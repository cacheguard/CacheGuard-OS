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

show-antivirus-create-log()
{
    local extended=${1}
    extended=${extended//+/ }

    refresh-buttons
    echo "<div class='table-title'>Last ${extended}antivirus signature DB creation report</div>"
    echo "<div id='${AUTO_REPORT_ID}' class='log-report'></div>"
}

show-av-create-form()
{
    local state width
    local extended
    local i=0

    test ${APL_ROLE} == 'gateway' || extended="extended "
    test "${REMOTE_USER}" == "${ADMIN_NAME}" || state=disabled

    if test ${APL_ROLE} == gateway ; then
	shortcutMenuItem[${i}]="mode-feature"
	shortcutMenuTitle[${i}]="Activate the antivirus"
	((i++))
    fi

    shortcutMenuItem[${i}]="antivirus"
    shortcutMenuTitle[${i}]="Configure the antivirus"
    ((i++))

    show-title "Create ${extended^}Antivirus Signature DB" "${state}" "antivirus"
    show-form "${width}" "${state}" show-antivirus-create-log ${extended// /+}
}

# Main()

show-av-create-form
