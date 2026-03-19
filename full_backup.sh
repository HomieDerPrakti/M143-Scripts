#!/bin/bash
SOURCE_IP="192.168.18.2"
TARGET_IP="192.168.19.2"
DATE=$(date +'%Y-%m-%dT%H:%M:%S')

SOURCE_DIR="/home/vmadmin/Patientenakten_Krankenhaus_Bern"
TARGET_DIR="/data/backup/full-${DATE}/${DATE}-full"

rm -rf /data/backup/*

rsync -ac --mkpath $SOURCE_IP:$SOURCE_DIR/ $TARGET_DIR
rsync -ac --mkpath $TARGET_DIR $TARGET_IP:$TARGET_DIR