# ── Stage 1: Build + Extract WAR ────────────────────────────────
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Cache dependencies first
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Build WAR
COPY src ./src
RUN mvn clean package -DskipTests -B

# Extract WAR in the build stage (Maven image has full JDK with 'jar' tool)
# JSP files must be on the real filesystem - Jasper cannot compile from inside a ZIP
RUN mkdir -p /app/exploded && \
    cd /app/exploded && \
    jar xf /app/target/*.war && \
    echo "Extracted WAR contents:" && \
    ls -la /app/exploded/WEB-INF/

# ── Stage 2: Run from exploded WAR ──────────────────────────────
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy the fully extracted WAR directory (not the zip file)
COPY --from=build /app/exploded .

EXPOSE 8080

# WarLauncher is at org/springframework/boot/loader/WarLauncher.class (WAR root)
# -cp . adds the current working dir (/app) to the classpath so JVM can find it
ENTRYPOINT ["java", "-cp", ".", "org.springframework.boot.loader.WarLauncher"]
