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

source ${APPLIANCE_DIR}/etc/constant
source ${APPLIANCE_DIR}/etc/role

source ${APPLIANCE_DIR}/lib/lib-job
source ${APPLIANCE_DIR}/lib/lib-cache
source ${APPLIANCE_DIR}/lib/lib-common
source ${APPLIANCE_DIR}/lib/lib-environment
source ${APPLIANCE_DIR}/lib/lib-error
source ${APPLIANCE_DIR}/lib/lib-interface
source ${APPLIANCE_DIR}/lib/lib-openssl
source ${APPLIANCE_DIR}/lib/lib-2fa
source ${APPLIANCE_DIR}/lib/lib-tools
source ${APPLIANCE_DIR}/lib/lib-usage

source ${HARD_DIR}/cloud.conf

export GUI_READONLY_STYLE="background:White url( ${IMAGE_DIR}/gray-hatched.png ) center center repeat; cursor:not-allowed;"
export PERCENT_BAR_WIDTH=180
export MAIN_TABLE_ID='main-table'
export CANCEL_ICON_TITLE='Show & Cancel Changes'
export CONF_MODIFIED=no
export DEFAULT_LIST_FORM_WIDTH=602
export DEFAULT_LIST_FORM_WIDTH_1=497
export DEFAULT_LIST_FORM_WIDTH_2=366
export DEFAULT_LIST_FORM_WIDTH_3=337
export DEFAULT_LIST_FORM_WIDTH_4=235
export LIST_FORM_WIDTH_A=1000
export LIST_FORM_WIDTH_B=900
export LIST_FORM_WIDTH_C=800
export LIST_FORM_WIDTH_D=700

declare -a itemWidth itemTitle itemID blankItemContent itemForm checkItem

get-upper-page()
{
    get-upper-page1 ${1} ${GUI_DIR}
}

show-title-login()
{
    show-title "Login to ${COMMERCIAL_NAME}" "enabled" "password"
}

show-title-check-usage()
{
    local message register_page='register'

    message=$(get-usage-message ${TRIAL_PERIOD} ${TRIAL_PERIOD_MARGIN} ${INSTALL_DATE} ${VARIATION_DATE} ${SERIAL_DATE} ${RENEW_DAYS} ${LICENSE_PERIOD} ${LICENSE_PERIOD_MARGIN_1})

    test -n "${message}" || return 0

    echo "<center><div style='margin:0; padding:5px; font-size:110%; font-style:normal; text-align:start; border:1px solid FireBrick;'>"
    local href="/${GUI_DIR_NAME}/${register_page}.${GUI_EXT_NAME}"
    echo "<a style='color:FireBrick;' href='${href}'>${message}</a>"
    echo "</div></center>"
}

