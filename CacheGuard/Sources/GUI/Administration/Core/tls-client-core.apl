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

show-client-tls()
{
    local title="Client Certificates"
    local width=900

    shortcutMenuItem[0]="tls-ocsp-etc"
    shortcutMenuTitle[0]="OCSP Settings"

    case ${APL_ROLE} in
	gateway)
	    ;;
	manager)
	    if gui-is-in-contextual-role ; then
		local context_base=${GUI_CONTEXT/:*}
		case ${context_base} in
		    template)
			local comment="Client certificates can't be created in a template context."

			show-title "${title}" disabled "tls"
			show-shortcuts-menu
			echo "<div style='margin:0; margin-top:5px; padding:5px;'>"
			echo "${comment}"
			echo "</div>"
			echo "<div style='clear:left;'></div>"
			show-form "${width}" disabled

			return 0
			;;
		    *)
			;;
		esac
	    fi
	    ;;
	*)
	    ;;
    esac

    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local not_available_label='n/a'
    local state add_state
    local id serial days ocsp numbits file tag revoke generate
    local del del_private

    itemWidth[1]=22
    itemWidth[3]=6
    itemWidth[5]=6

    itemTitle[1]="Identifier"
    itemTitle[2]="Serial"
    itemTitle[3]="Days"
    itemTitle[4]="OCSP"
    itemTitle[5]="Key Size"
    itemTitle[6]="Revoke Status"
    itemTitle[7]="Generate"
    itemTitle[8]="<center>Del<br />Private</center>"

    itemForm[2]="text"
    itemForm[4]="select"
    itemForm[6]="select:blank"
    itemForm[7]="state"
    itemForm[8]="state"

    itemID[0]="TLS"
    itemID[1]="tls"
    itemID[2]="serial"
    itemID[3]="days"
    itemID[4]="ocsp"
    itemID[5]="numbits"
    itemID[6]="status"
    itemID[7]="generate"
    itemID[8]="del_private"
    
    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='${MAX_NAME_LEN}' maxlength='${MAX_NAME_LEN}'"
    blankItemContent[3]="type='text' size='8' maxlength='8'"
    blankItemContent[4]="no yes"
    blankItemContent[5]="type='text' size='5' maxlength='4'"
    blankItemContent[6]="keyCompromise CACompromise affiliationChanged superseded cessationOfOperation unspecified cancelRevocation"
    blankItemContent[7]="type='checkbox' checked"
    blankItemContent[8]="type='checkbox'"

    checkItem[1]=identifier

    editColumnPage[0]="tls-client-manage"
    editColumnTitle[0]="Manage"
    
    unset listContent

    cd ${SSL_CLIENT_DIR}

    local all=$(ls -1d  *.cur *.new 2> /dev/null)

    for file in ${all}
    do
	id=${file%\.*}

	if test -f ${id}.2del ; then
	   del=$(cat ${id}.2del 2> /dev/null)
	   test -n "${del}" || continue
	   del_private=on
	else
	    if test -f ${id}.cur/${id}.key ; then
		del_private=off
	    else
		del_private=on
	    fi
	fi

	tag=${file/*\.}
	if test -f ${TMP_DIR}/${TLS_CLIENT}.${id}.2rev ; then
	    revoke=$(cat ${TMP_DIR}/${TLS_CLIENT}.${id}.2rev 2> /dev/null)
	elif test -f ${id}.revoked ; then
	    revoke=$(cat ${id}.revoked 2> /dev/null)
	else
	    revoke='active'
	fi

	case ${tag} in
	    cur)
		serial="0x$(cat ${id}.cur/${id}.serial 2> /dev/null)"
		days="${not_available_label}"
		ocsp="${not_available_label}"
		numbits="${not_available_label}"
		if test -f ${id}.new ; then
		    generate=on
		else
		    generate=off
		fi
		test ! -f ${id}.new || del_private=off
		listContent="${listContent} ${id} ${serial} ${days} ${ocsp} ${numbits} ${revoke} ${generate} ${del_private}"
		;;
	    new)
		if test ! -d ${id}.cur ; then
		    if test -f ${id}.days ; then
			days=$(cat ${id}.days 2> /dev/null)
		    else
			days=${TLS_CLIENT_DAYS}
		    fi

		    ocsp=$(cat ${id}.new 2> /dev/null)
		    if test -n "${ocsp}" ; then
			ocsp=yes
		    else
			ocsp=no
		    fi

		    numbits=$(cat ${id}.numbits 2> /dev/null)
		    test -n "${numbits}" || numbits=2048

		    if test -f ${TMP_DIR}/${LOADED}.${TLS_CLIENT}.certificate.${id} ; then
			generate=off
		    else
			generate=on
		    fi
		    listContent="${listContent} ${id} ${not_available_label} ${days} ${ocsp} ${numbits} ${revoke} ${generate} off"
		fi
		;;
	    *)
		;;
	esac
    done

    all=$(ls -1 ${TMP_DIR}/${LOADED}.${TLS_CLIENT}.certificate.* 2> /dev/null)
    for file in ${all}
    do
	id=$(file-basename ${file})
	id=${id/${LOADED}\.${TLS_CLIENT}\.certificate\.}
	test ! -d ${id}.cur || continue
	listContent="${listContent} ${id} ${not_available_label} ${not_available_label} ${not_available_label} ${not_available_label} active off on"
    done

    listContent="${listContent:1}"
    listContentStep=8

    test -n "${listContent}" || state=disabled
    local users_nb=$(gui-get-contextual-users-nb)

    show-title "${title}" "${state}" "tls"
    show-shortcuts-menu
    show-list-form $[${users_nb} * ${TLS_NB_FACTOR}] ${width} "${page_ref}" '' '' ${add_state}
}

# Main()

show-client-tls "${@}"
