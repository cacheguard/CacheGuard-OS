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

show-password-snmp-form()
{
    local width

    itemWidth[0]=65
    itemWidth[1]=35

    itemTitle[0]="User name"
    itemTitle[1]="Community (Password)"
    itemTitle[2]="Retype community (Password)"
    itemTitle[3]="Privacy encryption password"
    itemTitle[4]="Retyp Privacy"
    
    itemID[0]="user"
    itemID[1]="password1"
    itemID[2]="password2"
    itemID[3]="privacy1"
    itemID[4]="privacy2"
    
    blankItemContent[0]="${SNMP_USER}"
    blankItemContent[1]="type=password size=12 maxlength=32"
    blankItemContent[2]="type=password size=12 maxlength=32"
    blankItemContent[3]="type=password size=12 maxlength=32"
    blankItemContent[4]="type=password size=12 maxlength=32"

    checkItem[1]=printable
    checkItem[2]=printable
    checkItem[3]=printable
    checkItem[4]=printable
    
    itemForm[0]="text"

    shortcutMenuItem[0]="admin-snmp"
    shortcutMenuTitle[0]="SNMP Settings"

    show-title "SNMP Agent Password" "enabled" "admin password"
    show-shortcuts-menu
    show-form "${width}"
}

# Main()

show-password-snmp-form
