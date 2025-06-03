# Use the official Reposilite image.
# You can replace 'latest' with a specific version tag if preferred (e.g., 3.5.24)
FROM dzikoysk/reposilite:latest

# Default environment variables. These will be overridden by Railway's settings.
# For initial admin user (optional, set both user and password to enable)
ENV REPOSILITE_INITIAL_ADMIN_USER=""
ENV REPOSILITE_INITIAL_ADMIN_PASSWORD=""

# For UI Customizations
ENV REPOSILITE_TITLE="Reposilite"
ENV REPOSILITE_DESCRIPTION="A lightweight, open source Maven repository manager"
ENV REPOSILITE_ACCENT_COLOR="#3f51b5"
 # Default Reposilite accent color

# For Other Reposilite Options
ENV REPOSILITE_DEBUG="false"
ENV REPOSILITE_DISABLE_SWAGGER="false" # Set to true to disable Swagger UI

# For additional raw CLI options and JVM options
ENV REPOSILITE_OPTS=""
ENV REPOSILITE_JVM_OPTS="-Xmx1g -Xms128m" # Default JVM options

# Copy the custom entrypoint script into the image
# The base image's WORKDIR is /app
COPY entrypoint.sh /app/entrypoint.sh
# Make the entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Set the custom entrypoint script to run when the container starts
ENTRYPOINT ["/app/entrypoint.sh"]

# Expose the default Reposilite port
EXPOSE 8080

# Note: Volume for /app/data is configured in railway.json and Railway's UI.
