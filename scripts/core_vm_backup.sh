#!/bin/bash

# Backup important files and databases to NFS mount in each core vm.
# Sends Discord alert if error occurs during a backup step.
# Script assumes backup.json and discord.env exist in /home/docker/$HOSTNAME/env
#
# Requirements: borgbackup, rsync, sqlite3, jq
#
# discord.env:
# DISCORD_WEBHOOK=https://discord.com/api/webhooks/WEB_HOOK
#
#
# backup.json example:
# {
#     // databases to dump; separate step from file backup
#     "databases": {
#         "boltdb": [
#             "/home/docker/data/portainer/portainer.db"
#         ],
#         "sqlite": [
#             "/home/docker/data/uptimekuma/kuma.db"
#         ],
#         "mariadb": [
#             {
#                 "env_file": "/home/docker/giza/env/mariadb.env",
#                 "database": "nextcloud",
#                 "username": "MARIADB_NEXTCLOUD_USER",
#                 "password": "MARIADB_NEXTCLOUD_PASSWORD"
#             }
#         ]
#     }
#     // files to ignore during rsync
#     // database files should always be listed here
#     "ignore_patterns": {
#         // patterns to ignore in both /home/docker/data and /home/docker/$HOSTNAME
#         "all": [
#             "*.db*",
#             "*.log",
#             "*.tmp"
#         ],
#         // patterns to ignore in /home/docker/data
#         "data": [],
#         // patterns to ignore in /home/docker/$HOSTNAME
#         "repo": []
#     }
# }

### CONSTANTS ####

data_path=/home/docker/data
repo_path=/home/docker/$HOSTNAME
local_backup_path=/home/docker/backups
nfs_backup_path=/mnt/backups

config_json=$repo_path/env/backup.json

### FUNCTIONS ###

init() {
  echo "Starting $HOSTNAME backup..."
  mkdir -p $local_backup_path/data
  mkdir -p $local_backup_path/db
  mkdir -p $local_backup_path/$HOSTNAME

  # setup rsync exclude filters
  jq -c --raw-output '.ignore_patterns.all[]' $config_json > $local_backup_path/data_ignore_patterns.txt
  cp $local_backup_path/data_ignore_patterns.txt $local_backup_path/repo_ignore_patterns.txt
  jq -c --raw-output '.ignore_patterns.data[]' $config_json >> $local_backup_path/data_ignore_patterns.txt
  jq -c --raw-output '.ignore_patterns.repo[]' $config_json >> $local_backup_path/repo_ignore_patterns.txt

  # get discord web hook
  source $repo_path/env/discord.env
}

# $1 = msg
notify_error_and_exit() {
  echo 'Error occurred during backup!'
  curl -X POST -H 'Content-Type: application/json' -d "{\"content\":\"Borg backup failed on $HOSTNAME - $1\"}" $DISCORD_WEBHOOK
  exit 1
}

backup_boltdb_databases() {
  jq -c --raw-output '.databases.boltdb[]' $config_json | while read db; do
    echo Backing up boltdb $db...
    cp $db $local_backup_path/db/backup_$(basename $db) || return 1
    # Ignore WAL files; Regular copying will lose transactions in progress, but it should be good enough
  done
}

backup_h2_databases() {
  jq -c --raw-output '.databases.h2[]' $config_json | while read db; do
    echo Backing up h2 database $db...
    cp $db $local_backup_path/db/backup_$(basename $db) || return 1
    # TODO: requires h2 jar and java to be installed...ubooquity and cloudbeaver are the only ones...worth doing?
    # This has the chance to corrupt the h2 database, but not critical data at the moment
  done
}

backup_postgres_databases() {
  jq -c --raw-output '.databases.postgres[]' $config_json | while read db; do
    echo Backing up postgres database $db...
    return 1 # TODO: not supported yet
  done
}

backup_mariadb_databases() {
  username=''
  password=''
  database=''
  jq -c --raw-output '.databases.mariadb[]' $config_json | while read db_config; do
    echo Backing up mariadb database $db...
    source "$(echo $db_config | jq -c --raw-output '.env_file')"
    username="$(echo $db_config | jq -c --raw-output '.username')"
    password="$(echo $db_config | jq -c --raw-output '.password')"
    database="$(echo $db_config | jq -c --raw-output '.database')"
    docker exec mariadb sh -c "exec mysqldump -u${!username} -p${!password} $database" > "$local_backup_path/backup-$database.sql" || return 1
  done
}

backup_mongodb_databases() {
  jq -c --raw-output '.databases.mongodb[]' $config_json | while read db; do
    echo Backing up mongodb database $db...
    return 1 # TODO: not supported yet
  done
}

backup_sqlite_databases() {
  jq -c --raw-output '.databases.sqlite[]' $config_json | while read db; do
    echo Backing up sqlite database $db...
    sqlite3 $db ".timeout 10000" ".dump" > $local_backup_path/db/backup_$(basename $db | grep -Po '.*(?=\.)').sql || return 1
  done
}

backup_files() {
  echo 'Backing up files...'
  rsync -av --exclude-from="$local_backup_path/data_ignore_patterns.txt" $data_path $local_backup_path || return 1
  rsync -av --exclude-from="$local_backup_path/repo_ignore_patterns.txt" $repo_path $local_backup_path/$HOSTNAME || return 2
  borg create "$nfs_backup_path::{now:%Y-%m-%d_%H-%M-%S}" $local_backup_path || return 3
}

cleanup() {
  echo 'Cleaning...'
  borg prune --keep-daily 7 --keep-weekly 4 --keep-monthly 6 "$nfs_backup_path" || return 1
  rm -rf $local_backup_path/*
}

### MAIN ###

trap 'notify_error_and_exit "Unexpected error"' ERR

init || notify_error_and_exit 'Error occurred during init'
backup_boltdb_databases || notify_error_and_exit 'Error occurred during boltdb database backup'
backup_h2_databases || notify_error_and_exit 'Error occurred during h2 database backup'
backup_postgres_databases || notify_error_and_exit 'Error occurred during postgres database backup'
backup_mariadb_databases || notify_error_and_exit 'Error occurred during mariadb database backup'
backup_mongodb_databases || notify_error_and_exit 'Error occurred during mongodb database backup'
backup_sqlite_databases || notify_error_and_exit 'Error occurred during sqlite database backup'
backup_files || notify_error_and_exit 'Error occurred during file backup'
cleanup || notify_error_and_exit 'Error occurred during cleanup'

echo "Done $HOSTNAME backup!"
