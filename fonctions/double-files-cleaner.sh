#!/bin/bash

source "$SCRIPT_DIR/utils/log.sh"


# Fonction pour supprimer les fichiers doublons
nettoyer_doublons() {
    if ! command -v fdupes >/dev/null 2>&1; then
        yad --error --text="Le paquet 'fdupes' n'est pas installé. Veuillez l'installer pour utiliser cette fonction."
        return
    fi

    # Scanner dossier home
    fdupes -r "$HOME" > /tmp/doublons.txt

    if [ ! -s /tmp/doublons.txt ]; then
        yad --info --text="Aucun fichier doublon trouvé dans $HOME."
        return
    fi

    yad --text-info --filename=/tmp/doublons.txt --width=600 --height=400 --title="Fichiers doublons trouvés"

    yad --question --text="Voulez-vous lancer la suppression interactive des doublons ?"

    if [ $? -eq 0 ]; then
        # Suppression directe avec fdupes, sans terminal externe
        if fdupes -rdN "$HOME" >> "$LOG_FILE" 2>&1; then
            yad --info --text="Suppression terminée. Les doublons ont été supprimés automatiquement."
            log "SUPPRESSION" "fdupes a supprimé les doublons dans $HOME"
        else
            yad --error --text="Une erreur est survenue lors de la suppression des doublons."
            log "ERREUR" "Échec suppression automatique des doublons"
        fi
    else
        yad --info --text="Suppression annulée."
        log "INFO" "Suppression des doublons annulée par l'utilisateur"
    fi

}
