#!/usr/bin/env bash

# 1. Determine the city: argument $1 if not METEO_CITY default to "Yaounde"
CITY="${1:-${METEO_CITY:-Yaounde}}"

# 2. Fetch JSON weather data from wttr.in (replacing spaces with '+' for URL compatibility)
URL="https://wttr.in/${CITY// /+}?format=j1"
RESPONSE=$(curl -s "$URL")

if [[ $? -ne 0 || -z "$RESPONSE" ]]; then
    echo "Error: Failed to connect to weather service." >&2
    exit 1
fi

# 3. Extract temperature, description, and humidity using jq
TEMP=$(echo "$RESPONSE" | jq -r '.current_condition[0].temp_C // empty')
DESC=$(echo "$RESPONSE" | jq -r '.current_condition[0].weatherDesc[0].value // empty')
HUMIDITY=$(echo "$RESPONSE" | jq -r '.current_condition[0].humidity // empty')

if [[ -z "$TEMP" || -z "$DESC" || -z "$HUMIDITY" ]]; then
    echo "Error: Could not parse weather data for '${CITY}'." >&2
    exit 2
fi

# 4. Display the weather report
echo "Weather in ${CITY}:"
echo "Temperature: ${TEMP}°C"
echo "Condition:   ${DESC}"
echo "Humidity:    ${HUMIDITY}%"