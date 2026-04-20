/*
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
*/

var TILE_LOAD_INTERVAL = 100;
var CURRENT_TILE = false;
var TILES = [];

function mosaicOpen( parent_id, tile_id )
{
    var parent_obj = document.getElementById ( parent_id );
    if (!parent_obj) return false;

    var title = TILES[tile_id][0];
    var width = TILES[tile_id][1];
    var height = TILES[tile_id][2];
    var left = TILES[tile_id][3];
    var top = TILES[tile_id][4];

    var cgi = GUI_DIR + tile_id + "-dashboard" + GUI_EXTENSION;

    if (left == -1 && top == -1) {
	left = GUI_MOSAIC_LIMIT_LEFT + (GUI_MOSAIC_WIDTH / 2);
	top = GUI_MOSAIC_LIMIT_TOP + (GUI_MOSAIC_HEIGHT / 2)
	TILES[tile_id][3] = left;
	TILES[tile_id][4] = top;
    }

    width  += "px";
    height += "px";
    left   += "px";
    top    += "px";

    var args = "width=" + width + ",height=" + height + ",left=" + left + ",top=" + top + ", resize=0, scrolling=1";
    var tile_obj = dhtmlwindow.open( tile_id, 'inline', UNAVAILABLE_MSG, title, args, 'recal' );

    tile_obj.onclose = function( ) {
	mosaicClose( tile_id );
	return true;
    };

    $('#' + tile_id).on( 'mousedown', function( ) {
	mosaicMoveArm( tile_id );
    } );

    TILES[tile_id][5] = true;
    parent_obj.appendChild( tile_obj );

    $( tile_obj ).ready( function( ) {
	tile_obj.load( 'ajax', cgi, title );
    });

    return tile_obj;
}

function mosaicMoveArm( tile_id )
{
    var tile_obj = document.getElementById ( tile_id );
    if (!tile_obj) return false;

    CURRENT_TILE = tile_obj;
}

function mosaicMove( )
{
    if (!CURRENT_TILE) return false;
    
    var tile_obj = CURRENT_TILE;

    var left = tile_obj.offsetLeft;
    var top = tile_obj.offsetTop;
    var new_left, new_top;

    if (left <= GUI_MOSAIC_LIMIT_LEFT) {
	if (top <= GUI_MOSAIC_LIMIT_TOP) {
	    new_left = GUI_MOSAIC_LIMIT_LEFT;
	    new_top = GUI_MOSAIC_LIMIT_TOP;
	}
	else {
	    new_left = GUI_MOSAIC_LIMIT_LEFT;
	    new_top = top;
	}
    }
    else {
	if (top <= GUI_MOSAIC_LIMIT_TOP) {
	    new_left = left;
	    new_top = GUI_MOSAIC_LIMIT_TOP;
	}
	else {
	    new_left = left;
	    new_top = top;
	}
    }
    
    if (new_left != GUI_MOSAIC_LIMIT_LEFT) {
	new_left = Math.floor( new_left / GUI_MOSAIC_GRID_STICK ) * GUI_MOSAIC_GRID_STICK;
	if ((new_left % GUI_MOSAIC_GRID_STICK) != 0) {
	    new_left += GUI_MOSAIC_GRID_STICK
	}
    }

    if (new_top != GUI_MOSAIC_LIMIT_TOP) {
	new_top = Math.floor( new_top / GUI_MOSAIC_GRID_STICK ) * GUI_MOSAIC_GRID_STICK;
	if ((new_top % GUI_MOSAIC_GRID_STICK) != 0) {
	    new_top += GUI_MOSAIC_GRID_STICK
	}
    }

    tile_id = CURRENT_TILE.id;
    TILES[tile_id][3] = new_left;
    TILES[tile_id][4] = new_top;

    CURRENT_TILE = false;
}

function mosaicMoveInitialize(  )
{
    $(document).on( 'mouseup', function( ) { mosaicMove( ); } );
}

function mosaicClose( tile_id )
{
    var tile_obj = document.getElementById ( tile_id );
    if (!tile_obj) return false;
    TILES[tile_id][3] = -1;
    TILES[tile_id][4] = -1;
    TILES[tile_id][5] = false;
    CURRENT_TILE = false;
}

function mosaicShow( parent_id, tile_id )
{
    if (TILES[tile_id][5] == true) {
	var tile_obj = document.getElementById ( tile_id );
	if (!tile_obj) return false;

	var cgi = GUI_DIR + tile_id + "-dashboard" + GUI_EXTENSION;
	var title = TILES[tile_id][0];

	tile_obj.show( );
	tile_obj.load( 'ajax', cgi, title );

	return true;
    }

    mosaicOpen( parent_id, tile_id );
}

function refreshHealthChecks( )
{
    var get = $.get( GUI_DIR + "refresh-health-checks" + GUI_EXTENSION,
		     function( result, status )
		     {
			 switch (status) {
			 case "success":
			     break;

			 default:
			     break;
			 }
		     } );

    get.fail( function( ) { } );
}

