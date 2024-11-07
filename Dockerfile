# Use an official Maven image to build the app
FROM maven:3.8.4-openjdk-11-slim AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml and other files needed for the build
COPY pom.xml .

# Download dependencies (for faster builds, we'll cache them if possible)
RUN mvn dependency:go-offline

# Copy the source code
COPY src ./src

# Build the app with the specified profile (default: local)
ARG BUILD_PROFILE=local
RUN mvn clean install -P${BUILD_PROFILE} -DskipTests

# Use a minimal JDK runtime image to run the application
FROM openjdk:11-jre-slim

# Set the working directory for the app
WORKDIR /app

# Copy the built JAR from the previous stage
COPY --from=build /app/target/myapp-1.0-SNAPSHOT.jar /app/myapp.jar

# Copy the filtered application.properties file from the build stage
COPY --from=build /app/src/main/resources/application.properties /app/application.properties

# Expose the port the app will run on
EXPOSE 8080

# Command to run the JAR file
ENTRYPOINT ["java", "-jar", "/app/myapp.jar"]
