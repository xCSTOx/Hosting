# Stage 1: Build dengan Maven
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /app

# Salin Maven wrapper files dengan permission yang tepat
COPY mvnw .
COPY .mvn .mvn
RUN chmod +x ./mvnw

# Salin pom.xml dan download dependencies
COPY pom.xml .
RUN ./mvnw dependency:go-offline -B

# Salin source code dan build
COPY src ./src
RUN ./mvnw package -DskipTests

# Stage 2: Jalankan aplikasi dari JAR
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Salin JAR dari hasil build stage sebelumnya
COPY --from=build /app/target/*.jar app.jar

# Railway biasanya pakai PORT env variabel
EXPOSE 8080
ENV PORT=8080

# Jalankan aplikasi
ENTRYPOINT ["java", "-jar", "app.jar"]