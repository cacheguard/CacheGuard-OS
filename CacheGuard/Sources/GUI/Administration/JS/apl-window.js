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
# along with this program. If not, see 
<http://www.gnu.org/licenses/>.
#
###########################################################################
*/

"use strict";

(function( window )
{
    var CSP_WINDOWS = {};
    var CSP_ZINDEX = 1000;
    var CSP_DEFAULT_LEFT = 20;
    var CSP_DEFAULT_TOP = 20;

    function parseArgs( args )
    {
        var result = {};
        if (!args) return result;

        var items = args.split(",");

        for (var i = 0; i < items.length; i++) {
            var pair = items[i].split("=");

            if (pair.length == 2)
                result[pair[0].trim()] = pair[1].trim();
        }

        return result;
    }

    function loadWindow( win, type, source, title, callback )
    {
	if ( title ) {
            var title_obj = win.querySelector( ".csp-window-title" );

            if ( title_obj )
		title_obj.textContent = title;
	}

	if ( type == "inline" ) {
            win.content.innerHTML = source;

            if ( callback )
		callback( win.content, true );

            return true;
	}

	if ( type == "ajax" ) {
            fetch( source, { credentials:"same-origin" } )
		.then( function( response ) {
                    if ( !response.ok )
			throw new Error( "HTTP " + response.status );

                    return response.text( );
		} )
		.then( function( data ) {
                    win.content.innerHTML = data;

                    if ( callback )
			callback( win.content, true );
		} )
		.catch( function( ) {
                    if ( callback )
			callback( win.content, false );
		} );

            return true;
	}

	return false;
    }

    function initializeDrag( win, handle )
    {
        handle.addEventListener(
            "mousedown",
            function( event )
            {
                event.preventDefault( );

                var x = event.clientX - win.offsetLeft;
                var y = event.clientY - win.offsetTop;

                function move( e )
                {
		    win.moveTo(
			e.clientX - x,
			e.clientY - y
		    );
                }

                function stop( )
                {
                    document.removeEventListener( "mousemove", move );
                }

                document.addEventListener( "mousemove", move );
                document.addEventListener( "mouseup", stop, { once:true } );
            }
        );
    }

    function initializeResize( win, handle )
    {
        handle.addEventListener(
            "mousedown",
            function( event )
            {
                event.preventDefault( );

                var width = win.offsetWidth;
                var height = win.offsetHeight;
                var x = event.clientX;
                var y = event.clientY;

                function resize( e )
                {
                    win.style.width = (width + e.clientX - x) + "px";
                    win.style.height = (height + e.clientY - y) + "px";
                }

                function stop( )
                {
                    document.removeEventListener( "mousemove", resize );
                }

                document.addEventListener( "mousemove", resize );
                document.addEventListener( "mouseup", stop, { once:true } );
            }
        );
    }

    function createWindow( id, type, content, title, args )
    {
        var options = parseArgs( args );

        var win = document.createElement( "div" );

        win.id = id;
        win.className = "csp-window";
        win.style.zIndex = ++CSP_ZINDEX;

        if (options.width)
            win.style.width = options.width;

        if (options.height)
            win.style.height = options.height;

	if (options.left !== undefined)
	    win.style.left = options.left;

	if (options.top !== undefined)
	    win.style.top = options.top;

        var titlebar = document.createElement( "div" );
        titlebar.className = "csp-window-titlebar";

        var title_obj = document.createElement( "div" );
        title_obj.className = "csp-window-title";
        title_obj.textContent = title || "";

        var buttons = document.createElement( "div" );
        buttons.className = "csp-window-buttons";

        var close = document.createElement( "button" );
        close.className = "csp-window-button";
	close.innerHTML = "<svg viewBox='0 0 12 12' width='12' height='12' aria-hidden='true'><path d='M2 2L10 10M10 2L2 10' stroke='currentColor' stroke-width='2' stroke-linecap='round' fill='none'/></svg>";

        buttons.appendChild( close );
        titlebar.appendChild( title_obj );
        titlebar.appendChild( buttons );

        var content_obj = document.createElement( "div" );
        content_obj.className = "csp-window-content";

        var resize = document.createElement( "div" );
        resize.className = "csp-window-resize";

        win.appendChild( titlebar );
        win.appendChild( content_obj );
        win.appendChild( resize );

        win.content = content_obj;
        win.onclose = null;

	win.setActive = function( active )
	{
	    if (active)
		win.classList.remove( "csp-window-inactive" );
	    else
		win.classList.add( "csp-window-inactive" );
	};

	win.moveTo = function( left, top )
	{
	    win.style.left = left + "px";
	    win.style.top = top + "px";
	};

        win.load = function( type, source, title, callback )
        {
            return loadWindow( win, type, source, title, callback );
        };

        win.show = function( )
        {
            win.style.display = "flex";
            win.style.zIndex = ++CSP_ZINDEX;
        };

        win.hide = function( )
        {
            win.style.display = "none";
        };

        win.close = function( )
        {
            if (win.onclose) {
                if (win.onclose( ) === false)
                    return false;
            }

            win.remove( );
            delete CSP_WINDOWS[id];

            return true;
        };

        close.addEventListener(
            "click",
            function( )
            {
                win.close( );
            }
        );

	win.addEventListener(
	    "mousedown",
	    function( )
	    {
		for (var id in CSP_WINDOWS)
		    CSP_WINDOWS[id].setActive( false );

		win.setActive( true );
		win.style.zIndex = ++CSP_ZINDEX;
	    }
	);

        initializeDrag( win, titlebar );
        initializeResize( win, resize );

        if (type == "inline")
            content_obj.innerHTML = content;

        CSP_WINDOWS[id] = win;
	win.setActive( false );

        return win;
    }

    window.dhtmlwindow =
	{
	    activate:function( win )
	    {
		for (var id in CSP_WINDOWS)
		    CSP_WINDOWS[id].setActive(false);

		win.setActive(true);
	    },

            open:function( id, type, content, title, args )
            {
		if (CSP_WINDOWS[id]) {
                    CSP_WINDOWS[id].show( );
                    return CSP_WINDOWS[id];
		}

		return createWindow(
                    id,
                    type,
                    content,
                    title,
                    args
		);
            }
	};
})( window );
