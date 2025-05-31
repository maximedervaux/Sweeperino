#!/bin/bash

# --- CONFIGURATION INITIALE ---
# Nous allons utiliser xdg-user-dir pour trouver le chemin correct de votre dossier de téléchargements.
# Si xdg-user-dir n'est pas disponible ou échoue, il utilisera un chemin par défaut ($HOME/Downloads).

<<<<<<< HEAD:sort/directorysort.sh
SOURCE_DIR="$(xdg-user-dir DOWNLOAD 2>/dev/null || echo "$HOME/Downloads")" # << LE DOSSIER SOURCE EST MAINTENANT LE DOSSIER DE TÉLÉCHARGEMENTS
LOG_FILE="$HOME/reorganisation_downloads.log"
=======
SOURCE_DIR="$(xdg-user-dir DOWNLOAD 2>/dev/null || echo "$HOME/Downloads")" 
LOG_FILE="$HOME/reorganisation_downloads.log"     
>>>>>>> main:directorysort.sh


# --- DÉTECTION DES DOSSIERS UTILISATEUR STANDARDS ---
# Utilisez xdg-user-dir pour obtenir les chemins corrects des autres dossiers utilisateur.
# Cela gère les noms localisés (ex: "Images" vs "Pictures").
USER_DESKTOP_DIR="$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")"
USER_DOCUMENTS_DIR="$(xdg-user-dir DOCUMENTS 2>/dev/null || echo "$HOME/Documents")"
USER_DOWNLOAD_DIR="$SOURCE_DIR" 
USER_MUSIC_DIR="$(xdg-user-dir MUSIC 2>/dev/null || echo "$HOME/Music")"
USER_PICTURES_DIR="$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")"
USER_VIDEOS_DIR="$(xdg-user-dir VIDEOS 2>/dev/null || echo "$HOME/Videos")"

# Liste des extensions et des dossiers cibles en utilisant les chemins détectés
declare -A FILE_TYPES=(
    # Images
    [jpg]="$USER_PICTURES_DIR"
    [jpeg]="$USER_PICTURES_DIR"
    [png]="$USER_PICTURES_DIR"
    [gif]="$USER_PICTURES_DIR"
    [bmp]="$USER_PICTURES_DIR"
    [tif]="$USER_PICTURES_DIR"
    [tiff]="$USER_PICTURES_DIR"
    [webp]="$USER_PICTURES_DIR"
    [svg]="$USER_PICTURES_DIR"

    # Documents
    [doc]="$USER_DOCUMENTS_DIR"
    [docx]="$USER_DOCUMENTS_DIR"
    [pdf]="$USER_DOCUMENTS_DIR"
    [odt]="$USER_DOCUMENTS_DIR"
    [txt]="$USER_DOCUMENTS_DIR"
    [md]="$USER_DOCUMENTS_DIR"
    [pptx]="$USER_DOCUMENTS_DIR"
    [ppt]="$USER_DOCUMENTS_DIR"
    [xlsx]="$USER_DOCUMENTS_DIR"
    [xls]="$USER_DOCUMENTS_DIR"
    [csv]="$USER_DOCUMENTS_DIR"
    [epub]="$USER_DOCUMENTS_DIR/Ebooks" # Ajout spécifique pour les téléchargements

    # Archives
    [zip]="$USER_DOWNLOAD_DIR/Archives" 
    [rar]="$USER_DOWNLOAD_DIR/Archives"
    [7z]="$USER_DOWNLOAD_DIR/Archives"
    [gz]="$USER_DOWNLOAD_DIR/Archives"
    [tar]="$USER_DOWNLOAD_DIR/Archives"
    [tgz]="$USER_DOWNLOAD_DIR/Archives"
    [bz2]="$USER_DOWNLOAD_DIR/Archives"
    [xz]="$USER_DOWNLOAD_DIR/Archives"
    [iso]="$USER_DOWNLOAD_DIR/ISOs"

    # Audio
    [mp3]="$USER_MUSIC_DIR"
    [wav]="$USER_MUSIC_DIR"
    [ogg]="$USER_MUSIC_DIR"
    [flac]="$USER_MUSIC_DIR"

    # Vidéos
    [mp4]="$USER_VIDEOS_DIR"
    [mkv]="$USER_VIDEOS_DIR"
    [avi]="$USER_VIDEOS_DIR"
    [mov]="$USER_VIDEOS_DIR"
    [wmv]="$USER_VIDEOS_DIR"

    # Exécutables / Paquets 
    [deb]="$USER_DOWNLOAD_DIR/Packages" 
    [rpm]="$USER_DOWNLOAD_DIR/Packages"
    [AppImage]="$USER_DOWNLOAD_DIR/Applications" 
    [exe]="$USER_DOWNLOAD_DIR/WindowsExecutables"

    # Scripts/Code (peut-être dans un sous-dossier de Documents)
    [sh]="$USER_DOCUMENTS_DIR/Scripts"
    [py]="$USER_DOCUMENTS_DIR/Scripts"
    [js]="$USER_DOCUMENTS_DIR/Scripts"
    [php]="$USER_DOCUMENTS_DIR/Scripts"
    [html]="$USER_DOCUMENTS_DIR/WebFiles"
    [css]="$USER_DOCUMENTS_DIR/WebFiles"
    [xml]="$USER_DOCUMENTS_DIR/WebFiles"
    [json]="$USER_DOCUMENTS_DIR/WebFiles"
    [java]="$USER_DOCUMENTS_DIR/Code"
    [c]="$USER_DOCUMENTS_DIR/Code"
    [cpp]="$USER_DOCUMENTS_DIR/Code"
    [h]="$USER_DOCUMENTS_DIR/Code"
    [hpp]="$USER_DOCUMENTS_DIR/Code"
    [go]="$USER_DOCUMENTS_DIR/Code"
)
# Dossier par défaut pour les fichiers non reconnus
DEFAULT_FOLDER_PATH="$USER_DOWNLOAD_DIR/Autres"

