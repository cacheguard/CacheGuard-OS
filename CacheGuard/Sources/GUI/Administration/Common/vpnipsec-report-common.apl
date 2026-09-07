#!/bin/bash

###########################################################################
#
# MODULE:       GUI
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

    local labels label_index unavailable
    declare -a labels

    if test ${CURRENT_VPN_IPSEC_MODE} == 'False' ; then
	echo-unavailable-message "the IPsec VPN server is not enabled."
    	return 0
    fi

    local access_mode=${CURRENT_VPN_IPSEC_ACCESS/ *}

    labels[0]="Remote Access"
    labels[1]="Site to Site"

    case ${report_type} in
	site)
	    label_index=1
	    test ${access_mode} == 'off' || unavailable=yes
	    ;;
	access)
	    label_index=0
	    test ${access_mode} == 'on' || unavailable=yes
	    ;;
	*)
	    return 11
	    ;;
    esac

    if test -n "${unavailable}" ; then
	echo-unavailable-message "the IPsec VPN server is not in ${labels[${label_index}]} mode."
	return 0
    fi

    execute-command-nolog "vpnipsec report"

    if test ! -f ${RUN_DIR}/${VPN_IPSEC_STATUS_FILENAME} ; then
	echo-unavailable-message "the IPsec VPN Report is unavailable."
	return 0
    fi

    local connection status remote_address remote_id duration
    local refresh_time=$(date +"%H:%M:%S" 2> /dev/null)

    echo "<table class='highlight-form'>"
    echo "<tr>"
    echo "<td>Appliance Refresh Time</td>"
    echo "<td>${refresh_time}</td>"
    echo "</tr>"
    echo "</table>"

    echo "<table class='highlight-form'>"
    echo "<tr>"
    echo "<td>IPsec VPN mode</td>"
    echo "<td>${labels[${label_index}]}</td>"
    echo "</tr>"
    echo "</table>"

    echo "<table class='highlight-list'>"
    echo "<thead>"
    echo "<tr>"
    if test ${access_mode} == 'off' ; then
	echo "<th class='table-header' align='left'>IPsec VPN ID</th>"
	echo "<th class='table-header'>Remote IP</th>"
	echo "<th class='table-header' align='center'>Duration</th>"
	echo "<th class='table-header' align='center'>Status</th>"
    else
	echo "<th class='table-header'>Remote ID</th>"
	echo "<th class='table-header' align='left'>Private IP</th>"
	echo "<th class='table-header'>Public IP</th>"
	echo "<th class='table-header' align='center'>Duration</th>"
	echo "<th class='table-header' align='center'>Status</th>"
    fi

    echo "</tr>"
    echo "</thead>"
    echo "<tbody>"

    while read connection status remote_address remote_id duration
    do
	echo "<tr>"
	case ${status} in
	    ESTABLISHED)
		status="<center><img class='small' src='${IMAGE_DIR}/ok.png' /></center>"
		;;
	    CONNECTING)
		status="<center><img class='small' src='${IMAGE_DIR}/rotating_arrow.gif' /></center>"
		;;
	    KO)
		status="<center><img class='small' src='${IMAGE_DIR}/ko.png' title='KO' /></center>"
		;;
	    *)
		status="<center><img class='small' src='${IMAGE_DIR}/rotating_arrow.gif' /></center>"
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
}
