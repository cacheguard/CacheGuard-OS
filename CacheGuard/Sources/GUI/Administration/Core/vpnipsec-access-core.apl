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

source vpnipsec-common.${GUI_EXT_NAME}

show-vpnipsec-access()
{
    local width=450 i=0
    local value value_tab
    declare -a value_tab

    itemWidth[0]=60
    itemWidth[1]=40

    itemTitle[${i}]="Remote Access State" ; ((i++))
    itemTitle[${i}]="IKE Encryption Algorithm" ; ((i++))
    itemTitle[${i}]="IKE Integrity Algorithm" ; ((i++))
    itemTitle[${i}]="Diffie Hellman Key Strength" ; ((i++))
    itemTitle[${i}]="ESP Encryption Algorithm" ; ((i++))
    itemTitle[${i}]="ESP Integrity Algorithm" ; ((i++))
    itemTitle[${i}]="Client Authentication Method" ; ((i++))
    itemTitle[${i}]="Private Networks" ; ((i++))
    itemTitle[${i}]="Via Gateways" ; ((i++))

    i=0
    itemID[${i}]="state" ; ((i++))
    itemID[${i}]="ike_encryption" ; ((i++))
    itemID[${i}]="ike_integrity" ; ((i++))
    itemID[${i}]="dh" ; ((i++))
    itemID[${i}]="esp_encryption" ; ((i++))
    itemID[${i}]="esp_integrity" ; ((i++))
    itemID[${i}]="authenticate" ; ((i++))
    itemID[${i}]="private_networks" ; ((i++))
    itemID[${i}]="via_gateways" ; ((i++))

    i=0
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="text" ; ((i++))
    itemForm[${i}]="text" ; ((i++))

    i=0
    for value in ${VPN_IPSEC_ACCESS}
    do
	value_tab[${i}]=${value}
	((i++))
    done

    i=0
    blankItemContent[${i}]=$(show-vpnipsec-states ${value_tab[${i}]}) ; ((i++))
    blankItemContent[${i}]=$(show-vpnipsec-encryptions ${value_tab[${i}]}) ; ((i++))
    blankItemContent[${i}]=$(show-vpnipsec-integrities ${value_tab[${i}]}) ; ((i++))
    blankItemContent[${i}]=$(show-vpnipsec-dh ${value_tab[${i}]}) ; ((i++))
    blankItemContent[${i}]=$(show-vpnipsec-encryptions ${value_tab[${i}]}) ; ((i++))
    blankItemContent[${i}]=$(show-vpnipsec-integrities ${value_tab[${i}]}) ; ((i++))
    blankItemContent[${i}]=$(show-vpnipsec-authenticates ${VPN_IPSEC_ACCESS_AUTHENTICATE}) ; ((i++))
    blankItemContent[${i}]="<a href='/${GUI_DIR_NAME}/vpnipsec-access-network.${GUI_EXT_NAME}'>Manage Private Networks</a>" ; ((i++))
    blankItemContent[${i}]="<a href='/${GUI_DIR_NAME}/vpnipsec-access-via.${GUI_EXT_NAME}'>Manage Via Gateways</a>" ; ((i++))

    shortcutMenuItem[0]="port"
    shortcutMenuTitle[0]="Listening Ports"

    shortcutMenuItem[1]="tls-server"
    shortcutMenuTitle[1]="Manage TLS"

    show-title "Remote Access IPsec VPN Settings" enabled "dynamicdns tls vpnipsec"
    show-shortcuts-menu
    show-form "${width}"
}

# Main()

show-vpnipsec-access
