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

source functions
source /home/${ADMIN_NAME}/${ENV_RDIR}/${ENV_CURRENT_NAME}

show-ip-external-dhcp-renew-report()
{
    if test ${CURRENT_IP_EXTERNAL_MODE} != 'dhcp' ; then
	echo-unavailable-message "this report is not available."
	return 0
    fi

    echo "<table class='highlight-form'>"
    execute-command-with-output "ip external dhcp renew report"
    echo "</table>"
}

# Main()

gui-run-authentication
show-ip-external-dhcp-renew-report
