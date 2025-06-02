# Use the official Reposilite image.
# You can replace 'latest' with a specific version tag if preferred (e.g., 3.5.24)
FROM dzikoysk/reposilite:latest

# Environment variables for the initial admin user and password.
# These will be overridden by Railway's environment variable settings.
ENV REPOSILITE_INITIAL_ADMIN_USER="admin"
ENV REPOSILITE_INITIAL_ADMIN_PASSWORD="password"

# Copy the custom entrypoint script into the image
# The base image's WORKDIR is /app
COPY entrypoint.sh /app/entrypoint.sh
# Make the entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Set the custom entrypoint script to run when the container starts
ENTRYPOINT ["/app/entrypoint.sh"]

# Expose the default Reposilite port (already in base image, but good for clarity)
EXPOSE 8080

# Note: The VOLUME instruction has been removed as Railway handles volumes
# through its dashboard. You MUST configure a volume in Railway and mount
# it to /app/data for persistence.
