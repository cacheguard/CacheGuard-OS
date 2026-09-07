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

DASHBOARD_WINDOW_WIDTH=410
export CANCEL_ICON_TITLE='Show & Cancel Changes'
export CONF_MODIFIED=no
export DEFAULT_LIST_RECORD_NB=20
export DEFAULT_MULTI_LIST_RECORD_NB=5

declare -a itemTitle itemID blankItemContent itemForm checkItem

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

    echo "<div class='box-usage'>"
    local href="/${GUI_DIR_NAME}/${register_page}.${GUI_EXT_NAME}"
    echo "<a href='${href}'>${message}</a>"
    echo "</div>"
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
		echo "<a class='title-bar-item' href='#'><img id='${page}-control-image' src='${IMAGE_DIR}/${page}-reflect.png' alt='${title}' title='${title}' /></a>"
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

    local href class

    test -n "${icon}" || icon=${page}-reflect.png

    case ${display} in
	no)
	    class='item-not-displayed'
	    ;;
	yes)
	    class='item-displayed';
	    ;;
	*)
	    ;;
    esac

    test -z "${page}" || href=" href='/${GUI_DIR_NAME}/${page}.${GUI_EXT_NAME}'"

    echo "<span id='${page}-shortcut' class='${class}'>"
    echo "<span><a id='${page}-href' class='title-bar-item'${href}><span><img id='${page}-image' src='${IMAGE_DIR}/${icon}' alt='${title}' title='${title}' /></span></a></span>"
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

    echo "<span id='donate-iconbar'><a class='title-bar-item' href='${DONATE_URL}' target='_blank'><img src='${IMAGE_DIR}/dollar-reflect.png' alt='Make a Donation' title='Make a Donation' /></a></span>"
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

	gui-is-in-contextual-role || ! is-subscription-required || echo-menu-shortcut yes register 'Register & Subscribe'
	local display apply_title=$(get-apply-icon-title)

	if quick-conf-modified ; then CONF_MODIFIED=yes ; display=yes ; else display=no ; fi

	echo-menu-shortcut ${display} apply "${apply_title}"
	echo-menu-shortcut ${display} cancel "${CANCEL_ICON_TITLE}"

	if test -f ${TMP_DIR}/${KERBEROS_CREATE_FILENAME} ; then display=yes ; else display=no ; fi
	echo-menu-shortcut ${display} 'authenticate-kerberos-create' 'Initialize Kerberos'

	local ha_state=$(get-ha-state)
	if test ${ha_state} == failover ; then display=yes ; else display=no ; fi
	echo-menu-shortcut ${display} 'power' 'Failed Appliance! Activate?'


	if check-exchanging ; then display=yes ; else display=no ; fi
	echo-menu-shortcut ${display} file-exchange 'Files being Exchanged' loading.gif

	check-lock ; index=${?}
	if test ${index} -ne 0 ; then display=yes ; else display=no ; fi
	if test -n "${JobsPage[${index}]}" ; then
	    title="${JobsTitle[${index}]}"
	    page=${JobsPage[${index}]}
	else
	    title="Active Internal Micro Job"
	    unset page
	fi
	echo-menu-shortcut ${display} job "${title}" job.gif

	index=0
	gui-is-in-contextual-role || ! is-subscription-required || is-registered-appliance || { echo "<div data-init-blink-icon data-index='${index}' data-image-id='register-image' hidden></div>"; ((index++)); }
	echo "<div data-init-blink-icon data-index='${index}' data-image-id='apply-image' hidden></div>"; ((index++))
	echo "<div data-init-blink-icon data-index='${index}' data-image-id='cancel-image' hidden></div>"; ((index++))
	echo "<div data-init-blink-icon data-index='${index}' data-image-id='authenticate-kerberos-create-image' hidden></div>"; ((index++))
	echo "<div data-init-blink-icon data-index='${index}' data-image-id='power-image' hidden></div>"; ((index++))
	echo "<div data-init-refresh-shortcuts hidden></div>"

	show-title-iconbar-controls ${controls}
    else
	gui-is-in-contextual-role || echo "<span id='register-shortcut' class='item-not-displayed'></span>"
	echo "<span id='apply-shortcut' class='item-not-displayed'></span>"
	echo "<span id='cancel-shortcut' class='item-not-displayed'></span>"
	echo "<span id='authenticate-kerberos-create-shortcut' class='item-not-displayed'></span>"
	echo "<span id='ha-failover-shortcut' class='item-not-displayed'></span>"
	echo "<span id='job-lock-shortcut' class='item-not-displayed'></span>"
	echo "<span id='exchange-shortcut' class='item-not-displayed'></span>"
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

    echo-menu-shortcut yes manager-gateway "Managed Gateways"
    echo "<span class='title-bar-item'><select id='${context_id}' title='Context' data-action='manager-select-context'>"

    test "${GUI_CONTEXT}" != ${up_manager_context} || selected=' selected'

    echo "<option value='${up_manager_context}'${selected}>Manager</option>"

    if test -s ${HOME}/${MANAGER_GATEWAY_INDEX} ; then
	echo "<optgroup label='Gateways'>"
	while read uuid domain id ip
	do
	    test -n "${ip}" || continue
	    selected=$(get-selected-option gateway:${id} "${GUI_CONTEXT}")
	    echo "<option value='gateway:${id}'${selected}>[G]${id}</option>"
	done < ${HOME}/${MANAGER_GATEWAY_INDEX}
	echo "</optgroup>"
    fi

    if test -n "${templates}" ; then
	echo "<optgroup label='Templates'>"
	for template in ${templates}
	do
	    selected=$(get-selected-option template:${template} "${GUI_CONTEXT}")
	    echo "<option value='template:${template}'${selected}>[T]${template}</option>"
	done
	echo "</optgroup>"
    fi

    echo "<option value='${up_manager_context}'>Manager</option>"

    echo "</select>"
    echo "</span>"
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

    echo "<button id='${ADD_ID}' ${state} type='button' class='${ROW_ACTION_CLASS} row-operation' data-action='add-table-records' data-table='${MAIN_TABLE_ID}' data-list-type='${ftype}' data-max-records='${max}'>"
    echo "<img id='${ADD_IMAGE_ID}' src='${IMAGE_DIR}/add.png' />"
    echo "</button>"

    echo "<select id='${ITEM_2ADD_ID}' class='${ROW_ACTION_CLASS}'>"
    echo -n "<option value='1'>1 Record</option>"
    for ((i=2 ; i <= 8 ; i++))
    do
	echo -n "<option value='${i}'>${i} Records</option>"
    done
    echo "</select>"

    echo "<button id='${DELETE_ID}' type='submit' class='${ROW_ACTION_CLASS} row-operation' data-action='delete-table-records' data-table='${MAIN_TABLE_ID}' data-list-type='${ftype}' disabled>"
    echo "<img src='${IMAGE_DIR}/delete.png' />"
    echo "</button>"
}

