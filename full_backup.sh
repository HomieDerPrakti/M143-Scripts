#!/bin/bash

# IP von Fileserver und Archivserver
SOURCE_IP="192.168.18.2"
TARGET_IP="192.168.19.2"

# Timestamp für Labeling von Backup
DATE=$(date +'%Y-%m-%dT%H:%M:%S')
# verschlüsseltes und entschlüsseltes Backupverzeichnis
BACKUP_DIR_ENC="/data/backup_encrypted"
BACKUP_DIR="/data/backup_decrypted"

# verschlüsseltes Verzeichnis entschlüsselt anhängen
ssh $TARGET_IP "echo $BACKUP_DECRYPT_PW | gocryptfs -passfile /dev/stdin $BACKUP_DIR_ENC $BACKUP_DIR"
echo $BACKUP_DECRYPT_PW | gocryptfs -passfile /dev/stdin $BACKUP_DIR_ENC $BACKUP_DIR

# Quell- und Zielverzeichnis
SOURCE_DIR="/home/vmadmin/Patientenakten_Krankenhaus_Bern"
TARGET_DIR="${BACKUP_DIR}/full-${DATE}/${DATE}-full"

# Zwischenverzeichnis aufräumen
rm -rf $BACKUP_DIR/*

# Quelldaten in Zwischenverzeichnis ablegen
rsync -ac --mkpath $SOURCE_IP:$SOURCE_DIR/ $TARGET_DIR
# Daten von Zwischenverzeichnis in Zielverzeichnis ablegen
rsync -ac --mkpath $TARGET_DIR/ $TARGET_IP:$TARGET_DIR

# entschlüsseltes Backupverzeichnis abhängen
ssh $TARGET_IP "fusermount -u $BACKUP_DIR"
fusermount -u $BACKUP_DIR