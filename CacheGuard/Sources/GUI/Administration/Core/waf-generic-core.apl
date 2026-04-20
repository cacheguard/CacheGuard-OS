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

source waf-common.${GUI_EXT_NAME}

show-filter-generic-form()
{
    local length=8 width=300

    show-title "Default WAF Filters" "enabled" "waf"

    echo "<div class='core-form'>"
    show-form-begin ${length}
    echo "<input name='dummy' type='hidden' value='on'>"
    echo "<table class='highlight-form' width='${width}'>"
    show-generic-waf ${WAF_GENERIC}
    echo "</table>"
    show-do
    show-form-end
    echo "</div>"
}

# Main()

show-filter-generic-form
