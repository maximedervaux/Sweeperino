# 🧹 Sweeperino - Outil de nettoyage pour Linux

**Sweeperino** est un utilitaire graphique en Bash conçu pour simplifier la maintenance de base d’un système Linux.  
L'idée est d'avoir un outil "basique" permettant de clean son environnement (vider caches/logs, trier les dossiers, etc...).

> Quand le bash fait la fiesta, Sweeperino nettoie les degats
---

## 🎯 Objectifs du projet

- Automatiser des tâches de nettoyage courantes sous Linux.
- Intégrer une interface graphique utilisateur (YAD).
- Remonter des logs des actions menées.
- Appliquer des bonnes pratiques de développement Bash.
- Créer des backups 

---

## 🛠️ Fonctionnalités principales

1. **Nettoyage des paquets orphelins**  
   ➜ Supprime les dépendances installées qui ne sont plus nécessaires.

2. **Nettoyage des logs vieux de plus de 30 jours**  
   ➜ Analyse `/var/log` et supprime les fichiers de log trop anciens.

3. **Suppression des fichiers doublons**  
   ➜ Détecte les fichiers en double dans le dossier `$HOME` via l'outil `fdupes` et les supprime.

4. **Nettoyage du cache utilisateur**  
   ➜ Vide les caches des applications utilisateur pour libérer de l’espace.

5. **Affichage de l’espace disque**  
   ➜ Affiche les statistiques d’utilisation du disque.

6. **Tri automatique des téléchargements**  
   ➜ Classe automatiquement les fichiers du dossier *Téléchargements* dans les répertoires appropriés selon leur type (Images, Documents, Vidéos, etc...).

7. **Backups**
   ➜ Creer des backups chiffrées du dossier selectionné en config. Et propose de restaurer n'importe quelles backups sur le system.

---

## 🖼️ Interface graphique (YAD)

L’outil utilise **YAD (Yet Another Dialog)** pour proposer un menu simple et accessible à l’utilisateur.  
Le menu permet de choisir l'action à exécuter de manière graphique, sans passer par le terminal.

---

## 📄 Logs

L'application remonte les logs dans un fichier par défaut situé dans le `$HOME`.  
Ce chemin peut être modifié via le fichier `config.sh`.

---

## 📁 Structure du projet

```
sweeperino/
├── main.sh                # Script principal
├── config.sh              # Configuration globale
├── fonctions/
│   ├── logs-cleaner.sh         # Nettoyage de logs
│   ├── packets-cleaner.sh      # Suppression de paquets orphelins
│   ├── double-files-cleaner.sh # Suppression de fichiers doublons
│   ├── cache-cleaner.sh        # Nettoyage de cache utilisateur
│   └── storage.sh              # Affichage de l’espace disque
│   └── restore.sh		# Restore la backup selectionnée
│   └── backup.sh 		# Créé une backup d'un dossier
│   └── directorysort.sh        # Script de tri automatique des téléchargements
├── utils/
│   └── log.sh                  # Utilitaires de log
```
---

## ✨ Respect du Clean Code

Nous avons essayé de rendre l’application la plus **modulaire et maintenable** possible :  
- Le code est divisé en **fichiers et fonctions distincts**, chacun ayant une responsabilité claire.
- Cela permet une **réutilisation facile**, une **meilleure lisibilité** et une **évolution simplifiée** du projet.

---

## 🧰 Dépendances

- `bash`
- `yad`
- `fdupes`
- `xdg-user-dirs`
- `gnome-terminal`
- `argon2`
- `openssl`
- `zip`
- `tar`
- `coreutils`

### Installation Debian/Ubuntu :

```bash
sudo apt install yad fdupes gnome-terminal xdg-user-dirs argon2 openssl zip tar coreutils
```

### Installation Fedora :

```bash
ssudo dnf install yad fdupes gnome-terminal xdg-user-dirs argon2 openssl zip tar coreutils
```
---