show-navigation-controls()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    local records=${1}
    local records_ppage=${2}
    local page_2show=${3}

    local i page_nb pages=$[${records} / ${records_ppage}]
    test $[${records} % ${records_ppage}] -eq 0 || ((pages++))
    local value selected

    echo "<button id='${PREVIOUS_PAGE_ID}' type='button' class='${ROW_ACTION_CLASS} row-operation'  data-action='previous-page'>"
    echo "<img src='${IMAGE_DIR}/left.png' align='top' />"
    echo "</button>"

    echo "<select id='${SELECTED_PAGE_ID}' class='${ROW_ACTION_CLASS}' data-action='page-selection'>"

    if test ${pages} -eq 0 ; then
	echo "<option value='${i}'>Page $((i+1))</option>"
    else
	for ((i=0; i<pages; i++))
	do
	    page_nb=$[${i} / ${records_ppage}]

	    if test ${i} -eq ${page_2show} ; then
		echo "<option value='${i}' selected>Page $((i+1))</option>"
	    else
		echo "<option value='${i}'>Page $((i+1))</option>"
	    fi
	done
    fi
    echo "</select>"

    echo "<button id='${NEXT_PAGE_ID}' type='button' class='${ROW_ACTION_CLASS} row-operation' data-action='next-page'>"
    echo "<img src='${IMAGE_DIR}/right.png' align='top' />"
    echo "</button>"

    echo "<select id='${RECORDS_PPAGE_ID}' class='${ROW_ACTION_CLASS}' data-action='records-per-page'>"
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
    test -n "${4}" || return 4
    test -n "${5}" || return 5
    local records=${1}
    local max=${2}
    local records_ppage=${3}
    local page_2show=${4}
    local ftype=${5}
    local add_state=${6}

    echo "<div class='navigation-controls' data-table-navigation data-pages='${records_ppage}'>"
    show-table-add-controls ${max} ${ftype} ${add_state}
    show-navigation-controls ${records} ${records_ppage} ${page_2show}
    echo "</div>"
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
    echo "<td>${date} ${message}${dynamic_value}</td>"
    case ${status} in
	OK)
	    echo "<td align='center'><img src='${IMAGE_DIR}/ok.png' /></td>"
	    ;;
	KO)
	    echo "<td align='center'><img src='${IMAGE_DIR}/ko.png' title='KO' /></td>"
	    ;;
	*)
	    echo "<td align='center'><img src='${IMAGE_DIR}/rotating_arrow.gif' /></td>"
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
    if test ! -s ${log} ; then
	echo-unavailable-message "this report is not yet available."
	return 0
    fi

    echo "<table class='report'>"
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

    test -n "${protocols}" || protocols="sftp ftp tftp"

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

