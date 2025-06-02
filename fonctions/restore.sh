#!/bin/bash

set -e

restore_backup() {
    source "$(dirname "$0")/config.sh"

    cd "$BACKUP_DIR" || exit 1

    echo "Sauvegardes disponibles :"
    select ARCHIVE in backup_*.tar.gz.enc; do
        [ -n "$ARCHIVE" ] && break
    done

    SALT_FILE="${ARCHIVE%.tar.gz.enc}.salt"
    if [ ! -f "$SALT_FILE" ]; then
        echo "❌ Salt introuvable : $SALT_FILE"
        exit 1
    fi

    read -s -p "Mot de passe de restauration : " PASSWORD
    echo

    SALT=$(cat "$SALT_FILE")
    KEY=$(echo -n "$PASSWORD" | argon2 "$SALT" -id -t 2 -m 16 -p 1 -l 32 -r | awk '{print $2}')

    DECRYPTED="/tmp/restore.tar.gz"
    openssl enc -d -aes-256-cbc -pbkdf2 -in "$ARCHIVE" -out "$DECRYPTED" -pass pass:"$KEY" || {
        echo "❌ Échec du déchiffrement"
        exit 1
    }

    RESTORE_DIR="/tmp/restore_$RANDOM"
    mkdir -p "$RESTORE_DIR"
    tar -xzf "$DECRYPTED" -C "$RESTORE_DIR"

    echo "✅ Sauvegarde extraite dans : $RESTORE_DIR"
}