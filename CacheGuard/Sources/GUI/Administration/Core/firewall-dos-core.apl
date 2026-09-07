#!/bin/bash

###########################################################################
#
# MODULE:       GUI
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

show-waf-limit-form()
{
    local width=550

    itemWidth[0]=80
    itemWidth[1]=20

    local default_tcp_limit=$(get-default-tcp-flood-limit)
    local default_tcp_burst=$(get-default-tcp-flood-burst)

    local default_udp_limit=$(get-default-udp-flood-limit)
    local default_udp_burst=$(get-default-udp-flood-burst)

    local default_web_limit=$(get-default-web-flood-limit)
    local default_web_burst=$(get-default-web-flood-burst)

    local default_rweb_limit=$(get-default-rweb-flood-limit)
    local default_rweb_burst=$(get-default-rweb-flood-burst)

    local default_piptcp=$(get-default-piptcp)
    local default_pipweb=$(get-default-pipweb)
    local default_piprweb=$(get-default-piprweb)
    local default_pipdns=$(get-default-pipdns)
    local default_pipocsp=$(get-default-pipocsp)

    local i=0

    itemTitle[${i}]="Allowed TCP SYN/RST per second [<u><i>default to ${default_tcp_limit}</i></u>]" ; ((i++))
    itemTitle[${i}]="Allowed TCP SYN/RST burst limit> [<u><i>default to ${default_tcp_burst}</i></u>]" ; ((i++))
    itemTitle[${i}]="<hr />" ; ((i++))

    itemTitle[${i}]="Allowed UDP requests per second> [<u><i>default to ${default_udp_limit}</i></u>]" ; ((i++))
    itemTitle[${i}]="Allowed UDP requests burst limit> [<u><i>default to ${default_udp_burst}</i></u>]" ; ((i++))
    itemTitle[${i}]="<hr />" ; ((i++))

    itemTitle[${i}]="Allowed new Web requests per second> [<u><i>default to ${default_web_limit}</i></u>]" ; ((i++))
    itemTitle[${i}]="Allowed new Web requests burst limit> [<u><i>default to ${default_web_burst}</i></u>]" ; ((i++))
    itemTitle[${i}]="<hr />" ; ((i++))

    itemTitle[${i}]="Allowed new rWeb requests per second> [<u><i>default to ${default_rweb_limit}</i></u>]" ; ((i++))
    itemTitle[${i}]="Allowed new rWeb requests burst limit> [<u><i>default to ${default_rweb_burst}</i></u>]" ; ((i++))
    itemTitle[${i}]="<hr />" ; ((i++))

    itemTitle[${i}]="Maximum routed TCP SYN per source IP> [<u><i>default to ${default_piptcp}</i></u>]" ; ((i++))
    itemTitle[${i}]="Maximum new Web requests per source IP> [<u><i>default to ${default_pipweb}</i></u>]" ; ((i++))
    itemTitle[${i}]="Maximum new rWeb requests per source IP> [<u><i>default to ${default_piprweb}</i></u>]" ; ((i++))
    itemTitle[${i}]="Maximum new TCP DNS requests per source IP> [<u><i>default to ${default_pipdns}</i></u>]" ; ((i++))
    itemTitle[${i}]="Maximum new OCSP requests per source IP> [<u><i>default to ${default_pipocsp}</i></u>]" ; ((i++))

    local n=${i}

    i=0
    itemID[${i}]="tcp_limit" ; ((i++))
    itemID[${i}]="tcp_burst" ; ((i++))
    itemID[${i}]="sep_${i}" ; ((i++))

    itemID[${i}]="udp_limit" ; ((i++))
    itemID[${i}]="udp_burst" ; ((i++))
    itemID[${i}]="sep_${i}" ; ((i++))

    itemID[${i}]="web_limit" ; ((i++))
    itemID[${i}]="web_burst" ; ((i++))
    itemID[${i}]="sep_${i}" ; ((i++))

    itemID[${i}]="rweb_limit" ; ((i++))
    itemID[${i}]="rweb_burst" ; ((i++))
    itemID[${i}]="sep_${i}" ; ((i++))

    itemID[${i}]="piptcp" ; ((i++))
    itemID[${i}]="pipweb" ; ((i++))
    itemID[${i}]="piprweb" ; ((i++))
    itemID[${i}]="pipdns" ; ((i++))
    itemID[${i}]="pipocsp" ; ((i++))

    i=0
    blankItemContent[${i}]="type='text' size='10' maxlength='5' value='${FW_DOS_TCP_FLOOD/ *}' data-action='show-min-max-tooltip' data-min='1' data-max='10000'" ; ((i++))
    blankItemContent[${i}]="type='text' size='10' maxlength='5' value='${FW_DOS_TCP_FLOOD/* }' data-action='show-min-max-tooltip' data-min='1' data-max='10000'" ; ((i++))
    blankItemContent[${i}]="<hr />" ; itemForm[${i}]=text ; ((i++))

    blankItemContent[${i}]="type='text' size='10' maxlength='5' value='${FW_DOS_UDP_FLOOD/ *}' data-action='show-min-max-tooltip' data-min='1' data-max='10000'" ; ((i++))
    blankItemContent[${i}]="type='text' size='10' maxlength='5' value='${FW_DOS_UDP_FLOOD/* }' data-action='show-min-max-tooltip' data-min='1' data-max='10000'" ; ((i++))
    blankItemContent[${i}]="<hr />" ; itemForm[${i}]=text ; ((i++))

    blankItemContent[${i}]="type='text' size='10' maxlength='5' value='${FW_DOS_WEB_FLOOD/ *}' data-action='show-min-max-tooltip' data-min='1' data-max='10000'" ; ((i++))
    blankItemContent[${i}]="type='text' size='10' maxlength='5' value='${FW_DOS_WEB_FLOOD/* }' data-action='show-min-max-tooltip' data-min='1' data-max='10000'" ; ((i++))
    blankItemContent[${i}]="<hr />" ; itemForm[${i}]=text ; ((i++))

    blankItemContent[${i}]="type='text' size='10' maxlength='5' value='${FW_DOS_RWEB_FLOOD/ *}' data-action='show-min-max-tooltip' data-min='1' data-max='10000'" ; ((i++))
    blankItemContent[${i}]="type='text' size='10' maxlength='5' value='${FW_DOS_RWEB_FLOOD/* }' data-action='show-min-max-tooltip' data-min='1' data-max='10000'" ; ((i++))
    blankItemContent[${i}]="<hr />" ; itemForm[${i}]=text ; ((i++))

    blankItemContent[${i}]="type='text' size='10' maxlength='10' value='${FW_DOS_TCP_LIMIT}' data-action='show-min-max-tooltip' data-min='0' data-max='1000000000'" ; ((i++))
    blankItemContent[${i}]="type='text' size='10' maxlength='10' value='${FW_DOS_WEB_LIMIT}' data-action='show-min-max-tooltip' data-min='0' data-max='1000000000'" ; ((i++))
    blankItemContent[${i}]="type='text' size='10' maxlength='10' value='${FW_DOS_RWEB_LIMIT}' data-action='show-min-max-tooltip' data-min='0' data-max='1000000000'" ; ((i++))
    blankItemContent[${i}]="type='text' size='10' maxlength='10' value='${FW_DOS_DNS_LIMIT}' data-action='show-min-max-tooltip' data-min='0' data-max='1000000000'" ; ((i++))
    blankItemContent[${i}]="type='text' size='10' maxlength='10' value='${FW_DOS_OCSP_LIMIT}' data-action='show-min-max-tooltip' data-min='0' data-max='1000000000'" ; ((i++))

    for ((i=0 ; i<n ; i++))
    do
	checkItem[${i}]=digit
    done

    show-title "Firewall Dos Limits" "enabled" "firewall"
    show-form "${width}"
}

# Main()

show-waf-limit-form
