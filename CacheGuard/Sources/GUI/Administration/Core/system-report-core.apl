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

source system-report-load-common.${GUI_EXT_NAME}
source system-report-memory-common.${GUI_EXT_NAME}

display-dashboard-auto-refresh()
{
    test -n "${1}" || return 1
    local id="${1}"

    local title="Toggle Auto Refresh"
    local default_state='norefresh' checked

    case ${default_state} in
	norefresh)
	    unset checked
	    ;;
	refresh)
	    checked=' checked'
	    ;;
	*)
	    ;;
    esac

    echo "<span class='title-bar-item'><span class='contextual-help'><input class='dashboard-refresh-checkbox' name='${id}' id='${id}' type='checkbox'${checked} /><label for='${id}'></label><span class='contextual-help-text'>${title}</span></span></span>"
}

display-dashboard-reset-save()
{
    local title="Reset & Save"
    local id="dashboard-reset-save"

    echo "<span class='title-bar-item'><a href='#' data-action='mosaic-reset-save' data-id='${id}'><img id='${id}' src='${IMAGE_DIR}/${id}.png' alt='${title}' title='${title}' /></a></span>"
}

display-dashboard-save()
{
    local title="Save Layout"
    local id="dashboard-save"

    echo "<span class='title-bar-item'><a href='#' data-action='mosaic-save' data-id='${id}'><img id='${id}' src='${IMAGE_DIR}/${id}.png' alt='${title}' title='${title}' /></a></span>"
}

display-check-new-version()
{
    local id="new-os"
    local title="Check OS Upgrade"

    echo "<span class='title-bar-item'><a href='#' data-action='get-latest-version' data-url='/${GUI_DIR_NAME}/system-soft-check.${GUI_EXT_NAME}' data-target-id='${id}'><img src='${IMAGE_DIR}/system-patch.png' alt='${title}' title='${title}' /></a></span>"

    echo "<span class='title-bar-item compact' id='${id}'></span>"
}

get-stick-grid-value()
{
    local value=${1}
    if test -z "${value}" ; then echo 0 ; return 1 ; fi

    ((value = value / GUI_MOSAIC_GRID_STICK * GUI_MOSAIC_GRID_STICK + GUI_MOSAIC_GRID_STICK))
    echo ${value}
    return 0
}

init-auto-refresh-system-report()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local auto_id="${1}"
    local interval="${2}"

    echo "<div data-init-mosaic-auto-reload-all data-auto-id='${auto_id}' data-interval='${interval}' hidden></div>"
}

# Main()

