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

manager-sync-report()
{
    show-title "Manager Peers Synchronisation Report" disabled "manager" '' enable

    echo "<div class='core-form' style='margin-top:0;'>"
    refresh-buttons "update_manager_sync_report( 1 )"
    echo "<div style='clear:left;'></div>"
    echo "<div id='${AUTO_REPORT_ID}'></div>"
    echo "</div>"
}

# Main()

manager-sync-report "${@}"
