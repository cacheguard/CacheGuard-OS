/*
###########################################################################
#
# MODULE:       VPN Subscription
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
*/

var LOGOUT_TIMEOUT = 1800000;
var LOGOUT_TIMER = null;
var UPDATE_TIMER = null;

function resetUpdateTimer( )
{
    if (UPDATE_TIMER) {
	clearTimeout( UPDATE_TIMER );
	UPDATE_TIMER = null;
    }
}

function autoLogout( )
{
    resetUpdateTimer( );
    window.location = '/logout.php';
}

function armAutoLogout( )
{
    if (LOGOUT_TIMER) clearTimeout( LOGOUT_TIMER );
    LOGOUT_TIMER = setTimeout( "autoLogout( )", LOGOUT_TIMEOUT );
}

function initAutoLogout( )
{
    document.addEventListener( 'keydown', function( event ) {
	armAutoLogout( );
    } );

    document.addEventListener( 'keyup', function( event ) {
	armAutoLogout( );
    } );

    document.addEventListener( 'mousedown', function( event ) {
	armAutoLogout( );
    } );

    document.addEventListener( 'mouseup', function( event ) {
	armAutoLogout( );
    } );

    document.addEventListener( 'mousemove', function( event ) {
	armAutoLogout( );
    } );

    document.addEventListener( 'wheel', function( event ) {
	armAutoLogout( );
    } );

}

function copyToClipboard( text_area_id, icon_id, text )
{
    var icon = document.getElementById( icon_id );
    if ( icon == null) return false;

    var copy_icon_path = "image/clipboard.png";
    var ok_icon_path = "image/ok.png";

    var text_area = document.getElementById( text_area_id );

    if (text_area == null) {
	text_area = document.createElement( 'textarea' );
	text_area.setAttribute( 'id', text_area_id );
	document.body.append( text_area );
    }

    icon.src = ok_icon_path;

    setTimeout( function( ) {
	icon.src = copy_icon_path;
    }, 350 );

    text_area.textContent = text;
    text_area.style.visibility = 'visible';
    text_area.select( );
    document.execCommand( 'copy' );
    text_area.style.visibility = 'hidden';
}
