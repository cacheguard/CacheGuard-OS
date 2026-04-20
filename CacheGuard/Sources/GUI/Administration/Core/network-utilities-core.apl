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

TOOL_BUTTON_WIDTH=120
TOOL_REPORT_WIDTH=620
TOOL_REPORT_TABLE_WIDTH=$((TOOL_REPORT_WIDTH + 21))
TOOL_REPORT_ID='tool-report'

show-separator()
{
    echo "<tr>"
    echo "<td><hr /></td>"
    echo "<td><hr /></td>"
    echo "<td></td>"
    echo "</tr>"
}

show-ping-form()
{
    test -n "${1}" || return 1
    local cb=${1}

    local state message
    local host_id='ping-host'

    local callback="${cb}; ping( '${TOOL_REPORT_ID}', '${host_id}', ${TOOL_REPORT_WIDTH} );"

    echo "<tr>"
    echo "<td width='30%'>Ping the Machine</td>"
    echo "<td width='60%'>"
    echo "<input name='${host_id}' id='${host_id}' type='text' size='40' maxlength='${MAX_LEN}' onblur=\"checkIPDomainname( '${host_id}' );\" />"
    echo "</td>"
    echo "<td width='10%'>"
    echo "<button id='ping' name='ping' class='submit' style='width:${TOOL_BUTTON_WIDTH}px;' onClick=\"${callback}\">"
    echo "PING"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    show-separator
}

show-traceroute-form()
{
    test -n "${1}" || return 1
    local cb=${1}

    local state message protocol
    local host_id='ping-traceroute'
    local protocol_id='protocol'
    local callback="${cb}; traceroute( '${TOOL_REPORT_ID}', '${host_id}', '${protocol_id}', ${TOOL_REPORT_WIDTH} );"

    echo "<tr>"
    echo "<td>Trace Route to</td>"
    echo "<td>"
    echo "<input style='margin-bottom:2px;' name='${host_id}' id='${host_id}' type='text' size='40' maxlength='${MAX_LEN}' onblur=\"checkIPDomainname( '${host_id}' );\" />"
    echo "<br />Method: "
    protocol=icmp
    echo "<input name='${protocol_id}' type='radio' value='${protocol}' checked />${protocol^^}"
    protocol=udp
    echo "<input name='${protocol_id}' type='radio' value='${protocol}' />${protocol^^}"

    echo "</td>"
    echo "<td>"
    echo "<button id='traceroute' name='traceroute' class='submit' style='width:${TOOL_BUTTON_WIDTH}px;' onClick=\"${callback}\">"
    echo "TRACEROUTE"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    show-separator
}

show-ip-neighbour()
{
    test -n "${1}" || return 1
    local cb=${1}

    local state message
    local callback="${cb}; ipNeighbour( '${TOOL_REPORT_ID}', ${TOOL_REPORT_TABLE_WIDTH} );"

    echo "<tr>"
    echo "<td>Neighbour Machines</td>"
    echo "<td>(print the ARP cache entries.)</td>"
    echo "<td>"
    echo "<button class='submit' style='width:${TOOL_BUTTON_WIDTH}px;' ${state} onClick=\"${callback}\">"
    echo "ARP"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    show-separator
}

show-ntp-form()
{
    test -n "${1}" || return 1
    local cb=${1}

    local state message
    local callback="${cb}; ajaxpage( '/${GUI_DIR_NAME}/ntp-update.${GUI_EXT_NAME}?${TOOL_REPORT_WIDTH}', '${TOOL_REPORT_ID}' );"

    test -n "${CURRENT_NTP_SERVER_LIST}" || state="disabled"
    
    if test -z "${state}" ; then
        message="<span style='float:left;'>Synchronise the system time with NTP servers.</span><br /><span class='shortcut-menu-item' style='font-size:100%;'><a href='ntp.${GUI_EXT_NAME}'>Configure NTP servers</a>.</span>"
    else
        message="<span style='float:left; font-style:italic;'>(no NTP server has been configured.)</span><br /><span class='shortcut-menu-item' style='font-size:100%;'><a href='ntp.${GUI_EXT_NAME}'>Configure NTP servers</a></span>"
    fi

    echo "<tr>"
    echo "<td>NTP Synchronisation</td>"
    echo "<td>${message}</td>"
    echo "<td>"
    echo "<button class='submit' style='width:${TOOL_BUTTON_WIDTH}px;' ${state} onClick=\"${callback}\">"
    echo "NTP"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    show-separator
}

