#!/bin/bash

source "$SCRIPT_DIR/utils/log.sh"


# Function to remove duplicate files
clean_duplicates() {
    if ! command -v fdupes >/dev/null 2>&1; then
        yad --error --text="The 'fdupes' package is not installed. Please install it to use this feature."
        return
    fi

    # Scan the home directory for duplicates
    fdupes -r "$HOME" > /tmp/duplicates.txt

    if [ ! -s /tmp/duplicates.txt ]; then
        yad --info --text="No duplicates files found in $HOME."
        return
    fi

    yad --text-info --filename=/tmp/doublons.txt --width=600 --height=400 --title="Duplicates files found"

    yad --question --text="Do you want to automatically delete the duplicates?\n(fdupes will keep one file per group.)"

    # Cleanup of duplicates files
    if [ $? -eq 0 ]; then
        if fdupes -rdN "$HOME" >> "$LOG_FILE" 2>&1; then
            yad --info --text="Cleanup complete. Duplicate files were deleted automatically."
            log "DELETION" "fdupes removed duplicate files in $HOME"
        else
            yad --error --text="An error occurred while deleting duplicate files."
            log "ERROR" "Automatic duplicate removal failed"
        fi
    else
        yad --info --text="Deletion cancelled."
        log "INFO" "Duplicate file deletion was cancelled by the user"
    fi

}