show-system-report()
{
    local margin_y=$[${GUI_MOSAIC_GRID_STICK} * 2]
    local parent_id="mosaic-container"
    local dashboard_menu_id="dashboard-menu"
    local dashboard_control_id="dashboard-control"
    local auto_refresh_id="dashboard-auto-refresh"
    local refresh_interval=10
    local default_state

    local rows_0 rows_1 rows_nb
    local n i=0

    local cursor_column var
    local page width height left top title state

    local pages widths heights tops lefts titles states
    declare -a pages widths heights tops lefts titles states

    local dashboard_file=${HOME}/${ENV_RDIR}/${GUI_DASHBOARD_LAYOUT_FILENAME}

    titles[${i}]="Links, IP & Gateways" ; ((i++))
    titles[${i}]="Load & Memory Usage" ; ((i++))
    titles[${i}]="Internal Network Activities" ; ((i++))

    if test ${APL_ROLE} == 'gateway' ; then
	titles[${i}]="External Network Activities" ; ((i++))
	titles[${i}]="Auxiliary Network Activities" ; ((i++))
	default_state='false';
    else
	default_state='true';
    fi

    titles[${i}]="Appliance Services" ; ((i++))
    titles[${i}]="Disk(s) Usage & RAID Status" ; ((i++))
    titles[${i}]="URL lists & AV Updates" ; ((i++))

    case ${APL_ROLE} in
	gateway)
	    titles[${i}]="Site to Site IPsec Tunnels" ; ((i++))
	    ;;
	manager)
	    titles[${i}]="Manager HA" ; ((i++))
	    ;;
	*)
	    ;;
    esac

    ((n = i))

    i=0
    if test -s ${dashboard_file} ; then
	while read page width height left top state
	do
	    pages[${i}]=${page}
	    widths[${i}]=${width}
	    heights[${i}]=${height}
	    lefts[${i}]=${left}
	    tops[${i}]=${top}
	    states[${i}]=${state}
	    ((i++))
	done < ${dashboard_file}
	n=${i}
    else
	pages[${i}]=system-report-link-gateway
	widths[${i}]=${GUI_MOSAIC_WIDTH}
	heights[${i}]=${GUI_MOSAIC_HEIGHT}
	states[${i}]='true'
	((i++))

	pages[${i}]=system-report-load-memory
	widths[${i}]=${GUI_MOSAIC_WIDTH}
	heights[${i}]=${GUI_MOSAIC_HEIGHT}
	states[${i}]='true'
	((i++))

	pages[${i}]=network-activity-internal
	widths[${i}]=${GUI_MOSAIC_WIDTH}
	heights[${i}]=${GUI_MOSAIC_HEIGHT}
	states[${i}]='true'
	((i++))

	if test ${APL_ROLE} == 'gateway' ; then
	    pages[${i}]=network-activity-external
	    widths[${i}]=${GUI_MOSAIC_WIDTH}
	    heights[${i}]=${GUI_MOSAIC_HEIGHT}
	    states[${i}]='true'
	    ((i++))

	    pages[${i}]=network-activity-auxiliary
	    widths[${i}]=${GUI_MOSAIC_WIDTH}
	    heights[${i}]=${GUI_MOSAIC_HEIGHT}
	    states[${i}]='false'
	    ((i++))
	fi

	pages[${i}]=system-report-service
	widths[${i}]=${GUI_MOSAIC_WIDTH}
	heights[${i}]=${GUI_MOSAIC_HEIGHT}
	states[${i}]='false'
	((i++))

	pages[${i}]=system-report-disk-raid
	widths[${i}]=${GUI_MOSAIC_WIDTH}
	heights[${i}]=${GUI_MOSAIC_HEIGHT}
	states[${i}]="${default_state}"
	((i++))

	pages[${i}]=urllist-antivirus-report
	widths[${i}]=$[${GUI_MOSAIC_GRID_STICK} * 2 +${GUI_MOSAIC_WIDTH} * 2]
	heights[${i}]=$[${GUI_MOSAIC_HEIGHT} * 2]
	states[${i}]='false'
	((i++))

	case ${APL_ROLE} in
	    gateway)
		pages[${i}]=vpnipsec-report
		widths[${i}]=${GUI_MOSAIC_WIDTH}
		heights[${i}]=${GUI_MOSAIC_HEIGHT}
		states[${i}]='false'
		((i++))
		;;
	    manager)
		pages[${i}]=manager-sync-report
		widths[${i}]=${GUI_MOSAIC_WIDTH}
		heights[${i}]=${GUI_MOSAIC_HEIGHT}
		states[${i}]='false'
		((i++))
		;;
	    *)
		;;
	esac

	((cursor_column = 0))
	((rows_0 = 0))
	((rows_1 = 0))
	for ((i=0 ; i<n ; i++))
	do
	    ((height = heights[i]))
	    ((rows_nb = (height / GUI_MOSAIC_HEIGHT)))

	    test ${rows_nb} -eq 1 || ((height += (rows_nb - 1) * margin_y))
	    heights[${i}]=$(get-stick-grid-value ${height})

	    state=${states[${i}]}

	    if test ${state} == 'true' ; then
		case ${cursor_column} in
		    0)
			((lefts[i] = GUI_MOSAIC_LIMIT_LEFT))
			((tops[i] = GUI_MOSAIC_LIMIT_TOP + ((GUI_MOSAIC_HEIGHT + margin_y) * rows_0)))
			((rows_0 += rows_nb))
			;;
		    1)
			((lefts[i] = GUI_MOSAIC_LIMIT_LEFT + GUI_MOSAIC_WIDTH + GUI_MOSAIC_GRID_STICK))
			((tops[i] = GUI_MOSAIC_LIMIT_TOP + ((GUI_MOSAIC_HEIGHT + margin_y) * rows_1)))
			((rows_1 += rows_nb))	
			;;
		    *)
			return 255
			;;
		esac
		
		test ${lefts[${i}]} == ${GUI_MOSAIC_LIMIT_LEFT} || lefts[${i}]=$(get-stick-grid-value lefts[${i}])
		test ${tops[${i}]} == ${GUI_MOSAIC_LIMIT_TOP} || tops[${i}]=$(get-stick-grid-value tops[${i}])
	    else
		((lefts[i] = -1))
		((tops[i] = -1))
	    fi

	    echo ${pages[${i}]} ${widths[${i}]} ${heights[${i}]} ${lefts[${i}]} ${tops[${i}]} ${states[${i}]}

	    if test ${rows_0} -gt ${rows_1} ; then
		cursor_column=1
	    else
		cursor_column=0
	    fi
	done > ${dashboard_file}
    fi

    local controls="system-report ${dashboard_control_id} Toggle_Dashboard_Menu"

    show-title "Health Dashboard" 'disabled' '' "${controls}" 'disabled'

    echo "<div id='${dashboard_menu_id}' class='dashboard-bar'>"

    display-dashboard-auto-refresh ${auto_refresh_id}

    for ((i=0 ; i<n ; i++))
    do
	page=${pages[${i}]}
	state=${states[${i}]}
	title=${titles[${i}]}
	var=${page//-/_}

	echo "<span class='title-bar-item'><a href='#' data-action='mosaic-show' data-parent-id='${parent_id}' data-page='${page}'><img src='${IMAGE_DIR}/${page}.png' alt='${title}' title='${title}' /></a></span>"
    done

    display-dashboard-reset-save
    display-dashboard-save
    display-check-new-version

    echo "</div>"

    local token=$(get-auth-token)
    local separator

    echo "<div class='dashboard-container'>"
    echo "<input type='hidden' id='${GUI_CSRF_ATTRIBUTE}' name='${GUI_CSRF_ATTRIBUTE}' value='${token}' />"

    echo "<div id='${parent_id}' class='dashboard-container'>"
        cat << EOT
<script type='application/json' data-init-tiles>
{
"parentId": "${parent_id}",
"dashboardMenuId": "${dashboard_menu_id}",
"dashboardControlId": "${dashboard_control_id}",
"tiles": [
EOT

    for ((i=0 ; i<n ; i++))
    do
	page=${pages[${i}]}
	title=${titles[${i}]}
	width=${widths[${i}]}
	height=${heights[${i}]}
	left=${lefts[${i}]}
	top=${tops[${i}]}
	state=${states[${i}]}

	echo "${separator}{"
	echo "\"page\": \"${page}\","
	echo "\"title\": \"${title}\","
	echo "\"width\": ${width},"
	echo "\"height\": ${height},"
	echo "\"left\": ${left},"
	echo "\"top\": ${top},"
	echo "\"state\": ${state}"
	echo "}"

	separator=","
    done

    cat << EOT
]
}
</script>
EOT
    echo "</div>"
    echo "</div>"

    reset-gui-error-log

    init-auto-refresh-system-report ${auto_refresh_id} ${refresh_interval}
}

# Main()

show-system-report "${@}"
