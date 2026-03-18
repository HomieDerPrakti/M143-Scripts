#!/bin/bash

SOURCE_IP="192.168.18.2"
TARGET_IP="192.168.19.2"
DATE=$(date +'%Y-%m-%dT%H:%M:%s')
SOURCE_DIR="/home/vmadmin/Patientenakten_Krankenhaus_Bern"
BACKUP_DIR="/data/backup"
LAST_FULL_DIR=$(ssh $TARGET_IP "find $BACKUP_DIR | sort | tail -n 1")
LAST_BACKUP=$(ssh $TARGET_IP "find $LAST_FULL_DIR | sort | tail -n 1")
TARGET_DIR=${LAST_FULL_DIR}/${DATE}-inc

rsync -ac --link-dest=$LAST_BACKUP $SOURCE_IP:$SOURCE_DIR/ $TARGET_IP:$TARGET_DIR