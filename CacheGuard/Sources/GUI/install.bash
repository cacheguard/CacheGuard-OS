#!/bin/bash

###########################################################################
#
# MODULE:       Build
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

test -n "${APL}" || exit 1

source CacheGuard.env
source WorkFunctions

make-generated-directories()
{
    mkdir -p ${FULL_GENERATED_DIR}
    ln -sf ${FULL_GENERATED_DIR}

    local module

    for module in Administration Auditing
    do
	cd ${module}
	mkdir -p ${BASE_GENERATED_DIR}/${module}/${GENERATED_DIR}
	mkdir -p ${BASE_GENERATED_DIR}/${module}/${CGI_GENERATED_DIR}
	ln -sf ${BASE_GENERATED_DIR}/${module}/${GENERATED_DIR}
	ln -sf ${BASE_GENERATED_DIR}/${module}/${CGI_GENERATED_DIR}
	cd ..
    done
}

file-basename()
{
    test -n "${1}" || return 1
    local name=${1}

    local base=${name##*/}
    if test -n "${2}" ; then
	base=${base/${2}/}
    fi
    echo ${base}
}

gen-js-constant()
{
    test -n "${1}" || return 1
    local module=${1}

    cat ${HEADER_DIR}/js-file-header

    echo "var GUI_MODULE_NAME = '${module}';"
    echo "var GUI_DIR = '/${GUI_DIR_NAME}/';"
    echo "var GUI_IMAGE_DIR = '/${IMAGE_DIR_NAME}/';"
    echo "var GUI_EXTENSION = '.${GUI_EXT_NAME}';"
    echo "var GUI_CSRF_ATTRIBUTE = '${GUI_CSRF_ATTRIBUTE}';"
    echo "var GUI_COOKIE_AUTH_NAME = '${GUI_COOKIE_AUTH_NAME}';"
    echo "var GUI_COOKIE_LEFT_MENU_NAME = '${GUI_COOKIE_LEFT_MENU_NAME}';"
    echo "var GUI_COOKIE_TOP_MENU_NAME = '${GUI_COOKIE_TOP_MENU_NAME}';"
}

gen-js-mosaic-constant()
{
    cat ${HEADER_DIR}/js-file-header

    echo "var GUI_MOSAIC_LIMIT_LEFT = ${GUI_MOSAIC_LIMIT_LEFT};"
    echo "var GUI_MOSAIC_LIMIT_TOP = ${GUI_MOSAIC_LIMIT_TOP};"
    echo "var GUI_MOSAIC_WIDTH = ${GUI_MOSAIC_WIDTH};"
    echo "var GUI_MOSAIC_HEIGHT = ${GUI_MOSAIC_HEIGHT};"
    echo "var GUI_MOSAIC_GRID_STICK = ${GUI_MOSAIC_GRID_STICK};"
    echo "var GUI_COOKIE_DASHBOARD_MENU_NAME = \"${GUI_COOKIE_DASHBOARD_MENU_NAME}\";"
}

echo-cgi-header()
{
    cat ${HEADER_DIR}/file-header
    echo
    echo "source functions"
    echo
    echo "# Main()"
    echo
    echo "check-cgi-security"
}

gen-cgi-page()
{
    test -n "${1}" || return 1
    local page=${1}

    echo-cgi-header
    echo "gui-run-page \"\${@}\""
}

gen-cgi-dashboard-page()
{
    test -n "${1}" || return 1
    local page=${1}

    echo-cgi-header
    echo "gui-run-dashboard-page \"\${@}\""
}

gen-submit-cgi-core-page()
{
    test -n "${1}" || return 1
    local page=${1}

    echo-cgi-header
cat <<EOF
manage-submit-core "\${@}"
EOF
}

gen-functions()
{
    test -n "${1}" || return 1
    local gui=${1}

    cat ${HEADER_DIR}/file-header
    echo
    echo "GUI_ERRORS_FILE=${GUI_ERRORS_FILE}"
    echo 'LOG=${GUI_ERRORS_FILE}.${$}'
    echo "APPLIANCE_DIR=${APPLIANCE_DIR}"
    echo
    echo "source common-functions.${GUI_EXT_NAME}"
    echo "source ${gui}-functions.${GUI_EXT_NAME}"
}

gen-firewall-rules()
{
    local rset rset1
    local cgi

    local rsets="external auxiliary web rweb admin mon file peer antivirus vpnipsec" rsets1

    local post="(\&entry_[0-9]{1,4}=(old|anew|inew|move[[:digit:]]{1,3})\&rule_id_[0-9]{1,4}=[[:print:]]{0,192}(\&state_[0-9]{1,4}=on)?\&action_[0-9]{1,4}=(allow|deny)\&protocol_[0-9]{1,4}=(any|icmp|igmp|ipv6|udp|tcp|gre|esp|ah|tlsp|cftp|visa|vrrp|fc|ospfigp|mtp|etherip|ftp_passive|ftp_active|ftp_trivial|sip)\&src_ip_[0-9]{1,4}=[[:print:]]{0,54}\&dst_dev_[0-9]{1,4}=(${rsets1})\&dst_ip_[0-9]{1,4}=[[:print:]]{0,54}\&dst_ports_[0-9]{1,4}=[[:print:]]{0,33}\&src_nat_ip_[0-9]{1,4}=[[:print:]]{0,45}\&dst_nat_ip_[0-9]{1,4}=[[:print:]]{0,45}\&dst_pat_port_[0-9]{1,4}=[[:print:]]{0,15}(\&del_[0-9]{1,4}=on)?)*"

    for rset in ${rsets}
    do
	cgi="firewall-${rset}"
	query="(\?page:[[:digit:]]{0,3}-[[:digit:]]{0,3})?"

	unset rsets1
	for rset1 in ${rsets}
	do
	    test ${rset} == ${rset1} || rsets1="${rsets1} ${rset1}"
	done
	
	rsets1="any${rsets1}"
	rsets1="${rsets1// /|}"

	echo
	echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},severity:6,allow,chain"
	echo "SecRule REQUEST_URI \"^/${GUI_DIR_NAME}/${cgi}\.${GUI_EXT_NAME}${query}$\""
	((WAF_RULE_ID++))

	echo
	echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},severity:6,allow,chain"
	echo "SecRule REQUEST_URI \"^/${GUI_DIR_NAME}/submit-${cgi}\.${GUI_EXT_NAME}${query}$\""
	((WAF_RULE_ID++))

	echo
	echo "SecRule REQUEST_METHOD \"^POST$\" id:${WAF_RULE_ID},severity:6,allow,chain"
	echo "SecRule REQUEST_BODY \"^${GUI_CSRF_ATTRIBUTE}=[[:print:]]{64,128}${post}\" chain"
	echo "SecRule REQUEST_URI \"^/${GUI_DIR_NAME}/submit-${cgi}\.${GUI_EXT_NAME}${query}$\""
	((WAF_RULE_ID++))
    done
}

