#!/bin/bash

set -e

# Function make_backup
make_backup() {

    # Load configuration
    source "$(dirname "$0")/config.sh"

    # Check if the source directory exists
    if [ ! -d "$SOURCE_DIR" ]; then
        echo "Src folder not found: $SOURCE_DIR"
        exit 1
    fi

    # Create the backup directory if it does not exist
    mkdir -p "$BACKUP_DIR" || {
        echo " Impossible to create folder : $BACKUP_DIR"
        exit 1
    }

    # Password input
    read -s -p "Mot de passe pour le chiffrement : " PASSWORD
    echo

    # Create the backup archive (time-stamped / which directory)
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    ARCHIVE_NAME="backup_${TIMESTAMP}.tar.gz"
    ARCHIVE_PATH="/tmp/$ARCHIVE_NAME"

    tar -czf "$ARCHIVE_PATH" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

    # Generate random salt and derive key
    SALT=$(openssl rand -hex 8)
    SALT_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.salt"

    # 3. Derive key from password and salt using Argon
    KEY=$(echo -n "$PASSWORD" | argon2 "$SALT" -id -t 2 -m 16 -p 1 -l 32 -r | awk '{print $2}')

    # ENCRYPTION of the archive
    ENCRYPTED_FILE="backup_${TIMESTAMP}.tar.gz.enc"
    ENCRYPTED_PATH="${BACKUP_DIR}/${ENCRYPTED_FILE}"

    openssl enc -aes-256-cbc -pbkdf2 -salt -in "$ARCHIVE_PATH" -out "$ENCRYPTED_PATH" -pass pass:"$KEY"
    rm -f "$ARCHIVE_PATH"

    echo "$SALT" > "$SALT_FILE"

    # Cleanup: remove old backups
    cd "$BACKUP_DIR" || exit 1
    ls -1tr backup_*.tar.gz.enc | head -n -$MAX_BACKUPS | while read -r OLD_BACKUP; do
        rm -f "$OLD_BACKUP"
        rm -f "${OLD_BACKUP%.tar.gz.enc}.salt"
    done

    echo "Save completed: $ENCRYPTED_PATH"
}