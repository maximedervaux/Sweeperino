#!/bin/bash

source "$SCRIPT_DIR/utils/log.sh"
source "$SCRIPT_DIR/config.sh"

#Nettoyage des logs vieux de 30 jours
nettoyer_logs() {

    # Trouve les fichiers de logs dans /var/log qui sont plus vieux que 30 jours dans le dossier log
    local files
    files=$(find /var/log -maxdepth 1 -type f -mtime +30 2>/dev/null)

    # Si aucun fichier n est trouvé, affiche un message d'information
    if [ -z "$files" ]; then
        yad --info --text="Aucun fichier log vieux de plus de 30 jours trouvé."
        return
    fi

    # Formate la liste des fichiers pour l'affichage dans YAD
    local files_list
    files_list=$(echo "$files" | sed 's/^/- /')

    # Affiche une boîte de dialogue YAD pour confirmer la suppression des fichiers
    yad --width=600 --height=400 \
        --text="Fichiers logs à supprimer :\n\n$files_list\n\nConfirmez la suppression ?" \
        --button=gtk-ok:0 --button=gtk-cancel:1

    # Vérifie le code de retour de YAD pour savoir si l'utilisateur a confirmé ou annulé
    # Si l'utilsateur a confirmé (code de retour 0), procède à la suppression des fichiers
    if [ $? -eq 0 ]; then
        log "INFO" "Début de la suppression des fichiers de logs anciens."

        local errors=0

        # Boucle sur chaque fichier trouvé et tente de le supprimer
        while IFS= read -r file; do
            if sudo rm -v "$file" >> "$LOG_FILE" 2>&1; then
                log "SUCCÈS" "Supprimé : $file"
            else
                log "ERREUR" "Échec suppression : $file"
                ((errors++))
            fi
        done <<< "$files"

        # Affiche un message de succès ou davertissement selon le nombre d'erreurs
        if [ "$errors" -eq 0 ]; then
            yad --info --text="Tous les fichiers ont été supprimés avec succès."
        else
            yad --warning --text="Certains fichiers n'ont pas pu être supprimés. Consultez le fichier de log."
        fi

    # Si lutilisateur a annulé (code de retour 1), affiche un message d'information
    else
        yad --info --text="Suppression annulée."
        log "INFO" "Suppression des logs annulée par l'utilisateur."
    fi
}
