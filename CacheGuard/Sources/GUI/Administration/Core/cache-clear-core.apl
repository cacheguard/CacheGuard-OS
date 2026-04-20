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

show-cache-clear-log()
{
    echo "<div class='core-form'>"
    refresh-buttons "update_cache_clear( 1 )"
    echo "<div style='clear:left;'></div><br />"
    echo "<span class='table-title'>Last cache clearing report</span>"
    echo "<div style='clear:left;'></div>"
    echo "<div id='${AUTO_REPORT_ID}' class='log-report'></div>"
    echo "</div>"
}

show-cache-clear-form()
{
    local width

    local state
    test "${REMOTE_USER}" == "${ADMIN_NAME}" || state=disabled

    shortcutMenuItem[0]="mode-feature"
    shortcutMenuItem[1]="cache-size"
    shortcutMenuTitle[0]="Activate the caching"
    shortcutMenuTitle[1]="Configure the caching"

    show-title "Clear Web Cache" "${state}" "cache"
    show-shortcuts-menu
    show-form "${width}" "${state}" show-cache-clear-log
}

# Main()

show-cache-clear-form
