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

source functions

extract-ike-sa-id()
{
    local id=${1}
    local bracket=${2}

    id=${id/site-}
    id=${id/${bracket}*}

    echo ${id}
}

extract-ike-remote-id()
{
    local string=${1}

    local id=${string/*...}

    id=${id/*\[}
    id=${id/\]}
    id=${id/*, CN=}

    echo ${id}
}

extract-ike-remote-public-ip()
{
    local string=${1}

    local ip=${string/*...}
    ip=${ip/\[*}

    echo ${ip}
}

extract-ike-remote-private-ip()
{
    local string=${1}

    local ip=${string#*=== }

    echo ${ip}
}

show-log()
{
    test -n "${1}" || return 1
    local number=${1}

    [[ "${number}" =~ (^[1-9][0-9]{0,10}|^0)$ ]] || return 2
    test ${number} -le 1000 || return 3

    local log=/var/log/${VPN_IPSEC_LOG}

    if test ! -s "${log}" ; then
	echo "<div style='font-style:italic;'>&lt;The IPsec VPN log is empty&gt;</div>"
	return 0
    fi

    local time machine process ike key rest
    local remote_public_ip remote_private_ip vpn_id remote_id state title
    local vpn_id_bgcolor ike_bgcolor remote_id_bgcolor remote_public_ip_bgcolor remote_private_ip_bgcolor
    local i=0

    local style_margin="style='margin:0; margin-right:10px;'"
    local na_bgcolor=" bgcolor='${EMPTY_COLOR}'"

    echo "<table class='highlight-list' width:100%;'>"
    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header'><strong>Date</strong></td>"
    echo "<td class='table-header'><strong>VPN Id</strong></td>"
    echo "<td class='table-header'><strong>Tracking</strong></td>"
    echo "<td class='table-header'><strong>Remote Id</strong></td>"
    echo "<td class='table-header'><strong>Remote<br />Public IP</strong></td>"
    echo "<td class='table-header'><strong>Remote<br />Private IP</strong></td>"
    echo "<td class='table-header'><strong>State</strong></td>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    tac ${log} | while read time machine process ike key rest
    do
	test ${i} -lt ${number} || break

	unset vpn_id remote_id remote_public_ip remote_private_ip
	unset vpn_id_bgcolor remote_id_bgcolor remote_public_ip_bgcolor remote_private_ip_bgcolor

	case ${key} in
	    IKE_SA)
		if test "${rest}" == "deleted" ; then
		    continue
		else
		    vpn_id=${rest/ *}
		    vpn_id=$(extract-ike-sa-id "${vpn_id}" '\[')
		    ike=${ike/\[*}
		    remote_public_ip=$(extract-ike-remote-public-ip "${rest}")
		    remote_id=$(extract-ike-remote-id "${rest}")
		    remote_private_ip_bgcolor=${na_bgcolor}
		    state=1
		fi
		;;
	    CHILD_SA)
		vpn_id=${rest/ *}
		vpn_id=$(extract-ike-sa-id "${vpn_id}" '\{')
		ike=${ike/\[*}
		remote_public_ip_bgcolor=${na_bgcolor}
		remote_id_bgcolor=${na_bgcolor}
		remote_private_ip=$(extract-ike-remote-private-ip "${rest}")
		state=1
		;;
	    deleting)
		vpn_id=${rest/IKE_SA }
		vpn_id=$(extract-ike-sa-id "${vpn_id}" '\[')
		ike=${ike/\[*}
		remote_public_ip=$(extract-ike-remote-public-ip "${rest}")
		remote_id_bgcolor=${na_bgcolor}
		remote_private_ip_bgcolor=${na_bgcolor}
		state=2
		;;
	    *)
		if test "${rest}" == "is initiating an IKE_SA" ; then
		    vpn_id_bgcolor=${na_bgcolor}
		    ike=${ike/\[*}
		    remote_public_ip=${key}
		    remote_id_bgcolor=${na_bgcolor}
		    remote_private_ip_bgcolor=${na_bgcolor}
		    state=0
		else
		    continue
		fi
		;;  
	esac

	case ${state} in
	    0)
		title="Initiating"
		state="<img alt='${title}' title='${title}' src='${IMAGE_DIR}/refresh.png' />"
		;;
	    1)
		title="Established"
		state="<img alt='${title}' title='${title}' src='${IMAGE_DIR}/ok.png' />"
		;;
	    2)
		title="Deleting"
		state="<img alt='${title}' title='${title}' src='${IMAGE_DIR}/delete.png' />"
		;;
	    *)
		;;
	esac

	echo "<tr>"
	echo "<td><span ${style_margin}>${time}</span></td>"
	echo "<td${vpn_id_bgcolor}><span ${style_margin}>${vpn_id}</span></td>"
	echo "<td${ike_bgcolor}><span>${ike}</span></td>"
	echo "<td${remote_id_bgcolor}><span ${style_margin}>${remote_id}</span></td>"
	echo "<td${remote_public_ip_bgcolor}><span ${style_margin}>${remote_public_ip}</span></td>"
	echo "<td${remote_private_ip_bgcolor}><span ${style_margin}>${remote_private_ip}</span></td>"
	echo "<td><center>${state}</center></td>"
	echo "</tr>"
	((i++))
    done

    echo "</tbody>"
    echo "</table>"
}

# Main()

gui-run-authentication
show-log "${@}"
