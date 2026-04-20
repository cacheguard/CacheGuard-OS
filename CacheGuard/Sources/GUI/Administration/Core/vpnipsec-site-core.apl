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

show-vpnipsec-site()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=1100

    itemWidth[1]=20
    itemWidth[2]=15
    itemWidth[6]=30

    itemTitle[1]="Site Identifier"
    itemTitle[2]="Site Address"
    itemTitle[3]="<center>Auth</center>"
    itemTitle[4]="<center>Based Identifier</center>"
    itemTitle[5]="TLS Identifier"
    itemTitle[6]="<center>PSK, DN or FQDN</center>"

    itemID[0]="VPN ID"
    itemID[1]="vpn_id"
    itemID[2]="remote_address"
    itemID[3]="authenticate"
    itemID[4]="tls_authenticate"
    itemID[5]="tls_id"
    itemID[6]="psk_dn_fqdn"
    
    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='${MAX_NAME_LEN}' maxlength='${MAX_NAME_LEN}'"
    blankItemContent[2]="type='text' size='24' maxlength='32'"
    blankItemContent[3]="psk tls"
    blankItemContent[4]="certificate fqdn dn"
    blankItemContent[5]=${TLS_SERVER_LIST}
    blankItemContent[6]="type='text' size='64' maxlength='256'"

    checkItem[1]=identifier
    checkItem[2]=ipdomainname

    itemForm[3]="select"
    itemForm[4]="select:blank"
    itemForm[5]="select:blank"

    shortcutMenuItem[0]="port"
    shortcutMenuTitle[0]="Listening Ports"

    shortcutMenuItem[1]="tls-server"
    shortcutMenuTitle[1]="Manage TLS"

    editColumnTitle[0]="<center>All<br />Settings</center>"
    editColumnPage[0]="vpnipsec-site-settings"
    editColumnQuery[0]="level:1"

    itemFormSelectCBFunction[3]="VPNIPsecSiteCB"
    itemFormSelectCBArgs[3]="authenticate tls_authenticate tls_id psk_dn_fqdn"

    itemFormSelectCBFunction[4]=${itemFormSelectCBFunction[3]}
    itemFormSelectCBArgs[4]=${itemFormSelectCBArgs[3]}

    local elt i=0 range
    local vpn_id remote_address auth_type auth_key1 auth_key2
    local tls tls_auth psk_dn_fqdn
    unset listContent

    for elt in ${VPN_IPSEC_SITE_LIST}
    do
	range=$[${i} % 12]
	case ${range} in
	    0)
 		vpn_id=${elt}
		;;
	    1)
		remote_address=${elt}
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
	    5|6|7|8|9|10)
		;;
	    11)
		case ${auth_type} in
                    psk)
                        tls_auth="na:"
                        tls="na:"
                        psk_dn_fqdn="password:${auth_key1}"
                        ;;

                    tls)
                        tls_auth=text:${auth_key1}
                        case ${auth_key1} in
                            dn)
                                tls="na:"
                                psk_dn_fqdn="base64:${auth_key2}"
                                ;;
                            certificate)
                                tls="text:${auth_key2}"
                                psk_dn_fqdn="na:"
                                ;;
                            fqdn)
                                tls="na:"
                                psk_dn_fqdn="text:${auth_key2}"
                                ;;
                            *)
                                ;;
                        esac
                        ;;
                    *)
                        ;;
                esac

                listContent="${listContent} ${vpn_id} ${remote_address} ${auth_type} ${tls_auth} ${tls} ${psk_dn_fqdn}"
		;;
	    *)
		return 1
		;;
	esac
	((i++))
    done
    listContent=${listContent:1}

    itemType[4]=multi-coded
    itemType[5]=multi-coded
    itemType[6]=multi-coded

    listContentStep=6
    test -n "${listContent}" || state=disabled
    local max_vpn_nb=$(get-max-vpn-nb)

    show-title "Site to Site IPsec VPNs" "${state}" "port tls vpnipsec"
    show-shortcuts-menu
    show-list-form ${max_vpn_nb} "${width}" "${page_ref}"
}

show-vpnipsec-site "${@}"
