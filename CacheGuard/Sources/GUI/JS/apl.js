/*
###########################################################################
#
# MODULE:       GUI
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

function UTF82B64( str )
{
    var encoded = window.btoa(unescape( encodeURIComponent( str )));
    encoded = encoded.replace( /=/g, '@' );
    return encoded;
}

function B64UTF82( str )
{
    return decodeURIComponent( escape(window.atob( str )));
}

function encodeString( str )
{
    const bytes = new TextEncoder( ).encode( str );
    let binary = '';

    for (const byte of bytes) {
        binary += String.fromCharCode( byte );
    }

    return btoa( binary );
}

function decodeString( str )
{
    const binary = atob( str );
    const bytes = Uint8Array.from( binary, c => c.charCodeAt( 0 ));

    return new TextDecoder( ).decode( bytes );
}

function checkInput( id, regexp )
{
    var obj = document.getElementById( id );
    if (!obj) return false;

    val = obj.value;
    if (typeof val !== "string") return false;

    var val = removeTrailerBlank( val );

    if ( isBlank( val ) ) {
        setInputOK( obj );
        return true;
    }

    if ( isBlank( regexp ) ) {
        return true;
    }

    var pattern;

    try {
        pattern = new RegExp( regexp );
    }
    catch ( error ) {
        setInputKO( obj );
        return false;
    }

    if ( pattern.test( val ) ) {
        setInputOK( obj );
        return true;
    }

    setInputKO( obj );
    return false;
}

function checkText( id )
{
    return( checkInput( id, "^[^\x00-\x1F\x80-\x9F]+$" ));
}

function checkPrintable( id )
{
    return( checkInput( id, "^[\x20-\x7E]+$" ));
}

function checkControl( id )
{
    return( checkInput( id, "^[\x00-\x1F\x7F]$" ));
}

function checkPunct( id )
{
    return( checkInput( id, "^[-!\"#$%&\'()*+,.\/:;<=>?@[\\\]_\`{|}~]$" ));
}

function checkDigit( id )
{
    return( checkInput( id, "^[0-9]+$" ));
}

function checkPercent( id )
{
    return( checkInput( id, "^(100|[1-9]+|([1-9][0-9]))%?$" ));
}

function checkWeight( id )
{
    return( checkInput( id, "^(100|[0-9]|([1-9][0-9]))$" ));
}

function checkPhrase( id )
{
    return( checkInput( id, "^[A-Za-z0-9\ ]+$" ));
}

function checkAlphanum( id )
{
    return( checkInput( id, "^[A-Za-z0-9]+$" ));
}

function checkAAlphanum( id )
{
    return( checkInput( id, "^[A-Za-z][A-Za-z0-9]*$" ));
}

function checkAlpha( id )
{
    return( checkInput( id, "^[A-Za-z]+$" ));
}

function checkXdigit( id )
{
    return( checkInput( id, "^[A-Fa-f0-9]+$" ));
}

function checkBlank( id )
{
    return( checkInput( id, "^[ \t]+$" ));
}

function checkSpace( id )
{
    return( checkInput( id, "^[ \t\r\n\v\f]+$" ));
}

function checkHostname( id )
{
    return( checkInput( id, "^[a-zA-Z0-9]([a-zA-Z0-9])*(\-([a-zA-Z0-9])+)*$" ));
}

function isUsername( val )
{
    return( val.match( /^[a-zA-Z0-9]([a-zA-Z0-9\-._])*$/ ));
}

function isDomainname( val )
{
    return( val.match( /^[a-zA-Z0-9]([a-zA-Z0-9])*(\-([a-zA-Z0-9])+)*([.][a-zA-Z0-9]([a-zA-Z0-9])*(\-([a-zA-Z0-9])+)*)*$/ ));
}

function checkDomainname( id )
{
    return( checkInput( id, "^[a-zA-Z0-9]([a-zA-Z0-9])*(\-([a-zA-Z0-9])+)*([.][a-zA-Z0-9]([a-zA-Z0-9])*(\-([a-zA-Z0-9])+)*)*$" ));
}

function checkUsername( id )
{
    return( checkInput( id, "^[a-zA-Z0-9@._:,;\-]+$" ));
}

function checkGuard( id )
{
    return( checkInput( id, "^[a-zA-Z][a-zA-Z0-9_\-]*$" ));
}

function checkIdentifier( id )
{
    return( checkInput( id, "^[a-zA-Z]([a-zA-Z0-9-]|[.])*$" ));
}

function checkTime( id )
{
    return( checkInput( id, "^[0-9/:\-]*$" ));
}

function checkEmail( id )
{
    var obj = document.getElementById ( id );
    var email = obj.value;

    email = removeTrailerBlank ( email );

    if (isBlank( email )) {
	setInputOK ( obj );
	return true;
    }
    else {
	var index = email.indexOf( "@", 0 );
	if (index == -1) {
	    setInputKO ( obj );
	    return false;
	}

	var user = email.substr( 0, index );
	var domain = email.substr( ++index );

	if (isDomainname( domain ) && isUsername( user )) {
	    setInputOK (obj );
	    return true;
	}
	else {
	    setInputKO ( obj );
	    return false;
	}
    }
}

function checkDN( id )
{
    var obj = document.getElementById ( id );
    var dn = obj.value;

    dn = removeTrailerBlank ( dn );

    if (isBlank( dn )) {
	setInputOK ( obj );
	return true;
    }

    if (dn.match( /^[\x20-\x7E]+$/ )) {
	if (dn.match( /^([^,=]+=[^,]*)(,[^,=]+=[^,]*)*$/ )) {
	    setInputOK ( obj );
	    return true;
	}
	else {
	    setInputKO ( obj );
	    return false;
	}
    }
    else {
	setInputKO ( obj );
	return false;
    }
}

function isPort( val )
{
    if (val.match( /(^[1-9][0-9]{0,4}|^0)$/ )) {
	val = parseInt( val, 10 );

	if (val >= 0 && val < 65536) {
		return true;
	}
	else {
	    return false;
	}
    }
    else {
	return false;
    }
}

function checkMAC( id )
{
    var obj = document.getElementById( id );
    var mac = obj.value;

    if (mac.match( /^[a-fA-F1-9](:[0-9]{0,4}){5}$/ )) {
	return true;
    }
    else {
	return false;
    }
}

function checkPort( id )
{
    var obj = document.getElementById( id );
    var port = obj.value;

    port = removeTrailerBlank ( port );

    if (isBlank( port )) {
	setInputOK ( obj );
	return true;
    }

    if (isPort( port )) {
	setInputOK ( obj );
	return true;
    }
    else {
	setInputKO ( obj );
	return false;
    }
}

function checkPorts( id )
{
    var obj = document.getElementById ( id );
    var ports = obj.value;

    ports = removeTrailerBlank ( ports );

    if (isBlank( ports )) {
	setInputOK ( obj );
	return true;
    }
    
    if (isPort( ports )) {
	setInputOK ( obj );
	return true;
    }

    else {
	var index = ports.indexOf( ':', 0 );
	var port1 = ports.substr( 0, index );
	var port2 = ports.substr( ++index );

	if (isPort( port1 ) && isPort( port2 )) {
	    port1 = parseInt( port1, 10 );
	    port2 = parseInt( port2, 10 );

	    if ( port1.isNaN( page ) ) {
		return false;
	    }

	    if ( port2.isNaN( page ) ) {
		return false;
	    }

	    if (port1 <= port2) {
		setInputOK ( obj );
		return true;
	    }
	    else {
		setInputKO ( obj );
		return false;
	    }
	}
	else {
	    setInputKO ( obj );
	    return false;
	}
    }
}

function isIP( ip )
{    
    if (ip.match( /^[0-9]{1,3}([.][0-9]{1,3}){3}$/ )) {
	
	var index, byte;
	
	for (var i = 0 ; i < 3 ; i++) {
	    index = ip.indexOf( ".", 0 );
	    byte = ip.substr( 0, index );
	    
	    if (byte > 255) {
		return false;
	    }
	    index++;
	    ip = ip.substr( index );
	}
	
	byte = ip;
	
	if (byte > 255 ) {
	    return false;
	}
	return true;
    }
    else {
	return false;
    }
}

function isFQDN( fqdn )
{    
    if (fqdn.match( /^[a-zA-Z0-9]([a-zA-Z0-9])*(\-([a-zA-Z0-9])+)*([.][a-zA-Z0-9]([a-zA-Z0-9])*(\-([a-zA-Z0-9])+)*)*$/ )) {
	return true;
    }
    else {
	return false;
    }
}

function isIPList( ipList )
{
    ipList = ipList.replace( / /g, "" );
    var ipArray = ipList.split( ',' );
    for (var i = 0 ; i < ipArray.length ; i++) {
	if (! isIP( ipArray[i] )) return false;
    }

    return true;
}

function isFQDNList( fqdnList )
{
    fqdnList = fqdnList.replace( / /g, "" );
    var fqdnArray = fqdnList.split( ',' );
    for (var i = 0 ; i < fqdnArray.length ; i++) {
	if (! isFQDN( fqdnArray[i] )) return false;
    }

    return true;
}

function isPrefixMask( ip )
{    
    if (ip.match( /^[0-9]{1,2}$/ )) {
	if (ip >= 0 && ip <=32) {
	    return true;
	}
	else {
	    return false;
	}
    }
    else {
	return false;
    }
}

function checkIP( id )
{
    var obj = document.getElementById ( id );
    var ip = obj.value;

    ip = removeTrailerBlank ( ip );

    if (isBlank( ip )) {
	setInputOK ( obj );
	return true;
    }

    if (isIP( ip )) {
	setInputOK (obj );
	return true;
    }
    else {
	setInputKO ( obj );
	return false;
    }
}

function checkIPList( id )
{
    var obj = document.getElementById ( id );
    var ipList = obj.value;

    ipList = removeTrailerBlank ( ipList );

    if (isBlank( ipList )) {
	setInputOK ( obj );
	return true;
    }

    if (isIPList( ipList )) {
	setInputOK (obj );
	return true;
    }
    else {
	setInputKO ( obj );
	return false;
    }
}

function checkFQDNList( id )
{
    var obj = document.getElementById ( id );
    var fqdnList = obj.value;

    fqdnList = removeTrailerBlank ( fqdnList );

    if (isBlank( fqdnList )) {
	setInputOK ( obj );
	return true;
    }

    if (isFQDNList( fqdnList )) {
	setInputOK (obj );
	return true;
    }
    else {
	setInputKO ( obj );
	return false;
    }
}

function checkIPPx( id )
{
    var obj = document.getElementById ( id );
    var ippx = obj.value;

    ippx = removeTrailerBlank ( ippx );

    if (isBlank( ippx )) {
	setInputOK ( obj );
	return true;
    }
    
    if (isIP( ippx )) {
	setInputOK ( obj );
	return true;
    }
    else {
	var index = ippx.indexOf( "/", 0 );
	var ip = ippx.substr( 0, index );
	var px = ippx.substr( ++index );

	ip = removeTrailerBlank ( ip );
	px = removeTrailerBlank ( px );

	if (isIP( ip ) && isPrefixMask ( px )) {
	    setInputOK ( obj );
	    return true;
	}
	else {
	    setInputKO ( obj );
	    return false;
	}
    }
}

function checkIPDomainname( id )
{
    if (checkIP( id )) {
	return true;
    }
    else {
	return( checkDomainname( id ) );
    }
}

function checkQoS( id )
{
    if (checkPercent( id )) {
	return true;
    }
    else {
	return( checkDigit( id ) );
    }
}

function checkURL( url )
{
    if (url.match( /^((http[s]?|[st]?ftp):\/)?\/?([^:\/\s]+)((\/\w+)*\/)([\w\-\.]+[^#?\s]+)(.*)?(#[\w\-]+)?$/ )) {
	return true;
    }
    else {
	return false;
    }
}

function checkComputerName( id )
{
    return (checkInput( id, "^(?![0-9]+$)[A-Za-z0-9](?:[A-Za-z0-9-]{0,13}[A-Za-z0-9])?$" ));
}

function basename( path )
{
    return path.replace( /.*\//, "" );
}

function dirname( path )
{
    return path.match( /.*\// );
}

function gotoTopWindow( )
{
    window.scrollTo( {
	top:100,
	left:100,
	behavior:'auto'} );
}

function alertMaxReached( max )
{
    alert( "The maximum number of records for this list is " + max + "!" );
    return false;
}

function leapYear( year )
{
    return( (year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
}

function daysInYearMonth( year, month )
{
    var days;

    switch (month) {
    case 1:
    case 3:
    case 5:
    case 7:
    case 8:
    case 10:
    case 12:
	days = 31;
	break;

    case 4:
    case 6:
    case 9:
    case 11:
	days = 30;
	break;
	;;

    case 2:
	if (leapYear( year )) {
	    days = 29;
	}
	else {
	    days = 28;
	}
	break;

    default:
	days = 1;
	break;
    }

    return days;
}

function setCalendarDay( year_id, month_id, day_id )
{
    var year_object = document.getElementById( year_id );
    var month_object = document.getElementById( month_id );
    var day_object = document.getElementById( day_id );

    if (!year_object) return false;
    if (!month_object) return false;
    if (!day_object) return false;

    var year = year_object.value;
    var month = month_object.options[month_object.selectedIndex].value;
    var days = daysInYearMonth( Number( year ), Number( month ));

    while (day_object.options.length > 0) {
	day_object.remove( 0 );
    }

    for (var i = 0 ; i < days ; i++) {
	var j = i+1;
        j=j.toString( );

	if (j.length == 1) {
	    j = '0' + j;
	}
	var option = document.createElement( 'option' );
	option.value = j;
	option.innerHTML = j;
	day_object.appendChild( option );
    }
}

function initSubmitOnEnterInInput( button_id, input_id )
{
    var input = document.getElementById( input_id );
    var button = document.getElementById( button_id );

    if ( input == null) return true;
    if ( button == null) return true;

    $( '#' + input_id ).keyup( function( event ) {

	if (event.keyCode == 13) {

            event.preventDefault( );
	    var button = document.getElementById( button_id );
	    if (button == null) return true;

	    if (! $( '#' + button_id ).is( ':disabled' ))
		$( '#' + button_id ).click( );
	}
    } );
}

function doNothingOnEnterInInput( input_id )
{
    var input = document.getElementById( input_id );

    if ( input == null) return true;
    
    $( '#' + input_id ).keydown( function( event ) {

        if (event.keyCode == 13) {
            event.preventDefault( );
            return true;
        }
    } );
}

function setSelectOptions( select_id, values, tips )
{
    var select = document.getElementById( select_id );
    if (select == null) return false;

    var tips_length;

    if (typeof( tips ) == "undefined") {
	var tips_length = 0;
    }
    else {
	tips_length = tips.length;
    }

    if (select.options == null) return false;
    while (select.options.length > 0) {
	select.remove( 0 );
    }

    for (var i = 0 ; i < values.length ; i++) {
	var option = document.createElement( 'option' );
	option.value = values[i][0];
        option.id = values[i][0];
	option.textContent = values[i][1];

	if (tips_length != 0) {
	    var tip = tips[i];
	    option.onmouseover = function ( ) { ddrivetip( tip ); };
	    option.onmouseout = function( ) { hideddrivetip( ); } ;
	}
	select.appendChild( option );
    }
}

function addHiddenInputFromSelectionItem( form_id, select_id )
{
    var form = document.getElementById( form_id );
    var select = document.getElementById( select_id );
    if (!form) return false;
    if (!select) return false;

    var hiddenInput;

    $( '#' + select_id + ' option' ).each( function( ) {
	hiddenInput = document.createElement( "input" );
	hiddenInput.setAttribute( "type", "hidden" ); 
	hiddenInput.setAttribute( "name", select_id );
	hiddenInput.setAttribute( "value", $( this ).val( ) );
	form.appendChild( hiddenInput );
    } );
}

function initSelectionList( select_from, select_to, add_button, del_button )
{
    $( document ).ready( function( ) {

        select_from = '#' + select_from;
        select_to = '#' + select_to;
        add_button = '#' + add_button;
        del_button = '#' + del_button;

        var option_id, onmouseover, onmouseout;
	var option_val, option_text;

        $( add_button ).click( function( ) {
            $( select_from + ' option:selected' ).each( function( ) {
		option_val = $( this ).val ( );
		option_text = $( this ).text ( );
		option_id = $( this ).attr( "id" );
		onmouseover = $( this ).attr( "onmouseover" );
		onmouseout = $( this ).attr( "onmouseout" );

                $( this ).remove( );

		$(select_to).append( "<option value='" + option_val + "' id='" + option_id + "' onMouseOver='" + onmouseover + "' onMouseOut='" + onmouseout + "'>" + option_text + "</option>" );
		$( select_to ).append( $( select_to + " option" ).remove( ).sort( function( a, b ) {
		    var at = $( a ).text( ), bt = $( b ).text( );
		    return(  at > bt) ? 1 : ((at < bt) ? -1 : 0 );
		} ));


            } );
        } );
        $( del_button ).click( function( ){
            $( select_to + ' option:selected' ).each( function( ) {
		
		option_val = $( this ).val ( );
		option_text = $( this ).text ( );
		option_id = $( this ).attr( "id" );
		onmouseover = $( this ).attr( "onmouseover" );
		onmouseout = $( this ).attr( "onmouseout" );

                $( this ).remove( );

		$( select_from ).append( "<option value='" + $( this ).val( ) +"' id='" + option_id + "' onMouseOver='" + onmouseover + "' onMouseOut='" + onmouseout + "'>" + $( this ).text( ) + "</option>" );

		$( select_from ).append( $( select_from + " option" ).remove( ).sort( function( a, b ) {
		    var at = $( a ).text( ), bt = $( b ).text( );
		    return(  at > bt) ? 1 : ((at < bt) ? -1 : 0 );
		} ));


            } );
        } );
    } );
}

function initSelectionList( select_from, select_to, add_button, del_button )
{
    var selectFrom, selectTo, addButton, delButton;

    selectFrom = document.getElementById( select_from );
    selectTo = document.getElementById( select_to );
    addButton = document.getElementById( add_button );
    delButton = document.getElementById( del_button );


    function sortSelect( select )
    {
        var options;

        options = Array.from( select.options );

        options.sort( function( a, b ) {
            return( a.text.localeCompare( b.text ) );
        } );

        options.forEach( function( option ) {
            select.appendChild( option );
        } );
    }

    addButton.addEventListener( "click", function( ) {
        var selected;
        selected = Array.from( selectFrom.selectedOptions );
        selected.forEach( function( option ) {
            selectTo.appendChild( option );
        } );
        sortSelect( selectTo );
    } );

    delButton.addEventListener( "click", function( ) {
        var selected;
        selected = Array.from( selectTo.selectedOptions );
        selected.forEach( function( option ) {
            selectFrom.appendChild( option );
        } );
        sortSelect( selectFrom );
    } );
}

function showMinMaxToolTip( min, max )
{
    var message = "This value should be greater than or equal to " + min + " and less than or equal to " + max + "."
    ddrivetip( message, 200 );
    return true;
}

function hideMinMaxToolTip( )
{
    hideddrivetip( );
    return true;
}

function showTimeToolTip( id )
{
    var width = 400
    var pos_string = id.substring( 4 );
    var type_id = "type" + pos_string;
    var types = document.getElementById( type_id );
    var time_type = types.options[types.selectedIndex].value;

    switch (time_type) {
    case 'slot':
	ddrivetip( "A time slot has the format [w-]hh:mm-hh:mm where w is an optional digit between 0 and 6 representing the day of the week (0 is Sunday and 6 is Saturday). hh and mm are numbers representing respectively hours and minutes.", width );
	break;

    case 'frame':
	ddrivetip( "A date frame has the format yyyy/mm/dd-yyyy/mm/dd where yyyy, mm and dd are numbers representing respectively the year, the month and the day.", width );
	break;

    case 'date':
	ddrivetip( "A date has the format [yyyy]/[mm]/[dd][-hh:mm-hh:mm] where yyyy, mm and dd are optional numbers representing respectively the year, the month  and the day. If one of these numbers is omitted it will represent any value. The optional part [-hh:mm-hh:mm] defines a time slot at the defined date.", width );
	break;

    default:
	break;
    }
	
    return true;
}

function hideTimeToolTip( )
{
    hideddrivetip( );
    return true;
}

function blinkIcon( image_id )
{
    var image = document.getElementById( image_id );
    if (!image) return false;

    image.classList.toggle( 'item-ivisible' );

    return true;
}

function initBlinkIcon( index, id )
{
    if (BLINK_ICON_TIMERS[index] != null) {
        clearInterval( BLINK_ICON_TIMERS[index] );
    }

    BLINK_ICON_TIMERS[index] = setInterval(
        function( )
        {
            blinkIcon( id );
        },
        500
    );

    return true;
}

function hideZone( id )
{
    var object = document.getElementById( id );
    if (!object) return false;

    object.classList.remove( 'item-displayed' );
    object.classList.add( 'item-not-displayed' );
}

function showZone( id )
{
    var object = document.getElementById( id );
    if (!object) return false;

    object.classList.remove( 'item-not-displayed' );
    object.classList.add( 'item-displayed' );
}

function toggleZone( id )
{
    var zone = document.getElementById( id );
    if (!zone) return false;

    if (zone.classList.contains( 'item-displayed' )) {
	hideZone( id );
    }
    else if (zone.classList.contains( 'item-not-displayed' )) {
	showZone( id );
    }
}

function setIconBarState( icon_id, state )
{
    var icon = document.getElementById( icon_id );

    if (!icon) return false;
    if (state == true) {
	showZone( icon_id );
    }
    else {
	hideZone( icon_id );
    }
    return true;
}

function activateOKIconBar( )
{
    return setIconBarState( "ok-iconbar", true );
}

function deactivateOKIconBar( )
{
    return setIconBarState( "ok-iconbar", false );
}

function activateOperationReportIconBar( )
{
    return setIconBarState( "report-iconbar", true );
}

function deactivateOperationReportIconBar( )
{
    return setIconBarState( "report-iconbar", false );
}


function activateReloadIconBarState( )
{
    return setIconBarState( "reload-iconbar", true );
}

function deactivateReloadIconBarState( )
{
    return setIconBarState( "reload-iconbar", false );
}

function setButtonState( button_id, state )
{
    var button = document.getElementById( button_id );
    if (!button) return false;

    if (state == true) {
	button.disabled = false;
    }
    else {
	button.disabled = true;
    }
    return true;
}

function activateSubmitButton( )
{
    return setButtonState( SUBMIT_ID, true );
}

function deactivateSubmitButton( )
{
    return setButtonState( SUBMIT_ID, false );
}

function activateResetButton( )
{
    return setButtonState( RESET_ID, true );
}

function deactivateResetButton( )
{
    return setButtonState( RESET_ID, false );
}

function activateAddButton( )
{
    return setButtonState( ADD_ID, true );
}

function deactivateAddButton( )
{
    return setButtonState( ADD_ID, false );
}

function activateDeleteButton( )
{
    return setButtonState( DELETE_ID, true );
}

function deactivateDeleteButton( )
{
    return setButtonState( DELETE_ID, false );
}

function agreeLicense( id )
{
    var checked = document.getElementById( id ).checked;

    if (checked == true ) {
	activateSubmitButton( );
	activateOKIconBar( );
	activateOperationReportIconBar( );
    }
    else {
	deactivateOKIconBar( );
	deactivateSubmitButton( );
	deactivateOperationReportIconBar( );
    }
}

function collapseCheckZone( checkId, zoneId )
{
    var checkedObj = document.getElementById( checkId );
    if (!checkedObj) return false;

    if (checkedObj.checked == false) {
	showZone( zoneId );
    }
    else {
	hideZone( zoneId );
    }
}

function resetZone( id )
{
    document.getElementById( id ).innerHTML = "";
}

function setIconImage( id, icon, cssClass = '', title = '' )
{
    var zone = document.getElementById( id );
    if (!zone) return false;

    if (title != '') {
	title = " alt='" + title + "' title='" + title + "'";
    }

    if (cssClass != '') {
	cssClass = " class='" + cssClass + "'";
    }

    zone.innerHTML = "<span" + cssClass + "'><img src='" + GUI_IMAGE_DIR + icon + "'" + title + " /></span>";


    return true;
}

function setWorkingIconBar( id, title = "Loading" )
{
    setIconImage( id, "working-flower.gif", '', title );
}

function setWorking( title = "" )
{
    deactivateOKIconBar( );
    deactivateSubmitButton( );
    deactivateResetButton( );
    deactivateAddButton( );
    deactivateDeleteButton( );
    deactivateReloadIconBarState( );

    var id = "working";

    setWorkingIconBar( id, title );
    showZone( id );
}

function activatePostButtons( )
{
    activateOKIconBar( );
    activateSubmitButton( );
    activateResetButton( );
}

function deactivatePostButtons( )
{
    deactivateOKIconBar( );
    deactivateSubmitButton( );
    deactivateResetButton( );
}

function stopWorking( state, message )
{
    var id = "working";
    var obj = document.getElementById( id );

    if (obj) {
   	if (state == true) {
	    obj.innerHTML = "";
	    hideZone( id );
	}
	else {
	    obj.innerHTML = "<img src='" + GUI_IMAGE_DIR + "error-reflect.png' alt='" + message + "!' title='" + message + "!' />";
	}
    }

    activateReloadIconBarState( );
    activateSubmitButton( );
    activateOKIconBar( );
    activateResetButton( );
    activateAddButton( );
    activateDeleteButton( );
}

function resetUpdateTimer( )
{
    if (UPDATE_TIMER) {
	clearTimeout( UPDATE_TIMER );
	UPDATE_TIMER = null;
    }
}

function autoDisplay( f, timeout )
{
    if ( UPDATE_TIMER )
        clearTimeout( UPDATE_TIMER );

    if ( typeof f !== "function" )
        return false;

    UPDATE_TIMER = setTimeout( f, timeout );

    return true;
}

function resetAJAX_HTTP_REQUEST( )
{
    if (navigator.appName == "Microsoft Internet Explorer") {
	AJAX_HTTP_REQUEST = new ActiveXObject( "Microsoft.XMLHTTP" );
    } else {
	AJAX_HTTP_REQUEST = new XMLHttpRequest( );
    }
}

function AJAX_refreshReportCB( page )
{
    switch (AJAX_HTTP_REQUEST.readyState) {
    case AJAX_UNSENT:
	break;

    case AJAX_OPENED:
	break;

    case AJAX_HEADERS_RECEIVED:
	break;

    case AJAX_LOADING:
	break;

    case AJAX_DONE:
        RESPONSE_UPDATE_ARRIVED = 1;

        if ( AJAX_HTTP_REQUEST.status == 200 ) {

            const root = document.getElementById( AUTO_REPORT_ID );

            if ( !root ) {
                break;
            }

            const html_array = $.parseHTML( AJAX_HTTP_REQUEST.responseText, document, true );

            $( root ).html( html_array );
            activateContent( root, page );
        }
        else {
            document.getElementById( AUTO_REPORT_ID ).innerHTML = UNAVAILABLE;
        }
	break;

    default:
	RESPONSE_UPDATE_ARRIVED = 1;
	break;
    }
}

function isURLAvailable( cgi )
{
    var result = false;

    $.ajax( {
        type: "HEAD",
        async: false,
        url: cgi,
        success: function( message )
	{
	    result = true;
        }
    } );
    
    return result;
}

// Configuration

function printTLS( page, component_id, div_id )
{
    var components = document.getElementById( component_id );
    var div = document.getElementById( div_id );

    if (components == null) return false;
    if (div == null) return false;

    var component = components.options[components.selectedIndex].value;

    var fpage = page + '+' + component;
    ajaxpage( fpage, div_id );
}

function TLSOperationSelectCB( component_id, operation_id, days_id, ocsp_id )
{
    var components = document.getElementById( component_id );
    var operations = document.getElementById( operation_id );
    var days = document.getElementById( days_id );
    var ocsp = document.getElementById( ocsp_id );


    if (components == null) return false;
    if (operations == null) return false;
    if (days == null) return false;
    if (ocsp == null) return false;

    var operation = operations.options[operations.selectedIndex].value;

    switch (operation) {
    case 'save':
	days.disabled = true;
	ocsp.disabled = true;
	break;

    default:
	var component = components.options[components.selectedIndex].value;
	switch (component) {
	case 'csr':
	    days.disabled = false;
	    ocsp.disabled = false;
	    break;

	default:
	    days.disabled = true;
	    ocsp.disabled = true;
	    break;
	}
	break;
    }
}

function TLSComponentSelectCB( component_id, operation_id, days_id, ocsp_id, page, div_id )
{
    TLSOperationSelectCB( component_id, operation_id, days_id, ocsp_id );
    printTLS( page, component_id, div_id );
}

function IPsecVPNAccessConfSelectCB( system_id, tls_id, div_id)
{
    const page = GUI_DIR + "vpnipsec-access-conf-print" + GUI_EXTENSION;
    var systems = document.getElementById( system_id );
    var tlss = document.getElementById( tls_id );
    var div = document.getElementById( div_id );

    if (systems == null) return false;
    if (div == null) return false;

    div.innerHTML = UNAVAILABLE;

    var system = systems.options[systems.selectedIndex].value;

    if (tlss == null) {
	tls = 'any';
    }
    else {
	var tls = tlss.options[tlss.selectedIndex].value;
    }

    var fpage = page + '?' + system + '+' + tls;

    ajaxpage( fpage, div_id );
}

function printTLSCA( page, div_id )
{
    ajaxpage( page, div_id );
}

function refreshShortCuts( )
{
    $.get( GUI_DIR + "refresh-shortcuts" + GUI_EXTENSION + '?' + $.now( ), function( result, status ) {
	switch (status) {
	case 'success':
	    var pos = result.indexOf( ':' );
	    var result_1 = result.substring( 0, pos );
	    if ((result_1 & 1) == 1) {
		showZone( "apply-shortcut" );
	    }
	    else {
		hideZone( "apply-shortcut" );
	    }

	    if ((result_1 & 2) == 2) {
		showZone( "cancel-shortcut" );
	    }
	    else {
		hideZone( "cancel-shortcut" );
	    }

	    if ((result_1 & 4) == 4) {
		showZone( "authenticate-kerberos-create-shortcut" );
	    }
	    else {
		hideZone( "authenticate-kerberos-create-shortcut" );
	    }

	    if ((result_1 & 8) == 8) {
		showZone( "power-shortcut" );
	    }
	    else {
		hideZone( "power-shortcut" );
	    }
	    if ((result_1 & 16) == 16) {
		showZone( "file-exchange-shortcut" );
	    }
	    else {
		hideZone( "file-exchange-shortcut" );
	    }
	    if ((result_1 & 32) == 32) {
		pos++;
		var result_2 = result.substring( pos );
		if (result_2 != 0) {
		    var a = document.getElementById( "job-href" );
		    var icon = document.getElementById( "job-image" );
		    var page = JOBS[result_2][0];
		    var title, href;

		    if (page != "") {
			title = JOBS[result_2][1];
			href = GUI_DIR + page + GUI_EXTENSION;
			a.href = href;

			if (page == 'power') {
			    setTimeout( doLogout, POWER_PAGE_LOGOUT_TIMEOUT );
			}
		    }
		    else {
			title = "Active Internal Micro Job";
			a.removeAttribute( "href" );
		    }
		    icon.title = title;
		    showZone( "job-shortcut" );
		}
	    }
	    else {
		hideZone( "job-shortcut" );
	    }

	default:
	    break;
	}
    } );
}

function initRefreshShortcuts( )
{
    if (REFRESH_SHORTCUTS_TIMER != null) {
	clearInterval( REFRESH_SHORTCUTS_TIMER );
    }

    REFRESH_SHORTCUTS_TIMER = setInterval( refreshShortCuts, SHORTCUTS_UPDATE_INTERVAL );
}

function updateReport( page, force, arg_type = '', arg_value = '')
{
    switch (arg_type) {

    case 'ObjectId':
	var object = document.getElementById( arg_value );
	if (object == null) return false;
	var page_value = object.value;
	break;

    case 'Page':
	var page_value = arg_value;
	break;

    default:
	var arg_type = '';
	var page_value = '';
	break;
    }

    if (RESPONSE_UPDATE_ARRIVED == 1) {
	var auto = document.getElementById( AUOTO_UPDATE_ID );
	if (auto == null) return false;
	auto = auto.checked;

	if (auto == true || force == 1) {
	    RESPONSE_UPDATE_ARRIVED = 0;
	    var fpage = GUI_DIR + page + GUI_EXTENSION;
	    if (page_value != "") fpage += '?' + page_value;
	    resetAJAX_HTTP_REQUEST( );
	    AJAX_HTTP_REQUEST.open( "GET", fpage, true );
	    AJAX_HTTP_REQUEST.onreadystatechange = function( ) { AJAX_refreshReportCB( page ); };
	    AJAX_HTTP_REQUEST.send( null );
	}
    }

    var update_function = function( ) {
	updateReport( page, 0, arg_type, arg_value );
    };

    autoDisplay( update_function, CONF_LOG_UPDATE_INTERVAL );
}

function AJAX_refreshURLCB( id )
{
    switch (AJAX_HTTP_REQUEST.readyState) {
    case AJAX_UNSENT:
	break;

    case AJAX_OPENED:
	break;

    case AJAX_HEADERS_RECEIVED:
	break;

    case AJAX_LOADING:
	break;

    case AJAX_DONE:

	var input_object = document.getElementById( id );
	if (!input_object) return false;

	if (AJAX_HTTP_REQUEST.status == 200) {
	    input_object.innerHTML = AJAX_HTTP_REQUEST.responseText;
	}
	else {
	    input_object.innerHTML.innerHTML = UNAVAILABLE;
	}
	break;
	
    default:
	break;
    }
}

function AJAX_updateDenyURL( site_name_id )
{
    setWorkingIconBar( "denyurl" );

    var list = document.getElementById( site_name_id );
    if (!list) return false;

    var site_name = list.options[list.selectedIndex].value;

    resetAJAX_HTTP_REQUEST( );
    AJAX_HTTP_REQUEST.open( "GET", GUI_DIR + "waf-rweb-denyurl-print" + GUI_EXTENSION + '?' + site_name, true );
    AJAX_HTTP_REQUEST.onreadystatechange = function( ) { AJAX_refreshURLCB( "denyurl" ); };
    AJAX_HTTP_REQUEST.send( null );
}

function ping( report_id, machine_id, width )
{
    var report_object = document.getElementById( report_id );
    var machine_object = document.getElementById( machine_id );

    if (!report_object) return true;
    if (!machine_object) return true;

    var machine = machine_object.value;
    if (machine == "") {
	report_object.innerHTML = "<div class='diagnostic-tools-msg'>Please specify an IP address or a host name to ping.</div>";
	return true;
    }
    else if (!checkIPDomainname( machine_id )) {
	report_object.innerHTML = "<div class='diagnostic-tools-msg'>This is not a valid machine name!</div>";
	return false;
    }

    var page = GUI_DIR + "ping.apl?" + machine;
    ajaxpage( page, report_id );
}

function traceroute( report_id, machine_id, protocol_id )
{
    var report_object = document.getElementById( report_id );
    var machine_object = document.getElementById( machine_id );
    var protocol_object = document.getElementsByName( protocol_id );

    if (!report_object) return true;
    if (!machine_object) return true;
    if (!protocol_object) return true;

    var machine = machine_object.value;

    if (machine == "") {
	report_object.innerHTML = "<div class='diagnostic-tools-msg'>Please specify an IP address or a host name to trace the route to it.</div>";
	return true;
    }
    else if (!checkIPDomainname( machine_id )) {
	report_object.innerHTML = "<div class='diagnostic-tools-msg'>This is not a valid machine name!</div>";
	return false;
    }

    var protocol = false;
    for (var i = 0; i < protocol_object.length ; i++) {
        if (protocol_object[i].checked) {
	    var protocol = protocol_object[i].value;
	    break;
	}
    }

    if (protocol == false) return true;

    var page = GUI_DIR + "traceroute.apl?" + machine + '&' + protocol;
    ajaxpage( page, report_id );
}

function sendEmail( report_id, email_id )
{
    var report_object = document.getElementById( report_id );
    var email_object = document.getElementById( email_id );

    if (!report_object) return true;
    if (!email_object) return true;

    var email = email_object.value;
    if (email == "") {
	report_object.innerHTML = "<div class='diagnostic-tools-msg'>Please specify an email address.</div>";
	return true;
    }
    else if (!checkEmail( email_id )) {
	report_object.innerHTML = "<div class='diagnostic-tools-msg'>This is not a valid email address!</div>";
	return false;
    }

    var page = GUI_DIR + "email-test.apl?" + email;
    ajaxpage( page, report_id );
}

function ipNeighbour( report_id )
{
    var report_object = document.getElementById( report_id );

    if (!report_object) return true;

    var page = GUI_DIR + "ip-neighbour.apl";
    ajaxpage( page, report_id );
}

function authenticateLDAPTest( report_id, login_id, password_id )
{
    var report_object = document.getElementById( report_id );
    var login_object = document.getElementById( login_id );
    var password_object = document.getElementById( password_id );

    if (!report_object) return true;
    if (!login_object) return true;
    if (!password_object) return true;

    var login = login_object.value;
    var password = password_object.value;

    var page = GUI_DIR + "authenticate-ldap-test" + GUI_EXTENSION + '?' + login + '&' + password;
    ajaxpage( page, report_id );
}

function LDAPSearch( report_id, filter_id )
{
    var report_object = document.getElementById( report_id );
    var filter_object = document.getElementById( filter_id );

    if (!report_object) return true;
    if (!filter_object) return true;

    var filter = UTF82B64( filter_object.value );
    var page = GUI_DIR + "ldap-search" + GUI_EXTENSION + '?' + filter;

    ajaxpage( page, report_id );
}

function showKerberosKeytab( report_id )
{
    var report_object = document.getElementById( report_id );
    if (!report_object) return true;

    var page = GUI_DIR + "show-kerberos-keytab" + GUI_EXTENSION;

    ajaxpage( page, report_id );
}

function showWAFRules( cgi, div_id )
{
    var div = document.getElementById( div_id );
    if (div == null) return false;

    div.innerHTML = "<img src='" + GUI_IMAGE_DIR + "rotating_arrow.gif' alt='Working...' />";

    var name = document.mainform.site_name.value;
    var fcgi = cgi + "?" + name;
    ajaxpage( fcgi, div_id );
}

function managerSelectContextCB( select_id )
{
    var select_object = document.getElementById( select_id );
    if (!select_object) return false;
    var context = select_object.value;

    var location = GUI_DIR + MANAGER_MAIN_PAGE + GUI_EXTENSION + '?' + context;
    window.location.href = location;
}

function AJAX_refreshLogCB( )
{
    switch (AJAX_HTTP_REQUEST.readyState) {
    case AJAX_UNSENT:
	break;

    case AJAX_OPENED:
	break;

    case AJAX_HEADERS_RECEIVED:
	break;

    case AJAX_LOADING:
	break;

    case AJAX_DONE:
	if (AJAX_HTTP_REQUEST.status == 200) {
	    var obj = document.getElementById( AUTO_REPORT_ID );

	    if (!obj) return false;

	    obj.innerHTML = AJAX_HTTP_REQUEST.responseText;
	    obj.scrollTop = obj.scrollHeight;
	}
	else {
	    document.getElementById( AUTO_REPORT_ID ).innerHTML = UNAVAILABLE;
	}
	break;

    default:
	break;
    }
}

function updateLog( cgi, force )
{
    var auto = document.getElementById( AUOTO_UPDATE_ID );

    if ( auto == null )
        return false;

    auto = auto.checked;

    if ( auto == true || force == 1 ) {
        var last = document.getElementById( "last" ).value;
        var fcgi = GUI_DIR + cgi + GUI_EXTENSION + "?" + last;

        resetAJAX_HTTP_REQUEST( );
        AJAX_HTTP_REQUEST.open( "GET", fcgi, true );
        AJAX_HTTP_REQUEST.onreadystatechange = function( ) {
            AJAX_refreshLogCB( );
        };
        AJAX_HTTP_REQUEST.send( null );
    }

    autoDisplay( function( ) {
        updateLog( cgi, 0 );
    }, AUDIT_LOG_UPDATE_INTERVAL );

    return true;
}

function refreshAuditLogCB1( id )
{
    switch (AJAX_HTTP_REQUEST.readyState) {
    case AJAX_UNSENT:
	break;

    case AJAX_OPENED:
	break;

    case AJAX_HEADERS_RECEIVED:
	break;

    case AJAX_LOADING:
	break;

    case AJAX_DONE:
	if (AJAX_HTTP_REQUEST.status == 200) {
	    document.getElementById( id ).innerHTML = AJAX_HTTP_REQUEST.responseText;
	}
	else {
	    document.getElementById( id ).innerHTML = UNAVAILABLE;
	}
	break;

    default:
	break;
    }
}

function showAuditLog( name, force )
{
    if ( force == 1 ) {
        autoDisplay( function( ) {
            updateAuditLog( "update-audit-log", 0 );
        }, AUDIT_LOG_UPDATE_INTERVAL );
    }

    var log = document.getElementById( "request" ).value;
    var fcgi = GUI_DIR + "show-audit-log" + GUI_EXTENSION + "?" + name + "+" + log;

    resetAJAX_HTTP_REQUEST( );
    AJAX_HTTP_REQUEST.open( "GET", fcgi, true );
    AJAX_HTTP_REQUEST.onreadystatechange = function( ) {
        refreshAuditLogCB1( "audit" );
    };
    AJAX_HTTP_REQUEST.send( null );
}

function refreshAuditLogCB( id )
{
    switch (AJAX_HTTP_REQUEST.readyState) {
    case AJAX_UNSENT:
	break;

    case AJAX_OPENED:
	break;

    case AJAX_HEADERS_RECEIVED:
	break;

    case AJAX_LOADING:
	break;

    case AJAX_DONE:
	if (AJAX_HTTP_REQUEST.status == 200) {

	    document.getElementById( id ).innerHTML = AJAX_HTTP_REQUEST.responseText;

	    var sel=document.getElementById( "request" );
	    if (sel == null) return false;
	    var len=sel.length;

	    if (len != 0) {
		len--;
		sel.selectedIndex=len;
	    }

	    showAuditLog( document.getElementById( "sitename" ).value, 0 );
	}
	else {
	    document.getElementById( id ).innerHTML = UNAVAILABLE;
	}
	break;

    default:
	break;
    }
}

function updateAuditLog( cgi, force = 1)
{
    var auto = document.getElementById( AUOTO_UPDATE_ID );

    if ( auto == null )
        return false;

    auto = auto.checked;

    if ( auto == true || force == 1 ) {
        var last = document.getElementById( "last" ).value;
        var name = document.getElementById( "sitename" ).value;
        var fcgi = GUI_DIR + cgi + GUI_EXTENSION + "?" + last + "+" + name;

        resetAJAX_HTTP_REQUEST( );
        AJAX_HTTP_REQUEST.open( "GET", fcgi, true );
        AJAX_HTTP_REQUEST.onreadystatechange = function( ) {
            refreshAuditLogCB( AUTO_REPORT_ID );
        };
        AJAX_HTTP_REQUEST.send( null );
    }

    autoDisplay( function( ) {
        updateAuditLog( cgi, 0 );
    }, AUDIT_LOG_UPDATE_INTERVAL );

    return true;
}

function autoLogout()
{
    var rest = window.location.href;
    var pos = rest.indexOf(':');
    var proto = rest.substring(0, pos);

    resetUpdateTimer();

    pos += 3;
    rest = rest.substring(pos);
    pos = rest.indexOf("/");
    var uri = rest.substring(0, pos);
    var logout = proto + "://" + uri + LOGOUT_URI;

    window.location = logout;
}

function initAutoLogout( )
{
    const backCheckInterval = 60 * 1000;
    const frontCheckInterval = 20 * 1000;

    let lastFrontCheck = Date.now( );
    let lastBackCheck = 0;

    function registerFrontCheck( )
    {
        lastFrontCheck = Date.now( );
    }

    function setBackCheck( )
    {
        if (lastFrontCheck <= lastBackCheck)
            return true;

        lastBackCheck = lastFrontCheck;

        $.get( GUI_DIR + "auto-logout" + GUI_EXTENSION + "?touch" );
    }

    function checkAutoLogout( )
    {
	$.get( GUI_DIR + "auto-logout" + GUI_EXTENSION + "?check", function( result )
        {
            if ($.trim( result ) == "KO")
                autoLogout( );
        } );
    }

    $( document ).ready( function( )
    {
        $( document ).on(
            "keydown " +
            "keyup " +
            "mouseup " +
            "click " +
            "scroll " +
            "touchstart",
            registerFrontCheck
        );

        setInterval( setBackCheck, backCheckInterval );
        setInterval( checkAutoLogout, frontCheckInterval );

        setBackCheck( );
    } );
}

function doLogout( )
{
    $.get( GUI_DIR + "auto-logout" + GUI_EXTENSION + "?raz", function( )
    {
	location.href = LOGOUT_URI;
    } );
}

function requestLogout( )
{
    var logout = confirm( "Would you like to logout?" );
    if (logout == true) {
	doLogout( );
    }
}

function getExistingPage2show( recordsPerPage, page2show )
{
    var totalPages = ~~(TableRecordCursor / recordsPerPage);
    var recordsInLastPage = TableRecordCursor % recordsPerPage;
    if (recordsInLastPage != 0) totalPages++;
    if (recordsInLastPage == 0) var recordsInPage2show = recordsPerPage;
    else var recordsInPage2show  = recordsInLastPage;

    if (DeletedRecords == recordsInPage2show && (page2show + 1) == totalPages && page2show > 0) {
	page2show--;
    }

    return page2show;
}

function getSubmitPathWithPageArg( recordsPerPage, page2show )
{
    page2show = parseInt( page2show, 10 );
    page2show = isNaN( page2show ) ? 0 : page2show;

    var queryOut = "";

    var dir = dirname( window.location.pathname );
    var file = basename( window.location.pathname );
    var queryIn = window.location.search.slice( 1 );

    var assertions = queryIn.split(',');
    for (var i = 0 ; i < assertions.length ; i++) {
        var assertion = assertions[i].split(':');
        if (assertion[0] && decodeURIComponent(assertion[0]) != "page") {
	    queryOut += "," + assertions[i];
	}
    }

    queryOut = "page:" + String( recordsPerPage ) + "-" + String( page2show ) + queryOut;
    var path = dir + "submit-" + file + '?' + queryOut;

    return path;
}

function initListRecordsConfig( config )
{
    RecordInsertState = config.insertState;
    RecordBlankColumns = config.blankColumns;

    RecordID = new Array( );
    RecordInputType = new Array( );
    RecordContent = new Array( );
    RecordContentValues = new Array( );
    RecordData = new Array( );
    RecordCheck = new Array( );
    RecordInputState = new Array( );

    config.records.forEach( function( record, index ) {

        const i = index + 1;

        RecordID[i] = record.id;
        RecordInputType[i] = record.inputType;
        RecordContent[i] = record.content;
        RecordContentValues[i] = record.contentValues;
        RecordData[i] = record.data;
        RecordCheck[i] = record.check;
        RecordInputState[i] = record.inputState;

    } );
}

function initMultiFormRecordsConfig( config )
{
    RecordID = new Array( );
    RecordInputType = new Array( );
    RecordContent = new Array( );
    RecordContentValues = new Array( );
    RecordData = new Array( );
    RecordCheck = new Array( );
    RecordTitle = new Array( );

    RecordTitle[1] = config.title;

    config.records.forEach( function( record, index ) {

        const i = index + 1;

        RecordID[i] = record.id;
	RecordTitle[i] = record.title;
        RecordInputType[i] = record.inputType;
        RecordContent[i] = record.content;
        RecordContentValues[i] = record.contentValues;
        RecordData[i] = record.data;
        RecordCheck[i] = record.check;
    } );
}

function initTilesContent( config )
{
    config.tiles.forEach( function( tile ) {

        TILES[tile.page] = new Array(
            tile.title,
            tile.width,
            tile.height,
            tile.left,
            tile.top,
            tile.state
        );

        if (tile.state) {
            mosaicOpen( config.parentId, tile.page,
			function( content ) {
			    activateContent( content, tile.page );
			} );
        }
    } );

    mosaicMoveInitialize( );
    mosaicMenuInitialize( config.dashboardMenuId, config.dashboardControlId );
}

function activateContent( root = document, loadedPage )
{
    root.querySelectorAll( '[data-redirect]' ).forEach( function( element ) {
        window.location.replace( element.dataset.redirect );
    } );

    root.querySelectorAll( '[data-init-get-content]' ).forEach( function( element ) {
	initGetContent(
            element.dataset.reloadId,
            element.dataset.submitPage,
            element.dataset.checkboxId
	);

	element.remove( );
    } );

    root.querySelectorAll( '[data-init-post-content]' ).forEach( function( element ) {
	initPostContent(
            element.dataset.buttonId,
            element.dataset.formId,
            element.dataset.confirmation === 'true',
	    element.dataset.actionBeforePost,
            element.dataset.actionArgs
	);

	element.remove( );
    } );

    root.querySelectorAll( '[data-show-errors-zone]' ).forEach(function( element ) {
        showZone( element.dataset.showErrorsZone );
        element.remove( );
    } );

    root.querySelectorAll( '[data-init-table-form]' ).forEach( function( element ) {
	initTableForm( parseInt( element.dataset.recordNb, 10 ));
	element.remove( );
    } );

    root.querySelectorAll( '[data-table-navigation]' ).forEach( function( element ) {
        initTableNavigation( element );
    } );

    root.querySelectorAll( '[data-ddtabcontent]' ).forEach( function( element ) {
	var formTabs = new ddtabcontent( element.dataset.ddtabcontent );
	formTabs.setpersist( element.dataset.persist === 'true' );
	formTabs.setselectedClassTarget( element.dataset.selectedClassTarget );
	formTabs.init( );
    } );

    root.querySelectorAll( '[data-init-bi-select-list]' ).forEach(
	function( element ) {
            initSelectionList(
		element.dataset.selectId1,
		element.dataset.selectId2,
		element.dataset.addToSelectedId,
		element.dataset.delFromSelectedId
            );
            element.remove( );
	}
    );

    root.querySelectorAll( '[data-init-blink-icon]' ).forEach(
	function( element ) {
            initBlinkIcon(
		parseInt( element.dataset.index, 10 ),
		element.dataset.imageId
            );
            element.remove( );
	}
    );

    root.querySelectorAll( '[data-init-refresh-shortcuts]' ).forEach(
	function( element ) {
            initRefreshShortcuts( );
            element.remove( );
	}
    );

    root.querySelectorAll( '[data-init-refresh-exchange-file-percent]' ).forEach(
    function( element ) {
        initRefreshExchangeFilePercent(
            element.dataset.filenameId,
            element.dataset.progressId,
            parseInt( element.dataset.progression, 10 ),
            element.dataset.page
        );
        element.remove();
    } );

    root.querySelectorAll( '[data-init-focus]' ).forEach(
	function( element ) {
	    document.getElementById( element.dataset.targetId )?.focus();
	    element.remove();
	}
    );

    root.querySelectorAll( 'script[type="application/json"][data-list-records-config]' ).forEach( function( element ) {
	const config = JSON.parse( element.textContent );
	initListRecordsConfig( config );
	element.remove( );
    } );

    root.querySelectorAll( 'script[type="application/json"][data-multi-form-records-config]' ).forEach( function( element ) {
	const config = JSON.parse( element.textContent );
	initMultiFormRecordsConfig( config );
	element.remove( );
    } );

    var page;

    if (loadedPage) {
        page = loadedPage;
    }
    else {
	var page = window.location.pathname
	    .split( '/' )
	    .pop( )
	    .replace( /\.[^.]+$/, '' );
    }

    switch (page) {

    case 'admin':
    case 'first-login':
	root.querySelectorAll( '[data-init-qrcode]' ).forEach(
	    function( element ) {
		const size = 95;
		new QRCode(
		    document.getElementById( element.dataset.targetId ),
		    {
			text: element.dataset.text,
			width: size,
			height: size,
			colorDark: 'firebrick',
			colorLight: 'white',
			correctLevel: QRCode.CorrectLevel.M
		    }
		);
		element.remove( );
	    }
	);
	break;

    case 'conf-load-save-core':
	const form = document.getElementById( element.dataset.formId );
	if ( form ) {
            form.submit( );
	}
	break;

    case 'dynamicdns':
	root.querySelectorAll( '[data-init-dynamic-dns-select]' ).forEach(
	    function( element ) {
		dynamicDNSSelectCB(
		    element.dataset.stateId,
		    element.dataset.providerId,
		    element.dataset.hostnameId,
		    element.dataset.usernameId,
		    element.dataset.usernameId,
		    element.dataset.providerWebsiteId
		);
		element.remove( );
	    }
	);
	break;

    case 'register':
	root.querySelectorAll( '[data-init-registration-mode-select]' ).forEach(
	    function( element ) {
		registrationModeSelectCB(
		    element.dataset.mode,
		    element.dataset.link,
		    element.dataset.email
		);
		element.remove( );
	    }
	);

	root.querySelectorAll( '[data-init-registration-action-select]' ).forEach(
	    function( element ) {
		registrationActionSelectCB(
		    element.dataset.action,
		    element.dataset.osKey
		);
		element.remove( );
	    }
	);
	break;

    case '':
    case 'system-report':
    case 'login':
	root.querySelectorAll( '[data-init-mosaic-auto-reload-all]' ).forEach(
	    function( element ) {
		mosaicInitAutoReloadAll(
		    element.dataset.autoId,
		    parseInt( element.dataset.interval, 10 ),
		    function( content, page ) {
			activateContent( content, page );
		    } );
		element.remove( );
	    }
	);

	root.querySelectorAll( 'script[type="application/json"][data-init-tiles]' ).forEach( function( element ) {
	    const config = JSON.parse( element.textContent );
	    initTilesContent( config );
	    element.remove( );
	    } );
	break;

    case 'update-system-report-memory':
    case 'system-report-load-memory':
	root.querySelectorAll( 'script[type="application/json"][data-init-memory-pie-chart]' ).forEach( function( element ) {
	    initMemoryPieCharts( JSON.parse( element.textContent ) );
	    element.remove( );
	} );
	break;

    case 'update-network-activity':
    case 'network-activity-internal':
    case 'network-activity-external':
    case 'network-activity-auxiliary':
	root.querySelectorAll( 'script[type="application/json"][data-init-graph-chart]' ).forEach( function( element ) {
	    initGraphChart( JSON.parse( element.textContent ));
	    element.remove( );
	} );
	break;

    case 'cache-report':
	root.querySelectorAll( 'script[type="application/json"][data-init-gauge-chart]' ).forEach( function( element ) {
	    var config = JSON.parse( element.textContent );
	    initGaugeChart( config );
	    element.remove( );
	} );
	break;

    case 'system-report-counter':
	root.querySelectorAll( '[data-init-bar-chart]' ).forEach( function( element ) {
            initBarChart( JSON.parse( element.textContent ));
            element.remove( );
	} );
	break;

    case 'qos-report':
	root.querySelectorAll( 'script[type="application/json"][data-init-qos-pie-chart]' ).forEach( function( element ) {
	    var config = JSON.parse( element.textContent );
	    var id = config.bindto.replace( /^#/, "" );

	    initGenericPieChart(
		id,
		config.data.columns,
		Number( config.size.width ),
		Number( config.size.height )
	    );
	    element.remove( );
	} );
	break;

    case 'time':
	root.querySelectorAll( '[data-init-start-clock]' ).forEach(
	    function( element ) {
		startClock(
		    element.dataset.containerId,
		    parseInt( element.dataset.dateSeconds, 10 ),
		    parseInt( element.dataset.dateOffsetMn, 10 )
		);
		element.remove( );
	    }
	);
	break;	

    case 'tls-ca-system-load-save':
	root.querySelectorAll( '[data-init-print-tls]' ).forEach(
	    function( element ) {
		printTLS(
		    element.dataset.page,
		    element.dataset.componentId,
		    element.dataset.contentId
		);
		element.remove( );
	    }
	);
	break;

    case 'tls-ca-third-load':
	root.querySelectorAll( '[data-init-print-tls-ca]' ).forEach(
	    function( element ) {
		printTLSCA(
		    GUI_DIR + element.dataset.page + GUI_EXTENSION + '?' + element.dataset.pageArgs,
		    element.dataset.contentId
		);
		element.remove( );
	    }
	);
	break;

    case 'tls-client-manage':
	root.querySelectorAll( '[data-init-print-tls]' ).forEach(
	    function( element ) {
		printTLS(
		    GUI_DIR + element.dataset.page + GUI_EXTENSION + '?' + element.dataset.pageArgs,
		    element.dataset.componentId,
		    element.dataset.contentId
		);
		element.remove( );
	    }
	);
	break;

    case 'tls-ca-system-generate':
    case 'tls-server-generate':
	root.querySelectorAll( '[data-init-ajax-update-tls-conf]' ).forEach(
	    function( element ) {

		AJAX_updateTLSConf(
		    GUI_DIR + element.dataset.page + GUI_EXTENSION + '?' + element.dataset.pageArgs,
		    element.dataset.namesId,
		    element.dataset.numbitsId,
		    element.dataset.daysId,
		    element.dataset.countryId,
		    element.dataset.provinceId,
		    element.dataset.localityId,
		    element.dataset.organisationId,
		    element.dataset.unitId
		);
		element.remove();
	    }
	);
	break;

    case 'tls-server-manage':
	root.querySelectorAll( '[data-init-tls-component-select]' ).forEach(
	    function( element ) {
		TLSComponentSelectCB(
		    element.dataset.componentId,
		    element.dataset.operationId,
		    element.dataset.daysId,
		    element.dataset.ocspId,
		    element.dataset.page,
		    element.dataset.contentId
		);
		element.remove( );
	    }
	);
	break;

    case 'urllist-content':
	root.querySelectorAll( '[data-init-url-list-content-select]' ).forEach(
	    function( element ) {
		URLListContentSelectCB(
		    element.dataset.operationId,
		    element.dataset.protocolId,
		    element.dataset.serverId,
		    element.dataset.filenameId,
		    element.dataset.verifyId
		);
		element.remove( );
	    }
	);
	break;

    case 'vpnipsec-access-conf':
	root.querySelectorAll( '[data-show-ipsec-access-conf]' ).forEach( function( element ) {
	    IPsecVPNAccessConfSelectCB( element.dataset.systemId, element.dataset.tlsId, element.dataset.contentId );
	    element.remove( );
	} );
	break;

    case 'vpnipsec-authenticate':
	root.querySelectorAll( '[data-init-vpn-ipsec-authenticate-select]' ).forEach(
	    function( element ) {
		VPNIPsecAuthenticateSelectCB(
		    element.dataset.methodId,
		    element.dataset.autoPskId,
		    element.dataset.pskId,
		    element.dataset.tlsIdId,
		    element.dataset.usedIdId
		);

		element.remove( );
	    }
	);
	break;

    case 'vpnipsec-site-settings':
	root.querySelectorAll( '[data-init-vpn-ipsec-site-settings]' ).forEach(
	    function( element ) {
		VPNIPsecSiteSettingsCB(
		    element.dataset.authenticateId,
		    element.dataset.tlsAuthenticateId,
		    element.dataset.tlsIdId,
		    element.dataset.dnFqdnId,
		    element.dataset.pskId
		);
		element.remove( );
	    }
	);
	break;

    case 'waf-rweb-custom':
	root.querySelectorAll( '[data-init-show-waf-rules]' ).forEach(
	    function( element ) {
		showWAFRules(
		    element.dataset.page,
		    element.dataset.targetId
		);
		element.remove( );
	    }
	);
	break;

    default:
	break;
    }
}

function initPageSelectionBrowseCB( selectedPage, recordsPerPage, previousButton, nextButton, pages, action )
{
    var page2show = selectedPage.value;
    var recordsPPage = recordsPerPage.value;

    if ( ! $.isNumeric( page2show )) return false;
    if ( ! $.isNumeric( recordsPPage )) return false;

    let newPage = page2show;

    switch (action) {
    case 'select':
	break;

    case 'records':
	page2show = 0;
	break;

    case 'next':
	if (page2show < pages) {
	    newPage++;
	}
	else {
	    return false;
	}
	break;

    case 'previous':
	if ( page2show > 0) {
	    newPage--;
	}
	else {
	    return false;
	}
	break;

    default:
	return false;
	break;
    }

    selectedPage.disabled = true;
    recordsPerPage.disabled = true;
    previousButton.disabled = true;
    nextButton.disabled = true;

    var page = getSubmitPathWithPageArg( recordsPPage, newPage );

    setWorking( );

    $.get( page,
		     function( resultData, status )
		     {
			 switch (status) {
			 case 'success':
			     {
				 const core = document.getElementById( CORE_ID );
				 if ( !core ) {
				     stopWorking( false, "Missing content zone" );
				     return;
				 }

				 core.innerHTML = resultData;
				 activateContent( core );
				 stopWorking( true );
			     };
			     break;
			     
			 default:
			     stopWorking( false, "Communication Error" );
			     break;
			 }
		     } )
	.fail( function( ) { stopWorking( false, "Unable to get this page" ); } );

    return true;
}

function initTableNavigation( navigation )
{
    navigation.dataset.initialised = 'true';
}

function initPageSelection( )
{
    const selectedPage = document.getElementById( SELECTED_PAGE_ID );
    const previousButton = document.getElementById( PREVIOUS_PAGE_ID );
    const nextButton = document.getElementById( NEXT_PAGE_ID );

    if ( !selectedPage ||
         !previousButton ||
         !nextButton ) {

        return false;
    }

    const page2show = parseInt( selectedPage.value, 10 );
    const pages = selectedPage.options.length;

    previousButton.disabled = ( page2show === 0 );
    nextButton.disabled = ( page2show === (pages - 1) );

    return true;
}

function initTableForm( recordNb )
{
    window.NewRecords = 0;
    window.DeletedRecords = 0;
    window.TableRecordCursor = recordNb;
    window.InitialTableRecordCursor = recordNb;

    const table = document.getElementById( MAIN_TABLE_ID );

    if ( table ) {
        window.OldTable = $( table ).clone( true );
    }

    initPageSelection( );
    deactivateOKIconBar( );
}

function postContent( form_id, confirmation )
{
    const form = document.getElementById( form_id );

    if ( !form ) {
        return false;
    }

    if ( form.beforePost ) {

	switch (form.beforePost.action) {

	case 'add-hidden-input-from-selection-item':
	    addHiddenInputFromSelectionItem( form_id, form.beforePost.args )
	    break;

	default:
	    break;
	}
    }

    if ( confirmation ) {
        var message = "Are you sure you want to perform this action?";
        var response = confirm( message );

        if ( !response ) {
            return false;
        }
    }

    var selectedPage = document.getElementById( SELECTED_PAGE_ID );
    var recordsPerPage = document.getElementById( RECORDS_PPAGE_ID );
    var previousButton = document.getElementById( PREVIOUS_PAGE_ID );
    var nextButton = document.getElementById( NEXT_PAGE_ID );

    var page;

    if ( selectedPage != null &&
         recordsPerPage != null &&
         previousButton != null &&
         nextButton != null ) {

        selectedPage.disabled = true;
        recordsPerPage.disabled = true;
        previousButton.disabled = true;
        nextButton.disabled = true;

        var page2show = parseInt( selectedPage.value, 10 );
        var recordsPPage = parseInt( recordsPerPage.value, 10 );

        page2show = getExistingPage2show( recordsPPage, page2show );

        page = getSubmitPathWithPageArg( recordsPPage, page2show );
    }
    else {
        page = form.action;
    }

    var postData, processData, contentType;

    if ( form.enctype === 'multipart/form-data' ) {

        postData = new FormData( form );
        processData = false;
        contentType = false;

    }
    else {
	postData = $( '#' + form_id ).serialize( );
	var processData = true;
	var contentType = 'application/x-www-form-urlencoded; charset=UTF-8';
    }

    setWorking( "Submitting" );

    var post = $.ajax( {
        url: page,
        type: 'POST',
        data: postData,
        processData: false,
        contentType: false,

        success: function( resultData, status ) {
            switch ( status ) {
            case 'success':
                const core = document.getElementById( CORE_ID );
                core.innerHTML = resultData;
                activateContent( core );
                break;

            default:
                stopWorking( false, "Communication Error" );
                break;
            }
        }
    } );

    post.fail( function( ) {
        stopWorking( false, "Unable to post this page" );
    } );

    return true;
}

function initPostContent( button_id, form_id, confirmation,  action, args )
{
    const button = document.getElementById( button_id );
    const form = document.getElementById( form_id );

    if ( !button || !form ) {
        return false;
    }

    button.dataset.postFormId = form_id;
    button.dataset.confirmation = confirmation;

    form.beforePost = {
        action: action || '',
        args: args ? JSON.parse( args ) : []
    };

    $( '#' + button_id ).click( function( ) {
	postContent( form_id, confirmation );
    } );
}

function doClickButton( button_id )
{
    const button = document.getElementById( button_id );

    if ( !button ) {
        return false;
    }

    if ( button.dataset.postFormId ) {
        return postContent(
            button.dataset.postFormId,
            button.dataset.confirmation === 'true'
        );
    }

    return true;
}

function initGetContent( link_id, page, option_checkbox_id )
{
    $( '#' + link_id ).on('click', function( ) {
	var selectedPage = document.getElementById( SELECTED_PAGE_ID );
	var recordsPerPage = document.getElementById( RECORDS_PPAGE_ID );
	var previousButton = document.getElementById( PREVIOUS_PAGE_ID );
	var nextButton = document.getElementById( NEXT_PAGE_ID );

	if (selectedPage != null && recordsPerPage != null && previousButton != null && nextButton != null) {

	    selectedPage.disabled = true;
	    recordsPerPage.disabled = true;
	    previousButton.disabled = true;
	    nextButton.disabled = true;

	    var page2show = parseInt( selectedPage.value, 10 );
	    var recordsPPage = parseInt( recordsPerPage.value, 10 );
	    page2show = getExistingPage2show( recordsPPage, page2show );
	    page = getSubmitPathWithPageArg( recordsPPage, page2show );
	}
	else {
	    if (option_checkbox_id != null) {
		var optionCheckbox = document.getElementById( option_checkbox_id );
		if (optionCheckbox != null) {
		    var pos = page.indexOf( '?' );
		    if (pos != -1) {
			page = page.substring( 0, pos );
		    }
		    if (optionCheckbox.checked == true) {
			page += '?' + option_checkbox_id;
		    }
		}
	    }
	}

	setWorking( "Reloading" );

	var get = $.get( page,
			 function( resultData, status ) {
			     switch (status) {
			     case 'success':
				 const core = document.getElementById( CORE_ID );
				 core.innerHTML = resultData;
				 activateContent( core );
				 break;

			     default:
				 stopWorking( false, "Communication Error" );
				 break;
			     }
			 } );

        get.fail( function( ) { stopWorking( false, "Unable to get this page" ); } );
    } );
}

function makeFunctionArgs( inArgs )
{
    var outArgs = "";

    for (i=0 ; i<inArgs.length ; i++) {
	outArgs += ", '" + inArgs[i] + "_" + String( TableRecordCursor ) + "'";
    }
    outArgs = outArgs.slice( 2 );

    return outArgs;
}

function makeOptionsList( items, itemValues, selected )
{
    const group_prefix_begin = "__group_begin:";
    const group_end = "__group_end";

    var options = "";
    var range = "opt_" + String( TableRecordCursor ) + "_";
    var flag;

    for (i=0 ; i<items.length ; i++) {
	var option = items[i];
	if ( option.indexOf( group_prefix_begin ) === 0 ) {
	    options += "<optgroup label='" + option.substring( group_prefix_begin.length ) + "'>";
	}
	else {
	    if (option == group_end) {
		options += "</optgroup>";
	    }
	    else {
		if (itemValues.length === 0) {
		    var optionValue = option;
		}
		else {
		    var optionValue = itemValues[i];
		}

		if (optionValue == selected) {
		    flag = " selected";
		}
		else {
		    flag = "";
		}

		options += "<option id='" + range + option + "' name='" + range + option + "' value='" + optionValue + "'" + flag + ">" + option + "</option>"
	    }
	}
    }

    return options;
}

function getRowsInRecord( )
{
    var rows = 1

    for (var i = 0 ; i < RecordInputType.length ; i++) {
	if (RecordInputType[i] == "br") {
	    rows++;
	}
    }

    return rows
}

function newListTableRecord( table_id, type, src_inputs )
{
    var record = "<tr class='" + RECORD_CLASS_PREFIX + TableRecordCursor + "'>";
    var value, content, rows = 1, index_value = 1, separator = '';
    var record_rows = getRowsInRecord( );

    record += "<td><div class='center'>";
    record += "<input id='" + ENTRY_ID_PREFIX + TableRecordCursor + "' name='" + ENTRY_ID_PREFIX + TableRecordCursor + "' type='hidden' value='" + type + "' />";
    record += "<button type='button' class='" + ROW_ACTION_CLASS + " delete-item' data-action='remove-record' data-record-cursor='" + TableRecordCursor + "'></button>";

    if ( RecordInsertState ) {
	record += "<button type='button' class='" + ROW_ACTION_CLASS + " move-item-up' data-action='move-up-table-record' data-table-id='" + table_id + "' data-record-class='" + RECORD_CLASS_PREFIX + TableRecordCursor + "'></button>";
	record += "<button type='button' class='" + ROW_ACTION_CLASS + " move-item-down' data-action='move-down-table-record' data-table-id='" + table_id + "' data-record-class='" + RECORD_CLASS_PREFIX + TableRecordCursor + "'></button>";
    }
    record += "</div></td>";
    
    var with_br = false;
    for (var i = 1 ; i < RecordID.length ; i++) {

	input_state = "";

	switch (RecordInputType[i]) {
	case 'br':
	    rows++;
	    if ((rows % record_rows) == 0) {
		separator = 'list-item-separator';
	    }
	    with_br = true;

	    for (var j = 0 ; j < RecordBlankColumns ; j++) {
                record += "<td></td>";
	    }

	    record += "</tr><tr class='" + RECORD_CLASS_PREFIX + TableRecordCursor + "'><td class='" + separator + "' bgcolor='" + UNUSED_COLOR + "'>" + RecordContent[i] + "</td>";
	    break;

	case 'input':
	case 'encoded':
	    if (src_inputs) {
		if (RecordInputType[i] == 'encoded') {
		    value = decodeString( src_inputs[index_value] );
		}
		else {
		    value = src_inputs[index_value];
		}
		index_value++;
	    }
	    else {
		value="";
	    }
	    record += "<td class='" + separator + "'" + "><input name='" + RecordID[i] + "_" + TableRecordCursor + "' id='" + RecordID[i] + "_" + TableRecordCursor + "' " + RecordContent[i] + " data-action='check-input' data-check-function='" + RecordCheck[i] + "' value='" + value + "' /></td>";
	    break;

	case 'text':
	    record += "<td class='" + separator + "'" + "></td>";
	    break;

	case 'textarea':
	    if (src_inputs) {
		value = src_inputs[index_value];
		value = atob( value );
		index_value++;
	    }
	    else {
		value="";
	    }
	    record += "<td class='" + separator + "'" + "><textarea name='" + RecordID[i] + "_" + TableRecordCursor + "' id='" + RecordID[i] + "_" + TableRecordCursor + "' " + RecordContent[i] + " data-action='check-input' data-check-function='" + RecordCheck[i] + "'>" + value + "</textarea></td>";
	    break;

	case 'state':
	    if (src_inputs) {
		content = RecordContent[i].replace( / checked/, "" );
		value = src_inputs[index_value];
		index_value++;
		if (value) {
		    value=" checked";
		}
		else {
		    value="";
		}
	    }
	    else {
		content = RecordContent[i];
		value="";
	    }
	    record += "<td class='" + separator + "'" + "><center><input name='" + RecordID[i] + "_" + TableRecordCursor + "' id='" + RecordID[i] + "_" + TableRecordCursor + "' " + content + value + " /></center></td>";
	    break;
	    
	case 'text':
	    if (!RecordID[i] && !RecordContent[i]) {
		record += "<td class='" + separator + "' bgcolor='" + UNUSED_COLOR + "'></td>";
	    }
	    else {
		record += "<td class='" + separator + "'>" + RecordContent[i] + "</td>";
	    }
	    break;

	case 'select':
	    if (src_inputs) {
		value = src_inputs[index_value];
		index_value++;
	    }
	    else {
		value="";
	    }

	    if (RecordData[i]) {
		var data = ' ' + RecordData[i];
	    }
	    else {
		var data = "";
	    }

	    content = makeOptionsList( RecordContent[i], RecordContentValues[i], value );

	    record += "<td class='" + separator + "'" + "><select " + input_state + "name='" + RecordID[i] + "_" + TableRecordCursor + "' id='" + RecordID[i] + "_" + TableRecordCursor + "'" + data + ">" + content + "</select></td>";
	    break;
	    
	default:
	    break;
	}
    }

    for (i = 0 ; i < RecordBlankColumns ; i++) {
	record += "<td class='" + separator + "'></td>";
    }

    record += "</tr>";
    
    return record;
}

function newMultiTableRecord( table_id, type, src_inputs )
{
    var record = "<tr class='" + RECORD_CLASS_PREFIX + TableRecordCursor + " " + RECORD_FIRST_TR_CLASS + "' id='row_" + RecordID[0] + "_" + TableRecordCursor + "'><td><strong>" + RecordTitle[0] + "</strong></td><td><input id='" + ENTRY_ID_PREFIX + TableRecordCursor + "' name='" + ENTRY_ID_PREFIX + TableRecordCursor + "' type='hidden' value='" + type + "' />";

    record += "<button type='button' class='" + ROW_ACTION_CLASS + " delete-item' data-action='remove-record' data-record-cursor='" + TableRecordCursor + "'></button></td></tr>";

    var item, value, index_value = 3;

    for (var i = 1 ; i < RecordID.length ; i++) {
	switch (RecordInputType[i]) {
	case 'select':
	    if (src_inputs) {
		value = src_inputs[index_value];
		index_value++;
	    }
	    else {
		value="";
	    }

	    if (RecordData[i]) {
		var data = ' ' + RecordData[i];
	    }
	    else {
		var data = "";
	    }

	    var content = makeOptionsList( RecordContent[i], RecordContentValues[i], value );
	    item = "<select name='" + RecordID[i] + "_" + TableRecordCursor + "' id='" + RecordID[i] + "_" + TableRecordCursor + "'" + data + ">" + content + "</select>";
	    break;

	case 'input':
	case 'encoded':
	    if (src_inputs) {
		value = src_inputs[index_value];
		index_value++;
	    }
	    else {
		value="";
	    }

	    item = "<input name='" + RecordID[i] + "_"  + TableRecordCursor + "' id='" + RecordID[i] + "_"  + TableRecordCursor + "' " + RecordContent[i] + "data-action='check-input' data-check-function='" + RecordCheck[i] + "' value='" + value + "' />";
	    break;

	case 'textarea':
	    if (src_inputs) {
		value = src_inputs[index_value];
		value = atob( value );
		index_value++;
	    }
	    else {
		value="";
	    }

	    item = "<textarea name='" + RecordID[i] + "_"  + TableRecordCursor + "' id='" + RecordID[i] + "_"  + TableRecordCursor + "' " + RecordContent[i] + "data-action='check-input' data-check-function='" + RecordCheck[i] + "'>" + value + "</textarea>";
	    break;

	default:
	    break;
	}
	item = "<tr class='" + RECORD_CLASS_PREFIX + TableRecordCursor + "' id='row_" + RecordID[i] + "_" + TableRecordCursor + "'><td>" + RecordTitle[i] + "</td><td>" + item + "</td></tr>"
	record += item;
    }

    return record;
}

function removeRecord( record_index )
{
    var the_record = $( '.' + RECORD_CLASS_PREFIX + record_index );
    if (the_record == null) return false;

    for (var i = 0, row ; i < the_record.length ; i++) {
        row = the_record[i];
        $(row).remove( );
    }
    NewRecords--;
    TableRecordCursor++;
}

function deleteTableRecord( table_type, record_class, del_id )
{
    var rows = document.querySelectorAll( '[class ~= "' + record_class + '"]' );
    if (rows == null) return false;

    var del = document.getElementById( del_id );
    if (del == null) return false;

    switch (table_type) {
    case 'list':
	var init = 0;
	break;
	
    case 'multi':
	var init = 1;
	break;
	
    default:
	var init = 0;
	break;
    }

    if (del.checked == false) {
        for (var i=init ; i<rows.length ; i++) {
            var cells = rows[i].getElementsByTagName( 'td' );
            for (var j=init ; j<cells.length ; j++) {
		cells[j].classList.add( 'to-delete' );
            }
        }
	DeletedRecords++;
    }
    else {
        for (var i=init ; i<rows.length ; i++) {
            var cells = rows[i].getElementsByTagName( 'td' );
            for (var j=init ; j<cells.length ; j++) {
		cells[j].classList.remove( 'to-delete' );
            }
        }
	DeletedRecords--;
    }

    del.checked = !del.checked;
    
    activateSubmitButton( );
    activateOKIconBar( );
    activateResetButton( );
}

function animateRecord( record )
{
    for (var i = 0, row ; i < record.length ; i++) {
        row = record[i];
        $(row).animate( {opacity:'0.5'}, 300 );
        $(row).animate( {opacity:'1.0'}, 300 );
    }
}

function toggleSelectionsTableRecords( )
{
    var selections = document.querySelectorAll( '.' + SELECTION_CLASS );
    var state = ! isARecordSelected( );

    for (var i=0 ; i<selections.length ; i++) {
        selections[i].checked = state;
    }

    updateTableButtons( );
}

function toggleSelection( selection_class, state1, state2 )
{
    var selections = $( '.' + selection_class );
    if ( selections == null) return false;

    for (var i = 0 ; i < selections.length ; i++) {
	var selection = selections[i];
	if (selection.value == state1) {
	    selection.value = state2;
	}
	else {
	    selection.value = state1;
	}
    }
}

function preventSelect( e )
{
    e.preventDefault( );
}

function enableInput( element )
{
    switch (element.tagName) {
    case 'INPUT':
    case 'TEXTAREA':
        element.readOnly = false;
        break;

    case 'SELECT':
        element.removeEventListener( 'mousedown', preventSelect );
        element.removeEventListener( 'keydown', preventSelect );
        break;
    }

    element.classList.remove( 'read-only' );
}

function disableInput( element )
{
    switch ( element.tagName ) {
    case 'INPUT':
    case 'TEXTAREA':
        element.readOnly = true;
        break;

    case 'SELECT':
        element.addEventListener( 'mousedown', preventSelect );
        element.addEventListener( 'keydown', preventSelect );
        break;
    }

    element.classList.add( 'read-only' );
}

function enableInputByID( input_id )
{
    var input = document.getElementById( input_id );
    enableInput( input );
}

function disableInputByID( input_id )
{
    var input = document.getElementById( input_id );
    disableInput( input );
}

function selectURLListAutoProtocolCB( protocol_id, server_id, filename_id )
{
    var protocol = document.getElementById( protocol_id );
    var server = document.getElementById( server_id );
    var filename = document.getElementById( filename_id  );

    if (protocol == null) return false;
    if (server == null) return false;
    if (filename == null) return false;

    var protocolValue = protocol.options[protocol.selectedIndex].value;

    switch (protocolValue) {
    case '_push':
	disableInput( server );
	disableInput( filename );
	break;
	
    default:
	enableInput( server );
	enableInput( filename );
	break;
    }
}

function selectAllTheSameCB( src_selection_id, dst_selection_class )
{
    var src_selection = document.getElementById( src_selection_id );
    var dst_selections = $( '.' + dst_selection_class );
    if ( src_selection == null) return false;
    if ( dst_selections == null) return false;

    var src_value = src_selection.value;
    if (!src_value) return true;

    for (var i = 0 ; i < dst_selections.length ; i++) {
	var dst_selection = dst_selections[i];
	dst_selection.value = src_value;
    }
}

function selectURLListAutoAllProtocolCB( protocol_id, protocol_class, file_server_class, filename_class )
{
    var protocol = document.getElementById( protocol_id );
    if (protocol == null) return false;

    selectAllTheSameCB( protocol_id, protocol_class );

    var protocolValue = protocol.options[protocol.selectedIndex].value;
    var i, dst_selection, dst_selections;

    switch (protocolValue) {

    case '_push':

	dst_selections = $( '.' + file_server_class );
	for (var i = 0 ; i < dst_selections.length ; i++) {
	    var dst_selection = dst_selections[i];
	    disableInput( dst_selection );
	}

	dst_selections = $( '.' + filename_class );
	for (var i = 0 ; i < dst_selections.length ; i++) {
	    var dst_selection = dst_selections[i];
	    disableInput( dst_selection );
	}

	break;
	
    default:

	dst_selections = $( '.' + file_server_class );
	for (var i = 0 ; i < dst_selections.length ; i++) {
	    var dst_selection = dst_selections[i];
	    enableInput( dst_selection );
	}

	dst_selections = $( '.' + filename_class );
	for (var i = 0 ; i < dst_selections.length ; i++) {
	    var dst_selection = dst_selections[i];
	    enableInput( dst_selection );
	}

	break;
    }
}

function deleteTableSelectedRecords( table_type, table_id )
{
    var table = document.getElementById( table_id );
    if (table == null) return false;

    var table_body = table.tBodies[0];
    var record_class = null;

    for (var i = 0, row ; row = table_body.rows[i] ; i++) {
	for (var j = 0, col ; col = row.cells[j] ; j++) {
	    var inputs = col.getElementsByTagName( 'input' );
	    for (var k = 0 ; k < inputs.length ; k++) {
		var input = inputs[k];
		var id = input.getAttribute( 'id' );

		if (id.substring( 0, DEL_ID_PREFIX.length ) == DEL_ID_PREFIX) {
		    var del_id = input.getAttribute( 'id' );
		}

		if (id.substring( 0, SEL_ID_PREFIX.length ) == SEL_ID_PREFIX) {
		    var sel_id = input.getAttribute( 'id' );
		    if (input.type == 'checkbox' && input.checked == true) {
			record_class = row.classList.item( 0 );
			deleteTableRecord( table_type, record_class, del_id );
		    }
		}
	    }
	}
    }
    if (record_class == null) {
	return false;
    }
    else {
	activateSubmitButton( );
        activateOKIconBar( );
	activateResetButton( );
    }
}

function moveUpTableRecord( table_id, the_record_class )
{
    var the_record = $( '.' + the_record_class );
    if (the_record == null) return false;
    
    var record_pos = the_record[0].rowIndex;
    record_pos--;
    var record_index = record_pos / the_record.length;
    record_index++;
    record_pos -= the_record.length;
    var rows = $( '#' + table_id + ' > tbody tr' ).length;
    var records = rows / the_record.length;
    
    for (var i = 0 ; i < the_record.length ; i++) {
        var row = the_record[i];
        if (record_pos >=0) {
            var moved = true;
            $( '#' + table_id + ' > tbody tr' ).eq( record_pos ).before( row );
            record_pos++;
        }
    }
    if (!moved) return false;

    var row_nb = the_record_class.substring( RECORD_CLASS_PREFIX.length );
    var entry_id = ENTRY_ID_PREFIX + row_nb;
    var entry = document.getElementById( entry_id );
    if (entry == null) return false;

    if (entry.value == 'anew' || entry.value == 'inew') {
        entry.value = 'inew';
    }
    else {
	var selectedPage = document.getElementById( SELECTED_PAGE_ID );
	var recordsPerPage = document.getElementById( RECORDS_PPAGE_ID );
	if (selectedPage == null) return false;
	if (recordsPerPage == null) return false;

	if (records > 1) {
	    entry.value = "move" + (record_index - 1 + selectedPage.value * recordsPerPage.value).toString( );
	}
    }

    animateRecord( the_record );

    activateSubmitButton( );
    activateOKIconBar( );
    activateResetButton( );
}

function moveDownTableRecord( table_id, the_record_class )
{
    var the_record = $( '.' + the_record_class );
    if (the_record == null) return false;
    
    var record_pos = the_record[0].rowIndex;
    record_pos--;
    record_pos += the_record.length;
    var record_index = record_pos / the_record.length;
    record_pos += the_record.length;
    record_pos--;

    var rows = $( '#' + table_id + ' > tbody tr' ).length;
    var records = rows / the_record.length;

    for (var i = 0 ; i < the_record.length ; i++) {
        var row = the_record[i];
        if (record_pos < rows) {
            var moved = true;
            $( '#' + table_id + ' > tbody tr' ).eq( record_pos ).after( row );
        }
    }

    if (!moved) return false;

    var row_nb = the_record_class.substring( RECORD_CLASS_PREFIX.length );
    var entry_id = ENTRY_ID_PREFIX + row_nb;
    var entry = document.getElementById( entry_id );
    if (entry == null) return false;

    if (entry.value == 'anew' || entry.value == 'inew') {
	if (record_index == records - 1) {
            entry.value = 'anew';
	}
	else {
            entry.value = 'inew';
	}
    }
    else {
	var selectedPage = document.getElementById( SELECTED_PAGE_ID );
	var recordsPerPage = document.getElementById( RECORDS_PPAGE_ID );
	if (selectedPage == null) return false;
	if (recordsPerPage == null) return false;

	if (records > 1) {
	    entry.value = "move" + (record_index + 1 + selectedPage.value * recordsPerPage.value).toString( );
	}
    }

    animateRecord( the_record );

    activateSubmitButton( );
    activateOKIconBar( );
    activateResetButton( );
}

function resetTableChanges( table_id )
{
    if (typeof OldTable === 'undefined') return( false );
    var tmpTable = OldTable.clone( true );
    $( '#' + table_id ).replaceWith( OldTable );
    OldTable = tmpTable.clone( true );

    NewRecords = 0;
    TableRecordCursor = InitialTableRecordCursor;

    updateTableButtons( );

    deactivateResetButton( );
    deactivateSubmitButton( );
    deactivateOKIconBar( );
}

function isARecordSelected( )
{
    var state = false;

    var selections = document.querySelectorAll( '.' + SELECTION_CLASS );
    for (var i=0 ; i<selections.length ; i++) {
        if (selections[i].checked == true) {
            state = true;
            break;
        }
    }

    return state;
}

function getSelectedRecordNb( )
{
    var selected = 0;

    var selections = document.querySelectorAll( '.' + SELECTION_CLASS );
    for (var i=0 ; i<selections.length ; i++) {
        if (selections[i].checked == true) {
	    selected++;
        }
    }

    return selected;
}

function addBlankTableRecord( table_id, item )
{
    $( '#' + table_id ).find( 'tbody' ).append( item );
    NewRecords++;
    TableRecordCursor++;
}

function insertBlankTableRecord( table_id, pos, item )
{
    $( '#' + table_id + ' > tbody tr' ).eq( pos ).before( item );
    NewRecords++;
    TableRecordCursor++;
}

function addBlankTableRecords( add_type, record_class, table_id, table_type, max )
{
    var itemsToAdd = document.getElementById( ITEM_2ADD_ID );
    if (!itemsToAdd) return false;

    var nb = itemsToAdd.value;
    nb = Number ( nb );
    var total = nb + NewRecords;
    if (total > max) {
	alertMaxReached( max );
        return false;
    }

    for (var i=0 ; i<nb ; i++) {
	switch (table_type) {
	case 'list':
	    var item = newListTableRecord( table_id, add_type, null );
	    break;

	case 'multi':
	    var item = newMultiTableRecord( table_id, add_type, null );
	    break;

	default:
	    break;
	}

	switch (add_type) {
	case 'anew':
	    addBlankTableRecord( table_id, item );
	    break;

	case 'inew':
	    var rows = document.querySelectorAll( '.' + record_class );
	    var row = rows[0];
	    var pos = row.rowIndex;
	    pos--;

	    insertBlankTableRecord( table_id, pos, item );
	    break;

	default:
	    break;
	}
    }
    return true;
}

function addCopyPasteTableRecord( add_type, before_record_class, table_id, table_type, src_record_class )
{
    var rows = document.querySelectorAll( '.' + src_record_class );
    if (rows == null) return false;

    var src_inputs = new Array( );
    var nb = 0, pos = 0;

    for (var i=0 ; i<rows.length ; i++) {
        var inputs = rows[i].getElementsByTagName( 'input' );
        for (var j=0 ; j<inputs.length ; j++) {
	    if (inputs[j].type == 'hidden') {
                src_inputs[nb] = inputs[j].value;
                nb++;
	    }
	    else if (inputs[j].type == 'checkbox') {
		src_inputs[nb] = inputs[j].checked;
                nb++;
	    }
        }
    }

    switch (table_type) {
    case 'list':
	var item = newListTableRecord( table_id, add_type, src_inputs );
	break;

    case 'multi':
	var item = newMultiTableRecord( table_id, add_type, src_inputs );
	break;

    default:
	break;
    }

    switch (add_type) {
    case 'anew':
	addBlankTableRecord( table_id, item );
	pos = $( '#' + table_id ).length;
	break;
	
    case 'inew':
	var rows = document.querySelectorAll( '.' + before_record_class );
	var row = rows[0];
	pos = row.rowIndex;
	pos--;

	insertBlankTableRecord( table_id, pos, item );
	break;
	
    default:
	break;
    }

    return pos;
}

function addSelectedTableRecords( add_type, before_record_class, table_id, table_type, max )
{
    var nb = getSelectedRecordNb( );
    var total = nb + NewRecords;
    if (total > max) {
	alertMaxReached( max );
        return false;
    }

    var table = document.getElementById( table_id );
    if (table == null) return false;

    var table_body = table.tBodies[0];

    if (before_record_class) {
	var record_rows = document.querySelectorAll( '.' + before_record_class );
	var record_length = record_rows.length;
    }
    else {
	var record_length = 0;
    }

    for (var i = 0, row ; row = table_body.rows[i] ; i++) {
	for (var j = 0, col ; col = row.cells[j] ; j++) {
	    var inputs = col.getElementsByTagName( 'input' );
	    for (var k = 0 ; k < inputs.length ; k++) {
		var input = inputs[k];
		var id = input.getAttribute( 'id' );

		if (id.substring( 0, SEL_ID_PREFIX.length ) == SEL_ID_PREFIX) {
		    var sel_id = input.getAttribute( 'id' );
		    if (input.type == 'checkbox' && input.checked == true) {
			var src_record_class = row.getAttribute( 'class' ).split( ' ' )[0];
			var pos = addCopyPasteTableRecord( add_type, before_record_class, table_id, table_type, src_record_class );
			if (pos <= i) {
			    i += record_length;
			}
		    }
		}
	    }
	}
    }
    return true;
}

function addTableRecords( table_id, table_type, max )
{
    if (isARecordSelected( )) {
	if (!addSelectedTableRecords( 'anew', null, table_id, table_type, max )) {
	    return false;
	}
    }
    else {
	if (!addBlankTableRecords( 'anew', null, table_id, table_type, max )) {
	    return false;
	}
    }

    activateSubmitButton( );
    activateOKIconBar( );
    activateResetButton( );
    window.scrollTo( 0, document.body.scrollHeight );

}

function insertTableRecords( table_id, table_type, before_record_class, max )
{
    if (isARecordSelected( )) {
	if (!addSelectedTableRecords( 'inew', before_record_class, table_id, table_type, max )) {
	    return false;
	}
    }
    else {
	if (!addBlankTableRecords( 'inew', before_record_class, table_id, table_type, max )) {
	    return false;
	}
    }

    activateSubmitButton( );
    activateOKIconBar( );
    activateResetButton( );
}

function updateTableButtons( )
{
    var item2add_disabled = isARecordSelected( );
    var item_2add = document.getElementById( ITEM_2ADD_ID ).disabled = item2add_disabled;
    if (item_2add == null) return false;
    item_2add.disabled = item2add_disabled;

    var delete_button = document.getElementById( DELETE_ID )
    if (delete_button != null) {
	var delete_disabled = !item2add_disabled;
	delete_button.disabled = delete_disabled;
    }

    var add_image = document.getElementById( ADD_IMAGE_ID );
    if (add_image != null) {
        if (item2add_disabled) {
            add_image.src = GUI_IMAGE_DIR + "add-paste.png";
        }
        else {
            add_image.src = GUI_IMAGE_DIR + "add.png";
        }
    }

    var inserts = document.querySelectorAll( '.' + INSERT_IMAGE_CLASS );
    for (i=0 ; i<inserts.length ; i++) {
        if (item2add_disabled) {
	    inserts[i].classList.add( 'insert-paste-item' );
	    inserts[i].classList.remove( 'insert-item' );
	}
	else {
	    inserts[i].classList.add( 'insert-item' );
	    inserts[i].classList.remove( 'insert-paste-item' );
	}
    }
}

function removeTrailerBlank( val )
{
    val = val.replace( /^[ \t]+/, "" );
    val = val.replace( /[ \t]+$/, "" );
    return val;
}

function isBlank( val )
{
    return( val.match( /^[ \t]*$/ ));
}

function setInputOK( object )
{
    object.classList.remove( 'input-is-ko' );
    object.classList.add( 'input-is-ok' );

    return true;
}

function setInputKO( object )
{
    object.classList.remove( 'input-is-ok' );
    object.classList.add( 'input-is-ko' );

    return false;
}

function URLListContentSelectCB( operation_id, protocol_id, server_id, filename_id, verify_id )
{
    var operations = document.getElementById( operation_id );
    var protocol = document.getElementById( protocol_id );
    var server = document.getElementById( server_id );
    var filename = document.getElementById( filename_id );
    var verify = document.getElementById( verify_id );

    if (operations == null) return false;
    if (protocol == null) return false;
    if (server == null) return false;
    if (filename == null) return false;
    if (verify == null) return false;

    var operation = operations.options[operations.selectedIndex].value;

    switch (operation) {
    case 'clear':
	protocol.disabled = true;
	server.disabled = true;
	filename.disabled = true;
	verify.disabled = true;
	break;

    default:
	protocol.disabled = false;
	server.disabled = false;
	filename.disabled = false;
	verify.disabled = false;
	break;
    }
}

function registrationModeSelectCB( mode_id, link_id, email_id )
{
    var modes = document.getElementById( mode_id );
    var link = document.getElementById( link_id );
    var email = document.getElementById( email_id );

    if (modes == null) return false;
    if (email == null) return false;

    var a = null, href = null;
    if (link != null) {
	a = link.getElementsByTagName( 'a' );
	if (a == null) return false;
	if (a.length == 0) return false;
	href = a[0].href;
	href = href.replace( /\&mode=.*/g, "" );
    }
    
    var mode = modes.options[modes.selectedIndex].value;

    switch (mode) {
    case 'new':
	href += "&mode=new"
	enableInput( email );
	break;
	
    case 'old':
	href += "&mode=old"
	disableInput( email );
	break;

    default:
	break;
    }

    if (link != null && a != null && href != null) {
	a[0].href = href;
    }
}

