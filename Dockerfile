# Backup and restore service for the rubyjobs.ru project.

FROM debian:stretch

LABEL maintainer="Alexander Sulim <hello@sul.im>" \
      version="0.1.0"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                       ca-certificates \
                       cron \
                       curl \
                       postgresql-client \
                       python \
                       unzip

RUN curl https://s3.amazonaws.com/aws-cli/awscli-bundle.zip \
         --remote-name && \
    unzip awscli-bundle.zip && \
    awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
    rm awscli-bundle.zip && \
    rm -rf awscli-bundle/

RUN apt-get purge -y \
            curl \
            unzip && \
    apt-get autoremove -y && \
    apt-get clean

ENV HOME=/root
WORKDIR $HOME

COPY docker-entrypoint.sh /usr/local/bin/
COPY bin/* /usr/local/bin/

RUN echo "@hourly /usr/local/bin/backup > /root/backup.log" | crontab

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bash"]
