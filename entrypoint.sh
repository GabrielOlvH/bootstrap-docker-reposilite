#!/bin/sh
set -e

# Base arguments for Reposilite - ALWAYS set working directory
REPOSILITE_ARGS="-wd=/app/data" # Reposilite data is in the mounted volume

# --- Debug Option ---
if [ "${REPOSILITE_DEBUG}" = "true" ]; then
  REPOSILITE_ARGS="${REPOSILITE_ARGS} -d" # -d is the debug flag
  echo "Debug mode enabled."
fi

# --- Initial Admin Token (Optional) ---
if [ -n "${REPOSILITE_INITIAL_ADMIN_USER}" ] && [ -n "${REPOSILITE_INITIAL_ADMIN_PASSWORD}" ]; then
  # Token format is name:secret. -t is the token flag.
  REPOSILITE_ARGS="${REPOSILITE_ARGS} -t=${REPOSILITE_INITIAL_ADMIN_USER}:${REPOSILITE_INITIAL_ADMIN_PASSWORD}"
  echo "Configuring initial temporary admin token for user '${REPOSILITE_INITIAL_ADMIN_USER}'."
  echo "IMPORTANT: This token is temporary. Create a persistent token via the Reposilite console/dashboard after first login."
else
  echo "REPOSILITE_INITIAL_ADMIN_USER and/or REPOSILITE_INITIAL_ADMIN_PASSWORD not fully provided. Skipping temporary admin token creation."
fi

# --- Append user-provided raw REPOSILITE_OPTS ---
# User is responsible for correct quoting and validity of these options.
if [ -n "${REPOSILITE_OPTS}" ]; then
  REPOSILITE_ARGS="${REPOSILITE_ARGS} ${REPOSILITE_OPTS}"
fi

echo "Starting Reposilite..."
# Trim leading/trailing whitespace from REPOSILITE_ARGS for cleaner logging
REPOSILITE_ARGS_TRIMMED=$(echo "${REPOSILITE_ARGS}" | awk '{$1=$1};1')
echo "Final application arguments: ${REPOSILITE_ARGS_TRIMMED}"


# --- JVM Options ---
# Use user-defined REPOSILITE_JVM_OPTS or fallback to a default.
FINAL_JVM_OPTS="${REPOSILITE_JVM_OPTS:--Xmx1g -Xms128m}"
echo "Using JVM options: ${FINAL_JVM_OPTS}"

# Execute Reposilite using java -jar
# Word splitting of FINAL_JVM_OPTS and REPOSILITE_ARGS is intended by the shell.
# shellcheck disable=SC2086
exec java ${FINAL_JVM_OPTS} -jar /app/reposilite.jar ${REPOSILITE_ARGS}
