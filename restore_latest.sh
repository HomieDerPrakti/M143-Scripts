#!/bin/bash

SOURCE_IP="192.168.19.2"
TARGET_IP="192.168.18.2"
BACKUP_DIR="/data/backup"
LAST_FULL_DIR='$(ssh $SOURCE_IP "find ${BACKUP_DIR} | sort | tail -n 1)'
SOURCE_DIR='$(ssh $SOURCE_IP "find ${BACKUP_DIR} | sort | tail-n 1)'
TARGET_DIR="/home/vmadmin/Patientenakten_Krankenhaus_Bern"

rsync -ac $SOURCE_IP:$SOURCE_DIR/ $TARGET_IP:$TARGET_DIR