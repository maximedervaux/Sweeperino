#!/bin/bash

source "$SCRIPT_DIR/utils/log.sh"
source "$SCRIPT_DIR/config.sh"

# Clean log files older than 30 days
clean_old_logs() {

    # Find log files in /var/log older than 30 days (non-recursive)
    local files
    files=$(find /var/log -maxdepth 1 -type f -mtime +30 2>/dev/null)

    # If no files found, show info message
    if [ -z "$files" ]; then
        yad --info --text="No log files older than 30 days were found."
        return
    fi

    # Format the list for YAD display
    local files_list
    files_list=$(echo "$files" | sed 's/^/- /')

    # Display confirmation dialog with list of files
    yad --width=600 --height=400 \
        --text="The following log files will be deleted:\n\n$files_list\n\nDo you want to proceed?" \
        --button=gtk-ok:0 --button=gtk-cancel:1

    # If user confirmed (exit code 0), proceed with deletion
    if [ $? -eq 0 ]; then
        log "INFO" "Starting deletion of old log files."

        local errors=0

        # Loop through each file and try to delete
        while IFS= read -r file; do
            if sudo rm -v "$file" >> "$LOG_FILE" 2>&1; then
                log "SUCCESS" "Deleted: $file"
            else
                log "ERROR" "Failed to delete: $file"
                ((errors++))
            fi
        done <<< "$files"

        # Show result message
        if [ "$errors" -eq 0 ]; then
            yad --info --text="All log files were successfully deleted."
        else
            yad --warning --text="Some files could not be deleted. Check the log file for details."
        fi

    # If user cancelled
    else
        yad --info --text="Deletion cancelled."
        log "INFO" "Log file deletion cancelled by the user."
    fi
}
