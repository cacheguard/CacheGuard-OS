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

show-uniq-rweb-sites()
{
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
		member "${list}" ${name} || list="${list} ${name}"
		;;
	    *)
		;;
	esac
	((i++))
    done

    echo ${list:1}
}

rweb-site-nb()
{
    local i=0 nb=0
    local elt range
    local name

    local list

    for elt in ${RWEB_SITE_LIST}
    do
	range=$[${i} % 5]
	case ${range} in
	    0)
		name=${elt}
		;;
	    1|2|3)
		;;
	    4)
		if ! member "${list}" ${name} ; then
		    list="${list} ${name}"
		    ((nb++))

		fi
		;;
	    *)
		;;
	esac
	((i++))
    done

    echo ${nb}
}
