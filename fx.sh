#!/usr/bin/env bash

# Source the shared helper library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

#Let's include validation 
if [ "$#" -lt 2 ]; then
    die "Usage: fx.sh <AMOUNT> <FROM_CURRENCY> <TO_CURRENCY>" 1
fi

#Let's read the arguments in their positions
AMOUNT="$1"
FROM_RAW="$2"
TO_RAW="$3"

if [[ -z "$AMOUNT" || -z "$FROM_RAW" || -z "$TO_RAW" ]]; then 
    die "Usage: $0 AMOUNT FROM TO (Example: $0 250 usd xaf)" 1
fi
 # FIX 1: Convert raw inputs to uppercase variables
    FROM="${FROM_RAW^^}"
    TO="${TO_RAW^^}"

# 3. Validate currency codes: Must be exactly 3 uppercase letters
if ! [[ "$FROM" =~ ^[A-Z]{3}$ ]] || ! [[ "$TO" =~ ^[A-Z]{3}$ ]]; then
    die "Currency codes must be exactly 3 letters (e.g., USD, EUR, XAF)." 2
fi

# 4. Validate amount: Must be a positive number (integers or decimals allowed)
if ! [[ "$AMOUNT" =~ ^[0-9]+(\.[0-9]+)?$ ]] || (( $(awk "BEGIN {print ($AMOUNT > 0)}") == 0 )); then
    die "Amount must be a positive number." 2
fi

# 1. Fetch live exchange rates from the API
API_URL="https://open.er-api.com/v6/latest/${FROM}"
RESPONSE=$(safe_curl "$API_URL")

# Check if API returned a success status
API_RESULT=$(echo "$RESPONSE" | jq -r ".result // empty")
if [[ "$API_RESULT" != "success" ]]; then
    die "Invalid base currency '${FROM}' or API service error." 2
fi

# FIX 2: Extract the target currency rate using jq
RATE=$(echo "$RESPONSE" | jq -r ".rates.${TO} // empty")
if [[ -z "$RATE" || "$RATE" == "null" ]]; then
    die "Target currency '${TO}' not found in exchange rates." 2
fi

# Calculate total with 2 decimal places using awk
TOTAL=$(awk "BEGIN {printf \"%.2f\", $AMOUNT * $RATE}")

# Display the after formatting result
echo "${AMOUNT} ${FROM} = ${TOTAL} ${TO}   (rate ${RATE})"