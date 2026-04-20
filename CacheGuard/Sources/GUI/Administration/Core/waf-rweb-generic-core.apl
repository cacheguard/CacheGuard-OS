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

source waf-common.${GUI_EXT_NAME}

get-filters()
{
    test -n "${1}" || return 1
    local in_name=${1}

    local i=0 elt rang

    for elt in ${WAF_RWEB_GENERIC}
    do
	rang=$[${i} % 2]
	case ${rang} in
	    0)
		name=${elt}
		;;
	    1)
		filters=${elt}
		if test ${name} == ${in_name} ; then
		    echo ${filters}
		    return 0
		fi
		;;
	    *)
		echo "Unknown"
		return 1
		;;
	esac
	((i++))
    done
}

show-waf-rweb-generic-form()
{
    local name="${1}"
    if test -z "${name}" ; then
	redirect-page "waf-rweb-generic-select"
	return 0
    fi

    local length=8 width=300

    show-title "Configuring a Specific WAF Filter" "enabled" "waf"

    local filters=$(get-filters ${name})
    test -n "${filters}" || filters=${WAF_GENERIC}
    if test ${filters} == ${WAF_GENERIC} ; then
        local checked=checked
        local hide=1
        local display=none
    else
        local hide=0
        local display=inline
    fi

    echo "<div class='core-form'>"
    show-form-begin ${length}
    echo "<table style='margin:0; margin-bottom:5px;'>"
    echo "<tr>"
    echo "<td width='20'>"
    echo "<input name='site_name' type='hidden' value='${name}' />"
    echo "<input id='waf_inherit' name='waf_inherit' valign='middle' type='checkbox' ${checked} onClick=\"collapseCheckZone( 'waf_inherit', 'genericfilters', 1 )\"></td> <td valign='middle'><span class='table-title'>[${name}] Same as Default</span>"
    echo "</td>"
    echo "</tr>"
    echo "</table>"
    echo "<div id='genericfilters' style='float:left;display:${display};'>"
    echo "<table class='highlight-form' width='${width}'>"
    show-generic-waf ${filters}
    echo "</table>"
    echo "</div>"
    echo "<div style='clear:left;'></div>"
    show-do enabled disabled
    echo "<div style='clear:left;'></div>"
    show-form-end
    echo "</div>"
}

# Main()

show-waf-rweb-generic-form "${@}"
