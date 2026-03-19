#!/bin/bash

SOURCE_IP="192.168.18.2"
TARGET_IP="192.168.19.2"
DATE=$(date +'%Y-%m-%dT%H:%M:%S')
SOURCE_DIR="/home/vmadmin/Patientenakten_Krankenhaus_Bern"
BACKUP_DIR="/data/backup"
LAST_FULL_DIR=$(find $BACKUP_DIR -maxdepth 1 -type d | sort | tail -n 1)
LAST_BACKUP=$(find $LAST_FULL_DIR -maxdepth 1 -type d | sort | tail -n 1)
TARGET_DIR=${LAST_FULL_DIR}/${DATE}-inc

rsync -ac --mkpath --link-dest=$LAST_BACKUP $SOURCE_IP:$SOURCE_DIR/ $TARGET_DIR
rsync -aHc --mkpath $TARGET_DIR/ $TARGET_IP:$TARGET_DIR