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

show-admin-form()
{
    local width=300

    itemWidth[0]=95
    itemWidth[1]=5

    itemTitle[0]=""
    itemTitle[1]="Borrowing on Incoming from Internal"
    itemTitle[2]="Borrowing on Outgoing from Internal"
    itemTitle[3]="Borrowing on Incoming from External"
    itemTitle[4]="Borrowing on Outgoing from External"
    itemTitle[5]="Borrowing on Incoming from Auxiliary"
    itemTitle[6]="Borrowing on Outgoing from Auxiliary"

    itemID[0]="dummy"
    itemID[1]="internal_ingress"
    itemID[2]="internal_egress"
    itemID[3]="external_ingress"
    itemID[4]="external_egress"
    itemID[5]="auxiliary_ingress"
    itemID[6]="auxiliary_egress"
    
    blankItemContent[0]="value='on'"
    blankItemContent[1]="type=checkbox$(checked ${QOS_BORROW_INTERNAL_INGRESS})"
    blankItemContent[2]="type=checkbox$(checked ${QOS_BORROW_INTERNAL_EGRESS})"
    blankItemContent[3]="type=checkbox$(checked ${QOS_BORROW_EXTERNAL_INGRESS})"
    blankItemContent[4]="type=checkbox$(checked ${QOS_BORROW_EXTERNAL_EGRESS})"
    blankItemContent[5]="type=checkbox$(checked ${QOS_BORROW_AUXILIARY_INGRESS})"
    blankItemContent[6]="type=checkbox$(checked ${QOS_BORROW_AUXILIARY_EGRESS})"

    itemForm[0]="hidden"

    show-title "Borrowing Shaped Traffic" "enabled" "qos"
    show-form "${width}"
}

# Main()

show-admin-form
