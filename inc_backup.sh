#!/bin/bash

# IP von Fileserver und Archivserver
SOURCE_IP="192.168.18.2"
TARGET_IP="192.168.19.2"
# Timestamp für Labeling von Backup
DATE=$(date +'%Y-%m-%dT%H:%M:%S')
# verschlüsseltes und entschlüsseltes Backupverzeichnis
BACKUP_DIR_ENC="/data/backup_encrypted"
BACKUP_DIR="/data/backup_decrypted"

# verschlüsseltes Backupverzeichnis entschlüsselt anhängen
ssh $TARGET_IP "gocryptfs -passfile /root/.vault-pass $BACKUP_DIR_ENC $BACKUP_DIR"
gocryptfs -passfile /root/.vault-pass $BACKUP_DIR_ENC $BACKUP_DIR

# letztes Backup für --link-dest finden
LAST_FULL_DIR=$(find $BACKUP_DIR -maxdepth 1 -type d | sort | tail -n 1)
LAST_BACKUP=$(find $LAST_FULL_DIR -maxdepth 1 -type d | sort | tail -n 1)
# Ziel- und Quellverzeichnis
TARGET_DIR=${LAST_FULL_DIR}/${DATE}-inc
SOURCE_DIR="/home/vmadmin/Patientenakten_Krankenhaus_Bern"

# Quelldaten in Zwischenverzeichnis ablegen
rsync -ac --mkpath --link-dest=$LAST_BACKUP $SOURCE_IP:$SOURCE_DIR/ $TARGET_DIR
# Daten von Zwischenverzeichnis in Archiv ablegen
rsync -aHc --mkpath $TARGET_DIR/ $TARGET_IP:$TARGET_DIR

# entschlüsseltes Backupverzeichnis abhängen
ssh $TARGET_IP "fusermount -u $BACKUP_DIR"
fusermount -u $BACKUP_DIR