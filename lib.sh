#!/usr/bin/env bash
# Print an error message to stderr and exit with a code (default: 1)
die() {
    echo "Error: $1" >&2
    exit "${2:-1}"
}

# Safe curl wrapper with timeout and error handling
safe_curl() {
    local url="$1"
    local response
    
    response=$(curl -fsS --max-time 10 "$url")
    if [[ $? -ne 0 || -z "$response" ]]; then
        die "Failed to connect to remote service." 1
    fi
    
    echo "$response"
}
