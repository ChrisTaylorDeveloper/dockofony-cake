# Dockofony Cake
Run CakePHP inside Docker, which can be useful for local development.  Also, take advantage of CakePHP's ability to scaffold an app from just a database schema.

## Instructions
1. Copy `.env.sample` to `.env` and provide a value for each variable.
1. Run `docker compose up -d`
1. Enter the cake container with `docker compose exec cake bash`
1. Install CakePHP with `composer create-project --prefer-dist cakephp/app:~5.0 app`
1. Make a Git repo out of `VOLUME_CAKE` and commit everything.
1. Set database credentials in `app/config/app_local.php` to match the values in `.env`.  Remember, host will be `db`.
1. Vist your app at `http://localhost:<value of PORT_HOST_CAKE>`.

## CakePHP folder permissions.
If you experience permission issues, run these commands, from either inside or outside of the cake service.

From inside the cake container:
```
setfacl -R -m u:www-data:rwx app/tmp
setfacl -R -d -m u:www-data:rwx app/tmp
setfacl -R -m u:www-data:rwx app/logs
setfacl -R -d -m u:www-data:rwx app/logs
```

From the host:
```
docker compose exec cake setfacl -R -m u:www-data:rwx app/tmp
docker compose exec cake setfacl -R -d -m u:www-data:rwx app/tmp
docker compose exec cake setfacl -R -m u:www-data:rwx app/logs
docker compose exec cake setfacl -R -d -m u:www-data:rwx app/logs
```

## Scaffold the CakePHP CRUD
CakePHP makes it easy to create CRUD for your app from just a database schema.  The process below uses schema file `example-db.sql`.  

You will need to have the `mysql` cli tool available on your host.  If you don't, run the `mysql` commands in `scaffold.sh` with another MySQL client.

1. Run the script below directly on your host, swapping the placeholders for your own values.  This script will clean-up from any previous run and re-create your CRUD.
```
./scaffold.sh <path/to/cake> <mysql user> <mysql user pass> 127.0.0.1 <mysql host port> <db name>
```
2. Take a look a your app by browsing to the following urls `http://localhost<port num>/articles`, `http://localhost:<port num/users`, `http://localhost:<port num/tags`
3. Edit the schema in `example-db.sql` to your liking.
4. Run the script again.