show-snmp-form()
{
    test -n "${1}" || return 1
    local cb=${1}

    local state message
    local callback="${cb}; ajaxpage( '/${GUI_DIR_NAME}/admin-snmp-trap-test.${GUI_EXT_NAME}?${TOOL_REPORT_WIDTH}', '${TOOL_REPORT_ID}' );"

    test -n "${CURRENT_SNMP_TRAP_SERVER_LIST}" -a ${CURRENT_ADMIN_SNMP} == True || state="disabled"

    if test -z "${state}" ; then
        message="<span style='float:left;'>Send a testing SNMP trap to all SNMP receivers.</span><br /><span class='shortcut-menu-item' style='font-size:100%;'><a href='admin-snmp-trap.${GUI_EXT_NAME}'>SNMP receivers</a>.</span>"
    else
        message="<span style='float:left;font-style:italic;'>(SNMP trap sending is deactivated).</span><br /><span class='shortcut-menu-item' style='font-size:100%; margin:0;'><a href='admin.${GUI_EXT_NAME}'>Activate SNMP</a>&nbsp;</span><span class='shortcut-menu-item' style='font-size:100%; margin:0;'><a href='admin-snmp-trap.${GUI_EXT_NAME}'>Add SNMP receivers</a></span>"
    fi

    echo "<tr>"
    echo "<td>SNMP Trap</td>"
    echo "<td>${message}</td>"
    echo "<td>"
    echo "<button class='submit' style='width:${TOOL_BUTTON_WIDTH}px;' ${state} onClick=\"${callback}\">"
    echo "TRAP"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    show-separator
}

show-syslog-form()
{
    test -n "${1}" || return 1
    local cb=${1}

    local state message
    local callback="${cb}; ajaxpage( '/${GUI_DIR_NAME}/log-syslog-test.${GUI_EXT_NAME}?${TOOL_REPORT_WIDTH}', '${TOOL_REPORT_ID}' );"

    test -n "${CURRENT_SYSLOG_SERVER_LIST}" || state="disabled"

    if test -z "${state}" ; then
        message="<span style='float:left;'>Send a testing syslog message to all syslog servers.</span><br /><span class='shortcut-menu-item' style='font-size:100%;'><a href='log-syslog.${GUI_EXT_NAME}'>SysLog servers</a>.</span>"
    else
        message="<span style='float:left;font-style:italic;'>(no syslog server is configured.)</span><br /><span class='shortcut-menu-item' style='font-size:100%; margin:0;'><a href='log-syslog.${GUI_EXT_NAME}'>Add SysLog Servers</a></span>"
    fi

    echo "<tr>"
    echo "<td>SysLog Message</td>"
    echo "<td>${message}</td>"
    echo "<td>"
    echo "<button class='submit' style='width:${TOOL_BUTTON_WIDTH}px;' ${state} onClick=\"${callback}\">"
    echo "SYSLOG"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    show-separator
}

show-email-form()
{
    test -n "${1}" || return 1
    local cb=${1}

    local state message
    local email_id='email'

    local callback="${cb}; sendEmail( '${TOOL_REPORT_ID}', '${email_id}', ${TOOL_REPORT_WIDTH} );"

    message="<span class='shortcut-menu-item' style='font-size:100%;'><a href='email.${GUI_EXT_NAME}'>Configure Email Account</a></span><br />"

    echo "<tr>"
    echo "<td>Send Email To</td>"
    echo "<td>"
    echo "<input name='${email_id}' id='${email_id}' type='text' size='40' maxlength='${MAX_LEN}' onblur=\"checkEmail( '${email_id}' );\" />"
    echo "<br />${message}"
    echo "</td>"
    echo "<td>"
    echo "<button id='email' name='email' class='submit' style='width:${TOOL_BUTTON_WIDTH}px;' onClick=\"${callback}\">"
    echo "EMAIL"
    echo "</button>"
    echo "</td>"
    echo "</tr>"
}

echo-ldap-shortcuts()
{
    echo "<span class='shortcut-menu-item' style='font-size:100%;'><a href='authenticate-ldap-server.${GUI_EXT_NAME}'>LDAP servers</a></span>"
    echo "<span class='shortcut-menu-item' style='font-size:100%;'><a href='authenticate-ldap-request.${GUI_EXT_NAME}'>LDAP Settings</a></span>"
}

