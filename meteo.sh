#!/usr/bin/env bash

# Load shared utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
# Check required dependencies
if ! command -v curl >/dev/null 2>&1; then
    die "Error: curl is required but not installed." 2
fi

if ! command -v jq >/dev/null 2>&1; then
    die "Error: jq is required but not installed." 2
fi
# Determine the city from the command-line argument or environment variable
if [[ -n "${1:-}" ]]; then
    CITY="$*"
else
    CITY="${METEO_CITY:-Yaounde}"
fi
# Build the weather API URL using the requested city
URL="https://wttr.in/${CITY// /+}?format=j1"

# Fetch weather data and capture the HTTP status separately
HTTP_RESPONSE=$(curl -sS --max-time 10 -w $'\n%{http_code}' "$URL")
CURL_EXIT=$?

# Handle network or connection failures
if [[ "$CURL_EXIT" -ne 0 ]]; then
    die "Failed to connect to weather service (curl exit code: $CURL_EXIT)" 1
fi

# Separate the response body from the HTTP status
HTTP_STATUS="${HTTP_RESPONSE##*$'\n'}"
RESPONSE="${HTTP_RESPONSE%$'\n'*}"

# Detect an unknown city before handling other HTTP errors
if echo "$RESPONSE" | grep -Eiq 'location not found|unknown location|city not found'; then
    die "City not found: ${CITY}" 2
fi

# Handle other unsuccessful HTTP responses
if (( HTTP_STATUS >= 400 )); then
    die "Weather service returned HTTP error ${HTTP_STATUS}." 1
fi

# Validate API response JSON
if ! echo "$RESPONSE" | jq empty 2>/dev/null; then
    die "Invalid JSON response received from weather API." 3
fi

if ! echo "$RESPONSE" | jq -e '.current_condition[0]' >/dev/null 2>&1; then
    die "Weather information is missing from the API response." 3
fi

# Extract temperature, weather description, and humidity from the API response
TEMP_C=$(echo "$RESPONSE" | jq -r '.current_condition[0].temp_C // empty')
DESCRIPTION=$(echo "$RESPONSE" | jq -r '.current_condition[0].weatherDesc[0].value // empty | gsub("^\\s+|\\s+$"; "")')
HUMIDITY=$(echo "$RESPONSE" | jq -r '.current_condition[0].humidity // empty')

if [[ -z "$TEMP_C" || -z "$DESCRIPTION" || -z "$HUMIDITY" ]]; then
    die "Could not retrieve weather data for '${CITY}'. Please check the city name or network connection." 2
fi

# Display the weather report in a single line
printf "%s: %s°C, %s, humidity %s%%\n" \
    "$CITY" "$TEMP_C" "$DESCRIPTION" "$HUMIDITY"