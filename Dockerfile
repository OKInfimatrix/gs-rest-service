FROM maven:3.6.3-openjdk-17 AS build

WORKDIR /app

# Copy the pom.xml file first to leverage Docker cache
COPY pom.xml .

# Download dependencies (this step will be cached if pom.xml doesn't change)
RUN mvn dependency:go-offline

COPY src ./src

RUN mvn clean install -DskipTests

FROM openjdk:17-jdk-slim

WORKDIR /app

COPY --from=build /app/target/rest-service-complete-0.0.1-SNAPSHOT.jar /app/app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
