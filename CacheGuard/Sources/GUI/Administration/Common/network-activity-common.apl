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

gui-get-dynamic-dns-report()
{
    test ${CURRENT_DYNAMIC_DNS_STATE} == True || return 0

    test -n "${1}" || return 1
    local nic_name=${1}

    case ${APL_ROLE} in
	gateway)
	    test ${nic_name} == external || return 0
	    ;;
	manager)
	    test ${nic_name} == internal || return 0
	    ;;
	*)
	    return 11
	    ;;
    esac

    local report image ret

    report=$(get-dynamic-dns-report)
    ret=${?}

    case ${ret} in
	11)
	    image="<img src='${IMAGE_DIR}/ko.png' title='IP Resolution Error' alt='' />"
	    ;;
	13)
	    image="<img src='${IMAGE_DIR}/ko.png' title='IP Resolution Error' alt='' />"
	    ;;
	15)
	    image="<img src='${IMAGE_DIR}/ko.png' title='Updating Error' alt='' />"
	    ;;
	*)
	    local ip=${report/:*}
	    report=${report#*:}

	    if test ${ret} -eq 21 ; then
		image="<img src='${IMAGE_DIR}/ko.png' title='${CURRENT_DYNAMIC_DNS_HOSTNAME} [${ip}]: ${report}' alt='' />"
	    else
		image="<img src='${IMAGE_DIR}/ok.png' title='${CURRENT_DYNAMIC_DNS_HOSTNAME} [${ip}]: ${report}' alt='' />"
	    fi
	    ;;
    esac

    echo " - DynDNS ${image}"

    return ${ret}
}

show-network-activity()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local nic_name=${1}
    local bond_index=${2}
    local devs=${3}
    local compact=${4}

    local precision_time=60
    local graph_width graph_height=300
    local step=$[${precision_time} / ${STATISTICS_INTERVAL}]
    local nic

    if test -z "${compact}" ; then
	graph_width=700
    else
	graph_width=${DASHBOARD_WINDOW_WIDTH}
    fi

    if test -z ${devs} ; then
	echo-unavailable-message "This network interface is not currently in use."
	return 11
    fi
    
    if test ${step} -lt 1 ; then
	echo-unavailable-message "The time precision is lower than the interval."
	return 13
    fi

    if is-bond-dev "${devs}" ; then
	nic="bond${bond_index}"
    else
	nic="${devs}"
    fi

    local stat_file=${RUN_DIR}/${NETWORK_STATISTICS_FILENAME}.${nic}

    if test ! -f ${stat_file} ; then
	echo-unavailable-message "This network activity representation is temporarily unavailable."
	return 15
    fi

    local y_unit y_unit_label x_unit_label="Time"

    local rx_name="Reception (${STATISTICS_INTERVAL} sec avg)"
    local tx_name="Transmission (${STATISTICS_INTERVAL} sec avg)"

    local rx_color="FireBrick"
    local tx_color="SeaGreen"

    local graph_id="network-io-${nic_name}"
    local record_nb=$[(${STATISTICS_HISTORY} / ${STATISTICS_INTERVAL}) + (${precision_time} / ${STATISTICS_INTERVAL})]
    local tmp_file="/tmp/$(file-basename ${stat_file})-gui.${$}"

    local bw_rw bw_tr i=0 j
    local date rx tx
    local prev_date prev_rx prev_tx
    local interval minimal=0

    local      date_table rx_table tx_table
    declare -a date_table rx_table tx_table

    local      bw_date_table bw_rx_table bw_tx_table
    declare -  bw_date_table bw_rx_table bw_tx_table

    tail -${record_nb} ${stat_file} > ${tmp_file}
    while read date rx tx
    do
	date_table[${i}]=${date}
	rx_table[${i}]=${rx}
	tx_table[${i}]=${tx}
	((i++))
    done < ${tmp_file}
    rm -f ${tmp_file}

    local nb=${i}

    if test ${nb} -le ${step} ; then
	echo-unavailable-message "There is not enough data to draw a chart."
	return 15
    fi

    for ((i=1 ; i<nb ; i++))
    do
	date=${date_table[${i}]}
	rx=${rx_table[${i}]}
	tx=${tx_table[${i}]}

	((j=i-1))

	prev_date=${date_table[${j}]}
	prev_rx=${rx_table[${j}]}
	prev_tx=${tx_table[${j}]}

	interval=$[${date} - ${prev_date}]

	bw_date_table[${j}]=$[(${date} + ${prev_date}) * 1000 / 2]

	bw_rx_table[${j}]=$[(${rx} - ${prev_rx}) * 8 / 1000 / ${interval}]
	bw_tx_table[${j}]=$[(${tx} - ${prev_tx}) * 8 / 1000 / ${interval}]

	test ${bw_rx_table[${j}]} -ge ${minimal} || minimal=bw_rx_table[${j}]
	test ${bw_tx_table[${j}]} -ge ${minimal} || minimal=bw_tx_table[${j}]
    done

    ((nb--))

    if test ${minimal} -le 1000 ; then
	y_unit_label="Kbps"
	y_unit=1
    else
	y_unit_label="Mbps"
	y_unit=1000
    fi	

    echo "<div id='${graph_id}' class='graph-line-report'></div>"

    local average range stotal
    local rest=$[${step} - 1]

    cat << EOT
