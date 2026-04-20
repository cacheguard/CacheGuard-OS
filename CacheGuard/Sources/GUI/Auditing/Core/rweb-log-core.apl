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

run()
{
    local audit_title="Last rWeb accesses"

    show-title "Reverse Web Access Log" disabled
    show-audit-log-nb "${audit_title}"
    
    echo "<form name='mainform' id='mainform'></form>"

    echo "<div class='core-form'>"
    refresh-buttons "update_rweb_log( 1 )" "margin-left:1px;"
    echo "<div style='clear:left;'></div>"
    echo "<p>"
    echo "<input id='sitename' type='hidden' value=''>"
    echo "<div id='${AUTO_REPORT_ID}' class='web-log'>"
    echo "</div>"
    echo "</div>"

    show-scroll-top
}

run
