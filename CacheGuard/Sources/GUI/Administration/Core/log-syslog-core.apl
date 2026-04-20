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

print-syslog-protocols()
{
    echo -n "udp tcp tls"
}

show-syslog-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_1}
    local state

    itemWidth[0]=10
    itemWidth[1]=15
    itemWidth[2]=55

    itemTitle[0]=""
    itemTitle[1]="Protocol"
    itemTitle[2]="Server"
    itemTitle[3]="Port"

    itemID[0]="SysLog Server"
    itemID[1]="protocol"
    itemID[2]="server"
    itemID[3]="port"

    blankItemContent[0]=""
    blankItemContent[1]=$(print-syslog-protocols)
    blankItemContent[2]="type='text' size='24' maxlength='64'"
    blankItemContent[3]="type='text' size='5' maxlength='5'"

    itemForm[1]="select"

    checkItem[2]=ipdomainname
    checkItem[3]=port

    shortcutMenuItem[0]="log-type"
    shortcutMenuTitle[0]="Log Settings"

    if test -n "${CURRENT_SYSLOG_SERVER_LIST}" ; then
	shortcutMenuItem[1]="network-utilities"
	shortcutMenuTitle[1]="Test SysLog"
    fi

    listContent=${SYSLOG_SERVER_LIST}
    test -n "${listContent}" || state=disabled
    show-title "SysLog Servers" "${state}" "log"
    show-shortcuts-menu
    show-list-form ${MAX_SYSLOG_NB} "${width}" "${page_ref}"
}

# Main()

show-syslog-form "${@}"
