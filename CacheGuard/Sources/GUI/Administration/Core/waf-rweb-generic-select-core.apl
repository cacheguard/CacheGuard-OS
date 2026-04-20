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

show-filter-rweb-select-form()
{
    local i=0 elt range 
    local site_name
    local list

    local width=${DEFAULT_LIST_FORM_WIDTH_2}

    show-title "Specific WAF Filters" disabled "waf"

    echo "<div class='core-form'>"
    echo "<table class='highlight-list' width='${width}'>"
    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header' width='80%'>Site Name</td>"
    echo "<td class='table-header' width='20%'><center>Generic<br />Filter</center></td>"
    echo "</tr>"
    echo "</thead>"
    
    echo "<tbody>"

    for elt in ${RWEB_SITE_LIST}
    do
	range=$[${i} % 5]
	case ${range} in
	    0)
		site_name=${elt}
		;;
	    1|2|3)
		;;
	    4)
		if ! member "${list}" ${site_name} ; then
		    list="${list} ${site_name}"
		    echo "<tr>"
		    echo "<td>${site_name}</td>"
		    echo "<td><center><a href=/${GUI_DIR_NAME}/waf-rweb-generic.${GUI_EXT_NAME}?${site_name}><img name='edit_${nb}' src='/image/edit.png' alt='Edit' title='Edit' align='top' width='20' height='20' /></a></center></td>"
		    echo "</tr>"
		fi
		;;
	    *)
		;;
	esac
	((i++))
    done

    echo "</tbody>"
    echo "</table>"

    if test -z "${RWEB_SITE_LIST}" ; then
	echo "<br />"
	echo "<div style='clear:left;'></div>"
	echo "<div class='table-title'>"
	echo "<span class='table-title' style='fload:left;'>&lt;no reverse Web site has been defined&gt;</span>"
	echo "<span class='shortcut-menu-item' style='display:inline;'><a href='rweb-site.${GUI_EXT_NAME}'>Add rWeb</a></span>"
	echo "</div>"
    fi

    echo "</div>"
}

# Main()

show-filter-rweb-select-form
