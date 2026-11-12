#!/usr/bin/env bash

#Source the shared helper library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

# 1. Determine the city: argument $1 if not METEO_CITY default to "Yaounde"
CITY="${1:-${METEO_CITY:-Yaounde}}"

# 2. Fetch JSON weather data from wttr.in (replacing spaces with '+' for URL compatibility)
URL="https://wttr.in/${CITY// /+}?format=j1"
RESPONSE=$(safe_curl "$URL")

# 3. Extract temperature, description, and humidity using jq
TEMP=$(echo "$RESPONSE" | jq -r '.current_condition[0].temp_C // empty')
DESC=$(echo "$RESPONSE" | jq -r '.current_condition[0].weatherDesc[0].value // empty')
HUMIDITY=$(echo "$RESPONSE" | jq -r '.current_condition[0].humidity // empty')

if [[ -z "$TEMP" || -z "$DESC" || -z "$HUMIDITY" ]]; then
    die "Could not parse weather data for '${CITY}'." 2
fi

# 4. Display the weather report
echo "Weather in ${CITY}:"
echo "Temperature: ${TEMP}°C"
echo "Condition:   ${DESC}"
echo "Humidity:    ${HUMIDITY}%"