# --- FONCTIONS DE LOGGING ---
log_message() {
    local type="$1"
    local message="$2"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$type] $message" | tee -a "$LOG_FILE"
}

# --- VÉRIFICATIONS PRÉLIMINAIRES ---
if [ ! -d "$SOURCE_DIR" ]; then
    log_message "ERREUR" "Le dossier source de téléchargements '$SOURCE_DIR' n'existe pas ou n'a pas pu être détecté. Vérifiez xdg-user-dir."
    exit 1
fi

# Créer le dossier par défaut si nécessaire
if [ ! -d "$DEFAULT_FOLDER_PATH" ]; then
    log_message "INFO" "Le dossier par défaut '$DEFAULT_FOLDER_PATH' n'existe pas. Création..."
    mkdir -p "$DEFAULT_FOLDER_PATH" || { log_message "ERREUR" "Impossible de créer le dossier par défaut '$DEFAULT_FOLDER_PATH'."; exit 1; }
fi

# --- LOGIQUE DE RÉORGANISATION ---
log_message "INFO" "Démarrage de la réorganisation du dossier '$SOURCE_DIR'."
log_message "INFO" "Mode: $( [ "$MOVE_FILES" = true ] && echo "Déplacement" || echo "Copie" ) des fichiers."

# Parcourir tous les fichiers (non récursif, seulement dans le dossier source)
for file in "$SOURCE_DIR"/*; do
    if [ -f "$file" ]; then # S'assurer que c'est bien un fichier
        filename=$(basename "$file")
        extension="${filename##*.}" # Extrait l'extension
        extension_lower=$(echo "$extension" | tr '[:upper:]' '[:lower__') # Convertir en minuscule

        # Déterminer le chemin complet du dossier de destination
        DESTINATION_DIR="${FILE_TYPES[$extension_lower]}"
        if [ -z "$DESTINATION_DIR" ]; then
            DESTINATION_DIR="$DEFAULT_FOLDER_PATH"
        fi

        # Créer le dossier de destination s'il n'existe pas
        if [ ! -d "$DESTINATION_DIR" ]; then
            log_message "INFO" "Création du sous-dossier: '$DESTINATION_DIR'"
            mkdir -p "$DESTINATION_DIR" || { log_message "ERREUR" "Impossible de créer le sous-dossier '$DESTINATION_DIR'."; continue; }
        fi

        # Déplacer ou copier le fichier

         mv -n "$file" "$DESTINATION_DIR/" # -n pour ne pas écraser les fichiers existants
         if [ $? -eq 0 ]; then
                log_message "SUCCES" "Déplacé: '$filename' vers '$DESTINATION_DIR/'"
         else
                log_message "ERREUR" "Échec du déplacement de '$filename' vers '$DESTINATION_DIR/'"
         fi

    fi
done

log_message "INFO" "Réorganisation du dossier de téléchargements terminée."
log_message "INFO" "Consultez le fichier de log '$LOG_FILE' pour le détail des opérations."
