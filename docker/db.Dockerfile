FROM postgres:18.4

RUN apt-get update && apt-get install -y postgresql-18-cron