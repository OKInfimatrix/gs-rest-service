# Stage 1: Build the application using a Maven image
FROM maven:3.6.3-openjdk-17 AS build

# Set the working directory inside the build container
WORKDIR /app

# Copy the pom.xml file first to leverage Docker cache
COPY pom.xml .

# Download dependencies (this step will be cached if pom.xml doesn't change)
RUN mvn dependency:go-offline

# Copy the rest of your application source code
COPY src ./src

# Build the application
# Assuming your Spring Boot application creates a JAR in the 'target' directory
# and the JAR name is 'gs-rest-service-0.1.0.jar' (adjust if yours is different)
RUN mvn clean install -DskipTests

# Stage 2: Create the final, smaller production image
FROM openjdk:17-jdk-slim

# Set the working directory inside the production container
WORKDIR /app

# Copy the built JAR from the 'build' stage
COPY --from=build /app/target/rest-service-complete-0.0.1-SNAPSHOT.jar /app/app.jar

# Expose the port your Spring Boot application runs on (default is 8080)
EXPOSE 8080

# Command to run the application when the container starts
CMD ["java", "-jar", "app.jar"]
