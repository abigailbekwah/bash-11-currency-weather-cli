#!/usr/bin/env bash
# Print an error message to stderr and exit with a code (default: 1)
die() {
    local message="$1"
    local exit_code="${2:-1}"
    echo -e "[EEROR] $message" >&2
    exit "$exit_code"
}

# Safe curl wrapper with timeout and error handling
safe_curl() {
    local url="$1"
    local response
    local curl_exit
    
    response=$(curl -s --max-time 10 "$url")
    curl_exit=$?

    if [ $curl_exit -ne 0 ]; then
        die "Failed to connect to endpoint (curl exit code: $curl_exit)" 2 1
    fi
    
    if [ -z "$response" ]; then
        die :"Received empty response from server." 3
    fi

    echo "$response"
}
