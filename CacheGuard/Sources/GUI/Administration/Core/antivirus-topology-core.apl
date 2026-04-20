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

show-av-topology-form()
{
    local width

    itemWidth[0]=90
    itemWidth[1]=10

    itemTitle[0]=""
    itemTitle[1]="Internal access"
    itemTitle[2]="External access"
    itemTitle[3]="Auxiliary access"
    itemTitle[4]="IPsec VPN access"

    itemID[0]="dummy"
    itemID[1]="internal"
    itemID[2]="external"
    itemID[3]="auxiliary"
    itemID[4]="vpnipsec"
    
    blankItemContent[0]="value='on'"
    blankItemContent[1]="type=checkbox$(checked ${AV_INTERNAL})"
    blankItemContent[2]="type=checkbox$(checked ${AV_EXTERNAL})"
    blankItemContent[3]="type=checkbox$(checked ${AV_AUXILIARY})"
    blankItemContent[4]="type=checkbox$(checked ${AV_VPN_IPSEC})"

    itemForm[0]="hidden"

    show-title "Antivirus Topology" "enabled" "admin"
    show-form "${width}"

}

# Main()

show-av-topology-form
