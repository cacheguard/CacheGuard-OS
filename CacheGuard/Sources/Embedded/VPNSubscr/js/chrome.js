//** Chrome Drop Down Menu- Author: Dynamic Drive (http://www.dynamicdrive.com)

//** Updated: July 14th 06' to v2.0
	//1) Ability to "left", "center", or "right" align the menu items easily, just by modifying the CSS property "text-align".
	//2) Added an optional "swipe down" transitional effect for revealing the drop down menus.
	//3) Support for multiple Chrome menus on the same page.

//** Updated: Nov 14th 06' to v2.01- added iframe shim technique

//** Updated: July 23rd, 08 to v2.4
	//1) Main menu items now remain "selected" (CSS class "selected" applied) when user moves mouse into corresponding drop down menu. 
	//2) Adds ability to specify arbitrary HTML that gets added to the end of each menu item that carries a drop down menu (ie: a down arrow image).
	//3) All event handlers added to the menu are now unobstrusive, allowing you to define your own "onmouseover" or "onclick" events on the menu items.
	//4) Fixed elusive JS error in FF that sometimes occurs when mouse quickly moves between main menu items and drop down menus

//** Updated: Oct 29th, 08 to v2.5 (only .js file modified from v2.4)
	//1) Added ability to customize reveal animation speed (# of steps)
	//2) Menu now works in IE8 beta2 (a valid doctype at the top of the page is required)

//Version 2.6: Auguts 17th, 20226
//** Modifications made by CacheGuard Technologies SAS (FR): the menu has been updated to comply with Content Security Policy (CSP) requirements. Dynamic JavaScript evaluation and document-based HTML injection have been removed.

