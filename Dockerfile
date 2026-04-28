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

# Compile Java sources
RUN mkdir -p /app/WEB-INF/classes && \
    javac -cp "/app/WEB-INF/lib/*" -d /app/WEB-INF/classes \
    $(find /app/src -name "*.java")

# Stage 2: Runtime with Tomcat
FROM tomcat:10.1-jdk17-temurin

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy compiled application
COPY --from=builder /app/WEB-INF /usr/local/tomcat/webapps/ROOT/WEB-INF
COPY --from=builder /app/src /usr/local/tomcat/webapps/ROOT/src

# Copy web content (JSPs, HTML, CSS, JS)
COPY *.jsp /usr/local/tomcat/webapps/ROOT/
COPY *.html /usr/local/tomcat/webapps/ROOT/ 2>/dev/null || true
COPY *.css /usr/local/tomcat/webapps/ROOT/ 2>/dev/null || true
COPY *.js /usr/local/tomcat/webapps/ROOT/ 2>/dev/null || true
COPY common /usr/local/tomcat/webapps/ROOT/common/ 2>/dev/null || true
COPY data /usr/local/tomcat/webapps/ROOT/data/ 2>/dev/null || true
COPY uploads /usr/local/tomcat/webapps/ROOT/uploads/ 2>/dev/null || true

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
