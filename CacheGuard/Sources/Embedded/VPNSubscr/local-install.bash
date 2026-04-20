#!/bin/bash

source /tmp/CacheGuard.env

vpnsubscr-create-db()
{
    local schema_file=/tmp/${EMBEDDED_VPNSUBSCR_DB_SCHEMA}

    sqlite3 ${EMBEDDED_VPNSUBSCR_DB_FILE} < ${schema_file}

    chown filter ${EMBEDDED_VPNSUBSCR_DB_FILE}
    chmod 640 ${EMBEDDED_VPNSUBSCR_DB_FILE}
    chown filter ${WEB_DB_DIR}/${EMBEDDED_APPLICATIONS_NAME}
}

vpnsubscr-init-db()
{
    test -f ${EMBEDDED_VPNSUBSCR_DB_FILE} || return 11

    local tmp_file=/tmp/vpnsubscr-init-db-${$}.sql
    local username=admin password
    local dummy

    for dummy in dummy
    do
	echo "INSERT INTO setup( service_name, previous_service_name ) VALUES ( '${DEFAULT_CA_CN}', '${DEFAULT_CA_CN}' );"
	echo "INSERT INTO email( id ) VALUES ( 0 );"
	echo "INSERT INTO administrator( username, password ) VALUES( '${username}', '${password}' );"
    done > ${tmp_file}

    sqlite3 ${EMBEDDED_VPNSUBSCR_DB_FILE} < ${tmp_file}

    rm -f ${tmp_file}
}

install-embedded-application()
{
    local name=${EMBEDDED_VPNSUBSCR_NAME}

    cd ${WEB_SERVER_DIR}/${EMBEDDED_APPLICATIONS_NAME}
    tar xf /tmp/${name}.tar.gz
}

main()
{
    vpnsubscr-create-db
    vpnsubscr-init-db

    install-embedded-application
}

# Main()

main
