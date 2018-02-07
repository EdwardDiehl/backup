#!/usr/bin/env sh

set -o errexit    # always exit on error
set -o nounset    # fail on unset variables

# Make a copy of the user environment. It is loaded later in the backup script
# because the cron user does really limited environment, but AWS credentials
# must be available there.
touch /root/.env
echo "AWS_S3_BUCKET=$AWS_S3_BUCKET" >> /root/.env
echo "PGHOST=$PGHOST" >> /root/.env
echo "PGPORT=$PGPORT" >> /root/.env
echo "PGUSER=$PGUSER" >> /root/.env
echo "PGDATABASE=$PGDATABASE" >> /root/.env
chmod 0600 /root/.env

# The file .pgpass in a user's home directory can contain passwords to be used
# if the connection requires a password.
# https://www.postgresql.org/docs/current/static/libpq-pgpass.html
echo "$PGHOST:$PGPORT:$PGDATABASE:$PGUSER:$PGPASSWORD" > /root/.pgpass
chmod 0600 /root/.pgpass

# Store AWS credentials in a file. For some reason AWS CLI does not recognize
# AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables anymore.
mkdir -p /root/.aws
echo "[default]" > /root/.aws/credentials
echo "aws_access_key_id=$AWS_ACCESS_KEY_ID" >> /root/.aws/credentials
echo "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> /root/.aws/credentials
chmod -R 0600 /root/.aws

exec "$@"
