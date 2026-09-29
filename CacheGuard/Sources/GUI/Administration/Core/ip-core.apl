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

print-check-pppoe-field-function()
{
    echo "data-action='check-input' data-check-function='checkPrintable'"
}

display-external-interface-mode()
{
    mode selected

    for mode in static dhcp pppoe
    do
	if test ${mode} == ${IP_EXTERNAL_MODE} ; then
	    selected=' selected'
	else
	    unset selected
	fi
	echo "<option value='${mode}'${selected}>${mode}</option>"
    done
}

show-ip-form()
{
    local elt range vlan ip netmask nb=0 i=0
    local ip_external_state pppoe_state

    local external_ip_id='external_ip'
    local external_mk_id='external_mk'

    local pppoe_service_name_id='pppoe_service_name'
    local pppoe_username_id='pppoe_username'
    local pppoe_password_id='pppoe_password'

    shortcutMenuItem[0]="vlan"
    shortcutMenuItem[1]="diagnostic-tools"
    shortcutMenuTitle[0]="802.1q Tags"
    shortcutMenuTitle[1]="Send Pings"

    if test ${CURRENT_IP_EXTERNAL_MODE} == 'dhcp' ; then
	shortcutMenuTitle[2]="Renew DHCP Lease"
	shortcutMenuItem[2]="ip-external-dhcp-renew"
    fi

    show-title "IP Addresses" "enabled" "ip vlan"
    echo "<div class='core-form'>"
    show-shortcuts-menu

    show-form-begin

    if gui-contextual-is-allowed ; then

	test ${IP_EXTERNAL_MODE} == 'pppoe' || pppoe_state=' disabled'

	echo "<table class='highlight-form'>"
	echo "<tbody>"
	echo "<tr>"
	echo "<td>External Interface Mode</td>"
	echo "<td>"
	echo "<select id='ip_external_mode' name='ip_external_mode' data-action='ip-external-mode' data-ip-id='${external_ip_id}' data-mk-id='${external_mk_id}' data-pppoe-service-name-id='${pppoe_service_name_id}' data-pppoe-username-id='${pppoe_username_id}' data-pppoe-password-id='${pppoe_password_id}'>$(display-external-interface-mode)</select>"
	echo "</td>"
	echo "</tr>"

	echo "<tr>"
	echo "<td>PPPoE Service Name</td>"
	echo "<td><input id='${pppoe_service_name_id}' name='${pppoe_service_name_id}' type='text' size='32' maxlength='${MAX_LEN}' value='${IP_EXTRNAL_PPPOE_SERVICE_NAME}'${pppoe_state} $(print-check-pppoe-field-function)></td>"
	echo "</tr>"

	echo "<tr>"
	echo "<td>PPPoE Userame</td>"
	echo "<td><input id='${pppoe_username_id}' name='${pppoe_username_id}' type='text' size='32' maxlength='${MAX_LEN}' value='${IP_EXTRNAL_PPPOE_USERNAME}'${pppoe_state} $(print-check-pppoe-field-function)></td>"
	echo "</tr>"

	echo "<tr>"
	echo "<td>PPPoE Password</td>"
	echo "<td><input id='${pppoe_password_id}' name='${pppoe_password_id}' type='password' size='32' maxlength='${MAX_LEN}' value='${IP_EXTRNAL_PPPOE_PASSWORD}'${pppoe_state} $(print-check-pppoe-field-function)></td>"
	echo "</tr>"

	echo "</tbody>"
	echo "</table>"
    fi

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

	test ${IP_EXTERNAL_MODE} == 'static' || ip_external_state=' disabled'

	echo "<tr>"
	echo "<td>External</td>"
	
	echo "<td><input id='${external_ip_id}' name='${external_ip_id}' type='text' size='18' maxlength='18' value='${IP_EXTERNAL_IP}'${ip_external_state} $(print-check-ip-function)></td>"
	echo "<td><input id='${external_mk_id}' name='${external_mk_id}' type='text' size='15' maxlength='15' value='${IP_EXTERNAL_MASK}'${ip_external_state} $(print-check-ip-function)></td>"
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

                    echo "<tr>"
                    echo "<td><input name='internal_8021q_vlan_${nb}' type='hidden' value='${vlan}'>Internal [VLAN ${vlan}]</td>"
                    echo "<td><input name='internal_8021q_ip_${nb}' type='text' size='18' maxlength='18' value='${ip}'></td>"
                    echo "<td><input name='internal_8021q_mask_${nb}' type='text' size='15' maxlength='15' value='${netmask}'></td>"
                    echo "</tr>"
		    ((nb++))
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
