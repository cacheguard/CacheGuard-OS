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

show-password-login-form()
{
    local width=400 i=0
    local gui_only

    itemWidth[0]=45
    itemWidth[1]=55

    itemTitle[${i}]="Login" ; ((i++))
    itemTitle[${i}]="Current Web Password" ; ((i++))
    itemTitle[${i}]="New Password" ; ((i++))
    itemTitle[${i}]="Retype New Password" ; ((i++))
    itemTitle[${i}]="Web GUI Only" ; ((i++))

    i=0
    itemID[${i}]="login" ; ((i++))
    itemID[${i}]="password"
    checkItem[${i}]=printable
    ((i++))

    itemID[${i}]="password1" ; checkItem[${i}]=printable ; ((i++))
    itemID[${i}]="password2" ; checkItem[${i}]=printable ; ((i++))
    itemID[${i}]="gui" ; ((i++))

    i=0
    blankItemContent[${i}]="${USER}" ; ((i++))
    blankItemContent[${i}]="type='password' size='24' maxlength='32'" ; ((i++))
    blankItemContent[${i}]="type='password' size='24' maxlength='32'" ; ((i++))
    blankItemContent[${i}]="type='password' size='24' maxlength='32'" ; ((i++))

    test -z "${VALUES[${i}]}" || gui_only=" checked"

    blankItemContent[${i}]="type='checkbox'${gui_only}" ; ((i++))

    itemForm[0]=text

    shortcutMenuItem[0]="admin"
    shortcutMenuTitle[0]="2FA Settings"

    show-title "Admin Password" "enabled" "password"
    show-shortcuts-menu
    show-form "${width}" enabled show-post-errors
}

# Main()

show-password-login-form
