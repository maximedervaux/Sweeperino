#!/bin/bash

#CHEMINS ET CHARGEMENTS
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/fonctions/logs.sh"
source "$SCRIPT_DIR/fonctions/doublons.sh"
source "$SCRIPT_DIR/fonctions/cache.sh"
source "$SCRIPT_DIR/fonctions/espace.sh"
source "$SCRIPT_DIR/fonctions/config.sh"

#STYLE YAD
ICON="dialog-information"
TITLE="Mon Nettoyeur Linux"
WIDTH=450
HEIGHT=400

#BOUCLE DU MENU PRINCIPAL
while true; do
    CHOIX=$(yad \
        --width=$WIDTH \
        --height=$HEIGHT \
        --title="$TITLE" \
        --window-icon="$ICON" \
        --center \
        --list \
        --separator="|" \
        --column="ID:NUM" --column="Action" \
        1 "🧹 Nettoyer paquets orphelins" \
        2 "🧾 Nettoyer logs vieux de 30 jours" \
        3 "📁 Supprimer fichiers doublons" \
        4 "🧽 Nettoyer le cache utilisateur" \
        5 "💾 Afficher espace disque" \
        6 "⚙️ Configurer le chemin du fichier log" \
        7 "🚪 Quitter")

    case "${CHOIX%%|*}" in
        1) nettoyer_paquets ;;
        2) nettoyer_logs ;;
        3) nettoyer_doublons ;;
        4) nettoyer_cache ;;
        5) afficher_espace ;;
        6) configurer_log_file ;;
        7 | "" ) exit 0 ;;
        *) yad --info --text="Choix invalide" ;;
    esac
done