function registrationActionSelectCB( action_id, os_key_id )
{
    var actions = document.getElementById( action_id );
    var os_key = document.getElementById( os_key_id );

    if (actions == null) return false;
    if (os_key == null) return false;
    
    var action = actions.options[actions.selectedIndex].value;

    switch (action) {
    case 'register':
	enableInput( os_key );
	break;
	
    case 'unregister':
	disableInput( os_key );
	break;

    default:
	break;
    }
}

function genericOperationSelectCB( operation_id, protocol_id, server_id, filename_id )
{
    var operations = document.getElementById( operation_id );
    var protocol = document.getElementById( protocol_id );
    var server = document.getElementById( server_id );
    var filename = document.getElementById( filename_id );

    if (operations == null) return false;
    if (protocol == null) return false;
    if (server == null) return false;
    if (filename == null) return false;

    var operation = operations.options[operations.selectedIndex].value;

    switch (operation) {
    case 'create':
    case 'clear':
	protocol.disabled = true;
	server.disabled = true;
	filename.disabled = true;
	break;

    default:
	protocol.disabled = false;
	server.disabled = false;
	filename.disabled = false;
	break;
    }
}

function backupOperationSelectCB( operation_id, protocol_id, server_id, filename_id )
{
    genericOperationSelectCB( operation_id, protocol_id, server_id, filename_id );
}

