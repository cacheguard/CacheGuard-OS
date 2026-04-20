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

print-access-operations()
{
    echo "add del"
}

get-command-op()
{
    case ${1} in
	+)
	    echo add
	    ;;
	-)
	    echo del
	    ;;
	*)
	    ;;
    esac
}

show-vpnipsec-access-access()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local op_id op id width=600
    local rows=3
    local cols=$((MAX_IKE_ID_LEN / rows))

    itemTitle[0]=''
    itemTitle[1]="OP"
    itemTitle[2]="IKE (or EAP) Identifier"

    itemID[0]="VPN"
    itemID[1]="op"
    itemID[2]="id"

    itemForm[1]="select"
    itemForm[2]="encoded"

    blankItemContent[0]=''
    blankItemContent[1]=$(print-access-operations)
    blankItemContent[2]="type='text' size='64' maxlength='${MAX_IKE_ID_LEN}'"
    #blankItemContent[2]="rows='${rows}' cols='${cols}'"

    itemWidth[1]=10
    checkItem[2]=ikeidentifier
    
    unset listContent

    if test -f ${VPN_IPSEC_DIR}/whitelist.raz ; then
	op='del'
    else
	op='keep'
    fi

    if test -s ${VPN_IPSEC_DIR}/whitelist ; then
	while read id
	do
	    id=$(encode-string "${id}")
	    listContent="${listContent} ${op} ${id}"
	done < ${VPN_IPSEC_DIR}/whitelist
    fi

    if test -s ${VPN_IPSEC_DIR}/whitelist.diff ; then
	while read op_id
	do
	    op=${op_id:0:1}
	    id=${op_id:1}
	    id=$(encode-string "${id}")
	    op=$(get-command-op ${op})
	    listContent="${listContent} ${op} ${id}"
	done < ${VPN_IPSEC_DIR}/whitelist.diff
    fi

    listContent=${listContent:1}
    listContentStep=2

    test -n "${listContent}" || state=disabled

    local users_nb=$(gui-get-contextual-users-nb)
    local max_ike_nb=$[${users_nb} * ${TLS_NB_FACTOR}]

    shortcutMenuItem[0]="tls-client"
    shortcutMenuTitle[0]="Client Certificates"

    show-title "Allowed IPsec VPN Client Access" "${state}" "tls vpnipsec"
    show-shortcuts-menu
    show-list-form ${max_ike_nb} ${width} "${page_ref}"
}

# Main()

show-vpnipsec-access-access "${@}"
