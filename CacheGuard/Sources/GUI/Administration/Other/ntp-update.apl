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

source functions

ntp-synchronise()
{
    execute-command "ntp update"

    echo "<div class='diagnostic-tools-msg'>The system time is synchronising with configured time servers. Please wait for the synchronisation.<br /><br /><span class='shortcut-menu-item'><a href='time.${GUI_EXT_NAME}'>Synchronisation Check</a>.</span></div>"
}

LOG=/dev/null
gui-run-authentication
ntp-synchronise "${@}"
