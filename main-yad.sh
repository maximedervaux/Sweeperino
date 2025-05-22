#!/bin/bash

LOG_FILE="$HOME/monnettoyeur.log"
DATE_NOW=$(date '+%Y-%m-%d_%H-%M-%S')

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Nettoyage paquets orphelins
nettoyer_paquets() {
    if command -v dnf &>/dev/null; then
        CMD="sudo dnf autoremove -y"
    elif command -v apt &>/dev/null; then
        CMD="sudo apt autoremove -y"
    else
        yad --error --text="Gestionnaire de paquets non supporté."
        return
    fi

    yad --question --text="Voulez-vous lancer la suppression des paquets orphelins ?"
    if [ $? -eq 0 ]; then
        log "Lancement nettoyage paquets orphelins"
        $CMD | tee -a "$LOG_FILE"
        yad --info --text="Nettoyage paquets terminé."
    else
        yad --info --text="Opération annulée."
    fi
}

# Nettoyer logs vieux de 30 jours
nettoyer_logs() {
    FILES=$(find /var/log -type f -mtime +30 2>/dev/null)

    if [ -z "$FILES" ]; then
        yad --info --text="Aucun fichier log vieux de plus de 30 jours trouvé."
        return
    fi

    FILES_LIST=$(echo "$FILES" | sed 's/^/- /')

    yad --width=600 --height=400 --text="Fichiers logs à supprimer :\n\n$FILES_LIST\n\nConfirmez la suppression ?" \
        --button=gtk-ok:0 --button=gtk-cancel:1

    if [ $? -eq 0 ]; then
        log "Suppression logs anciens"
        while IFS= read -r file; do
            sudo rm -v "$file" | tee -a "$LOG_FILE"
        done <<< "$FILES"
        yad --info --text="Suppression terminée."
    else
        yad --info --text="Suppression annulée."
    fi
}

# Trouver et supprimer doublons via fdupes
nettoyer_doublons() {
    if ! command -v fdupes &>/dev/null; then
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
        gnome-terminal -- bash -c "fdupes -rdN $HOME; exec bash" 2>/dev/null || \
        xterm -e "fdupes -rdN $HOME; bash"
        log "Suppression interactive doublons lancée"
    else
        yad --info --text="Opération annulée."
    fi
}

# Nettoyer cache utilisateur
nettoyer_cache() {
    CACHE_DIR="$HOME/.cache"
    if [ ! -d "$CACHE_DIR" ]; then
        yad --info --text="Aucun cache utilisateur trouvé."
        return
    fi

    SIZE=$(du -sh "$CACHE_DIR" | cut -f1)
    yad --question --text="Le cache utilisateur occupe $SIZE. Voulez-vous le nettoyer ?"

    if [ $? -eq 0 ]; then
        log "Nettoyage cache utilisateur"
        rm -rf "$CACHE_DIR"/* 2>/dev/null
        yad --info --text="Cache nettoyé."
    else
        yad --info --text="Nettoyage annulé."
    fi
}

# Affichage espace disque
afficher_espace() {
    espace=$(df -h / | awk 'NR==2 {print $4 " libres sur " $2}')
    yad --info --text="Espace disque disponible : $espace"
}

# Menu principal YAD
while true; do
    choix=$(yad --width=400 --height=350 --title="Mon Nettoyeur Linux - tralalelo tralalala" --list --column="Option" --column="Description" \
        1 "Nettoyer paquets orphelins" \
        2 "Nettoyer logs vieux de 30 jours" \
        3 "Trouver & supprimer doublons" \
        4 "Nettoyer cache utilisateur" \
        5 "Afficher espace disque" \
        6 "Quitter")

    case "$choix" in
        1) nettoyer_paquets ;;
        2) nettoyer_logs ;;
        3) nettoyer_doublons ;;
        4) nettoyer_cache ;;
        5) afficher_espace ;;
        6) exit 0 ;;
        *) yad --info --text="Option invalide" ;;
    esac
done
