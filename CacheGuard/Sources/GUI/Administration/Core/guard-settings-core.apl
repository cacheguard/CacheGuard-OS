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

show-guard-other-settings()
{
    local width

    itemWidth[0]=90
    itemWidth[1]=10

    itemTitle[0]=""
    itemTitle[1]="Deny IP address in URLs"

    itemID[0]="dummy"
    itemID[1]="ip"
   
    blankItemContent[0]="value='on'"
    blankItemContent[1]="type='checkbox'$(checked ${GUARD_IP})"

    itemForm[0]="hidden"

    show-title "URL Guarding Global Settings" "enabled" "guard"
    show-form "${width}"
}

# Main()

show-guard-other-settings