get-arg-value()
{
    test -n "${1}" || return 0
    test -n "${2}" || return 1
    local args=${1}
    local key=${2}

    local separator=','
    local assertion=':'

    local value=${args/*${key}${assertion}}
    test "${value}" != "${args}" || return 3
    value=${value/${separator}*}

    echo ${value}
}

echo-day-options()
{
    local in_day=${1}

    local day i
    declare -a day

    day[0]=Sunday
    day[1]=Monday
    day[2]=Tuesday
    day[3]=Wednesday
    day[4]=Thursday
    day[5]=Friday
    day[6]=Saturday

    if test -z "${in_day}" ; then
	echo -n "<option value='' selected>All</option>"
    else
	echo -n "<option value=''>All</option>"
    fi

    for ((i=0 ; i<7 ; i++))
    do
	if test "${i}" == "${in_day}" ; then
	    echo -n "<option value='${i}' selected>${day[${i}]}</option>"
	else
	    echo -n "<option value='${i}'>${day[${i}]}</option>"
	fi
    done
}

echo-hour-options()
{
    local in_time=${1}

    local time

    for time in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
    do
	if test "${time}" == "${in_time}" ; then
	    echo -n "<option value='${time}' selected>${time}</option>"
	else
	    echo -n "<option value='${time}'>${time}</option>"
	fi
    done
}

echo-month-options()
{
    local in_month=${1}

    local month i j
    declare -a month

    month[0]=January
    month[1]=February
    month[2]=March
    month[3]=April
    month[4]=May
    month[5]=June
    month[6]=July
    month[7]=August
    month[8]=September
    month[9]=October
    month[10]=November
    month[11]=December

    for ((i=0;i<12;i++))
    do
	j=${i} ; ((j++))
	test ${#j} -eq 2 || j="0${j}"
	if test "${j}" == "${in_month}" ; then
	    echo -n "<option value='${j}' selected>${month[${i}]}</option>"
	else
	    echo -n "<option value='${j}'>${month[${i}]}</option>"
	fi
    done
}

echo-month-day-options()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local in_year=${1}
    local in_month=${2}
    local in_day=${3}

    local day days="01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28"

    case ${in_month} in
	01|03|05|07|08|10|12)
	    days="${days} 29 30 31"
	    ;;

	04|06|09|11)
	    days="${days} 29 30"
	    ;;

	02)
	    local rest1=$[${in_year} % 4]
	    local rest2=$[${in_year} % 100]
	    local rest3=$[${in_year} % 400]
	    if test ${rest1} -eq 0 -a ${rest2} -ne 0 ; then
		days="${days} 29"
	    elif test ${rest3} -eq 0 ; then
		days="${days} 29"
	    fi
	    ;;
	*)
	    ;;
    esac

    for day in ${days}
    do
	if test "${day}" == "${in_day}" ; then
	    echo -n "<option value='${day}' selected>${day}</option>"
	else
	    echo -n "<option value='${day}'>${day}</option>"
	fi
    done
}

echo-minute-options()
{
    local in_time=${1}

    local time

    for time in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59
    do
	if test "${time}" == "${in_time}" ; then
	    echo -n "<option value='${time}' selected>${time}</option>"
	else
	    echo -n "<option value='${time}'>${time}</option>"
	fi
    done
}

echo-second-options()
{
    echo-minute-options "${@}"
}

show-title-iconbar-controls()
{
    local controls="${@}"
    local page control title

    local elt range i=0

    for elt in ${controls}
    do
	range=$[${i} % 3]
	case ${range} in
	    0)
		page=${elt}
		;;
	    1)
		control=${elt}
		;;
	    2)
		title=${elt}
		title=${title//_/ }
		echo "<span id='${control}'>"
		echo "<a class='iconbar-item' href='javascript:void( 0 );'><img id='${page}-control-image' src='${IMAGE_DIR}/${page}-reflect.png' alt='${title}' title='${title}' /></a>"
		echo "</span>"
		;;
	    *)
		return 1
		;;
	esac
	((i++))
    done
}

echo-menu-shortcut()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    local display=${1}
    local page=${2}
    local title=${3}
    local icon=${4}
    test -n "${icon}" || icon=${page}-reflect.png

    local href

    test -z "${page}" || href=" href='/${GUI_DIR_NAME}/${page}.${GUI_EXT_NAME}'"
	
    echo "<span id='${page}-shortcut' style='display:${display};'>"
    echo "<span><a id='${page}-href' class='iconbar-item'${href}><span><img id='${page}-image' src='${IMAGE_DIR}/${icon}' alt='${title}' title='${title}' /></span></a></span>"
    echo "</span>"
}

show-on-off-state()
{
    local in_state=${1}

    local state states="off on"

    for state in ${states}
    do
	if test "${in_state}" == ${state} ; then
	    echo -n "<option value='${state}' selected>${state}</option>"
	else
	    echo -n "<option value='${state}'>${state}</option>"
	fi
    done
}

show-title-donate()
{
    case ${APL_ROLE} in
	gateway)
	    ! is-licensed || return 0
	    ;;
	manager)
	    if gui-is-in-contextual-role ; then
		local gateway_nb=$(get-variable-value-from-file /${HARD_DIR_NAME}/model.conf MANAGER_GATEWAY_NB)
		! is-licensed ${APL_ROLE} ${gateway_nb} || return 0
	    else
		! is-licensed || return 0
	    fi
	    ;;
	*)
	    return 0
	    ;;
    esac

    echo "<span id='donate-iconbar'><a class='iconbar-item' href='${DONATE_URL}' target='_blank'><img src='${IMAGE_DIR}/dollar-reflect.png' alt='Make a Donation' title='Make a Donation' /></a></span>"
}

get-apply-icon-title()
{
    if gui-is-in-contextual-role ; then
	local apply_title='Validate New Configuration'
    else
	local apply_title='Apply New Configuration'
    fi

    echo ${apply_title}
}

show-title-iconbar-custom()
{
    local controls="${@}"
    local title page index

    if test ${AUTH_STATE} -eq 0 ; then

	show-title-donate

	gui-is-in-contextual-role || ! is-subscription-required || echo-menu-shortcut inline register 'Register & Subscribe'
	local display apply_title=$(get-apply-icon-title)

	if quick-conf-modified ; then CONF_MODIFIED=yes ; display=inline ; else display=none ; fi

	echo-menu-shortcut ${display} apply "${apply_title}"
	echo-menu-shortcut ${display} cancel "${CANCEL_ICON_TITLE}"

	if test -f ${TMP_DIR}/${KERBEROS_CREATE_FILENAME} ; then display=inline ; else display=none ; fi
	echo-menu-shortcut ${display} 'authenticate-kerberos-create' 'Initialize Kerberos'

	local ha_state=$(get-ha-state)
	if test ${ha_state} == failover ; then display=inline ; else display=none ; fi
	echo-menu-shortcut ${display} 'power' 'Failed Appliance! Activate?'


	if check-exchanging ; then display=inline ; else display=none ; fi
	echo-menu-shortcut ${display} file-exchange 'Files being Exchanged' loading.gif

	check-lock ; index=${?}
	if test ${index} -ne 0 ; then display=inline ; else display=none ; fi
	if test -n "${JobsPage[${index}]}" ; then
	    title="${JobsTitle[${index}]}"
	    page=${JobsPage[${index}]}
	else
	    title="Active Internal Micro Job"
	    unset page
	fi
	echo-menu-shortcut ${display} job "${title}" job.gif

	index=0
	echo "<script type='text/javascript'>"
	gui-is-in-contextual-role || ! is-subscription-required || is-registered-appliance || echo "initBlinkIcon( ${index}, 'register-image', 'register-reflect.png' );" ; ((index++))
	echo "initBlinkIcon( ${index}, 'apply-image', 'apply-reflect.png' );" ; ((index++))
	echo "initBlinkIcon( ${index}, 'cancel-image', 'cancel-reflect.png' );" ; ((index++))
	echo "initBlinkIcon( ${index}, 'authenticate-kerberos-create-image', 'authenticate-kerberos-create-reflect.png' );" ; ((index++))
	echo "initBlinkIcon( ${index}, 'power-image', 'power-reflect.png' );" ; ((index++))
	echo "initRefreshShortcuts( );"
	echo "</script>"

	show-title-iconbar-controls ${controls}
    else
	gui-is-in-contextual-role || echo "<span id='register-shortcut' style='display:none;'></span>"
	echo "<span id='apply-shortcut' style='display:none;'></span>"
	echo "<span id='cancel-shortcut' style='display:none;'></span>"
	echo "<span id='authenticate-kerberos-create-shortcut' style='display:none;'></span>"
	echo "<span id='ha-failover-shortcut' style='display:none;'></span>"
	echo "<span id='job-lock-shortcut' style='display:none;'></span>"
	echo "<span id='exchange-shortcut' style='display:none;'></span>"
    fi
}

show-title-manager-context()
{
    test ${APL_ROLE} == manager || return 0

    local dir=$(get-manager-context-rdir template)
    local templates=$(ls -1 ${HOME}/${dir} 2> /dev/null)

    test -s ${HOME}/${MANAGER_GATEWAY_INDEX} -o -n "${templates}" || return 0

    local template
    local uuid domain id ip
    local selected context_id='manager-context'
    local up_manager_context='manager:manager'

    echo "<div style='float:right; margin:0; padding:0;'>"
    echo-menu-shortcut inline manager-gateway "Managed Gateways"
    echo "<select id='${context_id}' class='manager-context' onChange='managerSelectContextCB( \"${context_id}\" );'>"

    test "${GUI_CONTEXT}" != ${up_manager_context} || selected=' selected'
    echo "<option value='${up_manager_context}'${selected}>MANAGER</option>"

    for template in ${templates}
    do
	selected=$(get-selected-option template:${template} "${GUI_CONTEXT}")
	echo "<option value='template:${template}'${selected}>TEMPLATE > ${template}</option>"
    done

    while read uuid domain id ip
    do
	test -n "${ip}" || continue
	selected=$(get-selected-option gateway:${id} "${GUI_CONTEXT}")
	echo "<option value='gateway:${id}'${selected}>GATEWAY  > ${id}</option>"
    done < ${HOME}/${MANAGER_GATEWAY_INDEX}

    echo "</select>"
    echo "</div>"
}

gui-set-context()
{
    test ${APL_ROLE} == manager || return 0

    local page=${1}

    local context use_cookie

    case "${page}" in

	${MANAGER_MAIN_PAGE})

	    if test -n "${2}" ; then
		if [[ ${2} =~ ^(template|gateway):.+$ ]] ; then
		    context=${2}
		elif [ ${2} = 'manager:manager' ] ; then
		    unset context
		fi
	    else
		use_cookie=yes
	    fi
	    ;;
	system-report|manager-gateway|manager-gateway-operation)
	    unset context
	    ;;
	*)
	    use_cookie=yes
	    ;;
    esac

    if test -n "${use_cookie}" ; then
	local cookie=${HTTP_COOKIE/*${GUI_COOKIE_CONTEXT_NAME}=/}
	test "${cookie}" == "${HTTP_COOKIE}" || context=${cookie/;*}
    fi

    GUI_CONTEXT=${context}
}

show-table-add-controls()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local max=${1}
    local ftype=${2}
    local state=${3}

    case ${ftype} in
	list|multi)
	    ;;
	*)
	    return 11
	    ;;
    esac

    test "${state}" != none || return 0

    local i width=100

    echo "<button id='${ADD_ID}' ${state} type='submit' class='${ROW_ACTION_CLASS}' onClick='addTableRecords( \"${MAIN_TABLE_ID}\", \"${ftype}\", ${max} );' style='width:130px; height:100%;'>"
    echo "<span class='button-label'><span id='${ADD_LABEL_ID}'>ADD</span> <img id='${ADD_IMAGE_ID}' src='${IMAGE_DIR}/add.png' align='top' /></span>"
    echo "</button>"

    echo "<select id='${ITEM_2ADD_ID}' class='${ROW_ACTION_CLASS}'>"
    echo -n "<option value='1'>1 Record</option>"
    for ((i=2 ; i <= 8 ; i++))
    do
	echo -n "<option value='${i}'>${i} Records</option>"
    done
    echo "</select>"

    echo "<button id='${DELETE_ID}' type='submit' class='${ROW_ACTION_CLASS}' onClick='deleteTableSelectedRecords( \"${ftype}\", \"${MAIN_TABLE_ID}\" );' style='width:${width}px; height:100%;' disabled>"
    echo "<span class='button-label'>DELETE <img src='${IMAGE_DIR}/delete.png' align='top' /></span>"
    echo "</button>"
}

show-navigation-controls()
{
    test -n "${1}" || return 1
    local records_ppage=${1}

    local value selected

    echo "<button id='${PREVIOUS_PAGE_ID}' type='button' class='${ROW_ACTION_CLASS}' style='height:100%;' onClick=''>"
    echo "<span class='button-label'><img src='${IMAGE_DIR}/left.png' align='top' /></span>"
    echo "</button>"

    echo "<select id='${SELECTED_PAGE_ID}' class='${ROW_ACTION_CLASS}'></select>"

    echo "<button id='${NEXT_PAGE_ID}' type='button' class='${ROW_ACTION_CLASS}' style='height:100%;' onClick=''>"
    echo "<span class='button-label'><img src='${IMAGE_DIR}/right.png' align='top' /></span>"
    echo "</button>"

    echo "<select id='${RECORDS_PPAGE_ID}' class='${ROW_ACTION_CLASS}'>"
    for value in 10 20 30 40 50
    do
	selected=$(get-selected-option ${value} ${records_ppage})
	echo -n "<option value='${value}'${selected}>${value} Records / Page</option>"
    done
    echo "</select>"
}

show-table-form-controls()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    local max=${1}
    local records_ppage=${2}
    local ftype=${3}
    local add_state=${4}

    echo "<div style='float:left; margin:0; height:30px;'>"

    show-table-add-controls ${max} ${ftype} ${add_state}
    show-navigation-controls ${records_ppage}

    echo "</div>"
    echo "<div style='clear:left;'></div>"
}

colon2space()
{
    test -n "${1}" || return 0
    local text=${1}

    echo ${text//\:/\ }
}

raw-execute-command()
{
    test -n "${REMOTE_USER}" || return 11

    local apl_command=${1}
    local input=${2}

    if test -z "${input}" ; then
	MANAGER_CONTEXT_ENV="${GUI_CONTEXT/:/ }" \
			   sudo --non-interactive --login --user=${REMOTE_USER} -- ${apl_command}
    else
	MANAGER_CONTEXT_ENV="${GUI_CONTEXT/:/ }" \
			   sudo --non-interactive --login --user=${REMOTE_USER} -- ${apl_command} < ${input}
    fi

    return 0
}

cli-execute-command()
{
    test -n "${1}" || return 1
    local apl_command=${1}
    local input=${2}

    raw-execute-command "${apl_command}" ${input} 2>> ${LOG} > /dev/null
}

execute-command()
{
    test -n "${1}" || return 1
    local apl_command=${1}
    local input=${2}

    TERM=${WADMIN_TERM} raw-execute-command "${apl_command}" ${input} 2>> ${LOG} > /dev/null
}

execute-command-nolog()
{
    test -n "${1}" || return 1
    local apl_command=${1}
    local input=${2}

    TERM=${WADMIN_TERM} raw-execute-command "${apl_command}" ${input} > /dev/null 2>&1
}

execute-noauth-command()
{
    test -n "${1}" || return 1
    local apl_command=${1}
    local input=${2}

    local command_1="system internal alert login failed web"
    if test "${apl_command:0:${#command_1}}" != "${command_1}" ; then return 0 ; fi

    TERM=${WADMIN_TERM} execute-command-nolog "${apl_command}" ${input}
}

execute-command-with-output()
{
    test -n "${1}" || return 1
    local apl_command=${1}
    local input=${2}

    TERM=${WADMIN_TERM} raw-execute-command "${apl_command}" ${input}
}

update-dynamic-log-value()
{
    test -n "${1}" || return 1
    local tag=${1}

    case ${tag} in
	${LOG_TAG_AV_REGULAR}|${LOG_TAG_AV_EXTENDED_CREATE})
	    execute-command-nolog "apply report" || return ${?}
	    ;;
	*)
	    ;;
    esac
}

show-log-line()
{
    local tag=${1}
    local date=${2}
    shift 2 ; local rest=${*}

    local line1 message status

    local left=94
    local right=6

    line1="${rest/\[*/}"
    if test "${rest}" == "${line1}" ; then
	message=${rest}
	status="[ ?? ]"
    else
	message="${line1}"
	status="${rest/*\[/[}"
	status=${status:1:2}
    fi

    update-dynamic-log-value ${tag}
    local dynamic_value=$(get-dynamic-log-value ${tag})

    echo "<tr>"
    echo "<td width='${left}%'>${date} ${message}${dynamic_value}</td>"
    case ${status} in
	OK)
	    echo "<td width='${right}%' align='center'><img src='${IMAGE_DIR}/ok.png' /></td>"
	    ;;
	KO)
	    echo "<td width='${right}%' align='center'><img src='${IMAGE_DIR}/ko.png' title='KO' /></td>"
	    ;;
	*)
	    echo "<td width='${right}%' align='center'><img src='${IMAGE_DIR}/rotating_arrow.gif' /></td>"
    esac
    echo "</tr>"
}

