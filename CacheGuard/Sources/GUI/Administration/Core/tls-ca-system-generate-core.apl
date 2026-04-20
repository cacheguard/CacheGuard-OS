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

show-ca-generate-form()
{
    local width

    itemWidth[0]=30
    itemWidth[1]=70

    local numbits days name country province locality organisation unit
    local i=0 n=0

    if test ${APL_ROLE} == gateway ; then
	local web_ip=$(get-web-ip cur)

	itemTitle[${i}]="CA Link"
	blankItemContent[${i}]="<a href='http://${web_ip}' target='_blank'>${web_ip}</a> (available from the internal interface)"
	itemID[${i}]="ca_links"
	itemForm[${i}]="text"
	((i++))
	n=${i}
    fi

    itemTitle[${i}]="Common Name"
    checkItem[${i}]=printable ; ((i++))

    itemTitle[${i}]="RSA Key Size (bits)"
    checkItem[${i}]=digit ; ((i++))

    itemTitle[${i}]="Validity Days"
    checkItem[${i}]=digit ; ((i++))

    itemTitle[${i}]="Country Code"
    itemForm[${i}]="select" ; ((i++))

    itemTitle[${i}]="Province Name"
    checkItem[${i}]=printable ; ((i++))

    itemTitle[${i}]="Locality Name"
    checkItem[${i}]=printable ; ((i++))

    itemTitle[${i}]="Organisation Name"
    checkItem[${i}]=printable ; ((i++))

    itemTitle[${i}]="Unit Name"
    checkItem[${i}]=printable ; ((i++))

    i=${n}
    itemID[${i}]="name" ; ((i++))
    itemID[${i}]="numbits" ; ((i++))
    itemID[${i}]="days" ; ((i++))
    itemID[${i}]="country" ; ((i++))
    itemID[${i}]="province" ; ((i++))
    itemID[${i}]="locality" ; ((i++))
    itemID[${i}]="organisation" ; ((i++))
    itemID[${i}]="unit" ; ((i++))

    i=0
    name="${VALUES[${i}]}" ; ((i++))
    numbits="${VALUES[${i}]}" ; ((i++))
    days="${VALUES[${i}]}" ; ((i++))
    country="${VALUES[${i}]}" ; ((i++))
    province="${VALUES[${i}]}" ; ((i++))
    locality="${VALUES[${i}]}" ; ((i++))
    organisation="${VALUES[${i}]}" ; ((i++))
    unit="${VALUES[${i}]}"

    test -n "${numbits}" || numbits=2048

    i=${n}
    blankItemContent[${i}]="type='text' size='24' maxlength='32' value='${name}'" ; ((i++))
    blankItemContent[${i}]="type='text' size='5' maxlength='4' value='${numbits}'" ; ((i++))
    blankItemContent[${i}]="type='text' size='8' maxlength='8' value='${days}'" ; ((i++))
    blankItemContent[${i}]=$(show-tls-country ${country}) ; ((i++))
    blankItemContent[${i}]="type='text' size='24' maxlength='32' value='${province}'" ; ((i++))
    blankItemContent[${i}]="type='text' size='24' maxlength='32' value='${locality}'" ; ((i++))
    blankItemContent[${i}]="type='text' size='24' maxlength='32' value='${organisation}'" ; ((i++))
    blankItemContent[${i}]="type='text' size='24' maxlength='32' value='${unit}'" ; ((i++))

    show-title "System CA Generation" "enabled" "tls"

    show-form "${width}" enabled

    echo '<script type="text/javascript">'
    echo "doNothingOnEnterInInput( 'names' );"
    echo "AJAX_updateTLSConf( '/${GUI_DIR_NAME}/tls-print.${GUI_EXT_NAME}?ca:system+conf', 'name', 'numbits', 'days', 'country', 'province', 'locality', 'organisation', 'unit' );"
    echo '</script>'
}

# Main()

show-ca-generate-form "${@}"
