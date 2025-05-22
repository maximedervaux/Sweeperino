#!/bin/bash

# -- Variables --
LOG_FILE="$HOME/monnettoyeur.log"
DATE_NOW=$(date '+%Y-%m-%d_%H-%M-%S')

# Détection distro basique (apt ou dnf)
if command -v apt &>/dev/null; then
    PKG_MGR="apt"
elif command -v dnf &>/dev/null; then
    PKG_MGR="dnf"
else
    PKG_MGR="unknown"
fi

# -- Fonctions --

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

nettoyer_paquets() {
    log "Nettoyage des paquets inutilisés avec $PKG_MGR"
    if [[ $PKG_MGR == "apt" ]]; then
       	sudo apt autoremove -y | tee -a "$LOG_FILE"
        sudo apt clean | tee -a "$LOG_FILE"
    elif [[ $PKG_MGR == "dnf" ]]; then
        sudo dnf autoremove -y | tee -a "$LOG_FILE"
        sudo dnf clean all | tee -a "$LOG_FILE"
    else
        log "Gestionnaire de paquets non supporté"
    fi
}

nettoyer_logs() {
    log "Nettoyage des logs vieux de plus de 30 jours"
    sudo find /var/log -type f -mtime +30 -exec rm -v {} \; | tee -a "$LOG_FILE"
}

trouver_doublons() {
    if ! command -v fdupes &>/dev/null; then
        log "fdupes non installé. Installation..."
        if [[ $PKG_MGR == "apt" ]]; then
            sudo apt install -y fdupes
        elif [[ $PKG_MGR == "dnf" ]]; then
            sudo dnf install -y fdupes
        else
            log "Impossible d’installer fdupes"
            return
        fi
    fi

    echo "Recherche de fichiers doublons dans votre dossier personnel..."
    fdupes -r -dN "$HOME"
}

nettoyer_cache() {
    log "Nettoyage des caches utilisateurs"
    rm -rf "$HOME/.cache/thumbnails"/*
    log "Caches thumbnails supprimés"
    # Nettoyage cache apt/dnf déjà fait dans nettoyage paquets
}

afficher_espace() {
    echo "Espace disque avant nettoyage :"
    df -h /
}

menu() {
    clear
    echo "===== Menu Nettoyeur Système ====="
    echo "1) Nettoyer paquets inutilisés"
    echo "2) Nettoyer logs anciens"
    echo "3) Trouver & supprimer fichiers doublons"
    echo "4) Nettoyer caches utilisateur"
    echo "5) Afficher espace disque"
    echo "6) Quitter"
    echo "=================================="
    read -rp "Choix : " choix
    case $choix in
        1) nettoyer_paquets ;;
        2) nettoyer_logs ;;
        3) trouver_doublons ;;
        4) nettoyer_cache ;;
        5) afficher_espace ;;
        6) echo "Bye !" ; exit 0 ;;
        *) echo "Choix invalide" ; sleep 1 ;;
    esac
}

# -- Script principal --

touch "$LOG_FILE"
log "=== Début du nettoyage système ==="

while true; do
    menu
    read -rp "Appuyez sur Entrée pour continuer..."
done

