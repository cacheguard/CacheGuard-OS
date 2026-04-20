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

show-password-login-form()
{
    local title="First Login"
    local help_commands="admin password"

    case ${REQUEST_METHOD} in
	GET)
	    local go_ahead
	    ! is-first-login ${USER} || go_ahead=yes
	    ! is-admin-2fa-enabled || is-admin-2fa-is-running ${USER} || go_ahead=yes

	    if test -z "${go_ahead}" ; then
		show-title "${title}" "disabled" "${help_commands}"
		form-error-message 300 "This page is not available in this context."
		return 0
	    fi
	    ;;
	POST)
	    local gui_command=$(get-command-name)

	    if test ${gui_command} == 'submit-first-login' ; then
		local j=0 k=8
		if test ${USER} != ${ADMIN_NAME} && is-admin-2fa-enabled && ! is-admin-2fa-is-running ${USER} ; then
		    while true
		    do
			test ${j} -lt ${k} || break
			usleep 2500000
			! is-admin-2fa-is-running ${USER} || break
			((j++))
		    done
		fi

		if is-first-login ${USER} && ! error-occured ; then
		    j=0 k=8
		    while true
		    do
			test ${j} -lt ${k} || break
			usleep 2500000
			is-first-login ${USER} || break
			((j++))
		    done
		fi
	    fi
	    ;;
	*)
	    return 0
	    ;;
    esac

    local qrcode_message="As the 2FA mode is activated on this appliance, you should scan the displayed QR code with your Authenticator App and save displayed emergency codes in a safe place"
    local first_login init_2fa message
    local i=0

    if is-first-login ${USER} ; then
	first_login='yes'
	message="You are invited to modify your login password."
    fi

    test ${USER} != ${ADMIN_NAME} && is-admin-2fa-enabled && ! is-admin-2fa-is-running ${USER} && init_2fa=yes

    case ${REQUEST_METHOD} in
	GET)
	    if test -n "${init_2fa}" -a ${USER} != ${ADMIN_NAME} ; then
		if test -n "${first_login}" ; then
		    message="${message} ${qrcode_message}"
		else
		    message="${qrcode_message}"
		fi

		message="${message}. <strong>It is important to note that you should do those actions before pressing the SUBMIT button as displayed codes would not be available afterwards.</strong>"
	    fi
	    ;;
	POST)
	    ;;
	*)
	    return 0
	    ;;
    esac

    itemWidth[0]=45
    itemWidth[1]=55

    itemForm[${i}]=text
    itemID[${i}]="login"
    itemTitle[${i}]="Login"
    blankItemContent[${i}]="${USER}" ; ((i++))

    if test -n "${first_login}" ; then
	itemTitle[${i}]="New Password" ; ((i++))
	itemTitle[${i}]="Retype New Password" ; ((i++))
    fi

    i=1

    if test -n "${first_login}" ; then
	itemID[${i}]="password1" ; checkItem[${i}]=printable
	blankItemContent[${i}]="type='password' size='24' maxlength='32'"
	((i++))

	itemID[${i}]="password2" ; checkItem[${i}]=printable
	blankItemContent[${i}]="type='password' size='24' maxlength='32'"
	((i++))
    fi

    if test -n "${init_2fa}" ; then

	execute-command "admin internal 2fa-initialise no"

       local organisation=$(get-tls-canonical-name ${SSL_CA_DIR}/${SYSTEM_CA}.certificate)
       local secrets=$(execute-command-with-output "admin internal 2fa-get-secrets")
       local secret=${secrets/ *}
       local mfa_init_url="otpauth://totp/${organisation}:${USER}@${SHOSTNAME}.${DOMAIN_NAME}?secret=${secret}&issuer=${COMMERCIAL_NAME}"
       local ecodes=${secrets#* }
       local qrcode_id='qrcode'
       local qrcode_size=95
       local ecode html_ecodes

       for ecode in ${ecodes}
       do
	   html_ecodes="${html_ecodes}<br />${ecode}"
       done
       html_ecodes=${html_ecodes:6}

       itemTitle[${i}]="2FA Authenticator QR Code<br />[<strong>To Scan Before Submit</strong>]"
       itemID[${i}]="${qrcode_id}"
       itemForm[${i}]='text'
       blankItemContent[${i}]=''
       ((i++))

       itemTitle[${i}]="2FA Authenticator Emergency Codes<br />[<strong>To Save in a Safe Place</strong>]"
       itemID[${i}]="ecodes"
       itemForm[${i}]='text'
       blankItemContent[${i}]="${html_ecodes}"
       ((i++))
    fi

    show-title "${title}" "enabled" "${help_commands}"

    if test -n "${first_login}" -o -n "${init_2fa}" ; then
	gui-information-message "${message}"
	show-form 500 enabled show-post-errors
    else
	show-post-errors
	message="Thank you to have modified your login password"
	if test ${USER} == ${ADMIN_NAME} ; then
	    message="${message}."
	else
	    message="${message} and/or initialised the 2FA for your account."
	fi
	message="${message}<a href='/'><img src='${IMAGE_DIR}/refresh.png' align='middle' title='Continue' /></a>"
	gui-information-message "${message}"
    fi

    if test -n "${init_2fa}" ; then
	cat <<EOF
<script type='text/javascript'>
var qrcode = new QRCode( document.getElementById( '${qrcode_id}' ), {
text: '${mfa_init_url}',
width: ${qrcode_size},
height: ${qrcode_size},
colorDark: 'FireBrick',
colorLight: 'White',
correctLevel: QRCode.CorrectLevel.M
} );
</script>
EOF
    fi
}

# Main()

show-password-login-form
