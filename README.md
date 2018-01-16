# Backup and restore service for the rubyjobs.ru project

The service provides two scripts - `backup` and `restore`. The `backup` script
makes a dump of the database (PostgreSQL), compresses it, and then sends to
AWS S3 storage. The `restore` script can restore any dump file located
on AWS S3.

The service is ment to be ran as a Docker container. Inside the container
the backup routine is executed on hourly basis using cron scheduler.

Copyright (c) 2018 Alexander Sulim
