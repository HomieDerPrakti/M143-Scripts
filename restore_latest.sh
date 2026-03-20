#!/bin/bash

SOURCE_IP="192.168.19.2"
TARGET_IP="192.168.18.2"
BACKUP_DIR_ENC="/data/backup_encrypted"
BACKUP_DIR="/data/backup_decrypted"

ssh $SOURCE_IP "echo $BACKUP_DECRYPT_PW | gocryptfs -passfile /dev/stdin $BACKUP_DIR_ENC $BACKUP_DIR"

LAST_FULL_DIR=$(ssh $SOURCE_IP "find ${BACKUP_DIR} -maxdepth 1 -type d | sort | tail -n 1")
SOURCE_DIR=$(ssh $SOURCE_IP "find ${LAST_FULL_DIR} -maxdepth 1 -type d | sort | tail -n 1")
TARGET_DIR="/home/vmadmin/Patientenakten_Krankenhaus_Bern"

rm -rf /data/restore/*

rsync -ac --mkpath $SOURCE_IP:$SOURCE_DIR/ /data/restore
rsync -ac --mkpath /data/backup/ $TARGET_IP:$TARGET_DIR

rm rf /data/restore/*

ssh $SOURCE_IP "fusermount -u $BACKUP_DIR"