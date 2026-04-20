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

show-optional-tls-server-list()
{
    echo "<option value=''></option>"
    show-tls-server-list ${@}
}

show-ocsp-days()
{
    local days=${1}

    local i max=31

    for ((i=1 ; i<=max ; i++))
    do
	selected=$(get-selected-option ${i} ${days})
	echo -n "<option value='${i}' id='${i}'${selected}>${i}</option>"
    done
}

show-tls-ocsp-etc()
{
    local tls_id=${ADMIN_TLS/:*}
    local ca_id

    if mono-elt ${ADMIN_TLS//:/ } ; then
	unset ca_id
    else
	ca_id=${ADMIN_TLS/*:}
    fi

    local width=400 i=0

    itemWidth[0]=50
    itemWidth[1]=50

    itemTitle[${i}]="Web GUI & SNMP TLS Object" ; ((i++))
    itemTitle[${i}]="Web GUI Intermediate CA" ; ((i++))

    i=0
    itemID[${i}]="admin_tls" ; ((i++))
    itemID[${i}]="admin_ca" ; ((i++))

    i=0
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))

    i=0
    blankItemContent[${i}]=$(show-tls-server-list ${tls_id}) ; ((i++))
    blankItemContent[${i}]=$(show-tls-ca-list ${ca_id}) ; ((i++))

    i=0
    checkItem[${i}]=identifier ; ((i++))
    checkItem[${i}]=identifier ; ((i++))

    if gui-contextual-is-allowed ; then

	itemTitle[${i}]="PKI Server Certificates Validity Days" ; ((i++))
	itemTitle[${i}]="PKI Client Certificates Validity Days" ; ((i++))
	itemTitle[${i}]="OCSP Responder Network Name" ; ((i++))
	itemTitle[${i}]="OCSP Responder Port Number" ; ((i++))
	itemTitle[${i}]="OCSP Responses Validity Days" ; ((i++))
	itemTitle[${i}]="TLS to Sign/Check OCSP Responses" ; ((i++))
	itemTitle[${i}]="LDAPS Verification CA Certificate" ; ((i++))
	itemTitle[${i}]="SysLog over SSL Verification CA Certificate" ; ((i++))

	i=2
	itemID[${i}]="tls_days" ; ((i++))
	itemID[${i}]="tls_client_days" ; ((i++))
	itemID[${i}]="tls_ocsp_host" ; ((i++))
	itemID[${i}]="port_ocsp" ; ((i++))
	itemID[${i}]="tls_ocsp_days" ; ((i++))
	itemID[${i}]="tls_ocsp_tls" ; ((i++))
	itemID[${i}]="ldaps_ca" ; ((i++))
	itemID[${i}]="syslog_ca" ; ((i++))

	i=2
	itemForm[${i}]="input" ; ((i++))
	itemForm[${i}]="input" ; ((i++))
	itemForm[${i}]="input" ; ((i++))
	itemForm[${i}]="input" ; ((i++))
	itemForm[${i}]="select" ; ((i++))
	itemForm[${i}]="select" ; ((i++))
	itemForm[${i}]="select" ; ((i++))
	itemForm[${i}]="select" ; ((i++))

	i=2
	blankItemContent[${i}]="type='text' size='8' maxlength='8' value='${TLS_SERVER_DAYS}'" ; ((i++))
	blankItemContent[${i}]="type='text' size='8' maxlength='8' value='${TLS_CLIENT_DAYS}'" ; ((i++))
	blankItemContent[${i}]="type='text' size='32' maxlength='64' value='${OCSP_HOST}'" ; ((i++))
	blankItemContent[${i}]="type='text' size='5' maxlength='5' value='${OCSP_PORT}'" ; ((i++))
	blankItemContent[${i}]=$(show-ocsp-days ${OCSP_DAYS}) ; ((i++))
	blankItemContent[${i}]=$(show-optional-tls-server-list ${OCSP_TLS}) ; ((i++))
	blankItemContent[${i}]=$(show-tls-ca-list ${LDAPS_CA}) ; ((i++))
	blankItemContent[${i}]=$(show-tls-ca-list ${SYSLOG_CA}) ; ((i++))

	i=2
	checkItem[${i}]=digit ; ((i++))
	checkItem[${i}]=digit ; ((i++))
	checkItem[${i}]=domainname ; ((i++))
	checkItem[${i}]=digit ; ((i++))
	checkItem[${i}]=digit ; ((i++))
	checkItem[${i}]=identifier ; ((i++))
	checkItem[${i}]=identifier ; ((i++))
	checkItem[${i}]=identifier ; ((i++))

	shortcutMenuItem[0]="port"
	shortcutMenuTitle[0]="Listening Ports"
    fi

    show-title "Other TLS Settings" "enabled" "admin authenticate port tls"
    show-shortcuts-menu
    show-form "${width}"
}

# Main()

show-tls-ocsp-etc
