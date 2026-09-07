#!/bin/bash

###########################################################################
#
# MODULE:       GUI
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

source functions

show-kerberos-keytab()
{
    local kvno service enc

    execute-command-with-output "authenticate kerberos report keytab"

    if test ! -s /var/run/${KERBEROS_KEYTAB_FILENAME} ; then
	echo "<div class='diagnostic-tools-msg'><i>&lt;empty table&gt;</i></div>"
	return 0
    fi

    echo "<table class='highlight-report'>"

    echo "<thead><tr>"
    echo "<th class='table-header'>KVNO</th>"
    echo "<th class='table-header'>HTTP Service Name</th>"
    echo "<th class='table-header'>Encryption Type</th>"
    echo "</tr></thead>"

    echo "<tbody>"

    while read kvno service enc
    do
	echo "<tr><td>${kvno}</td><td>${service}</td><td>${enc}</td></tr>"
    done < /var/run/${KERBEROS_KEYTAB_FILENAME}

    echo "</tbody>"
    echo "</table>"
}

LOG=/dev/null
gui-run-authentication
show-kerberos-keytab "${@}"
