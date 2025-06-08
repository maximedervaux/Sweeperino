#!/bin/bash

source "$SCRIPT_DIR/utils/log.sh"
source "$SCRIPT_DIR/config.sh"

# Nettoyer les paquets inutiles selon la distribution
nettoyer_paquets() {
    local DISTRO=""
    
    # Détection du gestionnaire de paquets (APT ou DNF)
    if command -v apt >/dev/null 2>&1; then
        DISTRO="debian"
    elif command -v dnf >/dev/null 2>&1; then
        DISTRO="fedora"
    else
        yad --error --text="Distribution non prise en charge (APT ou DNF requis)."
        log "ERREUR" "Aucun gestionnaire APT/DNF détecté."
        return 1
    fi

    # Confirmation utilisateur
    yad --question \
        --text="Souhaitez-vous supprimer les paquets orphelins ?"

    # Vérification du code de retour de YAD
    if [ $? -ne 0 ]; then
        log "INFO" "Nettoyage des paquets annulé par l'utilisateur."
        yad --info --text="Nettoyage annulé."
        return
    fi

    # Exécution de la commande de nettoyage (selon la distribution)
    if [ "$DISTRO" = "debian" ]; then
        log "INFO" "Nettoyage (APT): autoremove + clean"
        sudo apt autoremove -y >> "$LOG_FILE" 2>&1
        sudo apt clean >> "$LOG_FILE" 2>&1
    elif [ "$DISTRO" = "fedora" ]; then
        log "INFO" "Nettoyage (DNF): autoremove + clean"
        sudo dnf autoremove -y >> "$LOG_FILE" 2>&1
        sudo dnf clean all >> "$LOG_FILE" 2>&1
    fi

    # Vérification de la réussite de la commande
    if [ $? -eq 0 ]; then
        log "SUCCÈS" "Nettoyage des paquets terminé avec succès."
        yad --info --text="Nettoyage terminé avec succès."
    else
        log "ERREUR" "Une erreur est survenue pendant le nettoyage."
        yad --error --text="Une erreur est survenue pendant le nettoyage."
    fi
}