function fileOperationSelectCB( operation_id, protocol_id, server_id, filename_id, title_id )
{
    genericOperationSelectCB( operation_id, protocol_id, server_id, filename_id );

    var operations = document.getElementById( operation_id );
    var title = document.getElementById( title_id ); 

    if (operations == null) return false;
    if (title == null) return false;

    var operation = operations.options[operations.selectedIndex].value;

    switch (operation) {
    case 'del':
	title.innerHTML = 'File Path';
	break;

    default:
	title.innerHTML = 'Directory Path';
	break;
    }
}

function accessIPsecVPNProtocolSelectCB( protocol_id, server_id, name_id, title_id )
{
    var protocols = document.getElementById( protocol_id );
    var server= document.getElementById( server_id );
    var name= document.getElementById( name_id );
    var title = document.getElementById( title_id );

    if (protocols == null) return false;
    if (server == null) return false;
    if (name == null) return false;
    if (title == null) return false;

    var protocol = protocols.options[protocols.selectedIndex].value;

    switch (protocol) {
    case '_smtp':
	disableInput( server );
	enableInput( name );
	title.innerHTML = 'Receiver Email';
	break;

    default:
	enableInput( server );
	disableInput( name );
	title.innerHTML = 'File Path';
	break;
    }
}

function antivirusWhitelistOperationSelectCB( operation_id, protocol_id, server_id, filename_id )
{
    genericOperationSelectCB( operation_id, protocol_id, server_id, filename_id );
}

