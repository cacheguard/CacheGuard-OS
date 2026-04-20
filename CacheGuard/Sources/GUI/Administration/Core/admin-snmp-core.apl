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

show-snmp-form()
{
    local width=550

    itemWidth[0]=65
    itemWidth[1]=35

    itemTitle[0]="Running Engine ID (Hex)"
    itemTitle[1]="SNMP v3 User"
    itemTitle[2]="SNMP Community / SNMP v3 Password"
    itemTitle[3]="SNMP Community / SNMP v3 Password [Retype]"
    itemTitle[4]="Privacy Encryption Password"
    itemTitle[5]="Privacy Encryption Password [Retype]"
    itemTitle[6]="Secure TCP (over TLS)"
    itemTitle[7]="Unencrypted UDP"
    itemTitle[8]="Unencrypted TCP "
    itemTitle[9]="Downloaded the MIB"
    
    itemID[0]="engine"
    itemID[1]="user"
    itemID[2]="password1"
    itemID[3]="password2"
    itemID[4]="privacy1"
    itemID[5]="privacy2"
    itemID[6]="tls"
    itemID[7]="udp"
    itemID[8]="tcp"
    itemID[9]="mib"
    
    local engine_file=/var/run/${SNMP_ENGINE_ID}
    if test -s ${engine_file} ; then
	local engine=$(cat ${engine_file})
	engine="${engine// /}"
    else
	engine="&lt;not running&gt;"
    fi

    blankItemContent[0]="<span style='font-family:monospace;'>${engine}</span>"
    blankItemContent[1]="type='text' size='16' maxlength='${MAX_USER_LEN}' value='${SNMP_USER}'"
    blankItemContent[2]="type='password' size='16' maxlength='32' value=''"
    blankItemContent[3]="type='password' size='16' maxlength='32' value=''"
    blankItemContent[4]="type='password' size='16' maxlength='32' value=''"
    blankItemContent[5]="type='password' size='16' maxlength='32' value=''"
    blankItemContent[6]="type='checkbox'$(checked ${SNMP_TLS})"
    blankItemContent[7]="type='checkbox'$(checked ${SNMP_UDP})"
    blankItemContent[8]="type='checkbox'$(checked ${SNMP_TCP})"
    blankItemContent[9]="<a href='${MIB_DIR}/${MAIN_MIB_NAME}' target='_blank'>${MAIN_MIB_NAME}</a>"

    itemForm[0]="text"
    itemForm[9]="text"

    checkItem[1]=alphanum
    checkItem[2]=printable
    checkItem[3]=printable
    checkItem[4]=printable
    checkItem[5]=printable

    show-title "SNMP Agent Settings" "enabled" "admin password"
    show-form "${width}"
}

show-snmp-form
