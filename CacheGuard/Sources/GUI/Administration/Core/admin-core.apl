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

is-ssh-generate-armed()
{
    test ! -f ${TMP_DIR}/${SSH_HOST_ARM_NEW} || echo -n checked
}

show-admin-form()
{
    local width=770
    local never="&lt;never generated&gt;"
    local role=$(gui-get-contextual-role)
    local i=0
    local rsa_fp

    itemWidth[0]=35
    itemWidth[1]=65

    itemTitle[${i}]="" ; ((i++))
    itemTitle[${i}]="SSH" ; ((i++))
    itemTitle[${i}]="SSH Server Key Fingerprints" ; ((i++))
    itemTitle[${i}]="Arm SSH Host Key Generation" ; ((i++))
    itemTitle[${i}]="SSH Password Authentication" ; ((i++))
    itemTitle[${i}]="Web Administration" ; ((i++))
    itemTitle[${i}]="SNMP" ; ((i++))

    i=0
    itemID[${i}]="dummy" ; ((i++))
    itemID[${i}]="ssh" ; ((i++))
    itemID[${i}]="ssh_fp" ; ((i++))
    itemID[${i}]="ssh_generate" ; ((i++))
    itemID[${i}]="ssh_password" ; ((i++))
    itemID[${i}]="wadmin" ; ((i++))
    itemID[${i}]="snmp" ; ((i++))

    if gui-is-in-template-context ${role} ; then
	rsa_fp="<i>NA</i>"
    else
	if test -f ${HARD_DIR}/${SSH_HOST_RSA_FP} ; then
	    rsa_fp=$(cat ${HARD_DIR}/${SSH_HOST_RSA_FP})
	else
	    rsa_fp=${never}
	fi
    fi

    i=0
    blankItemContent[${i}]="value='on'" ; ((i++))
    blankItemContent[${i}]="type=checkbox$(checked ${ADMIN_SSH})" ; ((i++))
    blankItemContent[${i}]="<span style='font-family:monospace;'>SHA256 (RSA): ${rsa_fp/*:}</span>" ; ((i++))
    blankItemContent[${i}]="type='checkbox' $(is-ssh-generate-armed)" ; ((i++))
    blankItemContent[${i}]="type=checkbox$(checked ${ADMIN_SSH_PASSWORD})" ; ((i++))
    blankItemContent[${i}]="type=checkbox$(checked ${ADMIN_WADMIN})" ; ((i++))
    blankItemContent[${i}]="type=checkbox$(checked ${ADMIN_SNMP})" ; ((i++))

    if gui-contextual-is-allowed ; then
	local web_auditing_title

	if test ${CURRENT_ADMIN_WAUDIT} == True ; then
	    web_auditing_title="<a href='https://${SERVER_NAME}:${CURRENT_WAUDIT_PORT}/' target='_blank'>Logs and Web Auditing</a>"
	else
	    web_auditing_title="Web Auditing"
	fi

	itemTitle[${i}]=${web_auditing_title}
	blankItemContent[${i}]="type=checkbox$(checked ${ADMIN_WAUDIT})"
	itemID[${i}]="waudit"
	((i++))
    fi

    itemForm[0]="hidden"
    itemForm[2]="text"

    local mfa_init_url

    if gui-is-in-top-level-context ; then

	local display_secrets ecodes
	local new_2fa=$(get-admin-2fa ${ADMIN_NAME} new)

	case ${USER} in

	    ${ADMIN_NAME})
		local cur_2fa=$(get-admin-2fa ${ADMIN_NAME} cur)

		if test ${new_2fa} != ${cur_2fa} -a ${new_2fa} == True ; then
		    display_secrets=yes
		fi
		;;
	    *)
		if is-admin-2fa-enabled ; then
		    is-admin-2fa-activated ${USER} || ! is-admin-2fa-initialised ${USER} || display_secrets=yes
		fi
		;;
	esac

	if test -n "${display_secrets}" ; then
	    local ecode html_ecodes
	    local organisation=$(get-tls-canonical-name ${SSL_CA_DIR}/${SYSTEM_CA}.certificate)
	    local secrets=$(execute-command-with-output "admin internal 2fa-get-secrets")
	    local secret=${secrets/ *}
	    ecodes=${secrets#* }
	    mfa_init_url="otpauth://totp/${organisation}:${USER}@${SHOSTNAME}.${DOMAIN_NAME}?secret=${secret}&issuer=${COMMERCIAL_NAME}"
	fi

	itemTitle[${i}]="2FA (Two Factor Authentication)"
	blankItemContent[${i}]="type=checkbox$(checked ${new_2fa})"
	itemID[${i}]="login_2fa"
	((i++))

	if test -n "${mfa_init_url}" ; then

	    local qrcode_id='qrcode'
	    local qrcode_size=95

	    itemForm[${i}]='text'
	    itemTitle[${i}]="2FA Authenticator QR Code<br />[<strong>To Scan Before Apply Operation</strong>]"
	    itemID[${i}]="${qrcode_id}"
	    blankItemContent[${i}]=''
	    ((i++))
	fi

	if test -n "${ecodes}" ; then
	    for ecode in ${ecodes}
	    do
		html_ecodes="${html_ecodes}<br />${ecode}"
	    done
	    html_ecodes=${html_ecodes:6}

	    itemForm[${i}]='text'
	    itemTitle[${i}]="2FA Authenticator Emergency Codes<br />[<strong>To Save in a Safe Place</strong>]"
	    itemID[${i}]="ecodes"
	    blankItemContent[${i}]="${html_ecodes}"
	    ((i++))
	fi

	if test -n "${display_secrets}" ; then

	    local qrcode_message="As the 2FA mode is activated on this appliance, you should scan the displayed QR code with your Authenticator App and save displayed emergency codes in a safe place. <strong>It is important to note that you should do those actions before applying the new configuration as displayed codes would not be available afterwards.</strong>"
	fi

    fi

    show-title "Administration Services" "enabled" "admin"
    form-error-message ${width} "${qrcode_message}"
    show-form "${width}"

    if test -n "${mfa_init_url}" ; then
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

show-admin-form
