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

show-help-form()
{
    local width=500

    itemWidth[0]=50
    itemWidth[1]=50

    itemTitle[0]="Get Collaborative Help"
    itemTitle[1]="Request an Anomaly Handling"
    itemTitle[2]="Request an Anomaly Handling"
    itemTitle[3]="Subscribe to a Support Contract"

    itemID[0]="forum"
    itemID[1]="support"
    itemID[2]="purchase"
    itemID[3]="subscribe"

    itemForm[0]="text"
    itemForm[1]="text"
    itemForm[2]="text"
    itemForm[3]="text"

    local forum_url="https://help.cacheguard.net/"
    local support_url="https://support.cacheguard.net/"
    local purchase_url=$(get-purchase-embedded-url anomaly)

    local register_page="register"
    local register_title="Appliance Registration & Subscription"

    blankItemContent[0]="<a href='${forum_url}' target='_blank'>Post Your Questions</a>"
    blankItemContent[1]="<a href='${support_url}' target='_blank'>With a Support Contact</a>"
    blankItemContent[2]="<a href='${purchase_url}' target='_blank'>Without Support Contact</a>"
    blankItemContent[3]="<a href='/${GUI_DIR_NAME}/${register_page}.${GUI_EXT_NAME}'>${register_title}</a>"

    shortcutMenuItem[0]=${register_page}
    shortcutMenuTitle[0]=${register_title}

    show-title "Get Support & Help"
    show-shortcuts-menu
    show-form ${width} disable
}

# Main()

show-help-form