gen-doc-rules()
{
    local doc_dir=../Documentation
    
    local html name

    for name in ${doc_dir}/JS/*.js
    do
	name=$(file-basename ${name})
	name=${name//\./\\\.}
	echo
	echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},severity:6,allow,chain"
	echo "SecRule REQUEST_URI \"^/${DOC_DIR_NAME}/${JS_DIR_NAME}/${name}$\""
	((WAF_RULE_ID++))
    done

    for html in ${doc_dir}/UsersGuide/HTMLGenerated/*.html
    do
	name=$(file-basename ${html} .html)
	echo
	echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},severity:6,allow,chain"
	echo "SecRule REQUEST_URI \"^/${DOC_DIR_NAME}/${DOC_GUIDE_DIR_NAME}/${name}\.html$\""
	((WAF_RULE_ID++))
    done

    for html in ${doc_dir}/*.css
    do
	name=$(file-basename ${html} .css)
	echo
	echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},severity:6,allow,chain"
	echo "SecRule REQUEST_URI \"^/${DOC_DIR_NAME}/${name}\.css$\""
	((WAF_RULE_ID++))
    done

    for image in ${doc_dir}/UsersGuide/Image/* ${doc_dir}/UsersGuide/Schema/*.png ${doc_dir}/Image/*
    do
	name=$(file-basename ${image})
	name=${name//\./\\\.}
	echo
	echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},severity:6,allow,chain"
	echo "SecRule REQUEST_URI \"^/${DOC_DIR_NAME}/${IMAGE_DIR_NAME}/${name}$\""
	((WAF_RULE_ID++))
    done

    for html in ${doc_dir}/OnlineCommands/Generated/*.html
    do
	name=$(file-basename ${html} .html)
	echo
	echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},severity:6,allow,chain"
	echo "SecRule REQUEST_URI \"^/${DOC_DIR_NAME}/${DOC_COMMAND_DIR_NAME}/${name}\.html$\""
	((WAF_RULE_ID++))
    done
}

gen-mib-rules()
{
    local etc_dir=../ETC
    
    local name

    for name in ${etc_dir}/${GENERATED_DIR}/${MAIN_MIB_NAME}
    do
	name=$(file-basename ${name})
	name=${name//\./\\\.}
	echo
	echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},severity:6,allow,chain"
	echo "SecRule REQUEST_URI \"^/${MIB_DIR_NAME}/${name}$\""
	((WAF_RULE_ID++))
    done
}

gen-waf-rules-constant()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local gui=${1}
    local module=${2}

    local css file role cgi query post name

    cat ${RULE_DIR}/exception.rules
    echo
    cat ${module}/${RULE_DIR}/exception.rules

    if test ${module} == 'Administration' ; then
	for file in ${module}/${UPDATE_DIR}/*.${GUI_EXT_NAME}
	do
	    name=$(file-basename ${file} .${GUI_EXT_NAME})
	    test ${name} != 'update-vpnipsec-report' || continue

	    echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},log,auditlog,severity:5,allow,chain"
	    echo "SecRule REQUEST_URI \"^/gui/${name}\.${GUI_EXT_NAME}$\""

	    ((WAF_RULE_ID++))
	done
    fi

    for css in ${CSS_DIR}/*.css
    do
	name=$(file-basename ${css})
	echo
	echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},log,auditlog,severity:6,allow,chain"
	echo "SecRule REQUEST_URI \"^/${name}$\""
	((WAF_RULE_ID++))
    done

    for file in Images/* Icons/* ${module}/Icons/*
    do
	name=$(file-basename ${file})
	name=${name//./\\.}
	echo
	echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},severity:6,allow,chain"
	echo "SecRule REQUEST_URI \"^/${IMAGE_DIR_NAME}/${name}$\""
	((WAF_RULE_ID++))
    done

    for file in JS/*.js ${module}/JS/*.js ${GENERATED_DIR}/*.js ${module}/${GENERATED_DIR}/*.js
    do
	name=$(file-basename ${file})
	name=${name//./\\.}
	echo
	echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},severity:6,allow,chain"
	echo "SecRule REQUEST_URI \"^/${JS_DIR_NAME}/${name}\$\""
	((WAF_RULE_ID++))
    done

    echo
    echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},severity:6,allow,chain"
    echo "SecRule REQUEST_URI \"^/${JS_DIR_NAME}//board-menu\.js\$\""
    ((WAF_RULE_ID++))

    for role in gateway manager
    do
	echo
	echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},severity:6,allow,chain"
	echo "SecRule REQUEST_URI \"^/${JS_DIR_NAME}//board-menu.${role}\.js\$\""
	((WAF_RULE_ID++))
    done

    echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},severity:6,allow,chain"
    echo "SecRule REQUEST_URI \"^/${JS_DIR_NAME}/scrolltopcontrol\.js\?_=[[:digit:]]{0,16}\$\""
    ((WAF_RULE_ID++))

    while read -r cgi query post
    do
	test -n "${cgi}" || continue

	echo
	echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},severity:6,allow,chain"
	echo "SecRule REQUEST_URI \"^/${GUI_DIR_NAME}/${cgi}\.${GUI_EXT_NAME}$\""

	((WAF_RULE_ID++))

	echo

	if test ${cgi/*-} != "dashboard" ; then
	    echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},severity:6,allow,chain"
	    echo "SecRule REQUEST_URI \"^/${GUI_DIR_NAME}/submit-${cgi}\.${GUI_EXT_NAME}$\""
	else
	    echo "SecRule REQUEST_METHOD \"^HEAD$\" id:${WAF_RULE_ID},severity:6,allow,chain"
	    echo "SecRule REQUEST_URI \"^/${GUI_DIR_NAME}/${cgi}\.${GUI_EXT_NAME}$\""
	fi

	((WAF_RULE_ID++))

	test -n "${query}" || continue
	test ${query} != nil || unset query

	echo
	echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},severity:6,allow,chain"
	echo "SecRule REQUEST_URI \"^/${GUI_DIR_NAME}/${cgi}\.${GUI_EXT_NAME}${query}$\""

	((WAF_RULE_ID++))

	if test ${cgi/*-} != "dashboard" ; then
	    echo
	    echo "SecRule REQUEST_METHOD \"^GET$\" id:${WAF_RULE_ID},severity:6,allow,chain"
	    echo "SecRule REQUEST_URI \"^/${GUI_DIR_NAME}/submit-${cgi}\.${GUI_EXT_NAME}${query}$\""

	    ((WAF_RULE_ID++))

	    if test -n "${post}" ; then
		if test ${post} == nil ; then
		    unset post
		else
		    post=${post//\//%2F}
		fi
		echo
		echo "SecRule REQUEST_METHOD \"^POST$\" id:${WAF_RULE_ID},severity:6,allow,chain"
		echo "SecRule REQUEST_BODY \"^${GUI_CSRF_ATTRIBUTE}=[[:print:]]{64,128}${post}\" chain"
		echo "SecRule REQUEST_URI \"^/${GUI_DIR_NAME}/submit-${cgi}\.${GUI_EXT_NAME}${query}$\""
		((WAF_RULE_ID++))
	    fi
	fi

    done < ${module}/${RULE_DIR}/page.rules

    if test ${module} == Administration ; then
	gen-firewall-rules
	gen-doc-rules
	gen-mib-rules
    fi

    echo
    echo "SecAction id:3999,severity:2"
}

gen-env-menu()
{
    local module=${1}
    local apl_roles=${2}
    local ctx_roles=${3}
    local title=${4}
    local page=${5}
    local path=${6}

    title=${title//_/ }
    page=${page/\?*}
    page=$(file-basename ${page} .${GUI_EXT_NAME})

    case ${apl_roles} in
	1)
	    echo "MENU_PAGE[${MENU_NB}]=\"${page}\"" >> ${module}/${GENERATED_DIR}/menu.env
	    echo "MENU_PAGE_TITLE[${MENU_NB}]=\"${title}\"" >> ${module}/${GENERATED_DIR}/menu.env
	    echo "MENU_PAGE_PATH[${MENU_NB}]=\"${path}\"" >> ${module}/${GENERATED_DIR}/menu.env
	    ((MENU_NB++))
	    ;;
	2)
	    case ${ctx_roles} in
		1)
		    echo "MENU_PAGE[${GATEWAY_MENU_NB}]=\"${page}\"" >> ${module}/${GENERATED_DIR}/menu.gateway.env
		    echo "MENU_PAGE_TITLE[${GATEWAY_MENU_NB}]=\"${title}\"" >> ${module}/${GENERATED_DIR}/menu.gateway.env
		    echo "MENU_PAGE_PATH[${GATEWAY_MENU_NB}]=\"${path}\"" >> ${module}/${GENERATED_DIR}/menu.gateway.env
		    ((GATEWAY_MENU_NB++))
		    ;;
		2)
		    echo "MENU_PAGE[${MANAGER_MENU_NB}]=\"${page}\"" >> ${module}/${GENERATED_DIR}/menu.manager.env
		    echo "MENU_PAGE_TITLE[${MANAGER_MENU_NB}]=\"${title}\"" >> ${module}/${GENERATED_DIR}/menu.manager.env
		    echo "MENU_PAGE_PATH[${MANAGER_MENU_NB}]=\"${path}\"" >> ${module}/${GENERATED_DIR}/menu.manager.env
		    ((MANAGER_MENU_NB++))
		    ;;
		*)
		    ;;
	    esac

      	    ;;
	3)
	    echo "MENU_PAGE[${MENU_NB}]=\"${page}\"" >> ${module}/${GENERATED_DIR}/menu.env
	    echo "MENU_PAGE_TITLE[${MENU_NB}]=\"${title}\"" >> ${module}/${GENERATED_DIR}/menu.env
	    echo "MENU_PAGE_PATH[${MENU_NB}]=\"${path}\"" >> ${module}/${GENERATED_DIR}/menu.env
	    ((MENU_NB++))

	    case ${ctx_roles} in
		1)
		    echo "MENU_PAGE[${GATEWAY_MENU_NB}]=\"${page}\"" >> ${module}/${GENERATED_DIR}/menu.gateway.env
		    echo "MENU_PAGE_TITLE[${GATEWAY_MENU_NB}]=\"${title}\"" >> ${module}/${GENERATED_DIR}/menu.gateway.env
		    echo "MENU_PAGE_PATH[${GATEWAY_MENU_NB}]=\"${path}\"" >> ${module}/${GENERATED_DIR}/menu.gateway.env
		    ((GATEWAY_MENU_NB++))
		    ;;
		2)
		    echo "MENU_PAGE[${MANAGER_MENU_NB}]=\"${page}\"" >> ${module}/${GENERATED_DIR}/menu.manager.env
		    echo "MENU_PAGE_TITLE[${MANAGER_MENU_NB}]=\"${title}\"" >> ${module}/${GENERATED_DIR}/menu.manager.env
		    echo "MENU_PAGE_PATH[${MANAGER_MENU_NB}]=\"${path}\"" >> ${module}/${GENERATED_DIR}/menu.manager.env
		    ((MANAGER_MENU_NB++))
		    ;;
		3)
		    echo "MENU_PAGE[${GATEWAY_MENU_NB}]=\"${page}\"" >> ${module}/${GENERATED_DIR}/menu.gateway.env
		    echo "MENU_PAGE_TITLE[${GATEWAY_MENU_NB}]=\"${title}\"" >> ${module}/${GENERATED_DIR}/menu.gateway.env
		    echo "MENU_PAGE_PATH[${GATEWAY_MENU_NB}]=\"${path}\"" >> ${module}/${GENERATED_DIR}/menu.gateway.env
		    ((GATEWAY_MENU_NB++))

		    echo "MENU_PAGE[${MANAGER_MENU_NB}]=\"${page}\"" >> ${module}/${GENERATED_DIR}/menu.manager.env
		    echo "MENU_PAGE_TITLE[${MANAGER_MENU_NB}]=\"${title}\"" >> ${module}/${GENERATED_DIR}/menu.manager.env
		    echo "MENU_PAGE_PATH[${MANAGER_MENU_NB}]=\"${path}\"" >> ${module}/${GENERATED_DIR}/menu.manager.env
		    ((MANAGER_MENU_NB++))
		    ;;
		*)
		    ;;
	    esac
	    ;;
	*)
	    ;;
    esac
}

echo-top-menu()
{
   local module=${1}
    local apl_roles=${2}
    local ctx_roles=${3}
    shift ; shift ; shift
    local text=${@}

    case ${apl_roles} in
	1)
	    echo "${text}" >> ${module}/${GENERATED_DIR}/top-menu.html
	    ;;
	2)
	    case ${ctx_roles} in
		1)
		    echo "${text}" >> ${module}/${GENERATED_DIR}/top-menu.gateway.html
		    ;;
		2)
		    echo "${text}" >> ${module}/${GENERATED_DIR}/top-menu.manager.html
		    ;;
		*)
	    esac
	    ;;
	3)
	    echo "${text}" >> ${module}/${GENERATED_DIR}/top-menu.html
	    
	    case ${ctx_roles} in
		1)
		    echo "${text}" >> ${module}/${GENERATED_DIR}/top-menu.gateway.html
		    ;;
		2)
		    echo "${text}" >> ${module}/${GENERATED_DIR}/top-menu.manager.html
		    ;;
		3)
		    echo "${text}" >> ${module}/${GENERATED_DIR}/top-menu.gateway.html
		    echo "${text}" >> ${module}/${GENERATED_DIR}/top-menu.manager.html
		    ;;
		*)
		    ;;
	    esac
	    ;;
	*)
	    ;;
    esac
}

get-menu-item()
{
    local prefix=${1}
    local module=${2}
    local level=${3}
    local role=${4}
    local item_in=${5}

    local item_out

    case ${level} in
	0)
	    item_out=${item_in}
	    ;;
	1)
	    item_out="<h3 class='menuheader ${prefix}-menu-${module,,}-${role}'>${item_in}</h3>"
	    ;;
	2)
	    item_out="<ul class='${prefix}-menu-${module,,}-items'>"
	    ;;
	3)
	    item_out="<li><a href='link' class='${prefix}-submenu-${module,,}-${role}'>${item_in}</a>"
	    ;;
	4)
	    item_out="<ul class='${prefix}-submenu-${module,,}-items' style='margin-left:15px;'>"
	    ;;
	*)
	    ;;
    esac

    echo ${item_out}
}

echo-left-menu()
{
    local module=${1}
    local apl_roles=${2}
    local ctx_roles=${3}
    local level=${4}
    local item_in=${5}

    local item

    case ${apl_roles} in
	1)
	    item=$(get-menu-item left ${module} ${level} gateway "${item_in}")
	    echo "${item}" >> ${module}/${GENERATED_DIR}/left-menu.html
	    ;;
	2)
	    case ${ctx_roles} in
		1)
		    item=$(get-menu-item left ${module} ${level} gateway "${item_in}")
		    echo "${item}" >> ${module}/${GENERATED_DIR}/left-menu.gateway.html
		    ;;
		2)
		    item=$(get-menu-item left ${module} ${level} manager "${item_in}")
		    echo "${item}" >> ${module}/${GENERATED_DIR}/left-menu.manager.html
		    ;;
		*)
		    ;;
	    esac
	    ;;
	3)
	    item=$(get-menu-item left ${module} ${level} gateway "${item_in}")
	    echo "${item}" >> ${module}/${GENERATED_DIR}/left-menu.html

	    case ${ctx_roles} in
		1)
		    item=$(get-menu-item left ${module} ${level} gateway "${item_in}")
		    echo "${item}" >> ${module}/${GENERATED_DIR}/left-menu.gateway.html
		    ;;
		2)
		    item=$(get-menu-item left ${module} ${level} manager "${item_in}")
		    echo "${item}" >> ${module}/${GENERATED_DIR}/left-menu.manager.html
		    ;;
		3)
		    item=$(get-menu-item left ${module} ${level} gateway "${item_in}")
		    echo "${item}" >> ${module}/${GENERATED_DIR}/left-menu.gateway.html

		    item=$(get-menu-item left ${module} ${level} manager "${item_in}")
		    echo "${item}" >> ${module}/${GENERATED_DIR}/left-menu.manager.html
		    ;;
		*)
		    ;;
	    esac
	    ;;
	*)
	    ;;
    esac
}

echo-board-js()
{
    local apl_roles=${1}
    local ctx_roles=${2}
    local js=${3}
    
    case ${apl_roles} in
	1)
	    echo "${js}" >> ${module}/${GENERATED_DIR}/board-menu.js
	    ;;
	2)
	    case ${ctx_roles} in
		1)
		    echo "${js}" >> ${module}/${GENERATED_DIR}/board-menu.gateway.js
		    ;;
		2)
		    echo "${js}" >> ${module}/${GENERATED_DIR}/board-menu.manager.js
		    ;;
		*)
		    ;;
	    esac
	    ;;
	3)
	    echo "${js}" >> ${module}/${GENERATED_DIR}/board-menu.js

	    case ${ctx_roles} in
		1)
		    echo "${js}" >> ${module}/${GENERATED_DIR}/board-menu.gateway.js
		    ;;
		2)
		    echo "${js}" >> ${module}/${GENERATED_DIR}/board-menu.manager.js
		    ;;
		3)
		    echo "${js}" >> ${module}/${GENERATED_DIR}/board-menu.gateway.js
		    echo "${js}" >> ${module}/${GENERATED_DIR}/board-menu.manager.js
		    ;;
		*)
		    ;;
	    esac
	    ;;
	*)
	    ;;
    esac
}

echo-board-menu()
{
    local apl_roles=${1}
    local ctx_roles=${2}
    local level=${3}
    local item_in=${4}

    local item

    case ${apl_roles} in
	1)
	    item=$(get-menu-item board ${module} ${level} gateway "${item_in}")
	    echo "${item}" >> ${module}/${GENERATED_DIR}/board-menu.html
	    ;;
	2)
	    case ${ctx_roles} in
		1)
		    item=$(get-menu-item board ${module} ${level} gateway "${item_in}")
		    echo "${item}" >> ${module}/${GENERATED_DIR}/board-menu.gateway.html
		    ;;
		2)
		    item=$(get-menu-item board ${module} ${level} manager "${item_in}")
		    echo "${item}" >> ${module}/${GENERATED_DIR}/board-menu.manager.html
		    ;;
		*)
		    ;;
	    esac
	    ;;
	3)
	    item=$(get-menu-item board ${module} ${level} gateway "${item_in}")
	    echo "${item}" >> ${module}/${GENERATED_DIR}/board-menu.html

	    case ${ctx_roles} in
		1)
		    item=$(get-menu-item board ${module} ${level} gateway "${item_in}")
		    echo "${item}" >> ${module}/${GENERATED_DIR}/board-menu.gateway.html
		    ;;
		2)
		    item=$(get-menu-item board ${module} ${level} manager "${item_in}")
		    echo "${item}" >> ${module}/${GENERATED_DIR}/board-menu.manager.html
		    ;;
		3)
		    item=$(get-menu-item board ${module} ${level} gateway "${item_in}")
		    echo "${item}" >> ${module}/${GENERATED_DIR}/board-menu.gateway.html

		    item=$(get-menu-item board ${module} ${level} manager "${item_in}")
		    echo "${item}" >> ${module}/${GENERATED_DIR}/board-menu.manager.html
		    ;;
		*)
		    ;;
	    esac
	    ;;
	*)
	    ;;
    esac
}

echo-board-icon()
{
    local apl_roles=${1}
    local ctx_roles=${2}
    local icon=${3}

    case ${apl_roles} in
	1)
	    echo "${icon}" >> ${module}/${GENERATED_DIR}/board-icon.html
	    ;;
	2)
	    case ${ctx_roles} in
		1)
		    echo "${icon}" >> ${module}/${GENERATED_DIR}/board-icon.gateway.html
		    ;;
		2)
		    echo "${icon}" >> ${module}/${GENERATED_DIR}/board-icon.manager.html
		    ;;
		*)
		    ;;
	    esac
	    ;;
	3)
	    echo "${icon}" >> ${module}/${GENERATED_DIR}/board-icon.html

	    case ${ctx_roles} in
		1)
		    echo "${icon}" >> ${module}/${GENERATED_DIR}/board-icon.gateway.html
		    ;;
		2)
		    echo "${icon}" >> ${module}/${GENERATED_DIR}/board-icon.manager.html
		    ;;
		3)
		    echo "${icon}" >> ${module}/${GENERATED_DIR}/board-icon.gateway.html
		    echo "${icon}" >> ${module}/${GENERATED_DIR}/board-icon.manager.html
		    ;;
		*)
		    ;;
	    esac
	    ;;
	*)
	    ;;
    esac
}

gen-menu()
{
    test -n "${1}" || return 1
    local module=${1}

    MENU_NB=0
    MANAGER_MENU_NB=0
    GATEWAY_MENU_NB=0

    rm -f \
       ${module}/${GENERATED_DIR}/menu.env \
       ${module}/${GENERATED_DIR}/menu.gateway.env \
       ${module}/${GENERATED_DIR}/menu.manager.env \
       \
       ${module}/${GENERATED_DIR}/top-menu.html \
       ${module}/${GENERATED_DIR}/left-menu.html \
       ${module}/${GENERATED_DIR}/board-menu.html \
       ${module}/${GENERATED_DIR}/board-icon.html \
       ${module}/${GENERATED_DIR}/board-menu.js \
       \
       ${module}/${GENERATED_DIR}/top-menu.gateway.html \
       ${module}/${GENERATED_DIR}/left-menu.gateway.html \
       ${module}/${GENERATED_DIR}/board-menu.gateway.html \
       ${module}/${GENERATED_DIR}/board-icon.gateway.html \
       ${module}/${GENERATED_DIR}/board-menu.gateway.js \
       \
       ${module}/${GENERATED_DIR}/top-menu.manager.html \
       ${module}/${GENERATED_DIR}/left-menu.manager.html \
       ${module}/${GENERATED_DIR}/board-menu.manager.html \
       ${module}/${GENERATED_DIR}/board-icon.manager.html \
       ${module}/${GENERATED_DIR}/board-menu.manager.js \
       \
       ${module}/${GENERATED_DIR}/${GUI_PAGES_HIERARCHY_FILENAME}.menu

    touch ${module}/${GENERATED_DIR}/menu.env \
	  ${module}/${GENERATED_DIR}/menu.gateway.env \
	  ${module}/${GENERATED_DIR}/menu.manager.env

    local apl_roles ctx_roles etype f1 f2 f3 f4
    local i=0 image page
    local l=0 upper_page
    local persist=0 hide=0

    echo-top-menu ${module} 3 3 "<ul>"

    while read apl_roles ctx_roles etype f1 f2 f3 f4
    do
	test -n "${apl_roles}" || continue
	test ${apl_roles:0:1} != '#' || continue

	if test -z "${f2}" ; then
	    case ${etype} in

		_BEGIN_)
		    echo-left-menu ${module} ${apl_roles} ${ctx_roles} 1 "${f1//_/ }"
		    echo-left-menu ${module} ${apl_roles} ${ctx_roles} 2

		    echo-top-menu ${module} ${apl_roles} ${ctx_roles} "<li><a href='#'>${f1//_/ }</a>"
		    echo-top-menu ${module} ${apl_roles} ${ctx_roles} "<ul>"

		    echo-board-menu ${apl_roles} ${ctx_roles} 1 "${f1//_/ }"
		    echo-board-menu ${apl_roles} ${ctx_roles} 2
		    ;;

		_ITEM_)
		    ;;

		_END_)
		    echo-left-menu ${module} ${apl_roles} ${ctx_roles} 0 "</ul>"

		    echo-top-menu ${module} ${apl_roles} ${ctx_roles} "</ul>"
		    echo-top-menu ${module} ${apl_roles} ${ctx_roles} "</li>"
		    
		    echo-board-menu ${apl_roles} ${ctx_roles} 0 "</ul>"
		    ;;
		*)
		    ;;
	    esac
	elif test -z "${f3}" ; then
	    case ${etype} in

		_BEGIN_)
		    echo-left-menu ${module} ${apl_roles} ${ctx_roles} 3 "${f2//_/ }"
		    echo-left-menu ${module} ${apl_roles} ${ctx_roles} 4

		    echo-top-menu ${module} ${apl_roles} ${ctx_roles} "<li><a href='/${GUI_DIR_NAME}/${GUI_HOME_PAGE}.${GUI_EXT_NAME}?expanddiv=board-${i}'>${f2//_/ }</a>"
		    echo-top-menu ${module} ${apl_roles} ${ctx_roles} "<ul>"

		    echo-board-js ${apl_roles} ${ctx_roles} "animatedcollapse.addDiv('board-${i}', 'fade=1,speed=400,group=board,persist=${persist},hide=${hide}');"
		    echo-board-menu ${apl_roles} ${ctx_roles} 0 "<li><a href=\"javascript:animatedcollapse.show('board-${i}')\">${f2//_/ }</a></li>"
		    echo-board-icon ${apl_roles} ${ctx_roles} "<div id='board-${i}'>"
		    echo-board-icon ${apl_roles} ${ctx_roles} "<div class='icon-board-title'>${f2//_/ }</div>"

		    ((i++))
		    hide=1
		    ;;

		_ITEM_)
		    echo-left-menu ${module} ${apl_roles} ${ctx_roles} 0 "</ul>"
		    echo-left-menu ${module} ${apl_roles} ${ctx_roles} 0 "</li>"
		    ;;

		_END_)
		    echo-left-menu ${module} ${apl_roles} ${ctx_roles} 0 "</ul>"
		    echo-left-menu ${module} ${apl_roles} ${ctx_roles} 0 "</li>"

		    echo-top-menu ${module} ${apl_roles} ${ctx_roles} "</ul>"
		    echo-top-menu ${module} ${apl_roles} ${ctx_roles} "</li>"

		    echo-board-icon ${apl_roles} ${ctx_roles} "</div>"
		    ;;
		*)
		    ;;
	    esac
	elif test -z "${f4}" ; then
	    case ${etype} in

		_BEGIN_)
		    ;;

		_ITEM_)
		    echo-left-menu ${module} ${apl_roles} ${ctx_roles} 0 "<li><a href='${f3}'>${f2//_/ }</a></li>"
		    echo-top-menu ${module} ${apl_roles} ${ctx_roles} "<li><a href='${f3}'>${f2//_/ }</a></li>"
		    echo-board-menu ${apl_roles} ${ctx_roles} 0 "<li><a href=\"${f3}\">${f2//_/ }</a></li>"
		    gen-env-menu ${module} ${apl_roles} ${ctx_roles} "${f2}" "${f3}" "[${f1}]"
		    ;;

		_ITEM_BLANK_)
		    echo-left-menu ${module} ${apl_roles} ${ctx_roles} 0 "<li><a href='${f3}' target='_blank'>${f2//_/ }</a></li>"
		    echo-top-menu ${module} ${apl_roles} ${ctx_roles} "<li><a href='${f3}' target='_blank'>${f2//_/ }</a></li>"
		    echo-board-menu ${apl_roles} ${ctx_roles} 0 "<li><a href=\"${f3}\" target='_blank'>${f2//_/ }</a></li>"
		    gen-env-menu ${module} ${apl_roles} ${ctx_roles} "${f2}" "${f3}" "[${f1}]"
		    ;;

		_END_)
		    ;;
		*)
		    ;;
	    esac
	else
	    case ${etype} in

		_BEGIN_)
		    ;;

		_ITEM_)
		    image=${f4##*/}
		    image=${image/\?*}
		    image=${image/\.${GUI_EXT_NAME}/.png}
		    image=${image/\.html/.png}

		    page=${f4/\/${GUI_DIR_NAME}\//}
		    page=${page/\.${GUI_EXT_NAME}/}

		    echo-left-menu ${module} ${apl_roles} ${ctx_roles} 0 "<li><a href='${f4}'>${f3//_/ }</a></li>"
		    echo-top-menu ${module} ${apl_roles} ${ctx_roles} "<li><a href='${f4}'>${f3//_/ }</a></li>"
		    gen-env-menu ${module} ${apl_roles} ${ctx_roles} "${f3}" "${f4}" "[${f1}]/[${f2//_/ }]"

		    echo-board-icon ${apl_roles} ${ctx_roles} "<div class='item-board'><a href='${f4}'><center><img alt='${f3//_/ }' title='${f3//_/ }' src='/${IMAGE_DIR_NAME}/${image}' border='0' align='top' /></center><h4>${f3//_/ }</h4></a></div>"
		    ;;

		_END_)
		    ;;
		*)
		    ;;
	    esac
	fi

	if test ${i} -ge 1 ; then l=$[${i} - 1] ; else l=0 ; fi
	upper_page="${GUI_HOME_PAGE}.${GUI_EXT_NAME}?expanddiv=board-${l}"
	echo "${upper_page} ${page}.${GUI_EXT_NAME}" >> ${module}/${GENERATED_DIR}/${GUI_PAGES_HIERARCHY_FILENAME}.menu

    done < ${module}/${MENU_DIR}/menu

    echo-top-menu ${module} 3 3 "</ul>"

    echo-board-js 3 3 "animatedcollapse.addDiv('board-99', 'fade=1,speed=400,group=board,persist=${persist},hide=1');"
    echo-board-js 3 3 "animatedcollapse.init( );"
    echo-board-icon 3 3 "<div id='board-99'><div class='icon-board-title'><br /><div class='main-message'><br />${COMMERCIAL_NAME} Appliance<br />Select a menu item</div></div><br /></div>"

    if test -f ${module}/${GENERATED_DIR}/${GUI_PAGES_HIERARCHY_FILENAME}.menu ; then
	local extra_page_links_fn="${module}/${MENU_DIR}/menu.extra-pages-hierarchy"
	if test -f ${extra_page_links_fn} ; then
	    cat ${module}/${GENERATED_DIR}/${GUI_PAGES_HIERARCHY_FILENAME}.menu > ${module}/${GENERATED_DIR}/${GUI_PAGES_HIERARCHY_FILENAME}
	    local up_page sub_page
	    while read up_page sub_page
	    do
		echo ${up_page}.${GUI_EXT_NAME} ${sub_page}.${GUI_EXT_NAME}
	    done < ${extra_page_links_fn} >> ${module}/${GENERATED_DIR}/${GUI_PAGES_HIERARCHY_FILENAME}
	else
	    mv -f ${module}/${GENERATED_DIR}/${GUI_PAGES_HIERARCHY_FILENAME}.menu ${module}/${GENERATED_DIR}/${GUI_PAGES_HIERARCHY_FILENAME}
	fi
    fi

    local module title page path

    while read apl_roles ctx_roles title page path
    do
	gen-env-menu ${module} ${apl_roles} ${ctx_roles} "${title}" "${page}" "${path}"
    done < ${module}/${MENU_DIR}/menu.indirect-pages
}

