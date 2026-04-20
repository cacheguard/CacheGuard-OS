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

show-counter-form()
{
    local width

    itemWidth[0]=90
    itemWidth[1]=10

    itemTitle[0]=""
    itemTitle[1]="Reset Forward Web Counter"
    itemTitle[2]="Reset Reverse Web Counter"
    itemTitle[3]="Reset Firewall Counter"
    itemTitle[4]="Reset URL Guarding Counter"
    itemTitle[5]="Reset Web Antivirus Counter"
    itemTitle[6]="Reset Antivirus Server Counter"
    itemTitle[7]="Reset WAF counter"

    itemID[0]="dummy"
    itemID[1]="web"
    itemID[2]="rweb"
    itemID[3]="firewall"
    itemID[4]="guard"
    itemID[5]="antivirus"
    itemID[6]="avserver"
    itemID[7]="waf"

    blankItemContent[0]="value='on'"
    blankItemContent[1]="type='checkbox'"
    blankItemContent[2]="type='checkbox'"
    blankItemContent[3]="type='checkbox'"
    blankItemContent[4]="type='checkbox'"
    blankItemContent[5]="type='checkbox'"
    blankItemContent[6]="type='checkbox'"
    blankItemContent[7]="type='checkbox'"

    itemForm[0]="hidden"

    shortcutMenuItem[0]="system-report-counter"
    shortcutMenuTitle[0]="View Counters"

    show-title "Reset Counters" "enabled" "system"
    show-shortcuts-menu
    show-form "${width}"
}

# Main()

show-counter-form
