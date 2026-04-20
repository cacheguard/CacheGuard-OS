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

show-manager-bases()
{
    local in_base=${1}

    local dir=${HOME}/${MANAGER_TEMPLATE_RDIR}
    local templates=$(ls -1 ${dir} 2> /dev/null)

    test -s ${MANAGER_GATEWAY_INDEX} -o -n "${templates}" || return 11

    local selected id

    for id in ${templates}
    do
	test template:${id} != ${GUI_CONTEXT} || continue
	selected=$(get-selected-option template:${id} "${in_base}")
	echo "<option value='template:${id}'${selected}>TEMPLATE > ${id}</option>"
    done

    local uuid domain ip

    while read uuid domain id ip
    do
	test -n "${ip}" || continue
	test gateway:${id} != ${GUI_CONTEXT} || continue
	selected=$(get-selected-option gateway:${id} "${in_base}")
	echo "<option value='gateway:${id}'${selected}>GATEWAY  > ${id}</option>"
    done < ${HOME}/${MANAGER_GATEWAY_INDEX}
}

show-specific-conf()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local index=${1}
    local page=${2}
    local title=${3}
    local value=${4}

    local icon_title='Modify Value' icon_sz=30

    itemTitle[${index}]="${title}"
    itemID[${index}]=${page}
    blankItemContent[${index}]="<a href='/${GUI_DIR_NAME}/${page}.${GUI_EXT_NAME}'><img style='width:${icon_sz}px; height:${icon_sz}px; margin:0; margin-right:10px;' src='${IMAGE_DIR}/${page}.png' alt='' title='${icon_title}' align='middle' /></a>${value}"
    itemForm[${index}]="text"
}

show-specific-vlan-ips()
{
    local elt range nb i=0
    local vlan ip mk

    for elt in ${IP_VLAN_LIST}
    do
        range=$[${i} % 3]
        case ${range} in
	    0)
                vlan=${elt}
                ;;
	    1)
                ip=${elt}
                ;;
	    2)
                mk=${elt}
                nb=$[${i} / 3]

		show-specific-conf ${_INDEX} ip "Internal [VLAN ${vlan}]" "${ip} / ${mk}" ; ((_INDEX++))
                ;;
	    *)
                return 1
                ;;
        esac
	((i++))
    done
}

show-specific-vrrp-ips-if()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    local page="${1}"
    local title="${2}"
    local vrrps="${3}"
    
    local i=0 n=0 elt range
    local ip state prio id value

    for elt in ${vrrps}
    do
	range=$[${i} % 4]
	case ${range} in
	    0)
		ip=${elt}
		;;
	    1)
		state=${elt}
		;;
	    2)
		priority=${elt}
		;;
	    3)
		vrrp_id=${elt}
		value="${ip} ${state} ${priority} ${vrrp_id}"

		if test ${n} -eq 0  ; then
		    show-specific-conf ${_INDEX} ${page} "${title}" "${value}"
		else
		    show-specific-conf ${_INDEX} ${page} "" "${value}"
		fi
		((_INDEX++))
		((n++))
		;;
	    *)
		return 1
		;;
	esac
	((i++))
    done
}

show-specific-vrrp-ips()
{
    if test -z "${VRRP_EXTERNAL_LIST}" -a \
	    -z "${VRRP_INTERNAL_LIST}" -a \
	    -z "${VRRP_AUXILIARY_LIST}" -a \
	    -z "${VRRP_WEB_LIST}" -a \
	    -z "${VRRP_RWEB_LIST}" -a \
	    -z "${VRRP_AV_LIST}" ; then

	show-specific-conf ${_INDEX} vrrp-external "VRRP IPs" "<i>vrrp...</i>"
	((_INDEX++))
	return 0
    fi

    show-specific-vrrp-ips-if vrrp-external "External VRRP IPs" "${VRRP_EXTERNAL_LIST}"
    show-specific-vrrp-ips-if vrrp-internal "Native Internal VRRP IPs" "${VRRP_INTERNAL_LIST}"
    show-specific-vrrp-ips-if vrrp-auxiliary "Auxiliary VRRP IPs" "${VRRP_AUXILIARY_LIST}"
    show-specific-vrrp-ips-if vrrp-web-8021q "Web VLAN VRRP IPs" "${VRRP_WEB_LIST}"
    show-specific-vrrp-ips-if vrrp-rweb-8021q "Reverse Web VLAN VRRP IPs" "${VRRP_RWEB_LIST}"
    show-specific-vrrp-ips-if vrrp-antivirus-8021q "Antivirus VLAN VRRP IPs" "${VRRP_AV_LIST}"
}

show-specific-ip-routes()
{
    local i=0 n=0 elt range
    local ip netmask gateway weight pinged value
    local page='ip-route' title='Static IP Routes'

    if test -z "${IP_ROUTE_LIST}" ; then
	show-specific-conf ${_INDEX} ip-route "${title}" "<i>ip route...</i>"
	((_INDEX++))
	return 0
    fi

    for elt in ${IP_ROUTE_LIST}
    do
	range=$[${i} % 5]
	case ${range} in
	    0)
		ip=${elt}
		;;
	    1)
		netmask=${elt}
		;;
	    2)
		gateway=${elt}
		;;
	    3)
		weight=${elt}
		;;
	    4)
		pinged=${elt}
		value="${ip} ${netmask} ${gateway} ${weight} ${pinged}"

		if test ${n} -eq 0  ; then
		    show-specific-conf ${_INDEX} ${page} "${title}" "${value}"
		else
		    show-specific-conf ${_INDEX} ${page} "" "${value}"
		fi
		((_INDEX++))
		((n++))
		;;
	    *)
		return 1
		;;
	esac
	((i++))
    done
}

