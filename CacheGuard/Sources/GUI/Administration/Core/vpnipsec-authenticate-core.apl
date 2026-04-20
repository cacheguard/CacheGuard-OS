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

source vpnipsec-common.${GUI_EXT_NAME}

select-vpnipsec-authenticate()
{
    local method_id=${1}
    local auto_psk_id=${2}
    local psk_id=${3}
    local tls_id_id=${4}
    local used_id_id=${5}

    call-js-function "VPNIPsecAuthenticateSelectCB( '${method_id}', '${auto_psk_id}', '${psk_id}', '${tls_id_id}', '${used_id_id}' )"
}

show-used-identifier()
{
    local in_value=${1}
    local values="fqdn dn"

    local selected value

    for value in ${values}
    do
	selected=$(get-selected-option ${value} "${in_value}")
	echo "<option value='${value}'${selected}>${value}</option>"
    done
}

show-vpnipsec-authenticate()
{
    local width=600 i=0
    local method_id=method psk_id=psk auto_psk_id=auto_psk tls_id_id=tls used_id_id=used_id
    local tls tls_id used_id

    local nat_ip_tip="Comma separated public IPs"
    local nat_ip_tip_width=250

    itemWidth[0]=30
    itemWidth[1]=70

    i=0
    itemTitle[${i}]="Authentication Method" ; ((i++))
    itemTitle[${i}]="Auto Generate PSK" ; ((i++))
    itemTitle[${i}]="Pre Shared Key (PSK)" ; ((i++))
    itemTitle[${i}]="TLS Certificate Identifier" ; ((i++))
    itemTitle[${i}]="Used Identifier" ; ((i++))
    itemTitle[${i}]="Behind NAT IP(s)" ; ((i++))

    i=0
    itemID[${i}]="${method_id}" ; ((i++))
    itemID[${i}]="${auto_psk_id}" ; ((i++))
    itemID[${i}]="${psk_id}" ; ((i++))
    itemID[${i}]="${tls_id_id}" ; ((i++))
    itemID[${i}]="${used_id_id}" ; ((i++))
    itemID[${i}]="nat_ips" ; ((i++))

    itemForm[0]="select"
    itemForm[1]="select"
    itemForm[3]="select"
    itemForm[4]="select"

    checkItem[5]=iplist

    local psk_file secret tls
    local method=${VPN_IPSEC_AUTHENTICATE/:*}

    if test ${method} == 'psk' ; then
	psk_file=${VPN_IPSEC_DIR}/${IPSEC_AUTHENTICATE_PSK_FILENAME}
	secret=$(cat ${psk_file} 2> /dev/null)
	secret=$(decrypt-password "${secret}" "${IPSEC_PASSWD}")
    else
	tls=${VPN_IPSEC_AUTHENTICATE#*:}
	tls_id=${tls/:*}
	used_id=${tls/*:}
    fi

    i=0
    blankItemContent[${i}]=$(show-vpnipsec-authenticates ${method}) ; ((i++))
    blankItemContent[${i}]=$(show-vpnipsec-auto-psk) ; ((i++))
    blankItemContent[${i}]="type='text' size='64' maxlength='64' value='${secret}'" ; ((i++))
    blankItemContent[${i}]=$(show-vpnipsec-tls ${tls_id}) ; ((i++))
    blankItemContent[${i}]=$(show-used-identifier ${used_id}) ; ((i++))
    blankItemContent[${i}]="type='text' size='47' maxlength='127' value='${VPN_IPSEC_BEHIND_NAT_IP_LIST// /,}' onMouseOver='ddrivetip( \\\"${nat_ip_tip}\\\", ${nat_ip_tip_width} );' onMouseOut='hideddrivetip( );'" ; ((i++))

    local cb="VPNIPsecAuthenticateSelectCB( '${method_id}', '${auto_psk_id}', '${psk_id}', '${tls_id_id}', '${used_id_id}' );"
    itemFormSelectCB[0]=${cb}
    itemFormSelectCB[1]=${cb}

    local after_function="select-vpnipsec-authenticate ${method_id} ${auto_psk_id} ${psk_id} ${tls_id_id} ${used_id_id}"

    shortcutMenuItem[0]="tls-server"
    shortcutMenuTitle[0]="Manage TLS"

    show-title "IPsec VPN Authentication Settings" enabled "tls vpnipsec"
    show-shortcuts-menu
    show-form "${width}" enabled "${after_function}"
}

# Main()

show-vpnipsec-authenticate
