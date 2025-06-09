#!/bin/bash


# List of file extensions and their target folders using detected paths
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
    [epub]="$USER_DOCUMENTS_DIR/Ebooks"

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

    # Videos
    [mp4]="$USER_VIDEOS_DIR"
    [mkv]="$USER_VIDEOS_DIR"
    [avi]="$USER_VIDEOS_DIR"
    [mov]="$USER_VIDEOS_DIR"
    [wmv]="$USER_VIDEOS_DIR"

    # Executables / Packages
    [deb]="$USER_DOWNLOAD_DIR/Packages"
    [rpm]="$USER_DOWNLOAD_DIR/Packages"
    [AppImage]="$USER_DOWNLOAD_DIR/Applications"
    [exe]="$USER_DOWNLOAD_DIR/WindowsExecutables"

    # Scripts / Code
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

directory_sort(){
  # --- INITIAL CHECKS ---
  if [ ! -d "$SOURCE_DIR_SORT" ]; then
      log "ERROR" "Source downloads folder '$SOURCE_DIR_SORT' does not exist or couldn't be detected. Check xdg-user-dir."
      exit 1
  fi

  # Create default folder if it doesn't exist
  if [ ! -d "$DEFAULT_FOLDER_PATH" ]; then
      log "INFO" "Default folder '$DEFAULT_FOLDER_PATH' does not exist. Creating it..."
      mkdir -p "$DEFAULT_FOLDER_PATH" || {
      	log "ERROR" "Unable to create default folder '$DEFAULT_FOLDER_PATH'."
	exit 1
      }
  fi

  # --- SORTING LOGIC ---
  log "INFO" "Starting reorganization of folder '$SOURCE_DIR_SORT'."
  log "INFO" "Mode: $( [ "$MOVE_FILES" = true ] && echo "Moving" || echo "Copying" ) files."

  # Loop through all files (non-recursive, only in the source folder)
  for file in "$SOURCE_DIR_SORT"/*; do
      if [ -f "$file" ]; then # Ensure it's a regular file
          filename=$(basename "$file")
          extension="${filename##*.}" # Get the file extension
          extension_lower=$(echo "$extension" | tr '[:upper:]' '[:lower') # Convert to lowercase

        # Determine the full destination folder path
        DESTINATION_DIR="${FILE_TYPES[$extension_lower]}"
        if [ -z "$DESTINATION_DIR" ]; then
            DESTINATION_DIR="$DEFAULT_FOLDER_PATH"
        fi

        # Create destination folder if it doesn't exist
        if [ ! -d "$DESTINATION_DIR" ]; then
            log "INFO" "Creating subfolder: '$DESTINATION_DIR'"
            mkdir -p "$DESTINATION_DIR" || {
		 log "ERROR" "Unable to create subfolder '$DESTINATION_DIR'."
		 continue
	    }
        fi

        # Move the file
        mv -n "$file" "$DESTINATION_DIR/"
        if [ $? -eq 0 ]; then
               log "SUCCESS" "Moved: '$filename' to '$DESTINATION_DIR/'"
        else
               log "ERROR" "Failed to move '$filename' to '$DESTINATION_DIR/'"
        fi

    fi
  done

  log "INFO" "Reorganization of the downloads folder completed."
  log "INFO" "Check the log file '$LOG_FILE' for details of the operations."
  yad --info --title="Sorting Completed" --text="✅ Sorting complete!\n\nYour files have been organized successfully."

}