var cssdropdown = {
    disappeardelay: 250,
    dropdownindicator: "/image/down.gif",
    enablereveal: [true, 5],
    enableiframeshim: 1,
    dropmenuobj: null,
    asscmenuitem: null,
    domsupport: !!document.getElementById,
    standardbody: null,
    iframeshimadded: false,
    revealtimers: {},
    delayhide: null,
    shimobject: null,

    getposOffset: function( what, offsettype ) {
        var totaloffset = offsettype === "left" ? what.offsetLeft : what.offsetTop;
        var parentEl = what.offsetParent;

        while ( parentEl !== null ) {
            totaloffset += offsettype === "left" ? parentEl.offsetLeft : parentEl.offsetTop;
            parentEl = parentEl.offsetParent;
        }

        return totaloffset;
    },

    css: function( el, targetclass, action ) {
        if ( !el )
            return;

        var needle = new RegExp( "(^|\\s+)" + targetclass + "($|\\s+)", "ig" );

        if ( action === "check" )
            return needle.test( el.className );

        if ( action === "remove" ) {
            el.className = el.className.replace( needle, " " ).trim( );
            return;
        }

        if ( action === "add" && !needle.test( el.className ) )
            el.className = ( el.className + " " + targetclass ).trim( );
    },

    showmenu: function( dropmenu ) {
        if ( !dropmenu )
            return;

        if ( this.enablereveal[0] ) {
            if ( !dropmenu._trueheight || dropmenu._trueheight < 10 )
                dropmenu._trueheight = dropmenu.offsetHeight;

            clearInterval( this.revealtimers[dropmenu.id] );

            dropmenu.style.height = "0px";
            dropmenu._curheight = 0;
            dropmenu.style.overflow = "hidden";
            dropmenu.style.visibility = "visible";

            var self = this;

            this.revealtimers[dropmenu.id] = setInterval( function( ) {
                self.revealmenu( dropmenu );
            }, 10 );
        }
        else {
            dropmenu.style.visibility = "visible";
        }

        this.css( this.asscmenuitem, "selected", "add" );
    },

    revealmenu: function( dropmenu ) {
        var curH = dropmenu._curheight;
        var maxH = dropmenu._trueheight;
        var steps = this.enablereveal[1];

        if ( curH < maxH ) {
            var newH = Math.min( curH, maxH );

            dropmenu.style.height = newH + "px";
            dropmenu._curheight = newH + Math.round( ( maxH - newH ) / steps ) + 1;
        }
        else {
            dropmenu.style.height = "auto";
            dropmenu.style.overflow = "hidden";
            clearInterval( this.revealtimers[dropmenu.id] );
        }
    },

    clearbrowseredge: function( obj, whichedge ) {
        var edgeoffset = 0;

        if ( whichedge === "rightedge" ) {
            var windowedge = this.standardbody.scrollLeft + this.standardbody.clientWidth - 15;
            var dropmenuW = this.dropmenuobj.offsetWidth;

            if ( windowedge - this.dropmenuobj.x < dropmenuW )
                edgeoffset = dropmenuW - obj.offsetWidth;
        }
        else {
            var topedge = window.pageYOffset;
            var windowedge = window.pageYOffset + window.innerHeight - 18;
            var dropmenuH = this.dropmenuobj._trueheight;

            if ( windowedge - this.dropmenuobj.y < dropmenuH ) {
                edgeoffset = dropmenuH + obj.offsetHeight;

                if ( this.dropmenuobj.y - topedge < dropmenuH )
                    edgeoffset = this.dropmenuobj.y + obj.offsetHeight - topedge;
            }
        }

        return edgeoffset;
    },

    dropit: function( obj, e, dropmenuID ) {
        if ( this.dropmenuobj !== null )
            this.hidemenu( );

        this.clearhidemenu( );

        this.dropmenuobj = document.getElementById( dropmenuID );
        this.asscmenuitem = obj;

        if ( !this.dropmenuobj )
            return;

        this.dropmenuobj.x = this.getposOffset( obj, "left" );
        this.dropmenuobj.y = this.getposOffset( obj, "top" );

        this.showmenu( this.dropmenuobj );

        this.dropmenuobj.style.left = this.dropmenuobj.x - this.clearbrowseredge( obj, "rightedge" ) + "px";
        this.dropmenuobj.style.top = this.dropmenuobj.y - this.clearbrowseredge( obj, "bottomedge" ) + obj.offsetHeight + 1 + "px";

        this.positionshim( );
    },

    positionshim: function( ) {
        if ( !this.iframeshimadded || !this.dropmenuobj )
            return;

        if ( this.dropmenuobj.style.visibility === "visible" ) {
            this.shimobject.style.width = this.dropmenuobj.offsetWidth + "px";
            this.shimobject.style.height = this.dropmenuobj._trueheight + "px";
            this.shimobject.style.left = parseInt( this.dropmenuobj.style.left, 10 ) + "px";
            this.shimobject.style.top = parseInt( this.dropmenuobj.style.top, 10 ) + "px";
            this.shimobject.style.display = "block";
        }
    },

    hideshim: function( ) {
        if ( this.iframeshimadded )
            this.shimobject.style.display = "none";
    },

    isContained: function( m, e ) {
        if ( !e )
            return false;

        var c = e.relatedTarget;

        while ( c && c !== m ) {
            c = c.parentNode;
        }

        return c === m;
    },

    dynamichide: function( m, e ) {
        if ( !this.isContained( m, e ) )
            this.delayhidemenu( );
    },

    delayhidemenu: function( ) {
        var self = this;

        if ( this.delayhide )
            clearTimeout( this.delayhide );

        this.delayhide = setTimeout( function( ) {
            self.hidemenu( );
        }, this.disappeardelay );
    },

    hidemenu: function( ) {
        if ( this.asscmenuitem )
            this.css( this.asscmenuitem, "selected", "remove" );

        if ( this.dropmenuobj ) {
            this.dropmenuobj.style.visibility = "hidden";
            this.dropmenuobj.style.left = "-1000px";
            this.dropmenuobj.style.top = "-1000px";
        }

        this.hideshim( );
        this.dropmenuobj = null;
        this.asscmenuitem = null;
    },

    clearhidemenu: function( ) {
        if ( this.delayhide ) {
            clearTimeout( this.delayhide );
            this.delayhide = null;
        }
    },

    addEvent: function( target, functionref, tasktype ) {
        if ( !target )
            return;

        target.addEventListener( tasktype, functionref, false );
    },

    addDropdownIndicator: function( menuitem ) {
        var img = document.createElement( "img" );

        img.src = this.dropdownindicator;
        img.alt = "";
        img.setAttribute( "aria-hidden", "true" );

        menuitem.appendChild( document.createTextNode( " " ) );
        menuitem.appendChild( img );
    },

    startchrome: function( ) {
        if ( !this.domsupport )
            return;

        this.standardbody = document.compatMode === "CSS1Compat" ? document.documentElement : document.body;

        var self = this;

        for ( var ids = 0; ids < arguments.length; ids++ ) {
            var menu = document.getElementById( arguments[ids] );

            if ( !menu )
                continue;

            var menuitems = menu.getElementsByTagName( "a" );

            for ( var i = 0; i < menuitems.length; i++ ) {
                var menuitem = menuitems[i];
                var relvalue = menuitem.getAttribute( "rel" );

                if ( !relvalue )
                    continue;

                var asscdropdownmenu = document.getElementById( relvalue );

                if ( !asscdropdownmenu )
                    continue;

                self.addEvent( asscdropdownmenu, function( ) {
                    self.clearhidemenu( );
                }, "mouseover" );

                self.addEvent( asscdropdownmenu, function( e ) {
                    self.dynamichide( this, e );
                }, "mouseout" );

                self.addEvent( asscdropdownmenu, function( ) {
                    self.delayhidemenu( );
                }, "click" );

                self.addDropdownIndicator( menuitem );

                self.addEvent( menuitem, function( e ) {
                    if ( !self.isContained( this, e ) ) {
                        self.dropit( this, e, this.getAttribute( "rel" ) );
                    }
                }, "mouseover" );

                self.addEvent( menuitem, function( e ) {
                    self.dynamichide( this, e );
                }, "mouseout" );

                self.addEvent( menuitem, function( ) {
                    self.delayhidemenu( );
                }, "click" );
            }
        }

        if ( this.enableiframeshim )
            this.createIframeShim( );
    },

    createIframeShim: function( ) {
        if ( this.iframeshimadded )
            return;

        var iframe = document.createElement( "iframe" );

        iframe.id = "iframeshim";
        iframe.src = "about:blank";
        iframe.frameBorder = "0";
        iframe.scrolling = "no";
        iframe.setAttribute( "aria-hidden", "true" );

        iframe.style.position = "absolute";
        iframe.style.left = "0";
        iframe.style.top = "0";
        iframe.style.display = "none";
        iframe.style.zIndex = "90";
        iframe.style.background = "transparent";
        iframe.style.opacity = "0";

        document.body.appendChild( iframe );

        this.shimobject = iframe;
        this.iframeshimadded = true;
    }
};
