#!/bin/bash

source "$SCRIPT_DIR/config.sh"

# Generic log function
log() {
    # Set message type (default to "INFO")
    local msg_type="${1:-INFO}"

    # Set message content, or empty if not provided
    local message="${2:-}"

    # Display and save the message to the log file
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$msg_type] $message" | tee -a "$LOG_FILE"
}
