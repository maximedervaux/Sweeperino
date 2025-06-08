#!/bin/bash

# Chemin du fichier de log
LOG_FILE="$HOME/sweeperino.log"

# Target directory to backup
SOURCE_DIR="$HOME/Documents"

# Backup directory
BACKUP_DIR="$HOME/backups"

# (to implement) Interval for automatic backups in minute
INTERVAL_MINUTES=30

# MAX number of backups to keep
MAX_BACKUPS=5

# --- CONFIG SORT ---
SOURCE_DIR_SORT="$(xdg-user-dir DOWNLOAD 2>/dev/null || echo "$HOME/Downloads")" 
USER_DESKTOP_DIR="$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")"
USER_DOCUMENTS_DIR="$(xdg-user-dir DOCUMENTS 2>/dev/null || echo "$HOME/Documents")"
USER_DOWNLOAD_DIR="$SOURCE_DIR" 
USER_MUSIC_DIR="$(xdg-user-dir MUSIC 2>/dev/null || echo "$HOME/Music")"
USER_PICTURES_DIR="$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")"
USER_VIDEOS_DIR="$(xdg-user-dir VIDEOS 2>/dev/null || echo "$HOME/Videos")"
DEFAULT_FOLDER_PATH="$USER_DOWNLOAD_DIR/Autres"
