#!/usr/bin/env sh

set -o errexit    # always exit on error
set -o nounset    # fail on unset variables

# Make a copy of the user environment. It is loaded later in the backup script
# because the cron user does really limited environment, but AWS credentials
# must be available there.
env > /root/env

# Cron deamon does not start automatically for some reason when the container
# boots up.
service cron start

exec "$@"
