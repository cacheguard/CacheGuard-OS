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

print-encrypt()
{
    local encrypt selected

    for encrypt in aes des
    do
	if test ${encrypt} == "${1}" ; then
	    selected=selected
	else
	    unset selected
	fi
	echo -n "<option value='${encrypt}' ${selected}>${encrypt}</option>"
    done
}

show-kerberos-dc-form()
{
    local width

    itemWidth[0]=30
    itemWidth[1]=70

    itemTitle[0]="Encryption Type"
    itemTitle[1]="AD Relative DN (of this system)"
    itemTitle[2]="Service Name (of this system)"
    itemTitle[3]="HA Shared Password"
    itemTitle[4]="HA Shared Password [Retype]"
    itemTitle[5]="This system Full DN"

    itemID[0]="encrypt"
    itemID[1]="ad_rdn"
    itemID[2]="service_name"
    itemID[3]="password1"
    itemID[4]="password2"
    itemID[5]="fdn"

    local dc_chain=$(get-domain-controller-chain ${DOMAIN_NAME})
    local fdn="cn=${KERBEROS_SERVICE_NAME},${AD_WEBGATEWAY_RDN},${dc_chain}"

    blankItemContent[0]=$(print-encrypt ${KERBEROS_ENCRYPT_TYPE})
    blankItemContent[1]="type='text' size='64' maxlength='256' value='${AD_WEBGATEWAY_RDN}'"
    blankItemContent[2]="type='text' size='16' maxlength='64' value='${KERBEROS_SERVICE_NAME}'"
    blankItemContent[3]="type='password' size='24' maxlength='32'"
    blankItemContent[4]="type='password' size='24' maxlength='32'"
    blankItemContent[5]="${fdn}"

    itemForm[0]="select"
    itemForm[5]="text"

    checkItem[1]=dn
    checkItem[2]=service_name
    checkItem[3]=printable
    checkItem[4]=printable

    shortcutMenuItem[0]="names"
    shortcutMenuTitle[0]="Domain Name"

    shortcutMenuItem[1]="authenticate-kerberos-create"
    shortcutMenuTitle[1]="Kerberos Initialization"

    show-title "Kerberos Authentication Settings" "enabled" "authenticate domainname"

    test \
	-z "${CURRENT_KERBEROS_SERVER_LIST}" -o \
	"${CURRENT_AUTHENTICATE_MODE}" == False -o \
	"${CURRENT_AUTHENTICATE_KERBEROS}" == False \
	|| show-shortcuts-menu

    show-form "${width}"
}

# Main()

show-kerberos-dc-form
