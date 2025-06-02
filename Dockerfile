# Use the official Reposilite image.
# You can replace 'latest' with a specific version tag if preferred (e.g., 3.5.24)
FROM dzikoysk/reposilite:latest

# Environment variables for the initial admin user and password.
# These values are defaults and SHOULD BE OVERRIDDEN in your Railway deployment settings
# for security.
ENV REPOSILITE_INITIAL_ADMIN_USER="admin"
ENV REPOSILITE_INITIAL_ADMIN_PASSWORD="password"

# Copy the custom entrypoint script into the image
# The base image's WORKDIR is /app
COPY entrypoint.sh /app/entrypoint.sh
# Make the entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Set the custom entrypoint script to run when the container starts
ENTRYPOINT ["/app/entrypoint.sh"]

# Expose the default Reposilite port (this is often already done by the base image,
# but it's good practice to declare it)
EXPOSE 8080

# Define the data volume for Reposilite data persistence (also often in base image)
VOLUME /app/data
