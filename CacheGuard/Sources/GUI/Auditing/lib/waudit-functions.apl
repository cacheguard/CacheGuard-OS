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

source /etc/waudit.env
source /etc/menu.env
source lib-common
source lib-2fa
source lib-usage

is-first-login()
{
    return 11
}

gui-init-env-variables()
{
    :
}

gui-init-env()
{
    set-global-variables
}

get-upper-page()
{
    get-upper-page1 ${1}
}

display-error()
{
    test -n "${1}" || return 1
    error_code=${1}
    
    if test -z "${error_code}" ; then exit 255 ; fi
    if test ${error_code} -ge 0 -a ${error_code} -le 255
	then
	local error_text=${GUIErrors[${error_code}]}
    else
	local error_text=""
    fi
    
    echo "*** Error ${error_code}: ${error_text}" >&2
}

get-system-soft()
{
    echo -n "${OSNAME} v${OSVERSION}"
}

show-title-login()
{
    show-title "Login to ${COMMERCIAL_NAME}" "enabled"
}

display-user()
{
    local hostname=$(cat /etc/hostname 2> /dev/null)
    local domainname=$(cat /etc/domainname 2> /dev/null)

    echo "[ ${REMOTE_USER}@${hostname}.${domainname} ]"
}

show-web-log()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    local mode=${1}
    local web_log=${2}
    local number=${3}

    [[ "${number}" =~ (^[1-9][0-9]{0,10}|^0)$ ]] || return 2
    test ${number} -le 1000 || return 3

    local i=0
    local log=/var/log/${web_log}
    local style="style='word-wrap:break-word;'"

    if test ! -s "${log}" ; then
	echo "<div style='font-style:italic;'>&lt;The log is empty&gt;</div>"
	return 0
    fi

    local date machine process ip user method req ver status bytes cache peer ssl agent
    local len r_agent

    echo "<table class='highlight-list' width:100%;'>"
    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header'><strong>Date</strong></td>"
    echo "<td class='table-header'><strong>Client IP</strong></td>"
    echo "<td class='table-header'><strong>Auth User</strong></td>"
    echo "<td class='table-header'><strong>User Agent</strong></td>"
    
    case ${mode} in
	reverse)
	    ;;
	forward)
	    echo "<td class='table-header'><strong>Cache</strong></td>"
	    echo "<td class='table-header'><strong>Peer</strong></td>"
	    
	    ;;
	*)
	    ;;
    esac

    echo "<td class='table-header'><strong>Bytes</strong></td>"
    echo "<td class='table-header'><strong>Status</strong></td>"
    echo "<td class='table-header'><strong>Request</strong></td>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    tac ${log} | while read date machine process ip user method req ver status bytes cache peer ssl agent
    do
	test -n "${bytes}" || continue
	test ${i} -lt ${number} || break

        if test "${method:1}" == CONNECT -a ${bytes} == 0 ; then
            case "${ssl}" in
		peek|stare)
                    continue
                    ;;
		*)
                    ;;
            esac
        fi

	len=${#ver} ; ((len--)) ; ver=${ver:0:${len}}
        req=$(url-decode ${req})

	echo "<tr>"
	echo "<td><span ${style}>${date}</span></td>"
	echo "<td><span ${style}>${ip}</span></td>"
	echo "<td><span ${style}>${user}</span></td>"

	case ${mode} in
	    reverse)
		r_agent="${cache}"
		if test -n "${peer}" ; then
		    r_agent="${r_agent} ${peer}"
		    if test -n "${ssl}" ; then
			r_agent="${r_agent} ${ssl} "
			if test -n "${agent}" ; then
			    r_agent="${r_agent} ${agent}"
			fi
		    fi
		fi
		len=${#r_agent} ; ((len -= 2))
		agent="${r_agent:1:${len}}"
		;;
	    forward)
		len=${#agent} ; ((len -= 2))
		agent=${agent:1:${len}}
		;;
	    *)
		;;
	esac

	echo "<td><span ${style}>${agent}</span></td>"

	if test ${mode} == 'forward' ; then
	    cache=${cache/TCP_}
	    cache=${cache//_/ }
	    peer=${peer//_/ }

	    echo "<td><span ${style}>${cache}</span></td>"
	    echo "<td><span ${style}>${peer}</span></td>"
	fi

	echo "<td><span ${style}>${bytes}</span></td>"
	echo "<td><span ${style}>${status}</span></td>"
	echo "<td><span ${style}>${method:1} ${req} ${ver}</span></td>"
	echo "</tr>"
	((i++))
    done
    
    echo "</tbody>"
    echo "</table>"
}

show-audit-log-nb()
{
    test -n "${1}" || return 1
    title=${1}

    echo "<div class='core-form'>"
    echo "<table class='highlight-form' width='100%'>"
    echo "<tr>"
    echo "<td width=25%>${title}</td>"
    echo "<td width=75%>"
    echo "<select id=last>"
    echo -n "<option value='10' selected>10</option>"
    echo -n "<option value='25'>25</option>"
    echo -n "<option value='50'>50</option>"
    echo -n "<option value='75'>75</option>"
    echo -n "<option value='100'>100</option>"
    echo -n "<option value='200'>200</option>"
    echo -n "<option value='300'>300</option>"
    echo "</select>"
    echo "</td>"
    echo "</tr>"
    echo "</table>"
    echo "</div>"
}

execute-noauth-command()
{
    :
}

get-login-redirect-page()
{
    echo '${GUI_HOME_PAGE}'
}

check-user-password()
{
    test -n "${1}" || return 1
    local user=${1}
    local passwd=${2}

    local htpasswd_file=/etc/.htpasswd

    check-user-password-file ${htpasswd_file} ${user} "${passwd}"
}

gui-user-exist()
{
    test -n "${1}" || return 1
    local user=${1}

    local htpasswd_file=/etc/.htpasswd

    gui-user-exist-file ${htpasswd_file} ${user}
}