show-log1()
{
    test -n "${1}" || return 1
    local log=${1}

    test -f ${log} || return 1

    local line

    while read line
    do
	test -n "${line}" || continue
	test "${line:0:1}" != "#" || continue
	show-log-line ${line}
    done < ${log}

    test -z "${line}" || show-log-line ${line}
}

show-log()
{
    test -n "${1}" || return 1
    local log=${1}
    local table_width=${2}
    
    test -n "${table_width}" || table_width="100%"
    if test ! -s ${log} ; then
	echo-content-unavailable ${table_width} "This report is not yet available."
	return 0
    fi

    echo "<table class='report' width='${table_width}'>"
    show-log1 "${@}"
    echo "</table>"
}

checked()
{
    test -n "${1}" || return 1
    
    case "${1}" in
	True)
	    echo -n ' checked'
	    return 0
	    ;;
	False)
	    return 0
	    ;;
	*)
	    return 1
	    ;;
    esac
}

show-file-protocol1()
{
    local in_protocol=${1}
    local protocols=${2}

    local protocol

    test -n "${protocols}" || protocols="sftp tftp ftp"

    for protocol in ${protocols}
    do
        # Use "_" to prevent a false positive from a command injection filter in mod_security
	if test "${in_protocol}" == ${protocol} ; then
	    echo -n "<option value='_${protocol}' selected>${protocol}</option>"
	else
	    echo -n "<option value='_${protocol}'>${protocol}</option>"
	fi
    done
}

show-file-protocol()
{
    echo -n "<select id='protocol' name='protocol'>"
    show-file-protocol1 "${1}" "${2}"
    echo "</select>"
}

show-file-servers()
{
    test -n "${1}" || return 1
    local version=${1}
    local in_server=${2}

    local access_file_list server_list

    case ${version} in
	new)
	    access_file_list=${ACCESS_FILE_LIST}
	    ;;
	cur)
	    if gui-is-in-contextual-role ; then
		access_file_list=$(get-variable-value-from-file ${ROOT_DIR}${ADMIN_DIR}/${ENV_RDIR}/${ENV_CURRENT_NAME} CURRENT_ACCESS_FILE_LIST)
	    else
		access_file_list=${CURRENT_ACCESS_FILE_LIST}
	    fi
	    ;;
	*)
	    ;;
    esac

    local elt range i=0
    local server

    for elt in ${access_file_list}
    do
	range=$[${i} % 4]
	case ${range} in
	    0|2)
		;;
	    1)
		server=${elt}
		;;
	    3)
		if ! member "${server_list}" ${server} ; then
		    if test "${server}" == "${in_server}" ; then
			echo -n "<option value='${server}' selected>${server}</option>"
		    else
			echo -n "<option value='${server}'>${server}</option>"
		    fi
		    if test -z "${server_list}" ; then
			server_list=${server}
		    else
			server_list="${server_list} ${server}"
		    fi
		fi
		;;
	    *)
		return 1
		;;
	esac
	((i++))
    done
}

