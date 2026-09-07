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

print-check-ip-function()
{
    echo "data-action='check-input' data-check-function='checkIP'"
}

show-ip-form()
{
    local elt range vlan ip netmask nb i=0

    shortcutMenuItem[0]="vlan"
    shortcutMenuItem[1]="diagnostic-tools"
    shortcutMenuTitle[0]="802.1q Tags"
    shortcutMenuTitle[1]="Send Pings"

    show-title "IP Addresses" "enabled" "ip vlan"
    echo "<div class='core-form'>"
    show-shortcuts-menu

    show-form-begin
    echo "<table class='highlight-form'>"

    echo "<thead>"
    echo "<tr>"
    echo "<th class='table-header'></th>"
    echo "<th class='table-header'>IP Address</th>"
    echo "<th class='table-header'>Network Mask</th>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    if gui-contextual-is-allowed ; then
	echo "<tr>"
	echo "<td>External</td>"
	echo "<td><input id='external_ip' name='external_ip' type='text' size='18' maxlength='18' value='${IP_EXTERNAL_IP}' $(print-check-ip-function)></td>"
	echo "<td><input id='external_mk' name='external_mk' type='text' size='15' maxlength='15' value='${IP_EXTERNAL_MASK}' $(print-check-ip-function)></td>"
	echo "</tr>"
    fi

    echo "<tr>"
    echo "<td>Internal</td>"
    echo "<td><input id='internal_ip' name='internal_ip' type='text' size='18' maxlength='18' value='${IP_INTERNAL_IP}' $(print-check-ip-function)></td>"
    echo "<td><input id='internal_mk' name='internal_mk' type='text' size='15' maxlength='15' value='${IP_INTERNAL_MASK}' $(print-check-ip-function)></td>"
    echo "</tr>"

    if gui-contextual-is-allowed ; then
	echo "<tr>"
	echo "<td>Auxiliary</td>"
	echo "<td><input id='auxiliary_ip' name='auxiliary_ip' type='text' size='18' maxlength='18' value='${IP_AUXILIARY_IP}' $(print-check-ip-function)></td>"
	echo "<td><input id='auxiliary_mk' name='auxiliary_mk' type='text' size='15' maxlength='15' value='${IP_AUXILIARY_MASK}' $(print-check-ip-function)></td>"
	echo "</tr>"

	for elt in ${IP_VLAN_LIST}
	do
            range=$[${i} % 3]
            case ${range} in
		0)
                    vlan=${elt}
                    ;;
		1)
                    ip=${elt}
                    ;;
		2)
                    netmask=${elt}
                    nb=$[${i} / 3]
		    
                    echo "<tr>"
                    echo "<td><input name=internal_8021q_vlan_${nb} type='hidden' value='${vlan}'>Internal [VLAN ${vlan}]</td>"
                    echo "<td><input name=internal_8021q_ip_${nb} type='text' size='18' maxlength='18' value='${ip}'></td>"
                    echo "<td><input name=internal_8021q_mask_${nb} type='text' size='15' maxlength='15' value='${netmask}'></td>"
                    echo "</tr>"
                    ;;
		*)
                    return 1
                    ;;
            esac
	    ((i++))
	done
    fi

    echo "</tbody>"
    echo "</table>"
    show-do
    show-form-end
    echo "</div>"
}

# Main()

show-ip-form
