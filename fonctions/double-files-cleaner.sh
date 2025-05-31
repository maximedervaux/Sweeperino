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
        yad --info --text="Lancement suppression interactive. Utilisez 'fdupes -rdN $HOME' en console."
        # Lancer suppression interactive dans un terminal
        gnome-terminal -- bash -c "fdupes -rdN $HOME; exec bash" 2>/dev/null 
        log "Suppression interactive doublons lancée"
    else
        yad --info --text="Opération annulée."
    fi
}
