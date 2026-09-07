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

get-traffic-name()
{
    test -n "${1}" || return 1
    local in_name=${1}

    case ${in_name} in
	all:|admin:|mon:|etc:|file:|vpnipsec:)
	    len=${#in_name}
	    ((len--))
	    echo ${in_name:0:${len}}
	    return 0
	    ;;
	*)
	    ;;
    esac

    case ${in_name:0:5} in
	rweb:|tweb:)
	    echo ${in_name:0:4}
	    return 0
	    ;;
	*)
	    ;;
    esac

    if test ${in_name:0:4} == web: ; then
	echo ${in_name:0:3}
    elif test ${in_name:0:5} == peer: ; then
	echo ${in_name:0:4}
    elif test ${in_name:0:7} == routed: ; then
	echo ${in_name:0:6}
    elif test ${in_name:0:10} == antivirus: ; then
	echo ${in_name:0:9}
    elif test ${in_name:0:16} == default-steered: ; then
	echo 'default'
    elif test ${in_name:0:15} == default-routed: ; then
	echo 'default'
    else
	echo 'unknown'
    fi
}

show-qos-report()
{
    local diff=${1} checked qos_traffic_filename
    local get_checkbox_id=diff
    local refresh_time=$(date +"%H:%M:%S" 2> /dev/null)
    local pie_height=250
    local pie_width=${pie_height}

    if test "${diff}" == "${get_checkbox_id}"; then
	diff=' diff'
	checked=' checked'
	qos_traffic_filename=${QOS_DIFF_TRAFFIC_FILENAME}
    else
	qos_traffic_filename=${QOS_TRAFFIC_FILENAME}
    fi

    show-title "QoS Shaping Report" disabled "qos" '' enable ${get_checkbox_id}
    execute-command-nolog "qos report${diff}"

    echo "<div class='core-form'>"

    # Time Display Part

    echo "<table class='highlight-form'>"
    echo "<tr>"
    echo "<td>Appliance Refresh Time</td>"
    echo "<td align='right'>${refresh_time}</td>"
    echo "</tr>"
    echo "<tr>"
    echo "<td><label for='${get_checkbox_id}'>Show Differentials?</label></td>"
    echo "<td align='right'><input id='${get_checkbox_id}' type='checkbox'${checked} /></td>"
    echo "</tr>"
    echo "</table>"

    if test ! -f ${RUN_DIR}/${qos_traffic_filename} ; then
	echo-unavailable-message "the QoS report is unavailable."
	echo "</div>"
	return 0
    fi

    # Get Values Part

    local tabs_id='interfacetabs'
    local interfaces="external internal auxiliary"

    local flow interface ibytes obytes
    local ikbits okbits
    local name

    local      externalFlow internalFlow auxiliaryFlow
    declare -a externalFlow internalFlow auxiliaryFlow

    local      externalIngressRate internalIngressRate auxiliaryIngressRate
    declare -a externalIngressRate internalIngressRate auxiliaryIngressRate

    local      externalEgressRate internalEgressRate auxiliaryEgressRate
    declare -a externalEgressRate internalEgressRate auxiliaryEgressRate

    local external_nb=0 internal_nb=0 auxiliary_nb=0 i

    local      externalIngressPieFlow internalIngressPieFlow auxiliaryIngressPieFlow
    declare -a externalIngressPieFlow internalIngressPieFlow auxiliaryIngressPieFlow

    local      externalEgressPieFlow internalEgressPieFlow auxiliaryEgressPieFlow
    declare -a externalEgressPieFlow internalEgressPieFlow auxiliaryEgressPieFlow

    local      externalIngressPieRate internalIngressPieRate auxiliaryIngressPieRate
    declare -a externalIngressPieRate internalIngressPieRate auxiliaryIngressPieRate

    local      externalEgressPieRate internalEgressPieRate auxiliaryEgressPieRate
    declare -a externalEgressPieRate internalEgressPieRate auxiliaryEgressPieRate

    local external_ingress_pie_nb=0 internal_ingress_pie_nb=0 auxiliary_ingress_pie_nb=0
    local external_egress_pie_nb=0 internal_egress_pie_nb=0 auxiliary_egress_pie_nb=0

    local external_pie_default_ingress=0  external_pie_default_egress=0
    local external_pie_rweb_ingress=0  external_pie_rweb_egress=0
    local external_pie_web_ingress=0  external_pie_web_egress=0
    local external_pie_peer_next_ingress=0  external_pie_peer_next_egress=0
    local external_pie_antivirus_ingress=0  external_pie_antivirus_egress=0
    local external_pie_routed_ingress=0  external_pie_routed_egress=0

    local internal_pie_default_ingress=0  internal_pie_default_egress=0
    local internal_pie_tweb_ingress=0  internal_pie_tweb_egress=0
    local internal_pie_rweb_ingress=0  internal_pie_rweb_egress=0
    local internal_pie_web_ingress=0  internal_pie_web_egress=0
    local internal_pie_peer_ingress=0 internal_pie_peer_egress=0
    local internal_pie_antivirus_ingress=0  internal_pie_antivirus_egress=0
    local internal_pie_routed_ingress=0  internal_pie_routed_egress=0

    local auxiliary_pie_default_ingress=0  auxiliary_pie_default_egress=0
    local auxiliary_pie_tweb_ingress=0 auxiliary_pie_tweb_egress=0
    local auxiliary_pie_web_ingress=0 auxiliary_pie_web_egress=0
    local auxiliary_pie_antivirus_ingress=0  auxiliary_pie_antivirus_egress=0
    local auxiliary_pie_routed_ingress=0 auxiliary_pie_routed_egress=0

    while read flow interface ibytes obytes
    do
	((ikbits = ibytes * 8)) ; ((ikbits /= 1024)) ; test $((ikbits % 1024)) -lt 512 || ((ikbits++))
	((okbits = obytes * 8)) ; ((okbits /= 1024)) ; test $((okbits % 1024)) -lt 512 || ((okbits++))

	name=$(get-traffic-name ${flow})

	case ${interface} in

	    external)
		externalFlow[${external_nb}]=${flow}
		externalIngressRate[${external_nb}]=${ikbits}
		externalEgressRate[${external_nb}]=${okbits}
		((external_nb++))

		case ${name} in
		    admin|etc|file|vpnipsec)
			if test ${ikbits} -ne 0 ; then
			    externalIngressPieFlow[${external_ingress_pie_nb}]=${flow}
			    externalIngressPieRate[${external_ingress_pie_nb}]=${ikbits}
			    ((external_ingress_pie_nb++))
			fi
			if test ${okbits} -ne 0 ; then
			    externalEgressPieFlow[${external_egress_pie_nb}]=${flow}
			    externalEgressPieRate[${external_egress_pie_nb}]=${okbits}
			    ((external_egress_pie_nb++))
			fi
			;;
		    default)
			((external_pie_default_ingress += ikbits))
			((external_pie_default_egress += okbits))
			;;
		    web)
			((external_pie_web_ingress += ikbits))
			((external_pie_web_egress += okbits))
			;;
		    peer)
			((external_pie_peer_next_ingress += ikbits))
			((external_pie_peer_next_egress += okbits))
			;;
		    rweb)
			((external_pie_rweb_ingress += ikbits))
			((external_pie_rweb_egress += okbits))
			;;
		    antivirus)
			((external_pie_antivirus_ingress += ikbits))
			((external_pie_antivirus_egress += okbits))
			;;
		    routed)
			((external_pie_routed_ingress += ikbits))
			((external_pie_routed_egress += okbits))
			;;
		    *)
			;;
		esac
		;;

	    internal|web|rweb|antivirus|admin|mon|file|peer)
		internalFlow[${internal_nb}]=${flow}
		internalIngressRate[${internal_nb}]=${ikbits}
		internalEgressRate[${internal_nb}]=${okbits}
		((internal_nb++))

		case ${name} in
		    admin|mon|etc|file)
			if test ${ikbits} -ne 0 ; then
			    internalIngressPieFlow[${internal_ingress_pie_nb}]=${name}
			    internalIngressPieRate[${internal_ingress_pie_nb}]=${ikbits}
			    ((internal_ingress_pie_nb++))
			fi
			if test ${okbits} -ne 0 ; then
			    internalEgressPieFlow[${internal_egress_pie_nb}]=${name}
			    internalEgressPieRate[${internal_egress_pie_nb}]=${okbits}
			    ((internal_egress_pie_nb++))
			fi
			;;
		    default)
			((internal_pie_default_ingress += ikbits))
			((internal_pie_default_egress += okbits))
			;;
		    web)
			((internal_pie_web_ingress += ikbits))
			((internal_pie_web_egress += okbits))
			;;
		    tweb)
			((internal_pie_tweb_ingress += ikbits))
			((internal_pie_tweb_egress += okbits))
			;;
		    rweb)
			((internal_pie_rweb_ingress += ikbits))
			((internal_pie_rweb_egress += okbits))
			;;
		    peer)
			((internal_pie_peer_ingress += ikbits))
			((internal_pie_peer_egress += okbits))
			;;
		    antivirus)
			((internal_pie_antivirus_ingress += ikbits))
			((internal_pie_antivirus_egress += okbits))
			;;
		    routed)
			((internal_pie_routed_ingress += ikbits))
			((internal_pie_routed_egress += okbits))
			;;
		    *)
			;;
		esac
		;;

	    auxiliary)
		auxiliaryFlow[${auxiliary_nb}]=${flow}
		auxiliaryIngressRate[${auxiliary_nb}]=${ikbits}
		auxiliaryEgressRate[${auxiliary_nb}]=${okbits}
		((auxiliary_nb++))

		case ${name} in
		    admin|etc|file)
			if test ${ikbits} -ne 0 ; then
			    auxiliaryIngressPieFlow[${auxiliary_ingress_pie_nb}]=${flow}
			    auxiliaryIngressPieRate[${auxiliary_ingress_pie_nb}]=${ikbits}
			    ((auxiliary_ingress_pie_nb++))
			fi
			if test ${okbits} -ne 0 ; then
			    auxiliaryEgressPieFlow[${auxiliary_egress_pie_nb}]=${flow}
			    auxiliaryEgressPieRate[${auxiliary_egress_pie_nb}]=${okbits}
			    ((auxiliary_egress_pie_nb++))
			fi
			;;
		    default)
			((auxiliary_pie_default_ingress += ikbits))
			((auxiliary_pie_default_egress += okbits))
			;;
		    web)
			((auxiliary_pie_web_ingress += ikbits))
			((auxiliary_pie_web_egress += okbits))
			;;
		    tweb)
			((auxiliary_pie_tweb_ingress += ikbits))
			((auxiliary_pie_tweb_egress += okbits))
			;;
		    antivirus)
			((auxiliary_pie_antivirus_ingress += ikbits))
			((auxiliary_pie_antivirus_egress += okbits))
			;;
		    routed)
			((auxiliary_pie_routed_ingress += ikbits))
			((auxiliary_pie_routed_egress += okbits))
			;;
		    *)
			;;
		esac
		;;
	    *)
		;;
	esac
    done < ${RUN_DIR}/${qos_traffic_filename}

    # External Interface

    if test ${external_pie_default_ingress} -ne 0 ; then
	externalIngressPieFlow[${external_ingress_pie_nb}]=default
	externalIngressPieRate[${external_ingress_pie_nb}]=${external_pie_default_ingress}
	((external_ingress_pie_nb++))
    fi
    if test ${external_pie_default_egress} -ne 0 ; then
	externalEgressPieFlow[${external_egress_pie_nb}]=default
	externalEgressPieRate[${external_egress_pie_nb}]=${external_pie_default_egress}
	((external_egress_pie_nb++))
    fi

    if test ${external_pie_rweb_ingress} -ne 0 ; then
	externalIngressPieFlow[${external_ingress_pie_nb}]=rweb
	externalIngressPieRate[${external_ingress_pie_nb}]=${external_pie_rweb_ingress}
	((external_ingress_pie_nb++))
    fi
    if test ${external_pie_rweb_egress} -ne 0 ; then
	externalEgressPieFlow[${external_egress_pie_nb}]=rweb
	externalEgressPieRate[${external_egress_pie_nb}]=${external_pie_rweb_egress}
	((external_egress_pie_nb++))
    fi
    
    if test ${external_pie_web_ingress} -ne 0 ; then
	externalIngressPieFlow[${external_ingress_pie_nb}]=web
	externalIngressPieRate[${external_ingress_pie_nb}]=${external_pie_web_ingress}
	((external_ingress_pie_nb++))
    fi
    if test ${external_pie_web_egress} -ne 0 ; then
	externalEgressPieFlow[${external_egress_pie_nb}]=web
	externalEgressPieRate[${external_egress_pie_nb}]=${external_pie_web_egress}
	((external_egress_pie_nb++))
    fi

    if test ${external_pie_peer_next_ingress} -ne 0 ; then
	externalIngressPieFlow[${external_ingress_pie_nb}]=peer
	externalIngressPieRate[${external_ingress_pie_nb}]=${external_pie_peer_next_ingress}
	((external_ingress_pie_nb++))
    fi
    if test ${external_pie_peer_next_egress} -ne 0 ; then
	externalEgressPieFlow[${external_egress_pie_nb}]=peer
	externalEgressPieRate[${external_egress_pie_nb}]=${external_pie_peer_next_egress}
	((external_egress_pie_nb++))
    fi

    if test ${external_pie_antivirus_ingress} -ne 0 ; then
	externalIngressPieFlow[${external_ingress_pie_nb}]=antivirus
	externalIngressPieRate[${external_ingress_pie_nb}]=${external_pie_antivirus_ingress}
	((external_ingress_pie_nb++))
    fi
    if test ${external_pie_antivirus_egress} -ne 0 ; then
	externalEgressPieFlow[${external_egress_pie_nb}]=antivirus
	externalEgressPieRate[${external_egress_pie_nb}]=${external_pie_antivirus_egress}
	((external_egress_pie_nb++))
    fi

    if test ${external_pie_routed_ingress} -ne 0 ; then
	externalIngressPieFlow[${external_ingress_pie_nb}]=routed
	externalIngressPieRate[${external_ingress_pie_nb}]=${external_pie_routed_ingress}
	((external_ingress_pie_nb++))
    fi
    if test ${external_pie_routed_egress} -ne 0 ; then
	externalEgressPieFlow[${external_egress_pie_nb}]=routed
	externalEgressPieRate[${external_egress_pie_nb}]=${external_pie_routed_egress}
	((external_egress_pie_nb++))
    fi

    # Internal Interface

    if test ${internal_pie_default_ingress} -ne 0 ; then
	internalIngressPieFlow[${internal_ingress_pie_nb}]=default
	internalIngressPieRate[${internal_ingress_pie_nb}]=${internal_pie_default_ingress}
	((internal_ingress_pie_nb++))
    fi
    if test ${internal_pie_default_egress} -ne 0 ; then
	internalEgressPieFlow[${internal_egress_pie_nb}]=default
	internalEgressPieRate[${internal_egress_pie_nb}]=${internal_pie_default_egress}
	((internal_egress_pie_nb++))
    fi

    if test ${internal_pie_web_ingress} -ne 0 ; then
	internalIngressPieFlow[${internal_ingress_pie_nb}]=web
	internalIngressPieRate[${internal_ingress_pie_nb}]=${internal_pie_web_ingress}
	((internal_ingress_pie_nb++))
    fi
    if test ${internal_pie_web_egress} -ne 0 ; then
	internalEgressPieFlow[${internal_egress_pie_nb}]=web
	internalEgressPieRate[${internal_egress_pie_nb}]=${internal_pie_web_egress}
	((internal_egress_pie_nb++))
    fi    

    if test ${internal_pie_tweb_ingress} -ne 0 ; then
	internalIngressPieFlow[${internal_ingress_pie_nb}]=tweb
	internalIngressPieRate[${internal_ingress_pie_nb}]=${internal_pie_tweb_ingress}
	((internal_ingress_pie_nb++))
    fi
    if test ${internal_pie_tweb_egress} -ne 0 ; then
	internalEgressPieFlow[${internal_egress_pie_nb}]=tweb
	internalEgressPieRate[${internal_egress_pie_nb}]=${internal_pie_tweb_egress}
	((internal_egress_pie_nb++))
    fi

    if test ${internal_pie_rweb_ingress} -ne 0 ; then
	internalIngressPieFlow[${internal_ingress_pie_nb}]=rweb
	internalIngressPieRate[${internal_ingress_pie_nb}]=${internal_pie_rweb_ingress}
	((internal_ingress_pie_nb++))
    fi
    if test ${internal_pie_rweb_egress} -ne 0 ; then
	internalEgressPieFlow[${internal_egress_pie_nb}]=rweb
	internalEgressPieRate[${internal_egress_pie_nb}]=${internal_pie_rweb_egress}
	((internal_egress_pie_nb++))
    fi
    
    if test ${internal_pie_peer_ingress} -ne 0 ; then
	internalIngressPieFlow[${internal_ingress_pie_nb}]=peer
	internalIngressPieRate[${internal_ingress_pie_nb}]=${internal_pie_peer_ingress}
	((internal_ingress_pie_nb++))
    fi
    if test ${internal_pie_peer_egress} -ne 0 ; then
	internalEgressPieFlow[${internal_egress_pie_nb}]=peer
	internalEgressPieRate[${internal_egress_pie_nb}]=${internal_pie_peer_egress}
	((internal_egress_pie_nb++))
    fi

    if test ${internal_pie_antivirus_ingress} -ne 0 ; then
	internalIngressPieFlow[${internal_ingress_pie_nb}]=antivirus
	internalIngressPieRate[${internal_ingress_pie_nb}]=${internal_pie_antivirus_ingress}
	((internal_ingress_pie_nb++))
    fi
    if test ${internal_pie_antivirus_egress} -ne 0 ; then
	internalEgressPieFlow[${internal_egress_pie_nb}]=antivirus
	internalEgressPieRate[${internal_egress_pie_nb}]=${internal_pie_antivirus_egress}
	((internal_egress_pie_nb++))
    fi
    
    if test ${internal_pie_routed_ingress} -ne 0 ; then
	internalIngressPieFlow[${internal_ingress_pie_nb}]=routed
	internalIngressPieRate[${internal_ingress_pie_nb}]=${internal_pie_routed_ingress}
	((internal_ingress_pie_nb++))
    fi
    if test ${internal_pie_routed_egress} -ne 0 ; then
	internalEgressPieFlow[${internal_egress_pie_nb}]=routed
	internalEgressPieRate[${internal_egress_pie_nb}]=${internal_pie_routed_egress}
	((internal_egress_pie_nb++))
    fi

    # Auxiliary Interface

    if test ${auxiliary_pie_default_ingress} -ne 0 ; then
	auxiliaryIngressPieFlow[${auxiliary_ingress_pie_nb}]=default
	auxiliaryIngressPieRate[${auxiliary_ingress_pie_nb}]=${auxiliary_pie_default_ingress}
	((auxiliary_ingress_pie_nb++))
    fi
    if test ${auxiliary_pie_default_egress} -ne 0 ; then
	auxiliaryEgressPieFlow[${auxiliary_egress_pie_nb}]=default
	auxiliaryEgressPieRate[${auxiliary_egress_pie_nb}]=${auxiliary_pie_default_egress}
	((auxiliary_egress_pie_nb++))
    fi

    if test ${auxiliary_pie_web_ingress} -ne 0 ; then
	auxiliaryIngressPieFlow[${auxiliary_ingress_pie_nb}]=web
	auxiliaryIngressPieRate[${auxiliary_ingress_pie_nb}]=${auxiliary_pie_web_ingress}
	((auxiliary_ingress_pie_nb++))
    fi
    if test ${auxiliary_pie_web_egress} -ne 0 ; then
	auxiliaryEgressPieFlow[${auxiliary_egress_pie_nb}]=web
	auxiliaryEgressPieRate[${auxiliary_egress_pie_nb}]=${auxiliary_pie_web_egress}
	((auxiliary_egress_pie_nb++))
    fi

    if test ${auxiliary_pie_tweb_ingress} -ne 0 ; then
	auxiliaryIngressPieFlow[${auxiliary_ingress_pie_nb}]=tweb
	auxiliaryIngressPieRate[${auxiliary_ingress_pie_nb}]=${auxiliary_pie_tweb_ingress}
	((auxiliary_ingress_pie_nb++))
    fi
    if test ${auxiliary_pie_tweb_egress} -ne 0 ; then
	auxiliaryEgressPieFlow[${auxiliary_egress_pie_nb}]=tweb
	auxiliaryEgressPieRate[${auxiliary_egress_pie_nb}]=${auxiliary_pie_tweb_egress}
	((auxiliary_egress_pie_nb++))
    fi

    if test ${auxiliary_pie_antivirus_ingress} -ne 0 ; then
	auxiliaryIngressPieFlow[${auxiliary_ingress_pie_nb}]=antivirus
	auxiliaryIngressPieRate[${auxiliary_ingress_pie_nb}]=${auxiliary_pie_antivirus_ingress}
	((auxiliary_ingress_pie_nb++))
    fi
    if test ${auxiliary_pie_antivirus_egress} -ne 0 ; then
	auxiliaryEgressPieFlow[${auxiliary_egress_pie_nb}]=antivirus
	auxiliaryEgressPieRate[${auxiliary_egress_pie_nb}]=${auxiliary_pie_antivirus_egress}
	((auxiliary_egress_pie_nb++))
    fi

    if test ${auxiliary_pie_routed_ingress} -ne 0 ; then
	auxiliaryIngressPieFlow[${auxiliary_ingress_pie_nb}]=routed
	auxiliaryIngressPieRate[${auxiliary_ingress_pie_nb}]=${auxiliary_pie_routed_ingress}
	((auxiliary_ingress_pie_nb++))
    fi
    if test ${auxiliary_pie_routed_egress} -ne 0 ; then
	auxiliaryEgressPieFlow[${auxiliary_egress_pie_nb}]=routed
	auxiliaryEgressPieRate[${auxiliary_egress_pie_nb}]=${auxiliary_pie_routed_egress}
	((auxiliary_egress_pie_nb++))
    fi

    # Pie Display Part

    echo "<div class='table-title'>QoS Traffic Summary</div>"

    echo "<table class='highlight-list center'>"
    echo "<thead>"
    echo "<tr>"
    echo "<th class='table-header'>Logical Interface</th>"
    echo "<th class='table-header'>Ingress (Incoming) in Kbits</th>"
    echo "<th class='table-header'>Egress (Outgoing) in Kbits</th>"
    echo "</tr>"
    echo "</thead>"
    echo "<tbody>"

    local pie_ingress pie_egress
    local pie_ingress_nb pie_egress_nb

    for interface in ${interfaces}
    do
	case ${interface} in
	    external)
		pie_ingress_nb=${external_ingress_pie_nb}
		pie_egress_nb=${external_egress_pie_nb}
		;;
	    internal)
		pie_ingress_nb=${internal_ingress_pie_nb}
		pie_egress_nb=${internal_egress_pie_nb}
		;;
	    auxiliary)
		pie_ingress_nb=${auxiliary_ingress_pie_nb}
		pie_egress_nb=${auxiliary_egress_pie_nb}
		;;
	    *)
		;;
	esac

	if test ${pie_ingress_nb} -eq 0 ; then
	    pie_ingress="<i>No Traffic</i>"
	else
	    pie_ingress="<div id='${interface}_ingress_pie'></div>"
	fi

	if test ${pie_egress_nb} -eq 0 ; then
	    pie_egress="<i>No Traffic</i>"
	else
	    pie_egress="<div id='${interface}_egress_pie'></div>"
	fi

	echo "<tr>"
	echo "<td align='center' bgcolor='Gainsboro'>${interface^}</td>"	
	echo "<td align='center'>${pie_ingress}</td>"
	echo "<td align='center'>${pie_egress}</td>"
	echo "</tr>"

    done

    echo "</tbody>"
    echo "</table>"

    for interface in ${interfaces}
    do
	case "${interface}" in
            external)
		ingress_nb="${external_ingress_pie_nb}"
		ingress_flow=( "${externalIngressPieFlow[@]}" )
		ingress_rate=( "${externalIngressPieRate[@]}" )

		egress_nb="${external_egress_pie_nb}"
		egress_flow=( "${externalEgressPieFlow[@]}" )
		egress_rate=( "${externalEgressPieRate[@]}" )
		;;

            internal)
		ingress_nb="${internal_ingress_pie_nb}"
		ingress_flow=( "${internalIngressPieFlow[@]}" )
		ingress_rate=( "${internalIngressPieRate[@]}" )

		egress_nb="${internal_egress_pie_nb}"
		egress_flow=( "${internalEgressPieFlow[@]}" )
		egress_rate=( "${internalEgressPieRate[@]}" )
		;;

            auxiliary)
		ingress_nb="${auxiliary_ingress_pie_nb}"
		ingress_flow=( "${auxiliaryIngressPieFlow[@]}" )
		ingress_rate=( "${auxiliaryIngressPieRate[@]}" )

		egress_nb="${auxiliary_egress_pie_nb}"
		egress_flow=( "${auxiliaryEgressPieFlow[@]}" )
		egress_rate=( "${auxiliaryEgressPieRate[@]}" )
		;;
            *)
		continue
		;;
	esac

	echo "<script type='application/json' data-init-qos-pie-chart>"
	echo "{"
	echo "\"bindto\":\"#${interface}_ingress_pie\","
	echo "\"data\":{"
	echo "\"columns\":["

	for ((i=0 ; i<ingress_nb ; i++))
	do
            printf '["%s",%s]' \
		   "${ingress_flow[i]}" \
		   "${ingress_rate[i]}"

            if test $((i + 1)) -lt "${ingress_nb}"
            then
		echo ","
            else
		echo
            fi
	done

	echo "],"
	echo "\"type\":\"pie\""
	echo "},"
	echo "\"size\":{"
	echo "\"height\":${pie_height},"
	echo "\"width\":${pie_width}"
	echo "}"
	echo "}"
	echo "</script>"

	echo "<script type='application/json' data-init-qos-pie-chart>"
	echo "{"
	echo "\"bindto\":\"#${interface}_egress_pie\","
	echo "\"data\":{"
	echo "\"columns\":["

	for ((i=0 ; i<egress_nb ; i++))
	do
            printf '["%s",%s]' \
		   "${egress_flow[i]}" \
		   "${egress_rate[i]}"

            if test $((i + 1)) -lt "${egress_nb}"
            then
		echo ","
            else
		echo
            fi
	done

	echo "],"
	echo "\"type\":\"pie\""
	echo "},"
	echo "\"size\":{"
	echo "\"height\":${pie_height},"
	echo "\"width\":${pie_width}"
	echo "}"
	echo "}"
	echo "</script>"
    done

    # Table Display Part

    echo "<br /><div class='table-title'>QoS Traffic Details</div>"

    echo "<div class='core-form'>"
    echo "<ul id='${tabs_id}' class='shadetabs'>"
    for interface in ${interfaces}
    do
	echo "<li><a href='#' rel='${interface}' class='selected'>${interface^}</a></li>"
    done
    echo "</ul>"
    echo "</div>"

    echo "<div class='core-form'>"
    for interface in ${interfaces}
    do
	echo "<div id='${interface}' class='tabcontent'>"
	echo "<table class='highlight-list'>"
	echo "<thead>"
	echo "<tr>"
	echo "<th class='table-header'>Traffic</th>"
	echo "<th class='table-header'>Ingress (Incoming)<br /> in Kbits</th>"
	echo "<th class='table-header'>Egress (Outgoing)<br />in Kbits</th>"
	echo "</tr>"
	echo "</thead>"
	echo "<tbody>"

	case ${interface} in
	    external)
		for ((i=0 ; i<external_nb ; i++))
		do
		    echo "<tr>"
		    echo "<td>${externalFlow[${i}]}</td><td align='right'>${externalIngressRate[${i}]}</td><td align='right'>${externalEgressRate[${i}]}</td>"
		    echo "</tr>"
		done
		;;
	    internal)
		for ((i=0 ; i<internal_nb ; i++))
		do
		    echo "<tr>"
		    echo "<td>${internalFlow[${i}]}</td><td align='right'>${internalIngressRate[${i}]}</td><td align='right'>${internalEgressRate[${i}]}</td>"
		    echo "</tr>"
		done
		;;
	    auxiliary)
		for ((i=0 ; i<auxiliary_nb ; i++))
		do
		    echo "<tr>"
		    echo "<td>${auxiliaryFlow[${i}]}</td><td align='right'>${auxiliaryIngressRate[${i}]}</td><td align='right'>${auxiliaryEgressRate[${i}]}</td>"
		    echo "</tr>"
		done
		;;
	    *)
		;;
	esac

	echo "</tbody>"
	echo "</table>"
	echo "</div>"
    done
    echo "</div>"

    # Table Tab Display Part

    echo "<div id='${tabs_id}' data-ddtabcontent='${tabs_id}' data-persist='true' data-selected-class-target='link'></div>"
    echo "</div>"
}

# Main()

show-qos-report "${@}"
