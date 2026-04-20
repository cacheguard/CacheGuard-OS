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

show-sites()
{
    local rwebs=$(ls ${WAUDITDIR} 2> /dev/null)

    test -n "${rwebs}" || return 1

    local rweb

    echo "<tr>"
    echo "<td width='25%'>Site Name</td>"
    echo "<td width='75%'>"

    echo "<select id='sitename' onChange='update_audit_log(1);'>"

    for rweb in ${rwebs}
    do
	echo -n "<option value='${rweb}'>${rweb}</option>"
    done

    echo "</select>"

    echo "</td>"
    echo "</tr>"
}

run()
{
    show-title "Reverse Web auditing" disabled

    echo "<div class='core-form'>"
    echo "<table class='highlight-form' style='table-layout:fixed; width:750px;'>"

    show-sites

    if test ${?} -eq 0 ; then

	echo "<tr>"
	echo "<td width='25%'>Last URIs</td>"
	echo "<td width='75%'>"
	echo "<select id='last'>"
	echo -n "<option value='10' selected>10</option>"
	echo -n "<option value='25'>25</option>"
	echo -n "<option value='50'>50</option>"
	echo -n "<option value='75'>75</option>"
	echo -n "<option value='100'>100</option>"
	echo -n "<option value='200'>200</option>"
	echo -n "<option value='300'>300</option>"
	echo "</select>"
	echo "</td>"
	echo "</tr>"
	echo "</table>"

	echo "<form name='mainform' id='mainform'></form>"

	refresh-buttons "update_audit_log( 1 )" "margin-left:1px;"
	echo "<div style='clear:left;'></div>"
	echo "<div id='${AUTO_REPORT_ID}'>"
	echo "</div>"
    else
	echo "<tr>"
	echo "<td width=100%>"
	echo "<input type='hidden' id='${AUOTO_UPDATE_ID}'>"
	echo "<style='font-size:11px; font-style:italic;'>&lt;No reverse Web site has been configured in audit mode&gt;</div>"
	echo "</td>"
	echo "</tr>"

        echo "<tr>"
        echo "<td width=100%><input name='${AUOTO_UPDATE_ID}' type='hidden'></td>"
        echo "</tr>"
	
	echo "</table>"
    fi
    echo "</div>"
}

run
