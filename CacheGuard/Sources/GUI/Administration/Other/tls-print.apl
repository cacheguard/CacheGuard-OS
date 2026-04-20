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

print-tls-certificate()
{
    test -n "${1}" || return 1
    local file=${1}

    openssl x509 -in ${file} -text -noout 2> /dev/null
    echo
    openssl x509 -in ${file} -fingerprint -sha256 -noout 2> /dev/null
    openssl x509 -in ${file} -fingerprint -sha1 -noout 2> /dev/null
    echo
    cat ${file}
}

print-fingerprint()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local sha1=${1}
    local sha256=${2}

    sha1=${sha1/*= }
    sha1=${sha1^^}

    sha256=${sha256/*= }
    sha256=${sha256^^}

    echo "SHA256 ${sha256}"
    echo "SHA1   ${sha1}"    
}

print-tls-key()
{
    test -n "${1}" || return 1
    local file=${1}

    local sha1=$(openssl dgst -sha1 -c ${file} 2> /dev/null)
    local sha256=$(openssl dgst -sha256 -c ${file} 2> /dev/null)

    echo "Fingerprints of this private key are as follows:"
    echo
    print-fingerprint "${sha1}" "${sha256}"
}

show-tls-clipboard-copy()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local component=${1}
    local pre_id=${2}

    case ${component} in
	certificate|csr|pfx)
	    show-pre-clipboard-copy ${pre_id}
	    ;;
	*)
	    ;;
    esac
}

show-send-password-by-sms()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local component=${1}
    local password_file=${2}

    case ${component} in
	password)
	    local title="Send the Certificate Password via WhatsApp"
	    local textarea_password_id='password-clipboard'

	    show-file-content-clipboard-copy ${password_file} ${textarea_password_id} 'Password'
	    show-send-file-content-by-sms ${password_file} "${title}"
	    ;;
	*)
	    ;;
    esac
}

print-tls-server-component()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local tls=${1}
    local component=${2}

    local file head title
    local pre_id='clipboard'

    echo "<table class='report' width='100%'><tr><td>$(show-tls-clipboard-copy ${component} ${pre_id})"
    echo "<pre id='${pre_id}'>"

    case ${component} in
	csr)
	    title=${component^^}
	    file=$(get-tls-server-component-file ${tls} ${component})
	    ;;
	certificate)
	    title=${component^}
	    file=$(get-tls-server-component-file ${tls} ${component})
	    ;;
	key)
	    title="Private ${component^}"
	    file=$(get-tls-server-component-file ${tls} ${component})
	    ;;
	der)
	    title="Certificate"
	    file=$(get-tls-server-component-file ${tls} certificate)
	    ;;
	*)
	    ;;
    esac

    if test ! -f ${file} ; then
	echo-unavailable-message "This ${title} is not available."
    else
	case ${component} in
	    csr)
		openssl req -in ${file} -text -noout 2> /dev/null
		echo
		cat ${file}
		;;
	    certificate)
		print-tls-certificate ${file}
		;;
	    key)
		print-tls-key ${file}
		;;
	    *)
		;;
	esac
    fi

    echo '</pre>'
    echo '</td></tr></table>'
}

print-tls-ca-system-component()
{
    test -n "${1}" || return 1
    local component=${1}

    local file head title
    local pre_id='clipboard'

    echo "<table class='report' width='100%'><tr><td>$(show-tls-clipboard-copy ${component} ${pre_id})"
    echo "<pre id='${pre_id}'>"

    case ${component} in
	certificate)
	    title=${component^}
	    file=$(get-tls-ca-system-component-file ${component})
	    ;;
	key)
	    title="Private ${component^}"
	    file=$(get-tls-ca-system-component-file ${component})
	    ;;
	der)
	    title="Certificate"
	    file=$(get-tls-ca-system-component-file certificate)
	    ;;
	*)
	    ;;
    esac

    if test ! -f ${file} ; then
	echo-unavailable-message "This ${title} is not available."
    else
	case ${component} in
	    certificate)
		print-tls-certificate ${file}
		;;
	    key)
		print-tls-key ${file}
		;;
	    der)
		local sha1=$(openssl x509 -noout -fingerprint -sha1 -in ${file} 2> /dev/null)
		local sha256=$(openssl x509 -noout -fingerprint -sha256 -in ${file} 2> /dev/null)

		sha1=${sha1/SHA1 Fingerprint=}
		sha256=${sha256/SHA256 Fingerprint=}

		echo "Fingerprints of this certificate are as follows:"
		echo
		print-fingerprint "${sha1}" "${sha256}"
		;;
	    *)
		;;
	esac
    fi

    echo '</pre>'
    echo '</td></tr></table>'
}

echo-tls-conf()
{
    test -n "${1}" || return 1
    local conf_file=${1}
    test -f ${conf_file} || return 11

    local numbits days names country province locality organisation unit
    local var val

    while read var val
    do
	case ${var} in
	    numbits)
		numbits=${val}
		;;
	    days)
		days=${val}
		;;
	    commonName)
		names=${val}
		;;
	    countryName)
		country=${val}
		;;
	    stateOrProvinceName)
		province=${val}
		;;
	    localityName)
		locality=${val}
		;;
	    organizationName)
		organisation=${val}
		;;
	    organizationalUnitName)
		unit=${val}
		;;
	    *)
		;;
	esac
    done < ${conf_file}

    echo -n "${names}|${numbits}|${days}|${country}|${province}|${locality}|${organisation}|${unit}"
}

print-tls-default-conf()
{
    test -n "${1}" || return 1
    local default_names=${1}

    local default_numbits='2048'
    local default_days='365'
    local default_country=''
    local default_province=''
    local default_locality=''
    local default_organisation=''
    local default_unit='Security'

    echo -n "${default_names}|${default_numbits}|${default_days}|${default_country}|${default_province}|${default_locality}|${default_organisation}|${default_unit}"
}

print-tls-server-conf()
{
    test -n "${1}" || return 1
    local tls_domain_name=${1}

    local tls=${tls_domain_name/,*}

    local conf_file=$(get-tls-server-component-file ${tls} conf)
    local tmp_conf_file=/tmp/${tls}.work.conf.${$}

    if test ! -f ${conf_file} ; then
	local cert_file=$(get-tls-server-component-file ${tls} certificate)
	if test ! -f ${cert_file} ; then
	    local csr_file=$(get-tls-server-component-file ${tls} csr)
	    if test ! -f ${csr_file} ; then

		local domain_name=${tls_domain_name/*,}
		local name=${tls,,}
		test "${name}" != "${name//.}" || name=${name}.${domain_name}

		print-tls-default-conf "${name}"
		return 0
	    else
		gen-tls-conf ${csr_file} csr > ${tmp_conf_file}
		conf_file=${tmp_conf_file}
	    fi
	else
	    gen-tls-conf ${cert_file} > ${tmp_conf_file}
	    conf_file=${tmp_conf_file}
	fi
    fi

    echo-tls-conf ${conf_file}
    rm -f ${tmp_conf_file}
}

print-tls-ca-system-conf()
{
    local conf_file=$(get-tls-ca-system-component-file conf)
    local tmp_conf_file=/tmp/ca.system.work.conf.${$}

    if test ! -f ${conf_file} ; then
	local cert_file=$(get-tls-ca-system-component-file certificate)
	if test ! -f ${cert_file} ; then
	    print-tls-default-conf "${DEFAULT_CA_CN}"
	    return 0
	else
	    gen-tls-conf ${cert_file} > ${tmp_conf_file}
	    conf_file=${tmp_conf_file}
	fi
    fi

    echo-tls-conf ${conf_file}
    rm -f ${tmp_conf_file}
}

print-tls-ca-third()
{
    test -n "${1}" || return 1
    local ca_id=${1}

    local pre_id='clipboard'

    echo "<table class='report' width='100%'><tr><td>$(show-tls-clipboard-copy certificate ${pre_id})"
    echo "<pre id='${pre_id}'>"

    local file=$(get-tls-ca-file ${ca_id})

    if test -f ${file} ; then
	openssl x509 -in ${file} -text -noout 2> /dev/null
	echo
	openssl x509 -in ${file} -fingerprint -sha256 -noout 2> /dev/null
	openssl x509 -in ${file} -fingerprint -sha1 -noout 2> /dev/null
	echo
	cat ${file}
    else
	echo-unavailable-message "This CA Certificate is not available."
    fi

    echo '</pre>'
    echo '</td></tr></table>'
}

print-tls-client-component()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local tls=${1}
    local component=${2}

    local file head title

    local pre_id='clipboard'

    case ${component} in
	certificate)
	    title=${component^}
	    file=$(get-tls-client-component-file ${tls} certificate)
	    ;;
	key)
	    title="Private ${component^}"
	    file=${tls}.cur/${tls}.key
	    ;;
	pkcs12)
	    title="Private ${component^^} bundle"
	    file=${tls}.cur/${tls}.pkcs12
	    ;;
	pfx)
	    title="${component^^} (base 64 encoded form of the PKCS12)"
	    file=${tls}.cur/${tls}.pfx
	    ;;
	password)
	    title="PKCS12 ${component^}"
	    file=${tls}.cur/${tls}.password
	    ;;
	*)
	    ;;
    esac

    echo "<table class='report' width='100%'><tr><td>$(show-tls-clipboard-copy ${component} ${pre_id})$(show-send-password-by-sms ${component} ${file})"
    echo "<pre id='${pre_id}'>"

    if test ! -f ${file} ; then
	echo-unavailable-message "This ${title} is not available."
    else
	case ${component} in
	    certificate)
		openssl x509 -in ${file} -text -noout 2> /dev/null
		echo
		openssl x509 -in ${file} -fingerprint -sha256 -noout 2> /dev/null
		openssl x509 -in ${file} -fingerprint -sha1 -noout 2> /dev/null
		echo
		cat ${file}
		;;
	    key)
		print-tls-key ${file}
		;;
	    pkcs12)
		echo-unavailable-message "This ${title} is not in plain text format and thus can't be displayed here."
		;;
	    pfx)
		cat ${file} 2> /dev/null
		;;
	    password)
		echo "For security reasons the password protecting a PKCS12 or PFX file can't be displayed here."
		;;
	    *)
		;;
	esac
    fi

    echo '</pre>'
    echo '</td></tr></table>'
}

print-tls()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local tls=${1}
    local component=${2}

    local tls_type=${tls/:*}
    local tls_id=${tls/*:}

    case ${tls_type} in
	server)
	    case ${component} in
		conf)
		    print-tls-server-conf ${tls_id}
		    ;;
		key|csr|certificate)
		    print-tls-server-component ${tls_id} ${component}
		    ;;
		*)
		    return 1
		    ;;
	    esac
	    ;;
	client)
	    cd ${SSL_CLIENT_DIR}

	    case ${component} in
		key|certificate|pkcs12|pfx|password)
		    print-tls-client-component ${tls_id} ${component}
		    ;;
		*)
		    ;;
	    esac
	    ;;
	ca)
	    case ${tls_id} in
		system)
		    case ${component} in
			conf)
			    print-tls-ca-system-conf
			    ;;
			key|certificate|der)
			    print-tls-ca-system-component ${component}
			    ;;
			*)
		    ;;
		    esac
		    ;;
		*)
		    case ${component} in
			certificate)
			    print-tls-ca-third ${tls_id}
			    ;;
			*)
			    ;;
		    esac
		    ;;
	    esac
	    ;;
	*)
	    ;;
    esac
}

gui-run-authentication
print-tls "${@}"