function SSHOperationSelectCB( operation_id, key_type_id, protocol_id, server_id, filename_id )
{
    var operations = document.getElementById( operation_id );
    var key_type = document.getElementById( key_type_id );
    var protocol = document.getElementById( protocol_id );
    var server = document.getElementById( server_id );
    var filename = document.getElementById( filename_id );

    if (operations == null) return false;
    if (key_type == null) return false;
    if (protocol == null) return false;
    if (server == null) return false;
    if (filename == null) return false;

    var operation = operations.options[operations.selectedIndex].value;

    switch (operation) {
    case 'generate':
	key_type.disabled = true;
	protocol.disabled = true;
	server.disabled = true;
	filename.disabled = true;
	break;

    default:
	key_type.disabled = false;
	protocol.disabled = false;
	server.disabled = false;
	filename.disabled = false;
	break;
    }
}

function targetGatewaySelectCB( scope_id, gateway_id )
{
    var scopes = document.getElementById( scope_id );
    var gateways = document.getElementById( gateway_id );

    if (scopes == null) return false;
    if (gateways == null) return false;

    var scope = scopes.options[scopes.selectedIndex].value;
    var gateway = gateways.options[gateways.selectedIndex].value;

    switch (scope) {
    case 'gateway':
	gateways.disabled = false;
	break;

    default:
	gateways.disabled = true;
	break;
    }
}

