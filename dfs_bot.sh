#!/usr/bin/env bash
set -e

# Check if necessary environment variables are set
if [[ -z $UISP_DOMAIN || -z $UISP_API_TOKEN || -f "/run/secrets/uisp_api_token" || -z $DEVICE_ID || -z $TARGET_FREQ ]]; then
  echo "One or more variables are undefined."
  echo "The following must be set:"
  echo "- UISP_DOMAIN"
  echo "- UISP_API_TOKEN (will also check /run/secrets/uisp_api_token)"
  echo "- DEVICE_ID"
  echo "- TARGET_FREQ"
  exit 1
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
