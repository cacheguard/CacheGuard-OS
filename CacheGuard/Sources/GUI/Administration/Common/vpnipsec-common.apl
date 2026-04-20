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

show-vpnipsec-options()
{
    local in_value=${1}
    local values=${2}

    local selected value

    for value in ${values}
    do
	selected=$(get-selected-option ${value} "${in_value}")
	echo "<option value='${value}'${selected}>${value}</option>"
    done
}

show-vpnipsec-states()
{
    show-vpnipsec-options ${1} "on off"
}

show-vpnipsec-encryptions()
{
    show-vpnipsec-options ${1} "aes128 aes192 aes256 aes128ctr aes192ctr aes256ctr"
}

show-vpnipsec-integrities()
{
    show-vpnipsec-options ${1} "sha1 sha256 sha384 sha512"
}

show-vpnipsec-dh()
{
    show-vpnipsec-options ${1} "modp1536 modp2048 modp3072 modp4096 modp6144 modp8192 ecp192 ecp224 ecp256 ecp384 ecp521 ecp224bp ecp256bp ecp384bp ecp512bp"
}

show-vpnipsec-authenticates()
{
    local methods="psk tls eaptls"

    show-vpnipsec-options ${1} "${methods}"
}

show-vpnipsec-site-authenticates()
{
    local methods="psk tls"

    show-vpnipsec-options ${1} "${methods}"
}

show-vpnipsec-tls-authenticates()
{
    echo "<option value=''></option>"
    show-vpnipsec-options "${1}" "certificate dn fqdn"
}

show-vpnipsec-auto-psk()
{
    show-vpnipsec-options "${1}" "no yes"
}

show-vpnipsec-tls()
{
    echo "<option value=''></option>"
    show-vpnipsec-options "${1}" "${TLS_SERVER_LIST}"
}

show-vpnipsec-nat-role()
{
    echo "<option value='raz'></option>"
    show-vpnipsec-options "${1}" "active passive"
}
