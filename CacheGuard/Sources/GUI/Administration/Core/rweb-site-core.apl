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

show-rweb-site-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH}
    local state

    local ip1=$(ipcalc -s ${IP_EXTERNAL_IP} ${IP_EXTERNAL_MASK} -n) ; ip1=${ip1/NETWORK=}
    local ip2=$(ipcalc -s ${IP_EXTERNAL_IP} ${IP_EXTERNAL_MASK} -b) ; ip2=${ip2/BROADCAST=}
    local ip_tip="${ip1} < IP < ${ip2}"
    local ip_tip_width=260

    itemWidth[1]=40
    itemWidth[2]=10
    itemWidth[3]=25

    itemTitle[0]=""
    itemTitle[1]="Website Name"
    itemTitle[2]="Protocol"
    itemTitle[3]="Exposed IP"
    
    itemID[0]="Site"
    itemID[1]="site_name"
    itemID[2]="protocol"
    itemID[3]="ip"
    
    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='24' maxlength='${MAX_LEN}'"
    blankItemContent[2]="http https"
    blankItemContent[3]="type='text' size='15' maxlength='15' onMouseOver='ddrivetip( \\\"${ip_tip}\\\", ${ip_tip_width} );' onMouseOut='hideddrivetip( );'"
    
    checkItem[1]=domainname
    checkItem[3]=ip

    itemForm[2]="select"

    editColumnPage[0]="rweb-settings"
    editColumnTitle[0]="All<br />Settings"
    editColumnQuery[0]="level:1"

    listContent=${RWEB_SITE_LIST}
    listContentStep=5
    listContentKeyLength=3
    listContentVisibility[3]=off
    listContentVisibility[4]=off

    test -n "${listContent}" || state=disabled
    local rweb_nb=$(gui-get-contextual-rweb-nb)

    call-js-function "hideddrivetip( )"
    show-title "Cloaked Reverse Websites" "${state}" "dynamicdns rweb tls"
    show-list-form ${rweb_nb} "${width}" "${page_ref}"
}

# Main()

show-rweb-site-form "${@}"
