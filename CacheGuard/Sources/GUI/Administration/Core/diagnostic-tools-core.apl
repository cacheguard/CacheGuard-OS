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
    local state message
    local host_id='ping-host'

    echo "<tr>"
    echo "<td>Ping the Machine</td>"
    echo "<td>"
    echo "<input name='${host_id}' id='${host_id}' type='text' size='40' maxlength='${MAX_LEN}' data-action='click-on-enter check-input' data-button-id='ping' data-check-function='checkIPDomainname' />"
    echo "</td>"
    echo "<td>"
    echo "<button id='ping' name='ping' class='form-button compact' data-action='ping' data-tool-report-id='${TOOL_REPORT_ID}' data-host-id='${host_id}'>"
    echo "PING"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    show-separator
}

show-traceroute-form()
{
    local state message protocol
    local host_id='ping-traceroute'
    local protocol_id='protocol'

    echo "<tr>"
    echo "<td>Trace Route to</td>"
    echo "<td>"
    echo "<input name='${host_id}' id='${host_id}' type='text' size='40' maxlength='${MAX_LEN}' data-action='click-on-enter check-input' data-button-id='traceroute' data-check-function='checkIPDomainname' />"
    echo "</td>"
    echo "<td>"
    echo "<button id='traceroute' name='traceroute' class='form-button compact' data-action='traceroute' data-tool-report-id='${TOOL_REPORT_ID}' data-host-id='${host_id}' data-protocol-id='${protocol_id}'>"
    echo "TRACEROUTE"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td></td>"
    echo "<td>"
    protocol=icmp
    echo "<label class='radio-label'>"
    echo "<input name='${protocol_id}' type='radio' value='${protocol}' checked />${protocol^^}"
    echo "</label>"
    echo "<label class='radio-label'>"
    protocol=udp
    echo "<input name='${protocol_id}' type='radio' value='${protocol}' />${protocol^^}"
    echo "</label>"
    echo "</td>"
    echo "<td></td>"
    echo "</tr>"

    show-separator
}

show-ip-neighbour()
{
    echo "<tr>"
    echo "<td>Neighbour Machines</td>"
    echo "<td>(print the ARP cache entries.)</td>"
    echo "<td>"
    echo "<button class='form-button compact' data-action='ip-neighbour' data-tool-report-id='${TOOL_REPORT_ID}'>"
    echo "ARP"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    show-separator
}

show-ntp-form()
{
    local state message

    test -n "${CURRENT_NTP_SERVER_LIST}" || state=" disabled"

    if test -z "${state}" ; then
        message="<span>Synchronise the system time with NTP servers.</span><br /><span class='shortcut-menu-item'><a href='ntp.${GUI_EXT_NAME}'>Configure NTP servers</a>.</span>"
    else
        message="<span>(no NTP server has been configured.)</span><br /><span class='shortcut-menu-item'><a href='ntp.${GUI_EXT_NAME}'>Configure NTP servers</a></span>"
    fi

    echo "<tr>"
    echo "<td>NTP Synchronisation</td>"
    echo "<td>${message}</td>"
    echo "<td>"
    echo "<button class='form-button compact'${state} data-action='ntp-update' data-tool-report-id='${TOOL_REPORT_ID}'>"
    echo "NTP"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    show-separator
}

show-snmp-form()
{
    local state message

    test -n "${CURRENT_SNMP_TRAP_SERVER_LIST}" -a ${CURRENT_ADMIN_SNMP} == True || state=" disabled"

    if test -z "${state}" ; then
        message="<span>Send a testing SNMP trap to all SNMP receivers.</span><br /><span class='shortcut-menu-item'><a href='admin-snmp-trap.${GUI_EXT_NAME}'>SNMP receivers</a>.</span>"
    else
        message="<i>The SNMP trap sending is deactivated.</i><br /><span class='shortcut-menu-item'><a href='admin.${GUI_EXT_NAME}'>Activate SNMP</a></span><span class='shortcut-menu-item'><a href='admin-snmp-trap.${GUI_EXT_NAME}'>Add SNMP receivers</a></span>"
    fi

    echo "<tr>"
    echo "<td>SNMP Trap</td>"
    echo "<td>${message}</td>"
    echo "<td>"
    echo "<button class='form-button compact'${state} data-action='snmp-trap-test' data-tool-report-id='${TOOL_REPORT_ID}'>"
    echo "TRAP"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    show-separator
}

show-syslog-form()
{
    local state message

    test -n "${CURRENT_SYSLOG_SERVER_LIST}" || state=" disabled"

    if test -z "${state}" ; then
        message="<span>Send a testing syslog message to all syslog servers.</span><br /><span class='shortcut-menu-item'><a href='log-syslog.${GUI_EXT_NAME}'>SysLog servers</a>.</span>"
    else
        message="<span>(no syslog server is configured.)</span><br /><span class='shortcut-menu-item'><a href='log-syslog.${GUI_EXT_NAME}'>Add SysLog Servers</a></span>"
    fi

    echo "<tr>"
    echo "<td>SysLog Message</td>"
    echo "<td>${message}</td>"
    echo "<td>"
    echo "<button class='form-button compact'${state} data-action='syslog-test' data-tool-report-id='${TOOL_REPORT_ID}'>"
    echo "SYSLOG"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    show-separator
}

