#!/bin/bash

###########################################################################
#
# MODULE:       GUI
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

show-tls-report-line()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 1
    test -n "${3}" || return 1
    local id=${1}
    local end_epoch=${2}
    local state=${3}

    local end_date=$(printf "%(%Y/%m/%d - %H:%M:%S)T" ${end_epoch} 2>/dev/null)

    echo "<tr>"
    echo "<td align='left'>${id}</td>"
    echo "<td align='left'>${end_date}</td>"

    if test "${state}" == OK ; then
        echo "<td align='center'><img src='/image/ok.png' /></td>"
    else
        echo "<td align='center'><img src='/image/ko.png' title='KO' /></td>"
    fi

    echo "</tr>"
}

show-tls-report()
{
    local table_width=${1}
    test -n "${table_width}" || table_width="405"

    echo "<div class='core-form'>"
    echo "<table class='highlight-list' width='${table_width}'>"

    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header indicator-table-header' align='center'>TLS ID</td>"
    echo "<td class='table-header' width='130' align='center'>Expiry Date</td>"
    echo "<td class='table-header' width='40' align='center'>State</td>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    local tls end_epoch state

    if gui-contextual-is-allowed ; then
	if test -f ${RUN_DIR}/${TLS_SYSTEM_CA_STATE_FILENAME} ; then
	    read tls end_epoch state < ${RUN_DIR}/${TLS_SYSTEM_CA_STATE_FILENAME}
	    show-tls-report-line "[SYSTEM CA]" ${end_epoch} ${state}
	fi

	if test -f ${RUN_DIR}/${TLS_THIRD_CA_STATE_FILENAME} ; then
	    while read tls end_epoch state
	    do
		show-tls-report-line "[THIRD CA] ${tls}" ${end_epoch} ${state}
	    done < ${RUN_DIR}/${TLS_THIRD_CA_STATE_FILENAME}
	fi
    fi

    if test -f ${RUN_DIR}/${TLS_SERVER_STATE_FILENAME} ; then
	while read tls end_epoch state
	do
	    show-tls-report-line "[SERVER] ${tls}" ${end_epoch} ${state}
	done < ${RUN_DIR}/${TLS_SERVER_STATE_FILENAME}
    fi

    if gui-contextual-is-allowed ; then
	if test -f ${RUN_DIR}/${TLS_CLIENT_STATE_FILENAME} ; then
	    while read tls end_epoch state
	    do
		show-tls-report-line "[CLIENT] ${tls}" ${end_epoch} ${state}
	    done < ${RUN_DIR}/${TLS_CLIENT_STATE_FILENAME}
	fi
    fi

    echo "</tbody>"
    echo "</table>"
    echo "</div>"
}

tls-report()
{
    show-title "TLS Certificates Health" "disabled" "tls"
    execute-command "tls report"
    show-tls-report 500
}

# Main()

tls-report
