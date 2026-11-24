#!/usr/bin/env bash

# Source the shared helper library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
# Check required dependencies
if ! command -v jq >/dev/null 2>&1; then
    die "Error: jq is required but not installed." 2
fi
if ! command -v awk >/dev/null 2>&1; then
    die "Error: awk is required but not installed." 2
fi

# Validate the number of command-line arguments

if [ "$#" -ne 3 ]; then
    die "Usage: $0 <AMOUNT> <FROM_CURRENCY> <TO_CURRENCY>" 2
fi
# Assign command-line arguments to variables
AMOUNT="$1"
FROM_RAW="$2"
TO_RAW="$3"

if [[ -z "$AMOUNT" || -z "$FROM_RAW" || -z "$TO_RAW" ]]; then 
    die "Usage: $0 <AMOUNT> <FROM_CURRENCY> <TO_CURRENCY>" 2
fi
# Normalize currency codes to uppercase
    FROM="${FROM_RAW^^}"
    TO="${TO_RAW^^}"

# Validate that both currency codes contain exactly three uppercase letters
if ! [[ "$FROM" =~ ^[A-Z]{3}$ ]] || ! [[ "$TO" =~ ^[A-Z]{3}$ ]]; then
    die "Currency codes must be exactly 3 letters (e.g., USD, EUR, XAF)." 2
fi

# Validate that the amount is a positive integer or decimal
if ! [[ "$AMOUNT" =~ ^[0-9]+(\.[0-9]+)?$ ]] || (( $(awk "BEGIN {print ($AMOUNT > 0)}") == 0 )); then
    die "Amount must be a positive number." 2
fi

# Fetch live exchange rates using the base currency
API_URL="https://open.er-api.com/v6/latest/${FROM}"

if ! RESPONSE=$(safe_curl "$API_URL"); then
    exit 1
fi

# Validate that the API response contains valid JSON
if ! echo "$RESPONSE" | jq empty 2>/dev/null; then
    die "Invalid JSON response received from API." 3
fi


# Check if API returned a success status
API_RESULT=$(echo "$RESPONSE" | jq -r ".result // empty")
if [[ "$API_RESULT" != "success" ]]; then
    die "Invalid base currency '${FROM}' or API service error." 2
fi

# Validate that the target currency rate exists and is a positive number
if ! echo "$RESPONSE" | jq -e --arg currency "$TO" \
    '.rates[$currency] | (type == "number" and . > 0)' >/dev/null 2>&1; then
    die "Invalid or missing exchange rate for '${TO}'." 2
fi

# Extract the validated exchange rate
RATE=$(echo "$RESPONSE" | jq -r --arg currency "$TO" '.rates[$currency]')

# Calculate total with 2 decimal places using awk
TOTAL=$(awk "BEGIN {printf \"%.2f\", $AMOUNT * $RATE}")

# Display the converted amount and exchange rate result
echo "${AMOUNT} ${FROM} = ${TOTAL} ${TO}   (rate ${RATE})"