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

show-qos-form()
{
    local width

    itemWidth[0]=75
    itemWidth[1]=25

    itemTitle[0]="Incoming from Internal (Kbps)"
    itemTitle[1]="Outgoing from Internal (Kbps)"
    itemTitle[2]="Incoming from External (Kbps)"
    itemTitle[3]="Outgoing from External (Kbps)"
    itemTitle[4]="Incoming from Auxiliary (Kbps)"
    itemTitle[5]="Outgoing from Auxiliary (Kbps)"
    
    itemID[0]="internal_ingress"
    itemID[1]="internal_egress"
    itemID[2]="external_ingress"
    itemID[3]="external_egress"
    itemID[4]="auxiliary_ingress"
    itemID[5]="auxiliary_egress"

    blankItemContent[0]="type='text' size='8' maxlength='10' value='${QOS_BW_INTERNAL_INGRESS}'"
    blankItemContent[1]="type='text' size='8' maxlength='10' value='${QOS_BW_INTERNAL_EGRESS}'"
    blankItemContent[2]="type='text' size='8' maxlength='10' value='${QOS_BW_EXTERNAL_INGRESS}'"
    blankItemContent[3]="type='text' size='8' maxlength='10' value='${QOS_BW_EXTERNAL_EGRESS}'"
    blankItemContent[4]="type='text' size='8' maxlength='10' value='${QOS_BW_AUXILIARY_INGRESS}'"
    blankItemContent[5]="type='text' size='8' maxlength='10' value='${QOS_BW_AUXILIARY_EGRESS}'"
    
    checkItem[0]=digit
    checkItem[1]=digit
    checkItem[2]=digit
    checkItem[3]=digit
    checkItem[4]=digit
    checkItem[5]=digit
    
    show-title "Bandwidth Limits" "enabled" "qos"
    show-form "${width}"
}

# Main()

show-qos-form
