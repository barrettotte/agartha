#!/bin/bash

set -e

# change default postgres password
psql -v ON_ERROR_STOP=1 --username postgres <<-EOSQL
  ALTER USER postgres WITH ENCRYPTED PASSWORD '$POSTGRES_PASSWORD';
EOSQL

# setup linkwarden
psql -v ON_ERROR_STOP=1 --username postgres <<-EOSQL
  CREATE USER $LINKWARDEN_USER WITH ENCRYPTED PASSWORD '$LINKWARDEN_PASSWORD';
  CREATE DATABASE linkwarden_db OWNER $LINKWARDEN_USER;
  GRANT ALL ON DATABASE linkwarden_db TO $LINKWARDEN_USER;
  GRANT ALL ON SCHEMA public TO $LINKWARDEN_USER;
EOSQL
