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

source functions

show-log()
{
    test -n "${1}" || return 1
    local number=${1}

    [[ "${number}" =~ (^[1-9][0-9]{0,10}|^0)$ ]] || return 2
    test ${number} -le 1000 || return 3

    local log=/var/log/${FIREWALL_LOG}
    local len=${#FW_LOG_TAG} ; ((len++))
    local i=0

    if test ! -s "${log}" ; then
	echo-unavailable-message "the firewall log is empty."
	return 0
    fi

    local rfc3339_time hostname kernel log_prefix input output rest
    local date_time date time
    local src_ip dst_ip proto dst_port reason

    echo "<table class='highlight-log'>"
    echo "<thead>"
    echo "<tr>"
    echo "<th class='table-header'><strong>Date</strong></th>"
    echo "<th class='table-header'><strong>Time</strong></th>"
    echo "<th class='table-header'><strong>Protocol</strong></th>"
    echo "<th class='table-header'><strong>Src IP</strong></th>"
    echo "<th class='table-header'><strong>Input NIC</strong></th>"
    echo "<th class='table-header'><strong>Output NIC</strong></th>"
    echo "<th class='table-header'><strong>Dst IP</strong></th>"
    echo "<th class='table-header'><strong>Dst Port</strong></th>"
    echo "<th class='table-header'><strong>Reason</strong></th>"
    echo "</tr>"
    echo "</thead>"
    echo "<tbody>"

    tac ${log} | while read rfc3339_time hostname kernel log_prefix input output rest
    do
	test ${i} -lt ${number} || break
	test ${log_prefix:0:${len}} == "${FW_LOG_TAG}:" || continue

	date_time=$(gui-get-date-time "${rfc3339_time}")
	date=${date_time/@*}
	time=${date_time/*@}

	reason=${log_prefix:${len}}
	input=${input/IN=}
	output=${output/OUT=}
	
	proto=${rest/*PROTO=} ; proto=${proto/ *}
	src_ip=${rest/*SRC=} ; src_ip=${src_ip/ *}
	dst_ip=${rest/*DST=} ; dst_ip=${dst_ip/ *}
	
	case ${proto} in
	    TCP|UDP)
		dst_port=${rest/*DPT=}
		dst_port=${dst_port/ *}
		;;
	    *)
		unset dst_port
		;;
	esac
	
	case ${proto} in
	    TCP)
		proto=tcp
		;;
	    UDP)
		proto=udp
		;;
	    2)
		proto=igmp
		;;
	    47)
		proto=gre
		;;
	    50)
		proto=esp
		;;
	    51)
		proto=ah
		;;
	    56)
		proto=tlsp
		;;	    
	    62)
		proto=cftp
		;;	    
	    70)
		proto=visa
		;;	    
	    112)
		proto=vrrp
		;;	    
	    133)
		proto=fc
		;;	    
	    89)
		proto=ospfigp
		;;	    
	    92)
		proto=mtp
		;;	    
	    97)
		proto=etherip
		;;	    
	    *)
		;;
	esac
	echo "<tr>"
	echo "<td><span>${date}</span></td>"
	echo "<td><span>${time}</span></td>"
	echo "<td><span>${proto}</span></td>"
	echo "<td><span>${src_ip}</span></td>"
	echo "<td><span>${input}</span></td>"
	echo "<td><span>${output}</span></td>"
	echo "<td><span>${dst_ip}</span></td>"
	echo "<td><span>${dst_port}</span></td>"
	echo "<td><span>${reason}</span></td>"
	echo "</tr>"
	((i++))
    done

    echo "</tbody>"
    echo "</table>"
}

# Main()

gui-run-authentication
show-log "${@}"
