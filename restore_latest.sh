#!/bin/bash

# IP von Archivserver und Fileserver
SOURCE_IP="192.168.19.2"
TARGET_IP="192.168.18.2"
# Pfad zum verschlüsselten und entschlüsselten Backup-Verzeichnis
BACKUP_DIR_ENC="/data/backup_encrypted"
BACKUP_DIR="/data/backup_decrypted"

# Backup verzeichnis entschlüsseln
ssh $SOURCE_IP "gocryptfs -passfile /root/.vault-pass $BACKUP_DIR_ENC $BACKUP_DIR"

# Das letzte Backup finden
LAST_FULL_DIR=$(ssh $SOURCE_IP "find ${BACKUP_DIR} -maxdepth 1 -type d | sort | tail -n 1")
SOURCE_DIR=$(ssh $SOURCE_IP "find ${LAST_FULL_DIR} -maxdepth 1 -type d | sort | tail -n 1")
TARGET_DIR="/home/vmadmin/Patientenakten_Krankenhaus_Bern"

# Temporäres Verzeichnis aufräumen
rm -rf /data/restore/*

# Backup in temporäres Verzeichnis ablegen
rsync -ac --mkpath $SOURCE_IP:$SOURCE_DIR/ /data/restore
# Backup von temporärem Verzeichnis in Fileserver wiederherstellen
rsync -ac --mkpath /data/restore/ $TARGET_IP:$TARGET_DIR

# temporäres Verzeichnis aufräumen
rm rf /data/restore/*

# Entschlüsseltes Backupverzeichnis abhängen
ssh $SOURCE_IP "fusermount -u $BACKUP_DIR"