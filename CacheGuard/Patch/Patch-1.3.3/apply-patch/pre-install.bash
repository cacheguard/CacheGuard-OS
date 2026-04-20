#!/bin/bash

############################################################################
#
# MODULE:       Patch
# AUTHOR(S):    Afshin Tajvidi, <afshin.tajvidi(at)cacheguard.com>
# COPYRIGHT:    (C) 2009-2017 by the CacheGuard Technologies Limited
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

CACHEGUARD_DIR=/etc/sysconfig/cacheguard
source ${CACHEGUARD_DIR}/constant
source ${CACHEGUARD_DIR}/TUNER.env

cache-conf-retune()
{
    test -f /etc/fs-size || return 11

    local cache_nb cache_sz_mb cache_sz_kb
    local fs sz
    local i index nb1=0
    local max_cache_sz=0 total_cache_sz_mb=0

    local cache_sz_a
    declare -a cache_sz_a

    local cache_ratio=$((100 - CACHE_FS_RATIO_PCT))
    local fs_ratio=$((100 - FS_EXT3_SZ_PCT))
    local cache_prefix=${PROXY_CACHE_DIR}/d
    local cache_prefix_len=${#cache_prefix}

    while read fs sz
    do
	test ${fs:0:${cache_prefix_len}} == ${cache_prefix} || continue
	test -d ${fs} || continue

	cache_nb=$(ls -1 ${fs} | wc -l)

	((cache_sz_kb = sz / cache_nb * fs_ratio / 100))
	((cache_sz_kb = cache_sz_kb * cache_ratio / 100))
	((cache_sz_mb = cache_sz_kb / 1024))

	for ((i=0 ; i< cache_nb ; i++))
	do
	    ((index = i + nb1))
	    cache_sz_a[${index}]=${cache_sz_mb}
	done	

	test ${cache_sz_mb} -le ${max_cache_sz} || max_cache_sz=${cache_sz_mb}
	((total_cache_sz += cache_sz_kb * cache_nb))

	((nb1 += cache_nb))
    done < /etc/fs-size

    ((total_cache_sz /= 1024))

    nb2=$(wc -l ${CONF_DIR}/squid.conf-cache-tuned 2> /dev/null)
    nb2=${nb2/ *}

    test ${nb1} -eq ${nb2} || return 13

    local tag program dir rest

    i=0
    while read tag program dir sz rest
    do
	cache_sz_mb=${cache_sz_a[${i}]}

	if test ${cache_sz_mb} -le 0 ; then
	    echo ${tag} ${program} ${dir} 1 ${rest}
	else
	    echo ${tag} ${program} ${dir} ${cache_sz_mb} ${rest}
	fi

	((i++))
    done < ${CONF_DIR}/squid.conf-cache-tuned > /root/squid.conf-cache-tuned

    cp -f ${ETC_DIR}/model.conf /root/model.conf &&
	sed -i \
	    -e "s/^LARGEST_CACHE_DIR_SZ=.*$/LARGEST_CACHE_DIR_SZ=${max_cache_sz}/" \
	    -e "s/^MAIN_CACHE_SZ=.*$/MAIN_CACHE_SZ=${total_cache_sz}/" \
	    /root/model.conf || return 15

    mv -f /root/squid.conf-cache-tuned ${CONF_DIR}/squid.conf-cache-tuned
    mv -f /root/model.conf ${ETC_DIR}/model.conf
}

# Main()

cache-conf-retune
