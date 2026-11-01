FROM alpine:latest

# Install required tools (procps gives full top/free/ps implementations)
RUN apk update && apk add --no-cache bash procps coreutils

WORKDIR /app

# Copy the script into the image
COPY monitor.sh /app/monitor.sh
RUN chmod +x /app/monitor.sh

# Run the health script when container starts
CMD ["/bin/bash", "/app/monitor.sh"]