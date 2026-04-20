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

print-state()
{
    local selected

    for state in off on
    do
	if test ${state} == "${1}" ; then
	    selected=selected
	else
	    unset selected
	fi
	echo -n "<option value='${state}' ${selected}>${state}</option>"
    done
}

show-cache-maxobject-form()
{
    local width

    itemWidth[0]=75
    itemWidth[1]=25

    itemTitle[0]="Min object size (KB)"
    itemTitle[1]="Max object size (KB)"
    itemTitle[2]="Caching Big Objects"
    itemTitle[3]="Reserved Area size for Big Objects (KB)"
    itemTitle[4]="Big Object Min size (KB)"
    itemTitle[5]="Big Object Max size (KB)"
    
    itemID[0]="object_min"
    itemID[1]="object_max"
    itemID[2]="state"
    itemID[3]="bigsize"
    itemID[4]="bigobject_min"
    itemID[5]="bigobject_max"

    local state

    local state min max big_min big_max

    if test -n "${VALUES[0]}" ; then
	min=${VALUES[0]}
    else
	min=${CACHE_MIN_OBJECT_SZ}
    fi

    if test -n "${VALUES[1]}" ; then
	max=${VALUES[1]}
    else
	max=${CACHE_MAX_OBJECT_SZ}
    fi

    if test -n "${VALUES[2]}" ; then
	state=${VALUES[2]}
    else
	if test "${CACHE_BIG_OBJECT}" == True ; then
	    state=on
	else
	    state=off
	fi
    fi

    if test -n "${VALUES[3]}" ; then
	big_min=${VALUES[3]}
    else
	big_min=${CACHE_BIG_MIN_OBJECT_SZ}
    fi

    if test -n "${VALUES[4]}" ; then
	big_max=${VALUES[4]}
    else
	big_max=${CACHE_BIG_MAX_OBJECT_SZ}
    fi

    blankItemContent[0]="type='text' size='6' maxlength='6' value='${min}' onMouseOver='showMinMaxToolTip( ${CACHE_MIN_OBJECT_SZ_MIN}, ${CACHE_MAX_OBJECT_SZ_MAX} );' onMouseOut='hideMinMaxToolTip( );'"
    blankItemContent[1]="type='text' size='6' maxlength='6' value='${max}' onMouseOver='showMinMaxToolTip( ${CACHE_MAX_OBJECT_SZ_MIN}, ${CACHE_MAX_OBJECT_SZ_MAX} );' onMouseOut='hideMinMaxToolTip( );'"
    blankItemContent[2]=$(print-state ${state})
    blankItemContent[3]="${PROXY_CACHE_UNIT_SZ}"
    blankItemContent[4]="type='text' size='10' maxlength='10' value='${big_min}'"
    blankItemContent[5]="type='text' size='10' maxlength='10' value='${big_max}' onMouseOver='showMinMaxToolTip( ${CACHE_MAX_OBJECT_SZ_MIN}, ${PROXY_CACHE_UNIT_SZ} );' onMouseOut='hideMinMaxToolTip( );'"

    checkItem[0]=digit
    checkItem[1]=digit
    checkItem[4]=digit
    checkItem[5]=digit

    itemForm[2]="select"
    itemForm[3]="text"

    if test ${state} == off ; then
	itemState[4]="disabled"
	itemState[5]="disabled"
    fi

    itemFormSelectCB[2]="cacheSizeCB( 'state', 'bigobject_min', 'bigobject_max' );"

    call-js-function "hideMinMaxToolTip( )"
    show-title "Cache Size Limits" "enabled" "cache"
    show-form "${width}"
}

# Main()

show-cache-maxobject-form
