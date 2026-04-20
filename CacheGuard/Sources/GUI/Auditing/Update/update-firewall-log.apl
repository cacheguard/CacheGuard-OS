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

show-log()
{
    test -n "${1}" || return 1
    local number=${1}

    [[ "${number}" =~ (^[1-9][0-9]{0,10}|^0)$ ]] || return 2
    test ${number} -le 1000 || return 3

    local log=/var/log/${FIREWALL_LOG}
    local style="style='word-wrap:break-word;'"
    local len=${#FW_LOG_TAG} ; ((len++))
    local i=0

    if test ! -s "${log}" ; then
	echo "<div style='font-style:italic;'>&lt;The IP firewall log is empty&gt;</div>"
	return 0
    fi

    local rfc3339_time hostname kernel log_prefix input output rest
    local src_ip dst_ip proto dst_port reason

    echo "<table class='highlight-list' width:100%;'>"
    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header'><strong>Date</strong></td>"
    echo "<td class='table-header'><strong>Protocol</strong></td>"
    echo "<td class='table-header'><strong>Src IP</strong></td>"
    echo "<td class='table-header'><strong>Input NIC</strong></td>"
    echo "<td class='table-header'><strong>Output NIC</strong></td>"
    echo "<td class='table-header'><strong>Dst IP</strong></td>"
    echo "<td class='table-header'><strong>Dst Port</strong></td>"
    echo "<td class='table-header'><strong>Reason</strong></td>"
    echo "</tr>"
    echo "</thead>"
    echo "<tbody>"

    tac ${log} | while read rfc3339_time hostname kernel log_prefix input output rest
    do
	test ${i} -lt ${number} || break
	test ${log_prefix:0:${len}} == "${FW_LOG_TAG}:" || continue
	
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
	echo "<td><span ${style}>${rfc3339_time}</span></td>"
	echo "<td><span ${style}>${proto}</span></td>"
	echo "<td><span ${style}>${src_ip}</span></td>"
	echo "<td><span ${style}>${input}</span></td>"
	echo "<td><span ${style}>${output}</span></td>"
	echo "<td><span ${style}>${dst_ip}</span></td>"
	echo "<td><span ${style}>${dst_port}</span></td>"
	echo "<td><span ${style}>${reason}</span></td>"
	echo "</tr>"
	((i++))
    done

    echo "</tbody>"
    echo "</table>"
}

# Main()

gui-run-authentication
show-log "${@}"
