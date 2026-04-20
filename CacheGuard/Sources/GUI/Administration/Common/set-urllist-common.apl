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

load-urllist-content()
{
    local name=${VALUES[0]}
    local operation=${VALUES[1]}
    local protocol=${VALUES[2]:1}
    local ip=${VALUES[3]}
    local fn=${VALUES[4]}

    local i pos attr attrs
    local verify
    local domains
    local urls
    local expressions

    if test "${operation}" == clear ; then
	pos=2
    else
	pos=5
    fi
	
    for ((i=pos ; i<${ATTRIBUTE_NB} ; i++))
    do
	attr=${ATTRIBUTES[${i}]}
	local ${attr}=${attr}
	attrs="${attrs} ${attr}"
    done

    test -n "${fn}" || fn=${name}

    if test "${operation}" == clear ; then
	log-command "urllist" "${operation} ${name}${attrs}"
	execute-command "urllist ${operation} ${name}${attrs}"
    else
	if test -z "${verify}" ; then
	    local load='load'
	else
	    local load='vload'
	fi
	
	log-command "urllist" "${load} ${operation} ${name} ${protocol} ${ip} ${fn} ${domains} ${urls} ${expressions}"
	execute-command "urllist ${load} ${operation} ${name} ${protocol} ${ip} ${fn} ${domains} ${urls} ${expressions}"
    fi
}
