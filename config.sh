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