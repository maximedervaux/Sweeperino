#!/bin/bash

# Affichage espace disque
afficher_espace() {
    espace=$(df -h / | awk 'NR==2 {print $4 " libres sur " $2}')
    yad --info --text="Espace disque disponible : $espace"
}