<script type='application/json' data-init-graph-chart>
{
EOT
    echo "\"bindto\": \"#${graph_id}\","
    echo "\"data\": {"
    echo "\"x\": \"date\","
    echo "\"xFormat\": \"%s\","
    echo "\"columns\": ["

    stotal=0
    printf "[\"date\""
    for ((i=0 ; i<nb ; i++))
    do
	range=$((i % step))
	stotal=$((stotal + bw_date_table[i]))

	if test ${range} -eq ${rest}; then
	    average=$((stotal / step))
	    stotal=0
	    printf ", %s" "${average}"
	fi
    done
    echo "],"

    stotal=0
    printf "[\"${rx_name}\""
    for ((i=0 ; i<nb ; i++))
    do
	range=$((i % step))
	stotal=$((stotal + bw_rx_table[i]))

	if test ${range} -eq ${rest}; then
	    average=$((stotal / step))
	    stotal=0
	    printf ", %s" "${average}"
	fi
    done
    echo "],"

    stotal=0
    printf "[\"${tx_name}\""
    for ((i=0 ; i<nb ; i++))
    do
	range=$((i % step))
	stotal=$((stotal + bw_tx_table[i]))

	if test ${range} -eq ${rest}; then
	    average=$((stotal / step))
	    stotal=0
	    printf ", %s" "${average}"
	fi
    done
    echo "]"

    echo "],"
    echo "\"type\": \"line\","
    echo "\"colors\": {"
    echo "\"${rx_name}\": \"${rx_color}\","
    echo "\"${tx_name}\": \"${tx_color}\""
    echo "}"
    echo "},"
    echo "\"axis\": {"
    echo "\"x\": {"
    echo "\"label\": \"${x_unit_label}\","
    echo "\"type\": \"timeseries\","
    echo "\"tick\": {"
    echo "\"format\": \"%H:%M\""
    echo "},"
    echo "\"localtime\": true"
    echo "},"
    echo "\"y\": {"
    echo "\"label\": \"${y_unit_label}\""
    echo "}"
    echo "},"
    echo "\"size\": {"
    echo "\"height\": ${graph_height},"
    echo "\"width\": ${graph_width}"
    echo "}"

    cat << EOT
}
</script>
EOT
}

show-network-activity-external()
{
    local compact=${1}
    test -z "${compact}" || compact=" ${compact}"

    local bond_index=$(get-bond-index external)
    local dyndns_report=$(gui-get-dynamic-dns-report external)

    echo "<div class='table-title${compact}'><strong>External</strong> [${CURRENT_BOND_EXTERNALS}]${dyndns_report}</div>"
    show-network-activity external ${bond_index} "${CURRENT_BOND_EXTERNALS}"${compact}
}

show-network-activity-internal()
{
    local compact=${1}
    test -z "${compact}" || compact=" ${compact}"

    local bond_index=$(get-bond-index internal)
    local dyndns_report=$(gui-get-dynamic-dns-report internal)

    echo "<div class='table-title${compact}'><strong>Internal</strong> [${CURRENT_BOND_INTERNALS}]${dyndns_report}</div>"
    show-network-activity internal ${bond_index} "${CURRENT_BOND_INTERNALS}"${compact}
}

show-network-activity-auxiliary()
{
    local compact=${1}
    test -z "${compact}" || compact=" ${compact}"

    local bond_index=$(get-bond-index auxiliary)

    echo "<div class='table-title${compact}'><strong>Auxiliary</strong> [${CURRENT_BOND_AUXILIARIES}]</div>"
    show-network-activity auxiliary ${bond_index} "${CURRENT_BOND_AUXILIARIES}"${compact}
}
