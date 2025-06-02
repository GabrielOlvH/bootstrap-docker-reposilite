#!/bin/sh
# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# These environment variables are expected to be set:
# REPOSILITE_INITIAL_ADMIN_USER: The username for the initial admin token.
# REPOSILITE_INITIAL_ADMIN_PASSWORD: The password for the initial admin token.
# REPOSILITE_OPTS (optional): Any other Reposilite options you want to pass.

# Construct the initial admin token argument for Reposilite
INITIAL_ADMIN_TOKEN_ARG="--token ${REPOSILITE_INITIAL_ADMIN_USER}:${REPOSILITE_INITIAL_ADMIN_PASSWORD}"

# Combine with any existing REPOSILITE_OPTS provided by the user
if [ -n "${REPOSILITE_OPTS}" ]; then
  # Append the initial admin token argument to existing options
  export REPOSILITE_OPTS="${REPOSILITE_OPTS} ${INITIAL_ADMIN_TOKEN_ARG}"
else
  # Set REPOSILITE_OPTS to just the initial admin token argument
  export REPOSILITE_OPTS="${INITIAL_ADMIN_TOKEN_ARG}"
fi

echo "Starting Reposilite..."
echo "REPOSILITE_OPTS: ${REPOSILITE_OPTS}"
echo "IMPORTANT: The initial token for user '${REPOSILITE_INITIAL_ADMIN_USER}' is temporary."
echo "It's recommended to create a persistent token via the Reposilite console/dashboard after the first login."
echo "This temporary token will be recreated with these credentials on every container start if these environment variables remain set."

# Execute the original Reposilite entrypoint/command
# The official Reposilite image has its entrypoint at /app/bin/reposilite
exec /app/bin/reposilite