function mosaicReloadAll( auto_id )
{
    var object = document.getElementById( auto_id );
    if (!object) return false;   

    var checked = object.checked;
    if (checked == false ) return false;

    refreshHealthChecks( );

    for (var tile_id in TILES) {
	var state = TILES[tile_id][5];
	if (state) {
	    var tile_obj = document.getElementById ( tile_id );
	    if (!tile_obj) continue;

	    var cgi = GUI_DIR + tile_id + "-dashboard" + GUI_EXTENSION;
	    var title = TILES[tile_id][0];

	    if (isURLAvailable( cgi )) {
		tile_obj.load( 'ajax', cgi, title );
	    }
	    else {
		tile_obj.load( 'inline', UNAVAILABLE_MSG, title );
	    }
	}
    }
}

function mosaicInitAutoReloadAll( auto_id, interval )
{
    setInterval( "mosaicReloadAll( '" + auto_id + "' )", interval * 1000 );
}

function mosaicReload( tile_id )
{
    var state = TILES[tile_id][5];

    if (state) {
	var tile_obj = document.getElementById ( tile_id );
	if (!tile_obj) return false;
	var cgi = GUI_DIR + tile_id + "-dashboard" + GUI_EXTENSION;
	var title = TILES[tile_id][0];
	tile_obj.load( 'ajax', cgi, title );
	return true;
    }
    else {
	return false;
    }
}

function mosaicGetSerializeLayout( )
{
    var layout = "";
    var sep = '+';

    for (var tile_id in TILES) {
	var title = TILES[tile_id][0];
	var width = TILES[tile_id][1];
	var height = TILES[tile_id][2];
	var left = TILES[tile_id][3];
	var top = TILES[tile_id][4];
	var state = TILES[tile_id][5];
	
	var encoded_title = UTF82B64( title );

	var value = encoded_title + sep +  width + sep + height + sep + left + sep + top + sep + state;
	layout += "&" + tile_id + "=" + value;
    }

    layout = layout.substring( 1 );
    return layout;
}

function setWorkingButton( icon_image_id )
{
    var icon_image = document.getElementById( icon_image_id );
    if (!icon_image) return false;

    icon_image.src = GUI_IMAGE_DIR + "working-flower.gif";
}

function unsetWorkingButton( icon_image_id, page )
{
    var icon_image = document.getElementById( icon_image_id );
    if (!icon_image) return false;

    icon_image.src = GUI_IMAGE_DIR + page + ".png";;
}

function mosaicResetSave( icon_image_id )
{
    var ask = confirm( "Reset default Dashboard and Save?" );

    if (!ask) {
	return false;
    }

    var csrf_input = document.getElementById ( GUI_CSRF_ATTRIBUTE );
    if (!csrf_input) return false;

    var page = "dashboard-reset-save";
    var cgi = GUI_DIR + page + GUI_EXTENSION;    
    var csrf_value = csrf_input.value;
    var data = GUI_CSRF_ATTRIBUTE + '=' + csrf_value;

    setWorkingButton( icon_image_id );
    var post = $.post( cgi,
		       data,
		       function( resultData, status ) {
			   switch (status) {
			   case "success":
			       window.location.reload( true );
			       break;

			   default:
			       alert( "Communication Error!" );
			       break;
			   }
			   unsetWorkingButton( icon_image_id, page );
		       } );
    post.fail( function( ) { alert( "Unable to Reset!" ); unsetWorkingButton( icon_image_id, page ); } );
}

function mosaicSave( icon_image_id )
{
    var csrf_input = document.getElementById ( GUI_CSRF_ATTRIBUTE );
    if (!csrf_input) return false;

    var page = "dashboard-save";
    var cgi = GUI_DIR + page + GUI_EXTENSION;    
    var csrf_value = csrf_input.value;
    var data = mosaicGetSerializeLayout( );

    data = GUI_CSRF_ATTRIBUTE + '=' + csrf_value + '&' + data;

    setWorkingButton( icon_image_id );
    var post = $.post( cgi,
		       data,
		       function( resultData, status ) {
			   switch (status) {
			   case "success":
			       break;

			   default:
			       alert( "Communication Error!" );
			       break;
			   }
			   unsetWorkingButton( icon_image_id, page )
		       } );
    post.fail( function( ) { alert( "Unable to Save!" ); unsetWorkingButton( icon_image_id, page ); } );
}

function mosaicMenuAddControl( section_id, control_id )
{
    var jq_section_id = "#" + section_id;
    var jq_control_id = "#" + control_id;

    $( jq_control_id ).live( 'click', function( e )
    {
	e.preventDefault( );
	var delay = 400, status;
	if ($( jq_section_id ).is( ':visible' )) {
	    status = 0;
	}
	else {
	    status = 1;
	}
	$( jq_section_id ).stop( );
	$( jq_section_id ).slideToggle( delay );
	window.setTimeout( function( ) { setGUICookie( GUI_COOKIE_DASHBOARD_MENU_NAME, status, 31 ); }, delay );
    } );
}

function showHideMosaicMenu( section, status )
{
    section = "#" + section;

    if (status == 0) {
	$( section ).hide( );
    }
    else {
	$( section ).show( );
    }
}

function mosaicMenuInitialize( section, control )
{
    mosaicMenuAddControl( section, control );

    var status = getCookieValue( GUI_COOKIE_DASHBOARD_MENU_NAME );
    if (status == null) status = 0;
    showHideMosaicMenu( section, status );
}
