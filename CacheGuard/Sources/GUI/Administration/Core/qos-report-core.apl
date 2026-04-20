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

get-traffic-name()
{
    test -n "${1}" || return 1
    local in_name=${1}

    local name;

    case ${in_name} in
	all:|admin:|gateway:|default:|etc:|file:|vpnipsec:)
	    len=${#in_name}
	    ((len--))
	    name=${in_name:0:${len}}
	    ;;
	*)
	    ;;
    esac

    case ${in_name:0:5} in
	rweb:|tweb:)
	    name=${in_name:0:4}
	    ;;
	*)
	    ;;
    esac

    test ${in_name:0:3} != web || name=${in_name:0:3}
    test ${in_name:0:5} != peer: || name=${in_name:0:4}
    test ${in_name:0:7} != router: || name=${in_name:0:6}
    test ${in_name:0:10} != antivirus: || name=${in_name:0:9}
    
    echo ${name}
}

show-qos-report()
{
    local diff=${1} checked qos_traffic_filename
    local get_checkbox_id=diff
    local width=${DEFAULT_LIST_FORM_WIDTH}
    local td_style="style='height:20px;'"
    local refresh_time=$(date +"%H:%M:%S" 2> /dev/null)

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

    echo "<div style='float:left;'>"
    echo "<table class='highlight-form' style='margin-bottom:5px;' width='$((width/2 -1))'>"
    echo "<tr>"
    echo "<td ${td_style}>Appliance Refresh Time</td>"
    echo "<td ${td_style} align='right'>${refresh_time}</td>"
    echo "</tr>"
    echo "</table>"
    echo "</div>"

    echo "<div style='float:left;'>"
    echo "<table class='highlight-form' style='margin-left:2px; margin-bottom:5px;' width='$((width/2 -1))'>"
    echo "<tr>"
    echo "<td ${td_style}><label for='${get_checkbox_id}'>Show Differentials?</label></td>"
    echo "<td ${td_style} align='right'><input id='${get_checkbox_id}' type='checkbox'${checked} /></td>"
    echo "</tr>"
    echo "</table>"
    echo "</div>"

    echo "<div style='clear:left; margin:0; margin-bottom:5px;'></div>"

    if test ! -f ${RUN_DIR}/${qos_traffic_filename} ; then
	echo "<div style='clear:left; margin:0; margin-bottom:5px;'></div>"
	echo-content-unavailable ${width} "The QoS Report is unavailable."
	echo "</div>"
	return 0
    fi

    # Get Values Part

    local tabs_id='interfacetabs'

    local flow interface ibytes obytes
    local ikbits okbits
    local name

    local      internalFlow externalFlow auxiliaryFlow
    declare -a internalFlow externalFlow auxiliaryFlow

    local      internalIngress externalIngress auxiliaryIngress
    declare -a internalIngress externalIngress auxiliaryIngress

    local      internalEgress externalEgress auxiliaryEgress
    declare -a internalEgress externalEgress auxiliaryEgress

    local internal_nb=0 external_nb=0 auxiliary_nb=0 i

    local      internalPieFlow externalPieFlow auxiliaryPieFlow
    declare -a internalPieFlow externalPieFlow auxiliaryPieFlow

    local      internalPieIngress externalPieIngress auxiliaryPieIngress
    declare -a internalPieIngress externalPieIngress auxiliaryPieIngress

    local      internalPieEgress externalPieEgress auxiliaryPieEgress
    declare -a internalPieEgress externalPieEgress auxiliaryPieEgress

    local internal_pie_nb=0 external_pie_nb=0 auxiliary_pie_nb=0

    local internal_pie_tweb_ingress=0  internal_pie_tweb_egress=0
    local internal_pie_rweb_ingress=0  internal_pie_rweb_egress=0
    local internal_pie_web_ingress=0  internal_pie_web_egress=0
    local internal_pie_peer_ingress=0 internal_pie_peer_egress=0
    local internal_pie_antivirus_ingress=0  internal_pie_antivirus_egress=0
    local internal_pie_router_ingress=0  internal_pie_router_egress=0

    local external_pie_rweb_ingress=0  external_pie_rweb_egress=0
    local external_pie_web_ingress=0  external_pie_web_egress=0
    local external_pie_antivirus_ingress=0  external_pie_antivirus_egress=0
    local external_pie_router_ingress=0  external_pie_router_egress=0

    local auxiliary_pie_tweb_ingress=0 auxiliary_pie_tweb_egress=0
    local auxiliary_pie_web_ingress=0 auxiliary_pie_web_egress=0
    local auxiliary_pie_antivirus_ingress=0  auxiliary_pie_antivirus_egress=0
    local auxiliary_pie_router_ingress=0 auxiliary_pie_router_egress=0

    while read flow interface ibytes obytes
    do
	((ikbits = ibytes * 8)) ; ((ikbits /= 1024)) ; test $((ikbits % 1024)) -lt 512 || ((ikbits++))
	((okbits = obytes * 8)) ; ((okbits /= 1024)) ; test $((okbits % 1024)) -lt 512 || ((okbits++))

	name=$(get-traffic-name ${flow})

	case ${interface} in

	    internal)
		internalFlow[${internal_nb}]=${flow}
		internalIngress[${internal_nb}]=${ikbits}
		internalEgress[${internal_nb}]=${okbits}
		((internal_nb++))

		case ${name} in
		    admin|default|etc|file)
			if test ${ikbits} -ne 0 -o ${okbits} -ne 0 ; then
			    internal_pie_traffic=1
			    internalPieFlow[${internal_pie_nb}]=${name}
			    internalPieIngress[${internal_pie_nb}]=${ikbits}
			    internalPieEgress[${internal_pie_nb}]=${okbits}
			    ((internal_pie_nb++))
			fi
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
		    router)
			((internal_pie_router_ingress += ikbits))
			((internal_pie_router_egress += okbits))
			;;
		    *)
			;;
		esac
		;;

	    external)
		externalFlow[${external_nb}]=${flow}
		externalIngress[${external_nb}]=${ikbits}
		externalEgress[${external_nb}]=${okbits}
		((external_nb++))

		case ${name} in
		    admin|default|etc|file|vpnipsec)
			if test ${ikbits} -ne 0 -o ${okbits} -ne 0 ; then
			    external_pie_traffic=1
			    externalPieFlow[${external_pie_nb}]=${flow}
			    externalPieIngress[${external_pie_nb}]=${ikbits}
			    externalPieEgress[${external_pie_nb}]=${okbits}
			    ((external_pie_nb++))
			fi
			;;
		    web)
			((external_pie_web_ingress += ikbits))
			((external_pie_web_egress += okbits))
			;;

		    rweb)
			((external_pie_rweb_ingress += ikbits))
			((external_pie_rweb_egress += okbits))
			;;
		    antivirus)
			((external_pie_antivirus_ingress += ikbits))
			((external_pie_antivirus_egress += okbits))
			;;
		    router)
			((external_pie_router_ingress += ikbits))
			((external_pie_router_egress += okbits))
			;;
		    *)
			;;
		esac
		;;

	    auxiliary)
		auxiliaryFlow[${auxiliary_nb}]=${flow}
		auxiliaryIngress[${auxiliary_nb}]=${ikbits}
		auxiliaryEgress[${auxiliary_nb}]=${okbits}
		((auxiliary_nb++))

		case ${name} in
		    admin|default|etc|file)
			if test ${ikbits} -ne 0 -o ${okbits} -ne 0 ; then
			    auxiliary_pie_traffic=1
			    auxiliaryPieFlow[${auxiliary_pie_nb}]=${flow}
			    auxiliaryPieIngress[${auxiliary_pie_nb}]=${ikbits}
			    auxiliaryPieEgress[${auxiliary_pie_nb}]=${okbits}
			    ((auxiliary_pie_nb++))
			fi
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
		    router)
			((auxiliary_pie_router_ingress += ikbits))
			((auxiliary_pie_router_egress += okbits))
			;;
		    *)
			;;
		esac
		;;
	    *)
		;;
	esac
    done < ${RUN_DIR}/${qos_traffic_filename}

    # Internal Interface

    if test ${internal_pie_web_ingress} -ne 0 -o ${internal_pie_web_egress} -ne 0 ; then
	internalPieFlow[${internal_pie_nb}]=web
	internalPieIngress[${internal_pie_nb}]=${internal_pie_web_ingress}
	internalPieEgress[${internal_pie_nb}]=${internal_pie_web_egress}
	((internal_pie_nb++))
    fi

    if test ${internal_pie_tweb_ingress} -ne 0 -o ${internal_pie_tweb_egress} -ne 0 ; then
	internalPieFlow[${internal_pie_nb}]=tweb
	internalPieIngress[${internal_pie_nb}]=${internal_pie_tweb_ingress}
	internalPieEgress[${internal_pie_nb}]=${internal_pie_tweb_egress}
	((internal_pie_nb++))
    fi

    if test ${internal_pie_rweb_ingress} -ne 0 -o ${internal_pie_rweb_egress} -ne 0 ; then
	internalPieFlow[${internal_pie_nb}]=rweb
	internalPieIngress[${internal_pie_nb}]=${internal_pie_rweb_ingress}
	internalPieEgress[${internal_pie_nb}]=${internal_pie_rweb_egress}
	((internal_pie_nb++))
    fi

    if test ${internal_pie_peer_ingress} -ne 0 -o ${internal_pie_peer_egress} -ne 0 ; then
	internalPieFlow[${internal_pie_nb}]=peer
	internalPieIngress[${internal_pie_nb}]=${internal_pie_peer_ingress}
	internalPieEgress[${internal_pie_nb}]=${internal_pie_peer_egress}
	((internal_pie_nb++))
    fi

    if test ${internal_pie_antivirus_ingress} -ne 0 -o ${internal_pie_antivirus_egress} -ne 0 ; then
	internalPieFlow[${internal_pie_nb}]=antivirus
	internalPieIngress[${internal_pie_nb}]=${internal_pie_antivirus_ingress}
	internalPieEgress[${internal_pie_nb}]=${internal_pie_antivirus_egress}
	((internal_pie_nb++))
    fi

    if test ${internal_pie_router_ingress} -ne 0 -o ${internal_pie_router_egress} -ne 0 ; then
	internalPieFlow[${internal_pie_nb}]=router
	internalPieIngress[${internal_pie_nb}]=${internal_pie_router_ingress}
	internalPieEgress[${internal_pie_nb}]=${internal_pie_router_egress}
	((internal_pie_nb++))
    fi

    # External Interface

    if test ${external_pie_rweb_ingress} -ne 0 -o ${external_pie_rweb_egress} -ne 0 ; then
	externalPieFlow[${external_pie_nb}]=rweb
	externalPieIngress[${external_pie_nb}]=${external_pie_rweb_ingress}
	externalPieEgress[${external_pie_nb}]=${external_pie_rweb_egress}
	((external_pie_nb++))
    fi

    if test ${external_pie_web_ingress} -ne 0 -o ${external_pie_web_egress} -ne 0 ; then
	externalPieFlow[${external_pie_nb}]=web
	externalPieIngress[${external_pie_nb}]=${external_pie_web_ingress}
	externalPieEgress[${external_pie_nb}]=${external_pie_web_egress}
	((external_pie_nb++))
    fi

    if test ${external_pie_antivirus_ingress} -ne 0 -o ${external_pie_antivirus_egress} -ne 0 ; then
	externalPieFlow[${external_pie_nb}]=antivirus
	externalPieIngress[${external_pie_nb}]=${external_pie_antivirus_ingress}
	externalPieEgress[${external_pie_nb}]=${external_pie_antivirus_egress}
	((external_pie_nb++))
    fi

    if test ${external_pie_router_ingress} -ne 0 -o ${external_pie_router_egress} -ne 0 ; then
	externalPieFlow[${external_pie_nb}]=router
	externalPieIngress[${external_pie_nb}]=${external_pie_router_ingress}
	externalPieEgress[${external_pie_nb}]=${external_pie_router_egress}
	((external_pie_nb++))
    fi

    # Auxiliary Interface

    if test ${auxiliary_pie_web_ingress} -ne 0 -o ${auxiliary_pie_web_egress} -ne 0 ; then
	auxiliaryPieFlow[${auxiliary_pie_nb}]=web
	auxiliaryPieIngress[${auxiliary_pie_nb}]=${auxiliary_pie_web_ingress}
	auxiliaryPieEgress[${auxiliary_pie_nb}]=${auxiliary_pie_web_egress}
	((auxiliary_pie_nb++))
    fi

    if test ${auxiliary_pie_tweb_ingress} -ne 0 -o ${auxiliary_pie_tweb_egress} -ne 0 ; then
	auxiliaryPieFlow[${auxiliary_pie_nb}]=tweb
	auxiliaryPieIngress[${auxiliary_pie_nb}]=${auxiliary_pie_tweb_ingress}
	auxiliaryPieEgress[${auxiliary_pie_nb}]=${auxiliary_pie_tweb_egress}
	((auxiliary_pie_nb++))
    fi

    if test ${auxiliary_pie_antivirus_ingress} -ne 0 -o ${auxiliary_pie_antivirus_egress} -ne 0 ; then
	auxiliaryPieFlow[${auxiliary_pie_nb}]=antivirus
	auxiliaryPieIngress[${auxiliary_pie_nb}]=${auxiliary_pie_antivirus_ingress}
	auxiliaryPieEgress[${auxiliary_pie_nb}]=${auxiliary_pie_antivirus_egress}
	((auxiliary_pie_nb++))
    fi

    if test ${auxiliary_pie_router_ingress} -ne 0 -o ${auxiliary_pie_router_egress} -ne 0 ; then
	auxiliaryPieFlow[${auxiliary_pie_nb}]=router
	auxiliaryPieIngress[${auxiliary_pie_nb}]=${auxiliary_pie_router_ingress}
	auxiliaryPieEgress[${auxiliary_pie_nb}]=${auxiliary_pie_router_egress}
	((auxiliary_pie_nb++))
    fi

    # Pie Display Part

    local pie_height=250 pie_width=250

    echo "<table width='${width}' style='border-spacing:2px; border-collapse:separated; border:1px solid Gainsboro; font-size:14px;'>"
    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header' style='height:50px;' width='20%' align='center'>Logical Interface</td>"
    echo "<td class='table-header' style='height:50px;' width='40%' align='center'>Ingress (Incoming)<br />in Kbits</td>"
    echo "<td class='table-header' style='height:50px;' width='40%' align='center'>Egress (Outgoing)<br />in Kbits</td>"
    echo "</tr>"
    echo "</thead>"
    echo "<tbody>"

    local pie_ingress pie_egress pie_nb

    for interface in internal external auxiliary
    do
	case ${interface} in
	    internal)
		pie_nb=${internal_pie_nb}
		;;
	    external)
		pie_nb=${external_pie_nb}
		;;
	    auxiliary)
		pie_nb=${auxiliary_pie_nb}
		;;
	    *)
		;;
	esac

	if test ${pie_nb} -eq 0 ; then
	    pie_ingress="<i>No Traffic</i>"
	    pie_egress="<i>No Traffic</i>"
	else
	    pie_ingress="<div id='${interface}_ingress_pie' style='height:${pie_height}px; width:${pie_width}px; margin:0; padding:0;'></div>"
	    pie_egress="<div id='${interface}_egress_pie' style='float:left; height:${pie_height}px; width:${pie_width}px; margin:0; padding:0;'></div>"
	fi

	echo "<tr>"
	echo "<td align='center' bgcolor='Gainsboro'>${interface^}</td>"	
	echo "<td align='center' style='border:1px solid Gainsboro;'>${pie_ingress}</td>"
	echo "<td align='center' style='border:1px solid Gainsboro;'>${pie_egress}</td>"
	echo "</tr>"

    done

    echo "</tbody>"
    echo "</table>"

    echo "<script type='text/javascript'>"

    for interface in internal external auxiliary
    do
	# Ingress Pie

	echo "var ${interface}_ingress_pie = c3.generate( {"
	echo "bindto: '#${interface}_ingress_pie',"
	echo "data: {"
	echo "columns: ["

	case ${interface} in
	    internal)
		for ((i=0 ; i<internal_pie_nb ; i++))
		do
		    echo -n "['${internalPieFlow[${i}]}', ${internalPieIngress[${i}]}]"
		    test $[${i}+1] -eq ${internal_pie_nb} || echo -n ","
		    echo
		done
		;;
	    external)
		for ((i=0 ; i<external_pie_nb ; i++))
		do
		    echo -n "['${externalPieFlow[${i}]}', ${externalPieIngress[${i}]}]"
		    test $[${i}+1] -eq ${external_pie_nb} || echo -n ","
		    echo
		done
		;;
	    auxiliary)
		for ((i=0 ; i<auxiliary_pie_nb ; i++))
		do
		    echo -n "['${auxiliaryPieFlow[${i}]}', ${auxiliaryPieIngress[${i}]}]"
		    test $[${i}+1] -eq ${auxiliary_pie_nb} || echo -n ","
		    echo
		done
		;;
	    *)
		;;
	esac

	echo "],"
	echo "type: 'pie',"
	echo "},"

	echo "pie: {"
	echo "label: {"
	echo "format: function (value, ratio, id) {"
	echo "return d3.format('^')(value);"
	echo "}"
	echo "}"
	echo "}"
	echo "} );"

	# Egress Pie

	echo "var ${interface}_egress_pie = c3.generate( {"
	echo "bindto: '#${interface}_egress_pie',"
	echo "data: {"
	echo "columns: ["

	case ${interface} in
	    internal)
		for ((i=0 ; i<internal_pie_nb ; i++))
		do
		    echo -n "['${internalPieFlow[${i}]}', ${internalPieEgress[${i}]}]"
		    test $[${i}+1] -eq ${internal_pie_nb} || echo -n ","
		    echo
		done
		;;
	    external)
		for ((i=0 ; i<external_pie_nb ; i++))
		do
		    echo -n "['${externalPieFlow[${i}]}', ${externalPieEgress[${i}]}]"
		    test $[${i}+1] -eq ${external_pie_nb} || echo -n ","
		    echo
		done
		;;
	    auxiliary)
		for ((i=0 ; i<auxiliary_pie_nb ; i++))
		do
		    echo -n "['${auxiliaryPieFlow[${i}]}', ${auxiliaryPieEgress[${i}]}]"
		    test $[${i}+1] -eq ${auxiliary_pie_nb} || echo -n ","
		    echo
		done
		;;
	    *)
		;;
	esac

	echo "],"
	echo "type: 'pie',"
	echo "},"

	echo "pie: {"
	echo "label: {"
	echo "format: function (value, ratio, id) {"
	echo "return d3.format('^')(value);"
	echo "}"
	echo "}"
	echo "}"
	echo "} );"

    done

    echo "</script>"





    # Table Display Part

    echo "<div style='clear:left;'></div>"
    echo "<br />"
    show-title-iconbar-text "QoS Traffic Details"
    echo "<div style='clear:left;'></div>"
    echo "<hr style='width:${width}px; float:left;' /><br /><br />"

    echo "<ul id='${tabs_id}' class='shadetabs' style='font-size:14px;'>"
    for interface in internal external auxiliary
    do
	echo "<li><a href='#' rel='${interface}' class='selected'>${interface^}</a></li>"
    done
    echo "</ul>"

    for interface in internal external auxiliary
    do
	echo "<div id='${interface}' class='tabcontent' style='margin:0; padding:0; padding-top:10px;'>"
	echo "<table class='highlight-list' width='${width}'>"
	echo "<thead>"
	echo "<tr>"
	echo "<td class='table-header' style='height:50px;' width='40%' align='center'>Traffic</td>"
	echo "<td class='table-header' width='30%' align='center'>Ingress (Incoming)<br /> in Kbits</td>"
	echo "<td class='table-header' width='30%' align='center'>Egress (Outgoing)<br />in Kbits</td>"
	echo "</tr>"
	echo "</thead>"
	echo "<tbody>"

	case ${interface} in
	    internal)
		for ((i=0 ; i<internal_nb ; i++))
		do
		    echo "<tr>"
		    echo "<td>${internalFlow[${i}]}</td><td align='right'>${internalIngress[${i}]}</td><td align='right'>${internalEgress[${i}]}</td>"
		    echo "</tr>"
		done
		;;
	    external)
		for ((i=0 ; i<external_nb ; i++))
		do
		    echo "<tr>"
		    echo "<td>${externalFlow[${i}]}</td><td align='right'>${externalIngress[${i}]}</td><td align='right'>${externalEgress[${i}]}</td>"
		    echo "</tr>"
		done
		;;
	    auxiliary)
		for ((i=0 ; i<auxiliary_nb ; i++))
		do
		    echo "<tr>"
		    echo "<td>${auxiliaryFlow[${i}]}</td><td align='right'>${auxiliaryIngress[${i}]}</td><td align='right'>${auxiliaryEgress[${i}]}</td>"
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





    # Tab Display

    echo "<script type='text/javascript'>"
    echo "var formTabs = new ddtabcontent( '${tabs_id}' );"
    echo "formTabs.setpersist( true );"
    echo "formTabs.setselectedClassTarget( 'link' );"
    echo "formTabs.init( );"
    echo "</script>"

    echo "</div>"
    echo "<br />"
}

# Main()

show-qos-report "${@}"