require-confirmation()
{
    test -n "${1}" || return 1
    local page=${1}

    page=${page/submit-}

    case "${page}" in
	power|cache-clear|antivirus-create|antivirus-update|log-rotate)
	    return 0
	    ;;
	*)
	    return 1
	    ;;
    esac
}

clean-gui-exit()
{
    trap "" INT QUIT TERM

    test -n "${1}" || return 1
    local alarm_pid=${1}

    kill -s KILL ${alarm_pid} 2> /dev/null
    return 0
}

get-form-js-check-function()
{
    test -n "${1}" || return 0
    local check_in=${1}
    
    local check_out
    
    case "${check_in}" in
	aalphanum)
	    check_out="checkAAlphanum"
	    ;;
	alphanum)
	    check_out="checkAlphanum"
	    ;;
	digit)
	    check_out="checkDigit"
	    ;;
	percent)
	    check_out="checkPercent"
	    ;;
	weight)
	    check_out="checkWeight"
	    ;;
	ip)
	    check_out="checkIP"
	    ;;
	ikeidentifier)
	    check="checkIKEIdentifier( \"${itemID[${i}]}\" );"
	    ;;
	domainname)
	    check_out="checkDomainname"
	    ;;
	ippx)
	    check_out="checkIPPx"
	    ;;
	mac)
	    check_out="checkMAC"
	    ;;
	ports)
	    check_out="checkPorts"
	    ;;
	port)
	    check_out="checkPort"
	    ;;
	guard)
	    check_out="checkGuard"
	    ;;
	identifier)
	    check_out="checkIdentifier"
	    ;;
	"time")
	    check_out="checkTime"
	    ;;
	ipdomainname)
	    check_out="checkIPDomainname"
	    ;;
	printable)
	    check_out="checkPrintable"
	    ;;
	text)
	    check_out="checkText"
	    ;;
	qos)
	    check_out="checkQoS"
	    ;;
	url)
	    check_out="checkURL"
	    ;;
	*)
	    ;;
    esac

    echo ${check_out}
    return 0
}

print-select-titles()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local edit_columns=${1}
    local width=${2}
    local i

    for ((i=0 ; i<edit_columns ; i++))
    do
	echo "<td class='controls' align='center'>${editColumnTitle[${i}]}</td>"
    done

    echo "<td class='controls' width='${width}' align='center' valign='middle'>"
    echo "<center>"
    echo "<button type='button' class='${ROW_ACTION_CLASS}' style='float:none; background-image:url( \"${IMAGE_DIR}/select.png\" );' onClick='toggleSelectionsTableRecords( );'></button>"
    echo "</center>"
    echo "</td>"
}

print-edit-delete-blank-columns()
{
    test -n "${1}" || return 1
    local edit_columns=${1}

    local i
    local columns=$[${edit_columns} + 1]

    for ((i=0;i<columns;i++))
    do
	echo "<td></td>"
    done
}

get-list-form-item()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    local in_array_name=${1}
    local in_value=${2}
    local in_index=${3}

    local -a ${in_array_name}
    local visible_value real_value

    case ${itemType[${in_index}]} in
	multi-coded)
	    local item_type=${in_value/:*}
	    case "${item_type}" in
		text)
		    real_value=${in_value#*:}
		    visible_value=${real_value}
		    ;;
		base64)
		    real_value=${in_value#*:}
		    visible_value=$(decode-string "${real_value}")
		    real_value=${visible_value}
		    ;;
		password)
		    unset real_value
		    visible_value="&lt;hidden&gt;"
		    ;;
		na)
		    unset real_value
		    visible_value="<i>NA</i>"
		    ;;
		*)
		    ;;
	    esac
	    ;;
	password)
            visible_value="&lt;hidden&gt;"
	    ;;
	protocol)
	    real_value=${in_value}
	    visible_value=${in_value}
	    real_value=_${real_value}
	    ;;
	*)
	    if test ${in_value} != nil ; then
		real_value="${in_value}"
		visible_value=${real_value}
	    fi
	    ;;
    esac

    eval "${in_array_name}=(\"${visible_value}\" \"${real_value}\")"
    declare -p ${in_array_name}
}

get-list-form-html-with()
{
    test -n "${1}" || return 1
    local index=${1}
    local br=${2}

    local width_html

    test -n "${br}" || width_html=" width='${itemWidth[${index}]}%'"
    echo ${width_html}
}

get-total-table-width()
{
    test -n "${1}" || return 1
    local columns=${1}

    local width=${itemWidth[0]} i=1

    for ((i=1 ; i < columns ; i++))
    do
	((width+=${itemWidth[${i}]}))
    done

    echo ${width}
}

js-init-table-form()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    local record_nb=${1}
    local records_ppage=${2}
    local page_2show=${3}
    test ${record_nb} -ge 0 || return 11
    test ${records_ppage} -ge 1 || return 13

    local pages=$[${record_nb} / ${records_ppage}]
    test $[${record_nb} % ${records_ppage}] -eq 0 || ((pages++))
    test ${pages} -gt 0 || pages=1

    echo "<script type='text/javascript'>"
    echo "var NewRecords = 0;"
    echo "var DeletedRecords = 0;"
    echo "var TableRecordCursor = ${record_nb};"
    echo "var InitialTableRecordCursor = TableRecordCursor;"
    echo "var OldTable = \$( '#${MAIN_TABLE_ID}' ).clone( true );"
    echo "initPageSelection( ${pages}, ${page_2show} );"
    echo "deactivateOKIconBar( );"
    echo "</script>"
}

show-shortcuts-menu()
{
    local nb=${#shortcutMenuItem[@]} i=0

    echo "<div class='shortcut-bar'>"
    for ((i=0 ; i<nb ; i++))
    do
	show-shortcut-menu "${shortcutMenuItem[${i}]}" "${shortcutMenuTitle[${i}]}" "${shortcutMenuArgs[${i}]}" "${shortcutMenuIcon[${i}]}"
    done
    echo "</div>"

    echo "<div style='clear:both; margin:0; padding:0; height:0;'></div>"
}

get-rows-in-record()
{
    local i nb=${#itemID[@]} rows=1

    for ((i=0 ; i<nb ; i++))
    do
        case "${itemForm[${index}]}" in 
            br)
		((rows++))
		;;
	    *)
		;;
	esac
    done
    
    echo ${rows}
}

