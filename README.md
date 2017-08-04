mysql-backup-docker
=======

Shell Script to backup MySQL databases running on docker container.

Install
========
```bash
cd /opt/
apt-get install -y git bsdutils
git clone https://github.com/HakaOps/mysql-backup-docker.git
```

Script Settings
=======
* `MYSQL_ROOT_PASSWORD`: MySQL root Password
* `DOCKER_IMAGE`: Grep match for `docker ps` command
* `BACKUP_DATE`: Suffix date name for backup file
* `BACKUP_PATH`: Backup storage path
* `BACKUP_RETENTION_DAYS`: Retention days for backup files

Usage
=======
Simple example:
```bash
cd mysql-backup-docker
chmod +x mysql-backup-docker.sh && ./mysql-backup-docker.sh
```

CRON example:
```
30 01 * * * root /opt/mysql-backup-docker/mysql-backup-docker.sh
```

Logger
=======
The script uses "logger" command to write basic operations in syslog.

Output example on syslog default file:
```
Aug  4 21:17:14 hakaops ubuntu: [MYSQL-DOCKER-BACKUP] INFO: Started Backup Script
Aug  4 21:17:14 hakaops ubuntu: [MYSQL-DOCKER-BACKUP] INFO: Docker container found: XXXXXXXX 
Aug  4 21:17:15 hakaops ubuntu: [MYSQL-DOCKER-BACKUP] INFO: Backuping databases
Aug  4 21:17:15 hakaops ubuntu: [MYSQL-DOCKER-BACKUP] INFO: Database wordpress dumped on /backup/mysql/database-04-08-2017.sql.gz
Aug  4 21:17:15 hakaops ubuntu: [MYSQL-DOCKER-BACKUP] INFO: Remove 3 old days backup
Aug  4 21:17:15 hakaops ubuntu: [MYSQL-DOCKER-BACKUP] INFO: Finished Backup Script
```

Author
======
Vagner Rodrigues Fernandes <hellops@hakaops.io>
https://hakaops.io/
