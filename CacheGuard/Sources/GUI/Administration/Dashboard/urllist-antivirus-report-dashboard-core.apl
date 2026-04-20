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

source urllist-antivirus-report-common.${GUI_EXT_NAME}
source /home/${ADMIN_NAME}/${ENV_RDIR}/${ENV_CURRENT_NAME}

show-urllist-antivirus-report-dashboard()
{
    perform-js-code "var PRELOADED_IMAGES = new Array( ); function runPreloadImages( ) { for (var i = 0 ; i < arguments.length ; i++) {PRELOADED_IMAGES[i] = document.createElement('img'); PRELOADED_IMAGES[i].setAttribute( 'src', \"${IMAGE_DIR}/\" + arguments[i] ); }}; runPreloadImages( 'rotating_arrow.gif' );"
    show-urllist-antivirus-report
}

# Main()

show-urllist-antivirus-report-dashboard
