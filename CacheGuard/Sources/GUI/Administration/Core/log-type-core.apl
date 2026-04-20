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

show-log-type-options()
{
    test -n "${1}" || return 1
    in_state=${1}

    local state selected option

    for state in True False
    do
	selected=$(get-selected-option ${state} ${in_state})
	case ${state} in
	    True)
		option=on
		;;
	    False)
		option=off
		;;
	    *)
		;;
	esac
	echo "<option value='${option}'${selected}>${option}</option>"
    done
}

show-log-type()
{
    itemTitle[0]="Forwarding Web Traffic"
    itemTitle[1]="Reverse Website Traffic"
    itemTitle[2]="Rejected URL Access"
    itemTitle[3]="Rejected Malware in Web Traffic"
    itemTitle[4]="Rejected Malware in Other Traffic"
    itemTitle[5]="Rejected Web Request / Response"
    itemTitle[6]="Denied Network Traffic"

    itemID[0]="web"
    itemID[1]="rweb"
    itemID[2]="guard"
    itemID[3]="antivirus"
    itemID[4]="avserver"
    itemID[5]="waf"
    itemID[6]="firewall"

    shortcutMenuItem[0]="log-syslog"
    shortcutMenuTitle[0]="SysLog Servers"

    show-title "Traffic Logging" "enabled" "log"

    echo "<div class='core-form'>"
    show-form-begin 2
    show-shortcuts-menu

    echo "<table class='highlight-form' width='400'>"

    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header' width='60%' align='center'>Traffic Type</td>"
    echo "<td class='table-header' width='20%' align='center'>Logging</td>"
    echo "<td class='table-header' width='20%' align='center'>Remote<br />Logging</td>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    local n=${#itemID[@]}
    local i item title log syslog

    for ((i=0 ; i<n ; i++))
    do
	item=${itemID[${i}]}
	title=${itemTitle[${i}]}
	
	case ${item} in
	    web)
		log=${LOG_TYPE_WEB/:*}
		syslog=${LOG_TYPE_WEB/*:}
		;;
	    rweb)
		log=${LOG_TYPE_RWEB/:*}
		syslog=${LOG_TYPE_RWEB/*:}
		;;
	    guard)
		log=${LOG_TYPE_GUARD/:*}
		syslog=${LOG_TYPE_GUARD/*:}
		;;
	    antivirus)
		log=${LOG_TYPE_ANTIVIRUS/:*}
		syslog=${LOG_TYPE_ANTIVIRUS/*:}
		;;
	    avserver)
		log=${LOG_TYPE_ANTIVIRUS_SERVER/:*}
		syslog=${LOG_TYPE_ANTIVIRUS_SERVER/*:}
		;;
	    waf)
		log=${LOG_TYPE_WAF/:*}
		syslog=${LOG_TYPE_WAF/*:}
		;;
	    firewall)
		log=${LOG_TYPE_FIREWALL/:*}
		syslog=${LOG_TYPE_FIREWALL/*:}
		;;
	    *)
		;;
	esac

	echo "<tr>"

	echo "<td>${title}</td>"

	echo "<td align='center'>"
	echo "<select name='log_${item}'>"
	show-log-type-options ${log}
	echo "</select>"
	echo "</td>"

	echo "<td align='center'>"
	echo "<select name='syslog_${item}'>"
	show-log-type-options ${syslog}
	echo "</select>"
	echo "</td>"

	echo "</tr>"
    done

    echo "</tbody>"
    echo "</table>"

    show-do
    show-form-end
    echo "</div>"
}

# Main()

show-log-type
