#!/bin/sh
# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# These environment variables are expected to be set in Railway:
# REPOSILITE_INITIAL_ADMIN_USER (optional): The username for the initial admin token.
# REPOSILITE_INITIAL_ADMIN_PASSWORD (optional): The password for the initial admin token.
# REPOSILITE_OPTS (optional): Any other Reposilite options you want to pass.

# Initialize current_opts with any pre-existing REPOSILITE_OPTS
# Uses parameter expansion: if REPOSILITE_OPTS is unset or null, default to empty string.
current_opts="${REPOSILITE_OPTS:-}"

# Check if BOTH user and password are provided and non-empty
if [ -n "${REPOSILITE_INITIAL_ADMIN_USER}" ] && [ -n "${REPOSILITE_INITIAL_ADMIN_PASSWORD}" ]; then
  INITIAL_ADMIN_TOKEN_ARG="--token ${REPOSILITE_INITIAL_ADMIN_USER}:${REPOSILITE_INITIAL_ADMIN_PASSWORD}"
  echo "Configuring initial temporary admin token for user '${REPOSILITE_INITIAL_ADMIN_USER}'."
  echo "IMPORTANT: This token is temporary. Create a persistent token via the Reposilite console/dashboard after first login."

  if [ -n "${current_opts}" ]; then
    # Append the new token argument to existing options
    export REPOSILITE_OPTS="${current_opts} ${INITIAL_ADMIN_TOKEN_ARG}"
  else
    # Set REPOSILITE_OPTS to just the token argument
    export REPOSILITE_OPTS="${INITIAL_ADMIN_TOKEN_ARG}"
  fi
else
  echo "REPOSILITE_INITIAL_ADMIN_USER and/or REPOSILITE_INITIAL_ADMIN_PASSWORD not fully provided. Skipping temporary admin token creation."
  echo "If this is a fresh instance without existing users/tokens, you may need to configure them manually or provide these variables for initial setup."
  # If token creation is skipped, REPOSILITE_OPTS remains as current_opts (which could be empty or user-defined)
  export REPOSILITE_OPTS="${current_opts}"
fi

echo "Starting Reposilite..."
if [ -n "${REPOSILITE_OPTS}" ]; then
  echo "Final REPOSILITE_OPTS: ${REPOSILITE_OPTS}"
else
  # Explicitly state if no options are being passed
  echo "Final REPOSILITE_OPTS: (not set/empty)"
fi

# Execute the original Reposilite entrypoint/command
# Corrected path to the Reposilite executable
exec /app/reposilite