<<<<<<< HEAD
=======
### ⚙️ Variables de Configuration

Le fichier config.sh centralise les variables essentielles pour personnaliser le comportement de Sweeperino. Vous pouvez y ajuster les chemins des fichiers de log et des répertoires de sauvegarde, ainsi que d'autres paramètres importants.

Voici les variables que vous pouvez modifier :

    LOG_FILE: Spécifie le chemin complet du fichier de log où Sweeperino enregistrera ses actions.
        Exemple : LOG_FILE="$HOME/sweeperino.log"

    SOURCE_DIR: Définit le répertoire source qui sera sauvegardé.
        Exemple : SOURCE_DIR="$HOME/Documents"

    BACKUP_DIR: Indique le répertoire où les sauvegardes seront stockées.
        Exemple : BACKUP_DIR="$HOME/backups"

    INTERVAL_MINUTES: (À implémenter) Représente l'intervalle en minutes pour les sauvegardes automatiques.
        Exemple : INTERVAL_MINUTES=30

    MAX_BACKUPS: Détermine le nombre maximal de sauvegardes à conserver. Les sauvegardes les plus anciennes seront supprimées une fois cette limite atteinte.
        Exemple : MAX_BACKUPS=5

📁 Configuration du Tri Automatique

La section --- CONFIG SORT --- dans le fichier config.sh contient les chemins des répertoires utilisés par la fonctionnalité de tri automatique des téléchargements. Ces variables sont basées sur les répertoires utilisateur standard et garantissent que vos fichiers sont classés aux bons endroits.

Voici les variables de configuration liées au tri :

    SOURCE_DIR_SORT: Le répertoire source à partir duquel les fichiers seront triés. Par défaut, il tente d'utiliser le répertoire de Téléchargements de l'utilisateur.
        Exemple : SOURCE_DIR_SORT="$(xdg-user-dir DOWNLOAD 2>/dev/null || echo "$HOME/Downloads")"

    USER_DESKTOP_DIR: Le chemin du répertoire Bureau de l'utilisateur.
        Exemple : USER_DESKTOP_DIR="$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")"

    USER_DOCUMENTS_DIR: Le chemin du répertoire Documents de l'utilisateur.
        Exemple : USER_DOCUMENTS_DIR="$(xdg-user-dir DOCUMENTS 2>/dev/null || echo "$HOME/Documents")"

    USER_DOWNLOAD_DIR: Le chemin du répertoire Téléchargements de l'utilisateur. Notez qu'il est lié à SOURCE_DIR dans cet exemple.
        Exemple : USER_DOWNLOAD_DIR="$SOURCE_DIR"

    USER_MUSIC_DIR: Le chemin du répertoire Musique de l'utilisateur.
        Exemple : USER_MUSIC_DIR="$(xdg-user-dir MUSIC 2>/dev/null || echo "$HOME/Music")"

    USER_PICTURES_DIR: Le chemin du répertoire Images de l'utilisateur.
        Exemple : USER_PICTURES_DIR="$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")"

    USER_VIDEOS_DIR: Le chemin du répertoire Vidéos de l'utilisateur.
        Exemple : USER_VIDEOS_DIR="$(xdg-user-dir VIDEOS 2>/dev/null || echo "$HOME/Videos")"

    DEFAULT_FOLDER_PATH: Le répertoire par défaut où les fichiers non reconnus seront déplacés.
        Exemple : DEFAULT_FOLDER_PATH="$USER_DOWNLOAD_DIR/Autres"

---

>>>>>>> a060dca (fix(english) : replace all french comments and titles with english)
## 🚀 Lancement

Pour lancer **Sweeperino** avec son interface graphique :

```bash
 ./main.sh
```

---

## Auteurs
	•	PASSET William, WAREMBOURG Ugo , DERVAUX Maxime
 JUNIA ISEN
 
---
## Licence

Ce projet a été réalisé dans le cadre d’un apprentissage.
Libre d’utilisation et de modification.
