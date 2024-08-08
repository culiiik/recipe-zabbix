#!/bin/bash

set -o pipefail
set -e

export PGPASSWORD=${pgdb_password}

INIT_DONE=$(psql -h pgdb -U pgdb pgdb -t -c "SELECT 1 FROM pg_database WHERE datname = 'zabbix';"|tr -d '[:blank:]')

if [[ ${INIT_DONE} -ne 1 ]]; then
        echo "Zabbic DB init"
        psql -h pgdb -U pgdb pgdb -t -c "CREATE DATABASE zabbix;"
        sudo zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo psql -h pgdb -U pgdb -d zabbix
fi