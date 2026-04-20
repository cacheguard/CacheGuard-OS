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

show-list-logs()
{
    local width=${1}
    test -n "${width}" || width=100

    local left=35
    local right=65

    local logs=$(ls -r /var/log/system.[0-9]*.log.[0-9]*.tar.gz 2> /dev/null)
    local log date seconds serial rest

    echo "<div style='clear:left;'></div><br />"

    if test -n "${logs}" ; then
        echo "<div class='table-title'>Archived logs</div>"
	echo "<table class='highlight-list' width='${width}'>"
        echo "<thead>"
        echo "<tr>"
        echo "<td class='table-header' width='${left}%'>Serial Nb</td>"
        echo "<td class='table-header' width='${right}%' align='right'>Date</td>"
        echo "</tr>"
        echo "</thead>"
        echo "<tbody>"
	for log in ${logs}
	do
            rest=${log/*system\.} ; seconds=${rest/\.*/}
            rest=${rest/*\.log\./} ; serial=${rest/\.tar.gz/}
            date=$(get-date-from-epoch-seconds ${seconds})
            echo "<tr>"
            echo "<td>Serial ${serial}</td>"
            echo "<td align='right'>${date}</td>"
            echo "</tr>"
	done
        echo "</tbody>"
	echo "</table>"
	echo "<br />"
    else
	echo-unavailable-message "There is no archived logs yet."
    fi
}

print-option-type()
{
    local log log_name
    local selected

    for log in \
	${WEB_LOG} \
	    ${RWEB_LOG} \
	    ${FIREWALL_LOG} \
	    ${ACCESS_GUARD_LOG} \
	    ${ANTI_VIRUS_LOG} \
	    ${ANTI_VIRUS_SERVER_LOG} \
	    ${WAF_LOG} \
	    ${VPN_IPSEC_LOG} \
	    system.log
    do
	log_name=${log/\.log}
	if test ${log_name} == "${VALUES[0]}" ; then
	    selected=selected
	else
	    unset selected
	fi
	echo -n "<option value='${log_name}' ${selected}>${log_name}</option>"
    done
}

show-log-rotate-nb()
{
    local i selected

    for ((i=1 ; i<= ${LOGROTATE_NB} ; i++))
    do
	if test ${i} == "${VALUES[1]}" ; then
	    selected=selected
	else
	    unset selected
	fi
	echo -n "<option value='${i}' ${selected}>${i}</option>"
    done

}

show-log-save-form()
{
    local width=400
    local state

    itemWidth[0]=30
    itemWidth[1]=70

    itemTitle[0]="Type"
    itemTitle[1]="Serial (Day)"
    itemTitle[2]="Protocol"
    itemTitle[3]="File Server"
    itemTitle[4]="File Path"

    itemID[0]="type"
    itemID[1]="serial"
    itemID[2]="protocol"
    itemID[3]="server"
    itemID[4]="filename"

    local file_servers=$(show-file-servers 'cur' ${VALUES[3]})
    test -n "${file_servers}" || state=disabled

    blankItemContent[0]="$(print-option-type)"
    blankItemContent[1]="$(show-log-rotate-nb)"
    blankItemContent[2]="$(show-file-protocol1 ${VALUES[2]:1})"
    blankItemContent[3]=${file_servers}
    blankItemContent[4]="type='text' size='48' maxlength='128' value='${VALUES[4]}'"

    checkItem[4]=printable

    itemForm[0]="select"
    itemForm[1]="select"
    itemForm[2]="select"
    itemForm[3]="select"

    shortcutMenuItem[0]="access-file"
    shortcutMenuItem[1]="log-rotate"
    shortcutMenuTitle[0]="File Servers"
    shortcutMenuTitle[1]="Rotate Logs"

    show-title "Save Logs" "${state}" "access log password"
    show-shortcuts-menu
    show-form "${width}" "${state}" show-list-logs ${width}
}

# Main()

show-log-save-form
