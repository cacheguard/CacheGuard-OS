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

print-countries()
{
    local code name style

    while read code name
    do
	test -n "${code}" || continue
	if test "${AV_COUNTRY_CODE}" == "${code}" ; then
	    echo -n "<option value='${code}' selected>${name} [${code}]</option>"
	else
	    echo -n "<option value='${code}'>${name} [${code}]</option>"
	fi
    done < ${APPLIANCE_DIR}/etc/countries
}

show-av-extended-methods()
{
    local in_method=${1}
    local methods=${2}

    local method

    for method in ${methods}
    do
	if test "${in_method}" == ${method} ; then
	    echo -n "<option value='${method}' selected>${method}</option>"
	else
	    echo -n "<option value='${method}'>${method}</option>"
	fi
    done
}

show-av-form()
{
    local width=600

    local av_protocol_server_path=$(get-protocol-server-path-from-url "${AV_EXTENDED_URL}")
    local av_protocol=$(get-record-field "${av_protocol_server_path}" 1)
    local av_server=$(get-record-field "${av_protocol_server_path}" 2)
    local len=$[${#av_protocol} + 3]
    local av_location=${AV_EXTENDED_URL:${len}}

    local methods="load vload" protocols="sftp ftp tftp"
    local push_method full_configuration

    case ${APL_ROLE} in
	gateway)
	    test -z "${ACCESS_MANAGER_LIST}" || push_method=yes
	    full_configuration=yes
	    ;;
	manager)
	    if gui-is-in-contextual-role ; then
		test -z "${ACCESS_MANAGER_LIST}" || push_method=yes
		full_configuration=yes
	    fi
	    ;;
	*)
	    ;;
    esac

    test -z "${push_method}" || methods="${methods} push"

    itemWidth[0]=40
    itemWidth[1]=60

    itemTitle[0]="Update Country<img align='middle' src='${IMAGE_DIR}/country-flag-${AV_COUNTRY_CODE}.png' style='margin-bottom:5px; margin-left:5px; width:20px; height:14px;' />"
    itemTitle[1]="Extended Antivirus update Method"
    itemTitle[2]="Extended Antivirus update Protocol"
    itemTitle[3]="Extended Antivirus update Location"

    itemID[0]="update"
    itemID[1]="extended_method"
    itemID[2]="extended_protocol"
    itemID[3]="extended_location"

    itemForm[0]="select"
    itemForm[1]="select"
    itemForm[2]="select"

    checkItem[3]=printable

    blankItemContent[0]="$(print-countries)"
    blankItemContent[1]=$(show-av-extended-methods "${AV_EXTENDED_METHOD}" "${methods}")
    blankItemContent[2]=$(show-file-protocol1 "${av_protocol}" "${protocols}")
    blankItemContent[3]="type='text' size='40' maxlength='$[${MAX_LEN} * 3]' value='${av_location}'"

    if test -n "${full_configuration}" ; then

	itemTitle[4]="File size limit (KB)"
	itemTitle[5]="Possibly Unwanted Applications (PUA)"

	itemID[4]="maxobject_file"
	itemID[5]="pua"

	blankItemContent[4]="type='text' size='6' maxlength='6' value='${AV_MAX_OBJECT_SZ}' onMouseOver=showMinMaxToolTip(${AV_MAX_FILE_MIN},${AV_MAX_FILE_MAX}); onMouseOut=hideMinMaxToolTip();"
	blankItemContent[5]="type='checkbox'$(checked ${AV_PUA})"

	checkItem[4]=digit
    fi

    shortcutMenuItem[0]="access-file"
    shortcutMenuTitle[0]="File Servers"

    call-js-function "hideMinMaxToolTip( )"
    show-title "Antivirus Settings" "enabled" "antivirus"
    show-shortcuts-menu
    show-form "${width}"
}

# Main()

show-av-form
