#!/bin/bash

set -e

restore_backup() {

    # Load configuration
    source "$(dirname "$0")/config.sh"

    cd "$BACKUP_DIR" || exit 1

    echo "Save available in $BACKUP_DIR :"
    select ARCHIVE in backup_*.tar.gz.enc; do
        [ -n "$ARCHIVE" ] && break
    done

    # Check if archive exists (SALT_FILE)
    SALT_FILE="${ARCHIVE%.tar.gz.enc}.salt"
    if [ ! -f "$SALT_FILE" ]; then
        echo "Salt not found : $SALT_FILE"
        exit 1
    fi
    # Ask for password
    read -s -p "Password : " PASSWORD
    echo

    # Read salt from file
    SALT=$(cat "$SALT_FILE")
    KEY=$(echo -n "$PASSWORD" | argon2 "$SALT" -id -t 2 -m 16 -p 1 -l 32 -r | awk '{print $2}')

    # Decrypt the archive with OpenSSL
    DECRYPTED="/tmp/restore.tar.gz"
    openssl enc -d -aes-256-cbc -pbkdf2 -in "$ARCHIVE" -out "$DECRYPTED" -pass pass:"$KEY" || {
        echo "Error decrypting the archive. Please check your password and try again."
        exit 1
    }


    RESTORE_DIR="/tmp/restore_$RANDOM"
    mkdir -p "$RESTORE_DIR"
    tar -xzf "$DECRYPTED" -C "$RESTORE_DIR"

    echo "✅ Sauvegarde extraite dans : $RESTORE_DIR"
}