page-2show-ref()
{
    test -n "${1}" || return 1
    local default_records_ppage=${1}
    local page_ref=${2}

    check-digit ${default_records_ppage} || return 11

    if test "${page_ref//[^-]}" != '-' ; then
	echo ${default_records_ppage} 0
	return 0
    fi

    local records_ppage=${page_ref/-*}
    local page_2show=${page_ref/*-}

    if check-digit "${records_ppage}" ; then
	if check-digit "${page_2show}" ; then
	    echo ${records_ppage} ${page_2show}
	    return 0
	fi
    fi

    echo ${default_records_ppage} 0
}

get-html-width-percentage()
{
    local width=${1}

    test -z "${width}" || width=" width='${width}%'"
    echo "${width}"
}    

show-list-form()
{
    test -n "${1}" || return 1
    local max_records=${1}
    local width=${2}
    local page_ref=${3}
    local title=${4}
    local insert=${5}
    local add_state=${6}

    local elt range n i=0
    local j record_id=0 page_nb index=1
    local items item item_value check state
    local edit_delete_columns key_value key_variable
    local comment comment bool_function icon
    local br width_html separator

    test -z "${width}" || width=" width='${width}'"
    local page_2show_ref=$(page-2show-ref 20 "${page_ref}")
    local records_ppage=${page_2show_ref/ *}
    local page_2show=${page_2show_ref/* }
    local record_separator="border-bottom:2px dotted black;"
    local record_rows=$(get-rows-in-record)
    local main_page=$(get-page) page query
    local cells_in_record=${#itemID[@]}
    local total_width=$(get-total-table-width ${cells_in_record})
    local length_single=${#singleItemID[@]}
    local edit_columns=${#editColumnPage[@]}
    local blank_columns=$[${edit_columns} + 1]
    local simple_width=24 ordered_width=111
    local controls_width

    echo "<script type='text/javascript'>"
    if test -n "${insert}" ; then
	echo "RecordInsertState = true;"
    else
	echo "RecordInsertState = false;"
    fi

    echo "var RecordWidth = new Array( );"
    echo "var RecordID = new Array( );"
    echo "var RecordInputType = new Array( );"
    echo "var RecordContent = new Array( );"
    echo "var RecordContentValues = new Array( );"
    echo "var RecordSelectCBFunction = new Array( );"
    echo "var RecordSelectCBArgs = new Array( );"
    echo "var RecordCheck = new Array( );"
    echo "var RecordInputState = new Array( );"

    echo "RecordWidth[0] = '${itemWidth[0]}';"

    echo "var RecordBlankColumns = ${blank_columns};"

    for ((i=1 ; i < cells_in_record ; i++))
    do
	test -n "${itemForm[${i}]}" || itemForm[${i}]="input"
	echo "RecordWidth[${i}] = '${itemWidth[${i}]}';"
	echo "RecordID[${i}] = '${itemID[${i}]}';"

	if test "${itemForm[${i}]:0:6}" == select ; then
	    echo "RecordInputType[${i}] = \"${itemForm[${i}]:0:6}\";"
	    echo "RecordContent[${i}] = new Array( );"
	    if test -n "${blankItemContentValues[${i}]}" ; then
		echo "RecordContentValues[${i}] = new Array( );"
	    else
		echo "RecordContentValues[${i}] = null;"
	    fi
	    
	    j=0
	    if test "${itemForm[${i}]}" == select:blank ; then
		echo "RecordContent[${i}][${j}] = \"\";"
		((j++))
	    fi
	    for elt in ${blankItemContent[${i}]}
	    do
		echo "RecordContent[${i}][${j}] = \"${elt}\";"
		((j++))
	    done

	    j=0
	    for elt in ${blankItemContentValues[${i}]}
	    do
		echo "RecordContentValues[${i}][${j}] = \"${elt}\";"
		((j++))
	    done

	    echo "RecordSelectCBFunction[${i}] = \"${itemFormSelectCBFunction[${i}]}\";"
	    echo "RecordSelectCBArgs[${i}] = new Array( );"
	    j=0
	    for elt in ${itemFormSelectCBArgs[${i}]}
	    do
		echo "RecordSelectCBArgs[${i}][${j}] = \"${elt}\";"
		((j++))
	    done

	    test -z "${itemState[${i}]}" || echo "RecordInputState[${i}] = \"${itemState[${i}]}\";"
	else
	    echo "RecordInputType[${i}] = \"${itemForm[${i}]}\";"
	    echo "RecordContent[${i}] = \"${blankItemContent[${i}]}\";"
	fi

	echo "RecordCheck[${i}] = \"$(get-form-js-check-function ${checkItem[${i}]})\";"

	test "${itemForm[${i}]}" != br || br=yes
    done

    echo "</script>"

    echo "<div class='core-form'>"
    show-table-form-controls ${max_records} ${records_ppage} list ${add_state}
    test -z "{title}" || echo "<div class='table-title'>${title}</div>"
    show-form-begin ${cells_in_record}

    for ((i=0 ; i < length_single ; i++))
    do
	echo "<input type='hidden' id='${singleItemID[${i}]}' name='${singleItemID[${i}]}' value='${singleItemValue[${i}]}' />"
    done

    echo "<table id='${MAIN_TABLE_ID}' name='${MAIN_TABLE_ID}' class='highlight-list'${width}>"
    echo "<thead>"
    echo "<tr>"

    if test "${itemWidth[0]}" == ordered ; then
	controls_width=${ordered_width}
    else
	controls_width=${simple_width}
    fi

    echo "<td class='controls' width='${controls_width}'></td>"
    ((n = cells_in_record)) ; ((n--))

    for ((i=1 ; i<n ; i++))
    do
	test "${itemForm[${i}]}" != "br" || break
	width_html=$(get-html-width-percentage ${itemWidth[${i}]})
	echo "<td class='table-header'${width_html}>${itemTitle[${i}]}</td>"
    done

    if test "${itemForm[${i}]}" != "br" ; then
	width_html=$(get-html-width-percentage ${itemWidth[${i}]})
	echo "<td class='table-header'${width_html}>${itemTitle[${i}]}</td>"
    fi

    print-select-titles ${edit_columns} ${simple_width}

    echo "</tr>"
    echo "</thead>"
    
    echo "<tbody>"

    if test -z "${listContentStep}" ; then
	local step=$[${cells_in_record} - 1]
    else
	local step=${listContentStep}
    fi
    local step_1=$[${step} - 1]

    test -n "${listContentKeyLength}" || listContentKeyLength=1

    i=0
    unset br
    local -a item_array

    for elt in ${listContent}
    do
	range=$[${i} % ${step}]

	page_nb=$[${record_id} / ${records_ppage}]
	if test ${page_nb} -ne ${page_2show} ; then
	    test ${range} -ne ${step_1} || ((record_id++))
	    ((i++))
	    continue
	fi

	item_array=$(get-list-form-item item_array "${elt}" ${index})
	eval "${item_array}"

	item=${item_array[0]}
	item_value=${item_array[1]}

	if test ${range} -eq 0 ; then
	    key_value=${item}
	elif test ${range} -lt ${listContentKeyLength} ; then
	    key_value="${key_value}§${item}"
	fi

        case "${itemForm[${index}]}" in
            br)
		br=yes
		test $[${index} % ${record_rows} + 1]  -ne ${record_rows} || separator=${record_separator}
		edit_delete_columns=$(print-edit-delete-blank-columns ${edit_columns})
		items="${items}${edit_delete_columns}"
		items="${items}</tr><tr class='${RECORD_CLASS_PREFIX}${record_id}'><td style='${separator}' bgcolor='${EMPTY_COLOR}'>${blankItemContent[${index}]}</td>"
		((index++))
		;;
	    textarea|encoded)
		item=$(decode-string ${item})
		;;
            *)
		;;
        esac

	while test ${index} -lt ${cells_in_record} -a -z "${itemID[${index}]}"
	do
	    width_html=$(get-list-form-html-with ${index} ${br})
	    items="${items}<td style='${separator}' ${width_html} bgcolor='${EMPTY_COLOR}'></td>"
	    ((index++))
	done

	if test -z "${listContentVisibility[${range}]}" ; then
	    width_html=$(get-list-form-html-with ${index} ${br})
	    case "${itemForm[${index}]}" in
		state)
		    if test ${elt} == "on" ; then
			state="checked"
		    else
			unset state
		    fi
		    items="${items}<td style='${separator}' ${width_html}><center><input id='${itemID[${index}]}_${record_id}' name='${itemID[${index}]}_${record_id}' type='checkbox' ${state} onClick='activatePostButtons( );' /></center></td>"
		    ;;
		text)
		    items="${items}<td style='${separator}' ${width_html}><span class='${RECORD_CELL_CLASS}'>${item}</span></td>"
		    ;;
		*)
		    items="${items}<td style='${separator}' ${width_html}><input id='${itemID[${index}]}_${record_id}' name='${itemID[${index}]}_${record_id}' type='hidden' value='${item_value}' /><span class='${RECORD_CELL_CLASS}'>${item}</span></td>"
		    ;;
	    esac
	fi

	if test ${range} -ne ${step_1} ; then
	    ((index++))
	    ((i++))
	    continue
	fi

	echo "<tr class='${RECORD_CLASS_PREFIX}${record_id}'>"
	echo "<td style='padding:1px;'><input id='${ENTRY_ID_PREFIX}${record_id}' name='${ENTRY_ID_PREFIX}${record_id}' type='hidden' value='old' />"
	echo "<center>"
	echo "<button type='button' class='${ROW_ACTION_CLASS}' style='background-image:url( \"${IMAGE_DIR}/delete.png\" );' onClick='deleteTableRecord( \"list\", \"${RECORD_CLASS_PREFIX}${record_id}\", \"del_${record_id}\");'></button>"

	if test -n "${insert}" ; then
	    echo "<button type='button' class='${ROW_ACTION_CLASS} ${INSERT_IMAGE_CLASS}' style='background-image:url( \"${IMAGE_DIR}/insert.png\" );' onClick='insertTableRecords( \"${MAIN_TABLE_ID}\", \"list\", \"${RECORD_CLASS_PREFIX}${record_id}\", ${max_records} );'></button>"
	    
	    echo "<button type='button' class='${ROW_ACTION_CLASS}' style='background-image:url( \"${IMAGE_DIR}/up.png\" );' onClick='moveUpTableRecord( \"${MAIN_TABLE_ID}\", \"${RECORD_CLASS_PREFIX}${record_id}\" );'></button>"
	    
	    echo "<button type='button' class='${ROW_ACTION_CLASS}' style='background-image:url( \"${IMAGE_DIR}/down.png\" );' onClick='moveDownTableRecord( \"${MAIN_TABLE_ID}\", \"${RECORD_CLASS_PREFIX}${record_id}\" );'></button>"
	fi
	echo "</center>"
	echo "</td>"
	echo "${items}"

	for ((j=0 ; j<${edit_columns} ; j++))
	do
	    page=${editColumnPage[${j}]}
	    query=${editColumnQuery[${j}]}
	    key_variable=${editColumnKey[${j}]}

	    bool_function=${editColumnCommentFunction[${j}]}

	    if test -z "${bool_function}" ; then
		if test -z "${editColumnCommentIcon[${j}]}" ; then
		    icon=${page}
		else
		    icon=${editColumnCommentIcon[${j}]}
		fi
		unset comment
	    else
		${bool_function} ${key_value}
		if test ${?} -eq 0 ; then
		    icon=${page}
		    comment=${editColumnCommentTrue[${j}]}
		else
		    icon=ok
		    comment=${editColumnCommentFalse[${j}]}
		fi
	    fi

	    test -z "${query}" || query="${query},"
	    test -n "${key_variable}" || key_variable=key

	    echo "<td style='${separator}' align='center'><a href=/${GUI_DIR_NAME}/${page}.${GUI_EXT_NAME}?${query}${key_variable}:${key_value}><img id='edit_${record_id}' name='edit_${record_id}' src='${IMAGE_DIR}/${icon}.png' alt='' title='${comment}' align='top' /></a></td>"
	done

	echo "<td align='center' style='${separator}'><input name='del_${record_id}' id='del_${record_id}' type='checkbox' style='border:0; display:none;' /><input class='${SELECTION_CLASS}' id='sel_${record_id}' type='checkbox' style='border:0;' onClick='updateTableButtons( )' /></td>"
	echo "</tr>"
	unset items
	unset br
	unset separator
	index=1
	((record_id++))
	((i++))
    done

    echo "</tbody>"
    echo "</table>"

    js-init-table-form ${record_id} ${records_ppage} ${page_2show}

    show-do "disabled" "disabled" "gotoTopWindow( )" "resetTableChanges( '${MAIN_TABLE_ID}' )"
    show-form-end
    echo "</div>"
}

show-multi-form-style()
{
    test -n "${1}" || return 1
    local step=${1}

    echo "<style type='text/css'>"
    echo "table.highlight-multi-form tr:nth-child(${step}n+1) > td {"
    echo "background:url(${IMAGE_DIR}/titlebg.gif) center center repeat-x;"
    echo "height:24px;"
    echo "border:1px solid DarkSlateGray;"
    echo "}"
    echo "</style>"
}

show-multi-form()
{
    test -n "${1}" || return 1
    local max_records=${1}
    local width=${2}
    local page_ref=${3}
    local title=${4}
    local add_state=${5}

    local elt i=0 range item items
    local blank_items blank_item separator check state
    local j record_id=0 page_nb index=1

    test -z "${width}" || width=" width='${width}'"
    local page_2show_ref=$(page-2show-ref 5 "${page_ref}")
    local records_ppage=${page_2show_ref/ *}
    local page_2show=${page_2show_ref/* }
    local cells_in_record=${#itemID[@]}
    local step=$[${cells_in_record} - 1]
    local step_1=$[${step} - 1]

    echo "<script type='text/javascript'>"

    echo "var RecordWidth = new Array( );"
    echo "var RecordID = new Array( );"
    echo "var RecordTitle = new Array( );"
    echo "var RecordInputType = new Array( );"
    echo "var RecordContent = new Array( );"
    echo "var RecordContentValues = new Array( );"
    echo "var RecordSelectCBFunction = new Array( );"
    echo "var RecordSelectCBArgs = new Array( );"
    echo "var RecordCheck = new Array( );"

    echo "RecordWidth[0] = '${itemWidth[0]}';"
    echo "RecordWidth[1] = '${itemWidth[1]}';"
    echo "RecordTitle[0] = '${itemTitle[0]}';"

    for ((i=1 ; i < cells_in_record ; i++))
    do
	test -n "${itemForm[${i}]}" || itemForm[${i}]=input

	echo "RecordID[${i}] = '${itemID[${i}]}';"
	echo "RecordTitle[${i}] = '${itemTitle[${i}]}';"

	if test "${itemForm[${i}]:0:6}" == select ; then
	    echo "RecordInputType[${i}] = \"${itemForm[${i}]:0:6}\";"
	    echo "RecordContent[${i}] = new Array( );"
	    if test -n "${blankItemContentValues[${i}]}" ; then
		echo "RecordContentValues[${i}] = new Array( );"
	    else
		echo "RecordContentValues[${i}] = null;"
	    fi
	    
	    j=0
	    if test "${itemForm[${i}]}" == select:blank ; then
		echo "RecordContent[${i}][${j}] = \"\";"
		((j++))
	    fi
	    for elt in ${blankItemContent[${i}]}
	    do
		echo "RecordContent[${i}][${j}] = \"${elt}\";"
		((j++))
	    done

	    j=0
	    for elt in ${blankItemContentValues[${i}]}
	    do
		echo "RecordContentValues[${i}][${j}] = \"${elt}\";"
		((j++))
	    done

	    echo "RecordSelectCBFunction[${i}] = \"${itemFormSelectCBFunction[${i}]}\";"
	    echo "RecordSelectCBArgs[${i}] = new Array( );"
	    j=0
	    for elt in ${itemFormSelectCBArgs[${i}]}
	    do
		echo "RecordSelectCBArgs[${i}][${j}] = \"${elt}\";"
		((j++))
	    done
	else
	    echo "RecordInputType[${i}] = \"${itemForm[${i}]}\";"
	    echo "RecordContent[${i}] = \"${blankItemContent[${i}]}\";"
	fi
	echo "RecordCheck[${i}] = \"$(get-form-js-check-function ${checkItem[${i}]})\";"
    done

    echo "</script>"

    echo "<div class='core-form'>"

    show-table-form-controls ${max_records} ${records_ppage} multi ${add_state}
    show-multi-form-style ${cells_in_record}

    test -z "{title}" || echo "<div class='table-title'>${title}</div>"

    show-form-begin ${cells_in_record}

    echo "<table id='${MAIN_TABLE_ID}' name='${MAIN_TABLE_ID}' class='highlight-multi-form'${width}>"
    echo "<thead></thead>"
    echo "<tbody>"

    local -a item_array
    i=0

    for elt in ${listContent}
    do
	range=$[${i} % ${step}]
	page_nb=$[${record_id} / ${records_ppage}]

	if test ${page_nb} -ne ${page_2show} ; then
	    test ${range} -ne ${step_1} || ((record_id++))
	    ((i++))
	    continue
	fi

	item_array=$(get-list-form-item item_array "${elt}" ${index})
	eval "${item_array}"

	item=${item_array[0]}
	item_value=${item_array[1]}
	
	if test "${itemForm[${index}]}" == text ; then
	    items="${items}<tr class='${RECORD_CLASS_PREFIX}${record_id}'><td width='${itemWidth[0]}%'>${itemTitle[${index}]}</td><td width='${itemWidth[1]}%'>${item}</td></tr>"
	else
	    case "${itemForm[${index}]}" in
		textarea|encoded)
		    item=$(decode-string ${item})
		    item_value='' # To avoid being blocked by HTML injection WAF rule
		    ;;
		*)
		    ;;
	    esac

	    items="${items}<tr class='${RECORD_CLASS_PREFIX}${record_id}'><td width='${itemWidth[0]}%'>${itemTitle[${index}]}</td><td width='${itemWidth[1]}%'><input id='${itemID[${index}]}_${record_id}' name='${itemID[${index}]}_${record_id}' type='hidden' value='${item_value}' />${item}</td></tr>"
	fi

	if test ${range} -ne ${step_1} ; then
	    ((index++))
	    ((i++))
	    continue
	fi

	echo "<tr class='${RECORD_CLASS_PREFIX}${record_id}'><td width='${itemWidth[0]}%'><i><strong>${itemTitle[0]} ${record_id}</strong></i><input id='${ENTRY_ID_PREFIX}${record_id}' name='${ENTRY_ID_PREFIX}${record_id}' type='hidden' value='old' /></td>"
	echo "<td width='${itemWidth[1]}%'>"

	echo "<input name='del_${record_id}' id='del_${record_id}' type='checkbox' style='border:0; display:none;' /><button type='button' class='${ROW_ACTION_CLASS}' style='background-image:url( \"${IMAGE_DIR}/delete.png\" );' align='left' onClick='deleteTableRecord( \"multi\", \"${RECORD_CLASS_PREFIX}${record_id}\", \"del_${record_id}\");'></button>"

	echo "<input class='${SELECTION_CLASS}' style='float:right; margin:5px; padding:0;' id='sel_${record_id}' type='checkbox' align='right' onClick='updateTableButtons( );' />"

	echo "</td></tr>"
	echo "${items}"
	unset items
	index=1
	((record_id++))
	((i++))
    done

    echo "</tbody>"
    echo "</table>"

    js-init-table-form ${record_id} ${records_ppage} ${page_2show}

    show-do "disabled" "disabled" "gotoTopWindow( )" "resetTableChanges( '${MAIN_TABLE_ID}' )"
    show-form-end ${cells_in_record}
    echo "</div>"
}

get-first-site()
{
    echo ${RWEB_SITE_LIST/ */}
}

