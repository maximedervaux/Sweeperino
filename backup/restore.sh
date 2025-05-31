#!/bin/bash

# Load configuration
source "$(dirname "$0")/config.sh"

# Choose the backup archive to restore
# (Merge with existing the interface)
cd "$BACKUP_DIR" || exit 1
echo "Archives disponibles :"
select ARCHIVE in backup_*.enc; do
    [ -n "$ARCHIVE" ] && break
done

# Password input
read -s -p "Mot de passe : " PASSWORD
echo
KEY=$(echo -n "$PASSWORD" | argon2 "$ARGON_SALT" -id -t 2 -m 16 -p 1 -l 32 -r | awk '{print $2}')

# Decrypt
DECRYPTED="/tmp/restore.tar.gz"
openssl enc -d -aes-256-cbc -pbkdf2 -in "$ARCHIVE" -out "$DECRYPTED" -pass pass:"$KEY" || {
    echo "Échec du déchiffrement."
    exit 1
}

# EXtract the archive and put it in /tmp/restore
mkdir -p /tmp/restore
tar -xzf "$DECRYPTED" -C /tmp/restore
echo "Sauvegarde extraite dans /tmp/restore"
