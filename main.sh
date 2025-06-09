#!/bin/bash

# PATHS AND SOURCES
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

source "$SCRIPT_DIR/functions/logs-cleaner.sh"
source "$SCRIPT_DIR/functions/packets-cleaner.sh"
source "$SCRIPT_DIR/functions/double-files-cleaner.sh"
source "$SCRIPT_DIR/functions/cache-cleaner.sh"
source "$SCRIPT_DIR/functions/storage.sh"
source "$SCRIPT_DIR/functions/directory-sort.sh"

# BACKUP AND RESTORE
source "$SCRIPT_DIR/functions/backup.sh"
source "$SCRIPT_DIR/functions/restore.sh"

#STYLE YAD
ICON="dialog-information"
TITLE="Sweeperino"
WIDTH=450
HEIGHT=400

# MAIN LOOP
while true; do
    CHOIX=$(yad \
        --width=$WIDTH \
        --height=$HEIGHT \
        --title="$TITLE" \
        --window-icon="$ICON" \
        --center \
        --list \
        --separator="|" \
        --column="ID:NUM" --column="Action" \
        1 "🧹 Clean orphan packages" \
        2 "🧾 Clean logs older than 30 days" \
        3 "📁 Delete duplicate files" \
        4 "🧽 Clean user cache" \
        5 "💾 Show disk space" \
        6 "📦 Create a backup" \
        7 "📂 Restore a backup" \
        8 "🧺 Sort a folder" \
        9 "🚪 Exit")

    case "${CHOIX%%|*}" in
        1) clean_packages ;;
        2) clean_old_logs ;;
        3) clean_duplicates ;;
        4) clean_user_cache ;;
        5) display_space ;;
        6) make_backup ;;
        7) restore_backup ;;
        8) directory_sort ;;
        9 | "" ) exit 0 ;;
        *) yad --info --text="Invalid choice" ;;
    esac
done
