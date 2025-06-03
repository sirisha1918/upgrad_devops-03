# Step 1: Build the Spring Boot application 
 # Use an official Maven image to build the application 
 FROM maven:3.9.9-eclipse-temurin-17 AS build 

# Set the working directory 
 WORKDIR /app 

# Copy the pom.xml and source code into the container 
 COPY pom.xml . 
 COPY src ./src 

# Run Maven to build the application (creates the .jar file) 
 RUN mvn clean package  

# Step 2: Prepare the runtime environment 
 # Use a slim OpenJDK image to run the application 
 FROM openjdk:17-jdk-slim 

# Set the working directory for the runtime container 
 WORKDIR /app 

# Copy the compiled jar file from the build stage 
 COPY --from=build /app/target/my-web-app-1.0-SNAPSHOT.jar app.jar 

# Expose the port the application will run on 
 EXPOSE 8081 

# Command to run the application 
 ENTRYPOINT ["java", "-jar", "app.jar"]
