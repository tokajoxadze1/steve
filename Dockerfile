# Build stage
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:resolve -q

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests -q

# Runtime stage
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy the built WAR from builder stage
COPY --from=builder /app/target/steve.war .

# Expose port (Railway will override with $PORT)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:${PORT:-8080}/steve/manager/ || exit 1

# Start the application
CMD ["java", "-jar", "steve.war"]
