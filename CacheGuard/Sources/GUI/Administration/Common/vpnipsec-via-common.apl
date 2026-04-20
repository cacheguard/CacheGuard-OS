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

show-vpnipsec-via()
{
    local in_ipsec_type=${1}
    local get_args=${2}
    local page_ref=$(get-arg-value "${get_args}" page)

    local long_title in_vpn_id
    local width=${DEFAULT_LIST_FORM_WIDTH_2}
    local state

    case ${in_ipsec_type} in
	site)
	    in_vpn_id=$(get-arg-value "${get_args}" key)
	    long_title="Site to Site VPN Id <font color='SeaGreen'>${in_vpn_id}</font>"
	    ;;
	access)
	    in_vpn_id=${in_ipsec_type}
	    long_title="Remote Access Mode"
	    ;;
	*)
	    in_vpn_id=${in_ipsec_type}
	    long_title="<i>Unknown</i>"
	    ;;
    esac

    itemWidth[1]=40
    itemWidth[3]=5

    itemTitle[1]="Via Gateway"
    itemTitle[2]="Role"
    itemTitle[3]="Priority"

    itemID[0]="VPN Id"
    itemID[1]="ip"
    itemID[2]="role"
    itemID[3]="priority"

    singleItemID[0]='vpn_id'
    singleItemValue[0]="${in_vpn_id}"

    blankItemContent[0]=""

    blankItemContent[1]=$(get-external-gateways)
    blankItemContent[2]="master backup"
    blankItemContent[3]="type='text' size='3' maxlength='3'"
    
    itemForm[1]="select"
    itemForm[2]="select"

    checkItem[3]=digit

    local elt range i=0
    local ipsec_type vpn_id vias
    local via gateway role_prio role prio

    for elt in ${VPN_IPSEC_VIA_LIST}
    do
	range=$[${i} % 3]
	case ${range} in
	    0)
		ipsec_type=${elt}
		;;
	    1)
		vpn_id=${elt}
		;;
	    2)
		vias=${elt}
		test "${ipsec_type}" != ${in_ipsec_type} -o "${vpn_id}" != ${in_vpn_id} || break
		;;
	    *)
		return 255
		;;
	esac
	((i++))
    done

    if test "${ipsec_type}" == ${in_ipsec_type} -a "${vpn_id}" == ${in_vpn_id} ; then
	vias=$(colon2space ${vias})
	for via in ${vias}
	do
	    gateway=${via/_*}
	    role_prio=${via#*_}
	    role=${role_prio/_*}
	    prio=${role_prio/*_}
	    listContent="${listContent} ${gateway} ${role} ${prio}"
	done
    fi
    listContent=${listContent:1}

    listContentStep=3
    test -n "${listContent}" || state=disabled

    show-title "IPsec VPN Via Gateways" "${state}" "ip vpnipsec"
    show-list-form ${MAX_IP_ROUTES_NB} "${width}" "${page_ref}" "<br />${long_title}"
}
