#!/bin/bash

# Clean user cache
clean_user_cache() {
    CACHE_DIR="$HOME/.cache"
    if [ ! -d "$CACHE_DIR" ]; then
        yad --info --text="No user cache found."
        return
    fi

    SIZE=$(du -sh "$CACHE_DIR" | cut -f1)
    yad --question --text="User cache takes up $SIZE. Do you want to clean it ?"

    if [ $? -eq 0 ]; then
        log "User cache cleanup"
        rm -rf "$CACHE_DIR"/* 2>/dev/null
        yad --info --text="Cache cleaned."
    else
        yad --info --text="Cleanup canceled."
    fi
}
