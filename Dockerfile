FROM ubuntu:xenial
MAINTAINER Ross Golder <ross@golder.org>

# Set terminal to be noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Put main packages in place
RUN sed -i 's/deb-src/# deb-src/' /etc/apt/sources.list
RUN apt-get update && \
    apt-get upgrade -y -f && \
    apt-get install --no-install-recommends -y --allow-unauthenticated \
        curl git awscli zip unzip rsync awscli gnupg2 mariadb-client vim \
        postgresql-client-9.5 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Run the script that does the work
COPY bin/* /usr/local/bin/
RUN chmod 755 \
    /usr/local/bin/backup-db \
    /usr/local/bin/backup-pgsql \
    /usr/local/bin/backup-vol \
    /usr/local/bin/restore-db \
    /usr/local/bin/restore-vol \
    /usr/local/bin/restore-pgsql
