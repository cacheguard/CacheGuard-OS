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

show-panel-board()
{
    local action=${1}

    local i n=${#MENU_PAGE[@]}

    process-main-action ${action}
    show-title "Web Auditing GUI" disabled

    echo "<form name='mainform' id='mainform'></form>"

    for ((i=0 ; i<n ; i++))
    do
	echo "<div class='item-board'><a href='/${GUI_DIR_NAME}/${MENU_PAGE[${i}]}.${GUI_EXT_NAME}'><center><img alt='${MENU_PAGE_TITLE[${i}]}' title='${MENU_PAGE_TITLE[${i}]}' src='/image/${MENU_PAGE[${i}]}.png' align= 'top' /></center><h4>${MENU_PAGE_TITLE[${i}]}</h4></a></div>"
    done

    echo "<div style='clear:left'></div>"
}

# Main()

show-panel-board "${@}"
