FROM joehe/ocpp-steve-server:3.6.06
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
