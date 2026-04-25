#!/bin/bash

###########################################################################
#
# MODULE:       Build
# AUTHOR(S):    CacheGuard Development Team
# COPYRIGHT:    (C) 2009-2025 by CacheGuard Technologies Ltd (UK)
# COPYRIGHT:    (C) 2026-2026 by CacheGuard Technologies SAS (FR)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
###########################################################################

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
