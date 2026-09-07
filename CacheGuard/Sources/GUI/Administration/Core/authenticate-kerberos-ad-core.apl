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

show-kerberos-dc-form()
{
    local width state

    test ${AUTHENTICATE_AD_MODE} == True || state=' disabled'
    itemWidth[0]=30
    itemWidth[1]=70

    itemTitle[0]="HTTP Proxy Service Name"
    itemTitle[1]="Active Directory Mode"
    itemTitle[2]="HTTP Proxy Service Principal"
    itemTitle[3]="AD Relative DN (of this Gateway)"
    itemTitle[4]="AD Account Login"
    itemTitle[5]="AD Account Password"
    itemTitle[6]="AD Account Password [Retype]"
    itemTitle[7]="AD Full DN"

    local rdn_id='rdn'
    local login_id='login'
    local password1_id='password1'
    local password2_id='password2'

    itemID[0]="service_name"
    itemID[1]="ad"
    itemID[2]="principal"
    itemID[3]=${rdn_id}
    itemID[4]=${login_id}
    itemID[5]=${password1_id}
    itemID[6]=${password2_id}
    itemID[7]="fdn"

    local dc_chain=$(get-domain-controller-chain ${DOMAIN_NAME})
    local fdn="cn=${KERBEROS_SERVICE_NAME},${AD_WEBGATEWAY_RDN},${dc_chain}"
    local principal="HTTP/${KERBEROS_SERVICE_NAME}.${DOMAIN_NAME}@${DOMAIN_NAME^^}"

    blankItemContent[0]="type='text' size='15' maxlength='15' value='${KERBEROS_SERVICE_NAME}'"
    blankItemContent[1]=$(show-on-off-state $(external-form "${AUTHENTICATE_AD_MODE}"))
    blankItemContent[2]="${principal}"
    blankItemContent[3]="type='text' size='48' maxlength='256' value='${AD_WEBGATEWAY_RDN}'${state}"
    blankItemContent[4]="type='text' size='24' maxlength='32' value='${AD_WEBGATEWAY_LOGIN}'${state}"
    blankItemContent[5]="type='password' size='24' maxlength='${MAX_LEN}'${state}"
    blankItemContent[6]="type='password' size='24' maxlength='${MAX_LEN}'${state}"
    blankItemContent[7]="${fdn}"

    itemForm[1]="select"
    itemForm[2]="text"
    itemForm[7]="text"

    checkItem[0]=computer_name
    checkItem[3]=dn
    checkItem[4]=printable
    checkItem[5]=printable
    checkItem[6]=printable

    itemData[1]="data-action='authenticate-kerberos-ad' data-rdn-id='${rdn_id}' data-login-id='${login_id}' data-password1-id='${password1_id}' data-password2-id='${password2_id}'"

    shortcutMenuItem[0]="names"
    shortcutMenuTitle[0]="Domain Name"

    shortcutMenuItem[1]="authenticate-kerberos-create"
    shortcutMenuTitle[1]="Kerberos Initialization"

    show-title "Kerberos Authentication Settings" "enabled" "authenticate domainname"
    show-form "${width}"
}

# Main()

show-kerberos-dc-form
