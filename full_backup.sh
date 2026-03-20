#!/bin/bash
SOURCE_IP="192.168.18.2"
TARGET_IP="192.168.19.2"
DATE=$(date +'%Y-%m-%dT%H:%M:%S')
BACKUP_DIR_ENC="/data/backup_encrypted"
BACKUP_DIR="/data/backup_decrypted"

ssh $TARGET_IP "echo $BACKUP_DECRYPT_PW | gocryptfs -passfile /dev/stdin $BACKUP_DIR_ENC BACKUP_DIR"

SOURCE_DIR="/home/vmadmin/Patientenakten_Krankenhaus_Bern"
TARGET_DIR="${BACKUP_DIR}/full-${DATE}/${DATE}-full"

rm -rf $BACKUP_DIR/*

rsync -ac --mkpath $SOURCE_IP:$SOURCE_DIR/ $TARGET_DIR
rsync -ac --mkpath $TARGET_DIR/ $TARGET_IP:$TARGET_DIR

ssh $TARGET_IP "fusermount -u $BACKUP_DIR"