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

show-name-form()
{
    local width

    itemWidth[0]=30
    itemWidth[1]=70

    itemTitle[0]="Host Name"
    itemTitle[1]="Domain Name"
    
    itemID[0]="hostname"
    itemID[1]="domainname"
    
    blankItemContent[0]="type='text' size='16' maxlength='${MAX_LEN}' value='${SHOSTNAME}'"
    blankItemContent[1]="type='text' size='32' maxlength='${MAX_LEN}' value='${DOMAIN_NAME}'"
    
    checkItem[0]=hostname
    checkItem[1]=domainname

    show-title "Hostname & Domainname" "enabled" "hostname domainname"
    show-form "${width}"
}

# Main()

show-name-form
