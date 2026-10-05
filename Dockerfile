FROM eclipse-temurin:17-jre
RUN useradd --system --uid 1001 app
USER 1001
WORKDIR /app
COPY target/app.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-XX:MaxRAMPercentage=60", "-jar", "app.jar"]