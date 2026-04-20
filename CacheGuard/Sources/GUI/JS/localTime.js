/***********************************************
* Local Time script- © Dynamic Drive (http://www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit http://www.dynamicdrive.com/ for this script and 100s more.
* Adapted by  : The CacheGuard Development Team for CacheGuard
***********************************************/

var weekdaystxt = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

function showLocalTime( container, serverTimeSecond, offsetMinutes, displayversion )
{
    if (!document.getElementById || !document.getElementById( container )) return false;
    this.container = document.getElementById( container );
    this.displayversion = displayversion;
    this.localtime = new Date( );
    this.localtimeoffest=this.localtime.getTimezoneOffset( );
    this.localtime.setTime( serverTimeSecond * 1000 );
    this.localtime.setTime( this.localtime.getTime( ) + (offsetMinutes + this.localtimeoffest) * 60 * 1000 ); //add user offset to server time
    this.updateTime( );
    this.updateContainer( );
}

showLocalTime.prototype.updateTime = function( )
{
    var thisobj = this;
    this.localtime.setSeconds( this.localtime.getSeconds( ) + 1 );
    setTimeout( function( ){ thisobj.updateTime( ) }, 1000 ); //update time every second
}

showLocalTime.prototype.updateContainer = function( ) {
    var thisobj = this;
    if ( this.displayversion == "long" )
	this.container.innerHTML = this.localtime.toLocaleString( );
    else {
	var hour = this.localtime.getHours( );
	var minutes = this.localtime.getMinutes( );
	var seconds = this.localtime.getSeconds( );
	var ampm = (hour>=12)? "PM" : "AM";
	var dayofweek = weekdaystxt[this.localtime.getDay( )];
	this.container.innerHTML = formatField( hour, 1 ) + ":" + formatField( minutes ) + ":" + formatField( seconds ) + " " + ampm + " ( " + dayofweek + " )";
    }
    setTimeout( function( ){ thisobj.updateContainer( ) }, 1000 ); //update container every second
}

function formatField( num, isHour )
{
    if (typeof isHour != "undefined")
    { //if this is the hour field
	var hour = (num > 12)? num-12 : num;
	return (hour == 0)? 12 : hour;
    }
    return (num <=9 )? "0"+num : num; //if this is minute or sec field
}
