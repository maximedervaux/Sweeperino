#!/bin/bash

# === Chargement de la configuration ===
source "$(dirname "$0")/config.sh"

# === Mot de passe utilisateur ===
read -s -p "Mot de passe pour le chiffrement : " PASSWORD
echo

# === Dérivation de la clé avec Argon2 ===
KEY=$(echo -n "$PASSWORD" | argon2 "$ARGON_SALT" -id -t 2 -m 16 -p 1 -l 32 -r | awk '{print $2}')

# === Création de l'archive ===
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="backup_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="/tmp/$ARCHIVE_NAME"

tar -czf "$ARCHIVE_PATH" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

# === Chiffrement de l'archive ===
ENCRYPTED_PATH="${ARCHIVE_PATH}.enc"
openssl enc -aes-256-cbc -pbkdf2 -salt -in "$ARCHIVE_PATH" -out "$ENCRYPTED_PATH" -pass pass:"$KEY"
rm -f "$ARCHIVE_PATH"

# === Déplacement de l'archive chiffrée ===
mkdir -p "$BACKUP_DIR"
mv "$ENCRYPTED_PATH" "$BACKUP_DIR"

# === Rotation des anciennes sauvegardes ===
cd "$BACKUP_DIR" || exit 1
ls -1tr backup_*.enc | head -n -$MAX_BACKUPS | xargs -r rm -f
