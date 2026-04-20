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

select-vpnipsec-site-settings()
{
    local authenticate_id="${1}"
    local tls_authenticate_id="${2}"
    local tls_id_id="${3}"
    local dn_fqdn_id="${4}"
    local psk_id="${5}"

    call-js-function "VPNIPsecSiteSettingsCB( '${authenticate_id}', '${tls_authenticate_id}', '${tls_id_id}', '${dn_fqdn_id}', '${psk_id}' )"
}

show-vpnipsec-site-settings()
{
    local get_args=${1}
    local in_vpn_id=$(get-arg-value "${get_args}" key)
    test -n "${in_vpn_id}" || return 1

    local remote_address_tip="Master address followed by optional comma separated backup addresses"
    local remote_address_tip_width=500

    local width=600 i=0

    itemWidth[0]=50
    itemWidth[1]=50

    local authenticate_id='authenticate'
    local id_based_id='id_based'
    local tls_id_id='tls_id'
    local dn_fqdn_id='dn_fqdn'
    local psk_id='psk'
    
    itemTitle[${i}]="Remote Site Identifier" ; ((i++))
    itemTitle[${i}]="Remote Site Address(s)" ; ((i++))
    itemTitle[${i}]="Remote Authentication Method" ; ((i++))
    itemTitle[${i}]="Remote Based Identifier" ; ((i++))
    itemTitle[${i}]="Remote TLS Identifier" ; ((i++))
    itemTitle[${i}]="Remote Identifier DN or FQDN" ; ((i++))
    itemTitle[${i}]="Remote Pre Shared Key (PSK)" ; ((i++))
    itemTitle[${i}]="IKE Encryption Algorithm" ; ((i++))
    itemTitle[${i}]="IKE Integrity Algorithm" ; ((i++))
    itemTitle[${i}]="Diffie Hellman Key Strength" ; ((i++))
    itemTitle[${i}]="ESP Encryption Algorithm" ; ((i++))
    itemTitle[${i}]="ESP Integrity Algorithm" ; ((i++))
    itemTitle[${i}]="Remote ISAMP (IKE) Port" ; ((i++))
    itemTitle[${i}]="Remote NAT Transversal (NATT) Port" ; ((i++))
    itemTitle[${i}]="Remote NAT Role" ; ((i++))
    itemTitle[${i}]="Private Networks" ; ((i++))
    itemTitle[${i}]="Via Gateways" ; ((i++))

    i=0
    itemID[${i}]="vpn_id" ; ((i++))
    itemID[${i}]="remote_addresses" ; ((i++))
    itemID[${i}]="${authenticate_id}" ; ((i++))
    itemID[${i}]="${id_based_id}" ; ((i++))
    itemID[${i}]="${tls_id_id}" ; ((i++))
    itemID[${i}]="${dn_fqdn_id}" ; ((i++))
    itemID[${i}]="${psk_id}" ; ((i++))
    itemID[${i}]="ike_encryption" ; ((i++))
    itemID[${i}]="ike_integrity" ; ((i++))
    itemID[${i}]="dh" ; ((i++))
    itemID[${i}]="esp_encryption" ; ((i++))
    itemID[${i}]="esp_integrity" ; ((i++))
    itemID[${i}]="isakmp_port" ; ((i++))
    itemID[${i}]="natt_port" ; ((i++))
    itemID[${i}]="nat_role" ; ((i++))
    itemID[${i}]="private_networks" ; ((i++))
    itemID[${i}]="via_gateways" ; ((i++))

    i=0
    itemForm[${i}]="input" ; ((i++))
    itemForm[${i}]="input" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="input" ; ((i++))
    itemForm[${i}]="input" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="input" ; ((i++))
    itemForm[${i}]="input" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="text" ; ((i++))
    itemForm[${i}]="text" ; ((i++))

    checkItem[1]=fqdnlist
    checkItem[12]=port
    checkItem[13]=port

    local elt range
    local vpn_id remote_address auth_type auth_key1 auth_key2 ike_encryption ike_integrity dh esp_encryption esp_integrity remote_isakmp_port remote_natt_port
    local tls_authenticate tls_id tls_dn_fqdn psk
    local remote_addresses nat_role

    i=0
    for elt in ${VPN_IPSEC_SITE_LIST}
    do
	range=$[${i} % 12]
	case ${range} in
	    0)
 		vpn_id=${elt}
		;;
	    1)
		remote_address=${elt}

		remote_addresses=$(get-vpn-ipsec-all-tos ${vpn_id} ${remote_address})
		remote_addresses=${remote_addresses// /,}

	        nat_role=$(get-vpn-ipsec-nat-role ${vpn_id} "${VPN_IPSEC_BEHIND_NAT_ROLE_LIST}")
		;;
	    2)
		auth_type=${elt}
		;;
	    3)
		auth_key1=${elt}
		;;
	    4)
		auth_key2=${elt}
		;;
	    5)
		ike_encryption=${elt}
		;;
	    6)
		ike_integrity=${elt}
		;;
	    7)
		dh=${elt}
		;;
	    8)
		esp_encryption=${elt}
		;;
	    9)
		esp_integrity=${elt}
		;;
	    10)
		isakmp_port=${elt}
		;;
	    11)
		natt_port=${elt}

		if test ${vpn_id} == ${in_vpn_id} ; then

		    case ${auth_type} in
			psk)
			    unset tls_authenticate tls_id tls_dn_fqdn
			    psk=${auth_key1}
			    ;;
			tls)
			    tls_authenticate=${auth_key1}
			    case "${tls_authenticate}" in
				certificate)
				    unset psk tls_dn_fqdn
				    tls_id=${auth_key2}
				    ;;
				dn)
				    unset psk tls_id
				    tls_dn_fqdn=$(decode-string ${auth_key2})
				    ;;
				fqdn)
				    unset psk tls_id
				    tls_dn_fqdn=${auth_key2}
				    ;;
				*)
				    ;;
			    esac
			    ;;
			*)
			    ;;
		    esac
		    break
		fi
		;;
	esac
	((i++))
    done

    local color='SeaGreen'
    i=0

    blankItemContent[${i}]="type='text' size='${MAX_NAME_LEN}' maxlength='${MAX_NAME_LEN}' value='${in_vpn_id}' readonly style='color:${color}; border:0;'" ; ((i++))
    blankItemContent[${i}]="type='text' size='64' maxlength='128' value='${remote_addresses}' onMouseOver='ddrivetip( \"${remote_address_tip}\", ${remote_address_tip_width} );' onMouseOut='hideddrivetip( );'" ; ((i++))
    blankItemContent[${i}]=$(show-vpnipsec-site-authenticates ${auth_type}) ; ((i++))
    blankItemContent[${i}]=$(show-vpnipsec-tls-authenticates ${tls_authenticate}) ; ((i++))
    blankItemContent[${i}]=$(show-vpnipsec-tls ${tls_id}) ; ((i++))
    blankItemContent[${i}]="type='text' size='64' maxlength='256' value='${tls_dn_fqdn}'" ; ((i++))
    blankItemContent[${i}]="type='password' size='64' maxlength='64' value=''" ; ((i++))
    blankItemContent[${i}]=$(show-vpnipsec-encryptions ${ike_encryption}) ; ((i++))
    blankItemContent[${i}]=$(show-vpnipsec-integrities ${ike_integrity}) ; ((i++))
    blankItemContent[${i}]=$(show-vpnipsec-dh ${dh}) ; ((i++))
    blankItemContent[${i}]=$(show-vpnipsec-encryptions ${esp_encryption}) ; ((i++))
    blankItemContent[${i}]=$(show-vpnipsec-integrities ${esp_integrity}) ; ((i++))
    blankItemContent[${i}]="type='text' size='5' maxlength='5' value='${isakmp_port}'" ; ((i++))
    blankItemContent[${i}]="type='text' size='5' maxlength='5' value='${natt_port}'" ; ((i++))
    blankItemContent[${i}]=$(show-vpnipsec-nat-role ${nat_role}) ; ((i++))

    blankItemContent[${i}]="<a href='/${GUI_DIR_NAME}/vpnipsec-site-network.${GUI_EXT_NAME}?level:2,key:${in_vpn_id}'>Manage Private Networks</a>" ; ((i++))
    blankItemContent[${i}]="<a href='/${GUI_DIR_NAME}/vpnipsec-site-via.${GUI_EXT_NAME}?level:2,key:${in_vpn_id}'>Manage Via Gateways</a>" ; ((i++))

    itemFormSelectCB[2]="VPNIPsecSiteSettingsCB( '${authenticate_id}', '${id_based_id}', '${tls_id_id}', '${dn_fqdn_id}', '${psk_id}' );"
    itemFormSelectCB[3]=${itemFormSelectCB[2]}
    itemFormSelectCB[4]=${itemFormSelectCB[2]}

    shortcutMenuItem[0]="tls-server"
    shortcutMenuTitle[0]="Manage TLS"

    local after_function="select-vpnipsec-site-settings ${authenticate_id} ${id_based_id} ${tls_id_id} ${dn_fqdn_id} ${psk_id}"

    call-js-function "hideddrivetip( )"
    show-title "IPsec VPN Site Settings" "${state}" "vpnipsec tls"
    show-shortcuts-menu
    show-form "${width}" enabled "${after_function}"
}

show-vpnipsec-site-settings "${@}"
