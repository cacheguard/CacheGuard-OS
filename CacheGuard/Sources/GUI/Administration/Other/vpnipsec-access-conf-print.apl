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

print-vpnipsec-access-conf()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local client_type=${1}
    local client_tls_id=${2}

    local pre_profile_id='profile-clipboard'
    local textarea_password_id='password-clipboard'

    local password_file=${SSL_CLIENT_DIR}/${client_tls_id}.cur/${client_tls_id}.password
    local title="Send the Certificate Password via WhatsApp"

    echo "<table class='report' width='100%'><tr><td>$(show-pre-clipboard-copy ${pre_profile_id} 'Profile')$(show-file-content-clipboard-copy ${password_file} ${textarea_password_id} 'Certificate Password')$(show-send-file-content-by-sms ${password_file} "${title}")"
    echo "<pre id='${pre_profile_id}'>"

    execute-command-with-output "vpnipsec access conf ${client_type} ${client_tls_id} show"

    echo '</pre>'
    echo '</td></tr></table>'
}

gui-run-authentication
print-vpnipsec-access-conf "${@}"
