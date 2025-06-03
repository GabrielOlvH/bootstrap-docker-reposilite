#!/bin/sh
set -e

# Prepare arguments for Reposilite
REPOSILITE_ARGS=""

# --- UI Customization Options ---
if [ -n "${REPOSILITE_TITLE}" ]; then
  REPOSILITE_ARGS="${REPOSILITE_ARGS} --title=\"${REPOSILITE_TITLE}\""
fi
if [ -n "${REPOSILITE_DESCRIPTION}" ]; then
  REPOSILITE_ARGS="${REPOSILITE_ARGS} --description=\"${REPOSILITE_DESCRIPTION}\""
fi
if [ -n "${REPOSILITE_ACCENT_COLOR}" ]; then
  REPOSILITE_ARGS="${REPOSILITE_ARGS} --accent-color=\"${REPOSILITE_ACCENT_COLOR}\""
fi

# --- Other Reposilite Options ---
if [ "${REPOSILITE_DEBUG}" = "true" ]; then
  REPOSILITE_ARGS="${REPOSILITE_ARGS} --debug"
fi
if [ "${REPOSILITE_DISABLE_SWAGGER}" = "true" ]; then
  REPOSILITE_ARGS="${REPOSILITE_ARGS} --disable-swagger"
fi

# --- Append user-provided raw REPOSILITE_OPTS ---
# User is responsible for correct quoting within this string if needed.
if [ -n "${REPOSILITE_OPTS}" ]; then
  REPOSILITE_ARGS="${REPOSILITE_ARGS} ${REPOSILITE_OPTS}"
fi

# --- Initial Admin Token (Optional) ---
if [ -n "${REPOSILITE_INITIAL_ADMIN_USER}" ] && [ -n "${REPOSILITE_INITIAL_ADMIN_PASSWORD}" ]; then
  # Token format is name:secret, no spaces expected in user or pass here.
  # Using --token=value syntax
  REPOSILITE_ARGS="${REPOSILITE_ARGS} --token=${REPOSILITE_INITIAL_ADMIN_USER}:${REPOSILITE_INITIAL_ADMIN_PASSWORD}"
  echo "Configuring initial temporary admin token for user '${REPOSILITE_INITIAL_ADMIN_USER}'."
  echo "IMPORTANT: This token is temporary. Create a persistent token via the Reposilite console/dashboard after first login."
else
  echo "REPOSILITE_INITIAL_ADMIN_USER and/or REPOSILITE_INITIAL_ADMIN_PASSWORD not fully provided. Skipping temporary admin token creation."
  echo "If this is a fresh instance without existing users/tokens, you may need to configure them manually or provide these variables for initial setup."
fi

echo "Starting Reposilite..."
if [ -n "${REPOSILITE_ARGS}" ]; then
  # Trim leading/trailing whitespace from REPOSILITE_ARGS for cleaner logging
  REPOSILITE_ARGS_TRIMMED=$(echo "${REPOSILITE_ARGS}" | awk '{$1=$1};1')
  echo "Final application arguments: ${REPOSILITE_ARGS_TRIMMED}"
else
  echo "No application arguments."
fi

# --- JVM Options ---
# Use user-defined REPOSILITE_JVM_OPTS or fallback to a default.
FINAL_JVM_OPTS="${REPOSILITE_JVM_OPTS:--Xmx1g -Xms128m}"
echo "Using JVM options: ${FINAL_JVM_OPTS}"

# Execute Reposilite using java -jar
# Word splitting of FINAL_JVM_OPTS and REPOSILITE_ARGS is intended by the shell.
# shellcheck disable=SC2086
exec java ${FINAL_JVM_OPTS} -jar /app/reposilite.jar ${REPOSILITE_ARGS}
