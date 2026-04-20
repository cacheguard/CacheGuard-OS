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

show-urllist-update-log()
{
    echo "<div class='core-form'>"
    refresh-buttons "update_urllist_update( 1 )"
    echo "<div style='clear:left;'></div>"
    echo "<br /><span class='table-title'>Last URL lists update report&nbsp;</span>"
    echo "<div style='clear:left;'></div><br />"
    echo "<div id='${AUTO_REPORT_ID}' class='log-report'></div>"
    echo "</div>"
}

guard-update()
{
    local width state

    test "${REMOTE_USER}" == "${ADMIN_NAME}" || state=disabled

    local autos=$(ls ${URLLIST_DIR}/*.${URLLIST_AUTO}.current 2> /dev/null)
    test -n "${autos}" || state=disabled

    shortcutMenuItem[0]="urllist-auto"
    shortcutMenuTitle[0]="Auto load configuration"

    show-title "Update Guard Lists" "${state}" "urllist"
    show-shortcuts-menu
    show-form "${width}" "${state}" show-urllist-update-log
}

# Main()

guard-update
