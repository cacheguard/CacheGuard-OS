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

show-login-form()
{
    local action=${1}

    local width

    local user_id='user'
    local password_id='password'
    local focus_id

    itemWidth[0]=40
    itemWidth[1]=60

    local login_step=${VALUES[0]}

    case ${login_step} in
	2fa)
	    local user=${VALUES[1]}
	    local password=${VALUES[2]}
	    ;;
	*)
	    login_step=basic
	    ;;
    esac

    itemID[0]="authentication"
    itemForm[0]="hidden"
    blankItemContent[0]="value='${login_step}'"

    local password_len=24

    case ${login_step} in
	basic)
	    itemTitle[1]="Login name"
	    itemTitle[2]="Password"

	    itemID[1]=${user_id}
	    itemID[2]=${password_id}

	    blankItemContent[1]="type='text' size='24' maxlength='${MAX_USER_LEN}' value='' autocomplete='off'"
	    blankItemContent[2]="type='password' size='${password_len}' maxlength='32' value=''"
    
	    checkItem[1]=printable
	    checkItem[2]=printable

	    focus_id=${user_id}
	    ;;
	2fa)
	    itemForm[1]="hidden"
	    itemForm[2]="text"

	    itemID[1]=${user_id}
	    itemID[2]=dummy
	    itemID[3]=${password_id}

	    itemTitle[2]="Login name"
	    itemTitle[3]="Verification Code"

	    blankItemContent[1]="value='${user}'"
	    blankItemContent[2]=${user}
	    blankItemContent[3]="type='text' size='${password_len}' maxlength='32' value='' autocomplete='off'"

	    checkItem[3]=printable

	    focus_id=${password_id}
	    ;;
	*)
	    ;;
    esac

    process-main-action ${action}
    show-title-login
    show-form "${width}" enabled

    echo "<script type='text/javascript'>document.getElementById( '${focus_id}' ).focus( );</script>"
}

# Main()

show-login-form "${@}"
