#!/bin/sh
# Exit immediately if a command exits with a non-zero status.
set -e


combined_opts="${REPOSILITE_OPTS:-}"

# Check if BOTH user and password are provided and non-empty
if [ -n "${REPOSILITE_INITIAL_ADMIN_USER}" ] && [ -n "${REPOSILITE_INITIAL_ADMIN_PASSWORD}" ]; then
  INITIAL_ADMIN_TOKEN_ARG="--token ${REPOSILITE_INITIAL_ADMIN_USER}:${REPOSILITE_INITIAL_ADMIN_PASSWORD}"
  echo "Configuring initial temporary admin token for user '${REPOSILITE_INITIAL_ADMIN_USER}'."
  echo "IMPORTANT: This token is temporary. Create a persistent token via the Reposilite console/dashboard after first login."

  if [ -n "${combined_opts}" ]; then
    # Append the new token argument to existing options
    combined_opts="${combined_opts} ${INITIAL_ADMIN_TOKEN_ARG}"
  else
    # Set combined_opts to just the token argument
    combined_opts="${INITIAL_ADMIN_TOKEN_ARG}"
  fi
else
  echo "REPOSILITE_INITIAL_ADMIN_USER and/or REPOSILITE_INITIAL_ADMIN_PASSWORD not fully provided. Skipping temporary admin token creation."
  echo "If this is a fresh instance without existing users/tokens, you may need to configure them manually or provide these variables for initial setup."
fi

echo "Starting Reposilite..."
if [ -n "${combined_opts}" ]; then
  echo "Final application arguments: ${combined_opts}"
else
  echo "Final application arguments: (none)"
fi

exec java -jar /app/reposilite.jar ${combined_opts}
