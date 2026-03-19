#!/bin/bash

SOURCE_IP="192.168.19.2"
TARGET_IP="192.168.18.2"
BACKUP_DIR="/data/backup"
LAST_FULL_DIR='$(ssh $SOURCE_IP "find ${BACKUP_DIR} -maxdepth 1 -type d | sort | tail -n 1)'
SOURCE_DIR='$(ssh $SOURCE_IP "find ${BACKUP_DIR} -maxdepth 1 -type d | sort | tail-n 1)'
TARGET_DIR="/home/vmadmin/Patientenakten_Krankenhaus_Bern"

rm -rf /data/backup/*

rsync -ac $SOURCE_IP:$SOURCE_DIR/ /data/backup
rsync -ac /data/backup/ $TARGET_IP:$TARGET_DIR
