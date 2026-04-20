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

show-rweb-via()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)
    local key=$(get-arg-value "${get_args}" key)

    local width=${DEFAULT_LIST_FORM_WIDTH_1} state

    local in_site_name=${key/§*}
    local in_rest=${key#*§}
    local in_site_ip=${in_rest/*§}

    if test -z "${in_site_name}" -o -z "${in_site_ip}"  ; then
	redirect-page "rweb-site"
        return 1
    fi

    local long_title="<font color='SeaGreen'>${in_site_name}</font> [<font color='SeaGreen'>${in_site_ip}</font>]"

    itemWidth[1]=50
    itemWidth[2]=20

    itemTitle[1]="Via Gateway"
    itemTitle[2]="Role"
    itemTitle[3]="Priority"

    itemID[0]="Site Name"
    itemID[1]="ip"
    itemID[2]="role"
    itemID[3]="priority"

    singleItemID[0]='site_name'
    singleItemValue[0]="${in_site_name}"

    singleItemID[1]='site_ip'
    singleItemValue[1]="${in_site_ip}"

    blankItemContent[0]=""

    blankItemContent[1]=$(get-external-gateways)
    blankItemContent[2]="master backup"
    blankItemContent[3]="type='text' size='3' maxlength='3'"
    
    itemForm[1]="select"
    itemForm[2]="select"

    checkItem[3]=digit

    local elt range i=0
    local site_name site_ip vias
    local via gateway role_prio role prio

    for elt in ${RWEB_SITE_VIA_LIST}
    do
	range=$[${i} % 3]
	case ${range} in
	    0)
		site_name=${elt}
		;;
	    1)
		site_ip=${elt}
		;;
	    2)
		vias=${elt}
		test "${site_name}" != ${in_site_name} -o "${site_ip}" != ${in_site_ip} || break
		;;
	    *)
		return 255
		;;
	esac
	((i++))
    done

    if test "${site_name}" == ${in_site_name} -a "${site_ip}" == ${in_site_ip} ; then
	vias=$(colon2space ${vias})
	for via in ${vias}
	do
	    gateway=${via/_*}
	    role_prio=${via#*_}
	    role=${role_prio/_*}
	    prio=${role_prio/*_}
	    listContent="${listContent} ${gateway} ${role} ${prio}"
	done
    fi
    listContent=${listContent:1}

    listContentStep=3
    test -n "${listContent}" || state=disabled

    show-title "Website Via Gateways" "${state}" "ip rweb"
    show-list-form ${MAX_IP_ROUTES_NB} "${width}" "${page_ref}" "<br />${long_title}"
}

show-rweb-via "${@}"
