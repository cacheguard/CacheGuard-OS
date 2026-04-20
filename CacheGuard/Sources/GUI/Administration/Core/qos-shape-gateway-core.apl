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

get-qos-sums()
{
    local qos len
    local total=0 total_pct=0

    for qos in ${*}
    do
	len=${#qos} ; ((len--))
	if test ${qos:${len}:1} == '%' ; then
	    qos=${qos:0:${len}}
	    ((total_pct += qos))
	else
	    ((total += qos))
	fi
    done

    echo "${total_pct} ${total}"
}

show-overall-qos()
{
    local width=${1}
    test -n "${width}" || width=100

    local margin=5
    local qos_color_pct qos_color
    local dev gress qoss qos qos_pct bw
    local qos_web qos_tweb qos_rweb qos_antivirus qos_file qos_peer qos_vpnipsec qos_default

    local i=0 qos_pct_tab qos_tab
    declare -a qos_pct_tab qos_tab

    for dev in internal external auxiliary
    do
	for gress in ingress egress
	do
	    qos_web=$(get-qos-shape ${dev} ${gress} web)
	    qos_tweb=$(get-qos-shape ${dev} ${gress} tweb)
	    qos_rweb=$(get-qos-shape ${dev} ${gress} rweb)
	    qos_antivirus=$(get-qos-shape ${dev} ${gress} antivirus)
	    qos_file=$(get-qos-shape ${dev} ${gress} file)
	    qos_peer=$(get-qos-shape ${dev} ${gress} peer)
	    qos_vpnipsec=$(get-qos-shape ${dev} ${gress} vpnipsec)
	    qos_default=$(get-qos-shape ${dev} ${gress} default)

	    qoss=$(get-qos-sums ${qos_web} ${qos_tweb} ${qos_rweb} ${qos_antivirus} ${qos_file} ${qos_peer} ${qos_vpnipsec} ${qos_default})
	    qos_pct=${qoss/ *}
	    qos=${qoss/* }

	    qos_pct_tab[${i}]=${qos_pct}
	    qos_tab[${i}]=${qos}
	    ((i++))
	done
    done

    echo "<div style='clear:left;'></div><br />"

    echo "<div class='table-title' style='margin-left:${margin}px;'>Overall QoS</div>"
    echo "<table class='highlight-list' style='margin-left:${margin}px;' width='${width}'>"
    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header' width='40%'>Traffic</td>"
    echo "<td class='table-header' width='30%' align='right'>Overall %</td>"
    echo "<td class='table-header' width='30%' align='right'>Overall kbps</td>"
    echo "</tr>"
    echo "</thead>"
    echo "<tbody>"

    i=0
    for dev in internal external auxiliary
    do
	for gress in ingress egress
	do
            echo "<tr>"
            echo "<td>$(gress-title ${gress}) from ${dev^}</td>"
	    qos_pct=${qos_pct_tab[${i}]}
	    qos=${qos_tab[${i}]}
	    bw=$(get-qos-bw ${dev} ${gress})

	    if test ${qos_pct} -gt 100 ; then qos_color_pct='FireBrick' ; else qos_color_pct='Black' ; fi
	    if test ${qos} -gt ${bw} ; then qos_color='FireBrick' ; else qos_color='Black' ; fi

            echo "<td align='right'><span style='color:${qos_color_pct}'>${qos_pct}%</span></td>"
	    echo "<td align='right'><span style='color:${qos_color}'>${qos} kbps</span></td>"
            echo "</tr>"
	    ((i++))
	done
    done

    echo "</tbody>"
    echo "</table>"
    echo "<br />"
}

gress-title()
{
    test -n "${1}" || return 1
    gress=${1}

    case ${gress} in
	ingress)
	    echo "Incoming"
	    ;;
	egress)
	    echo "Outgoing"
	    ;;
	*)
	    ;;
    esac
}

show-qos-shape-gateway-form()
{
    show-title "Shape Gateway Traffic" "enabled" "qos"

    local width=638
    itemWidth[0]=85
    itemWidth[1]=15

    local dev gress qos
    local nb=0

    itemID[${nb}]="tab_${nb}"
    itemTitle[${nb}]="Web"
    blankItemContent[${nb}]=""
    itemForm[${nb}]=tab
    ((nb++))

    for dev in internal external auxiliary
    do
	itemID[${nb}]="dev_${nb}"
	itemTitle[${nb}]="<strong>${dev^} Interface</strong>"
	blankItemContent[${nb}]=""
	itemForm[${nb}]=text
	((nb++))

	for gress in ingress egress
	do
	    qos=$(get-qos-shape ${dev} ${gress} web)
	    itemTitle[${nb}]="Shape $(gress-title ${gress}) (${gress}) traffic"
	    itemID[${nb}]="web_${dev}_${gress}"
	    blankItemContent[${nb}]="type='text' size='8' maxlength='10' value='${qos}'"
	    checkItem[${nb}]=qos
	    ((nb++))
	done
    done

    itemID[${nb}]="tab_${nb}"
    itemTitle[${nb}]="Transparent Web"
    blankItemContent[${nb}]=""
    itemForm[${nb}]=tab
    ((nb++))

    for dev in internal auxiliary
    do
	itemID[${nb}]="dev_${nb}"
	itemTitle[${nb}]="<strong>${dev^} Interface</strong>"
	blankItemContent[${nb}]=""
	itemForm[${nb}]=text
	((nb++))

	for gress in ingress egress
	do
	    qos=$(get-qos-shape ${dev} ${gress} tweb)
	    itemTitle[${nb}]="Shape $(gress-title ${gress}) (${gress}) traffic"
	    itemID[${nb}]="tweb_${dev}_${gress}"
	    blankItemContent[${nb}]="type='text' size='8' maxlength='10' value='${qos}'"
	    checkItem[${nb}]=qos
	    ((nb++))
	done
    done

    itemID[${nb}]="tab_${nb}"
    itemTitle[${nb}]="Reverse Web"
    blankItemContent[${nb}]=""
    itemForm[${nb}]=tab
    ((nb++))

    for dev in internal external
    do
	itemID[${nb}]="dev_${nb}"
	itemTitle[${nb}]="<strong>${dev^} Interface</strong>"
	blankItemContent[${nb}]=""
	itemForm[${nb}]=text
	((nb++))

	for gress in ingress egress
	do
	    qos=$(get-qos-shape ${dev} ${gress} rweb)
	    itemTitle[${nb}]="Shape $(gress-title ${gress}) (${gress}) traffic"
	    itemID[${nb}]="rweb_${dev}_${gress}"
	    blankItemContent[${nb}]="type='text' size='8' maxlength='10' value='${qos}'"
	    checkItem[${nb}]=qos
	    ((nb++))
	done
    done

    itemID[${nb}]="tab_${nb}"
    itemTitle[${nb}]="Antivirus"
    blankItemContent[${nb}]=""
    itemForm[${nb}]=tab
    ((nb++))

    for dev in internal external auxiliary
    do
	itemID[${nb}]="dev_${nb}"
	itemTitle[${nb}]="<strong>${dev^} Interface</strong>"
	blankItemContent[${nb}]=""
	itemForm[${nb}]=text
	((nb++))

	for gress in ingress egress
	do
	    qos=$(get-qos-shape ${dev} ${gress} antivirus)
	    itemTitle[${nb}]="Shape $(gress-title ${gress}) (${gress}) traffic"
	    itemID[${nb}]="antivirus_${dev}_${gress}"
	    blankItemContent[${nb}]="type='text' size='8' maxlength='10' value='${qos}'"
	    checkItem[${nb}]=qos
	    ((nb++))
	done
    done
    
    itemID[${nb}]="tab_${nb}"
    itemTitle[${nb}]="File"
    blankItemContent[${nb}]=""
    itemForm[${nb}]=tab
    ((nb++))

    for dev in internal external auxiliary
    do
	itemID[${nb}]="dev_${nb}"
	itemTitle[${nb}]="<strong>${dev^} Interface</strong>"
	blankItemContent[${nb}]=""
	itemForm[${nb}]=text
	((nb++))

	for gress in ingress egress
	do
	    qos=$(get-qos-shape ${dev} ${gress} file)
	    itemTitle[${nb}]="Shape $(gress-title ${gress}) (${gress}) traffic"
	    itemID[${nb}]="file_${dev}_${gress}"
	    blankItemContent[${nb}]="type='text' size='8' maxlength='10' value='${qos}'"
	    checkItem[${nb}]=qos
	    ((nb++))
	done
    done

    dev=internal
    itemID[${nb}]="tab_${nb}"
    itemTitle[${nb}]="Peer"
    blankItemContent[${nb}]=""
    itemForm[${nb}]=tab
    ((nb++))

    itemID[${nb}]="dev_${nb}"
    itemTitle[${nb}]="<strong>${dev^} Interface</strong>"
    blankItemContent[${nb}]=""
    itemForm[${nb}]=text
    ((nb++))

    for gress in ingress egress
    do
	qos=$(get-qos-shape internal ${gress} peer)
	itemTitle[${nb}]="Shape $(gress-title ${gress}) (${gress}) traffic"
	itemID[${nb}]="peer_${dev}_${gress}"
	blankItemContent[${nb}]="type='text' size='8' maxlength='10' value='${qos}'"
	checkItem[${nb}]=qos
	((nb++))
    done

    dev=external
    itemID[${nb}]="tab_${nb}"
    itemTitle[${nb}]="IPsec VPN"
    blankItemContent[${nb}]=""
    itemForm[${nb}]=tab
    ((nb++))

    itemID[${nb}]="dev_${nb}"
    itemTitle[${nb}]="<strong>${dev^} Interface</strong>"
    blankItemContent[${nb}]=""
    itemForm[${nb}]=text
    ((nb++))

    for gress in ingress egress
    do
	qos=$(get-qos-shape external ${gress} vpnipsec)
	itemTitle[${nb}]="Shape $(gress-title ${gress}) (${gress}) traffic"
	itemID[${nb}]="vpnipsec_${dev}_${gress}"
	blankItemContent[${nb}]="type='text' size='8' maxlength='10' value='${qos}'"
	checkItem[${nb}]=qos
	((nb++))
    done

    itemID[${nb}]="tab_${nb}"
    itemTitle[${nb}]="Default"
    blankItemContent[${nb}]=""
    itemForm[${nb}]=tab
    ((nb++))

    for dev in internal external auxiliary
    do
	itemID[${nb}]="dev_${nb}"
	itemTitle[${nb}]="<strong>${dev^} Interface</strong>"
	blankItemContent[${nb}]=""
	itemForm[${nb}]=text
	((nb++))

	for gress in ingress egress
	do
	    qos=$(get-qos-shape ${dev} ${gress} default)
	    itemTitle[${nb}]="Shape $(gress-title ${gress}) (${gress}) traffic"
	    itemID[${nb}]="default_${dev}_${gress}"
	    blankItemContent[${nb}]="type='text' size='8' maxlength='10' value='${qos}'"
	    checkItem[${nb}]=qos
	    ((nb++))
	done
    done

    show-tab-form ${width} enabled show-overall-qos ${width}
}

# Main()

show-qos-shape-gateway-form