show-ldap-auth-form()
{
    local state callback

    test ${CURRENT_AUTHENTICATE_MODE} == True -a ${CURRENT_AUTHENTICATE_LDAP} == True -a -n "${CURRENT_LDAP_SERVER_LIST}" || state="disabled"
    callback="${cb}; authenticateLDAPTest( '${TOOL_REPORT_ID}', 'login', 'password', ${TOOL_REPORT_WIDTH} );"

    echo "<tr>"
    echo "<td>LDAP Authentication</td>"
    echo "<td>"

    if test -z "${state}" ; then
	echo "<span style='float:left;'>Authenticate the user below:</span>"
	echo "<br />"
	echo "<label class='compact' for='login'>Login</label>"
	echo "<input name='login' id='login' type='text' size='24' maxlength='${MAX_LEN}' /><br />"

	echo "<label class='compact' for='password'>Password</label>"
	echo "<input name='password' id='password' type='password' size='24' maxlength='${MAX_LEN}' /><br />"
	echo-ldap-shortcuts
    else
	echo "<span style='float:left;font-style:italic;'>(the authentication mode is deactivated.)</span><br />"
	echo-ldap-shortcuts
    fi

    echo "</td>"
    echo "<td>"
    echo "<button id='auth' name='auth' class='submit' style='width:${TOOL_BUTTON_WIDTH}px;' ${state} onClick=\"${callback}\">"
    echo "AUTHENTICATE"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    show-separator
}

show-ldap-search-form()
{
    local state callback

    test ${CURRENT_AUTHENTICATE_MODE} == True -a ${CURRENT_AUTHENTICATE_LDAP} == True -a -n "${CURRENT_LDAP_SERVER_LIST}" || state="disabled"
    callback="${cb}; LDAPSearch( '${TOOL_REPORT_ID}', 'filter', ${TOOL_REPORT_WIDTH} );"

    echo "<tr>"
    echo "<td>LDAP Search</td>"
    echo "<td>"

    if test -z "${state}" ; then
	echo "<label for='filter'>Filter:</label>"
	echo "<input name='filter' id='filter' type='text' size='40' maxlength='${MAX_LDAP_FILTER_LEN}' /><br />"
	echo-ldap-shortcuts
    else
	echo "<span style='float:left;font-style:italic;'>(the authentication mode is deactivated.)</span><br />"
	echo-ldap-shortcuts
    fi

    echo "</td>"
    echo "<td>"
    echo "<button id='search' name='auth' class='submit' style='width:${TOOL_BUTTON_WIDTH}px;' ${state} onClick=\"${callback}\">"
    echo "SEARCH"
    echo "</button>"
    echo "</td>"
    echo "</tr>"
}

show-enter-key-actions()
{
    local input button i=0
    declare -a input button

    input[${i}]="ping-machine" ; button[${i}]="ping" ; ((i++))
    input[${i}]="traceroute-machine" ; button[${i}]="traceroute" ; ((i++))
    input[${i}]="login" ; button[${i}]="auth" ; ((i++))
    input[${i}]="password" ; button[${i}]="auth" ; ((i++))
    input[${i}]="filter" ; button[${i}]="search" ; ((i++))

    local n=${#input[@]}

    for ((i=0 ; i<n ; i++))
    do
	echo "<script type='text/javascript'>"
	echo "\$('#${input[${i}]}').keyup( function( event ) { if (event.keyCode == 13) { \$('#${button[${i}]}').click( ); }} );"
	echo "</script>"
    done
}

show-network-utilities-form()
{
    local length=3
    local cb="setIconImage( '${TOOL_REPORT_ID}', 'network-utilities-working-zone', 'working-bar.gif' )"

    show-title "Diagnostic Tools" disabled "admin authenticate ip ldap ntp ping traceroute"

    echo "<div class='core-form'>"
    echo "<div id='${TOOL_REPORT_ID}' style='width:${TOOL_REPORT_WIDTH}px;'></div>"

    echo "<div style='clear:left; margin:0; padding:0;'>"
    show-table-begin ${length} ${TOOL_REPORT_TABLE_WIDTH}

    show-ping-form "${cb}"
    show-traceroute-form "${cb}"
    show-ip-neighbour "${cb}"
    show-ntp-form "${cb}"
    show-snmp-form "${cb}"
    show-syslog-form "${cb}"
    show-email-form "${cb}"

    test ${APL_ROLE} == gateway || return 0

    show-separator
    show-ldap-auth-form "${cb}"
    show-ldap-search-form "${cb}"

    show-table-end ${length}
    echo "</div>"

    show-enter-key-actions
    show-scroll-top

    echo "</div>"
}

# Main()

show-network-utilities-form
