# ─────────────────────────────────────────────────────────────
#  GramSetu Dockerfile — Multi-stage build
#  Stage 1: Maven builds the WAR
#  Stage 2: Tomcat serves it
# ─────────────────────────────────────────────────────────────

# ── Stage 1: Build ───────────────────────────────────────────
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom first (caches dependency downloads)
COPY pom.xml .
RUN mvn dependency:go-offline -q

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests -q

# ── Stage 2: Run ─────────────────────────────────────────────
FROM tomcat:10.1-jdk17-temurin

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy our WAR as ROOT.war so it deploys at /  (not /GramSetu/)
COPY --from=builder /app/target/GramSetu.war /usr/local/tomcat/webapps/ROOT.war

# Create upload directory inside the container
# NOTE: For Render, mount a persistent disk at /uploads
RUN mkdir -p /uploads && chmod 755 /uploads

# Set upload directory env var (can be overridden in Render dashboard)
ENV UPLOAD_DIR=/uploads

# Tomcat listens on 8080 — Render routes $PORT to this
EXPOSE 8080

CMD ["catalina.sh", "run"]
