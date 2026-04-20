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

show-license-form()
{
    local width

    local first_action=$(get-first-startup-action)

    itemWidth[0]=90
    itemWidth[1]=10

    itemTitle[0]="I agree to terms of the <a href=/doc/command/license.html target=_blank>${COMMERCIAL_NAME}-OS License</a>"
    itemID[0]=accept
    blankItemContent[0]="type='checkbox' onClick='agreeLicense(\"accept\")'"

    show-title "License Terms Acceptance" disabled "license"

    if test "${first_action}" != license ; then
	gui-information-message "Thank you to have accepted the terms of the ${COMMERCIAL_NAME}-OS License.<a href='/'><img src='${IMAGE_DIR}/refresh.png' align='middle' title='Continue' /></a>"
	return 0
    fi

    gui-information-message "Please carefully read and accept the terms of the ${COMMERCIAL_NAME}-OS License before implementing a ${COMMERCIAL_NAME} appliance."
    show-form "${width}" disabled

    echo "<div class='core-form'>"
    cat ${ETC_HTML_DIR}/license.html
    show-scroll-top
    echo "</div>"

}

# Main()

show-license-form
