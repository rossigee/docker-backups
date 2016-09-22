# Dockerfile utilities for backups and restores

Expects the following environment variables to be set:

Variable | Notes
-------- | -----
PASSPHRASE | The GnuPG passphrase to use to encrypt/decrypt the backup
AWS_ACCESS_KEY_ID | Amazon AWS access key
AWS_SECRET_ACCESS_KEY | Amazon AWS secret key
S3_LOCATION | The S3 URI to store/retrieve the backup to, with trailing slash (e.g. '<tt>s3://mybucket/sqlbackups/</tt>')

By default, with no arguments, the container will return a usage warning.

# Dockerfile for mysql backups

Expects the following environment variables to be set:

Variable | Notes
-------- | -----
MYSQL_HOST | MySQL server to connect to
MYSQL_PORT | MySQL server port to connect to
MYSQL_NAME | MySQL database name to dump
MYSQL_USER | MySQL username to connect as
MYSQL_PASS | MySQL password to use for authentication

Usage:

    docker run -ti exec backupcontainer backup-db

    docker run -ti exec backupcontainer restore-db s3://bucket/snapshot.sql.gz

If successful, the size (in bytes) of the backup file is reported on standard output.


# Dockerfile for postgresql backups

Expects the following environment variables to be set:

Variable | Notes
-------- | -----
PGSQL_HOST | MySQL server to connect to
PGSQL_PORT | MySQL server port to connect to
PGSQL_NAME | MySQL database name to dump
PGSQL_USER | MySQL username to connect as
PGSQL_PASS | MySQL password to use for authentication

Usage:

    docker run -ti exec backupcontainer backup-pgsql

    docker run -ti exec backupcontainer restore-pgsql s3://bucket/snapshot.sql.gz


# Dockerfile for volume backups

Expects the following environment variables to be set:

Variable | Notes
-------- | -----
BACKUP_DIR | Directory to be backed up

By default, with no arguments, the container will return a usage warning.

    docker run -ti exec backupcontainer backup-vol

    docker run -ti exec backupcontainer restore-vol s3://bucket/snapshot.sql.gz


## Backing up a data volume

Simply run the 'backup' script in the container.

Something like this:

    docker run -ti --rm \
        -e BACKUP_NAME=foobar \
        -e BACKUP_DIR=/data \
        -e PASSPHRASE="reallycomplicatedpassphrase" \
        -e AWS_ACCESS_KEY_ID=AKIAyourkeyhere \
        -e AWS_SECRET_ACCESS_KEY=biglongrandomsecretkeyhere \
        -e S3_LOCATION=s3://mybucket/backups/ \
        rossg/backups \
        backup-vol

(or use an environment file, perhaps on a volume containing environment files for different backups)

## Restoring a data volume

You need to specify the S3 URL of the backup to be restored as an argument to the 'restore' script.

Something like this:

    docker run -ti --rm \
        -e BACKUP_NAME=foobar \
        -e RESTORE_DIR=/data \
        -e PASSPHRASE="reallycomplicatedpassphrase" \
        -e AWS_ACCESS_KEY_ID=AKIAyourkeyhere \
        -e AWS_SECRET_ACCESS_KEY=biglongrandomsecretkeyhere \
        -e S3_LOCATION=s3://mybucket/backups/ \
        rossg/backups \
        restore-vol s3://mybucket/backups/foobar-20120101010101.tar.gpg


## Backing up a database

Simply run the 'backup' script in the container.

Something like this:

    docker run -ti --rm \
        -e MYSQL_HOST=db \
        -e MYSQL_PORT=3306 \
        -e MYSQL_NAME=mydb \
        -e MYSQL_USER=myuser \
        -e MYSQL_PASS=mypass \
        -e PASSPHRASE="reallycomplicatedpassphrase" \
        -e AWS_ACCESS_KEY_ID=AKIAyourkeyhere \
        -e AWS_SECRET_ACCESS_KEY=biglongrandomsecretkeyhere \
        -e S3_LOCATION=s3://mybucket/backups/ \
        rossg/backups \
        backup-db


## Restoring a database

You need to specify the S3 URL of the backup to be restored as an argument to the 'restore' script.

Something like this:

    docker run -ti --rm \
        -e MYSQL_HOST=db \
        -e MYSQL_PORT=3306 \
        -e MYSQL_NAME=mydb \
        -e MYSQL_USER=myuser \
        -e MYSQL_PASS=mypass \
        -e PASSPHRASE="reallycomplicatedpassphrase" \
        -e AWS_ACCESS_KEY_ID=AKIAyourkeyhere \
        -e AWS_SECRET_ACCESS_KEY=biglongrandomsecretkeyhere \
        -e S3_LOCATION=s3://mybucket/backups/ \
        rossg/backups \
        restore-db s3://mybucket/backups/mydb-20120101010101.sql.gpg


## Scheduling regular backups

Still not sure yet. Options to explore are to use Jenkins or Drone to trigger some kind of running of this container on a regular basis. Otherwise, perhaps a scheduler container running 'crond' that runs this container regularly. Or extend this container to include a scheduling daemon.

PRs welcome :)
