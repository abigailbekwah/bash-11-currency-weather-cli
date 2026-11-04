#!/usr/bin/env bash

#Let's read the arguments in their positions
AMOUNT="$1"
FROM_RAW="$2"
TO_RAW="$3"

if [[ -z "$AMOUNT" || -z "$FROM_RAW" || -z "$TO_RAW" ]]; then 
    echo "Usage: $0 AMOUNT FROM TO" >&2
    echo "Example: $0 250 usd xaf" >&2
    exit 1
fi
 
# 3. Validate currency codes: Must be exactly 3 uppercase letters
if ! [[ "$FROM" =~ ^[A-Z]{2}$ ]] || ! [[ "$TO" =~ ^[A-Z]{3}$ ]]; then
    echo "Error: Currency codes must be exactly 3 letters (e.g., USD, EUR, XAF)." >&2
    exit 2
fi

# 4. Validate amount: Must be a positive number (integers or decimals allowed)
if ! [[ "$AMOUNT" =~ ^[0-9]+(\.[0-9]+)?$ ]] || (( $(awk "BEGIN {print ($AMOUNT > 0)}") == 0 )); then
    echo "Error: Amount must be a positive number." >&2
    exit 2
fi

# 1. Fetch live exchange rates from the API
API_URL="https://open.er-api.com/v6/latest/${FROM}"
RESPONSE=$(curl -s "$API_URL")

# Check if curl failed or returned nothing
if [[ $? -ne 0 || -z "$RESPONSE" ]]; then
    echo "Error: Failed to connect to exchange rate API." >&2
    exit 1
fi

# 2. Check if the API returned a success status
API_RESULT=$(echo "$RESPONSE" | jq -r ".result // empty")
if [[ "$API_RESULT" != "success" ]]; then
    echo "Error: Invalid base currency '${FROM}' or API service error." >&2
    exit 2
fi
