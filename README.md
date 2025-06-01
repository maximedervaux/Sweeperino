# 🧹 Sweeperino - Outil de nettoyage pour Linux

**Sweeperino** est un utilitaire graphique en Bash conçu pour simplifier la maintenance de base d’un système Linux.  
L'idée est d'avoir un outil "basique" permettant de clean son environnement (vider caches/logs, trier les dossiers, etc...).

---

## 🎯 Objectifs du projet

- Automatiser des tâches de nettoyage courantes sous Linux.
- Intégrer une interface graphique utilisateur (YAD).
- Remonter des logs des actions menées.
- Appliquer des bonnes pratiques de développement Bash.

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

sweeperino/
├── main.sh                # Script principal
├── config.sh              # Configuration globale
├── fonctions/
│   ├── logs-cleaner.sh         # Nettoyage de logs
│   ├── packets-cleaner.sh      # Suppression de paquets orphelins
│   ├── double-files-cleaner.sh # Suppression de fichiers doublons
│   ├── cache-cleaner.sh        # Nettoyage de cache utilisateur
│   └── storage.sh              # Affichage de l’espace disque
├── sort/
│   └── directorysort.sh        # Script de tri automatique des téléchargements
├── utils/
│   └── log.sh                  # Utilitaires de log

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

### Installation Debian/Ubuntu :

```bash
sudo apt install yad fdupes gnome-terminal xdg-user-dirs
```

### Installation Fedora :

```bash
ssudo dnf install yad fdupes gnome-terminal xdg-user-dirs
```
---

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
