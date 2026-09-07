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

test-ldap-auth()
{
    test -n "${1}" || return 1
    local login=${1}
    local password=${2}

    local tmp_file=/tmp/authenticate-ldap-test.${$}

    execute-command-with-output "authenticate ldap test ${login} ${password}" > ${tmp_file}

    echo "<div class='diagnostic-tools-msg'><pre>"
    cat ${tmp_file}
    echo "</pre></div>"

    rm -f ${tmp_file}
}


LOG=/dev/null
LDAP_ARGS=${@//\\\&/ }
gui-run-authentication
test-ldap-auth ${LDAP_ARGS}
