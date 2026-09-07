/***********************************************
* Cool DHTML tooltip script II- © Dynamic Drive DHTML code library (www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit Dynamic Drive at http://www.dynamicdrive.com/ for full source code
***********************************************/

var offsetfromcursorX = 12 //Customize x offset of tooltip
var offsetfromcursorY = 10 //Customize y offset of tooltip

var offsetdivfrompointerX = 10 //Customize x offset of tooltip DIV relative to pointer image
var offsetdivfrompointerY = 14 //Customize y offset of tooltip DIV relative to pointer image. Tip: Set it to (height_of_pointer_image-1).

var enabletip = false
var tipobj = null;
var pointerobj = null;

function ddrivetip(thetext)
{
    if (!tipobj)
        return false;

    tipobj.innerHTML = thetext;
    enabletip = true;

    return false;
}

function positiontip(e)
{
    if (enabletip){
	var nondefaultpos = false
	const curX = e.pageX;
	const curY = e.pageY;
	const leftedge = -1000;

	var winwidth = window.innerWidth;
	var winheight = window.innerHeight;

	var rightedge = winwidth - e.clientX - offsetfromcursorX;
	var bottomedge = winheight - e.clientY - offsetfromcursorY;

	//if the horizontal distance isn't enough to accomodate the width of the context menu
	if (rightedge < tipobj.offsetWidth) {
	    tipobj.style.left = (curX - tipobj.offsetWidth) + "px";
	    nondefaultpos = true;
	}
	else if (curX<leftedge)
	    tipobj.style.left = "5px";
	else {
	    //position the horizontal position of the menu where the mouse is positioned
	    tipobj.style.left = curX+offsetfromcursorX-offsetdivfrompointerX+"px"
	    pointerobj.style.left = curX+offsetfromcursorX+"px"
	}

	//same concept with the vertical position
	if (bottomedge<tipobj.offsetHeight){
	    tipobj.style.top = curY-tipobj.offsetHeight-offsetfromcursorY+"px"
	    nondefaultpos = true
	}
	else{
	    tipobj.style.top = curY+offsetfromcursorY+offsetdivfrompointerY+"px"
	    pointerobj.style.top = curY+offsetfromcursorY+"px"
	}
	tipobj.style.visibility = "visible"
	if (!nondefaultpos)
	    pointerobj.style.visibility = "visible"
	else
	    pointerobj.style.visibility = "hidden"
    }
}

function hideddrivetip()
{
    enabletip = false
    tipobj.style.visibility = "hidden"
    pointerobj.style.visibility = "hidden"
}

document.addEventListener("DOMContentLoaded", function () {
    const tooltip = document.createElement("div");
    tooltip.id = "dhtmltooltip";
    document.body.appendChild(tooltip);

    const pointer = document.createElement("img");
    pointer.id = "dhtmlpointer";
    pointer.alt = '';
    pointer.decoding = "async";
    pointer.src = "/image/tip_arrow.gif";
    document.body.appendChild(pointer);

    tipobj = tooltip;
    pointerobj = pointer;

    tipobj.style.visibility = "hidden";
    pointerobj.style.visibility = "hidden";
} );

document.addEventListener("mousemove", positiontip);
