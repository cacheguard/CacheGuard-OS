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

show-system-list()
{
    local in_system=${1}
    local system selected

    for system in android apple linux windows
    do
	selected=$(get-selected-option ${system} "${in_system}")
	echo -n "<option value='${system}'${selected}>${system}</option>"
    done
}

show-vpnipsec-access-conf()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    test -n "${4}" || return 4
    local width=${1}
    local system_id=${2}
    local tls_id=${3}
    local content_id=${4}
    local tls_state=${5}

    echo "<div style='clear:left;'></div><br />"

    if test -n "${tls_state}" ; then
	echo-content-unavailable ${width} "No client certificate is present on this system."
	return 0
    fi

    echo "<div class='table-title'>IPsec VPN Access Configuration</div>"
    echo "<div id='${content_id}'></div>"

    call-js-function "IPsecVPNAccessConfSelectCB( '${system_id}', '${tls_id}', '/${GUI_DIR_NAME}/vpnipsec-access-conf-print.${GUI_EXT_NAME}', '${content_id}' )"
}

show-vpnipsec-access-conf-form()
{
    local state width=550
    local tls_clients file_servers tls_state
    local psk i=0

    local system_id='system'
    local tls_id='tls'
    local content_id='vpnipsec_access_conf'
    local protocol_id='protocol' style protocol
    local server_id='server'
    local target_id='target_title' target_title
    local name_id='name'

    itemWidth[0]=25
    itemWidth[1]=75

    test ${CURRENT_VPN_IPSEC_AUTHENTICATE} != psk || psk=yes

    itemTitle[${i}]="Client System"
    itemID[${i}]="${system_id}"
    itemForm[${i}]="select"
    blankItemContent[${i}]="$(show-system-list ${VALUES[${i}]})"
    itemFormSelectCB[${i}]="IPsecVPNAccessConfSelectCB( '${system_id}', '${tls_id}', '/${GUI_DIR_NAME}/vpnipsec-access-conf-print.${GUI_EXT_NAME}', '${content_id}' );"
    ((i++))

    if test -z "${psk}" ; then
	tls_clients=$(show-tls-client-list ${VALUES[${i}]})
	if test -z "${tls_clients}" ; then
	    tls_state=ko
	    state=disabled
	fi
	itemTitle[1]="Client TLS Identifier"
	itemID[${i}]="${tls_id}"
	itemForm[${i}]="select"
	blankItemContent[${i}]=${tls_clients}
	itemFormSelectCB[${i}]="IPsecVPNAccessConfSelectCB( '${system_id}', '${tls_id}', '/${GUI_DIR_NAME}/vpnipsec-access-conf-print.${GUI_EXT_NAME}', '${content_id}' );"
	((i++))
    fi

    itemTitle[${i}]="Protocol"
    itemID[${i}]=${protocol_id}
    itemForm[${i}]="select"
    protocol=${VALUES[${i}]:1}
    blankItemContent[${i}]=$(show-file-protocol1 "${protocol}" "sftp tftp ftp smtp")
    itemFormSelectCB[${i}]="accessIPsecVPNProtocolSelectCB( '${protocol_id}', '${server_id}', '${name_id}', '${target_id}' );"
    ((i++))

    file_servers=$(show-file-servers 'cur' ${VALUES[${i}]})
    test -n "${file_servers}" || state=disabled
    itemTitle[${i}]="File Server"
    itemID[${i}]=${server_id}
    itemForm[${i}]="select"
    blankItemContent[${i}]=${file_servers}
    ((i++))

    case ${protocol} in
	smtp)
	    unset style
	    target_title="Receiver Email"
	    ;;
	*)
	    target_title="File Path"
	    style=" style='${GUI_READONLY_STYLE}'"
	    ;;
    esac

    itemTitleId[${i}]=${target_id}
    itemTitle[${i}]=${target_title}
    itemID[${i}]="target"
    checkItem[${i}]=printable
    blankItemContent[${i}]="type='text' size='48' maxlength='128' value='${VALUES[${i}]}'"
    ((i++))

    itemTitle[${i}]="Receiver Name"
    itemID[${i}]=${name_id}
    blankItemContent[${i}]="type='text' size='32' maxlength='${MAX_LEN}' value='${VALUES[${i}]}'${style}"
    ((i++))

    i=0

    if test -z "${psk}" ; then
	shortcutMenuItem[${i}]="tls-client"
	shortcutMenuTitle[${i}]="Client Certificates"
	((i++))
    fi

    shortcutMenuItem[${i}]="email"
    shortcutMenuTitle[${i}]="Email Account"
    ((i++))

    shortcutMenuItem[${i}]="access-file"
    shortcutMenuTitle[${i}]="File Servers"
    ((i++))

    shortcutMenuItem[${i}]="password-file"
    shortcutMenuTitle[${i}]="Accounts"
    ((i++))

    show-title "Show, Save or Email IPsec VPN Access Configuration" "${state}" "access email password vpnipsec"
    show-shortcuts-menu
    show-form "${width}" "${state}" "show-vpnipsec-access-conf ${width} ${system_id} ${tls_id} ${content_id} ${tls_state}"
}

# Main()

show-vpnipsec-access-conf-form "${@}"
