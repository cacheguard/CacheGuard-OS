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

filter-checked()
{
    test -n "${1}" || return 1
    
    case "${1}" in
	1)
	    echo -n checked
	    return 0
	    ;;
	0)
	    return 0
	    ;;
	*)
	    return 1
	    ;;
    esac
}

show-generic-waf()
{
    test -n "${1}" || return 1
    local filters=${1}

    local left=90
    local right=10

    set-generic-rule-table

    local i len=${#WAF_GENERIC_FILTER_ID[@]}
    local filter_id filter_name

    for ((i=0;i<len;i++))
    do
	filter_id=${WAF_GENERIC_FILTER_ID[${i}]}
	filter_name=${WAF_GENERIC_FILTER_NAME[${i}]}
	echo "<tr>"
	echo "<td width='${left}%'><label for='waf_${filter_id}'>${filter_name}</label></td>"
	echo "<td width='${right}%' align='right'><input id='waf_${filter_id}' name='waf_${filter_id}' type='checkbox' style='border:0;' $(filter-checked ${filters:${i}:1}) /></td>"
	echo "</tr>"
	unset filter_name
    done
}
