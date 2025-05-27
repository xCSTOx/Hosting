# Stage 1: Build dengan Maven
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /app

# Salin semua file dan build project
COPY . .
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