show-email-form()
{
    local state message
    local email_id='email'

    test -n "${CURRENT_EMAIL_ACCOUNT_SERVER_FQDN}" -a -n "${CURRENT_EMAIL_ACCOUNT_USERNAME}" || state=" disabled"

    message="<span class='shortcut-menu-item'><a href='email.${GUI_EXT_NAME}'>Configure Email Account</a></span>"

    echo "<tr>"
    echo "<td>Send Email To</td>"
    echo "<td>"
    echo "<input name='${email_id}' id='${email_id}' type='text' size='40' maxlength='${MAX_LEN}' data-action='click-on-enter check-input' data-button-id='email' data-check-function='checkEmail' />"
    echo "</td>"
    echo "<td>"
    echo "<button id='email' name='email' class='form-button compact'${state} data-action='send-email' data-tool-report-id='${TOOL_REPORT_ID}' data-email-id='${email_id}'>"
    echo "EMAIL"
    echo "</button>"
    echo "</td>"
    echo "</tr>"
    echo "<tr>"
    echo "<td></td>"
    echo "<td>${message}</td>"
    echo "<td></td>"
    echo "</tr>"
}

echo-ldap-shortcuts()
{
    echo "<tr>"
    echo "<td></td>"
    echo "<td>"
    echo "<span class='shortcut-menu-item'><a href='authenticate-ldap-server.${GUI_EXT_NAME}'>LDAP servers</a></span>"
    echo "<span class='shortcut-menu-item'><a href='authenticate-ldap-request.${GUI_EXT_NAME}'>LDAP Settings</a></span>"
    echo "</td>"
    echo "<td></td>"
    echo "</tr>"
}

show-ldap-auth-form()
{
    local state

    test ${CURRENT_AUTHENTICATE_MODE} == True -a ${CURRENT_AUTHENTICATE_LDAP} == True -a -n "${CURRENT_LDAP_SERVER_LIST}" || state=" disabled"

    echo "<tr>"
    echo "<td>LDAP Authentication Test</td>"

    echo "<td>"
    if test -z "${state}" ; then
	echo "<label class='compact' for='login'>Login</label>"
	echo "<input name='login' id='login' type='text' size='24' maxlength='${MAX_LEN}' data-action='click-on-enter check-input' data-button-id='auth' data-check-function='checkPrintable' />"

    else
	echo "<i>The authentication mode is deactivated.</i>"
    fi
    echo "</td>"
    echo "<td>"
    echo "<button id='auth' name='auth' class='form-button compact'${state} data-action='authenticate-ldap-test' data-tool-report-id='${TOOL_REPORT_ID}'>"
    echo "AUTHENTICATE"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    if test -z "${state}" ; then
	echo "<tr>"
	echo "<td></td>"
	echo "<td>"
	echo "<label class='compact' for='password'>Password</label>"
	echo "<input name='password' id='password' type='password' size='24' maxlength='${MAX_LEN}' data-action='click-on-enter' data-button-id='auth' />"
	echo "</td>"
	echo "<td></td>"
	echo "</tr>"
    fi

    echo-ldap-shortcuts

    show-separator
}

show-ldap-search-form()
{
    local state

    test ${CURRENT_AUTHENTICATE_MODE} == True -a ${CURRENT_AUTHENTICATE_LDAP} == True -a -n "${CURRENT_LDAP_SERVER_LIST}" || state=" disabled"

    echo "<tr>"
    echo "<td>LDAP Search Filter</td>"

    echo "<td>"

    if test -z "${state}" ; then
	echo "<input name='filter' id='filter' type='text' size='40' maxlength='${MAX_LDAP_FILTER_LEN}' />"
    else
	echo "<i>The authentication mode is deactivated.</i>"
    fi
    echo "</td>"
    echo "<td>"
    echo "<button id='search' name='auth' class='form-button compact'${state} data-action='ldap-search' data-tool-report-id='${TOOL_REPORT_ID}'>"
    echo "SEARCH"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    echo-ldap-shortcuts
}

show-kerberos-keytab()
{
    local state

    test-current-kerberos-auth-state || state=" disabled"

    echo "<tr>"
    echo "<td>Kerberos Key Table</td>"

    echo "<td>"

    if test -z "${state}" ; then
	echo "Display the Kerberos key table version numbers."
    else
	echo "<i>The Kerberos authentication mode is deactivated.</i>"
    fi
    echo "</td>"
    echo "<td>"
    echo "<button id='kerberos-keytab' name='kerberos-keytab' class='form-button compact'${state} data-action='show-kerberos-keytab' data-tool-report-id='${TOOL_REPORT_ID}'>"
    echo "DISPLAY"
    echo "</button>"
    echo "</td>"
    echo "</tr>"
}

show-diagnostic-tools-form()
{
    show-title "Diagnostic Tools" disabled "admin authenticate ip ldap ntp ping traceroute"

    echo "<div class='core-form'>"
    echo "<div id='${TOOL_REPORT_ID}'></div>"

    echo "<table class='highlight-form'>"
    echo "<thead></thead>"
    echo "<tbody>"

    show-ping-form
    show-traceroute-form
    show-ip-neighbour
    show-ntp-form
    show-snmp-form
    show-syslog-form
    show-email-form

    test ${APL_ROLE} == gateway || return 0

    show-separator
    show-ldap-auth-form
    show-ldap-search-form
    show-kerberos-keytab

    echo "</tbody>"
    echo "</table>"
    echo "</div>"
    echo "</div>"
}

# Main()

show-diagnostic-tools-form
