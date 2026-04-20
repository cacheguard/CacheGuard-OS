#!/bin/bash

###########################################################################
#
# MODULE:       Patch
# AUTHOR(S):    CacheGuard Development Team
# COPYRIGHT:    (C) 2009-2025 by CacheGuard Technologies Ltd
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

CACHEGUARD_DIR=/etc/sysconfig/cacheguard
source ${CACHEGUARD_DIR}/constant

patch-initrd()
{
    apl_update_initrd grub
}

update-vpnsubscr-db()
{
    local db_file=${EMBEDDED_VPNSUBSCR_DB_FILE}

    sqlite3 ${db_file} "SELECT mfa_state from administrator WHERE username = '${ADMIN_NAME}';" > /dev/null 2>&1
    test ${?} -ne 0 || return 0

    sqlite3 ${db_file} << EOFSQL
ALTER TABLE administrator ADD mfa_state TINYINT DEFAULT 0;
ALTER TABLE administrator ADD mfa_secret VARCHAR(128) DEFAULT '';

CREATE TABLE IF NOT EXISTS mfa_timestamp (
    username VARCHAR(32) NOT NULL,
    step_time INT(6) DEFAULT 0,
    PRIMARY KEY (username, step_time)
    );

CREATE TABLE IF NOT EXISTS mfa_emergency (
    username VARCHAR(32) NOT NULL,
    code VARCHAR(8) DEFAULT '00000000',
    PRIMARY KEY (username, code)
    );

EOFSQL
}

main()
{
    patch-initrd
    update-vpnsubscr-db
}

main
