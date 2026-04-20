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

get-ip-filter()
{
    test -n "${1}" || return 1
    local in_filter_name=${1}

    local filter_name ip_key ip1 ip2
    local i=0 elt range

    for elt in ${GUARD_FILTER_IP_LIST}
    do
	range=$[${i} % 4]
	case ${range} in
	    0)
		filter_name=${elt}
		;;
	    1)
		ip_key=${elt}
		;;
	    2)
		ip1=${elt}
		;;
	    3)
		ip2=${elt}
		if test ${filter_name} == ${in_filter_name} ; then
		    case ${ip_key} in
			range)
			    if test ${ip1} == ${ip2} ; then
				echo "[ip] ${ip1}"
			    else
				echo "[range] ${ip1}-${ip2}"
			    fi
			    ;;
			network)
			    echo "[network] ${ip1}/${ip2}"
			    ;;
			*)
			    ;;
		    esac
		    break
		fi
		    ;;
	    *)
		break
		;;
	esac
	((i++))
    done
}

get-time-filter()
{
    test -n "${1}" || return 1
    local in_filter_name=${1}

    local filter_name type time
    local i=0 elt range

    for elt in ${GUARD_FILTER_TIME_LIST}
    do
	range=$[${i} % 3]
	case ${range} in
	    0)
		filter_name=${elt}
		;;
	    1)
		type=${elt}
		;;
	    2)
		time=${elt}
		if test ${filter_name} == ${in_filter_name} ; then
		    echo "[${type}] ${time}"
		    break
		fi
		    ;;
	    *)
		break
		;;
	esac
	((i++))
    done
}

get-ldap-filter()
{
    test -n "${1}" || return 1
    local in_filter_name=${1}

    local filter_name group login filter
    local i=0 elt range

    for elt in ${GUARD_FILTER_LDAP_LIST}
    do
	range=$[${i} % 4]
	case ${range} in
	    0)
		filter_name=${elt}
		;;
	    1)
		group=${elt}
		;;
	    2)
		login=${elt}
		;;
	    3)
		filter=${elt}
		if test ${filter_name} == ${in_filter_name} ; then
		    echo "[group dn ${group}], [login attribute ${login}], [ldap filter ${filter}]"
		    break
		fi
		    ;;
	    *)
		break
		;;
	esac
	((i++))
    done
}
