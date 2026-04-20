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

show-vpnipsec-network()
{
    local in_ipsec_type=${1}
    local get_args=${2}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_1}
    local state

    local long_title in_vpn_id

    case ${in_ipsec_type} in
	site)
	    in_vpn_id=$(get-arg-value "${get_args}" key)
	    long_title="Private Networks for the Site to Site VPN ID <strong>${in_vpn_id}</strong>"
	    ;;
	access)
	    in_vpn_id=${in_ipsec_type}
	    long_title="Private Networks in Remote Access Mode"
	    ;;
	*)
	    in_vpn_id=${in_ipsec_type}
	    long_title="<i>Unknown</i>"
	    ;;
    esac

    itemWidth[2]=30
    itemWidth[3]=30

    itemTitle[1]="Network<br />Location"
    itemTitle[2]="Network IP"
    itemTitle[3]="Network Mask"

    itemID[0]="VPN ID"
    itemID[1]="location"
    itemID[2]="ip"
    itemID[3]="mk"

    singleItemID[0]='vpn_id'
    singleItemValue[0]="${in_vpn_id}"

    blankItemContent[0]=""
    blankItemContent[1]="remote local"
    blankItemContent[2]="type='text' size='18' maxlength='18'"
    blankItemContent[3]="type='text' size='15' maxlength='15'"

    checkItem[2]=ip
    checkItem[3]=ip
    
    itemForm[1]="select"

    local elt i=0 range
    local ipsec_type vpn_id local_ip_mk_list remote_ip_mk_list
    local ip_mk ip mk

    i=0
    for elt in ${VPN_IPSEC_NETWORK_LIST}
    do
	range=$[${i} % 4]
	case ${range} in
	    0)
		ipsec_type=${elt}
		;;
	    1)
		vpn_id=${elt}
		;;
	    2)
		local_ip_mk_list=${elt}
		;;
	    3)
		remote_ip_mk_list=${elt}
		test ${ipsec_type} != ${in_ipsec_type} -o ${vpn_id} != ${in_vpn_id} || break
		;;
	    *)
		return 255
		;;
	esac
	((i++))
    done

    if test "${ipsec_type}" == ${in_ipsec_type} -a "${vpn_id}" == ${in_vpn_id} ; then

	test "${local_ip_mk_list}" != nil || unset local_ip_mk_list
	test "${remote_ip_mk_list}" != nil || unset remote_ip_mk_list

	local_ip_mk_list=${local_ip_mk_list//,/ }
	remote_ip_mk_list=${remote_ip_mk_list//,/ }

	for ip_mk in ${local_ip_mk_list}
	do
	    ip=${ip_mk/\/*}
	    mk=${ip_mk/*\/}
	    listContent="${listContent} local ${ip} ${mk}"
	done

	for ip_mk in ${remote_ip_mk_list}
	do
	    ip=${ip_mk/\/*}
	    mk=${ip_mk/*\/}
	    listContent="${listContent} remote ${ip} ${mk}"
	done
	listContent=${listContent:1}
    fi

    listContentStep=3
    test -n "${listContent}" || state=disabled

    show-title "IPsec VPN Private Networks" "${state}" "ip vpnipsec"
    show-list-form ${MAX_IP_ROUTES_NB} "${width}" "${page_ref}" "<br />${long_title}"
}
