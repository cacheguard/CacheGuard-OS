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

print-check-ip-function()
{
    test -n "${1}" || return 1
    local id=${1}
    echo "onblur=\"checkIP( '${id}' );\""
}

show-ip-form()
{
    local w1=30
    local w2=35
    local w3=35
    local length=2

    local elt i=0 range vlan ip netmask nb
    local width=550

    shortcutMenuItem[0]="vlan"
    shortcutMenuItem[1]="network-utilities"
    shortcutMenuTitle[0]="802.1q Tags"
    shortcutMenuTitle[1]="Send Pings"

    show-title "IP Addresses" "enabled" "ip vlan"
    echo "<div class='core-form'>"
    show-shortcuts-menu

    show-form-begin ${length}
    echo "<table class='highlight-list' width='${width}'>"

    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header' width=${w1}%></td>"
    echo "<td class='table-header' width=${w2}%><u>IP Address</u></td>"
    echo "<td class='table-header' width=${w3}%><u>Network Mask</u></td>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    if gui-contextual-is-allowed ; then
	echo "<tr>"
	echo "<td width=${w1}%>External</td>"
	echo "<td width=${w2}%><input id='external_ip' name='external_ip' type='text' size='18' maxlength='18' value='${IP_EXTERNAL_IP}' $(print-check-ip-function external_ip)></td>"
	echo "<td width=${w3}%><input id='external_mk' name='external_mk' type='text' size='15' maxlength='15' value='${IP_EXTERNAL_MASK}' $(print-check-ip-function external_mk)></td>"
	echo "</tr>"
    fi

    echo "<tr>"
    echo "<td width=${w1}%>Internal</td>"
    echo "<td width=${w2}%><input id='internal_ip' name='internal_ip' type='text' size='18' maxlength='18' value='${IP_INTERNAL_IP}' $(print-check-ip-function internal_ip)></td>"
    echo "<td width=${w3}%><input id='internal_mk' name='internal_mk' type='text' size='15' maxlength='15' value='${IP_INTERNAL_MASK}' $(print-check-ip-function internal_mk)></td>"
    echo "</tr>"

    if gui-contextual-is-allowed ; then
	echo "<tr>"
	echo "<td width=${w1}%>Auxiliary</td>"
	echo "<td width=${w2}%><input id='auxiliary_ip' name='auxiliary_ip' type='text' size='18' maxlength='18' value='${IP_AUXILIARY_IP}' $(print-check-ip-function auxiliary_ip)></td>"
	echo "<td width=${w3}%><input id='auxiliary_mk' name='auxiliary_mk' type='text' size='15' maxlength='15' value='${IP_AUXILIARY_MASK}' $(print-check-ip-function auxiliary_mk)></td>"
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
                    echo "<td width=${w1}%><input name=internal_8021q_vlan_${nb} type='hidden' value='${vlan}'>Internal [VLAN ${vlan}]</td>"
                    echo "<td width=${w2}%><input name=internal_8021q_ip_${nb} type='text' size='18' maxlength='18' value='${ip}'></td>"
                    echo "<td width=${w3}%><input name=internal_8021q_mask_${nb} type='text' size='15' maxlength='15' value='${netmask}'></td>"
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
