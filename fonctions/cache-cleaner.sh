#!/bin/bash

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