function patchOperationAutoLoadCB( aload_id, protocol_id, server_id, filename_id )
{
    var aload = document.getElementById( aload_id );
    var protocol = document.getElementById( protocol_id );
    var server = document.getElementById( server_id );
    var filename = document.getElementById( filename_id );

    if (aload == null) return false;
    if (protocol == null) return false;
    if (server == null) return false;
    if (filename == null) return false;

    if (aload.checked == true) {
	protocol.disabled = true;
	server.disabled = true;
	filename.disabled = true;
    }
    else {
	protocol.disabled = false;
	server.disabled = false;
	filename.disabled = false;
    }
}

function cacheSizeCB( state_id, min_size_id, max_size_id )
{

    var states = document.getElementById( state_id );
    var min_size = document.getElementById( min_size_id );
    var max_size = document.getElementById( max_size_id );

    if (states == null) return false;
    if (min_size == null) return false;
    if (max_size == null) return false;

    var state = states.options[states.selectedIndex].value;
    
    switch (state) {
    case 'on':
	min_size.disabled = false;
	max_size.disabled = false;
	break;

    case 'off':
	min_size.disabled = true;
	max_size.disabled = true;
	break;

    default:
	break;
    }
}

function configurationLoadSaveSelectCB( operation_id, state_id, server_id, filename_id )
{
    var operations = document.getElementById( operation_id );
    var state = document.getElementById( state_id );
    var server = document.getElementById( server_id );
    var filename = document.getElementById( filename_id );

    if (operations == null) return false;
    if (state == null) return false;
    if (server == null) return false;
    if (filename == null) return false;

    var operation = operations.options[operations.selectedIndex].value;

    switch (operation) {
    case 'load':
	state.disabled = true;
	break;

    case 'save':
	state.disabled = false;
	break;

    default:
	break;
    }

    var selectedOption = null;

    if (selectedOption) {
	selectedOption.selected = true;
    }
}

