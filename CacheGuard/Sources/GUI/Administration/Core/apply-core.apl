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

show-apply-log()
{
    refresh-buttons "update_apply( 1 )"

    echo "<div style='clear:left;'></div><br />"
    echo "<span class='table-title'>Last apply report</span>"
    echo "<div style='clear:left;'></div>"
    echo "<div id='${AUTO_REPORT_ID}' class='log-report'></div>"
}

show-apply-form()
{
    local width=200 state=enabled
    local check_id='check' checked

    test "${ATTRIBUTES[0]}" != ${check_id} -o "${VALUES[0]}" != 'on' || checked=' checked'

    itemWidth[0]=90
    itemWidth[1]=10

    itemTitle[0]="Check Integrity Only"
    itemID[0]=${check_id}
    blankItemContent[0]="type='checkbox'${checked}"

    shortcutMenuItem[0]="cancel"
    shortcutMenuTitle[0]="Cancel Changes"

    show-title "Apply New Configuration" "${state}" "apply cancel"
    show-shortcuts-menu
    show-form "${width}" "${state}" show-apply-log
}

# Main()

show-apply-form
