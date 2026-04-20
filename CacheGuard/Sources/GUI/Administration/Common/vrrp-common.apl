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

show-vrrp-form()
{
    test -n "${1}" | return 1
    local dev=${1}
    local get_args=${2}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_1}
    local state

    itemWidth[2]=15
    itemWidth[3]=13
    itemWidth[4]=10

    local title
    local ip mask vlan ip_mask
    local ip1 ip2

    case ${dev} in
	external)
	    listContent=${VRRP_EXTERNAL_LIST}
	    title="External VRRP"
	    ip=${IP_EXTERNAL_IP}
	    mask=${IP_EXTERNAL_MASK}
	    ip_mask="${ip} ${mask}"
	    ;;
	internal)
	    listContent=${VRRP_INTERNAL_LIST}
	    title="Native Internal VRRP"
	    ip=${IP_INTERNAL_IP}
	    mask=${IP_INTERNAL_MASK}
	    ip_mask="${ip} ${mask}"
	    ;;
	auxiliary)
	    listContent=${VRRP_AUXILIARY_LIST}
	    title="Auxiliary VRRP"
	    ip=${IP_AUXILIARY_IP}
	    mask=${IP_AUXILIARY_MASK}
	    ip_mask="${ip} ${mask}"
	    ;;
	web)
	    listContent=${VRRP_WEB_LIST}
	    title="Web VLAN VRRP"
	    vlan=$(get-vlan-tag web new)
	    ip_mask=$(get-vlan-ip-netmask ${vlan} new)
	    ;;
	rweb)
	    listContent=${VRRP_RWEB_LIST}
	    title="Reverse Web VLAN VRRP"
	    vlan=$(get-vlan-tag rweb new)
	    ip_mask=$(get-vlan-ip-netmask ${vlan} new)
	    ip=${ip_mask/ *}
	    mask=${ip_mask/* }
	    ;;
	antivirus)
	    listContent=${VRRP_AV_LIST}
	    title="Antivirus VLAN VRRP"
	    vlan=$(get-vlan-tag antivirus new)
	    ip_mask=$(get-vlan-ip-netmask ${vlan} new)
	    ip=${ip_mask/ *}
	    mask=${ip_mask/* }
	    ;;
	*)
	    ;;
    esac

    ip1=$(ipcalc -s ${ip_mask} -n) ; ip1=${ip1/NETWORK=}
    ip2=$(ipcalc -s ${ip_mask} -b) ; ip2=${ip2/BROADCAST=}

    local message="${ip1} < IP < ${ip2}"
    local message_width=260

    itemTitle[0]=""
    itemTitle[1]="VRRP IP"
    itemTitle[2]="Role"
    itemTitle[3]="Priority"
    itemTitle[4]="ID"

    
    itemID[0]="VRRP"
    itemID[1]="ip"
    itemID[2]="state"
    itemID[3]="priority"
    itemID[4]="vrid"
    
    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='15' maxlength='15' onMouseOver='ddrivetip( \\\"${message}\\\", ${message_width} );' onMouseOut='hideddrivetip( );'"
    blankItemContent[2]="master backup"
    blankItemContent[3]="type='text' size='3' maxlength='3'"
    blankItemContent[4]="type='text' size='3' maxlength='3'"
    
    checkItem[1]=ip
    checkItem[3]=digit
    checkItem[4]=digit

    itemForm[2]="select"

    test -n "${listContent}" || state=disabled

    call-js-function "hideddrivetip( )"
    show-title "${title}" "${state}" "vrrp"
    show-list-form ${MAX_VRRP_NB} "${width}" "${page_ref}"
}

set-vrrp()
{
    test -n "${1}" || return 1
    local dev=${1}

    local pos=0 entry_pos del_pos
    local vrrp_pos state_pos priority_pos vrid_pos

    local transaction=/tmp/${TRANSACTION_FILE}.wadmin.${REMOTE_USER}.${$}
    rm -f ${transaction}

    while test ${pos} -lt ${ATTRIBUTE_NB}
    do
	entry_pos=${pos}
	vrrp_pos=$[${pos} + 1]
	state_pos=$[${pos} + 2]
	priority_pos=$[${pos} + 3]
	vrid_pos=$[${pos} + 4]
	del_pos=$[${pos} + 5]
	
	[[ "${ATTRIBUTES[${del_pos}]}" =~ ^del_[0-9]+$ ]]
	if test ${?} -ne 0 ; then
	    
	    if test "${VALUES[${entry_pos}]}" == anew -a \
		-n "${VALUES[${vrrp_pos}]}" -a \
		-n "${VALUES[${state_pos}]}" ; then
		if test -n "${VALUES[${priority_pos}]}" ; then
		    echo "vrrp '${dev}' add '${VALUES[${vrrp_pos}]}' '${VALUES[${state_pos}]}' '${VALUES[${priority_pos}]}' '${VALUES[${vrid_pos}]}'" >> ${transaction}
		else
		    case "${VALUES[${state_pos}]}" in
			master)
			    echo "vrrp '${dev}' add '${VALUES[${vrrp_pos}]}' '${VALUES[${state_pos}]}' 110 '${VALUES[${vrid_pos}]}'" >> ${transaction}
			    ;;
			backup)
			    echo "vrrp '${dev}' add '${VALUES[${vrrp_pos}]}' '${VALUES[${state_pos}]}' 100 '${VALUES[${vrid_pos}]}'" >> ${transaction}
			    ;;
			*)
			    ;;
		    esac
		    
		fi
	    fi
	    
	    pos=$[${pos} + 5]
	else
	    echo "vrrp ${dev} del '${VALUES[${vrrp_pos}]}'" >> ${transaction}
	    pos=$[${pos} + 6]
	fi
    done
    
    execute-transaction ${transaction}
}
