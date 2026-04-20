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

show-antivirus-report-av-update()
{
    local display_type=${1}
    local table_width=${2}
    test -n "${table_width}" || table_width="100%"

    case ${APL_ROLE} in
	gateway)
	    if test ${CURRENT_AV_MODE} == False ; then
		echo-content-unavailable ${table_width} "<i>The AV is not active.</i>"
		return 0
	    fi
	    ;;
	manager)
	    if ! is-av-extended-enabled cur ; then
		echo-content-unavailable ${table_width} "<i>The Extended AV is not active.</i>"
		return 0
	    fi

	    if test ! -s ${AV_UPDATE_LOG} ; then
		echo-content-unavailable ${table_width} "<i>The Extended AV report is not yet available.</i>"
		return 0
	    fi
	    ;;
	*)
	    ;;
    esac

    local date_s=$(date +"%s")
    local date_h=$(get-date-from-epoch-seconds ${date_s})
    local status date_update

    echo "<table class='report' width='${table_width}'>"

    case ${APL_ROLE} in
	gateway)
	    if test -s ${AV_AUTO_UPDATE_FILE} ; then
		status=OK
		execute-command-nolog "antivirus report"
		date_update=$(cat ${AV_AUTO_UPDATE_FILE} 2> /dev/null)
		date_update=$(get-date-from-epoch-seconds ${date_update})
		show-log-line 0 ${date_h} Antivirus updated at ${date_update}[${status}]
	    else
		status=KO
		show-log-line 0 ${date_h} Antivirus updating[${status}]
	    fi
	    ;;
	manager)
	    ;;
	*)
	    ;;
    esac

    case ${display_type} in
	summary)
	    if is-av-extended-enabled cur ; then
		if test -s ${AV_VAR_DIR}/${AV_EXTENDED_LAST_UPDATE_FILENAME} ; then

		    date_update=$(cat ${AV_VAR_DIR}/${AV_EXTENDED_LAST_UPDATE_FILENAME} 2> /dev/null)
		    if av-extended-is-auto-updated-in-time ${date_s} ${date_update} ; then
			status=OK
		    else
			status=KO
		    fi
		    date_update=$(get-date-from-epoch-seconds ${date_update})

		    show-log-line 0 ${date_h} Extended Antivirus updated at ${date_update}[${status}]

		    if test ${APL_ROLE} == manager ; then
			if test -s ${HOME}/${MANAGER_GATEWAY_INDEX} ; then

			    local uuid domain id ip
			    local push_status push_date error_txt

			    while read uuid domain id ip
			    do
				test -n "${ip}" || continue
				test -s ${AV_VAR_DIR}/${id}.${MPUSHED_STATUS} || continue
				read push_status push_date < ${AV_VAR_DIR}/${id}.${MPUSHED_STATUS}
				push_date=$(get-date-from-epoch-seconds ${push_date})

				if test ${push_status} -eq 0 ; then
				    status=OK
				    unset error_txt
				else
				    status=KO
				    error_txt=" (${push_status})"
				fi
				show-log-line 0 ${date_h} "Pushing Extended Antivirus to '${id}' at ${push_date}${error_txt}[${status}]"
			    done < ${HOME}/${MANAGER_GATEWAY_INDEX}
			fi
		    fi
		else
		    status=KO
		    show-log-line 0 ${date_h} Extended Antivirus updating[${status}]
		fi
	    fi
	    ;;
	details)
	    show-log1 ${AV_UPDATE_LOG}
	    ;;
	*)
	    ;;
    esac

    echo "</table>"
}

show-urllist-report-guard-auto()
{
    local table_width=${1}
    show-log ${URLLIST_AUTO_LOG} ${table_width}
}

show-urllist-antivirus-report()
{
    local table_width=${1}

    echo "<div class='core-form'>"

    show-antivirus-report-av-update summary ${table_width}
    show-urllist-report-guard-auto ${table_width}

    echo "</div>"
}
