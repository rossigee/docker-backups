#!/bin/bash

if [ -n "$MYSQL_HOST" ]; then
    echo "Configuring MySQL client settings..."
    cat >$HOME/.my.cnf <<EOF
[client]
host=$MYSQL_HOST
port=$MYSQL_PORT
user=$MYSQL_USER
password=$MYSQL_PASS
EOF
    chmod 400 $HOME/.my.cnf
fi

if [ -n "$PGSQL_HOST" ]; then
    echo "Configuring PostGresQL client settings..."
    cat >$HOME/.pgpass <<EOF
$PGSQL_HOST:5432:$PGSQL_NAME:$PGSQL_USER:$PGSQL_PASS
EOF
    chmod 400 $HOME/.pgpass
fi

# Warning fix...
[ ! -d ~/.gnupg ] && mkdir ~/.gnupg && touch ~/.gnupg/gpg.conf

exec "$@"