get-first-https()
{
    local i=0 nb=1
    local elt range
    local name protocol

    for elt in ${RWEB_SITE_LIST}
    do
	range=$[${i} % 5]
	case ${range} in
	    0)
		name=${elt}
		;;
	    1)
		protocol=${elt}
		;;
	    2|3)
		;;
	    4)
		if test ${protocol} == https ; then
		    echo ${name}
		    break
		fi
		;;
	    *)
		;;
	esac
	((i++))
    done
}

show-site-select1()
{
    local in_protocol=${1}
    local in_name=${2}

    if test -z "${RWEB_SITE_LIST}" ; then
	echo -n "<option value='nil'>The rWeb list is empty</option>"
	return 0
    fi

    local i=0
    local elt range
    local name protocol

    local list

    for elt in ${RWEB_SITE_LIST}
    do
	range=$[${i} % 5]
	case ${range} in
	    0)
		name=${elt}
		;;
	    1)
		protocol=${elt}
		;;
	    2|3)
		;;
	    4)
		if test -z "${in_protocol}" -o "${in_protocol}" == any ; then
		    if ! member "${list}" ${name} ; then
			list="${list} ${name}"
			if test -z "${in_name}" ; then
			    echo -n "<option value='${name}'>${name}</option>"
			elif test "${in_name}" == "${name}" ; then
			    echo -n "<option value='${name}' selected>${name}</option>"
			else
			    echo -n "<option value='${name}'>${name}</option>"
			fi
		    fi
		else
		    if test ${protocol} == ${in_protocol} ; then
			if ! member "${list}" ${name} ; then
			    list="${list} ${name}"
			    if test -z "${in_name}" ; then
				echo -n "<option value='${name}'>${name}</option>"
			    elif test "${in_name}" == "${name}" ; then
				echo -n "<option value='${name}' selected>${name}</option>"
			    else
				echo -n "<option value='${name}'>${name}</option>"
			    fi
			fi
		    fi
		fi
		;;
	    *)
		;;
	esac
	((i++))
    done
}

