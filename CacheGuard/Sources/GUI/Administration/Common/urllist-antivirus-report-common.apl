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

show-antivirus-report-av-update()
{
    test -n "${1}" || return 1
    local display_type=${1}

    case ${APL_ROLE} in
	gateway)
	    if test ! -s ${AV_UPDATE_LOG} ; then
		echo-unavailable-message "the AV update report is not yet available."
		return 0
	    fi
	    ;;
	manager)
	    if ! is-av-extended-enabled cur ; then
		echo-unavailable-message "the Extended AV is not active."
		return 0
	    fi

	    if test ! -s ${AV_UPDATE_LOG} ; then
		echo-unavailable-message "the Extended AV report is not yet available."
		return 0
	    fi
	    ;;
	*)
	    ;;
    esac

    local date_s=$(date +"%s")
    local date_h=$(get-date-from-epoch-seconds ${date_s})
    local status date_update

    echo "<table class='report'>"

    case ${display_type} in
	summary)
	    case ${APL_ROLE} in
		gateway)
		    if test -s ${AV_AUTO_UPDATE_FILE} ; then
			status=OK
			execute-command-nolog "antivirus report"
			date_update=$(cat ${AV_AUTO_UPDATE_FILE} 2> /dev/null)
		date_update=$(get-date-from-epoch-seconds ${date_update})
		show-log-line 0 ${date_h} antivirus updated at ${date_update}[${status}]
		    else
			status=KO
			show-log-line 0 ${date_h} antivirus updating[${status}]
		    fi
		    ;;
		manager)
		    ;;
		*)
		    ;;
	    esac

	    if is-av-extended-enabled cur ; then
		if test -s ${AV_VAR_DIR}/${AV_EXTENDED_LAST_UPDATE_FILENAME} ; then

		    date_update=$(cat ${AV_VAR_DIR}/${AV_EXTENDED_LAST_UPDATE_FILENAME} 2> /dev/null)
		    if av-extended-is-auto-updated-in-time ${date_s} ${date_update} ; then
			status=OK
		    else
			status=KO
		    fi
		    date_update=$(get-date-from-epoch-seconds ${date_update})

		    show-log-line 0 ${date_h} Extended antivirus updated at ${date_update}[${status}]

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
				show-log-line 0 ${date_h} "Pushing Extended antivirus to '${id}' at ${push_date}${error_txt}[${status}]"
			    done < ${HOME}/${MANAGER_GATEWAY_INDEX}
			fi
		    fi
		else
		    status=KO
		    show-log-line 0 ${date_h} Extended antivirus updating[${status}]
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
    show-log ${URLLIST_AUTO_LOG}
}

show-urllist-antivirus-report()
{
    show-antivirus-report-av-update summary
    show-urllist-report-guard-auto
}
