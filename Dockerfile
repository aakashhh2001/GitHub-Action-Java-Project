FROM maven:3.9.5-eclipse-temurin-17

WORKDIR /app

COPY . .

# Run tests + build the jar
RUN mvn -B package

# Expose (optional)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "target/demo-app-1.0-SNAPSHOT.jar"]
