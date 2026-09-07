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
    local system_id=${1}
    local tls_id=${2}
    local content_id=${3}
    local tls_state=${4}

    if test -n "${tls_state}" ; then
	echo-unavailable-message "no client certificate is present on this system."
	return 0
    fi

    echo "<div class='table-title'>IPsec VPN Access Configuration</div>"
    echo "<div id='${content_id}'></div>"
    echo "<div data-show-ipsec-access-conf data-system-id='${system_id}' data-tls-id='${tls_id}' data-content-id='${content_id}' hidden></div>"
}

show-vpnipsec-access-conf-form()
{
    local state width=550
    local tls_clients file_servers tls_state
    local psk i=0

    local system_id='system'
    local tls_id='tls'
    local content_id='profile'
    local protocol_id='protocol' class protocol
    local server_id='server'
    local target_id='target-title' target_title
    local name_id='name'

    itemWidth[0]=25
    itemWidth[1]=75

    test ${CURRENT_VPN_IPSEC_AUTHENTICATE} != psk || psk=yes

    itemTitle[${i}]="Client System"
    itemID[${i}]="${system_id}"
    itemForm[${i}]="select"
    blankItemContent[${i}]="$(show-system-list ${VALUES[${i}]})"
    itemData[${i}]="data-action='ipsec-vpn-access-conf' data-system-id='${system_id}' data-tls-id='${tls_id}' data-content-id='${content_id}'"

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
	itemData[${i}]="data-action='ipsec-vpn-access-conf' data-system-id='${system_id}' data-tls-id='${tls_id}' data-content-id='${content_id}'"
	((i++))
    fi

    itemTitle[${i}]="Protocol"
    itemID[${i}]=${protocol_id}
    itemForm[${i}]="select"
    protocol=${VALUES[${i}]:1}
    blankItemContent[${i}]=$(show-file-protocol1 "${protocol}" "sftp tftp ftp smtp")
    itemData[${i}]="data-action='access-ipsec-vpn-protocol' data-protocol-id='${protocol_id}' data-server-id='${server_id}' data-name-id='${name_id}' data-target-id='${target_id}'"

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
	    unset class
	    target_title="Receiver Email"
	    ;;
	*)
	    target_title="File Path"
	    class=" class='read-only'"
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
    blankItemContent[${i}]="type='text' size='32' maxlength='${MAX_LEN}' value='${VALUES[${i}]}'${class}"
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
    show-form "${width}" "${state}" "show-vpnipsec-access-conf ${system_id} ${tls_id} ${content_id} ${tls_state}"
}

# Main()

show-vpnipsec-access-conf-form "${@}"