function stickyLBSelectCB( sticky_id, mode_id, cookie_id )
{
    var sticky = document.getElementById( sticky_id );
    var mode = document.getElementById( mode_id );
    var cookie = document.getElementById( cookie_id );

    if (sticky == null) return false;
    if (mode == null) return false;
    if (cookie == null) return false;

    if (sticky.checked == true) {
	mode.disabled = false;
	cookie.disabled = false;
    }
    else {
	mode.disabled = true;
	cookie.disabled = true;
    }

}

function customWAFActionSelectCB( operation_id, protocol_id, server_id, filename_id, new_state_id )
{
    var operations = document.getElementById( operation_id );
    var protocol = document.getElementById( protocol_id );
    var server = document.getElementById( server_id );
    var filename = document.getElementById( filename_id );
    var newState = document.getElementById( new_state_id );

    if (operations == null) return false;
    if (protocol == null) return false;
    if (server == null) return false;
    if (filename == null) return false;
    if (newState == null) return false;

    var operation = operations.options[operations.selectedIndex].value;

    switch (operation) {
    case 'clear':
	protocol.disabled = true;
	server.disabled = true;
	filename.disabled = true;
	newState.disabled = true;
	break;

    case 'load':
	protocol.disabled = false;
	server.disabled = false;
	filename.disabled = false;
	newState.disabled = true;
	break;

    default:
	protocol.disabled = false;
	server.disabled = false;
	filename.disabled = false;
	newState.disabled = false;
	break;
    }
}

