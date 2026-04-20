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

gui-qos-shape-router()
{
    local in_rules=${@}
    local out_rules

    local i=0 n=0 elt range
    local id dev protocol src_ip src_port dst_ip dst_port ingress_qos egress_qos dscp
    local rule

    for elt in ${in_rules}
    do
	range=$[${i} % 10]
	case ${range} in
	    0)
		id=${elt}
		;;
	    1)
		dev=${elt}
		;;
	    2)
		protocol=${elt}
		;;
	    3)
		src_ip=${elt}
		;;
	    4)
		src_port=${elt}
		;;
	    5)
		ingress_qos=${elt}
		;;
	    6)
		dst_ip=${elt}
		;;
	    7)
		dst_port=${elt}
		;;
	    8)
		egress_qos=${elt}
		;;
	    9)
		dscp=${elt}
		rule="${id} ${dev} ${protocol} ${src_ip} ${src_port} ${ingress_qos} ${dscp} ${dst_ip} ${dst_port} ${egress_qos}"
		out_rules="${out_rules} ${rule}"
		;;
	    *)
		return 255
		;;
	esac
	((i++))
    done
    out_rules=${out_rules:1}

    echo ${out_rules}
}

show-qos-shape-router-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${LIST_FORM_WIDTH_B}
    local state

    itemWidth[0]=ordered
    itemWidth[1]=15
    itemWidth[2]=10

    itemTitle[1]="Rule Name"
    itemTitle[2]="Interface"
    itemTitle[3]="Protocol<hr />DSCP"
    itemTitle[4]="Src IP[/Px]<hr />Dst IP[/Px]"
    itemTitle[5]="Src Port<hr />Dst Port"
    itemTitle[6]="In QoS<hr />Out QoS"

    itemID[0]="QoS Rule"
    itemID[1]="rule_id"
    itemID[2]="dev"
    itemID[3]="protocol"
    itemID[4]="src_ip"
    itemID[5]="src_port"
    itemID[6]="ingress_qos"
    itemID[7]=""
    itemID[8]=""
    itemID[9]=""
    itemID[10]="dscp"
    itemID[11]="dst_ip"
    itemID[12]="dst_port"
    itemID[13]="egress_qos"
    
    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='${MAX_NAME_LEN}' maxlength='${MAX_NAME_LEN}'"
    blankItemContent[2]="internal external auxiliary"
    blankItemContent[3]="any tcp udp"
    blankItemContent[4]="type='text' size='18' maxlength='18'"
    blankItemContent[5]="type='text' size='5' maxlength='5'"
    blankItemContent[6]="type='text' size='8' maxlength='10'"
    blankItemContent[7]=""
    blankItemContent[8]=""
    blankItemContent[9]=""
    blankItemContent[10]="type='text' size='3' maxlength='2'"
    blankItemContent[11]="type='text' size='18' maxlength='18'"
    blankItemContent[12]="type='text' size='5' maxlength='5'"
    blankItemContent[13]="type='text' size='8' maxlength='10'"

    checkItem[1]=identifier
    checkItem[4]=ippx
    checkItem[5]=port
    checkItem[6]=qos
    checkItem[10]=digit
    checkItem[11]=ippx
    checkItem[12]=port
    checkItem[13]=qos
    
    itemForm[1]="input"
    itemForm[2]="select"
    itemForm[3]="select"
    itemForm[4]="input"
    itemForm[5]="input"
    itemForm[6]="input"
    itemForm[7]="br"
    itemForm[8]="text"
    itemForm[9]="text"
    itemForm[10]="input"
    itemForm[11]="input"
    itemForm[12]="input"
    itemForm[13]="input"

    listContent=$(gui-qos-shape-router ${QOS_SHAPE_ROUTER_LIST})
    listContentStep=10
    test -n "${listContent}" || state=disabled

    show-title "Shape Routed Traffic" "${state}" "qos"
    show-list-form ${MAX_QOS_SHAPE_ROUTER_RULES_NB} "${width}" "${page_ref}" "" insert
}

# Main()

show-qos-shape-router-form "${@}"
