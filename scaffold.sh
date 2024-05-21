#!/bin/bash

# Make yourself owner of all the files.
sudo chown -R "${USER}":"${USER}" "$1"

# If you've made a git repo, reset everything from the previous run.
# git -C "$1" checkout -- .
# git -C "$1" clean -fd

# Apply the fine-grain file permissions as recommended by CakePHP.
docker compose exec cake setfacl -R -m u:www-data:rwx app/tmp
docker compose exec cake setfacl -R -d -m u:www-data:rwx app/tmp
docker compose exec cake setfacl -R -m u:www-data:rwx app/logs
docker compose exec cake setfacl -R -d -m u:www-data:rwx app/logs

# (re)Make an empty database.
mysql -u "$2" -p"$3" -h "$4" -P "$5" -e "drop database if exists $6; create database $6"

# Import your database table definitions.
mysql -u "$2" -p"$3" -h "$4" -P "$5" "$6" < ./example-db.sql

# Finally, Bake all CRUD for all tables.
docker compose exec cake app/bin/cake bake all --everything
