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

source system-backup-common.${GUI_EXT_NAME}

show-file-exchange-log()
{
    echo "<div class='core-form' style='margin-top:0;'>"
    refresh-buttons "update_file_operation( 1 )"
    echo "<div style='clear:left;'></div><br />"
    echo "<span class='table-title'>Last file exchange report&nbsp;</span>"
    echo "<div id='${AUTO_REPORT_ID}' class='log-report'></div>"
    echo "</div>"
}

print-operation()
{
    local file_servers=${1}
    local in_op=${2}

    local op ops
    local selected

    if test -n "${file_servers}" ; then
	ops="load save clear del"
    else
	ops="clear"
    fi

    for op in ${ops}
    do
	if test ${op} == "${in_op}" ; then
	    selected=" selected"
	else
	    unset selected
	fi
	echo -n "<option value='${op}'${selected}>${op}</option>"
    done
}

show-file-operation-form()
{
    local width operation=${VALUES[0]}
    local i n

    local operation_id='operation'
    local protocol_id='protocol'
    local server_id='server'
    local directory_id='dirname'
    local title_id='path_title'

    local admin_snmp_certificate=False
    local admin_ssh_key=False
    local tls_ca_third=False
    local tls_server=False
    local tls_ca_system=False
    local tls_client=False
    local waf_rweb_custom=False
    local antivirus_whitelist_signature=False
    local manager_ssh=False

    local i n exclusion

    case "${operation}" in
	clear)
	    n=1
	    ;;
	load|save|del)
	    n=1
	    ;;
	*)
	    n=0
	    ;;
    esac

    for ((i=n ; i<${ATTRIBUTE_NB} ; i++))
    do
	exclusion=${ATTRIBUTES[${i}]}
	local ${exclusion}=True
    done

    itemWidth[0]=35
    itemWidth[1]=65

    local file_servers=$(show-file-servers 'cur' ${VALUES[2]})

    if test "${REQUEST_METHOD}" == POST ; then
	case ${operation} in
	    clear)
		itemState[1]='disabled'
		itemState[2]='disabled'
		itemState[3]='disabled'
		;;
	    *)
		;;
	esac
    else
	if test -z "${file_servers}" ; then
	    itemState[1]='disabled'
	    itemState[2]='disabled'
	    itemState[3]='disabled'
	fi
    fi

    checkItem[3]=printable

    itemForm[0]="select"
    itemForm[1]="select"
    itemForm[2]="select"

    i=0
    itemTitle[${i}]="Operation" ; ((i++))
    itemTitle[${i}]="Protocol" ; ((i++))
    itemTitle[${i}]="File Server" ; ((i++))

    itemTitle[${i}]="Directory Path"
    itemTitleId[${i}]=${title_id}
    itemFormSelectCB[0]="fileOperationSelectCB( '${operation_id}', '${protocol_id}', '${server_id}', '${directory_id}', '${title_id}' );"
    ((i++))

    itemTitle[${i}]="Exclude SNMP Client Certificates" ; ((i++))
    itemTitle[${i}]="Exclude Administrator SSH keys" ; ((i++))
    itemTitle[${i}]="Exclude TLS Third party CAs" ; ((i++))
    itemTitle[${i}]="Exclude TLS Server objects" ; ((i++))

    i=0
    itemID[${i}]="${operation_id}" ; ((i++))
    itemID[${i}]="${protocol_id}" ; ((i++))
    itemID[${i}]="${server_id}" ; ((i++))
    itemID[${i}]="${directory_id}" ; ((i++))
    itemID[${i}]="admin_snmp_certificate" ; ((i++))
    itemID[${i}]="admin_ssh_key" ; ((i++))
    itemID[${i}]="tls_ca_third" ; ((i++))
    itemID[${i}]="tls_server" ; ((i++))

    i=0
    blankItemContent[${i}]=$(print-operation "${file_servers}" ${operation}) ; ((i++))
    blankItemContent[${i}]=$(show-file-protocol1 ${VALUES[1]:1}) ; ((i++))
    blankItemContent[${i}]=${file_servers} ; ((i++))
    blankItemContent[${i}]="type='text' size='48' maxlength='128' value='${VALUES[3]}'" ; ((i++))
    blankItemContent[${i}]="type='checkbox'$(checked ${admin_snmp_certificate})" ; ((i++))
    blankItemContent[${i}]="type='checkbox'$(checked ${admin_ssh_key})" ; ((i++))
    blankItemContent[${i}]="type='checkbox'$(checked ${tls_ca_third})" ; ((i++))
    blankItemContent[${i}]="type='checkbox'$(checked ${tls_server})" ; ((i++))

    if gui-contextual-is-allowed ; then

	n=${i}
	itemTitle[${i}]="Exclude TLS System CA" ; ((i++))
	itemTitle[${i}]="Exclude TLS Client objects" ; ((i++))
	itemTitle[${i}]="Exclude Custom WAF rules" ; ((i++))

	i=${n}
	itemID[${i}]="tls_ca_system" ; ((i++))
	itemID[${i}]="tls_client" ; ((i++))
	itemID[${i}]="waf_rweb_custom" ; ((i++))

	i=${n}
	blankItemContent[${i}]="type='checkbox'$(checked ${tls_ca_system})" ; ((i++))
	blankItemContent[${i}]="type='checkbox'$(checked ${tls_client})" ; ((i++))
	blankItemContent[${i}]="type='checkbox'$(checked ${waf_rweb_custom})" ; ((i++))
    fi

    case ${APL_ROLE} in
	gateway)
	    itemTitle[${i}]="Exclude Antivirus white list"
	    itemID[${i}]="antivirus_whitelist_signature"
	    blankItemContent[${i}]="type='checkbox'$(checked ${antivirus_whitelist_signature})"
	    ((i++))
	    ;;
	manager)
	    if ! gui-contextual-is-allowed ; then

		n=${i}
		itemTitle[${i}]="Exclude Antivirus white list" ; ((i++))
		itemTitle[${i}]="Exclude Manager SSH Keys" ; ((i++))

		i=${n}
		itemID[${i}]="antivirus_whitelist_signature" ; ((i++))
		itemID[${i}]="manager_ssh" ; ((i++))

		i=${n}
		blankItemContent[${i}]="type='checkbox'$(checked ${antivirus_whitelist_signature})" ; ((i++))
		blankItemContent[${i}]="type='checkbox'$(checked ${manager_ssh})" ; ((i++))
	    fi
	    ;;
    esac

    shortcutMenuItem[0]="access-file"
    shortcutMenuItem[1]="password-file"
    shortcutMenuTitle[0]="File Servers"
    shortcutMenuTitle[1]="Accounts"

    show-title "File Operations" "${submit}" "antivirus admin conf file tls urllist waf"
    show-shortcuts-menu
    show-form "${width}" "enabled" show-file-exchange-log
}

# Main()

show-file-operation-form
