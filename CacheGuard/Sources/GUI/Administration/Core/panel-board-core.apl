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

show-panel-board()
{
    local action=${1}

    local extension=$(gui-get-contextual-menu-extension)

    process-main-action ${action}
    show-title "Web Administration GUI" disabled

    echo "<script type='text/javascript' src='${JS_DIR}/board-menu${extension}-${GUI_FE_VERSION}.js'></script>"

    echo "<div class='panel-board-container'>"
    echo "<div class='arrowlistmenu'>"
    cat ${ETC_HTML_DIR}/board-menu${extension}.html
    echo "</div>"

    echo "<div class='icon-board'>"
    cat ${ETC_HTML_DIR}/board-icon${extension}.html
    echo "</div>"
    echo "</div>"
}

# Main()

show-panel-board "${@}"
