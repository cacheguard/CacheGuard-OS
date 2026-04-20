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

source apl-js-var.apl

GUIErrors[1]="Empty password is not allowed."
GUIErrors[2]="Empty entry is not allowed."
GUIErrors[3]="Whitespace characters are not allowed."
GUIErrors[4]="Passwords do not match."
GUIErrors[5]="Please accept the license agreement."
GUIErrors[6]="Please specify a file path."
GUIErrors[7]="Empty website name is not allowed."
GUIErrors[8]="Only the 'admin' user is authorised to modify the date and time."
GUIErrors[9]="Authentication failed – please try again."
GUIErrors[10]="Timeout error – please try again or use the console interface."
GUIErrors[11]="Access denied – you are not authorised to access this system."
GUIErrors[12]="The GUI is temporarily locked – please try again later."
GUIErrors[13]="Empty SNMP community string is not allowed."
GUIErrors[14]="The requested URL was not found on this system."
GUIErrors[15]="Your request has been blocked as it was identified as a potential threat."
GUIErrors[16]="An error occurred while uploading the file."
GUIErrors[17]="Your session has expired. You will be logged out shortly."
GUIErrors[18]="Your request is invalid. You will be logged out shortly."
GUIErrors[19]="Cannot execute this command because another local or remote session is active."
GUIErrors[20]="This template or gateway cannot be deleted because it is currently in use by an administrator via the CLI or GUI."
GUIErrors[21]="Empty PSK is not allowed."
GUIErrors[22]="Please specify a destination email address."
GUIErrors[23]="Empty email address is not allowed."
GUIErrors[24]="Please specify a remote TLS identifier for certificate-based authentication."
GUIErrors[25]="Please specify a DN for DN-based identifier authentication."
GUIErrors[26]="Please specify an FQDN for FQDN-based identifier authentication."

GUIInformation[1]=""

GATEWAY_HEAD_COLOR='White'
GATEWAY_TITLE_COLOR='FireBrick'

MANAGER_HEAD_COLOR='White'
MANAGER_TITLE_COLOR='DarkGreen'

EMPTY_COLOR='WhiteSmoke'

SUBMIT_ID="submit"
RESET_ID="reset"
AUOTO_UPDATE_ID="auto-update-log"
GUI_LOGOUT_TOKEN="logout,logout,logout,logout"
BUTTON_MARGIN_TOP='3px'
BUTTON_MARGIN_BOTTOM='5px'

