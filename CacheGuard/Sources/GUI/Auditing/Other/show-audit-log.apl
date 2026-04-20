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

source functions

waf-get-generic-rule-name()
{
    test -n "${1}" || return 1
    local file=${1}

    local i len=${#WAF_GENERIC_FILTER_FILE[@]}

    for ((i=0; i<len; i++))
    do
	if test ${file} == ${WAF_GENERIC_FILTER_FILE[${i}]} ; then
	    echo ${WAF_GENERIC_FILTER_NAME[${i}]}
	    return 0
	fi
    done

    return 11
}

show-audit()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 1
    local name=${1}
    local log_file=${2}

    local bg_color="style='background-color:Lavender;'"
    local audit_file=${WAUDITDIR}/${name}${log_file}
    test -f ${audit_file} || return 2

    local line date ip request filter state nohtml
    local boundary content_type cppost_first
    local nb=0

    local cpost ipost cppost
    declare -a cpost cppost ipost

    local b=0 c=0 i=0 cp=0 f=0

    dos2unix ${audit_file}
    while read line
    do
	test -n "${line}" || continue

	if test "${line:0:34}" == "Content-Type: multipart/form-data;" ; then
	    boundary="--${line:44}"
	fi

	case "${line:0:2}" in
	    --)
		case "${line:11:1}" in
		    A)
			state=A
			unset date
			;;
		    B)
			state=B
			unset request
			b=0
			;;
		    C)
			state=C
			unset cpost
			c=0
			;;
		    E)
			state=E
			;;
		    I)
			state=I
			unset ipost
			i=0
			;;
		    H)
			state=H
			unset filter
			f=0
			;;
		    Z)
			state=Z
			break
			;;
		    *)
			if test "${line}" == "${boundary}" ; then
			    unset content_type cppost_first
			    if test "${state}" == "C" ; then
				state=CP
				unset cppost
				cp=0
			    fi
			    if test -n "${cp}" -a $[${cp} % 2] -ne 0 ; then
				cppost[${cp}]="value="
				((cp++))
			    fi
			fi
			;;
		esac

		;;
	    *)
		case ${state} in
		    A)
			date=${line/ */}
			date=${date:1}
			ip="${line/*] /}"
			ip=${ip#* }
			ip=${ip/ */}
			;;
		    B)
			request[${b}]=${line}
			((b++))
			;;
		    C)
                        cpost[${c}]=$(no-html-format "$(url-decode "${line}")")
			((c++))
			;;
		    E)
			;;
		    I)
                        ipost[${i}]=$(no-html-format "$(url-decode "${line}")")
			((i++))
			;;
		    CP)
			if test "${line:0:31}" == "Content-Disposition: form-data;" ; then
			    cppost[${cp}]=${line:32}
			    ((cp++))
			elif test "${line:0:13}" == "Content-Type:" ; then
			    content_type=${line:14}
			elif test -n "${content_type}" ; then
			    if test -z "${cppost_first}" ; then
				cppost_first=true
				cppost[${cp}]="value=${line:0:16}...<i>(16 first chars)</i>"
				((cp++))
			    fi
			else
			    cppost[${cp}]="value=${line}"
			    ((cp++))
			fi
			;;
		    H)
			filter[${f}]=${line}
			((f++))
			;;
		    *)
			;;
		esac
		;;
	esac
    done < ${audit_file}

    local title_pct=15
    local value_pct=85

    local style="style='word-wrap:break-word;'"
    
    local method=${request[0]/ */}
    local uri=${request[0]/${method} /}
    local version=${uri/* /}
    uri=${uri/ */}
    uri=$(no-html-format "$(url-decode "${uri}")")
    
    echo "<table class='highlight-list' style='table-layout:fixed; width:750px; margin-bottom:10px;'>"

    echo "<thead>"
    echo "<tr>"
    echo "<td width='${title_pct}%' ${bg_color}><strong>Request</strong></td>"
    echo "<td width='${value_pct}%' ${bg_color}><span ${style}>${method} ${uri}</span></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td ${bg_color}><strong>Date</strong></td>"
    echo "<td ${bg_color}><span ${style}>${date}</td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td ${bg_color}><strong>Version</strong></td>"
    echo "<td ${bg_color}><span ${style}>${version}</td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td ${bg_color}><strong>Client IP</strong></td>"
    echo "<td ${bg_color}><span ${style}>${ip}</td>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    local i message status
    local file line id rev msg data severity version maturity accuray
    local rulematch generic_filter

    for ((i=0;i<f;i++))
    do
	message=${filter[${i}]}
	test "${message:0:8}" == "Message:" || continue

	if test ${nb} -ne 0 ; then
	    echo "<tr>"
	    echo "<td ${bg_color}></td>"
	    echo "<td ${bg_color}></td>"
	    echo "</tr>"
	fi

	status=${message/ \(*/}
	status=${status:16}
	status=${status/ */}

        if test "${message:9:7}" == "Access " -o "${message:9:8}" == "Warning." ; then
	    rest=${message##* \[file\ \"}
	    file=${rest/ *}
	    file=${file/\"\]}

	    rest=${rest##* \[line\ \"}
	    line=${rest/ *}
	    line=${line/\"\]}

	    rest=${rest##* \[id\ \"}
	    id=${rest/ *}
	    id=${id/\"\]}

            rest=${rest##* \[rev\ \"}
	    rev=${rest/ *}
	    rev=${rev/\"\]}

            rest=${rest##* \[msg\ \"}
	    msg=${rest# *}
	    msg=${msg/\"\]*}

            rest=${rest##* \[data\ \"}
	    data=${rest/ *}
	    data=${data/\"\]}

            rest=${rest##* \[severity\ \"}
	    severity=${rest/ *}
	    severity=${severity/\"\]}

            rest=${rest##* \[version\ \"}
	    version=${rest/ *}
	    version=${version/\"\]}

            rest=${rest##* \[maturity\ \"}
	    maturity=${rest/ *}
	    maturity=${maturity/\"\]}

            rest=${rest##* \[accuray\ \"}
	    accuray=${rest/ *}
	    accuray=${accuray/\"\]}
	else
	    severity="<i>unknown</i>"
	    id=0
	    msg=${message:9}
	fi

	echo "<tr>"
	echo "<td><strong>Rule ID</strong></td>"
	echo "<td><span ${style}>${id}</span></td>"
	echo "</tr>"

	echo "<tr>"
	echo "<td><strong>Status</strong></td>"
	echo "<td><span ${style}>"
	case ${status} in
	    allowed)
		echo "<font color='DarkSlateGray'>"
		;;
	    denied)
		echo "<font color='FireBrick'>"
		;;
	    *)
		if test "${message:9:8}" == "Warning." ; then
		    status=allowed
		    echo "<font color='DarkSlateGray'>"
		else
		    status='<i>unknown</i>'
		    echo "<font color='DarkSlateGray'>"
		fi
		;;
	esac
	echo "${status}</font></span></td>"
	echo "</tr>"

	echo "<tr>"
	echo "<td><strong>Severity</strong></td>"
	echo "<td><span ${style}>${severity}</span></td>"
	echo "</tr>"

	if test ${id} -lt ${WAF_RULE_ID_INIT} ; then
	    generic_filter=$(file-basename ${file} .conf)
	    generic_filter=$(waf-get-generic-rule-name ${generic_filter})

	    if test -n "${generic_filter}" ; then
		echo "<tr>"
		echo "<td><strong>Generic Filter</strong></td>"
		echo "<td><span ${style}>${generic_filter}</span></td>"
		echo "</tr>"
	    fi
	fi
	echo "<tr>"
	echo "<td><strong>Message</strong></td>"
	echo "<td><span ${style}>${msg}</span></td>"
	echo "</tr>"

	((nb++))
    done

    if test -n "${ipost}" ; then
	echo "<tr>"
	echo "<td><strong>Post Args</strong></td>"
	echo "<td><span ${style}>${ipost[0]}</span></td>"
	echo "</tr>"
    fi

    if test -n "${cpost}" ; then
	echo "<tr>"
	echo "<td><strong>Post Args</strong></td>"
	echo "<td><span ${style}>${cpost[0]}</span></td>"
	echo "</tr>"
    elif test -n "${cppost}" ; then
	echo "<tr>"
	echo "<td><strong>Post Content</strong></td>"
	echo "<td><span ${style}>"
	for ((i=0;i<cp;i++))
	do
	    echo "${cppost[${i}]}<br />"
	    test $[${i} % 2] -eq 0 || echo "<br />"
	done
	echo "</span></td>"
	echo "</tr>"
    fi

    echo "</table>"
    echo "</tbody>"
}

check-cgi-security
verify-authentication
test ${?} -eq 0 || exit 1
echo-http-header
show-audit "${@}"