show-specific-ip-vias()
{
    local elt range i=0 n=0
    local gateway role prio
    local page='ip-via' title='Via Gateways'


    if test -z "${IP_VIA_LIST}" ; then
	show-specific-conf ${_INDEX} ip-via "${title}" "<i>ip via...</i>"
	((_INDEX++))
	return 0
    fi

    for elt in ${IP_VIA_LIST}
    do
	range=$[${i} % 3]
	case ${range} in
	    0)
		gateway=${elt}
		;;
	    1)
		role=${elt}
		;;
	    2)
		prio=${elt}
		value="${gateway} ${role} ${prio}"

		if test ${n} -eq 0  ; then
		    show-specific-conf ${_INDEX} ${page} "${title}" "${value}"
		else
		    show-specific-conf ${_INDEX} ${page} "" "${value}"
		fi
		((_INDEX++))
		((n++))

		;;
	    *)
		return 255
		;;
	esac
	((i++))
    done
}

show-conf-template-form()
{
    test -n "${GUI_CONTEXT}" || return 0
    local in_context=${GUI_CONTEXT/:*}
    local in_gateway_id=${GUI_CONTEXT/*:}

    _INDEX=0
    local page i=0

    local state width=700
    local in_base

    if test "${REQUEST_METHOD}" == POST ; then
	in_base="${VALUES[0]}"
    fi
	
    itemWidth[0]=30
    itemWidth[1]=70

    itemID[${_INDEX}]="base"
    itemTitle[${_INDEX}]="Configuration Base"
    itemForm[${_INDEX}]="select"
    blankItemContent[${_INDEX}]=$(show-manager-bases ${in_base})
    test ${?} -eq 0 || state=disabled
    ((_INDEX++))

    itemID[${_INDEX}]="break1"
    itemTitle[${_INDEX}]="<span style='color:FireBrick; font-style:italic; text-decoration:underline;'>Main Specific Settings</span>"
    blankItemContent[${_INDEX}]="<hr />"
    itemForm[${_INDEX}]="text"
    ((_INDEX++))

    show-specific-conf ${_INDEX} names 'Host Name' ${SHOSTNAME} ; ((_INDEX++))
    show-specific-conf ${_INDEX} ip 'External Interface' "${IP_EXTERNAL_IP} / ${IP_EXTERNAL_MASK}" ; ((_INDEX++))
    show-specific-conf ${_INDEX} ip 'Internal Interface' "${IP_INTERNAL_IP} / ${IP_INTERNAL_MASK}" ; ((_INDEX++))
    show-specific-conf ${_INDEX} ip 'Auxiliary Interface' "${IP_AUXILIARY_IP} / ${IP_AUXILIARY_MASK}" ; ((_INDEX++))

    show-specific-vlan-ips
    show-specific-vrrp-ips
    show-specific-ip-routes
    show-specific-ip-vias

    itemID[${_INDEX}]="break2"
    itemTitle[${_INDEX}]="<span style='color:FireBrick; font-style:italic; text-decoration:underline;'>Other Specific Settings</span>"
    blankItemContent[${_INDEX}]="<hr />"
    itemForm[${_INDEX}]="text"
    ((_INDEX++))

    show-specific-conf ${_INDEX} transparent 'Transparent Web Networks' "<i>transparent...</i>" ; ((_INDEX++))
    show-specific-conf ${_INDEX} access-web 'Appliance Access' "<i>access...</i>" ; ((_INDEX++))
    show-specific-conf ${_INDEX} dhcp-range 'DHCP Configuration' "<i>dhcp...</i>" ; ((_INDEX++))
    show-specific-conf ${_INDEX} firewall-web 'Firewall Rules' "<i>firewall...</i>" ; ((_INDEX++))
    show-specific-conf ${_INDEX} vpnipsec-site-via 'IPsec VPN Via Gateways' "<i>vpnipsec...</i>" ; ((_INDEX++))
    show-specific-conf ${_INDEX} vpnipsec-site 'IPsec VPN Local Networks' "<i>vpnipsec...</i>" ; ((_INDEX++))
    show-specific-conf ${_INDEX} rweb-via 'Reverse Web Via Gateways' "<i>rweb...</i>" ; ((_INDEX++))
    show-specific-conf ${_INDEX} peer-share 'Peer Proxies' "<i>peer...</i>" ; ((_INDEX++))

    i=0

    if test "${in_context}" == gateway ; then
	shortcutMenuItem[${i}]="manager-gateway-operation"
	shortcutMenuArgs[${i}]="push,key:${in_gateway_id}"
	shortcutMenuIcon[${i}]="manager-gateway-push"
	shortcutMenuTitle[${i}]="Push Configuration"
	((i++))

	shortcutMenuItem[${i}]="manager-gateway-operation"
	shortcutMenuArgs[${i}]="push,key:${in_gateway_id}"
	shortcutMenuIcon[${i}]="manager-gateway-pull"
	shortcutMenuTitle[${i}]="Pull Configuration"
	((i++))
    fi

    shortcutMenuItem[${i}]="conf-show"
    shortcutMenuIcon[${i}]="conf-show"
    shortcutMenuTitle[${i}]="Configuration Overview"
    ((i++))

    show-title "Configure by Template" ${state} "conf manager"
    show-shortcuts-menu
    show-form "${width}" ${state}
}

# Main()

show-conf-template-form "${@}"
