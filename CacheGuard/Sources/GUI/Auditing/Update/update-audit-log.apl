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

source functions

get-file-name-from-rest()
{
    local code=${1}
    local size=${2}
    local dummy3=${3}
    local dummy4=${4}
    local key=${5}
    local dummy6=${6}
    local file=${7}
    local dummy8=${8}
    local dummy9=${9}
    local md5=${10}

    echo ${file}
}

show-log()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 1
    local number=${1}
    local name=${2}

    [[ "${number}" =~ (^[1-9][0-9]{0,10}|^0)$ ]] || return 2
    test ${number} -le 1000 || return 3
    [[ "${name}" =~ ^[a-zA-Z0-9][a-zA-Z0-9.\-]*[.][a-zA-Z0-9.\-]*[a-zA-Z0-9\-]$ ]] || return 4

    local log=${WAUDITDIR}/${name}/audit.log

    if test -s "${log}" ; then

	local site ip dummy1 dummy2 date1 date2 method rest
	local uri code size dummy3 dummy4 key dummy5 file dummy6 dummy7 md5

	local protocol=" HTTP/1.1\" "
	local uri_len rest_len protocol_len=${#protocol}

	echo "<br />"
	echo "<strong>Last requests</strong>"
	echo "<div style='overflow:hidden;'>"
	echo "<select size='10' id='request' style='width:750px; font-size:80%;' onChange='showAuditLog( \"${name}\", 1 );'>"


	tail -${number} ${log} | while read -r site ip dummy1 dummy2 date1 date2 method rest
	do
	    uri=${rest/ HTTP\/[0-9]\.[0-9]\" */}
	    uri_len=${#uri}
	    rest_len=$[${uri_len}+${protocol_len}]
            rest=${rest:${rest_len}}
	    file=$(get-file-name-from-rest ${rest})
	    uri=$(url-decode "${uri}")
	    echo -n "<option value='${file}'>${method:1} ${uri}</option>"
	done

	echo "</select>"
	echo "</div>"

	echo "<p>"
	
	echo "<div id='audit'>"
	echo "</div>"
    else
	echo "<input type='hidden' id='request' name='file' value=''>"
	echo "<input type='hidden' id='audit'>"
	echo-unavailable-message "The audit log is empty."
	echo "<br />"
    fi
}

# Main()

gui-run-authentication
show-log "${@}"
