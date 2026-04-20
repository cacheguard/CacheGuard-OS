#!/bin/bash

###########################################################################
#
# MODULE:       Patch
# AUTHOR(S):    CacheGuard Development Team
# COPYRIGHT:    (C) 2009-2023 by CacheGuard Technologies Ltd
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
source ${APPLIANCE_DIR}/etc/role

gen-cloud-conf-1()
{
    echo "CLOUD_NAME="
    echo "CLOUD_USAGE="
    echo "CLOUD_VALID_IP="
    echo "CLOUD_PROVISION_STATE="

    echo "CLOUD_CONSOLE="

    echo "CLOUD_NETWORK_MAIN_DEV=eth0"
    echo "CLOUD_NETWORK_MAIN_IP="
    echo "CLOUD_NETWORK_MAIN_MASK="
    echo "CLOUD_NETWORK_MAIN_GATEWAY="

    echo "CLOUD_NETWORK_SECOND_DEV=eth1"
    echo "CLOUD_NETWORK_SECOND_IP="
    echo "CLOUD_NETWORK_SECOND_MASK="
}

gen-cloud-conf()
{
    test ! -f ${HARD_DIR}/cloud.conf || return 0

    local tmp_cloud_conf=/tmp/cloud_conf.${$}
    gen-cloud-conf-1 > ${tmp_cloud_conf}

    install -m 644 -o root -g root ${tmp_cloud_conf} ${HARD_DIR}/cloud.conf

    if test ${APL_ROLE} == manager ; then

	local hard_dirs=$(ls -1d ${ABASE_DIR}/${MANAGER_GATEWAY_RDIR}/*/${HARD_DIR_NAME} 2> /dev/null)

	for hard_dir in ${hard_dirs}
	do
	    test ! -f ${hard_dir}/cloud.conf || continue
	    install -m 644 -o root -g root ${tmp_cloud_conf} ${hard_dir}/cloud.conf
	done
    fi

    rm -f ${tmp_cloud_conf}
}

update-model-conf()
{
    local model_file model_files="${HARD_DIR}/model.conf"
    local pattern="HDD_INFOS="
    local len_pattern=${#pattern}

    local hdd_infos len_hdd_infos disk_infos
    local disk_type disk_id disk_size
    local elt range i=0

    if test ${APL_ROLE} == manager ; then
	local gateway_model_files=$(ls -1 ${ABASE_DIR}/${MANAGER_GATEWAY_RDIR}/*/${HARD_DIR_NAME}/model.conf 2> /dev/null)
	test -z "${gateway_model_files}" || \
	    model_files="${model_files} ${gateway_model_files}"
    fi

    for model_file in ${model_files}
    do
	unset disk_infos

	while read line
	do
	    if test "${line:0:${len_pattern}}" == "${pattern}" ; then
		hdd_infos=${line:${len_pattern}}
		len_hdd_infos=${#hdd_infos}
		((len_hdd_infos -= 2))
		hdd_infos=${hdd_infos:1:${len_hdd_infos}}
		
		for elt in ${hdd_infos}
		do
		    range=$[${i} % 3]
		    case ${range} in
			0)
			    disk_type=${elt}
			    ;;
			1)
			    disk_id=${elt}
			    ;;
			2)
			    disk_size=${elt}
			    disk_infos="${disk_infos} ${disk_type} x:${disk_id} ${disk_size}"
			    ;;
			*)
			    return 255
			    ;;
		    esac
		    ((i++))
		done
		disk_infos=${disk_infos:1}
		echo "DISK_INFOS=\"${disk_infos}\""
	    else
		echo ${line}
	    fi
	done < ${model_file} > ${model_file}.upgraded
	mv -f ${model_file}.upgraded ${model_file}
    done
}

main()
{
    gen-cloud-conf
    update-model-conf
}

main
