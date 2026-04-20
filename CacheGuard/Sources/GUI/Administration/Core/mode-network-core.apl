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

show-network-form()
{
    local width=400 i=0

    itemWidth[0]=90
    itemWidth[1]=10

    itemTitle[${i}]="" ; ((i++))

    if gui-contextual-is-allowed ; then

	itemTitle[${i}]="DHCP Server" ; ((i++))
	itemTitle[${i}]="Domain Name Server" ; ((i++))
	itemTitle[${i}]="High Availability" ; ((i++))
    fi

    itemTitle[${i}]="Passive FTP" ; ((i++))

    if gui-contextual-is-allowed ; then

	itemTitle[${i}]="Quality of Service" ; ((i++))
	itemTitle[${i}]="Router (IP Forwarding)" ; ((i++))
	itemTitle[${i}]="Source NAT" ; ((i++))
	itemTitle[${i}]="Transparent Web" ; ((i++))
	itemTitle[${i}]="Transparent Web Source IP NAT" ; ((i++))
	itemTitle[${i}]="802.1q VLAN on Internal Interface" ; ((i++))
    fi

    i=0
    itemID[${i}]="dummy" ; ((i++))

    if gui-contextual-is-allowed ; then
	itemID[${i}]="mode_dhcp" ; ((i++))
	itemID[${i}]="mode_dns" ; ((i++))
	itemID[${i}]="mode_ha" ; ((i++))
    fi

    itemID[${i}]="mode_ftppassive" ; ((i++))

    if gui-contextual-is-allowed ; then

	itemID[${i}]="mode_qos" ; ((i++))
	itemID[${i}]="mode_router" ; ((i++))
	itemID[${i}]="mode_snat" ; ((i++))
	itemID[${i}]="mode_tweb" ; ((i++))
	itemID[${i}]="mode_tnat" ; ((i++))
	itemID[${i}]="mode_vlan" ; ((i++))
    fi

    i=0
    blankItemContent[${i}]="value='on'" ; ((i++))

    if gui-contextual-is-allowed ; then

	blankItemContent[${i}]="type='checkbox'$(checked ${DHCP_MODE})" ; ((i++))
	blankItemContent[${i}]="type='checkbox'$(checked ${DNS_MODE})" ; ((i++))
	blankItemContent[${i}]="type='checkbox'$(checked ${HA_MODE})" ; ((i++))
    fi

    blankItemContent[${i}]="type='checkbox'$(checked ${FTP_PASSIVE_MODE})" ; ((i++))

    if gui-contextual-is-allowed ; then

	blankItemContent[${i}]="type='checkbox'$(checked ${QOS_MODE})" ; ((i++))
	blankItemContent[${i}]="type='checkbox'$(checked ${ROUTER_MODE})" ; ((i++))
	blankItemContent[${i}]="type='checkbox'$(checked ${SNAT_MODE})" ; ((i++))
	blankItemContent[${i}]="type='checkbox'$(checked ${TRANSPARENT_MODE})" ; ((i++))
	blankItemContent[${i}]="type='checkbox'$(checked ${TNAT_MODE})" ; ((i++))
	blankItemContent[${i}]="type='checkbox'$(checked ${VLAN_MODE})" ; ((i++))
    fi

    itemForm[0]="hidden"

    if gui-contextual-is-allowed ; then
	shortcutMenuItem[0]="mode-feature"
	shortcutMenuTitle[0]="General Modes & Features"
    fi

    show-title "Network Modes & Services" "enabled" "mode"
    ! gui-contextual-is-allowed || show-shortcuts-menu
    show-form "${width}"
}

# Main()

show-network-form