show-site-select()
{
    local protocol=${1}
    local js_func=${2}
    local site_name=${3}

    if test -z "${js_func}" ; then
	echo "<select name='site_name' id='site_name'>"
    else
	echo "<select name='site_name' id='site_name' onChange=\"${js_func}\">"
    fi
    
    show-site-select1 "${protocol}" "${site_name}"

    echo "</select>"
}

get-posted-site-name()
{
    local i

    for ((i=0;i<ATTRIBUTE_NB;i++))
    do
	test ${ATTRIBUTES[${i}]} != "site_name" || break
    done
    echo ${VALUES[${i}]}
}

execute-transaction()
{
    test -n "${1}" || return 1
    local transaction=${1}

    test -s ${transaction} || return 0
    
    execute-command "transaction close"
    execute-command "transaction open" "${transaction}"
    rm -f ${transaction}
    execute-command "transaction commit log"
}

get-url-protocol()
{
    test -n "${1}" || return 1
    local url=${1}

    local protocol=${url/:*/}
    echo ${protocol}
}

get-url-domainname-uri()
{
    test -n "${1}" || return 1
    local url=${1}

    local domainname_uri=${url/*:/}
    domainname_uri=${domainname_uri:2}
    echo ${domainname_uri}
}

print-denyurl()
{
    local name=${1}

    local url=$(rweb-get-denyurl "${name}" "${RWEB_SITE_DENYURL_LIST}")
    local protocol=$(get-url-protocol ${url})
    local proto selected

    echo "<select id='protocol' name='protocol'>"
    for proto in http https ftp
    do
	selected=$(get-selected-option ${proto} "${protocol}")
	echo -n "<option value='_${proto}'${selected}>${proto}</option>"
    done
    echo "</select>://"

    local domainname_uri=$(get-url-domainname-uri ${url})
    echo "<input name='domainname_uri' id='domainname_uri' style='width:300px;' type='text' size='32' maxlength='$[${MAX_LEN} * 2]' value='${domainname_uri}' />"
}

init-refresh-exchnage-file-progress-bar()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    test -n "${4}" || return 4
    local filename_id=${1}
    local progress_id=${2}
    local progression=${3}
    local refresh_page=${4}

    echo "<script type='text/javascript'>"
    echo "initRefreshExchangeFilePercent( '${filename_id}', '${progress_id}', ${progression}, '/${GUI_DIR_NAME}/${refresh_page}.${GUI_EXT_NAME}' );"
    echo "</script>"
}

draw-percent-bar()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local width=${1}
    local in_percent=${2}

    local percent pixels precision=1000
    local color='FireBrick'
    local background='SlateGray'

    if test ${in_percent} -le 100 ; then
	((percent = in_percent))
    else
	percent=100
    fi

    ((pixels = width * percent / 100  ))

    local style1="position: relative; line-height:15px; background-color:${background}; border:1px solid black; width:${width}px;"
    local style2="height:20px; width:${pixels}px; background-color:${color};"
    local style3="color:White; position:absolute; text-align:center; padding-top:3px; width:${width}px; top:0; left:0"

    local bar1_open="<div style='${style1}'>"
    local bar11="<div style='${style2}'></div>"
    local bar12="<div style='${style3}'>${in_percent}%</div>"
    local bar1_close="</div>"

    local bar="${bar1_open}${bar11}${bar12}${bar1_close}"

    echo -n ${bar}
}

get-highlight-license-state()
{
    test -n "${1}" || return 1
    local state=${1}

    case ${state} in
	expired|error)
	    state="<font color='FireBrick'>${state}</font>"
	    ;;
	active)
	    state="<font color='SeaGreen'>${state}</font>"
	    ;;
	scheduled)
	    state="<font color='DarkOrange'>${state}</font>"
	    ;;
	*)
	    ;;
    esac

    echo ${state}
}

display-subscription-info()
{
    local id=$(get-system-id top)

    echo "<span style='float:left; margin:0; margin-left:5px; background-color:transparent;'>"
    echo "<strong>S/N</strong>: [${id}]"

    if test ${OS_FREE_USAGE} == False ; then

	local end=$(get-system-end ${APL_ROLE} top)
	local state="${end/ *}"

	echo -n ", Sub End: "
	case ${state} in
	    never)
		echo "[never]"
		;;
	    payg)
		echo "[cloud subscription end]"
		;;
	    *)
		local date="${end/* }"
		state=$(get-highlight-license-state ${state})
		echo "<strong>${date} (${state})</strong>"
		;;
	esac
    fi

    echo "</span>"
}

display-left-header-info()
{
    display-remote-ip
    display-subscription-info
}

display-appliance-time-row()
{
    local align=${1}
    local refresh_time=$(date +"%H:%M:%S" 2> /dev/null)
    local align_html
    test -z "${align}" || align_html=" align=${align}"

    echo "<tr>"
    echo "<td>"
    echo "Appliance Refresh Time"
    echo "</td>"
    echo "<td${align_html}>"
    echo "<div id='time'>${refresh_time}</div>"
    echo "</td>"
    echo "</tr>"
}

show-file-operation()
{
    local in_op=${1}
    shift
    local in_other_ops=${*}
    local op selected

    for op in load save ${in_other_ops}
    do
	selected=$(get-selected-option ${op} "${in_op}")
	echo -n "<option value='${op}'${selected}>${op}</option>"
    done
}

show-tls-country()
{
    local in_country=${1}
    test -n "${in_country}" || in_country='ZZ'

    local selected
    country_code country_name

    while read country_code country_name
    do
	test -n "${country_name}" || continue
	test ${country_code} != uk || continue
	country_code=${country_code^^}
	selected=$(get-selected-option ${country_code} ${in_country})
	echo "<option value='${country_code}'${selected}>${country_name}</option>"

    done < ${APPLIANCE_DIR}/etc/countries

    country_code=${DEFAULT_COUNTRY_CODE}
    country_name=${DEFAULT_COUNTRY_NAME}

    selected=$(get-selected-option ${country_code} ${in_country})
    echo "<option value='${country_code}'${selected}>${country_name}</option>"
}

get-login-redirect-page()
{
    echo 'system-report'
}

show-tls-server-list()
{
    local in_tls=${1}

    local selected tls

    for tls in ${TLS_SERVER_LIST}
    do
	selected=$(get-selected-option ${tls} "${in_tls}")
	echo "<option value='${tls}'${selected}>${tls}</option>"
    done
}

show-tls-client-list()
{
    local in_tls=${1}

    local tls tls_list=$(ls -1d ${SSL_CLIENT_DIR}/*.cur 2> /dev/null)

    for tls in ${tls_list}
    do
	tls=$(file-basename ${tls} \.cur)
	selected=$(get-selected-option ${tls} "${in_tls}")
	echo "<option value='${tls}'${selected}>${tls}</option>"
    done
}

show-tls-ca-list()
{
    local in_tls=${1}

    local elt range i=0
    local selected tls

    echo "<option value=''></option>"

    for elt in ${SYSTEM_CA_ID} on ${TLS_CA_LIST}
    do
	range=$[${i} % 2]
	case ${range} in
	    0)
		tls=${elt}
		;;
	    1)
		selected=$(get-selected-option ${tls} "${in_tls}")
		echo "<option value='${tls}'${selected}>${tls}</option>"
		;;
	    *)
		return 255
		;;
	esac
	((i++))
    done
}

check-user-password()
{
    test -n "${1}" || return 1
    local user=${1}
    local passwd=${2}

    local htpasswd_file=/${HARD_DIR_NAME}/.htpasswd

    check-user-password-file ${htpasswd_file} ${user} "${passwd}"
}

gui-user-exist()
{
    test -n "${1}" || return 1
    local user=${1}

    local htpasswd_file=/${HARD_DIR_NAME}/.htpasswd

    gui-user-exist-file ${htpasswd_file} ${user}
}

show-list-options()
{
    local in_values=${1}
    local in_value=${2}

    local value

    for value in ${in_values}
    do
	if test "${in_value}" == ${value} ; then
	    echo -n "<option value='${value}' selected>${value}</option>"
	else
	    echo -n "<option value='${value}'>${value}</option>"
	fi
    done
}

show-public-ssh-key()
{
    test -n "${1}" || return 1
    local file=${1}
    test -s ${file} || return 11

    local pre_id='clipboard'

    echo "<table class='report'><tr><td>$(show-pre-clipboard-copy ${pre_id})"
    echo "<pre id='${pre_id}' style='width:700px;'>"
    cat ${file} 2> /dev/null
    echo '</pre></td></tr></table>'
}

remove-eol-from-ssh-public-key()
{
    test -n "${1}" || return 1
    local ssh_key=${1}

    local f1 f2 f3
    echo ${ssh_key} > ${ADMIN_TMP_DIR}/ssh_key.${$}

    while read f1 f2 f3
    do
	test -n "${f3}" || continue
	f3=${f3//[^[:print:]]/}
	ssh_key="${f1} ${f2} ${f3}"
	break
    done < ${ADMIN_TMP_DIR}/ssh_key.${$}
    rm -f ${ADMIN_TMP_DIR}/ssh_key.${$}

    echo ${ssh_key}
}
