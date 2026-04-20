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

show-vpnipsec-report()
{
    test -n "${1}" || return 1
    local report_type=${1}

    local width labels label_index unavailable
    declare -a labels

    echo "<div class='core-form'>"

    if test ${CURRENT_VPN_IPSEC_MODE} == 'False' ; then
	echo-content-unavailable 350 "The IPsec VPN Server is not enabled."
	echo "</div>"
	return 0
    fi

    local access_mode=${CURRENT_VPN_IPSEC_ACCESS/ *}

    labels[0]="Remote Access"
    labels[1]="Site to Site"

    case ${report_type} in
	site)
	    width=500
	    label_index=1
	    test ${access_mode} == 'off' || unavailable=yes
	    ;;
	access)
	    width=600
	    label_index=0
	    test ${access_mode} == 'on' || unavailable=yes
	    ;;
	*)
	    return 11
	    ;;
    esac

    if test -n "${unavailable}" ; then
	echo-content-unavailable 400 "The IPsec VPN Server is not in ${labels[${label_index}]} mode."
	echo "</div>"
	return 0
    fi

    execute-command-nolog "vpnipsec report"

    if test ! -f ${RUN_DIR}/${VPN_IPSEC_STATUS_FILENAME} ; then
	echo-content-unavailable 350 "The IPsec VPN Report is unavailable."
	echo "</div>"
	return 0
    fi

    local connection status remote_address remote_id duration
    local td_style="style='height:20px;'"
    local refresh_time=$(date +"%H:%M:%S" 2> /dev/null)

    echo "<div style='float:left;'>"
    echo "<table class='highlight-form' style='margin-bottom:5px;' width='$((width/2 -1))'>"
    echo "<tr>"
    echo "<td ${td_style}>Appliance Refresh Time</td>"
    echo "<td ${td_style} align='right'>${refresh_time}</td>"
    echo "</tr>"
    echo "</table>"
    echo "</div>"

    echo "<div style='float:left;'>"
    echo "<table class='highlight-form' style='margin-left:2px; margin-bottom:5px;' width='$((width/2 -1))'>"
    echo "<tr>"
    echo "<td ${td_style}>IPsec VPN mode</td>"
    echo "<td ${td_style}>${labels[${label_index}]}</td>"
    echo "</tr>"
    echo "</table>"
    echo "</div>"

    echo "<div style='clear:left; margin:0; margin-bottom:5px;'></div>"

    echo "<table class='highlight-list' width='${width}'>"
    echo "<thead>"
    echo "<tr>"
    if test ${access_mode} == 'off' ; then
	echo "<td class='table-header indicator-table-header' width='24%' align='left'>IPsec VPN ID</td>"
	echo "<td class='table-header' width='20%'>Remote IP</td>"
	echo "<td class='table-header' width='26%' align='center'>Duration</td>"
	echo "<td class='table-header' width='10%' align='center'>Status</td>"
    else
	echo "<td class='table-header' width='30%'>Remote ID</td>"
	echo "<td class='table-header indicator-table-header' width='20%' align='left'>Private IP</td>"
	echo "<td class='table-header' width='20%'>Public IP</td>"
	echo "<td class='table-header' width='20%' align='center'>Duration</td>"
	echo "<td class='table-header' width='10%' align='center'>Status</td>"
    fi

    echo "</tr>"
    echo "</thead>"
    echo "<tbody>"

    while read connection status remote_address remote_id duration
    do
	echo "<tr>"
	case ${status} in
	    ESTABLISHED)
		status="<center><img src='${IMAGE_DIR}/ok.png' /></center>"
		;;
	    CONNECTING)
		status="<center><img src='${IMAGE_DIR}/rotating_arrow.gif' /></center>"
		;;
	    KO)
		status="<center><img src='${IMAGE_DIR}/ko.png' title='KO' /></center>"
		;;
	    *)
		status="<center><img src='${IMAGE_DIR}/rotating_arrow.gif' /></center>"
		;;
	esac

	test "${remote_address}" != nil || unset remote_address
	if test ${access_mode} == 'off' ; then
	    echo "<td>${connection#site-}</td>"
	    echo "<td>${remote_address}</td>"
	    echo "<td>${duration}</td>"
	    echo "<td>${status}</td>"
	else
	    echo "<td>${remote_id}</td>"
	    echo "<td>${connection}</td>"
	    echo "<td>${remote_address}</td>"
	    echo "<td>${duration}</td>"
	    echo "<td>${status}</td>"
	fi
	echo "</tr>"
    done < ${RUN_DIR}/${VPN_IPSEC_STATUS_FILENAME}

    echo "</tbody>"
    echo "</table>"
    echo "</div>"
}
