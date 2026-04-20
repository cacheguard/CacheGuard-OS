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

show-tls-generate-form()
{
    local get_args=${1}
    local tls=$(get-arg-value "${get_args}" key)

    if test -z "${tls}" ; then
	redirect-page "tls"
	return 0
    fi

    local width=600

    itemWidth[0]=30
    itemWidth[1]=70

    local names numbits days country province locality organisation unit sign ocsp

    itemTitle[0]="Hidden"
    itemTitle[1]="TLS ID"
    itemTitle[2]="Common Name(s)"
    itemTitle[3]="RSA Key Size (bits)"
    itemTitle[4]="Validity Days"
    itemTitle[5]="Country Code"
    itemTitle[6]="Province Name"
    itemTitle[7]="Locality Name"
    itemTitle[8]="Organisation Name"
    itemTitle[9]="Unit Name"

    if gui-contextual-is-allowed ; then
	itemTitle[10]="Sign with the CA"
	itemTitle[11]="Use OCSP<br />(${OCSP_HOST})"
    fi

    itemID[0]="tls"
    itemID[1]="not_posted"
    itemID[2]="names"
    itemID[3]="numbits"
    itemID[4]="days"
    itemID[5]="country"
    itemID[6]="province"
    itemID[7]="locality"
    itemID[8]="organisation"
    itemID[9]="unit"

    if gui-contextual-is-allowed ; then
	itemID[10]="sign"
	itemID[11]="ocsp"

	if check-tls-cert-2gen ${tls} ; then
	    if check-tls-cert-2sign ${tls} ; then
		sign=" checked"
		! check-tls-cert-use-ocsp ${tls} || ocsp=" checked"
	    fi
	else
	    ! check-tls-cert-signed-by-system-ca server ${tls} || sign=" checked"
	    ! check-tls-cert-use-ocsp ${tls} || ocsp=" checked"
	fi
    fi

    if test "${REQUEST_METHOD}" == POST ; then
	names="${VALUES[1]}"
	numbits="${VALUES[2]}"
	days="${VALUES[3]}"
	country="${VALUES[4]}"
	province="${VALUES[5]}"
	locality="${VALUES[6]}"
	organisation="${VALUES[7]}"
	unit="${VALUES[8]}"
    else
	numbits=2048
    fi

    blankItemContent[0]="value='${tls}'"
    blankItemContent[1]="${tls}"
    blankItemContent[2]="cols='48' rows='3'"
    blankItemContent[3]="type='text' size='5' maxlength='4' value='${numbits}'"
    blankItemContent[4]="type='text' size='8' maxlength='8' value='${days}'"
    blankItemContent[5]=$(show-tls-country ${country})
    blankItemContent[6]="type='text' size='24' maxlength='32' value='${province}'"
    blankItemContent[7]="type='text' size='24' maxlength='32' value='${locality}'"
    blankItemContent[8]="type='text' size='24' maxlength='32' value='${organisation}'"
    blankItemContent[9]="type='text' size='24' maxlength='32' value='${unit}'"

    if gui-contextual-is-allowed ; then
	blankItemContent[10]="type='checkbox'${sign}"
	blankItemContent[11]="type='checkbox'${ocsp}"
    fi

    checkItem[2]=text
    checkItem[3]=digit
    checkItem[4]=digit
    checkItem[5]=alphanum
    checkItem[6]=printable
    checkItem[7]=printable
    checkItem[8]=printable
    checkItem[9]=printable

    itemForm[0]="hidden"
    itemForm[1]="text"
    itemForm[2]="textarea"
    itemForm[5]="select"

    itemValue[2]=${names}

    shortcutMenuItem[0]="tls-ocsp-etc"
    shortcutMenuTitle[0]="OCSP Settings"

    show-title "Generate Server TLS" "enabled" "tls"
    show-shortcuts-menu
    show-form "${width}" enabled

    if test "${REQUEST_METHOD}" != POST ; then
	echo '<script type="text/javascript">'
	echo "doNothingOnEnterInInput( 'names' );"
	echo "AJAX_updateTLSConf( '/${GUI_DIR_NAME}/tls-print.${GUI_EXT_NAME}?server:${tls},${DOMAIN_NAME}+conf', 'names', 'numbits', 'days', 'country', 'province', 'locality', 'organisation', 'unit' );"
	echo '</script>'
    fi
}

# Main()

show-tls-generate-form "${@}"
