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

show-embedded-bevypn-form()
{
    local state width
    local ea_state tls_id ca_id

    if test ${EMBEDDED_VPNSUBSCR_MODE} == True ; then
	ea_state=on
    else
	ea_state=off
    fi

    tls_id=${EMBEDDED_VPNSUBSCR_RWEB_TLS_ID/:*}
    mono-elt ${EMBEDDED_VPNSUBSCR_RWEB_TLS_ID//:/ } || ca_id=${EMBEDDED_VPNSUBSCR_RWEB_TLS_ID/*:}

    itemWidth[0]=35
    itemWidth[1]=65

    itemTitle[0]="Activation State"
    itemTitle[1]="Public Website Name"
    itemTitle[2]="TLS Identifier"
    itemTitle[3]="TLS Intermediate CA"

    itemID[0]="state"
    itemID[1]="site_name"
    itemID[2]="tls_id"
    itemID[3]="ca_id"

    itemForm[0]="select"
    itemForm[2]="select"
    itemForm[3]="select"

    blankItemContent[0]=$(show-on-off-state ${ea_state})
    blankItemContent[1]="type='text' size='24' maxlength='${MAX_LEN}' value='${EMBEDDED_VPNSUBSCR_RWEB_SITE_NAME}'"
    blankItemContent[2]=$(show-tls-server-list ${tls_id}) ; ((i++))
    blankItemContent[3]=$(show-tls-ca-list ${ca_id}) ; ((i++))

    checkItem[1]=domainname

    shortcutMenuItem[0]="tls-server"
    shortcutMenuTitle[0]="Manage Server TLS"

    if gui-contextual-is-allowed ; then
	if is-embedded-activable vpnsubscr ; then

	    local key
	    test ! -f ${TMP_DIR}/${EMBEDDED_VPNSUBSCR_REGISTER_KEY} || key=$(cat ${TMP_DIR}/${EMBEDDED_VPNSUBSCR_REGISTER_KEY})

	    itemTitle[4]="Embedded License Key"
	    itemTitle[5]="Purchase Link"

	    itemID[4]="key"
	    itemID[5]="purchase"

	    blankItemContent[4]="type='text' size='44' maxlength='64' value='${key}' autocomplete='off'"

	    checkItem[4]=printable
	    itemForm[5]="text"

	    if is-registered-appliance ; then
		local url=$(get-purchase-embedded-url vpnsubscr)
		blankItemContent[5]="<a href='${url}' target='_blank'>Purchase ${EMBEDDED_VPNSUBSCR_COMMERCIAL_NAME}</a>"
	    else
		local register_page='register'
		blankItemContent[5]="<i><a href='/${GUI_DIR_NAME}/${register_page}.${GUI_EXT_NAME}'>Appliance Registration</a> is required before purchase.</i>"
	    fi

	    shortcutMenuItem[1]="register"
	    shortcutMenuTitle[1]="Appliance Registration"
	fi
    fi

    show-title "${EMBEDDED_VPNSUBSCR_COMMERCIAL_NAME} Embedded Application" "${state}" "embedded register tls"
    show-shortcuts-menu
    show-form "${width}"
}

# Main()

show-embedded-bevypn-form
