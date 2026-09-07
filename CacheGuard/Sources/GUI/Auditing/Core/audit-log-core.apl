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

show-sites()
{
    local rwebs=${1}
    test -n "${rwebs}" || return 1

    local rweb

    echo "<tr>"
    echo "<td>Site Name</td>"
    echo "<td>"

    echo "<select id='sitename' data-action='update-audit-log' data-force='1'>"

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
    local rwebs=$(ls ${WAUDITDIR} 2> /dev/null)

    if test -z "${rwebs}" ; then
	echo "<br />"
	echo-unavailable-message "no reverse Web site has been configured in audit mode."
	return 0
    fi

    echo "<div class='core-form'>"
    echo "<form>"
    echo "<table class='highlight-form'>"

    show-sites "${rwebs}"
    show-audit-log-nb-tr "Last Web Requests"

    echo "</table>"
    echo "</form>"

    refresh-buttons audit

    echo "<div id='${AUTO_REPORT_ID}'></div>"
    echo "</div>"
}

run
