#!/bin/bash

source "$SCRIPT_DIR/utils/log.sh"


# Fonction pour supprimer les fichiers doublons
nettoyer_doublons() {

    # Vérifie si fdupes est installé
    if ! command -v fdupes >/dev/null 2>&1; then
        yad --error --text="Le paquet 'fdupes' n'est pas installé. Veuillez l'installer pour utiliser cette fonction."
        return
    fi

    # Scanne dossier home
    fdupes -r "$HOME" > /tmp/doublons.txt

    # Vérifie si le dossier temporaire est vide
    if [ ! -s /tmp/doublons.txt ]; then
        yad --info --text="Aucun fichier doublon trouvé dans $HOME."
        return
    fi

    # Initialise un ID de groupe pour regrouper les doublons visuellement
    local group_id=0

    # Chaîne qui va contenir les données formatées pour YAD
    local yad_lines="" 

    # Variable temporaire pour lire chaque ligne du fichier
    local line

    # Lire le fichier de doublons ligne par ligne
    # et formater les données pour YAD
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ -z "$line" ]]; then
            ((group_id++))
            continue
        fi

        # Format : group_id|filepath
         yad_lines+="TRUE|$group_id|$line\n"

    done < /tmp/doublons.txt

    # Lance YAD en mode liste avec les doublons trouvés
    local selection=$(echo -e -n "$yad_lines" | yad --list --width=800 --height=500 --title="Fichiers doublons trouvés - Sélectionnez à supprimer" \
        --checklist --column="Supprimer" --column="Groupe" --column="Fichier" --separator="|")

    # Vérifie si l'utilisateur a sélectionné des fichiers
    if [ -z "$selection" ]; then
        yad --info --text="Aucun fichier sélectionné. Opération annulée."
        return
    fi

    # Confirmer la suppression
    yad --question --text="Êtes-vous sûr de vouloir supprimer les fichiers sélectionnés ?"

    # Vérifie le code de retour de YAD pour savoir si l'utilisateur a confirmé ou annulé
    if [ $? -ne 0 ]; then
        yad --info --text="Suppression annulée."
        return
    fi

    # Supprimer les fichiers sélectionnés (séparés par |)
    IFS='|' read -r -a files_to_delete <<< "$selection"
    local errors=0

    # Boucle pour supprimer chaque fichier sélectionné
    for file in "${files_to_delete[@]}"; do
        if rm -v "$file" >> "$LOG_FILE" 2>&1; then
            log "Suppression fichier doublon: $file"
        else
            log "ERREUR suppression fichier doublon: $file"
            ((errors++))
        fi
    done

    # Affiche un message de succès ou d'avertissement selon le nombre d'erreurs
    if [ "$errors" -eq 0 ]; then
        yad --info --text="Suppression terminée avec succès."
    else
        yad --info --text="Suppression terminée avec des erreurs. Consultez le log."
    fi
}
