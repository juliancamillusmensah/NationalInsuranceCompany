# Multi-stage build for National Insurance Company Java Web App
# Compatible with Render, Fly.io, Railway, and any Docker-based hosting

# Stage 1: Build
FROM eclipse-temurin:17-jdk AS builder

WORKDIR /app

# Copy source code
COPY src /app/src
COPY WEB-INF/lib /app/WEB-INF/lib

# Download SQLite JDBC driver if not present
RUN if [ ! -f /app/WEB-INF/lib/sqlite-jdbc-*.jar ]; then \
    curl -L -o /app/WEB-INF/lib/sqlite-jdbc-3.45.1.0.jar \
    https://github.com/xerial/sqlite-jdbc/releases/download/3.45.1.0/sqlite-jdbc-3.45.1.0.jar; \
    fi

# Download SLF4J if not present
RUN if [ ! -f /app/WEB-INF/lib/slf4j-api-*.jar ]; then \
    curl -L -o /app/WEB-INF/lib/slf4j-api-2.0.9.jar \
    https://repo1.maven.org/maven2/org/slf4j/slf4j-api/2.0.9/slf4j-api-2.0.9.jar && \
    curl -L -o /app/WEB-INF/lib/slf4j-simple-2.0.9.jar \
    https://repo1.maven.org/maven2/org/slf4j/slf4j-simple/2.0.9/slf4j-simple-2.0.9.jar; \
    fi

# Download Jakarta Mail for SMTP support
RUN curl -L -o /app/WEB-INF/lib/jakarta.mail-2.0.1.jar \
    https://repo1.maven.org/maven2/com/sun/mail/jakarta.mail/2.0.1/jakarta.mail-2.0.1.jar && \
    curl -L -o /app/WEB-INF/lib/jakarta.activation-2.0.1.jar \
    https://repo1.maven.org/maven2/com/sun/activation/jakarta.activation/2.0.1/jakarta.activation-2.0.1.jar

# Download Jakarta Servlet API for compilation
RUN curl -L -o /app/WEB-INF/lib/jakarta.servlet-api-6.0.0.jar \
    https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/6.0.0/jakarta.servlet-api-6.0.0.jar

# Compile Java sources
RUN mkdir -p /app/WEB-INF/classes && \
    javac -cp "/app/WEB-INF/lib/*" -d /app/WEB-INF/classes \
    $(find /app/src -name "*.java")

# Copy all web files to builder stage
COPY . /app/web/

# Ensure directories exist in builder
RUN mkdir -p /app/web/common /app/web/data /app/web/uploads

# Stage 2: Runtime with Tomcat
FROM tomcat:10.1-jdk17-temurin

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy compiled application
COPY --from=builder /app/WEB-INF /usr/local/tomcat/webapps/ROOT/WEB-INF
COPY --from=builder /app/src /usr/local/tomcat/webapps/ROOT/src

# Copy all web content from builder
COPY --from=builder /app/web/*.jsp /usr/local/tomcat/webapps/ROOT/
COPY --from=builder /app/web/common /usr/local/tomcat/webapps/ROOT/common/
COPY --from=builder /app/web/data /usr/local/tomcat/webapps/ROOT/data/
COPY --from=builder /app/web/uploads /usr/local/tomcat/webapps/ROOT/uploads/
COPY --from=builder /app/web/WEB-INF/lib/*.jar /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

# Ensure directories exist and set permissions
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/common \
    /usr/local/tomcat/webapps/ROOT/data \
    /usr/local/tomcat/webapps/ROOT/uploads

# Create data directory for SQLite persistence (for volume mounting)
RUN mkdir -p /data && \
    ln -sf /data /usr/local/tomcat/webapps/ROOT/data && \
    chmod -R 777 /data

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]
