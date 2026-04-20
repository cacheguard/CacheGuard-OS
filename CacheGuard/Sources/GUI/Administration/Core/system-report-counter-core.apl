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

show-system-report-counter()
{
    local width=${1}
    test -n "${width}" || width="400"

    local unavailable_width=$[${width}-10]

    echo "<div class='core-form'>"

    if test ${CURRENT_LOG_MODE} == False ; then
	echo "<div class='core-form'>"
	echo-content-unavailable ${unavailable_width} "The logging mode is not activated."
        echo "</div>"
	return 0
    fi

    local height=200
    local log logs
    local log_name counter_file
    local message seconds nb date value color
    local title

    local log_name_a date_a nb_a color_a array_len
    declare -a log_name_a date_a nb_a color_a

    test ${CURRENT_LOG_TYPE_WEB/:*} == False || logs="${logs} ${WEB_LOG}"
    test ${CURRENT_LOG_TYPE_RWEB/:*} == False || logs="${logs} ${RWEB_LOG}"

    logs="${logs:1}"

    if test -z "${logs}" ; then
	echo "<div class='core-form'>"
	echo-content-unavailable ${unavailable_width} "The Web and rWeb access logging are not activated."
        echo "</div>"
    else
	echo "<table class='highlight-form' width='${width}'>"
	for log in ${logs}
	do
	    log_name=${log/\.log}
	    counter_file=${RUN_DIR}/${log_name}.log
	    
	    case "${log_name}" in
		web|rweb)
		    message="Total number of accessed URL [${log_name}]"
		    ;;
		*)
		    return 1
		    ;;
	    esac

	    if test -f ${counter_file}.${COUNTER_POSTFIX} ; then
		nb=$(cat ${counter_file}.${COUNTER_POSTFIX} 2> /dev/null)
	    else
		nb=0
	    fi

	    if test -f ${counter_file}.${COUNTER_DATE_POSTFIX} ; then
		seconds=$(cat ${counter_file}.${COUNTER_DATE_POSTFIX} 2> /dev/null)
		date=$(get-date-from-epoch-seconds ${seconds})
	    else
		date=""
	    fi

	    value=$(format-number ${nb})
	    test -z "${date}" || value="${value} since ${date}"

	    echo "<tr>"
	    echo "<td>${message}</td>"
	    echo "<td>${value}</td>"
	    echo "</tr>"
	done
	echo "</table>"
    fi

    unset logs
    local logs

    test ${CURRENT_LOG_TYPE_FIREWALL/:*} == False || logs="${logs} ${FIREWALL_LOG}"
    test ${CURRENT_LOG_TYPE_GUARD/:*} == False || logs="${logs} ${ACCESS_GUARD_LOG}"
    test ${CURRENT_LOG_TYPE_ANTIVIRUS/:*} == False || logs="${logs} ${ANTI_VIRUS_LOG}"
    test ${CURRENT_LOG_TYPE_ANTIVIRUS_SERVER/:*} == False || logs="${logs} ${ANTI_VIRUS_SERVER_LOG}"
    test ${CURRENT_LOG_TYPE_WAF/:*} == False || logs="${logs} ${WAF_LOG}"

    logs="${logs:1}"

    if test -z "${logs}" ; then
	echo "<div class='core-form'>"
	echo-content-unavailable ${unavailable_width} "No blocked access logging is activated."
        echo "</div>"
    else

	for log in ${logs}
	do
	    log_name=${log/\.log}
	    counter_file=${RUN_DIR}/${log_name}.log

	    if test -f ${counter_file}.${COUNTER_POSTFIX} ; then
		nb=$(cat ${counter_file}.${COUNTER_POSTFIX} 2> /dev/null)
	    else
		nb=0
	    fi

	    if test -f ${counter_file}.${COUNTER_DATE_POSTFIX} ; then
		seconds=$(cat ${counter_file}.${COUNTER_DATE_POSTFIX} 2> /dev/null)
		if test ${seconds} -eq 0 ; then
		    date=""
		else
		    seconds=$(cat ${counter_file}.${COUNTER_DATE_POSTFIX} 2> /dev/null)
		    date=$(get-date-from-epoch-seconds ${seconds})
		fi
	    else
		date=""
	    fi

	    case ${log} in
		${FIREWALL_LOG})
		    color="SeaGreen"
		    ;;
		${ANTI_VIRUS_LOG})
		    color="FireBrick"
		    ;;
		${ANTI_VIRUS_SERVER_LOG})
		    color="Orange"
		    ;;
		${ACCESS_GUARD_LOG})
		    color="Purple"
		    ;;
		${WAF_LOG})
		    color="SteelBlue"
		    ;;
		*)
		    color="Black"
		    ;;
	    esac

	    log_name_a[${i}]=${log_name}
	    nb_a[${i}]=${nb}
	    date_a[${i}]=${date}
	    color_a[${i}]=${color}
	    ((i++))
	done
	array_len=${#log_name_a[@]}

	title="Blocked Traffic Types"

	echo "<br />"
	echo "<table class='highlight-form' width='${width}'>"
	echo "<tr><td class='table-header' style='line-height:25px;'><center>${title}</center></td></tr>"
	echo "<tr><td>"
	for ((i=0 ; i <array_len ; i++))
	do
	    nb=$(format-number ${nb_a[${i}]})
            if test -z "${date_a[${i}]}" ; then
                echo "<abbr title='${nb} blocked'><font color='${color_a[${i}]}'>${log_name_a[${i}]}</font></abbr>"
            else
                echo "<abbr title='${nb} blocked since ${date_a[${i}]}'><font color='${color_a[${i}]}'>${log_name_a[${i}]}</font></abbr>"
            fi
	done

	echo "</tr>"
	echo "</table>"

	local n=$(record-length-list 1 "${logs}") i=0
	local counters_id='counters'

	echo "<div id='${counters_id}' style='float:left; width:${width}px; height:${height}px; margin:0; padding:0;'></div>"
	echo "<div style='clear:left;'></div>"
	echo "<script type='text/javascript'>"

	echo "var bar_counter = c3.generate( {"
	echo "bindto: '#${counters_id}',"
	echo "data: {"
	echo "columns: ["

	for ((i=0 ; i <array_len ; i++))
	do
	    echo -n "['${log_name_a[${i}]}', ${nb_a[${i}]}]"
	    if test $[${i} + 1] -eq ${n} ; then echo ; else echo "," ; fi
	done

	echo "],"
	echo "type: 'bar',"
	echo "labels: false,"
	echo "colors: {"

	for ((i=0 ; i <array_len ; i++))
	do
	    echo -n "'${log_name_a[${i}]}': '${color_a[${i}]}'"
	    if test $[${i} + 1] -eq ${n} ; then echo ; else echo "," ; fi
	done

	echo "}"
	echo "},"

	echo "bar: {"
	echo "width: {"
	echo "ratio: 0.5"
	echo "}"
	echo "}"

	echo "} );"
	echo "</script>"
    fi
	
    echo "</div>"
}

system-report-counter()
{
    shortcutMenuItem[0]="system-report-counter-raz"
    shortcutMenuTitle[0]="Reset Counters"

    show-title "Traffic Counters" "disabled" "log system"
    show-shortcuts-menu
    show-system-report-counter 500
}

# Main()

system-report-counter