print-select-items()
{
    test -n "${1}" || return 1
    local edit_columns=${1}
    local i

    for ((i=0 ; i<edit_columns ; i++))
    do
	echo "<th class='table-header' align='center'>${editColumnTitle[${i}]}</th>"
    done

    echo "<th class='table-header' align='center' valign='middle'>"
    echo "<center><button type='button' class='${ROW_ACTION_CLASS} select-items' data-action='toggle-selections-table-records'></button></center>"
    echo "</th>"
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

data-init-table-form()
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

    echo "<div data-init-table-form data-record-nb='${record_nb}' hidden></div>"
}

show-shortcuts-menu()
{
    local nb=${#shortcutMenuItem[@]}
    test ${nb} -ne 0 || return 0

    local i
    echo "<div class='shortcut-bar'>"
    for ((i=0 ; i<nb ; i++))
    do
	show-shortcut-menu "${shortcutMenuItem[${i}]}" "${shortcutMenuTitle[${i}]}" "${shortcutMenuArgs[${i}]}" "${shortcutMenuIcon[${i}]}"
    done
    echo "</div>"
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
    local j page_nb index=1 record_id=0
    local items item item_value check state
    local edit_delete_columns key_value key_variable
    local comment comment bool_function icon
    local br separator

    unset width
    local page_2show_ref=$(page-2show-ref ${DEFAULT_LIST_RECORD_NB} "${page_ref}")
    local records_ppage=${page_2show_ref/ *}
    local page_2show=${page_2show_ref/* }
    local record_rows=$(get-rows-in-record)
    local main_page=$(get-page) page query
    local cells_in_record=${#itemID[@]}

    local records=$(record-length-list ${cells_in_record} "${listContent}")

    local length_single=${#singleItemID[@]}
    local edit_columns=${#editColumnPage[@]}
    local blank_columns=$[${edit_columns} + 1]

    local insert_state values content_values

    if test -n "${insert}" ; then
	insert_state='true'
    else
	insert_state='false'
    fi

    cat << EOT
<script type='application/json' data-list-records-config>
{
"insertState": ${insert_state},
"blankColumns": ${blank_columns},
"records": [
EOT
    for ((i=1 ; i < cells_in_record ; i++))
    do
	test -n "${itemForm[${i}]}" || itemForm[${i}]="input"

	echo "${separator}{"
	echo "\"id\": \"${itemID[${i}]}\","

	if test "${itemForm[${i}]:0:6}" == select ; then

	    echo "\"inputType\": \"${itemForm[${i}]:0:6}\","

	    unset values
	    test "${itemForm[${i}]}" != select:blank -o -z "${blankItemContentValues[${i}]}" || values="\"\""
	    for elt in ${blankItemContentValues[${i}]}
	    do
		values="${values},\"${elt}\""
	    done
	    test "${values:0:1}" != ',' || values=${values:1}
	    echo "\"contentValues\": [${values}],"

	    unset values
	    test "${itemForm[${i}]}" != select:blank || values="\"\""
	    for elt in ${blankItemContent[${i}]}
	    do
		values="${values},\"${elt}\""
	    done
	    test "${values:0:1}" != ',' || values=${values:1}
	    echo "\"content\": [${values}],"

	    echo "\"data\": \"${itemData[${i}]}\","

	else
	    echo "\"inputType\": \"${itemForm[${i}]}\","
	    echo "\"content\": \"${blankItemContent[${i}]}\","
	fi

	test -z "${itemState[${i}]}" || echo "\"inputState\": \"${itemState[${i}]}\","
	echo "\"check\": \"$(get-form-js-check-function ${checkItem[${i}]})\""

	test "${itemForm[${i}]}" != br || br=yes

	echo '}'
	separator=','
    done

    cat << EOT
]
}
</script>
EOT

    echo "<div class='core-form'>"
    show-shortcuts-menu
    show-table-form-controls ${records} ${max_records} ${records_ppage} ${page_2show} list ${add_state}
    test -z "${title}" || echo "<div class='table-title'>${title}</div>"
    show-form-begin

    for ((i=0 ; i < length_single ; i++))
    do
	echo "<input type='hidden' id='${singleItemID[${i}]}' name='${singleItemID[${i}]}' value='${singleItemValue[${i}]}' />"
    done

    echo "<table id='${MAIN_TABLE_ID}' name='${MAIN_TABLE_ID}' class='highlight-list'${width}>"
    echo "<thead>"
    echo "<tr>"

    echo "<th class='table-header'></th>"
    ((n = cells_in_record)) ; ((n--))

    for ((i=1 ; i<n ; i++))
    do
	test "${itemForm[${i}]}" != "br" || break
	echo "<th class='table-header'>${itemTitle[${i}]}</th>"
    done

    if test "${itemForm[${i}]}" != "br" ; then
	echo "<th class='table-header'>${itemTitle[${i}]}</th>"
    fi

    print-select-items ${edit_columns}

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
		test $[${index} % ${record_rows} + 1]  -ne ${record_rows} || separator='list-item-separator'
		edit_delete_columns=$(print-edit-delete-blank-columns ${edit_columns})
		items="${items}${edit_delete_columns}"
		items="${items}</tr><tr class='${RECORD_CLASS_PREFIX}${record_id}'><td class='${separator}' bgcolor='${EMPTY_COLOR}'>${blankItemContent[${index}]}</td>"
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
	    items="${items}<td class='${separator}' bgcolor='${EMPTY_COLOR}'></td>"
	    ((index++))
	done

	if test -z "${listContentVisibility[${range}]}" ; then
	    case "${itemForm[${index}]}" in
		state)
		    if test ${elt} == "on" ; then
			state="checked"
		    else
			unset state
		    fi
		    items="${items}<td class='${separator}'><input id='${itemID[${index}]}_${record_id}' name='${itemID[${index}]}_${record_id}' type='checkbox' ${state} data-action='activate-post-buttons' /></td>"
		    ;;
		text)
		    items="${items}<td class='${separator}'><span class='${RECORD_CELL_CLASS}'>${item}</span></td>"
		    ;;
		*)
		    items="${items}<td class='${separator}'><input id='${itemID[${index}]}_${record_id}' name='${itemID[${index}]}_${record_id}' type='hidden' value='${item_value}' /><span class='${RECORD_CELL_CLASS}'>${item}</span></td>"
		    ;;
	    esac
	fi

	if test ${range} -ne ${step_1} ; then
	    ((index++))
	    ((i++))
	    continue
	fi

	echo "<tr class='${RECORD_CLASS_PREFIX}${record_id}'>"
	echo "<td><input id='${ENTRY_ID_PREFIX}${record_id}' name='${ENTRY_ID_PREFIX}${record_id}' type='hidden' value='old' />"

	echo "<div class='center'>"
	echo -n "<button type='button' class='${ROW_ACTION_CLASS} delete-item' data-action='delete-table-record' data-list-id='list' data-record-class='${RECORD_CLASS_PREFIX}${record_id}' data-delete-id='del_${record_id}'></button>"
	if test -n "${insert}" ; then
	    echo -n "<button type='button' class='${ROW_ACTION_CLASS} ${INSERT_IMAGE_CLASS} insert-item' data-action='insert-table-records' data-table-id='${MAIN_TABLE_ID}' data-list-id='list' data-record-class='${RECORD_CLASS_PREFIX}${record_id}' data-max-records='${max_records}'></button>"	    
	    echo -n "<button type='button' class='${ROW_ACTION_CLASS} move-item-up' data-action='move-up-table-record' data-table-id='${MAIN_TABLE_ID}' data-record-class='${RECORD_CLASS_PREFIX}${record_id}'></button>"	    
	    echo -n "<button type='button' class='${ROW_ACTION_CLASS} move-item-down' data-action='move-down-table-record' data-table-id='${MAIN_TABLE_ID}' data-record-class='${RECORD_CLASS_PREFIX}${record_id}'></button>"
	fi
	echo "</div>"
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

	    echo "<td class='${separator}' align='center'><a href=/${GUI_DIR_NAME}/${page}.${GUI_EXT_NAME}?${query}${key_variable}:${key_value}><img id='edit_${record_id}' name='edit_${record_id}' src='${IMAGE_DIR}/${icon}.png' alt='' title='${comment}' align='top' /></a></td>"
	done

	echo "<td align='center' class='${separator}'>"
	echo "<input name='del_${record_id}' id='del_${record_id}' type='checkbox' class='item-not-displayed' />"
	echo "<input class='${SELECTION_CLASS}' id='sel_${record_id}' type='checkbox' data-action='update-table-buttons' /></td>"
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

    data-init-table-form ${record_id} ${records_ppage} ${page_2show}

    show-do-apply disabled 'goto-top-window'
    show-do-reset disabled 'reset-table-changes' "[\"${MAIN_TABLE_ID}\"]"

    show-form-end
    echo "</div>"
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
    local blank_items blank_item check state
    local j page_nb record_id=0 index=1

    unset width
    local page_2show_ref=$(page-2show-ref ${DEFAULT_MULTI_LIST_RECORD_NB} "${page_ref}")
    local records_ppage=${page_2show_ref/ *}
    local page_2show=${page_2show_ref/* }
    local cells_in_record=${#itemID[@]}
    local step=$[${cells_in_record} - 1]
    local step_1=$[${step} - 1]

    local records=$(record-length-list ${cells_in_record} "${listContent}")
    local values separator

    cat << EOT
<script type='application/json' data-multi-form-records-config>
{
"title": "${itemTitle[0]}",
"records": [
EOT
    for ((i=1 ; i < cells_in_record ; i++))
    do
	test -n "${itemForm[${i}]}" || itemForm[${i}]=input
	echo "${separator}{"
	echo "\"id\": \"${itemID[${i}]}\","
	echo "\"title\": \"${itemTitle[${i}]}\","

	if test "${itemForm[${i}]:0:6}" == select ; then

	    echo "\"inputType\": \"${itemForm[${i}]:0:6}\","

	    unset values
	    test "${itemForm[${i}]}" != select:blank -o -z "${blankItemContentValues[${i}]}" || values="\"\""
	    for elt in ${blankItemContentValues[${i}]}
	    do
		values="${values},\"${elt}\""
	    done
	    test "${values:0:1}" != ',' || values=${values:1}
	    echo "\"contentValues\": [${values}],"

	    unset values
	    test "${itemForm[${i}]}" != select:blank || values="\"\""
	    for elt in ${blankItemContent[${i}]}
	    do
		values="${values},\"${elt}\""
	    done
	    test "${values:0:1}" != ',' || values=${values:1}
	    echo "\"content\": [${values}],"

	    echo "\"data\": \"${itemData[${i}]}\","

	else
	    echo "\"inputType\": \"${itemForm[${i}]}\","
	    echo "\"content\": \"${blankItemContent[${i}]}\","
	fi

	echo "\"check\": \"$(get-form-js-check-function ${checkItem[${i}]})\""

	test "${itemForm[${i}]}" != br || br=yes

	echo '}'
	separator=','
    done

    cat << EOT
]
}
</script>
EOT
    
    echo "<div class='core-form'>"
    show-shortcuts-menu
    show-table-form-controls ${records} ${max_records} ${records_ppage} ${page_2show} multi ${add_state}

    test -z "${title}" || echo "<div class='table-title'>${title}</div>"

    show-form-begin

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
	    items="${items}<tr class='${RECORD_CLASS_PREFIX}${record_id}'><td>${itemTitle[${index}]}</td><td>${item}</td></tr>"
	else
	    case "${itemForm[${index}]}" in
		textarea|encoded)
		    item=$(decode-string ${item})
		    item_value='' # To avoid being blocked by HTML injection WAF rule
		    ;;
		*)
		    ;;
	    esac

	    items="${items}<tr class='${RECORD_CLASS_PREFIX}${record_id}'><td>${itemTitle[${index}]}</td><td><input id='${itemID[${index}]}_${record_id}' name='${itemID[${index}]}_${record_id}' type='hidden' value='${item_value}' />${item}</td></tr>"
	fi

	if test ${range} -ne ${step_1} ; then
	    ((index++))
	    ((i++))
	    continue
	fi

	echo "<tr class='${RECORD_CLASS_PREFIX}${record_id} ${RECORD_FIRST_TR_CLASS}'><td><strong>${itemTitle[0]} ${record_id}</strong><input id='${ENTRY_ID_PREFIX}${record_id}' name='${ENTRY_ID_PREFIX}${record_id}' type='hidden' value='old' /></td>"
	echo "<td>"

	echo "<input name='del_${record_id}' id='del_${record_id}' type='checkbox' class='item-not-displayed' />"
	echo "<button type='button' class='${ROW_ACTION_CLASS} delete-item' data-action='delete-table-record' data-list-id='multi' data-record-class='${RECORD_CLASS_PREFIX}${record_id}' data-delete-id='del_${record_id}'></button>"
	echo "<input class='${SELECTION_CLASS}' id='sel_${record_id}' type='checkbox' data-action='update-table-buttons' />"
	echo "</td></tr>"
	echo "${items}"
	unset items
	index=1
	((record_id++))
	((i++))
    done

    echo "</tbody>"
    echo "</table>"

    data-init-table-form ${record_id} ${records_ppage} ${page_2show}

    show-do-apply disabled 'goto-top-window'
    show-do-reset disabled 'reset-table-changes' "[\"${MAIN_TABLE_ID}\"]"

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
	echo -n "<option value='nil'>&lt;Empty List&gt;</option>"
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
    echo "<input name='domainname_uri' id='domainname_uri' type='text' size='32' maxlength='$[${MAX_LEN} * 2]' value='${domainname_uri}' />"
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

    echo "<div data-init-refresh-exchange-file-percent data-filename-id='${filename_id}' data-progress-id='${progress_id}' data-progression='${progression}' data-page='/${GUI_DIR_NAME}/${refresh_page}.${GUI_EXT_NAME}' hidden></div>"
}

draw-percent-bar()
{
    test -n "${1}" || return 1
    local in_percent=${1}
    local in_attributes=${2}
    local compact=${3}

    test -z "${compact}" || compact=' compact'

    local percent attributes
    test -z "${in_attributes}" || attributes=" ${in_attributes}"

    if test ${in_percent} -le 100 ; then
	((percent = in_percent))
    else
	percent=100
    fi

    local percent_txt="<span class='meter-label'>${percent}%</span>"
    local meter="<meter min='0' max='100'${attributes} value='${percent}'></meter>"
    local bar="<div class='meter-wrap${compact}'>${meter}${percent_txt}</div>"

    echo -n ${bar}
}

draw-progress-bar()
{
    draw-percent-bar ${1}
}

draw-load-meter-bar()
{
    draw-percent-bar ${1} "low='60' high='85' optimum='0'" ${2}
}

draw-cache-meter-bar()
{
    draw-percent-bar ${1} "low='5' high='10' optimum='100'"
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

    echo "<span>"
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

get-appliance-time()
{
    date +"%H:%M:%S" 2> /dev/null
}

display-appliance-time-row()
{
    local align=${1}
    local refresh_time=$(get-appliance-time)
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

display-appliance-time-table()
{
    local compact=${1}
    test -z "${compact}" || compact=' compact'

    echo "<table class='highlight-form${compact}'>"
    display-appliance-time-row right
    echo "</table>"
}

display-appliance-time()
{
    local refresh_time=$(get-appliance-time)

    echo "<div>Appliance Refresh Time: ${refresh_time}</div>"
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
    echo "<pre id='${pre_id}' class='ssh-key'>"
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

echo-add-remove-selected-row()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local select_id1=${1}
    local select_id2=${2}
    local item_name=${3}

    local add_id="add-to-${select2_id}"
    local del_id="del-from-${select2_id}"

    echo "<td>"
    echo "<center><a href='#' id='${add_id}'><img src='/image/right-arrow.png' alt='Add Selected Filters' title='Add Selected ${item_name}' align='top' /></a></center>"

    echo "<center><a href='#' id='${del_id}'><img src='/image/left-arrow.png' alt='Remove Selected Filters' title='Remove Selected ${item_name}' align='top' /></a></center>"
    cat <<EOT
<div
data-init-bi-select-list
data-select-id1="${select_id1}"
data-select-id2="${select_id2}"
data-add-to-selected-id="${add_id}"
data-del-from-selected-id="${del_id}"
hidden>
</div>
EOT
    echo "</td>"
}

refresh-buttons()
{
    local arg_type=${1}
    local arg_value=${2}

    local page=$(get-page "${@}")
    local title='Toggle Auto Refresh'

    echo "<button id='refresh' type='submit' class='form-button' data-action='update-report' data-update-page='update-${page}' data-arg-type='${arg_type}' data-arg-value='${arg_value}'>"
    echo "REFRESH <img src='${IMAGE_DIR}/refresh.png' align='top' /></button>"

    echo "<span class='contextual-help'><input class='form-refresh-checkbox' id='${AUOTO_UPDATE_ID}' type='checkbox' checked /><label for='${AUOTO_UPDATE_ID}'></label><span class='contextual-help-text'>${title}</span></span>"

    echo "<div data-init-update-report='update-${page}' data-force='1' data-arg-type='${arg_type}' data-arg-value='${arg_value}' hidden></div>"
}
