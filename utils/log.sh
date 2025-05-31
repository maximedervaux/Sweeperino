#!/bin/bash

source "$SCRIPT_DIR/config.sh"

#Fonction de log générique
log() {
    # Définit le type de message (par défaut "INFO")
    local msg_type="${1:-INFO}"

    # Définit le contenu du message, ou un message vide si non fourni
    local message="${2:-}"

    # Affiche et enregistre le message dans le fichier de log
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$msg_type] $message" | tee -a "$LOG_FILE"
}