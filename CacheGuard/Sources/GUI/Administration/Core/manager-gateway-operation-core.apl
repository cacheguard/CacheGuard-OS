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

show-manager-gateway-operation-item()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local value=${1}
    local title=${2}
    local selected_value=${3}

    local selected=$(get-selected-option ${value} "${selected_value}")
    echo "<option value='${value}'${selected}>${title}</option>"
}

show-manager-gateway-operation()
{
    local in_op=${1}

    local selected op

    show-manager-gateway-operation-item pull "Pull Configuration" ${in_op}
    show-manager-gateway-operation-item push "Push Configuration" ${in_op}
}

show-manager-gateway-scope()
{
    local in_scope=${1}
    local domains=${2}

    local selected domain

    selected=$(get-selected-option "${in_scope}" gateway)    
    echo "<option value='gateway'${selected}>Specific Gateways</option>"

    for domain in ${domains}
    do
	selected=$(get-selected-option domain:${domain} "${in_scope}")
	echo "<option value='domain:${domain}'${selected}>Domain ${domain}</option>"
    done

    selected=$(get-selected-option "${in_scope}" all)
    echo "<option value='all'${selected}>All Gateways</option>"
}

show-manager-domain-gateway()
{
    local in_domain_gateway_ip=${1}
    local domain_gateway_ips=${2}

    local selected domain_gateway_ip
    local gateway_ip domain gateway ip

    for domain_gateway_ip in ${domain_gateway_ips}
    do
	selected=$(get-selected-option ${domain_gateway_ip} "${in_domain_gateway_ip}")
	domain=${domain_gateway_ip/:*}
	gateway_ip=${domain_gateway_ip/*:}
	gateway=${gateway_ip/,*}
	echo "<option value='${domain_gateway_ip}'${selected}>${gateway} (Domain ${domain})</option>"
    done
}

show-manager-gateway-operation-log()
{
    test -n "${1}" || return 1
    local operation_selection_id=${1}

    refresh-buttons "update_manager_gateway_operation( 1, \"${operation_selection_id}\" )"

    echo "<div style='clear:left;'></div><br />"
    echo "<div style='clear:left;'></div>"
    echo "<div id='${AUTO_REPORT_ID}' class='log-report'></div>"
}

show-manager-gateway-operation-form()
{
    local operation_id=${1}
    local in_operation=${operation_id/,*}
    local in_key_id=${operation_id/*,}
    local in_gateway=${in_key_id/key:}

    local in_domain_gateway_ip in_domain in_ip
    local in_scope='gateway'

    local state log_function width=500
    local in_operation

    local operation_selection_id='operation'
    local scope_selection_id='scope'
    local gateway_selection_id='gateway'

    if test "${REQUEST_METHOD}" == POST ; then
	in_operation="${VALUES[0]}"
	in_scope="${VALUES[1]}"
	in_domain_gateway_ip="${VALUES[2]}"
    fi

    local domains domain_gateway_ips

    if test -s ${HOME}/${MANAGER_GATEWAY_INDEX} ; then
	local uuid domain id ip
	while read uuid domain id ip
	do
	    test -n "${ip}" || continue

	    domains="${domains} ${domain}"
	    domain_gateway_ips="${domain_gateway_ips} ${domain}:${id},${ip}"

	    if test ${id} == "${in_gateway}" ; then
		in_domain=${domain}
		in_ip=${ip}
	    fi

	done < ${HOME}/${MANAGER_GATEWAY_INDEX}
	domains=${domains:1}
	domain_gateway_ips=${domain_gateway_ips:1}
	domains=$(uniq-elt ${domains})
    fi

    test "${REQUEST_METHOD}" != GET || test -z "${in_gateway}" || in_domain_gateway_ip=${in_domain}:${in_gateway},${in_ip}

    itemWidth[0]=50
    itemWidth[1]=50

    itemTitle[0]="Operation"
    itemTitle[1]="Target Gateway Scope"
    itemTitle[2]="Target Specific Gateway"

    itemID[0]=${operation_selection_id}
    itemID[1]=${scope_selection_id}
    itemID[2]=${gateway_selection_id}

    blankItemContent[0]=$(show-manager-gateway-operation "${in_operation}")
    blankItemContent[1]=$(show-manager-gateway-scope "${in_scope}" "${domains}")
    blankItemContent[2]=$(show-manager-domain-gateway "${in_domain_gateway_ip}" "${domain_gateway_ips}")

    itemForm[0]="select"
    itemForm[1]="select"
    itemForm[2]="select"

    itemFormSelectCB[1]="targetGatewaySelectCB( '${scope_selection_id}', '${gateway_selection_id}' );"

    test "${in_scope}" == gateway || itemState[2]=disabled

    test -s ${HOME}/${MANAGER_GATEWAY_INDEX} || state=disabled

    case ${in_operation} in
	pull|push)
	    ;;
	*)
	    unset in_operation
	    ;;
    esac

    shortcutMenuItem[0]="manager-gateway"
    shortcutMenuTitle[0]="Gateways Repository"

    show-title "Operation on Gateways" "${state}" "manager"
    show-shortcuts-menu
    show-form "${width}" "${state}" show-manager-gateway-operation-log ${operation_selection_id}
}

# Main()

show-manager-gateway-operation-form "${@}"
