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

show-port-form()
{
    local width i=0 n nb

    itemWidth[0]=80
    itemWidth[1]=20

    itemTitle[${i}]="Web Admin Port"
    itemID[${i}]="port_wadmin"
    blankItemContent[${i}]="type='text' size='5' maxlength='5' value='${WADMIN_PORT}'"
    checkItem[0]=port
    ((i++))
    n=${i}

    if gui-contextual-is-allowed ; then

	itemTitle[${i}]="Forwarding Proxy Port" ; ((i++))
	itemTitle[${i}]="Transparent HTTP Proxy Port" ; ((i++))
	itemTitle[${i}]="Transparent HTTPS Proxy Port" ; ((i++))
	itemTitle[${i}]="Antivirus Port" ; ((i++))
	itemTitle[${i}]="OCSP Port" ; ((i++))
	itemTitle[${i}]="ISAMP (IKE) Port" ; ((i++))
	itemTitle[${i}]="NAT Transversal (NATT) Port" ; ((i++))
	itemTitle[${i}]="HTTP Peer Port" ; ((i++))
	itemTitle[${i}]="HTCP Peer Port" ; ((i++))
	itemTitle[${i}]="DHCP Peer Port" ; ((i++))
	itemTitle[${i}]="Web Audit Port" ; ((i++))

	i=${n}
	itemID[${i}]="port_proxy" ; ((i++))
	itemID[${i}]="port_thttp" ; ((i++))
	itemID[${i}]="port_thttps" ; ((i++))
	itemID[${i}]="port_antivirus" ; ((i++))
	itemID[${i}]="port_ocsp" ; ((i++))
	itemID[${i}]="port_isakmp" ; ((i++))
	itemID[${i}]="port_natt" ; ((i++))
	itemID[${i}]="port_http_peer" ; ((i++))
	itemID[${i}]="port_htcp_peer" ; ((i++))
	itemID[${i}]="port_dhcp" ; ((i++))
	itemID[${i}]="port_waudit" ; ((i++))

	i=${n}
	blankItemContent[${i}]="type='text' size='5' maxlength='5' value='${PROXY_PORT}'" ; ((i++))
	blankItemContent[${i}]="type='text' size='5' maxlength='5' value='${THTTP_PORT}'" ; ((i++))
	blankItemContent[${i}]="type='text' size='5' maxlength='5' value='${THTTPS_PORT}'" ; ((i++))
	blankItemContent[${i}]="type='text' size='5' maxlength='5' value='${AV_PORT}'" ; ((i++))
	blankItemContent[${i}]="type='text' size='5' maxlength='5' value='${OCSP_PORT}'" ; ((i++))
	blankItemContent[${i}]="type='text' size='5' maxlength='5' value='${ISAKMP_PORT}'" ; ((i++))
	blankItemContent[${i}]="type='text' size='5' maxlength='5' value='${NATT_PORT}'" ; ((i++))
	blankItemContent[${i}]="type='text' size='5' maxlength='5' value='${PEER_HTTP_PORT}'" ; ((i++))
	blankItemContent[${i}]="type='text' size='5' maxlength='5' value='${PEER_HTCP_PORT}'" ; ((i++))
	blankItemContent[${i}]="type='text' size='5' maxlength='5' value='${DHCP_PEER_PORT}'" ; ((i++))
	blankItemContent[${i}]="type='text' size='5' maxlength='5' value='${WAUDIT_PORT}'" ; ((i++))

	nb=${i}
    fi

    if gui-contextual-is-allowed ; then
	for ((i=n ; i<${nb} ; i++))
	do
	    checkItem[${i}]=port
	done
    fi

    show-title "Listening Ports" "enabled" "port"
    show-form "${width}"
}

# Main()

show-port-form
