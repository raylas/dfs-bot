#!/usr/bin/env bash
set -e

# Check if necessary environment variables are set
if [[ -z $UISP_DOMAIN || -z $DEVICE_ID || -z $TARGET_FREQ ]]; then
  echo "One or more variables are undefined."
  echo "The following must be set:"
  echo "- UISP_DOMAIN"
  echo "- DEVICE_ID"
  echo "- TARGET_FREQ"
  exit 1
fi

# Check if UISP API token exists
if [[ -z $UISP_API_TOKEN && ! -f "/run/secrets/uisp_api_token" ]]; then
  echo "The UISP API token cannot be found."
  echo "The following must be set:"
  echo "- UISP_API_TOKEN (will also check /run/secrets/uisp_api_token)"
  exit 1
elif [[ -z $UISP_API_TOKEN ]]; then
  export UISP_API_TOKEN=$(cat /run/secrets/uisp_api_token)
fi

# Define API routes
status_route="${UISP_DOMAIN}/nms/api/v2.1/devices/airmaxes/${DEVICE_ID}"
restart_route="${UISP_DOMAIN}/nms/api/v2.1/devices/${DEVICE_ID}/restart"

# Variable to store current device center frequency
device_freq=$(curl -s -X GET $status_route -H "accept: application/json" -H "x-auth-token: ${UISP_API_TOKEN}" | jq '.airmax.frequencyCenter')

# Let's see if any DFS events have occured
if [[ $device_freq != $TARGET_FREQ ]]; then
  echo "Frequency off target [${device_freq}]. Rebooting access point..."
  curl -s -X POST $restart_route -H "accept: application/json" -H "x-auth-token: ${UISP_API_TOKEN}"
else
  echo "Frequency on target [${TARGET_FREQ}]. No reboot needed."
fi
