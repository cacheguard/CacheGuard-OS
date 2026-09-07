/*
###########################################################################
#
# MODULE:       VPN Subscription
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
*/

var LOGOUT_TIMEOUT = 1800000;
var LOGOUT_TIMER = null;
var UPDATE_TIMER = null;

initAutoLogout( );
activateContent( );

document.addEventListener( 'click', function( event ) {

    const element = event.target.closest( '[data-action]' );

    if ( !element ) {
        return;
    }

    if ( !( element instanceof HTMLInputElement && element.type === 'checkbox' ) ) {
	event.preventDefault( );
    }

    switch (element.dataset.action) {

    case 'copy-to-clipboard':
	copyToClipboard( element.dataset.textAreaId, element.id, element.dataset.content );
	break;

    case 'confirm-reset':
	
	break;

    default:
	return false;
	break;
    }

    return true;
} );
