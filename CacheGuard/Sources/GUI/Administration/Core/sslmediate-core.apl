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

show-sslmediate-policies()
{
    local in_policy=${1}
    local policy

    for policy in allow deny
    do
	if test ${policy} == "${in_policy}" ; then
	    echo -n "<option value='${policy}' selected>${policy}</option>"
	else
	    echo -n "<option value='${policy}'>${policy}</option>"
	fi
    done
}

show-sslmediate-policy-form()
{
    local width=350

    itemWidth[0]=80
    itemWidth[1]=20

    itemTitle[0]="Exception Policy"
    itemTitle[1]="Transparent SSL Mediation"
    itemTitle[2]="Allow Expired"
    itemTitle[3]="Allow Premature"
    itemTitle[4]="Allow Self Signed"

    itemID[0]="policy"
    itemID[1]="transparent"
    itemID[2]="expired"
    itemID[3]="premature"
    itemID[4]="selfsigned"

    blankItemContent[0]="$(show-sslmediate-policies ${SSLMEDIATE_POLICY})"
    blankItemContent[1]="type=checkbox$(checked ${SSLMEDIATE_TRANSPARENT})"
    blankItemContent[2]="type=checkbox$(checked ${SSLMEDIATE_EXPIRED})"
    blankItemContent[3]="type=checkbox$(checked ${SSLMEDIATE_PREMATURE})"
    blankItemContent[4]="type=checkbox$(checked ${SSLMEDIATE_SELFSIGNED})"

    itemForm[0]="select"

    shortcutMenuItem[0]="sslmediate-exception-domainname"
    shortcutMenuItem[1]="sslmediate-exception-urllist"
    shortcutMenuTitle[0]="Domain Name Exceptions"
    shortcutMenuTitle[1]="URL List Exceptions"

    show-title "SSL Mediation General Settings" "enabled" "sslmediate"
    show-shortcuts-menu
    show-form "${width}"
}

# Main()

show-sslmediate-policy-form
