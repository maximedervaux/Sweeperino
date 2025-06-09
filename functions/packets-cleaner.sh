#!/bin/bash

source "$SCRIPT_DIR/utils/log.sh"
source "$SCRIPT_DIR/config.sh"

# Clean unnecessary packages depending on the distribution
clean_packages() {
    local DISTRO=""

    # Detect package manager (APT or DNF)
    if command -v apt >/dev/null 2>&1; then
        DISTRO="debian"
    elif command -v dnf >/dev/null 2>&1; then
        DISTRO="fedora"
    else
        yad --error --text="Unsupported distribution (APT or DNF required)."
        log "ERROR" "No APT or DNF package manager detected."
        return 1
    fi

    # User confirmation
    yad --question \
        --text="Do you want to remove orphaned or unused packages?"

    # Check user response
    if [ $? -ne 0 ]; then
        log "INFO" "Package cleanup cancelled by the user."
        yad --info --text="Cleanup cancelled."
        return
    fi

    # Run the appropriate cleanup command depending on the distribution
    if [ "$DISTRO" = "debian" ]; then
        log "INFO" "Cleanup (APT): autoremove + clean"
        sudo apt autoremove -y >> "$LOG_FILE" 2>&1
        sudo apt clean >> "$LOG_FILE" 2>&1
    elif [ "$DISTRO" = "fedora" ]; then
        log "INFO" "Cleanup (DNF): autoremove + clean"
        sudo dnf autoremove -y >> "$LOG_FILE" 2>&1
        sudo dnf clean all >> "$LOG_FILE" 2>&1
    fi

    # Check if the commands were successful
    if [ $? -eq 0 ]; then
        log "SUCCESS" "Package cleanup completed successfully."
        yad --info --text="Cleanup completed successfully."
    else
        log "ERROR" "An error occurred during package cleanup."
        yad --error --text="An error occurred during cleanup."
    fi
}

