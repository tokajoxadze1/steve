# Build stage
FROM eclipse-temurin:17-jdk AS builder

WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:resolve -q

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests -q && \
    mv target/steve-*.jar target/steve.jar

# Runtime stage
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy the built JAR from builder stage
COPY --from=builder /app/target/steve.jar .

# Expose port (Railway will override with $PORT)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:${PORT:-8080}/steve/manager/ || exit 1

# Start the application
CMD ["java", "-jar", "steve.jar"]
