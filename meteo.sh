#!/usr/bin/env bash

#Source the shared helper library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
# Check required dependencies
if ! command -v curl >/dev/null 2>&1; then
    die "Error: curl is required but not installed." 2
fi

if ! command -v jq >/dev/null 2>&1; then
    die "Error: jq is required but not installed." 2
fi

# 1. Determine the city: argument $1 if not METEO_CITY default to "Yaounde"
if [[ -n "${1:-}" ]]; then
    CITY="$*"
else
    CITY="${METEO_CITY:-Yaounde}"
fi

# 2. Fetch JSON weather data from wttr.in (replacing spaces with '+' for URL compatibility)
URL="https://wttr.in/${CITY// /+}?format=j1"
RESPONSE=$(safe_curl "$URL")
# Validate API response JSON
if ! echo "$RESPONSE" | jq empty 2>/dev/null; then
    die "Invalid JSON response received from weather API." 3
fi

if ! echo "$RESPONSE" | jq -e '.current_condition[0]' >/dev/null 2>&1; then
    die "Weather information is missing from the API response." 3
fi

# 3. Extract temperature, description, and humidity using jq
TEMP_C=$(echo "$RESPONSE" | jq -r '.current_condition[0].temp_C // empty')
DESCRIPTION=$(echo "$RESPONSE" | jq -r '.current_condition[0].weatherDesc[0].value // empty')
HUMIDITY=$(echo "$RESPONSE" | jq -r '.current_condition[0].humidity // empty')

if [[ -z "$TEMP_C" || -z "$DESCRIPTION" || -z "$HUMIDITY" ]]; then
    die "Could not retrieve weather data for '${CITY}'. Please check the city name or network connection." 2
fi

# 4. Display the weather report
echo "========================================"
echo "Weather report for ${CITY}:"
echo "========================================"
echo "Temperature  :${TEMP_C}°C"
echo "Condition    :${DESCRIPTION}"
echo "Humidity     :${HUMIDITY}%"
echo "========================================"