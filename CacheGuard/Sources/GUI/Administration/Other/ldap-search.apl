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

source functions

ldap-search()
{
    local encoded_args=${@}
    
    echo "<div class='diagnostic-tools-msg'><pre>"

    if test -n "${encoded_args}" ; then

	local stdout_tmp_file=/tmp/search-ldap.stdout.${$}
	local stderr_tmp_file=/tmp/search-ldap.stderr.${$}
	local decoded_args filter

	decoded_args=${encoded_args//@/=}
	decoded_args=$(decode-string "${decoded_args}")

	filter=${decoded_args//\\\&/ }

	execute-command-with-output "ldap search ${filter}" > ${stdout_tmp_file} 2>${stderr_tmp_file}

	if test -s ${stderr_tmp_file} ; then
	    local error=$(cat ${stderr_tmp_file} 2> /dev/null)
	    error=${error/${ERROR_TAG} /}
	    echo "<span>${error}</span>"
	else
	    if test -s ${stdout_tmp_file} ; then
		cat ${stdout_tmp_file}
	    else
		echo "<i>&lt;empty response&gt;</i>"
	    fi
	fi
	rm -f ${stdout_tmp_file} ${stderr_tmp_file}
    else
	echo "An empty filter is not allowed."
    fi
    echo "</pre></div>"
}

LOG=/dev/null
gui-run-authentication
ldap-search "${@}"
