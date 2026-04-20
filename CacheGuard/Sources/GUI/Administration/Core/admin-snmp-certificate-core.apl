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

show-admin-snmp-certificate()
{
    local certificate_file state

    echo "<div style='clear:left;'></div><br />"

    if test -f ${TMP_DIR}/${LOADED}.${SNMP_SSL}.certificate ; then
	certificate_file=${TMP_DIR}/${LOADED}.${SNMP_SSL}.certificate
	state="<span style='color:FireBrick;'>[loaded]</span>"
    elif test -f ${SSL_SNMP_DIR}/${SNMP_SSL}.crt ; then
	certificate_file=${SSL_SNMP_DIR}/${SNMP_SSL}.crt
	if test ${SNMP_CLIENT_CERTIFICATE} == True ; then
	    state='[active]'
	else
	    state="<span style='color:FireBrick;'>[erased]</span>"
	fi
    else
	state='[empty]'
    fi

    echo "<div class='table-title' style='width:100%;'>SNMP Client Certificate ${state}</div>"
    echo "<table class='report' width='100%'><tr><td>"

    if test -n "${certificate_file}" ; then
	local pre_id='clipboard'
	show-pre-clipboard-copy ${pre_id}
	echo "<pre id='${pre_id}'>"
	openssl x509 -in ${certificate_file} -text -noout 2> /dev/null
	echo
	openssl x509 -in ${certificate_file} -fingerprint -sha256 -noout 2> /dev/null
	openssl x509 -in ${certificate_file} -fingerprint -sha1 -noout 2> /dev/null
	echo
	cat ${certificate_file}
	echo "</pre>"
    fi

    echo '</td></tr></table>'
}

show-admin-snmp-certificate-op()
{
    local in_op=${1}

    local ops="load raz" op

    for op in ${ops}
    do
	if test "${in_op}" == ${op} ; then
	    echo -n "<option value='${op}' selected>${op}</option>"
	else
	    echo -n "<option value='${op}'>${op}</option>"
	fi
    done
}

admin-snmp-certificate()
{
    local width state

    local operation_id='operation'
    local protocol_id='protocol'
    local server_id='server'
    local filename_id='filename'

    itemWidth[0]=35
    itemWidth[1]=65

    itemTitle[0]="Operation"
    itemTitle[1]="Protocol"
    itemTitle[2]="File Server"
    itemTitle[3]="File Path"

    itemID[0]="${operation_id}"
    itemID[1]="${protocol_id}"
    itemID[2]="${server_id}"
    itemID[3]="${filename_id}"

    local file_servers=$(show-file-servers 'cur' ${VALUES[2]})
    test -n "${file_servers}" || state=disabled

    blankItemContent[0]="$(show-admin-snmp-certificate-op)"
    blankItemContent[1]="$(show-file-protocol1 ${VALUES[1]:1})"
    blankItemContent[2]=${file_servers}
    blankItemContent[3]="type='text' size='44' maxlength='128' value='${VALUES[3]}'"

    checkItem[3]=printable

    itemForm[0]="select"
    itemForm[1]="select"
    itemForm[2]="select"

    itemFormSelectCB[0]="adminSNMPCertificateSelectCB( '${operation_id}', '${protocol_id}', '${server_id}', '${filename_id}' );"

    shortcutMenuItem[0]="access-file"
    shortcutMenuTitle[0]="File Servers"

    show-title "SNMP Client Certificate" "${state}" "access admin"
    show-shortcuts-menu
    show-form "${width}" "${state}" "show-admin-snmp-certificate"
}

# Main()

admin-snmp-certificate