MULTIPART_CONTENT_TYPE_HEADER_1="Content-Type: application/octet-stream"
MULTIPART_CONTENT_TYPE_HEADER_2="Content-Type: text/plain"
MULTIPART_CONTENT_TYPE_HEADER_LEN_1=${#MULTIPART_CONTENT_TYPE_HEADER_1}
MULTIPART_CONTENT_TYPE_HEADER_LEN_2=${#MULTIPART_CONTENT_TYPE_HEADER_2}

FORM_DATA_HEADER="Content-Disposition: form-data;"
FORM_DATA_HEADER_LEN=${#FORM_DATA_HEADER}

declare -a itemID
declare -a itemState
declare -a itemWidth
declare -a itemType
declare -a itemValue
declare -a checkItem
declare -a itemTitle
declare -a itemTitleId
declare -a itemForm
declare -a itemFormSelectCB
declare -a itemFormSelectCBFunction
declare -a itemFormSelectCBArgs
declare -a itemFormCheckCB

declare -a blankItemContent
declare -a shortcutMenuItem
declare -a shortcutMenuTitle

get-command-name()
{
    local command_name=$(file-basename "${0}" ".${GUI_EXT_NAME}")
    echo ${command_name}
}

get-upper-page1()
{   
    test -n "${1}" || return 1
    local page_in=${1}
    local dir_in=${2}

    if test ${page_in:0:5} == "edit-" ; then
	echo ${page_in:5}
	return 0
    fi

    local pageboard_file=${dir_in}/etc/${GUI_PAGES_HIERARCHY_FILENAME}
    test -f ${pageboard_file} || return 3

    local query_string

    if test -n "${QUERY_STRING}" ; then
	local level_assertion=$(get-assertion-in-query level)	
	if test -n "${level_assertion}" ; then
	    local level_val=${level_assertion/*:}
	    if check-digit ${level_val} ; then
		((level_val--))
		if test ${level_val} -gt 0 ; then
		    query_string="?level:${level_val}"
		    local base_query=$(remove-assertions-in-query "level page")
		    test -z "${base_query}" || query_string="${query_string},${base_query}"
		fi
	    fi
	fi
    fi

    local upper_page page

    while read upper_page page
    do
	if test ${page} == ${page_in} ; then
	    echo ${upper_page}${query_string}
	    return 0
	fi
    done < ${pageboard_file}

    echo ${page_in}${query_string}
    return 0
}

get-upper-page()
{
    :
}

get-contextual-page()
{
    if test ${USER} == ${ADMIN_NAME} ; then
	local first_action=$(get-first-startup-action)
	if test "${first_action}" == license ; then
	    echo license
	    return 0
	fi
    fi

    if is-first-login ${USER} ; then
	echo first-login
	return 0
    fi

    if test ${USER} != ${ADMIN_NAME} ; then
	if is-admin-2fa-enabled ; then
	    if ! is-admin-2fa-is-running ${USER} ; then
		echo first-login
		return 0
	    fi
	fi
    fi

    local page=$(get-command-name)
    echo ${page}
}

get-submit-page()
{
    local query full_page
    local page=$(get-contextual-page "${@}")

    case ${page} in
	login)
	    case "${QUERY_STRING}" in
		""|"logout")
		    ;;
		*)
		    query="?${QUERY_STRING}"
		    ;;
	    esac
	    ;;
	${GUI_HOME_PAGE})
	    case "${QUERY_STRING}" in
		""|not-found|blocked)
		    ;;
		*)
		    query="?${QUERY_STRING}"
		    ;;
	    esac
	    ;;
	*)
	    test -z "${QUERY_STRING}" || query="?${QUERY_STRING}"
	    ;;
    esac

    if test ${AUTH_STATE} -eq 0 ; then

	local prefix="submit-"
	local len=${#prefix}
	
	test "${page:0:${len}}" == ${prefix} || page="${prefix}${page}"
    fi

    full_page="/${GUI_DIR_NAME}/${page}.${GUI_EXT_NAME}${query}"

    echo ${full_page}
}

get-page()
{
    local command_name=$(get-contextual-page "${@}")
    echo ${command_name/submit-}
}

get-full-page()
{
    local page=$(get-contextual-page "${@}")
    local query full_page

    test -z "${QUERY_STRING}" || query="?${QUERY_STRING}"

    full_page="/${GUI_DIR_NAME}/${page}.${GUI_EXT_NAME}${query}"
    echo ${full_page}
}

perform-set-page()
{
    check-csrf-cookie || return 1

    local page=$(get-page "${@}")
    source set-${page}
}

echo-unavailable-message()
{
    echo "<span class='unavailable-message'>&lt;${1}&gt;</span>"
}

gui-set-context()
{
    :
}

gui-context-is-edited()
{
    test ${APL_ROLE} == manager || return 11

    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local in_context=${1}
    local in_id=${2}

    ! manager-context-is-edited ${in_context} ${in_id} || return 0

    test -n "${GUI_CONTEXT}" || return 21
    local context_id=${GUI_CONTEXT}

    test ${context_id} == ${in_context}:${in_id}
}

gui-is-in-contextual-role()
{
    test ${APL_ROLE} != gateway || return 11
    test -n "${GUI_CONTEXT}"
}

gui-get-contextual-role()
{
    local role

    case ${APL_ROLE} in
	gateway)
	    role=${APL_ROLE}
	    ;;
	manager)
	    if gui-is-in-contextual-role ; then
		role=gateway
	    else
		role=${APL_ROLE}
	    fi
	    ;;
	*)
	    role=${APL_ROLE}
	    ;;
    esac

    echo ${role}
}

gui-is-in-top-level-context()
{
    local role=$(gui-get-contextual-role)
    test ${role} == ${APL_ROLE}
}

gui-get-contextual-menu-extension()
{
    local extension

    case ${APL_ROLE} in
	gateway)
	    ;;
	manager)
	    if gui-is-in-contextual-role ; then
		extension=.gateway
	    else
		extension=.${APL_ROLE}
	    fi
	    ;;
	*)
	    extension=.${APL_ROLE}
	    ;;
    esac

    echo ${extension}
}

gui-contextual-is-allowed()
{
    case ${APL_ROLE} in
	gateway)
	    return 0
	    ;;
	manager)
	    gui-is-in-contextual-role
	    ;;
	*)
	    return 11
	    ;;
    esac	
}

gui-get-contextual-network-interfaces()
{
    local interfaces

    if gui-contextual-is-allowed ; then
	interfaces="internal external auxiliary vpnipsec"
    else
	interfaces="internal"
    fi

    echo ${interfaces}
}

gui-get-contextual-users-nb()
{
    local users_nb

    case ${APL_ROLE} in
	gateway)
	    users_nb=${USERS_NB}
	    ;;
	manager)
	    local context_base=${GUI_CONTEXT/:*}

	    case ${context_base} in
		template)
		    users_nb=${MANAGER_TOTAL_USERS_NB}
		    ;;
		gateway)
		    users_nb=${USERS_NB}
		    ;;
		*)
		    users_nb=0
		    ;;
	    esac
	    ;;
	*)
	    users_nb=0
	    ;;
    esac

    echo ${users_nb}
}

gui-get-contextual-rweb-nb()
{
    local rweb_nb

    case ${APL_ROLE} in
	gateway)
	    rweb_nb=${RWEB_NB}
	    ;;
	manager)
	    local context_base=${GUI_CONTEXT/:*}

	    case ${context_base} in
		template)
		    rweb_nb=${MANAGER_TOTAL_RWEB_NB}
		    ;;
		gateway)
		    rweb_nb=${RWEB_NB}
		    ;;
		*)
		    rweb_nb=0
		    ;;
	    esac
	    ;;
	*)
	    rweb_nb=0
	    ;;
    esac

    echo ${rweb_nb}
}

call-js-function()
{
    test -n "${1}" || return 1
    local js_function="${1}"

    echo "<script type='text/javascript'>${js_function};</script>"
}

perform-js-code()
{
    echo "<script type='text/javascript'>"
    echo "${@}"
    echo "</script>"
}

get-full-menu-path()
{
    test -n "${1}" || return 1
    local page=${1}

    local path title full_path
    local i n=${#MENU_PAGE[@]}

    for ((i=0 ; i<n ; i++))
    do
	test ${MENU_PAGE[${i}]} != ${page} || break
    done

    title=${MENU_PAGE_TITLE[${i}]}
    path=${MENU_PAGE_PATH[${i}]}

    test -z "${path}" || full_path="${path}/"
    test -z "${title}" || full_path="${full_path}[${title}]"

    echo "${full_path}"
}

echo-http-header()
{
    local content_type=${1}
    test -n "${content_type}" || content_type="text/html; charset=utf-8"

    local options="path=/; HttpOnly; SameSite=Strict"

    case "${GUI_AUTH_TOKEN}" in

	${GUI_LOGOUT_TOKEN})
	    echo -e "Set-Cookie: ${GUI_COOKIE_AUTH_NAME}=; ${options};"
	    ;;
	"")
	    ;;
	*)
	    echo -e "Set-Cookie: ${GUI_COOKIE_AUTH_NAME}=${GUI_AUTH_TOKEN}; ${options}"
	    ;;
    esac

    test ${APL_ROLE} != manager || \
	echo -e "Set-Cookie: ${GUI_COOKIE_CONTEXT_NAME}=${GUI_CONTEXT}; ${options}"

    echo -e "Content-type: ${content_type}\n"
}

redirect-page()
{
    test -n "${1}" || return 1
    local page=${1}
    local args=${2}

    test -z "${args}" || args="?${args}"

    echo "<script type='text/javascript'>"
    echo "location.href = '/${GUI_DIR_NAME}/${page}.${GUI_EXT_NAME}${args}'"
    echo "</script>"
}

logout-page()
{
    echo-http-header
    redirect-page "login" "logout"
}

unset-post-data()
{
    ATTRIBUTE_NB=0
    UPLOADED_FILE_NB=0

    unset ATTRIBUTES
    unset VALUES
    unset UPLOADED_FILES
}

url-encode()
{
    test -n "${1}" || return 0
    local text=${1}

    local i c len=${#text}

    for ((i=0 ; i<len ; i++))
    do
	c="${text:${i}:1}"
	printf '%%%02X' "'$c"
    done
}

url-decode()
{
    test -n "${1}" || return 0
    local in_text=${1}

    local out_text=${in_text//+/\\x20}

    out_text=${out_text//\%25/\\x25}
    out_text=${out_text//\%/\\x}

    printf -- "${out_text}"
}

read-post-data()
{
    test ${REQUEST_METHOD} == 'POST' || return 0

    unset-post-data

    local content_type_header=${CONTENT_TYPE}
    local content_type=${content_type_header/ *}
    local line

    read line

    if test "${content_type}" == "multipart/form-data;" ; then

	local boundary_assertion=${content_type_header/* }
	local boundary="--${boundary_assertion/boundary=}"
	local boundary_len=${#boundary}

	if test "${line:0:${boundary_len}}" == "${boundary}" ; then
	    read-multipart-post-data "${line}"
	    local ret=${?}
	    test ${ret} -ne 0 || return 0
	    ATTRIBUTE_NB=0
	    UPLOADED_FILE_NB=0
	    return ${ret}
	fi
    fi

    local assertions=${line}
    local len=${#assertions} i=0
    local assertion attribute value

    assertion=${assertions/&*/}
    attribute=${assertion/=*/}

    test ${attribute} == ${GUI_CSRF_ATTRIBUTE} || return 101
    value=${assertion/*=/}
    MY_CSRF_COOKIE=$(url-decode ${value})
	
    len=${#assertion}
    ((len++))
    assertions=${assertions:${len}}
    len=${#assertions}

    while test ${len} -gt 0
    do
	assertion=${assertions/&*/}
	attribute=${assertion/=*/}
	value=${assertion/*=/}
	len=${#assertion}
	((len++))

	# Mod_security does the job
	# ! sane-input ${value} || VALUES[${i}]=$(url-decode ${value})
	# ! sane-input ${attribute} || ATTRIBUTES[${i}]=$(url-decode ${attribute})

	ATTRIBUTES[${i}]=$(url-decode ${attribute})
	VALUES[${i}]=$(url-decode ${value})

	((i++))
	
	assertions=${assertions:${len}}
	len=${#assertions}
    done
    
    unset ATTRIBUTES[${i}]
    unset VALUES[${i}]
    ATTRIBUTE_NB=${i}
}

set-global-variables()
{
    local auth

    case "${GUI_AUTH_TOKEN}" in
	"")
	    auth=$(get-auth-token)
	    ;;
	"${GUI_LOGOUT_TOKEN}")
	    ;;
	*)
	    auth=${GUI_AUTH_TOKEN}
	    ;;
    esac

    REMOTE_USER=${auth/,*/}
    USER=${REMOTE_USER}
    HOME=/home/${USER}
    unset ROOT_DIR

    TERM=${WADMIN_TERM}
    MANAGER_CONTEXT_ENV=${GUI_CONTEXT/:/ }
}

gui-is-in-template-context()
{
    test -n "${1}" || return 1
    local role=${1}

    local state

    case ${role} in
	gateway)
	    if gui-is-in-contextual-role ; then
		local context_base=${GUI_CONTEXT/:*}
		test "${context_base}" == template || state=no
	    else
		state=no
	    fi
	    ;;
	manager)
	    state=no
	    ;;
	*)
	    ;;
    esac

    test -z "${state}"
}

