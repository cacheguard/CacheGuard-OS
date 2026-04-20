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

print-fw-protocols()
{
    echo -n "any tcp udp icmp ftp_active ftp_passive ftp_trivial sip cftp ah esp etherip fc gre igmp ipv6 mtp ospfigp tlsp visa vrrp"
}

print-fw-actions()
{
    echo -n "allow deny"
}

print-fw-devs()
{
    test -n "${1}" || return 1
    local in_rset=${1}

    local rset list="any"
    
    for rset in external auxiliary web rweb admin mon file peer antivirus vpnipsec
    do
	test ${rset} != ${in_rset} || continue
	list="${list} ${rset}"
    done

    echo ${list}
}

show-firewall-form()
{
    test -n "${1}" || return 1
    local rset=${1}
    local get_args=${2}

    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${LIST_FORM_WIDTH_A}
    local state title

    itemWidth[0]=ordered
    itemWidth[1]=17
    itemWidth[5]=14
    itemWidth[7]=14
    itemWidth[8]=9

    itemTitle[1]="Rule Name"
    itemTitle[2]="State"
    itemTitle[3]="Action"
    itemTitle[4]="Protocol"
    itemTitle[5]="Src IP[/Px]<hr />NAT"
    itemTitle[6]="Output"
    itemTitle[7]="Dst IP[/Px]<hr />NAT"
    itemTitle[8]="Port(s)<hr />PAT"

    itemID[0]="FW Rule"
    itemID[1]="rule_id"
    itemID[2]="state"
    itemID[3]="action"
    itemID[4]="protocol"
    itemID[5]="src_ip"
    itemID[6]="dst_dev"
    itemID[7]="dst_ip"
    itemID[8]="dst_ports"
    itemID[9]=""
    itemID[10]=""
    itemID[11]=""
    itemID[12]=""
    itemID[13]=""
    itemID[14]="src_nat_ip"
    itemID[15]=""
    itemID[16]="dst_nat_ip"
    itemID[17]="dst_pat_port"
    
    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='${MAX_NAME_LEN}' maxlength='${MAX_NAME_LEN}'"
    blankItemContent[2]="type='checkbox' checked"
    blankItemContent[3]=$(print-fw-actions)
    blankItemContent[4]=$(print-fw-protocols)
    blankItemContent[5]="type='text' size='18' maxlength='18'"
    blankItemContent[6]=$(print-fw-devs ${rset})
    blankItemContent[7]="type=text size='18' maxlength='18'"
    blankItemContent[8]="type=text size='11' maxlength='11'"
    blankItemContent[9]=""
    blankItemContent[10]=""
    blankItemContent[11]=""
    blankItemContent[12]=""
    blankItemContent[13]=""
    blankItemContent[14]="type='text' size='15' maxlength='15'"
    blankItemContent[15]=""
    blankItemContent[16]="type='text' size='15' maxlength='15'"
    blankItemContent[17]="type='text' size='5' maxlength='5'"

    itemFormSelectCBFunction[3]="firewallSelectCB"
    itemFormSelectCBArgs[3]="action protocol dst_ports src_nat_ip dst_nat_ip dst_pat_port"

    itemFormSelectCBFunction[4]=${itemFormSelectCBFunction[3]}
    itemFormSelectCBArgs[4]=${itemFormSelectCBArgs[3]}

    checkItem[1]=identifier
    checkItem[5]=ippx
    checkItem[7]=ippx
    checkItem[8]=ports
    checkItem[14]=ip
    checkItem[16]=ip
    checkItem[17]=port
    
    itemForm[1]="input"
    itemForm[2]="state"
    itemForm[3]="select"
    itemForm[4]="select"
    itemForm[5]="input"
    itemForm[6]="select"
    itemForm[7]="input"
    itemForm[8]="input"
    itemForm[9]="br"
    itemForm[10]="text"
    itemForm[11]="text"
    itemForm[12]="text"
    itemForm[13]="text"
    itemForm[14]="input"
    itemForm[15]="text"
    itemForm[16]="input"
    itemForm[17]="input"

    case "${rset}" in
	external)
	    title="External"
	    listContent=${FW_EXTERNAL_RULE_LIST}
	    ;;
	web)
	    title="Internal Web"
	    listContent=${FW_WEB_RULE_LIST}
	    ;;
	rweb)
	    title="Internal rWeb"
	    listContent=${FW_RWEB_RULE_LIST}
	    ;;
	antivirus)
	    title="Internal Antivirus"
	    listContent=${FW_AV_RULE_LIST}
	    ;;
	admin)
	    title="Internal Admin"
	    listContent=${FW_ADMIN_RULE_LIST}
	    ;;
	mon)
	    title="Internal Mon"
	    listContent=${FW_MON_RULE_LIST}
	    ;;
	file)
	    title="Internal File"
	    listContent=${FW_FILE_RULE_LIST}
	    ;;
	peer)
	    title="Internal Peer"
	    listContent=${FW_PEER_RULE_LIST}
	    ;;
	auxiliary)
	    title="Auxiliary"
	    listContent=${FW_AUXILIARY_RULE_LIST}
	    ;;
	vpnipsec)
	    title="IPsec VPN"
	    listContent=${FW_VPN_IPSEC_RULE_LIST}
	    ;;
	*)
	    return 255
	    ;;
    esac

    listContentStep=11
    test -n "${listContent}" || state=disabled

    show-title "${title} Interface Firewall Rules" "${state}" "firewall"
    show-list-form ${MAX_FW_RULES_NB} "${width}" "${page_ref}" "" insert
}
