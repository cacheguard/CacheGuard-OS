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

    local dclass checked

    show-title "Configuring a Specific WAF Filter" "enabled" "waf"

    local filters=$(get-filters ${name})
    test -n "${filters}" || filters=${WAF_GENERIC}

    if test ${filters} == ${WAF_GENERIC} ; then
        checked=checked
        dclass='item-not-displayed'
    else
        dclass='item-displayed'
    fi

    echo "<div class='core-form'>"
    show-form-begin
    echo "<table class='highlight-form'>"
    echo "<tr>"
    echo "<th class='table-header'><label for='waf_inherit'>[${name}] Same as Default</label></th>"
    echo "<th class='table-header'><input name='site_name' type='hidden' value='${name}' /><input id='waf_inherit' name='waf_inherit' type='checkbox' ${checked} data-action='collapse-check-zone' data-zone-id='genericfilters'></th>"
    echo "</tr>"
    echo "</table>"
    echo "<div id='genericfilters' class='${dclass}'>"
    echo "<table class='highlight-form'>"
    show-generic-waf ${filters}
    echo "</table>"
    echo "</div>"
    show-do enabled disabled
    show-form-end
    echo "</div>"
}

# Main()

show-waf-rweb-generic-form "${@}"