gui-init-env()
{
    test -n "${1}" || return 1
    local page=${1}
    local context=${2}

    gui-set-context ${page} ${context}
    set-global-variables

    if test -z "${GUI_CONTEXT}" ; then
	init-env
    else
	local context_base=${GUI_CONTEXT/:*}
	local context_leaf=${GUI_CONTEXT/*:}

	init-env ${context_base} ${context_leaf}
    fi

    local extension=$(gui-get-contextual-menu-extension)

    source ${GUI_DIR}/etc/menu${extension}.env
    source ${HARD_DIR}/model.conf
    source ${HARD_DIR}/cloud.conf
}

gui-init-env-variables()
{
    gui-set-context
    set-global-variables

    if test -z "${GUI_CONTEXT}" ; then
	init-env-variables 
    else
	local context_base=${GUI_CONTEXT/:*}
	local context_leaf=${GUI_CONTEXT/*:}

	init-env-variables ${context_base} ${context_leaf}
    fi
}

submit-core()
{
    test -n "${1}" || return 1
    local page=${1}
    shift

    try-authenticate
    verify-authentication
    AUTH_STATE=${?}
    test ${AUTH_STATE} -eq 0 || return 11

    gui-init-env ${page} "${@}"
    INITENV_STATUS=${?}

    if test ${INITENV_STATUS} -eq 0 ; then
	read-post-data
	perform-method-post || return 13
    else
	gen-gui-error 12
        show-title-errors
	return 0
    fi

    echo-http-header

    if test ${REQUEST_METHOD} == 'POST' ; then
	gui-init-env ${page} "${@}"
	INITENV_STATUS=${?}

	if test ${INITENV_STATUS} -eq 0 ; then
	    source ${page}${GUI_CORE_EXT}
	else
	    gen-gui-error 12
            show-title-errors
	    return 0
	fi
    else
	source ${page}${GUI_CORE_EXT}
    fi

    return 0
}

manage-submit-core()
{
    local page=$(get-page "${@}")

    AUTH_STATE=0
    INITENV_STATUS=0

    submit-core "${page}" "${@}" || logout-page
}

process-main-action()
{
    test -n "${1}" || return 0
    local action=${1}

    case "${action}" in
        not-found)
            gen-gui-error 14
            ;;
        blocked)
            gen-gui-error 15
            ;;
	"logout")
	    ;;
        *)
            ;;
    esac
}

echo-body-top()
{
    test -n "${1}" || return 1
    local id=${1}
    local style=${2}

    test -z "${style}" || style=" style='${style}'"

    echo "<body id='${id}'${style}>"
    echo "<a name='top' href='#'></a>"
}

gen-body-bottom()
{
    echo "<a name='bottom' href='#'></a>"
    echo "</body>"
}

gen-bottom-html()
{
    echo "</html>"
}

no-html-format()
{
    test -n "${1}" || return 0
    local nohtml=${1}

    nohtml=${nohtml//</&lt;}
    nohtml=${nohtml//>/&gt;}

    echo ${nohtml}
}

gen-gui-error()
{
    test -n "${1}" || return 1
    local error=${1}
    local error_msg=${GUIErrors[${error}]}

    ((error += 1000))
    echo "${ERROR_TAG} Error ${error} - ${error_msg}" >> ${LOG}
}

gen-gui-info()
{
    test -n "${1}" || return 1
    local info=${1}
    local info_msg=${GUIInformation[${info}]}

    ((info += 1000))
    echo "${INFO_TAG} Information ${info} - ${info_msg}" >> ${LOG}
}

log-command()
{
    test -n "${1}" || return 1
    local cmd=${1}
    local args=${2}

    if test -n "${args}" ; then
	echo "${COMMAND_TAG} <a href='/doc/command/${cmd}.html' target='_blank'>${cmd}</a> ${args}" >> ${LOG}
    else
	echo "${COMMAND_TAG} <a href='/doc/command/${cmd}.html' target='_blank'>${cmd}</a>" >> ${LOG}
    fi
}

refresh-buttons()
{
    test -n "${1}" || return 0
    local refresh_js_func=${1}
    local refresh_css=${2}

    local title='Toggle Auto Refresh'
    local check_sz='24px'

    echo "<span style='float:left; margin:0; margin-top:${BUTTON_MARGIN_TOP}; margin-bottom:${BUTTON_MARGIN_BOTTOM};'>"

    echo "<button id='refresh' type='submit' class='submit' style='${refresh_css}' onClick='${refresh_js_func};'>"
    echo "REFRESH <img src='${IMAGE_DIR}/refresh.png' align='top' /></button>"

    echo "<span class='submit tooltip' style='width:${check_sz};height:${check_sz}'><input class='dashboard-refresh-checkbox' id='${AUOTO_UPDATE_ID}' type='checkbox' checked /><label for='${AUOTO_UPDATE_ID}'></label><span class='tooltip-text'>${title}</span></span>"

    echo "</span>"

    call-js-function "${refresh_js_func}"
}

get-assertion-in-query()
{
    test -n "${1}" || return 1
    local var=${1}

    local assertion
    local query_string=${QUERY_STRING//,/ }

    for assertion in ${query_string}
    do
	if test ${assertion/:*} == ${var} ; then
	    echo ${assertion}
	    return 0
	fi
    done

    return 11
}

remove-assertions-in-query()
{
    test -n "${1}" || return 1
    local vars=${1}

    local assertion assertions
    local query_string=${QUERY_STRING//,/ }

    for assertion in ${query_string}
    do
	member "${vars}" ${assertion/:*} || assertions="${assertions},${assertion}"
    done

    echo ${assertions:1}
}

show-shortcut-menu()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local page=${1}
    local title=${2}
    local args=${3}
    local icon=${4}

    test -z "${args}" || args="?${args}"
    local href="/${GUI_DIR_NAME}/${page}.${GUI_EXT_NAME}${args}"

    if test -n "${icon}" ; then
	echo "<span style='padding:5px;'><a href='${href}'><img src='${IMAGE_DIR}/${icon}.png' title='${title}' alt='' /></a></span>"
    else
	echo "<span class='shortcut-menu-item'><a href='${href}'>${title}</a></span>"
    fi
}

show-title-iconbar-custom()
{
    :
}

reset-gui-error-log()
{
    rm -f ${LOG}
}

is-messages-in-log()
{
    test -f ${LOG} || return 1

    local flag message

    while read flag message
    do
	test -n "${flag}" || continue
	test "${flag}" != "${ERROR_TAG}" || break
	test "${flag}" != "${WARNING_TAG}" || break
	test "${flag}" != "${INFO_TAG}" || break
    done < ${LOG}
    
    test "${flag}" == "${ERROR_TAG}" -o "${flag}" == "${WARNING_TAG}" -o "${flag}" == "${INFO_TAG}"
}

show-errors()
{
    call-js-function "showZone( 'top-errors' )"
}

show-post-errors()
{
    test "${REQUEST_METHOD}" == POST || return 0
    show-errors
}

show-hide-errors()
{
    is-messages-in-log || return 0
    show-errors
}

error-occured()
{
    local flag message
    local error_flag

    while read flag message
    do
	test -n "${flag}" || continue
	case ${flag} in
	    "${ERROR_TAG}")
		error_flag=yes
		break
		;;
	    "${COMMAND_TAG}")
	        ;;
	    "${WARNING_TAG}")
		;;
	    *)
		;;
	esac
    done < ${LOG}

    test -n "${error_flag}"
}

display-errors-content()
{
    if test ! -s ${LOG} ; then
	#echo "&lt;<i>There is no operation report</i>&gt;"
	return 0
    fi

    local flag message
    local error_flag warning_flag

    while read flag message
    do
	test -n "${flag}" || continue
	case ${flag} in
	    "${COMMAND_TAG}")
		echo "<div><img src='${IMAGE_DIR}/information.png' class='error-icon' align='top' />${message}</div>"
		;;
	    "${ERROR_TAG}")
		error_flag=yes
		echo "<div><img src='${IMAGE_DIR}/forbidden.png' class='error-icon' align='top' /><font color='FireBrick'><i>${message}</i></font></div>"
		;;
	    "${WARNING_TAG}")
		warning_flag=yes
		echo "<div><img src='${IMAGE_DIR}/warning.png' class='error-icon' align='top' /><font color='DarkOrange'><i>${message}</i></font></div>"
		;;
	    "${INFO_TAG}")
		echo "<div><img src='${IMAGE_DIR}/ok.png' class='error-icon' align='top' /><i>${message}</i></div>"
		;;

	    *)
		echo "<div><img src='${IMAGE_DIR}/warning.png' class='error-icon' align='top' /><font color='DarkOrange'><i>Internal: ${message}</i></font></div>"
		;;
	esac
    done < ${LOG}

    if test -n "${error_flag}" ; then
	echo "<div><img src='${IMAGE_DIR}/forbidden.png' class='error-icon' align='top' />Faulty operation(s)</div>"
    elif test -n "${warning_flag}" ; then
	echo "<div><img src='${IMAGE_DIR}/warning.png' class='error-icon' align='top' />Warning(s) detected</div>"
    else
	echo "<div><img src='${IMAGE_DIR}/ok.png' class='error-icon' align='top' />Successful operation(s)</div>"
    fi
}

display-title-errors()
{
    echo "<div id='top-errors' class='box-errors-outer'>"
    echo "<div class='box-errors-inner'>"

    echo "<div><a href=\"javascript:hideZone( 'top-errors' )\"><img src='${IMAGE_DIR}/delete.png' alt='' title='Close' style='float:right; width:10px; height:10px; margin:0; margin-right:10px; margin-top:5px;' /></a></div>"

    echo "<div style='padding:10px; margin:0;'>"
    echo "<div style='float:left; margin:0; margin-bottom:5px; font-size:120%; text-align:left; font-weight:bold;'>Last operation report</div>"
    echo "<div style='clear:left; margin:0; padding:0; height:0;'></div>"

    display-errors-content

    echo "</div>"
    echo "</div>"
    echo "</div>"
    echo "<div style='clear:left; margin:0; padding:0; height:0;'></div>"
}

show-title-errors()
{
    display-title-errors
    show-hide-errors
    reset-gui-error-log
}

show-title-check-usage()
{
    :
}

echo-quick-help()
{
    test -n "${1}" || return 1
    local page=${1}

    cat ${ETC_HTML_DIR}/${page}-help.html
}

show-title-help()
{
    test -n "${1}" || return 1
    local content=${1}
    local commands=${2}

    local path query

    path=$(get-full-menu-path ${content})
    echo "<div class='box-help-outer' id='top-help'>"
    echo "<div class='box-help-inner'>"

    if test -n "${path}" ; then

	test -z "${QUERY_STRING}" || query="?${QUERY_STRING}"
	path=${path//\// <strong>></strong> }

	echo "<div id='reload-page-iconbar' style='font-size:120%; font-style:normal;'><a href='/${GUI_DIR_NAME}/${content}.${GUI_EXT_NAME}${query}'><img align='middle' src='${IMAGE_DIR}/${content}.png' alt='Reload Page' title='Reload Page' /></a><span style='margin:0; margin-left:10px;'>${path}</span></div><br />"
    fi

    echo-quick-help ${content}

    if test -n "${commands}" ; then
	if test "${commands/ }" == "${commands}" ; then
	    echo " The related command to this page is: [ <a href=${DOC_COMMAND_DIR}/${commands}.html target=_blank>${commands}</a> ]"
	else
	    local command
	    echo -n " Related commands to this page are: ["
	    for command in ${commands}
	    do
		echo -n " <a href=/doc/command/${command}.html target=_blank>${command}</a>"
	    done
	    echo " ]"
	fi
    fi
    echo "</div>"
    echo "</div>"
    echo "<div style='clear:left; margin:0; padding:0; height:0;'></div>"
}

show-title-iconbar-left-menu-arrow()
{
    test ${AUTH_STATE} -eq 0 || return 0    
    echo "<div class='left-menu-arrow' id='left-menu-arrow' title='Show/Hide Left Menu'></div>"
    set-left-menu-arrow
}

show-title-iconbar-text()
{
    test -n "${1}" || return 1
    local title=${1}

    echo "<span class='title-text'>${title}</span>"    
}

show-title-iconbar-global()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local page=${1}
    local content=${2}
    
    if test ${AUTH_STATE} -eq 0 ; then
	local upper_page=$(get-upper-page "${page}.${GUI_EXT_NAME}")
	echo "<span id='${GUI_HOME_PAGE}-iconbar'><a class='iconbar-item' href='/${GUI_DIR_NAME}/${GUI_HOME_PAGE}.${GUI_EXT_NAME}'><img src='${IMAGE_DIR}/${GUI_HOME_PAGE}-reflect.png' alt='Panel Board' title='Panel Board' /></a></span>"
	if test -n "${upper_page}" ; then
	    test "${upper_page}" == "${GUI_HOME_PAGE}.${GUI_EXT_NAME}" || \
		echo "<span id='up-iconbar'><a class='iconbar-item' href='/${GUI_DIR_NAME}/${upper_page}'><img src='${IMAGE_DIR}/arrow-level-up-reflect.png' alt='Upper Level' title='Upper Level' /></a></span>"
	fi
    fi
}

show-title-manager-context()
{
    :
}

show-title-working()
{
    echo "<div class='working' id='working'></div>"
}

show-title-iconbar-submit()
{
    test -n "${1}" || return 1
    local page=${1}
    local submit_state=${2}
    local get_state=${3}
    local get_checkbox_id=${4}

    local submit_label

    case ${page} in
	apply|cancel)
	    submit_label='Confirm'
	    ;;
	*)
	    submit_label='Submit'
	    ;;
    esac

    if test -z "${get_checkbox_id}" ; then
	get_checkbox_id='null'
    else
	get_checkbox_id="'${get_checkbox_id}'"
    fi

    local display=none page
    local submit_page

    test "${submit_state}" == disabled || display=inline

    if test ${AUTH_STATE} -eq 0 ; then
	case ${page} in
	    ${GUI_HOME_PAGE})
		;;
	    *)
		case ${page} in
		    login)
			submit_page=$(get-submit-page system-report)
			;;
		    *)
			submit_page=$(get-submit-page)
			;;
		esac

		local reload_id="reload-content"
		local iconbar_id="reload-iconbar"

		show-title-working

		if test "${get_state}" != disabled ; then
		    echo "<span id='${iconbar_id}'><a id='${reload_id}' class='iconbar-item' href='javascript:void( 0 );'><img src='${IMAGE_DIR}/refresh-reflect.png' alt='Reload Content' title='Reload Content' /></a></span>"
		    call-js-function "initGetContent( '${reload_id}', '${submit_page}', ${get_checkbox_id} )"
		fi
	esac
    fi

    echo "<span id='ok-iconbar' style='display:${display};'><a class='iconbar-item' href='javascript:void( 0 );' onClick='javascript:doClickButton( \"${SUBMIT_ID}\" );'><img src='${IMAGE_DIR}/ok-reflect.png' alt='${submit_label}' title='${submit_label}' /></a></span>"
    echo "<span id='report-iconbar'><a class='iconbar-item' href=\"javascript:toggleZone( 'top-errors' )\"><img src='${IMAGE_DIR}/report-reflect.png' alt='Operation Report' title='Operation Report' /></a></span>"
    echo "<span id='help-iconbar'><a class='iconbar-item' href=\"javascript:toggleZone( 'top-help' )\"><img src='${IMAGE_DIR}/help-reflect.png' alt='Quick Help' title='Quick Help' /></a></span>"
}

show-title()
{
    test -n "${1}" || return 1
    local title=${1}
    local submit_state=${2}
    local commands=${3}
    local controls=${4}
    local get_state=${5}
    local get_checkbox_id=${6}

    local page=$(get-page) content

    case "${page}" in
	login)
	    if test ${AUTH_STATE} -eq 0 ; then
		content=${GUI_HOME_PAGE}
	    else
		content=login
	    fi
	    ;;
	*)
	    if test ${AUTH_STATE} -eq 0 ; then
		content=${page}
	    else
		content=login
	    fi
	    ;;
    esac

    echo "<div class='title-bar'>"
    show-title-iconbar-left-menu-arrow
    show-title-iconbar-text "${title}"
    show-title-iconbar-submit ${page} ${submit_state} ${get_state} ${get_checkbox_id}
    show-title-iconbar-custom ${controls}
    show-title-iconbar-global ${page} ${content}
    show-title-manager-context
    echo "</div>"

    show-title-help ${content} "${commands}"
    show-title-errors
}

show-title-login()
{
    :
}

display-user()
{
    local hostname domainname

    case ${APL_ROLE} in
	gateway)
	    hostname=${CURRENT_SHOSTNAME}
	    domainname=${CURRENT_DOMAIN_NAME}
	    ;;
	manager)
	    local level=${1}
	    if test -n "${level}" ; then
		if gui-is-in-contextual-role ; then
		    hostname=$(get-variable-value-from-file ${ROOT_DIR}${ADMIN_DIR}/${ENV_RDIR}/${ENV_CURRENT_NAME} CURRENT_SHOSTNAME)
		    domainname=$(get-variable-value-from-file ${ROOT_DIR}${ADMIN_DIR}/${ENV_RDIR}/${ENV_CURRENT_NAME} CURRENT_DOMAIN_NAME)
		else
		    hostname=${CURRENT_SHOSTNAME}
		    domainname=${CURRENT_DOMAIN_NAME}
		fi
	    else
		hostname=${CURRENT_SHOSTNAME}
		domainname=${CURRENT_DOMAIN_NAME}
	    fi
	    ;;
	*)
	    hard_dir=${HARD_DIR}
	    ;;
    esac

    echo "[ ${REMOTE_USER}@${hostname}.${domainname} ]"
}

display-os-version()
{
    local new_version full_version=$(get-system-soft)

    new_version=$(get-os-new-version)

    if test ${?} -ne 0 ; then
	echo "<strong>${full_version}</strong> "
	return ${?}
    fi

    local cur_version=$(get-os-cur-version)
    if test "${cur_version}" == "${new_version}" ; then
	echo "<strong>${full_version}</strong> "
	return 0
    fi

    local link=/${GUI_DIR_NAME}/system-patch.${GUI_EXT_NAME}
    local title="New Version Available - Upgrade"

    echo "<a href='${link}'>${full_version} <img width='18' align='top' src='${IMAGE_DIR}/upgrade.gif' title='${title}' alt='${title}' /></a>"
}

display-os-version-user()
{
    display-os-version
    display-user top
}

display-right-header-info()
{
    echo "<div style='float:right; background-color:transparent;'>"
    display-os-version-user
    echo "</div>"
}

display-remote-ip()
{
    local ip=${REMOTE_ADDR}
    test -n "${ip}" || ip="<i>None</i>"

    echo "<span style='float:left; background-color:transparent;'>Your IP: [${REMOTE_ADDR}]</span>"
}

display-check-new-version()
{
    :
}

display-left-header-info()
{
    display-remote-ip
}

check-user-password-file()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local htpasswd_file=${1}
    local user=${2}
    local passwd=${3}

    test -f ${htpasswd_file} || return 11
    htpasswd -vb ${htpasswd_file} ${user} "${passwd}" > /dev/null 2>&1
}

check-user-password()
{
    :
}

gui-user-exist-file()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local htpasswd_file=${1}
    local in_user=${2}

    test -f ${htpasswd_file} || return 11
    local line user

    while read line
    do
	test -n "${line}" || continue
	user=${line/:*}
	test ${user} != ${in_user} || return 0
    done < ${htpasswd_file}

    return 13
}

gui-user-exist()
{
    :
}

hmac()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 1
    test -n "${3}" || return 1
    local user=${1}
    local time=${2}
    local rand=${3}

    local appliance_key=$(cat ${GUI_AUTHENTICATION_KEY_FILE} 2> /dev/null)
    test -n "${appliance_key}" || appliance_key='y18PMnKA1KAEr#f4xVaL6vnk0cOcrTSw'

    local hmac=$(echo -n "${user},${time}" | openssl dgst -sha1 -hmac ${appliance_key} 2> /dev/null)
    hmac=$(remove-dgst-prefix "${hmac}")
    hmac=$(echo -n "${user},${time},${rand}" | openssl dgst -sha1 -hmac ${hmac} 2> /dev/null)
    hmac=$(remove-dgst-prefix "${hmac}")
    echo ${hmac}
}

set-auth-token()
{
    test -n "${1}" || return 1
    local user=${1}

    local date=$(date +"%s" 2> /dev/null)
#   ((date+=7200060)) # Should be greater than the javascript logout timeout
    local rand=$(random-phrase-base62)
    local hmac=$(hmac "${user}" "${date}" "${rand}")

    GUI_AUTH_TOKEN="${user},${date},${rand},${hmac}"
}

reset-auth-token()
{
    GUI_AUTH_TOKEN=${GUI_LOGOUT_TOKEN}
}

get-auth-token()
{
    local auth

    case "${GUI_AUTH_TOKEN}" in
	"")
	    local cookie=${HTTP_COOKIE/*${GUI_COOKIE_AUTH_NAME}=/}
	    test "${cookie}" != "${HTTP_COOKIE}" || return 1
	    auth=${cookie/;*}
	    ;;
	${GUI_LOGOUT_TOKEN})
	    ;;
	*)
	    auth=${GUI_AUTH_TOKEN}
	    ;;
    esac
    
    echo ${auth}
}

is-authenticated()
{
    local auth

    case "${GUI_AUTH_TOKEN}" in
	"")
	    auth=$(get-auth-token)
	    ;;
	"${GUI_LOGOUT_TOKEN}")
	    ;;
	*)
	    auth=${GUI_AUTH_TOKEN}
	    ;;
    esac

    test -n "${auth}" || return 11
    
    local user=${auth/,*/}
    test -n "${user}" || return 13
    gui-user-exist ${user} || return 15

    auth=${auth/${user},/}
    local date=${auth/,*/}
    auth=${auth/${date},/}
    
    check-digit ${date} || return 17

    local rand=${auth/,*/}
    auth=${auth/*,/}

    local auth_hmac=${auth}
    local hmac=$(hmac "${user}" "${date}" "${rand}")

    test "${hmac}" == "${auth_hmac}" || return 19
}

verify-authentication()
{
    is-authenticated
    local ret=${?}

    test ${ret} -ne 0 || return 0
    reset-auth-token
    return ${ret}
}

http-exit()
{
    echo -e "Content-type: text/html\n\n"
    exit ${1}
}

check-cgi-security()
{
    test -n "${REQUEST_METHOD}"	|| exit 1
    test -n "${REMOTE_ADDR}"	|| exit 2
    test -n "${SCRIPT_NAME}"	|| exit 3
    test -n "${SERVER_PORT}"	|| exit 4
    test -n "${HTTP_HOST}"	|| exit 5
    test -n "${SERVER_ADMIN}"	|| exit 6
    
    case ${REQUEST_METHOD} in
	PUT|PATCH|DELETE)
	    exit 10
	    ;;
	HEAD|OPTIONS|GET|POST)
	    ;;
	*)
	    exit 11
	    ;;
    esac
}

sane-input()
{
    test -n "${1}" || return 0
    local value=${1}

    [[ "${value}" =~ ^[[:print:]]*$ ]] || return 1
    ! [[ "${value}" =~ ^.*\</?script\>.*$  ]] || return 1

    return 0
}

remove-cr()
{
    test -n "${1}" || return 0
    local value=${1}

    local len=${#value}
    ((len--))
    value=${value:0:${len}}

    echo ${value}
}

get-unquoted()
{
    test -n "${1}" || return 0
    local value=${1}

    local len=${#value}
    ((len--))
    test ${value:${len}:1} != $'\r' || ((len--))
    ((len--))
    value=${value:1:${len}}

    echo ${value}
}

read-multipart-post-data()
{
    test -n "${1}" || return 1
    local boundary=${1}

    local assertions assertion
    local attribute quoted_attribute
    local value src_filename dst_filename
    local line len

    read line || return 11

    test "${line:0:${FORM_DATA_HEADER_LEN}}" == "${FORM_DATA_HEADER}" || return 13

    assertion=${line:${FORM_DATA_HEADER_LEN}}
    quoted_attribute=${assertion/ name=}
    attribute=$(get-unquoted "${quoted_attribute}")

    test "${attribute}" == ${GUI_CSRF_ATTRIBUTE} || return 15
    read line || return 17
    test "${line}" == $'\r' || return 19
    read value || return 21
    read line || return 23
    test "${line}" == "${boundary}" || return 25

    value=$(remove-cr "${value}")
    MY_CSRF_COOKIE=$(url-decode ${value})

    local i=0 j=0
    local eof=$(remove-cr "${boundary}")
    eof=$(echo -e "${eof}--\r")


    while read line
    do
	test "${line}" != "${eof}" || break
	test "${line}" != "${boundary}" || continue
	test "${line:0:${FORM_DATA_HEADER_LEN}}" == "${FORM_DATA_HEADER}" || return 31

	assertions=${line:${FORM_DATA_HEADER_LEN}}
        assertion=${assertions/; *}
	quoted_attribute=${assertion/ name=}
	attribute=$(get-unquoted "${quoted_attribute}")

    	ATTRIBUTES[${i}]=$(url-decode ${attribute})

	len=${#assertion}
	assertions=${assertions:${len}}

	if test -z "${assertions}" ; then
	    read line || return 41
	    test "${line}" == $'\r' || return 43
	    read value || return 45

	    value=$(remove-cr "${value}")
	    VALUES[${i}]=$(url-decode ${value})
	    ((i++))
	else
	    if test "${assertions:0:11}" == "; filename=" ; then
		value=${assertions:11}
		value=$(get-unquoted "${value}")
		
		src_filename=$(url-decode ${value})
		dst_filename="uploaded.${j}.${$}"

		VALUES[${i}]=${src_filename}

		read line || return 51
		test \
		    "${line:0:${MULTIPART_CONTENT_TYPE_HEADER_LEN_1}}" == "${MULTIPART_CONTENT_TYPE_HEADER_1}" -o \
		    "${line:0:${MULTIPART_CONTENT_TYPE_HEADER_LEN_2}}" == "${MULTIPART_CONTENT_TYPE_HEADER_2}" || return 53
		read line || return 55
		test "${line}" == $'\r' || return 57

		while read line
		do
		    if test "${line}" == $'\r' ; then

			read line #### May return 1 if it's the last line
			test "${line}" != "${eof}" || break
			test "${line}" != "${boundary}" || break
			echo
			echo ${line}
		    else
			echo ${line}
		    fi
		done > /tmp/${dst_filename}

                test "${line}" == "${eof}" -o "${line}" == "${boundary}" || return 61

		UPLOADED_FILES[${j}]=${dst_filename}
		((j++))
		((i++))
	    fi
	fi
    done

    unset ATTRIBUTES[${i}]
    unset VALUES[${i}]
    unset UPLOADED_FILES[${j}]

    ATTRIBUTE_NB=${i}
    UPLOADED_FILE_NB=${j}
}

check-csrf-cookie()
{
    local cookie=$(get-auth-token)

    test "${cookie}" != "${MY_CSRF_COOKIE}" || return 0
    reset-auth-token

    return 1
}

is-authentication-post()
{
    test "${ATTRIBUTES[0]}" == authentication || return 11
    test \
	"${ATTRIBUTES[1]}" == user -a \
	"${ATTRIBUTES[2]}" == password || return 13
    test \
	"${VALUES[0]}" == login -o \
	"${VALUES[0]}" == basic -o \
	"${VALUES[0]}" == 2fa || return 15
}

try-authenticate()
{
    test ${REQUEST_METHOD} == 'POST' || return 0
    ! is-authentication-post || source set-login
    return 0
}

perform-method-post()
{
    test ${REQUEST_METHOD} == 'POST' || return 0
    ! is-authentication-post || return 0
    perform-set-page
}

require-confirmation()
{
    return 1
}

set-left-menu-visibility()
{
    echo "<script type='text/javascript'>"
    echo "var status = getCookieValue( '${GUI_COOKIE_LEFT_MENU_NAME}${GUI_MODULE_NAME}' );"
    echo "showHideLeftMenu( 'left-menu', status );"
    echo "</script>"
}

set-left-menu-arrow()
{
    echo "<script type='text/javascript'>"
    echo "var status = getCookieValue( '${GUI_COOKIE_LEFT_MENU_NAME}${GUI_MODULE_NAME}' );"
    echo "setLeftMenuArrow( 'left-menu-arrow', status );"
    echo "</script>"
}

show-left-menu()
{
    local extension=$(gui-get-contextual-menu-extension)

    echo "<div class='show-hide' id='left-menu'>"
    echo "<div class='arrowlistmenu' id='left-menu-core'>"
    cat ${ETC_HTML_DIR}/left-menu${extension}.html
    echo "</div>"
    echo "</div>"

    set-left-menu-visibility
}

set-top-menu-visibility()
{
    echo "<script type='text/javascript'>"
    echo "var status = getCookieValue( '${GUI_COOKIE_TOP_MENU_NAME}${GUI_MODULE_NAME}' );"
    echo "showHideTopMenu( 'top-menu', 'top-menu-arrow', status );"
    echo "</script>"
}

show-top-menu()
{
    local extension=$(gui-get-contextual-menu-extension)

    echo "<div id='top-menu' class='ddsmoothmenu'>"
    cat ${ETC_HTML_DIR}/top-menu${extension}.html
    echo "<br style='clear:left; margin:0; padding:0; height:0;' /></div>"

    set-top-menu-visibility
}

show-scroll-top()
{
    echo "<script type='text/javascript' src='/js/scrolltopcontrol.js'></script>"
}

show-form-begin()
{
    test -n "${1}" || return 1
    local length=${1}

    local page=$(get-submit-page)
    local cookie=$(get-auth-token)
    local on_submit

    if test ${AUTH_STATE} -eq 0 ; then
	on_submit="onSubmit='javascript:return( false );'"
    else
	on_submit="onSubmit=''"
    fi

    echo "<form name='mainform' id='mainform' method='post' ${on_submit} action='${page}'>"
    echo "<input type='hidden' name='${GUI_CSRF_ATTRIBUTE}' value='${cookie}' />"
}

show-form-end()
{
    show-scroll-top
    echo "</form>"
}

show-table-begin()
{
    test -n "${1}" || return 1
    local length=${1}
    local width=${2}

    test ${length} -gt 0 || return 0
    test -z "${width}" || width=" width='${width}'"

    echo "<table class='highlight-form'${width}>"
    echo "<thead></thead>"
    echo "<tbody>"

}

show-table-end()
{
    test -n "${1}" || return 1
    local length=${1}

    test ${length} -gt 0 || return 0

    echo "</tbody>"
    echo "</table>"
}

show-do-apply()
{
    test -n "${1}" || return 1
    local state=${1}
    local on_submit=${2}

    local label page=$(get-page)

    case ${page} in
	apply|cancel)
	    label='CONFIRM'
	    ;;
	*)
	    label='SUBMIT'
	    ;;
    esac

    case ${state} in
	enabled)
	    unset state
	    ;;
	disabled)
	    state=" ${state}"
	    ;;
	hidden)
	    return 0
	    ;;
	*)
	    ;;
    esac

    local button_type='button'

    test ${AUTH_STATE} -eq 0 || button_type='submit'
    test -z "${on_submit}" || on_submit="onClick=\"${on_submit};\""

    echo -n "<button id='${SUBMIT_ID}' type='${button_type}' class='submit' ${on_submit}${state}>"
    echo -n "${label} <img src='${IMAGE_DIR}/ok.png' align='top' />"
    echo    "</button>"

    local command_name=$(get-command-name)

    if require-confirmation ${command_name} ; then
	local ask=true
    else
	local ask=false
    fi

    test ${AUTH_STATE} -ne 0 || call-js-function "initPostContent( '${SUBMIT_ID}', 'mainform', ${ask} )"
}

show-do-reset()
{
    test -n "${1}" || return 1
    local state=${1}
    local on_reset=${2}

    case ${state} in
	enabled)
	    unset state
	    ;;
	disabled)
	    state=" ${state}"
	    ;;
	hidden)
	    return 0
	    ;;
	*)
	    ;;
    esac
	
    test -z "${on_reset}" || on_reset="onClick=\"${on_reset};\""

    echo -n "<button id='${RESET_ID}' type='reset' class='submit'${state} ${on_reset}>"
    echo -n "RESET <img src='${IMAGE_DIR}/undo.png' align='top' />"
    echo    "</button>"
}

show-do()
{
    local submit_state=${1}
    local reset_state=${2}
    local on_submit=${3}
    local on_reset=${4}
    test -n "${submit_state}" || submit_state="enabled"
    test -n "${reset_state}" || reset_state="enabled"

    echo "<div style='float:left; margin:0; margin-top:${BUTTON_MARGIN_TOP}; margin-bottom:${BUTTON_MARGIN_BOTTOM};'>"

    show-do-apply ${submit_state} "${on_submit}"
    show-do-reset ${reset_state} "${on_reset}"

    echo "<div style='clear:left; margin:0; padding:0; height:0;'></div>"
    echo "</div>"
}

show-form()
{
    local width=${1}
    local submit_state=${2}
    local after_function=${3}
    shift 3 ; local after_function_args="${@}"

    local submit_state reset_state item_state item_title item_title_id
    local check jsfunction
    local first_tab=yes

    case "${submit_state}" in
	enabled)
	    ;;
	"")
	    submit_state=enabled
	    ;;
	*)
	    submit_state=disabled
	    ;;
    esac

    local length=${#itemID[@]} i

    if test ${length} -eq 0 ; then
	reset_state=hidden
    else
	reset_state=enabled
    fi

    echo "<div class='core-form'>"
    show-form-begin ${length}

    for ((i=0 ; i<length ; i++))
    do
	test "${itemForm[${i}]}" == "hidden" || continue
	echo "<input type='hidden' id='${itemID[${i}]}' name='${itemID[${i}]}' ${blankItemContent[${i}]} />"	
    done

    test "${itemForm[0]}" == tab || show-table-begin ${length} ${width}

    for ((i=0 ; i<length ; i++))
    do
	item_state=${itemState[${i}]}
	test -z "${item_state}" || item_state=" ${item_state}"

	case "${checkItem[${i}]}" in
	    aalphanum)
		check="checkAAlphanum( \"${itemID[${i}]}\" );"
		;;
	    alphanum)
		check="checkAlphanum( \"${itemID[${i}]}\" );"
		;;
	    digit)
		check="checkDigit( \"${itemID[${i}]}\" );"
		;;
	    percent)
		check="checkPercent( \"${itemID[${i}]}\" );"
		;;
	    weight)
		check="checkWeight( \"${itemID[${i}]}\" );"
		;;
	    ip)
		check="checkIP( \"${itemID[${i}]}\" );"
		;;
	    iplist)
		check="checkIPList( \"${itemID[${i}]}\" );"
		;;
	    ikeidentifier)
		check="checkIKEIdentifier( \"${itemID[${i}]}\" );"
		;;
	    port)
		check="checkPort( \"${itemID[${i}]}\" );"
		;;
	    printable)
		check="checkPrintable( \"${itemID[${i}]}\" );"
		;;
	    hostname)
		check="checkHostname( \"${itemID[${i}]}\" );"
		;;
	    domainname)
		check="checkDomainname( \"${itemID[${i}]}\" );"
		;;
	    username)
		check="checkUsername( \"${itemID[${i}]}\" );"
		;;
	    email)
		check="checkEmail( \"${itemID[${i}]}\" );"
		;;
	    dn)
		check="checkDN( \"${itemID[${i}]}\" );"
		;;
	    fqdnlist)
		check="checkFQDNList( \"${itemID[${i}]}\" );"
		;;
	    ipdomainname)
		check="checkIPDomainname( \"${itemID[${i}]}\" );"
		;;
	    text)
		check="checkText( \"${itemID[${i}]}\" );"
		;;
	    qos)
		check="checkQoS( \"${itemID[${i}]}\" );"
		;;
	    url)
		check="checkURL( \"${itemID[${i}]}\" );"
		;;
	    none)
		unset check
		;;
	    *)
		unset check
		;;
	esac

	item_title_id=${itemTitleId[${i}]}

	if test -z "${item_title_id}" ; then
	    item_title=${itemTitle[${i}]}
	else
	    item_title="<span id='${item_title_id}'>${itemTitle[${i}]}</span>"
	fi

	case "${itemForm[${i}]}" in
	    'hidden')
		;;
	    'textarea')
		echo "<tr><td width='${itemWidth[0]}%'>${item_title}</td>"
		echo "<td width='${itemWidth[1]}%'><textarea id='${itemID[${i}]}' name='${itemID[${i}]}' ${blankItemContent[${i}]} onblur='${check}'${item_state}>${itemValue[${i}]}</textarea></td></tr>"
		;;
	    'select')
		echo "<tr><td width='${itemWidth[0]}%'>${item_title}</td>"
		if test -n "${itemFormSelectCB[${i}]}" ; then
		    jsfunction=" onChange=\"javascript:${itemFormSelectCB[${i}]}\""
		else
		    unset jsfunction
		fi
		echo "<td width='${itemWidth[1]}%'><select id='${itemID[${i}]}' name='${itemID[${i}]}'${item_state}${jsfunction}>${blankItemContent[${i}]}</select></td></tr>"
		;;
	    'check')
		echo "<tr><td width='${itemWidth[0]}%'><label for='${itemID[${i}]}'>${item_title}</label></td>"
		if test -n "${itemFormCheckCB[${i}]}" ; then
		    jsfunction=" onChange=\"javascript:${itemFormCheckCB[${i}]}\""
		else
		    unset jsfunction
		fi
		echo "<td width='${itemWidth[1]}%'><input id='${itemID[${i}]}' name='${itemID[${i}]}' ${blankItemContent[${i}]} onblur='${check}'${item_state}${jsfunction} /></td></tr>"
		;;

	    'text')
		echo "<tr><td width='${itemWidth[0]}%'>${item_title}</td>"
		echo "<td width='${itemWidth[1]}%'><span id='${itemID[${i}]}'>${blankItemContent[${i}]}</span></td></tr>"
		;;
	    'tab')
		if test -z "${first_tab}" ; then
		    show-table-end ${length}
		    echo "</div>"
		else
		    unset first_tab
		fi
		echo "<div id='${itemID[${i}]}' class='tabcontent'>"
		show-table-begin ${length} ${width}
		;;
	    *)
		echo "<tr><td width='${itemWidth[0]}%'><label for='${itemID[${i}]}'>${item_title}</label></td>"
		echo "<td width='${itemWidth[1]}%'><input id='${itemID[${i}]}' name='${itemID[${i}]}' ${blankItemContent[${i}]} onblur='${check}'${item_state} /></td></tr>"
		;;
	esac
    done

    show-table-end ${length}
    test "${itemForm[0]}" != tab || echo "</div>"
    show-do ${submit_state} ${reset_state}
    test -z "${after_function}" || eval ${after_function} ${after_function_args}
    show-form-end
    echo '</div>'
}

show-tab-form()
{
    local width=${1}
    local submit_state=${2}
    local after_function=${3}
    shift 3 ; local after_function_args="${@}"

    local i=0
    test "${itemForm[${i}]}" == tab || return 1
    local length=${#itemID[@]}

    echo "<script type='text/javascript' src='/js/tabcontent.js'></script>"
    echo "<link rel='stylesheet' type='text/css' href='/tabcontent.css' />"

    echo "<div style='clear:left; height:11px;'></div>"

    echo "<div class='core-form'>"
    echo "<ul id='formtabs' class='shadetabs'>"
    echo "<li><a href='#' rel='${itemID[${i}]}' class='selected'>${itemTitle[${i}]}</a></li>"

    for ((i=1 ; i<length ; i++))
    do
	test "${itemForm[${i}]}" == tab || continue
	echo "<li><a href='#' rel='${itemID[${i}]}'>${itemTitle[${i}]}</a></li>"
    done

    echo "</ul>"
    echo "</div>"

    show-form "${width}" "${submit_state}"

    echo "<script type='text/javascript'>"
    echo "var formTabs = new ddtabcontent( 'formtabs' );"
    echo "formTabs.setpersist( true );"
    echo "formTabs.setselectedClassTarget( 'link' );"
    echo "formTabs.init( );"
    echo "</script>"

    test -z "${after_function}" || eval ${after_function} ${after_function_args}
}

echo-noscript()
{
    local items item n i=0
    declare -a items

    items[${i}]="The requested page contains JavaScript codes that could not be executed while this application uses JavaScript." ; ((i++))
    items[${i}]="If your browser doesn't support JavaScript please feel free to use a browser that supports JavaScript." ; ((i++))
    items[${i}]="It may also possible that you disabled JavaScript in your browser. In this case, please reactivate it in order to use this application." ; ((i++))
    items[${i}]="Please note that the system may also be configured using the CLI (Command Line Interface) via the Console port or an SSH client." ; ((i++))
    n=${i}

    local code="Web GUI error"
    local title="JavaScript is disabled"

    echo "<noscript>"
    echo "<table width='100%'>"
    echo "<tr>"
    echo "<td width='20%' bgcolor='FireBrick' valign='center'><center><font size='2' color='White'><strong>${code}</strong></font></center></td>"
    echo "<td width='80%' bgcolor='' valign='center'>"
    echo "<span style='font-size:150%; font-weight:bold; color:FireBrick;'>"
    echo "<center>${title}</center>"
    echo "</span>"
    echo "</td>"
    echo "</tr>"
    for ((i=0 ; i<n ; i++))
    do
	item=${items[${i}]}

	echo "<tr>"
	echo "<td width='20%' bgcolor='Gainsboro'></td>"
	echo "<td width='80%' bgcolor='Gainsboro' valign='center'><font size='2' color='DarkSlateGray'>${item}</font></td>"
	echo "</tr>"
    done

    echo "</table>"
    echo "</noscript>"
}

echo-top-page-begin()
{
    local peer_role bgcolor menucolor

    case ${APL_ROLE} in
	gateway)
	    bgcolor=${GATEWAY_HEAD_COLOR};
	    menucolor=${GATEWAY_TITLE_COLOR}
	    ;;
	manager)
	    bgcolor=${MANAGER_HEAD_COLOR};
	    menucolor=${MANAGER_TITLE_COLOR}
	    case ${CURRENT_MANAGER_SYNC_ROLE} in
		master)
		    peer_role=" (${CURRENT_MANAGER_SYNC_ROLE})"
		    ;;
		slave)
		    peer_role=" <i>(${CURRENT_MANAGER_SYNC_ROLE})</i>"
		    ;;
		*)
		    ;;
	    esac
	    ;;
	*)
	    bgcolor=${GATEWAY_HEAD_COLOR};
	    menucolor=${GATEWAY_TITLE_COLOR}
	    ;;
    esac

    cat <<EOF
<div class='box-header' style='background-color:${bgcolor};'>
<div class='box-logo'>
<a href='/'><img src='${IMAGE_DIR}/${COMMERCIAL_NAME}Logo.png' alt='${COMMERCIAL_NAME}' align='left' height='65' /></a>
</div>
<div class='header-left' style='float:left;'>
<span style='float:left; color:FireBrick;'>Cache</span>
<span style='float:left; color:#75757c;'>Guard</span><br />
<span style='float:left; color:${menucolor}; font-style:normal;'>${APL_ROLE^}${peer_role}</span>
</div>
</div>
EOF
}

echo-top-page-middle()
{
    test ${AUTH_STATE} -eq 0 || return 0
    show-title-check-usage
}

echo-top-page-end()
{
    cat <<EOF
<div style='float:right; text-align:end;'><b>${COMMERCIAL_NAME} ${APL_ROLE^}</b><br />
Network Security & Optimisation
EOF

    if test ${AUTH_STATE} -ne 0 ; then
	echo "</div>"
	return 0
    fi

    echo "<div id='logout-iconbar' style='margin:0; margin-top:2px;'><a class='iconbar-item' href='#' style='float:right;margin-left:10px;' onClick='requestLogout( );'><img src='${IMAGE_DIR}/exit-reflect.png' alt='Logout' title='Logout' /></a></div>"
    echo "</div>"
}

echo-head-end()
{
    local title

    test -z "${GUI_PAGE_TITLE}" || title=" ${GUI_PAGE_TITLE}"
    cat <<EOF
<title>
${COMMERCIAL_NAME} ${APL_ROLE^}${title}
</title>
</head>

EOF
}

echo-top-page()
{
    echo "<div style='padding:5px; margin:0;' >"
    echo "<table width='100%'><tr>"

    echo "<td width='25%'>"
    echo-top-page-begin
    echo "</td>"

    echo "<td width='50%'>"
    echo-top-page-middle
    echo "</td>"

    echo "<td width='25%'>"
    echo-top-page-end
    echo "</td>"

    echo "</tr></table>"
    echo "</div>"
}

echo-top-html()
{
    test -n "${1}" || return 1
    local id=${1}
    local style=${2}

    echo-noscript
    echo-head-end
    echo-body-top "${id}" "${style}"
}

gui-authenticate-phase1()
{
    test -n "${1}" || return 1
    local page=${1}
    shift
 
    read-post-data
    try-authenticate

    verify-authentication
    AUTH_STATE=${?}

    if test ${AUTH_STATE} -eq 0 ; then

	gui-init-env ${page} "${@}"
	INITENV_STATUS=${?}

	echo-http-header

	local role=$(gui-get-contextual-role)
	cat ${ETC_HTML_DIR}/head-top.${APL_ROLE}.html
	echo "<script type=\"text/javascript\" src=\"${JS_DIR}/ddaccordioninit.${role}.js\"></script>"
    else
	echo-http-header
	cat ${ETC_HTML_DIR}/head-login-top.html
    fi
}

get-login-redirect-page()
{
    echo '/'
}

gui-authenticated-core-content()
{
    local page=$(file-basename ${0} .${GUI_EXT_NAME})
    test ${page} != 'login' || page=$(get-login-redirect-page)

    echo "<table width='100%'><tr><td valign='top'>"

    show-left-menu ${module}
    echo "</td><td valign='top' width='100%'>"
    show-top-menu ${module}

    echo "<div class='core' id='core' name='core'>"

    if test ${INITENV_STATUS} -eq 0 ; then

	local page=$(get-contextual-page "${@}")
	test ${page} != 'login' || page=$(get-login-redirect-page)

	source ${page}${GUI_CORE_EXT}

	if test -f ${GUI_CGI_DIR}/update-${page}.${GUI_EXT_NAME} ; then
	    local script="update_${page//-/_}( 0 );"
	    call-js-function "${script}"
	fi
    else
	gen-gui-error 12
	show-title-errors
    fi

    echo "</div>"
    echo "</td><tr></table>"
}

gui-unauthenticated-core-content()
{
    echo "<div class='core' id='core' name='core'>"
    source login${GUI_CORE_EXT}
    echo "</div>"
}

gui-authenticate-phase2()
{
    if test ${AUTH_STATE} -eq 0 ; then

	case ${APL_ROLE} in
	    gateway)
		local bgcolor=${GATEWAY_HEAD_COLOR};
		;;
	    manager)
		local bgcolor=${MANAGER_HEAD_COLOR};
		;;
	    *)
		local bgcolor=${GATEWAY_HEAD_COLOR};
		;;
	esac

	echo "<div style='background-color:${bgcolor};'>"
	echo "<span style='float:left; background-color:transparent;'>"
	display-left-header-info
	echo "</span>"

	echo "<span style='float:right; background-color:transparent;'>"
	echo "<span class='top-menu-arrow' id='top-menu-arrow' title='Show/Hide Top Menu'></span>"
	display-right-header-info

	echo "</span>"
	echo "</div>"

	gui-authenticated-core-content "${@}"
    else
	gui-unauthenticated-core-content "${@}"
    fi
}

gui-authenticate-dashboard-phase1()
{
    check-cgi-security
    verify-authentication
    AUTH_STATE=${?}

    if test ${AUTH_STATE} -eq 0 ; then
	gui-init-env-variables
	echo-http-header
	cat ${ETC_HTML_DIR}/head-top-dashboard.html
    else
	echo-http-header
	cat ${ETC_HTML_DIR}/head-login-top-dashboard.html
    fi
}

gui-authenticate-dashboard-phase2()
{
    local page=$(file-basename ${0} .${GUI_EXT_NAME})

    if test ${AUTH_STATE} -eq 0 ; then
	source ${page}${GUI_CORE_EXT}
    else
	source authenticate-gui.${GUI_EXT_NAME}
    fi
}

gui-run-authentication()
{
    check-cgi-security
    verify-authentication || http-exit 1
    gui-init-env-variables
    echo-http-header
}

gui-run-dashboard-page()
{
    local page=$(file-basename ${0} .${GUI_EXT_NAME})

    gui-authenticate-dashboard-phase1
    echo-top-html ${page} 'min-width:0px; overflow-x:hidden;'
    gui-authenticate-dashboard-phase2 "${@}"
    gen-body-bottom
    gen-bottom-html
}

gui-run-page()
{
    local page=$(file-basename ${0} .${GUI_EXT_NAME})

    test ${page} != login -o "${1}" != 'logout' || reset-auth-token

    gui-authenticate-phase1 ${page} "${@}"
    echo-top-html "${page}"
    echo-top-page
    gui-authenticate-phase2 "${@}"

    test ${page} == login -a "${1}" == 'logout' || call-js-function 'initAutoLogout( )'

    show-footer
    gen-body-bottom
    gen-bottom-html
}

show-copyright()
{
    echo "<div class='copyright'>"
    echo "Copyright ${YEARS} ${COMPANY_NAME} - All rights reserved - <a target='_blank' href='https://${WEBSITE}/'>${WEBSITE}</a>"
    echo '</div>'
}

show-footer()
{
    echo "<div style='clear:left; margin:0; padding:0; height:0;'></div>"
    show-copyright
}

gui-information-message()
{
    local message=${1}
    local font_sz=${2}
    test -n "${font_sz}" || font_sz=120%

    echo "<div class='core-form'>"
    echo "<div class='box-help-inner' style='font-size:${font_sz}; margin:0; padding:15px; border:solid FireBrick 1px;'>"
    echo ${message}
    echo "</div>"
    echo "</div>"
}

show-pre-clipboard-copy()
{
    test -n "${1}" || return 1
    local pre_id=${1}
    local object_type=${2}

    test -z "${object_type}" || object_type=" ${object_type}"
    local icon_id="${pre_id}-icon"
    local title="Copy${object_type} to Clipboard"

    echo "<div style='float:right;'><img id='${icon_id}' style='width:40px; height:40px; margin:0; margin-left:5px;' src='${IMAGE_DIR}/clipboard-copy.png' alt='${title}' title='${title}' onclick='copyPreToClipboard( \"${pre_id}\", \"${icon_id}\" )' /></div>"
}

show-file-content-clipboard-copy()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local file=${1}
    local text_area_id=${2}
    local object_type=${3}

    test -f ${file} || return 11

    local size=$(ls -s --block-size=1024 ${file} 2>/dev/null)
    size=${size/ */}
    test ${size} -eq 1 || return 13

    local content=$(cat ${file})

    test -z "${object_type}" || object_type=" ${object_type}"
    local icon_id="${text_area_id}-icon"
    local title="Copy${object_type} to Clipboard"

    echo "<div style='float:right;'><img id='${icon_id}' style='width:40px; height:40px; margin:0; margin-left:5px;' src='${IMAGE_DIR}/clipboard-copy.png' alt='${title}' title='${title}' onclick='copyToClipboard( \"${text_area_id}\", \"${icon_id}\", \"${content}\" )' /></div>"
}