install-gui()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    test -n "${4}" || return 4
    local gui_name=${1}
    local gui_rdir=${2}
    local static_rdir=${3}
    local full_app_dir=${4}
    local app_dir=${5}

    local full_dir=${APL}${full_app_dir}
    local www_dir=${full_dir}/${static_rdir}
    local etc_dir=${full_dir}/etc
    local etc_html_dir=${full_dir}/${ETC_HTML_RDIR}
    local cgi_dir=${full_dir}/${CGI_RDIR}
    local image_dir=${www_dir}/${IMAGE_DIR_NAME}
    local js_dir=${www_dir}/${JS_DIR_NAME}
    local core_pages=$(ls -1 ${gui_rdir}/${CORE_DIR}/*${GUI_CORE_EXT} 2> /dev/null)
    local dashboard_pages=$(ls -1 ${gui_rdir}/${DASHBOARD_DIR}/*${GUI_DASHBOARD_CORE_EXT} 2> /dev/null)

    mkdir -p ${gui_rdir}/${GENERATED_DIR}
    mkdir -p ${gui_rdir}/${CGI_GENERATED_DIR}

    sudo mkdir -p ${image_dir}
    sudo mkdir -p ${js_dir}
    sudo mkdir -p ${cgi_dir}
    sudo mkdir -p ${etc_html_dir}
    
    local page dashboard
    unset PAGES DASHBOARDS

    for page in ${core_pages}
    do
	PAGES="${PAGES} $(file-basename ${page} ${GUI_CORE_EXT})"
    done

    for dashboard in ${dashboard_pages}
    do
	DASHBOARDS="${DASHBOARDS} $(file-basename ${dashboard} ${GUI_DASHBOARD_CORE_EXT})"
    done

    for page in ${PAGES}
    do
	gen-cgi-page ${page} > ${gui_rdir}/${CGI_GENERATED_DIR}/${page}.${GUI_EXT_NAME}
	gen-submit-cgi-core-page ${page} > ${gui_rdir}/${CGI_GENERATED_DIR}/submit-${page}.${GUI_EXT_NAME}

	sudo install -m 645 -o root -g root ${gui_rdir}/${CGI_GENERATED_DIR}/${page}.${GUI_EXT_NAME} ${cgi_dir}
	sudo install -m 645 -o root -g root ${gui_rdir}/${CGI_GENERATED_DIR}/submit-${page}.${GUI_EXT_NAME} ${cgi_dir}
	sudo install -m 644 -o root -g root ${gui_rdir}/${CORE_DIR}/${page}${GUI_CORE_EXT} ${cgi_dir}

	if test -f ${gui_rdir}/${HELP_DIR}/${page}-help.html ; then
	    sudo install -m 644 -o root -g root ${gui_rdir}/${HELP_DIR}/${page}-help.html ${etc_html_dir}
	else
	    echo "*** ${gui_rdir}/${HELP_DIR}/${page}-help.html is missing"
	fi

	if test ${page} != "${GUI_HOME_PAGE}" -a ${page} != 'login' ; then
	    test -f ${gui_rdir}/Icons/${page}.png || echo "*** ${gui_rdir}/Icons/${page}.png is missing"
	fi
	sudo install -m 645 -o root -g root ${gui_rdir}/${CORE_DIR}/set-${page} ${cgi_dir}
    done

    for dashboard in ${DASHBOARDS}
    do
	gen-cgi-dashboard-page ${dashboard} > ${gui_rdir}/${CGI_GENERATED_DIR}/${dashboard}-dashboard.${GUI_EXT_NAME}
	sudo install -m 645 -o root -g root ${gui_rdir}/${CGI_GENERATED_DIR}/${dashboard}-dashboard.${GUI_EXT_NAME} ${cgi_dir}
	sudo install -m 644 -o root -g root ${gui_rdir}/${DASHBOARD_DIR}/${dashboard}${GUI_DASHBOARD_CORE_EXT} ${cgi_dir}
    done

    gen-functions ${gui_name} > ${gui_rdir}/${GENERATED_DIR}/functions
    sudo install -m 644 -o root -g root ${gui_rdir}/${GENERATED_DIR}/functions ${cgi_dir}
    sudo install -m 644 -o root -g root ${gui_rdir}/lib/${gui_name}-functions.${GUI_EXT_NAME} ${cgi_dir}
    gen-waf-rules-constant ${gui_name} ${gui_rdir} > ${gui_rdir}/${GENERATED_DIR}/${gui_name}.rules-constant

    sudo install -m 644 -o root -g root ${gui_rdir}/${GENERATED_DIR}/${gui_name}.rules-constant ${APL}${CONF_DIR}    
    sudo install -m 644 -o root -g root favicon.ico ${www_dir}

    local file files role

    files=$(ls Images/* Icons/* ${gui_rdir}/Icons/* 2> /dev/null)
    for file in ${files}
    do
	sudo install -m 644 -o root -g root ${file} ${image_dir}
    done

    sudo install -m 644 -o root -g root ${gui_rdir}/${GENERATED_DIR}/menu.env ${etc_dir}

    test ! -f ${gui_rdir}/${GENERATED_DIR}/top-menu.html || \
	sudo install -m 644 -o root -g root ${gui_rdir}/${GENERATED_DIR}/top-menu.html ${etc_html_dir}

    test ! -f ${gui_rdir}/${GENERATED_DIR}/left-menu.html || \
	sudo install -m 644 -o root -g root ${gui_rdir}/${GENERATED_DIR}/left-menu.html ${etc_html_dir}

    test ! -f ${gui_rdir}/${GENERATED_DIR}/board-menu.html || \
	sudo install -m 644 -o root -g root ${gui_rdir}/${GENERATED_DIR}/board-menu.html ${etc_html_dir}

    test ! -f ${gui_rdir}/${GENERATED_DIR}/board-icon.html || \
	sudo install -m 644 -o root -g root ${gui_rdir}/${GENERATED_DIR}/board-icon.html ${etc_html_dir}

    test ! -f ${gui_rdir}/${GENERATED_DIR}/board-menu.js || \
	sudo install -m 644 -o root -g root ${gui_rdir}/${GENERATED_DIR}/board-menu.js ${js_dir}

    for role in gateway manager
    do
	sudo install -m 644 -o root -g root ${gui_rdir}/${GENERATED_DIR}/menu.${role}.env ${etc_dir}

	test ! -f ${gui_rdir}/${GENERATED_DIR}/top-menu.${role}.html || \
	     sudo install -m 644 -o root -g root ${gui_rdir}/${GENERATED_DIR}/top-menu.${role}.html ${etc_html_dir}

	test ! -f ${gui_rdir}/${GENERATED_DIR}/left-menu.${role}.html || \
	    sudo install -m 644 -o root -g root ${gui_rdir}/${GENERATED_DIR}/left-menu.${role}.html ${etc_html_dir}

	test ! -f ${gui_rdir}/${GENERATED_DIR}/board-menu.${role}.html || \
	    sudo install -m 644 -o root -g root ${gui_rdir}/${GENERATED_DIR}/board-menu.${role}.html ${etc_html_dir}

	test ! -f ${gui_rdir}/${GENERATED_DIR}/board-icon.${role}.html || \
	     sudo install -m 644 -o root -g root ${gui_rdir}/${GENERATED_DIR}/board-icon.${role}.html ${etc_html_dir}

	test ! -f ${gui_rdir}/${GENERATED_DIR}/board-menu.${role}.js || \
	    sudo install -m 644 -o root -g root ${gui_rdir}/${GENERATED_DIR}/board-menu.${role}.js ${js_dir}
    done

    files=$(ls ${HTML_DIR}/*.html ${gui_rdir}/${HTML_DIR}/*.html 2> /dev/null)
    for file in ${files}
    do
	sudo install -m 644 -o root -g root ${file} ${etc_html_dir}
    done

    test ! -f ${gui_rdir}/${GENERATED_DIR}/${GUI_PAGES_HIERARCHY_FILENAME} || \
	sudo install -m 644 -o root -g root ${gui_rdir}/${GENERATED_DIR}/${GUI_PAGES_HIERARCHY_FILENAME} ${etc_dir}

    files=$(ls JS/*.js ${gui_rdir}/JS/*.js ${gui_rdir}/${GENERATED_DIR}/*.js 2> /dev/null)
    for file in ${files}
    do
	sudo install -m 644 -o root -g root ${file} ${js_dir}
    done

    files=$(ls lib/*.${GUI_EXT_NAME} ${gui_rdir}/${COMMON_DIR}/*.${GUI_EXT_NAME} 2> /dev/null)
    for file in ${files}
    do
	sudo install -m 644 -o root -g root ${file} ${cgi_dir}
    done

    files=$(ls ${gui_rdir}/Update/*.${GUI_EXT_NAME} ${gui_rdir}/Other/*.${GUI_EXT_NAME} 2> /dev/null)
    for file in ${files}
    do
	sudo install -m 645 -o root -g root ${file} ${cgi_dir}
    done

    files=$(ls ${CSS_DIR}/*.css 2> /dev/null)
    for file in ${files}
    do
	sudo install -m 644 -o root -g root ${file} ${www_dir}
    done
}

gen-license-core()
{
    test -L Administration/license.html || return 0

    local line after

    while read line
    do
	test -n "${line}" || continue
	test "${line:0:7}" != '</body>' || break

	if test "${line:0:6}" == '<body>' ; then
	    after=yes
	    continue
	fi
	test -n "${after}" || continue
	echo ${line}
    done < Administration/license.html
}

install-gui-etc()
{
    sudo install -m 444 -o root -g root Administration/ETC/gui-page-command-index ${APL}${ADMIN_DIR}${APPLIANCE_DIR}/etc/gui-page-command-index
    sudo install -m 444 -o root -g root Administration/${GENERATED_DIR}/license.html ${APL}${ADMIN_DIR}${GUI_DIR}/${ETC_HTML_RDIR}
}

# Main()

HELP_DIR=Help
CORE_DIR=Core
DASHBOARD_DIR=Dashboard
CSS_DIR=CSS
HTML_DIR=HTML
RULE_DIR=Rule
WAF_RULE_ID=600
HEADER_DIR=FileHeader
MENU_DIR=Menu
UPDATE_DIR=Update
COMMON_DIR=Common
DATE=$(date)

make-generated-directories

gen-js-constant Administration > Administration/${GENERATED_DIR}/apl-constant.js
gen-js-constant Auditing > Auditing/${GENERATED_DIR}/apl-constant.js
gen-js-mosaic-constant > Administration/${GENERATED_DIR}/mosaic-constant.js
gen-license-core > Administration/${GENERATED_DIR}/license.html
gen-menu Administration
gen-menu Auditing

install-gui ${WADMIN_NAME} Administration ${WWW_DIR_NAME} ${ADMIN_DIR}${GUI_DIR} ${GUI_DIR}
install-gui ${WAUDIT_NAME} Auditing       ${WAUDIT_NAME}  ${WEB_SERVER_DIR}

install-gui-etc