function firewallSelectCB( action_id, protocol_id, dst_ports_id, src_nat_ip_id, dst_nat_ip_id, dst_pat_port_id )
{
    var action = document.getElementById( action_id );
    var protocol = document.getElementById( protocol_id );
    var dst_ports = document.getElementById( dst_ports_id );
    var src_nat_ip = document.getElementById( src_nat_ip_id );
    var dst_nat_ip = document.getElementById( dst_nat_ip_id );
    var dst_pat_port = document.getElementById( dst_pat_port_id );

    if (action == null) return false;
    if (protocol == null) return false;
    if (dst_ports == null) return false;
    if (src_nat_ip == null) return false;
    if (dst_nat_ip == null) return false;
    if (dst_pat_port == null) return false;

    var actionValue = action.options[action.selectedIndex].value;
    var protocolValue = protocol.options[protocol.selectedIndex].value;

    switch (actionValue) {
    case 'allow':
	enableInput( src_nat_ip );
	enableInput( dst_nat_ip );
 
	switch (protocolValue) {
	case 'tcp':
	case 'udp':
	case 'ftp_active':
	case 'ftp_passive':
	case 'ftp_trivial':
	case 'sip':
	    enableInput( dst_ports );
	    enableInput( dst_pat_port );
	    break;
	    
	default:
	    disableInput( dst_ports );
	    disableInput( dst_pat_port );
	    break;
	}

	break;

    case 'deny':
	disableInput( src_nat_ip );
	disableInput( dst_nat_ip );
	disableInput( dst_pat_port );

	switch (protocolValue) {
	case 'tcp':
	case 'udp':
	case 'ftp_active':
	case 'ftp_passive':
	case 'ftp_trivial':
	case 'sip':
	    enableInput( dst_ports );
	    break;
	    
	default:
	    disableInput( dst_ports );
	    break;
	}

	break;

    default:
	break;
    }
}

function authenticateKerberosADSelectCB( modes_id, rdn_id, login_id, password1_id, password2_id )
{
    var modes = document.getElementById( modes_id );
    var rdn = document.getElementById( rdn_id );
    var login = document.getElementById( login_id );
    var password1 = document.getElementById( password1_id );
    var password2 = document.getElementById( password2_id );

    if (modes == null) return false;
    if (rdn == null) return false;
    if (login == null) return false;
    if (password1 == null) return false;
    if (password2 == null) return false;

    var mode = modes.options[modes.selectedIndex].value;

    switch (mode) {
    case 'off':
	rdn.disabled = true;
	login.disabled = true;
	password1.disabled = true;
	password2.disabled = true;
	break;

    case 'on':
	rdn.disabled = false;
	login.disabled = false;
	password1.disabled = false;
	password2.disabled = false;
	break;

    default:
	break;
    }
}

function ipExternalModeCB( modes_id, ip_id, mk_id, pppoe_service_name_id, pppoe_username_id, pppoe_password_id )
{
    var modes = document.getElementById( modes_id );
    var ip = document.getElementById( ip_id );
    var mk = document.getElementById( mk_id );
    var pppoe_service_name = document.getElementById( pppoe_service_name_id );
    var pppoe_username = document.getElementById( pppoe_username_id );
    var pppoe_password = document.getElementById( pppoe_password_id );

    if (modes == null) return false;
    if (ip == null) return false;
    if (mk == null) return false;
    if (pppoe_service_name == null) return false;
    if (pppoe_username == null) return false;
    if (pppoe_password == null) return false;

    var mode = modes.options[modes.selectedIndex].value;

    switch (mode) {
    case 'static':
	ip.disabled = false;
	mk.disabled = false;
	pppoe_service_name.disabled = true;
	pppoe_username.disabled = true;
	pppoe_password.disabled = true;
	ip.focus( );
	ip.setSelectionRange( ip.value.length, ip.value.length );
	break;

    case 'dhcp':
	ip.disabled = true;
	mk.disabled = true;
	pppoe_service_name.disabled = true;
	pppoe_username.disabled = true;
	pppoe_password.disabled = true;
	break;

    case 'pppoe':
	ip.disabled = true;
	mk.disabled = true;
	pppoe_service_name.disabled = false;
	pppoe_username.disabled = false;
	pppoe_password.disabled = false;
	pppoe_username.focus( );
	pppoe_username.setSelectionRange( pppoe_username.value.length, pppoe_username.value.length );
	break;

    default:
	break;
    }
}

function firewallSelectProtocolCB( protocol_id, dst_ports_id, dst_pat_port_id)
{
    var protocol = document.getElementById( protocol_id );
    var dst_ports = document.getElementById( dst_ports_id );
    var dst_pat_port = document.getElementById( dst_pat_port_id );

    if (dst_pat_port == null) return false;

    switch (protocolValue) {
    case 'tcp':
    case 'udp':
    case 'ftp_active':
    case 'ftp_passive':
    case 'ftp_trivial':
    case 'sip':
	enableInput( dst_ports );
	enableInput( dst_pat_port );
	break;

    default:
	disableInput( dst_ports );
	disableInput( dst_pat_port );
	break;
    }
}

function snmpTrapSelectVersionCB( version_id, user_id, hash_id, enc_id, privacy_id )
{
    var version = document.getElementById( version_id );
    var user = document.getElementById( user_id );
    var hash = document.getElementById( hash_id  );
    var enc = document.getElementById( enc_id );
    var privacy = document.getElementById( privacy_id );

    if (version == null) return false;
    if (user == null) return false;
    if (hash == null) return false;
    if (enc == null) return false;
    if (privacy == null) return false;

    var versionValue = version.options[version.selectedIndex].value;

    switch (versionValue) {
    case 'v3':
	enableInput( user );
	enableInput( hash );
	enableInput( enc );
	enableInput( privacy );
	break;
	
    default:
	disableInput( user );
	disableInput( hash );
	disableInput( enc );
	disableInput( privacy );
	break;
    }
}