show-send-file-content-by-sms()
{
    test -n "${1}" || return 1
    local file=${1}
    local title=${2}

    test -f ${file} || return 11

    local size=$(ls -s --block-size=1024 ${file} 2>/dev/null)
    size=${size/ */}
    test ${size} -eq 1 || return 13

    local phone_len=20
    local phone_id='phone'
    local phone_title='<strong>Phone Number</strong> (International Format)'
    local content=$(cat ${file})

    message="${content}"
    message=$(url-encode "${message}")

    echo "<div style='float:right;'>${phone_title} <input id='${phone_id}' type='text' size='${phone_len}' maxlength='${phone_len}' /> <img style='width:40px; height:40px; vertical-align:middle;' src='${IMAGE_DIR}/whatsapp.png' alt='${title}' title='${title}' onclick='sendPhoneNumber( \"whatsapp\", \"${phone_id}\", \"${message}\" )' /><hr /></div>"
}

get-selected-option()
{
    local selected
    test "${1}" != "${2}" || selected=" selected"
    printf '%s' "${selected}"
}

echo-content-unavailable()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local width=${1}
    local message=${2}

    len=${#width} ; ((len--))
    test ${width:${len}:1} == '%' || width="${width}px"

    echo "<table class='report' width='${width}'>"
    echo "<tr><td width='100%'>${message}</td></tr>"
    echo "</table>"
}

form-error-message()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local width=${1}
    local message=${2}

    echo "<div class='core-form' style='margin-bottom:8px;'>"
    echo-content-unavailable ${width} "${message}"
    echo "</div>"
}
