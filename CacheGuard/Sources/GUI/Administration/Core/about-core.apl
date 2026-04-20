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

show-about()
{
    local width=750
    local left=35
    local right=65

    show-title "About this System" "disabled" "system"

    local role=$(gui-get-contextual-role)
    local license_end=$(get-system-end ${role})
    local license_state="${license_end/ *}"
    local license_date="${license_end/* }"

    echo "<div class='core-form'>"

    if ! gui-is-in-contextual-role ; then
	shortcutMenuItem[0]="system-patch"
	shortcutMenuTitle[0]="OS Patch"
	show-shortcuts-menu
    fi

    echo "<table class='highlight-list' width='${width}' style='margin-top:5px;'>"

    echo "<tr>"
    echo "<td width='${left}%'>Operating System Version</td>"
    echo "<td width='${right}%'><strong>$(get-system-soft)</strong></td>"
    echo "</tr>"

    if gui-is-in-template-context ${role} ; then
	echo "</table>"
	echo "</div>"
	return 0
    fi

    if ! gui-is-in-contextual-role ; then
	echo "<tr>"
	echo "<td><a href='#' onClick='getLatestVersion( \"/${GUI_DIR_NAME}/system-soft-check.${GUI_EXT_NAME}\", \"new-os\" )'>Check for Updates</a></td>"
	echo "<td><div id='new-os' class='iconbar-item'><i>&lt;not yet checked&gt;</i></div></td>"
	echo "</tr>"
    fi

    local hard_ap="<li>OS: OS installation, VE: Virtual Edition, HW: Hardware</li>"

    case ${role} in
	gateway)
	    local hard_us="<li>US: number of USers in forwarding mode</li>"
	    local hard_gr="<li>GR: GuaRd blacklist records number</li>"
	    local hard_ru="<li>RU: number of Userse in Revers mode</li>"
	    local hard_rw="<li>RW: number of Reverse Websites</li>"
	    local hard_rc="<li>CR: Cache size per Reverse website in MB</li>"
	    local hard_lr="<li>LR: Logs Rotation period</li>"
	    local hard_ul="<li>UL: maximum size for UpLoaded files in MB</li>"
	    local hard_pc="<li>PC: Persistent Cache (0:off, 1:on)</li>"
	    local hard_wl="<li>WL: Persistent Web access logging (0:off, 1:on)</li>"
	    local hard_rl="<li>RL: Persistent rWeb access logging (0:off, 1:on)</li>"

	    local hardware="<ul>${hard_ap}${hard_us}${hard_gr}${hard_ru}${hard_rw}${hard_rc}${hard_lr}${hard_ul}${hard_pc}${hard_wl}${hard_rl}</ul>"
	    ;;
	manager)
	    local hard_gw="<li>GW: supported managed GateWays</li>"
	    local hard_tl="<li>TL: supported TempLates</li>"
	    local hard_us="<li>US: number of USers in forwarding mode</li>"
	    local hard_rw="<li>RW: number of Reverse Websites</li>"
	    local hard_gr="<li>GR: GuaRd blacklist records number</li>"

	    local hardware="<ul>${hard_ap}${hard_gw}${hard_tl}${hard_us}${hard_rw}${hard_gr}</ul>"
	    ;;
	*)
	    ;;
    esac

    echo "<tr>"
    echo "<td width='${left}%'>Appliance Role</td>"
    echo "<td width='${right}%'><strong>${role^}</strong></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td width='${left}%'>Appliance Model Reference</td>"
    echo "<td width='${right}%' onMouseOver='ddrivetip( \"${hardware}\", 450 );' onMouseOut='hideddrivetip( );'><strong>$(get-system-hard long)</strong></td>"
    echo "</tr>"

    local title value i=0 hards=$(get-system-hard raw)

    for value in ${hards}
    do
	echo "<tr>"

	if test ${i} -eq 0 ; then
	    title="Installation Type"
	    case ${value} in
		OS)
		    value="${value} (Operation System)"
		    ;;
		VE)
		    case ${CLOUD_NAME} in
			aws|azure)
			    if test "${CLOUD_VALID_IP}" == yes ; then
				local cloud_name=$(get-external-cloud-name ${CLOUD_NAME})

				case ${CLOUD_USAGE} in
				    free)
					value="Free on ${cloud_name} Cloud"
					;;
				    payg)
					value="PAYG on ${cloud_name} Cloud"
					;;
				    byol)
					value="BYOL on ${cloud_name} Cloud"
					;;
				    *)
					value="Unknown on ${cloud_name} Cloud"
					;;
				esac
			    else
				value="Invalid on ${cloud_name} Cloud"
			    fi
			    ;;
			*)
			    value="${value} (Virtual Edition)"
			    ;;
		    esac
		    ;;
		HW)
		    value="${value} (Hardware Appliance)"
		    ;;
		*)
		    value="${value} (Virtual Edition)"
		    ;;
	    esac
	else
	    case ${role} in
		gateway)
		    case ${i} in
			1)
			    title="Supported Forwarding Users"
			    ;;
			2)
			    title="Supported URL Lists Records"
			    value=$(format-number ${value})
			    ;;
			3)
			    title="Supported Reverse Users"
			    ;;
			4)
			    title="Supported Reverse Websites"
			    ;;
			5)
			    title="Reverse Websites Cache Size"
			    value="${value} MB"
			    ;;
			6)
			    title="Logs Rotation Period"
			    value="${value} days"
			    ;;
			7)
			    title="Uploaded Files Maximum Size"
			    value="${value} MB"
			    ;;
			8)
			    title="Persistent Cache"
			    ;;
			9)
			    title="Persistent Web Access Logging"
			    ;;
			10)
			    title="Persistent rWeb Access Logging"
			    ;;
			*)
			    ;;
		    esac
		    
		    case ${i} in
			8|9|10)
			    if test ${value} == 1 ; then
				value='Yes'
			    else
				value='No'
			    fi
			    ;;
			*)
			    ;;
		    esac
		    ;;
		manager)
		    case ${i} in
			1)
			    title="Supported Managed Gateways"
			    ;;
			2)
			    title="Supported TempLates"
			    ;;
			3)
			    title="Supported Forwarding Users"
			    ;;
			4)
			    title="Supported Reverse Websites"
			    ;;
			5)
			    title="Supported URL Lists Records"
			    value=$(format-number ${value})
			    ;;
			*)
			    ;;
		    esac
		    ;;
		*)
		    ;;
	    esac
	fi

	echo "<td>${title}</td>"
	echo "<td>${value}</td>"
	echo "</tr>"
	((i++))
    done

    echo "<tr>"
    echo "<td width='${left}%'>Machine</td>"
    echo "<td width='${right}%'><strong>$(get-system-machine)</strong></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td width='${left}%'>Architecture</td>"
    echo "<td width='${right}%'><strong>${CPU_ARCHITECTURE}</strong></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td width='${left}%'>CPU</td>"
    echo "<td width='${right}%'><strong>$(get-system-cpu)</strong></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td width='${left}%'>RAM</td>"

    local ram=$(get-installed-memory-sz)
    ((ram /= 1024))

    echo "<td width='${right}%'><strong>${ram} MB</strong></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td width='${left}%'>Disk(s)</td>"
    echo "<td width='${right}%'><strong>$(get-system-disk)</strong></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td width='${left}%'>RAID</td>"
    echo "<td width='${right}%'><strong>$(get-system-raid)</strong></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td width='${left}%'>Serial Number</td>"
    echo "<td width='${right}%'><strong>$(get-system-id)</strong></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td width='${left}%'>UUID (Universally Unique IDentifier)</td>"
    echo "<td width='${right}%'><strong>$(get-system-uuid)</strong></td>"
    echo "</tr>"

    license_state=$(get-highlight-license-state ${license_state})

    echo "<tr>"
    echo "<td width='${left}%'>License End</td>"
    case ${license_state} in
	never)
	    echo "<td width='${right}%'><strong>never</strong></td>"
	    ;;
	*)
	    echo "<td width='${right}%'><strong>${license_date} (${license_state})</strong></td>"
	    ;;
    esac
    echo "</tr>"
    
    echo "</table>"
    echo "</div>"
}

# Main()

show-about
