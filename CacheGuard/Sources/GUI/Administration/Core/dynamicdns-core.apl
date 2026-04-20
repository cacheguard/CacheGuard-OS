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

select-dyndns()
{
    local state_id=${1}
    local provider_id=${2}
    local hostname_id=${3}
    local username_id=${4}
    local password_id=${5}
    local provider_website_id=${6}

    call-js-function "dynamicDNSSelectCB( '${state_id}', '${provider_id}', '${hostname_id}', '${username_id}', '${password_id}', '${provider_website_id}' )"
}

show-dyndns-options()
{
    local in_value=${1}
    local values=${2}

    local selected value

    test -n "${in_value}" || in_value=${DEFAULT_DYNAMIC_DNS_PROVIDER}

    for value in ${values}
    do
	selected=$(get-selected-option ${value} "${in_value}")
	echo "<option value='${value}'${selected}>${value}</option>"
    done
}

show-dyndns-intervals()
{
    local in_interval=${1}
    local interval selected

    for ((interval=MIN_DYNAMIC_DNS_INTERVAL ; interval<=MAX_DYNAMIC_DNS_INTERVAL ; interval++))
    do
	selected=$(get-selected-option ${interval} ${in_interval})
	echo "<option value='${interval}'${selected}>${interval}</option>"
    done
}

show-dyndns-form()
{
    local width i=0
    local state_id='state'
    local provider_id='provider'
    local provider_website_id='provider-website'
    local hostname_id='hostname'
    local username_id='username'
    local password_id='password'

    itemWidth[0]=35
    itemWidth[1]=65

    itemTitle[${i}]="State" ; ((i++))
    itemTitle[${i}]="Provider ID" ; ((i++))
    itemTitle[${i}]="Provider Website" ; ((i++))
    itemTitle[${i}]="Public Hostname" ; ((i++))
    itemTitle[${i}]="Username" ; ((i++))
    itemTitle[${i}]="Password (or Token)" ; ((i++))
    itemTitle[${i}]="Update Interval (mn)" ; ((i++))

    i=0
    itemID[${i}]=${state_id} ; ((i++))
    itemID[${i}]=${provider_id} ; ((i++))
    itemID[${i}]='dummy' ; ((i++))
    itemID[${i}]=${hostname_id} ; ((i++))
    itemID[${i}]=${username_id} ; ((i++))
    itemID[${i}]=${password_id} ; ((i++))
    itemID[${i}]='interval' ; ((i++))
    
    i=0
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="text" ; ((i++))
    itemForm[${i}]="input" ; ((i++))
    itemForm[${i}]="input" ; ((i++))
    itemForm[${i}]="input" ; ((i++))
    itemForm[${i}]="select" ; ((i++))

    i=0
    blankItemContent[${i}]=$(show-dyndns-options $(external-form ${DYNAMIC_DNS_STATE}) "on off") ; ((i++))
    blankItemContent[${i}]=$(show-dyndns-options "${DYNAMIC_DNS_PROVIDER}" "${DYNAMIC_DNS_PROVIDERS}") ; ((i++))
    blankItemContent[${i}]="<span id='${provider_website_id}'></span>" ; ((i++))
    blankItemContent[${i}]="type='text' size='32' maxlength='${MAX_LEN}' value='${DYNAMIC_DNS_HOSTNAME}'" ; ((i++))
    blankItemContent[${i}]="type='text' size='32' maxlength='${MAX_LEN}' value='${DYNAMIC_DNS_USERNAME}'" ; ((i++))
    blankItemContent[${i}]="type='password' size='32' maxlength='${MAX_LEN}' value='${DYNAMIC_DNS_PASSWORD}'" ; ((i++))
    blankItemContent[${i}]=$(show-dyndns-intervals ${DYNAMIC_DNS_INTERVAL}) ; ((i++))

    local cb="dynamicDNSSelectCB( '${state_id}', '${provider_id}', '${hostname_id}', '${username_id}', '${password_id}', '${provider_website_id}' );"
    itemFormSelectCB[0]=${cb}
    itemFormSelectCB[1]=${cb}

    checkItem[3]=domainname
    checkItem[4]=username

    shortcutMenuItem[0]="tls-server"
    shortcutMenuTitle[0]="Manage TLS"

    local after_function="select-dyndns ${state_id} ${provider_id} ${hostname_id} ${username_id} ${password_id} ${provider_website_id}"

    show-title "Dynamic DNS" "enabled" "dynamicdns rweb tls vpnipsec"
    show-shortcuts-menu
    show-form "${width}" enabled "${after_function}"
}

# Main()

show-dyndns-form
