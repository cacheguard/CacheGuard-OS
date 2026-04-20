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

show-rweb-host-form()
{
    local get_args=${1}
    local key=$(get-arg-value "${get_args}" key)
    local page_ref=$(get-arg-value "${get_args}" page)

    local name=${key/§*}

    if test -z "${name}" ; then
	redirect-page "rweb-site"
        return 1
    fi

    local width=${DEFAULT_LIST_FORM_WIDTH}
    local disabled

    itemWidth[3]=22

    local hosts=$(get-site-hosts "${RWEB_SITE_HOSTS_LIST}" ${name})
    hosts=${hosts//_/ }

    singleItemID[0]="site_name"
    singleItemValue[0]="${name}"

    itemTitle[0]=""
    itemTitle[1]="Interface"
    itemTitle[2]="Protocol"
    itemTitle[3]="Host<br />IP Address"
    itemTitle[4]="Port"
    itemTitle[5]="Weight"
    itemTitle[6]="QoS"

    itemID[0]="Host"
    itemID[1]="interface"
    itemID[2]="protocol"
    itemID[3]="ip"
    itemID[4]="port"
    itemID[5]="weight"
    itemID[6]="qos"

    blankItemContent[0]=""
    blankItemContent[1]="rweb vpnipsec external"
    blankItemContent[2]="http https"
    blankItemContent[3]="type='text' size='15' maxlength='15'"
    blankItemContent[4]="type='text' size='5' maxlength='5'"
    blankItemContent[5]="type='text' size='3' maxlength='3'"
    blankItemContent[6]="type='text' size='3' maxlength='3'"

    checkItem[0]=''
    checkItem[1]=''
    checkItem[2]=''
    checkItem[3]=ip
    checkItem[4]=port
    checkItem[5]=weight
    checkItem[6]=percent

    itemForm[1]="select"
    itemForm[2]="select"

    listContent=${hosts}
    test -n "${listContent}" || disabled=disabled

    local color='SeaGreen'
    show-title "Backend Web Servers" "${disabled}" "rweb qos vlan vpnipsec"
    show-list-form ${MAX_RWEB_HOST_NB} "${width}" "${page_ref}" "<br /><div style='color:${color};'>${name}</div>"
}

# Main()

show-rweb-host-form "${@}"
