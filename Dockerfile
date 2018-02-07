# Backup and restore service for the rubyjobs.ru project.

FROM debian:stretch

LABEL maintainer="Alexander Sulim <hello@sul.im>" \
      version="0.1.0"

# Install dependencies:
# - ca-certificates: Certificates are necessary for AWS CLI.
# - cron: Cron is used to regulary run the backup script.
# - curl: A temporary dependency. It is used to download AWS CLI archive.
# - postgresql-client-9.6: Main tools to interact with PostgreSQL.
# - python: Python is necessary for AWS CLI.
# - unzip: A temporary dependency. It is used to extract AWS CLI from archive.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                       ca-certificates \
                       cron \
                       curl \
                       postgresql-client-9.6 \
                       python \
                       unzip && \
    curl https://s3.amazonaws.com/aws-cli/awscli-bundle.zip \
         --remote-name && \
    unzip awscli-bundle.zip && \
    awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
    rm awscli-bundle.zip && \
    rm -rf awscli-bundle/ && \
    apt-get purge -y \
            curl \
            unzip && \
    apt-get autoremove -y && \
    apt-get clean

COPY bin/* /usr/local/bin/

# TODO: Change to hourly schedule.
# Configure cron to run the backup routine on regular basis.
RUN echo "* * * * * /usr/local/bin/backup > /proc/1/fd/1 2>/proc/1/fd/2" | crontab

ENV HOME=/root
WORKDIR $HOME

ENTRYPOINT ["docker-entrypoint.sh"]

# Run cron in foreground.
CMD ["cron", "-f"]
