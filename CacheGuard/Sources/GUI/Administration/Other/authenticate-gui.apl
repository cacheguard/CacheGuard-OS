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

show-authenticate-gui()
{
    echo "<div class='center-middle-wrapper unavailable-element'>"
    echo "<div class='center-middle-content unavailable-element'>"
    echo "<center>"
    echo "<img src='${IMAGE_DIR}/error.png' alt='Authenticate Failed' title='Authenticate Failed' />"
    echo "</center>"
    echo "</div>"
    echo "</div>"
}

# Main()

show-authenticate-gui
