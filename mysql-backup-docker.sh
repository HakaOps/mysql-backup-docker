#!/bin/bash -       
#title           :mysql-backup-docker.sh
#description     :This script will backup mysql databases running on docker container. 
#author		 :Vagner Rodrigues Fernandes - HakaOps Inc.
#website	 :https://hakaops.io/
#date            :20170804
#version         :0.1    
#usage		 :./mysql-backup-docker.sh
#bash_version    :4.3.48(1)-release
#==============================================================================

## Settings
MYSQL_ROOT_PASSWORD="MYSQL_ROOT_PASSWORD"
DOCKER_IMAGE="mysql"
BACKUP_DATE=`date +%d-%m-%Y`
BACKUP_PATH="/backup/mysql"
BACKUP_RETENTION_DAYS="3"

## Go! 
logger "[MYSQL-DOCKER-BACKUP] INFO: Started Backup Script"

if [ -d $BACKUP_PATH ]; then
	mkdir -p $BACKUP_PATH
fi

## Get a docker container running MySQL
DOCKER_CONTAINER=`docker ps | grep -w $DOCKER_IMAGE | awk '{ print $1 }'`
if [[ -z $DOCKER_CONTAINER ]]; then
	logger "[MYSQL-DOCKER-BACKUP] ERROR: Container not found, check image filter on settings: DOCKER_IMAGE=$DOCKER_IMAGE"
	exit
else
	logger "[MYSQL-DOCKER-BACKUP] INFO: Docker container found: $DOCKER_CONTAINER"
fi

## Get a list MySQL databases
MYSQL_DATABASES=`docker exec -it $DOCKER_CONTAINER mysql -p$MYSQL_ROOT_PASSWORD -e "show databases;" \
			| egrep -v -w -e information_schema -e performance_schema -e sys -e Database \
			| awk '{ print $2 }' | grep -v '^$' | egrep -v "Warning"`

## Backup databases 
logger "[MYSQL-DOCKER-BACKUP] INFO: Backuping databases"
for DATABASE_NAME in $MYSQL_DATABASES; do
	docker exec -it $DOCKER_CONTAINER mysqldump -p$MYSQL_ROOT_PASSWORD $DATABASE_NAME | gzip -9 > $BACKUP_PATH/$DATABASE_NAME-$BACKUP_DATE.sql.gz
	logger "[MYSQL-DOCKER-BACKUP] INFO: Database $DATABASE_NAME dumped on $BACKUP_PATH/$DATABASE_NAME-$BACKUP_DATE.sql.gz"
done

## Backup retention clear
if [ $BACKUP_RETENTION_DAYS ]; then
	logger "[MYSQL-DOCKER-BACKUP] INFO: Remove $BACKUP_RETENTION_DAYS old days backup"
	find $BACKUP_PATH -type f -mtime +$BACKUP_RETENTION_DAYS -exec rm {} \;
fi

logger "[MYSQL-DOCKER-BACKUP] INFO: Finished Backup Script"
