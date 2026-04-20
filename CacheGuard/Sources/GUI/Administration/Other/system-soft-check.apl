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

source functions

print-system-soft-check()
{
    local new_os_version

    new_os_version=$(get-os-latest-version) ; ret=${?}

    if test ${ret} -ne 0 ; then
	echo "<img id='io-error-image' src='${IMAGE_DIR}/ko.png' alt='Unable to test' title='Unable to Check' />"
	return 0
    fi

    local message=$(get-system-soft-check-message "${new_os_version}")

    echo "<a href='${PATCH_URL}' target='_blank'>${message}</a>"
}

gui-run-authentication
print-system-soft-check
