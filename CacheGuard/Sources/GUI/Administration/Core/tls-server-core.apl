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

print-revoke-reasons()
{
    echo -n "keyCompromise CACompromise affiliationChanged superseded cessationOfOperation unspecified cancelRevocation"
}

show-rweb-tls()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local not_available_label='n/a'
    local width=650
    local state tls serial revoke
    local max_tls_nb

    itemWidth[1]=35

    itemTitle[0]=""
    itemTitle[1]="Identifier"
    itemTitle[2]="Serial"
    itemTitle[3]="Revoke Status"

    itemForm[2]="text"
    itemForm[3]="select:blank"

    itemID[0]="TLS"
    itemID[1]="tls"
    itemID[2]="serial"
    itemID[3]="status"
    
    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='${MAX_NAME_LEN}' maxlength='${MAX_NAME_LEN}'"
    blankItemContent[3]=$(print-revoke-reasons)

    checkItem[1]=identifier

    editColumnPage[0]="tls-server-generate"
    editColumnPage[1]="tls-server-manage"

    editColumnTitle[0]="Generate"
    editColumnTitle[1]="Manage"
    
    unset listContent

    for tls in ${TLS_SERVER_LIST}
    do
	if test -f ${SSL_SERVER_DIR}/${tls}.serial ; then
	    serial="0x$(cat ${SSL_SERVER_DIR}/${tls}.serial 2> /dev/null)"
	    if test -f ${TMP_DIR}/${TLS_SERVER}.${tls}.2rev ; then
		revoke=$(cat ${TMP_DIR}/${TLS_SERVER}.${tls}.2rev 2> /dev/null)
	    elif test -f ${SSL_SERVER_DIR}/${tls}.revoked ; then
		revoke=$(cat ${SSL_SERVER_DIR}/${tls}.revoked 2> /dev/null)
	    else
		revoke='active'
	    fi
	else
	    serial="${not_available_label}"
	    if test -f ${TMP_DIR}/${TLS_SERVER}.${tls}.2rev ; then
		revoke=$(cat ${TMP_DIR}/${TLS_SERVER}.${tls}.2rev 2> /dev/null)
	    else
		revoke="${not_available_label}"
	    fi
	fi

	listContent="${listContent} ${tls} ${serial} ${revoke}"
    done
    listContent=${listContent:1}
    listContentStep=3

    test -n "${listContent}" || state=disabled

    if test ${APL_ROLE} == manager -a -z "${GUI_CONTEXT}" ; then
	max_tls_nb=8
    else
	max_tls_nb=$(gui-get-contextual-rweb-nb)
	((max_tls_nb *= TLS_NB_FACTOR))
    fi

    show-title "Server Certificates" "${state}" "tls rweb admin"
    show-list-form ${max_tls_nb} ${width} "${page_ref}"
}

# Main()

show-rweb-tls "${@}"
