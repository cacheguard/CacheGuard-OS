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

select-registration-mode()
{
    local mode="${1}"
    local link="${2}"
    local email="${3}"

    call-js-function "registrationModeSelectCB( '${mode}', '${link}', '${email}' )"
}

select-registration-action()
{
    local action="${1}"
    local os_key="${2}"

    call-js-function "registrationActionSelectCB( '${action}', '${os_key}' )"
}

print-sn-mode()
{
    local selected

    if test "${1}" == new ; then selected="selected " ; else unset selected ; fi
    echo -n "<option value='new'${selected}>First Registration</option>"

    if test "${1}" == old ; then selected="selected " ; else unset selected ; fi
    echo -n "<option value='old'${selected}>Recover S/N</option>"
}

print-registration-action()
{
    local license_state deregister_state

    if test ${OS_FREE_USAGE} == False ; then
	if test -f ${TMP_DIR}/${UNREGISTER_SN} ; then
	    deregister_state=' selected'
	else
	    license_state=' selected'
	fi

	echo -n "<option value='register'${license_state}selected>Register License Key</option>"
    fi

    echo -n "<option value='unregister'${deregister_state}>Deregister Appliance</option>"
}

print-comment()
{
    test -n "${1}" || return 0
    local comment=${1}

    local network_page=$(get-upper-page "ip.${GUI_EXT_NAME}")
    echo "<div style='margin:0; padding:5px;'>"
    echo "<div class='shortcut-menu-item' style='font-weight:normal;'><a href='${network_page}'>${comment}</a></div>"
    echo "</div>"
    echo "<div style='clear:left;'></div>"
}

show-register-form()
{
    local subscription_title="MANAGE SUBSCRIPTION"

    if ! is-subscription-required ; then
	show-title "Registration Services" disabled "register"
	echo "<div class='core-form'>"
	gui-information-message "The registration is not required/available on this system."
	return 0
    fi

    local subscription_url accept_index posted_accept_index
    local subscription_link comment
    local state accept_value mode_value width
    local title after_function
    
    local accept_id=accept
    local id=$(get-system-id)
    local i=0

    itemTitle[${i}]="Serial Number"
    itemID[${i}]="id"
    blankItemContent[${i}]=${id}
    itemForm[${i}]="text"
    ((i++))

    if is-registered-appliance ; then

	title="License Registration & Subscription"
	subscription_url=$(get-subscription-url)

	if test ${?} -eq 0 ; then
	    subscription_link="<a href='${subscription_url}' target='_blank'>${subscription_title}</a>"
	else
	    subscription_link="<i>Unavailable</i>"
	    comment="To purchase a subscription or check the state of your subscription the appliance should be connected to the Internet and have Web access to ${COMMERCIAL_NAME} registration services."
	fi

	local os_key

	test ! -f ${TMP_DIR}/${REGISTER_KEY} || os_key=$(cat ${TMP_DIR}/${REGISTER_KEY})

	local action_id="action"
	local os_key_id="os_key"

	after_function="select-registration-action ${action_id} ${os_key_id}"

	itemTitle[${i}]="Action"
	itemID[${i}]=${action_id}
	itemForm[${i}]="select"
	blankItemContent[${i}]=$(print-registration-action)
	itemFormSelectCB[${i}]="registrationActionSelectCB( '${action_id}', '${os_key_id}' );"
	((i++))

	if test ${OS_FREE_USAGE} == True ; then
	    itemTitle[${i}]="Services Subscription URL"
	else
	    itemTitle[${i}]="Subscription URL"
	fi

	itemID[${i}]='subscription_url'
	blankItemContent[${i}]="${subscription_link}"
	itemForm[${i}]="text"
	((i++))

	itemID[${i}]=${os_key_id}
	itemTitle[${i}]="OS License Key"
	checkItem[${i}]=printable
	blankItemContent[${i}]="type='text' size='44' maxlength='64' value='${os_key}' autocomplete='off'"
	((i++))

	if test ${OS_FREE_USAGE} == True ; then
	    itemTitle[${i}]=""
	    itemID[${i}]='free_usage'
	    blankItemContent[${i}]="<span style='font-style:italic; color:SeaGreen;'>Since CacheGuard-OS version UF-2.4.1, no license key is required to run the appliance. However, we strongly recommend purchasing a support contract. To do so, please click on the <span style='font-style:normal;'>${subscription_title}</span> link above.</span>"
	    itemForm[${i}]="text"
	    ((i++))
	fi

	accept_index=${i}
    else
	local mode="mode"
	local email="email"
	local link="link"
	title="Appliance Registration"
	id="${id} (<i>temporary</i>)"
	subscription_url=$(get-registration-otp-url)

	if test ${?} -eq 0 ; then
	    subscription_link="<span id='${link}'><a href='${subscription_url}' target='_blank'>Get a One Time Password</a></span>"
	else
	    subscription_link="<i>Unavailable</i>"
	    comment="To initiate the registration process the appliance should be connected to the Internet and have Web access to ${COMMERCIAL_NAME} registration services."
	fi

	mode_value=${VALUES[0]}
	after_function="select-registration-mode ${mode} ${link} ${email}"

	itemTitle[${i}]="Mode"
	itemID[${i}]=${mode}
	blankItemContent[${i}]=$(print-sn-mode ${mode_value})
	itemFormSelectCB[${i}]="registrationModeSelectCB( '${mode}', '${link}', '${email}' );"
	itemForm[${i}]="select"
	((i++))

	itemTitle[${i}]="Contact Email"
	itemID[${i}]=${email}
	blankItemContent[${i}]="type='text' size='32' maxlength='$[${MAX_LEN} * 2]' value='${VALUES[1]}'"
	checkItem[${i}]=email
	((i++))

	itemTitle[${i}]="<strong>Important Notice</strong>"
	itemID[${i}]='commitment'
	blankItemContent[${i}]="<span style='font-style:italic;color:SeaGreen;'>We are responsible email senders and never misuse your address. However, some providers may block our messages - Please check your spam folder or use another email.</span>"
	itemForm[${i}]="text"
	((i++))

	itemTitle[${i}]="Registration URL"
	itemID[${i}]='otp_url'
	blankItemContent[${i}]="${subscription_link}"
	itemForm[${i}]="text"
	((i++))

	itemTitle[${i}]="Obtained OTP"
	itemID[${i}]='otp'
	blankItemContent[${i}]="type='password' size='40' maxlength='64' value='${VALUES[2]}' autocomplete='off'"
	checkItem[${i}]=printable
	((i++))

	accept_index=${i}
    fi

    posted_accept_index=$[${accept_index} - 1]

    if test "${ATTRIBUTES[${posted_accept_index}]}" == ${accept_id} ; then
	state="enabled"
    else
	state="disabled"
    fi

    test ${state} == disabled || accept_value=" checked"

    itemTitle[${accept_index}]="I agree to terms of the <a href='/doc/command/license.html' target='_blank'>${COMMERCIAL_NAME}-OS License</a>"
    itemID[${accept_index}]="${accept_id}"
    blankItemContent[${accept_index}]="type='checkbox'${accept_value} onClick='agreeLicense(\"${accept_id}\")'"

    show-title "${title}" ${state} "register"
    print-comment "${comment}"
    show-form "${width}" ${state} "${after_function}"
}

# Main()

show-register-form