function VPNIPsecAuthenticateSelectCB( method_id, auto_psk_id, psk_id, tls_id_id, used_id_id )
{
    var method = document.getElementById( method_id );
    var auto_psk = document.getElementById( auto_psk_id );
    var psk = document.getElementById( psk_id );
    var tls_id = document.getElementById( tls_id_id );
    var used_id = document.getElementById( used_id_id );

    if ( method == null) return false;
    if ( auto_psk == null) return false;
    if ( psk == null) return false;
    if ( tls_id == null) return false;
    if ( used_id == null) return false;

    var methodValue = method.options[method.selectedIndex].value;

    switch (methodValue) {
    case 'psk':
	enableInput( auto_psk );
	var autoPSKValue = auto_psk.options[auto_psk.selectedIndex].value;

	switch (autoPSKValue) {
	case 'yes':
	    disableInput( psk );
	    break;

	default:
	    enableInput( psk );
	    break;
	}

	disableInput( tls_id )
	disableInput( used_id )
	break;

    default:
	disableInput( psk )
	disableInput( auto_psk )
	enableInput ( tls_id );
	enableInput ( used_id );
	break;
    }
}

function adminSNMPCertificateSelectCB( operation_id, protocol_id, server_id, filename_id )
{
    var operations = document.getElementById( operation_id );
    var protocol = document.getElementById( protocol_id );
    var server = document.getElementById( server_id );
    var filename = document.getElementById( filename_id );

    if (operations == null) return false;
    if (protocol == null) return false;
    if (server == null) return false;
    if (filename == null) return false;

    var operation = operations.options[operations.selectedIndex].value;

    switch (operation) {
    case 'raz':
	protocol.disabled = true;
	server.disabled = true;
	filename.disabled = true;
	break;

    default:
	protocol.disabled = false;
	server.disabled = false;
	filename.disabled = false;
	break;
    }
}

function VPNIPsecSiteCB( authenticate_id, tls_authenticate_id, tls_id_id, psk_dn_fqdn_id )
{
    var authenticate = document.getElementById( authenticate_id );
    var tls_authenticate = document.getElementById( tls_authenticate_id );
    var tls_id = document.getElementById( tls_id_id );
    var psk_dn_fqdn = document.getElementById( psk_dn_fqdn_id );

    if ( authenticate == null) return false;
    if ( tls_authenticate == null) return false;
    if ( tls_id == null) return false;
    if ( psk_dn_fqdn == null) return false;

    var authenticateValue = authenticate.options[authenticate.selectedIndex].value;

    switch (authenticateValue) {
    case 'psk':

	enableInput( psk_dn_fqdn );
	disableInput( tls_authenticate );
	disableInput( tls_id );
	break;

    case 'tls':

	enableInput( tls_authenticate );

	var TLSauthenticateValue = tls_authenticate.options[tls_authenticate.selectedIndex].value;

	switch (TLSauthenticateValue) {
	case 'certificate':
	    enableInput( tls_id );
	    disableInput( psk_dn_fqdn );
	    break;

	case 'dn':
	case 'fqdn':
	    enableInput( psk_dn_fqdn );
	    disableInput( tls_id );
	    break;

	default:
	    disableInput( psk_dn_fqdn );
	    disableInput( tls_id );
	    break;
	}
	break

    default:
	break;
    }
}

function VPNIPsecSiteSettingsCB( authenticate_id, tls_authenticate_id, tls_id_id, dn_fqdn_id, psk_id )
{
    var authenticate = document.getElementById( authenticate_id );
    var tls_authenticate = document.getElementById( tls_authenticate_id );
    var tls_id = document.getElementById( tls_id_id );
    var dn_fqdn = document.getElementById( dn_fqdn_id );
    var psk = document.getElementById( psk_id );

    if ( authenticate == null) return false;
    if ( tls_authenticate == null) return false;
    if ( tls_id == null) return false;
    if ( dn_fqdn == null) return false;
    if ( psk == null) return false;

    var authenticateValue = authenticate.options[authenticate.selectedIndex].value;

    switch (authenticateValue) {
    case 'psk':
	enableInput( psk );
	disableInput( tls_authenticate );
	disableInput( tls_id );
	disableInput( dn_fqdn );
	break;

    case 'tls':
	disableInput( psk );
	enableInput( tls_authenticate );

	var TLSauthenticateValue = tls_authenticate.options[tls_authenticate.selectedIndex].value;

	switch (TLSauthenticateValue) {
	case 'certificate':
	    enableInput( tls_id );
	    disableInput( dn_fqdn );
	    break;

	case 'dn':
	case 'fqdn':
	    enableInput( dn_fqdn );
	    disableInput( tls_id );
	    break;

	default:
	    disableInput( tls_id );
	    disableInput( dn_fqdn );
	    break;
	}
	break

    default:
	break;
    }
}

function dynamicDNSSelectCB( state_id, provider_id, hostname_id, username_id, password_id, provider_website_id )
{
    var states = document.getElementById( state_id );
    var providers = document.getElementById( provider_id );
    var hostname = document.getElementById( hostname_id  );
    var username = document.getElementById( username_id  );
    var password = document.getElementById( password_id  );
    var provider_website = document.getElementById( provider_website_id  );

    if (states == null) return false;
    if (providers == null) return false;
    if (hostname == null) return false;
    if (username == null) return false;
    if (password == null) return false;
    if (provider_website == null) return false;

    var state = states.options[states.selectedIndex].value;

    switch (state) {
    case 'off':
	disableInput( providers );
	disableInput( hostname );
	disableInput( username );
	disableInput( password );
	disableInput( provider_website );
	break;

    case 'on':
	var website;
	var selected_provider = providers.options[providers.selectedIndex].value;

	enableInput( providers );
	enableInput( hostname );

	switch (selected_provider) {

	case 'changeip':
	    website = "www.changeip.com";
	    enableInput( username );
	    enableInput( password );
	    enableInput( provider_website );
	    break;

	case 'dnshome':
	    website = "www.dnshome.de";
	    disableInput( username );
	    enableInput( password );
	    enableInput( provider_website );
	    break;

	case 'freemyip':
	    website = "freemyip.com";
	    disableInput( username );
	    enableInput( password );
	    enableInput( provider_website );
	    break;

	case 'myonlineportal':
	    website = "myonlineportal.net";
	    enableInput( username );
	    enableInput( password );
	    enableInput( provider_website );
	    break;

	case 'noip':
	    website = "www.noip.com";
	    enableInput( username );
	    enableInput( password );
	    enableInput( provider_website );
	    break;

	default:
	    return false;
	    break;
	}
	break;

    default:
	return false;
	break;
    }

    var website_link = "<a href='https://" + website + "' target='_blank'> https://" + website + "</a>";
    document.getElementById( provider_website_id ).innerHTML = website_link;
}

function setImageSrcDelay( elem, src, msg, delay )
{
    window.setTimeout(
		      function( ) {
			  elem.setAttribute( "src", src );
			  elem.setAttribute( "alt", msg );
			  elem.setAttribute( "title", msg );
		      },
		      delay );
}

function setGUICookie( name, value, expire )
{
    var date = new Date( );
    date.setDate( date.getDate( ) + expire );
    
    date = date.toUTCString( );

    var cookie = name + "=" + value + "; Expires=" + date + "; Path=/; Secure; SameSite=Strict";
    document.cookie = cookie;
}

function getCookieValue( name )
{
    var cookies = document.cookie.split(';'),
        length = cookies.length,
        cookie,
        name = name + '=';

    for (var i = 0; i < length; i++) {
        cookie = cookies[i];
        while (cookie.charAt(0) == ' ') {
            cookie = cookie.substring( 1, cookie.length );
        }
        if (cookie.indexOf( name ) == 0) {
            return cookie.substring(name.length, cookie.length);
        }
    }
    return null;
}

function initTopMenu( section_id, control_id )
{
    var jq_section_id = "#" + section_id;
    var jq_control_id = "#" + control_id;

    $(jq_control_id).on( 'click', function(e)
    {
        e.preventDefault( );

        var delay = 400;
        var status;

        if ($(jq_section_id).is( ':visible' )) {
            status = 0;
        }
        else {
            status = 1;
        }

        $(jq_section_id).stop( ).slideToggle( delay );

        window.setTimeout(function( )
        {
            $( jq_control_id ).toggleClass( "up", status != 0 ).toggleClass( "down", status == 0 );

            setGUICookie( GUI_COOKIE_TOP_MENU_NAME + GUI_MODULE_NAME, status, 31 );
        }, delay);
    });
}

function showHideTopMenu( section, control, status )
{
    section = "#" + section;
    control = "#" + control;

    if (status == 0) {
        $(section).hide();
        $(control).removeClass("up").addClass("down");
    }
    else {
        $(section).show();
        $(control).removeClass("down").addClass("up");
    }
}

function initLeftMenu( section_id, arrow_id )
{
    var jq_section_id = "#" + section_id;
    var jq_arrow_id = "#" + arrow_id;

    $( jq_arrow_id ).on( 'click', function( e )
    {
        e.preventDefault( );

        var delay = 400;
        var status;

        if ($( jq_section_id ).is( ':visible' )) {
            status = 0;
        }
        else {
            status = 1;
        }

        $( jq_section_id ).stop( ).toggle( delay );

        window.setTimeout( function( )
        {
            $( jq_arrow_id ).toggleClass("left", status != 0).toggleClass("right", status == 0);
            setGUICookie( GUI_COOKIE_LEFT_MENU_NAME + GUI_MODULE_NAME, status, 31 );

        }, delay);
    });
}

function showHideLeftMenu( section, control, status )
{
    section = "#" + section;
    control = "#" + control;

    if (status == 0) {
        $(section).hide();
        $(control)
            .removeClass("left")
            .addClass("right");
    }
    else {
        $(section).show();
        $(control)
            .removeClass("right")
            .addClass("left");
    }
}

function updateTLSInfo( names_id, names, numbits_id, numbits, days_id, days, country_id, country, province_id, province, locality_id, locality, organisation_id, organisation, unit_id, unit )
{
    document.getElementById( names_id ).value = names;
    document.getElementById( numbits_id ).value = numbits;
    document.getElementById( days_id ).value = days; 
    if (country != "") {
	document.getElementById( country_id ).value = country;
    }
    document.getElementById( province_id ).value = province;
    document.getElementById( locality_id ).value = locality;
    document.getElementById( organisation_id ).value = organisation;
    document.getElementById( unit_id ).value = unit;
}

function AJAX_updateTLSConfCB( names_id, numbits_id, days_id, country_id, province_id, locality_id, organisation_id, unit_id )
{
    switch (AJAX_HTTP_REQUEST.readyState) {
    case AJAX_UNSENT:
	break;

    case AJAX_OPENED:
	break;

    case AJAX_HEADERS_RECEIVED:
	break;

    case AJAX_LOADING:
	break;

    case AJAX_DONE:
	if (AJAX_HTTP_REQUEST.status == 200) {

	    var response = AJAX_HTTP_REQUEST.responseText.split( "|", 8 );
	    var names = response[0];
	    var numbits = response[1];
	    var days = response[2];
	    var country = response[3];
	    var province = response[4];
	    var locality = response[5];
	    var organisation = response[6];
	    var unit = response[7];

	    updateTLSInfo( names_id, names, numbits_id, numbits, days_id, days, country_id, country, province_id, province, locality_id, locality, organisation_id, organisation, unit_id, unit );
	}
	break;

    default:
	break;
    }
}

function AJAX_updateTLSConf( page, names_id, numbits_id, days_id, country_id, province_id, locality_id, organisation_id, unit_id )
{
    resetAJAX_HTTP_REQUEST( );
    AJAX_HTTP_REQUEST.open( "GET", page, true );
    AJAX_HTTP_REQUEST.onreadystatechange = function( ) { AJAX_updateTLSConfCB(  names_id, numbits_id, days_id, country_id, province_id, locality_id, organisation_id, unit_id ); };
    AJAX_HTTP_REQUEST.send( null );
}

function downloadFile( page, file_name )
{
    window.open( GUI_DIR + page + GUI_EXTENSION + '?' + file_name, '_blank' );
}

function getLatestVersion( page, div_id )
{
    setWorkingIconBar( div_id );
    ajaxpage( page, div_id );
}

function copyToClipboard( textarea_id, icon_id, text )
{
    var icon = document.getElementById( icon_id );
    if ( icon == null) return false;

    var ok_icon_path = GUI_IMAGE_DIR + "ok.png";
    var copy_icon_path = GUI_IMAGE_DIR + "clipboard-copy.png";

    var textarea_id = 'clipboard-text-area';

    var textarea = document.getElementById( textarea_id );

    if (textarea == null) {
	textarea = document.createElement( 'textarea' );
	textarea.setAttribute( 'id', textarea_id );
	document.body.append( textarea );
    }

    icon.src = ok_icon_path;

    setTimeout( function( ) {
	icon.src = copy_icon_path;
    }, 350 );

    textarea.textContent = text;

    textarea.classList.remove( 'item-ivisible' );
    textarea.classList.add( 'item-visible' );

    textarea.select( );
    document.execCommand( 'copy' );

    textarea.classList.remove( 'item-visible' );
    textarea.classList.add( 'item-ivisible' );
}

function copyPreToClipboard( pre_id, icon_id )
{
    var pre = document.getElementById( pre_id );
    var icon = document.getElementById( icon_id );

    if ( pre == null) return false;
    if ( icon == null) return false;

    var ok_icon_path = GUI_IMAGE_DIR + "ok.png";
    var copy_icon_path = GUI_IMAGE_DIR + "clipboard-copy.png";

    var text = pre.textContent;
    var textarea_id = pre_id + '-temporary';
    var textarea = document.getElementById( textarea_id );

    if (textarea == null) {
	textarea = document.createElement( 'textarea' );
	textarea.setAttribute( 'id', textarea_id );
	document.body.append( textarea );
    }

    icon.src = ok_icon_path;

    setTimeout( function( ) {
	icon.src = copy_icon_path;
    }, 350 );

    textarea.textContent = text;

    textarea.classList.remove( 'item-ivisible' );
    textarea.classList.add( 'item-visible' );

    textarea.select( );
    document.execCommand( 'copy' );

    textarea.classList.remove( 'item-visible' );
    textarea.classList.add( 'item-ivisible' );
}

function sendPhoneNumber( system, phone_id, message )
{
    var phone = document.getElementById( phone_id );
    if ( phone == null) return false;

    phone = phone.value;
    phone = phone.replace( /\s/g, '' );
    phone = phone.replace( /^00/, '' );
    phone = phone.replace( /[+-]/g, '' );

    switch (system) {
    case 'whatsapp':
	var url = "https://wa.me/" + phone + "?text=" + message;
	break;

    case 'telegram':
	var url = '';
	break;

    case 'signal':
	var url = '';
	break;

    default:
	var url = '';
	break;
    }

    window.open( url, '_blank' );
}

function startClock( clock_id, utcSeconds, offsetMinutes ) {
    const clock = document.getElementById( clock_id );

    if (!clock) {
        return false;
    }

    let current = new Date( (utcSeconds + offsetMinutes * 60) * 1000 );

    function pad( n ) {
        return n.toString( ).padStart( 2, '0' );
    }

     function update( ) {
        clock.textContent =
            current.getUTCFullYear( ) + '/' +
            pad( current.getUTCMonth( ) + 1) + '/' +
            pad( current.getUTCDate( )) + '-' +
            pad( current.getUTCHours( )) + ':' +
            pad( current.getUTCMinutes( )) + ':' +
            pad( current.getUTCSeconds( ));

        current.setUTCSeconds(current.getUTCSeconds() + 1);
    }

    update();
    setInterval( update, 1000 );

    return true;
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
