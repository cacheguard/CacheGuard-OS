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

show-rweb-sb-protocol()
{
    local in_protocol=${1}

    local protocol protocols="https http ftp"

    echo -n "<option value='none'></option>"

    for protocol in ${protocols}
    do
	if test "${in_protocol}" == ${protocol} ; then
	    echo -n "<option value='${protocol}' selected>${protocol}</option>"
	else
	    echo -n "<option value='${protocol}'>${protocol}</option>"
	fi
    done
}

show-rweb-settings()
{
    local get_args=${1}
    local key=$(get-arg-value "${get_args}" key)

    local in_site_name=${key/§*}
    local in_rest=${key#*§}
    local in_protocol=${in_rest/§*}
    local in_ip=${in_rest/*§}

    if test -z "${in_site_name}" -o -z "${in_protocol}" -o -z "${in_ip}"  ; then
	redirect-page "rweb-site"
        return 1
    fi

    local ip1=$(ipcalc -s ${IP_EXTERNAL_IP} ${IP_EXTERNAL_MASK} -n) ; ip1=${ip1/NETWORK=}
    local ip2=$(ipcalc -s ${IP_EXTERNAL_IP} ${IP_EXTERNAL_MASK} -b) ; ip2=${ip2/BROADCAST=}
    local ip_tip="${ip1} < IP < ${ip2}"
    local ip_tip_width=260

    local width i=0

    itemWidth[0]=40
    itemWidth[1]=60

    itemTitle[${i}]="Website Name" ; ((i++))
    itemTitle[${i}]="Protocol" ; ((i++))
    itemTitle[${i}]="Public IP" ; ((i++))

    if test ${in_protocol} == 'https' ; then
	itemTitle[${i}]="TLS Identifier (for HTTPS)" ; ((i++))
	itemTitle[${i}]="TLS Intermediate CA (for HTTPS)" ; ((i++))
	itemTitle[${i}]="HTTP to HTTPS Redirection" ; ((i++))
    fi

    itemTitle[${i}]="Quality of Service (QoS)" ; ((i++))
    itemTitle[${i}]="Standby State" ; ((i++))
    itemTitle[${i}]="Standby URL Protocol" ; ((i++))
    itemTitle[${i}]="Standby Location" ; ((i++))
    itemTitle[${i}]="Backend Web Servers" ; ((i++))
    itemTitle[${i}]="Load Balancing Policy" ; ((i++))
    itemTitle[${i}]="Via Gateways" ; ((i++))

    i=0
    itemID[${i}]="site_name" ; ((i++))
    itemID[${i}]="protocol" ; ((i++))
    itemID[${i}]="ip" ; ((i++))

    if test ${in_protocol} == 'https' ; then
	itemID[${i}]="tls_id" ; ((i++))
	itemID[${i}]="ca_id" ; ((i++))
	itemID[${i}]="rhttp_state" ; ((i++))
    fi

    itemID[${i}]="qos" ; ((i++))
    itemID[${i}]="sb_state" ; ((i++))
    itemID[${i}]="sb_protocol" ; ((i++))
    itemID[${i}]="sb_location" ; ((i++))
    itemID[${i}]="backend_servers" ; ((i++))
    itemID[${i}]="load_balancing" ; ((i++))
    itemID[${i}]="via_gateways" ; ((i++))

    i=0
    itemForm[${i}]="input" ; ((i++))
    itemForm[${i}]="input" ; ((i++))
    itemForm[${i}]="input" ; ((i++))

    if test ${in_protocol} == 'https' ; then
	itemForm[${i}]="select" ; ((i++))
	itemForm[${i}]="select" ; ((i++))
	itemForm[${i}]="select" ; ((i++))
    fi

    itemForm[${i}]="input" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="input" ; ((i++))
    itemForm[${i}]="text" ; ((i++))
    itemForm[${i}]="text" ; ((i++))
    itemForm[${i}]="text" ; ((i++))

    if test ${in_protocol} == 'https' ; then
	i=0
    else
	i=3
    fi

    checkItem[2]=ip
    checkItem[$((4-i))]=percent
    checkItem[$((7-i))]=printable

    local elt range 

    local site_name protocol ip qos
    local tls tls_id ca_id
    local sb_state sb_site_name sb_protocol sb_location

    i=0
    for elt in ${RWEB_SITE_LIST}
    do
	range=$[${i} % 5]
	case ${range} in
	    0)
		site_name=${elt}
		;;
	    1)
		protocol=${elt}
		;;
	    2)
		ip=${elt}
		;;
	    3)
		tls=${elt}
		;;
	    4)
		qos=${elt}
		test ${site_name} != ${in_site_name} -o ${protocol} != ${in_protocol} -o ${ip} != ${in_ip} || break

		;;
	    *)
		return 1
		;;
	esac
	((i++))
    done

    tls_id=${tls/:*}
    mono-elt ${tls//:/ } || ca_id=${tls/*:}

    i=0
    for elt in ${RWEB_SITE_STANDBY_LIST}
    do
	range=$[${i} % 3]
	case ${range} in
	    0)
		sb_site_name=${elt}
		;;
	    1)
		sb_protocol=${elt}
		;;
	    2)
		sb_location=${elt}
		test ${sb_site_name} != ${in_site_name} || break
		;;
	    *)
		return 1
		;;
	esac
	((i++))
    done

    if test "${sb_site_name}" == ${in_site_name} ; then
	sb_state=on
    else
	sb_state=off
    fi

    local color='SeaGreen'

    i=0
    blankItemContent[${i}]="type='text' size='24' maxlength='64' value='${in_site_name}' readonly style='color:${color}; border:0;'" ; ((i++))
    blankItemContent[${i}]="type='text' size='5' maxlength='5' value='${in_protocol}' readonly style='color:${color}; border:0;'" ; ((i++))
    blankItemContent[${i}]="type='text' size='15' maxlength='15' value='${in_ip}' readonly style='color:${color}; border:0;'" ; ((i++))

    if test ${in_protocol} == 'https' ; then

	local rhttp_state

	if is-rweb-http-redirected-to-https ${in_site_name} ; then
	    rhttp_state=on
	else
	    rhttp_state=off
	fi

	blankItemContent[${i}]=$(show-tls-server-list ${tls_id}) ; ((i++))
	blankItemContent[${i}]=$(show-tls-ca-list ${ca_id}) ; ((i++))
	blankItemContent[${i}]=$(show-on-off-state ${rhttp_state}) ; ((i++))
    fi

    blankItemContent[${i}]="type='text' size='3' maxlength='3' value='${qos}'" ; ((i++))
    blankItemContent[${i}]=$(show-on-off-state ${sb_state}) ; ((i++))
    blankItemContent[${i}]=$(show-rweb-sb-protocol ${sb_protocol}) ; ((i++))
    blankItemContent[${i}]="type='text' size='48' maxlength='$[${MAX_LEN} * 3]' value='${sb_location}'" ; ((i++))
    blankItemContent[${i}]="<a href='/${GUI_DIR_NAME}/rweb-host.${GUI_EXT_NAME}?level:2,key:${in_site_name}§${in_protocol}§${in_ip}'>Manage Backend Web Servers</a>" ; ((i++))
    blankItemContent[${i}]="<a href='/${GUI_DIR_NAME}/rweb-balancer.${GUI_EXT_NAME}?level:2,key:${in_site_name}§${in_protocol}§${in_ip}'>Manage Load Balancing Policy</a>" ; ((i++))
    blankItemContent[${i}]="<a href='/${GUI_DIR_NAME}/rweb-via.${GUI_EXT_NAME}?level:2,key:${in_site_name}§${in_protocol}§${in_ip}'>Manage Via Gateways</a>" ; ((i++))

    shortcutMenuItem[0]="tls-server"
    shortcutMenuTitle[0]="Manage Server TLS"

    show-title "Website Settings" "${state}" "rweb tls"
    show-shortcuts-menu
    show-form "${width}" enabled
}

show-rweb-settings "${@}"
