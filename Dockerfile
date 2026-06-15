# ── Stage 1: Build ──────────────────────────────────────────────
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Cache dependencies first
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and build WAR
COPY src ./src
RUN mvn clean package -DskipTests -B

# ── Stage 2: Run ────────────────────────────────────────────────
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy WAR and extract it so JSP files exist on the filesystem
# (Tomcat Jasper requires file-system access to compile JSPs — they cannot
#  be compiled from inside a zipped WAR archive)
COPY --from=build /app/target/*.war app.war
RUN jar -xf app.war && rm app.war

EXPOSE 8080

# Use Spring Boot's WarLauncher (embedded in the extracted WAR root)
ENTRYPOINT ["java", "org.springframework.boot.loader.WarLauncher"]
