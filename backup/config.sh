#!/bin/bash

# === CONFIGURATION ===

# Dossier à sauvegarder
SOURCE_DIR="$HOME/Documents"

# Dossier où stocker les backups
BACKUP_DIR="$HOME/backups"

# Intervalle (en minutes) entre les backups
INTERVAL_MINUTES=30

# Nombre maximum de sauvegardes à conserver
MAX_BACKUPS=5

# Salt fixe pour Argon2 (tu peux le randomiser et le stocker aussi)
ARGON_SALT="12345678"
