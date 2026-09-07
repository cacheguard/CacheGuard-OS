/*
###########################################################################
#
# MODULE:       Documentation
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

document.addEventListener( "DOMContentLoaded", ( ) => {

    const tree = document.getElementById( "uguide" );
    if (!tree) return false;

    const STORAGE_KEY = "cacheguard-doc-tree";

    //------------------------------------------------------------
    // Restore saved state
    //------------------------------------------------------------

    let openFolders = [];

    try {
        openFolders = JSON.parse( localStorage.getItem( STORAGE_KEY )) || [];
    } catch ( e ) {
        openFolders = [];
    }

    //------------------------------------------------------------
    // Initialise folders
    //------------------------------------------------------------

    tree.querySelectorAll( "li" ).forEach(( li, index ) => {

        const subTree = li.querySelector( ":scope > ul" );
        const folder = li.querySelector( ":scope > .folder" );

        if (!subTree || !folder)
            return false;

	li.classList.add( "folder-node" );

        li.dataset.id = index;

        if (openFolders.includes( index ))
            li.classList.add( "open" );

        folder.addEventListener( "click", () => {

            li.classList.toggle( "open" );

            saveState( );
        });

    });

    //------------------------------------------------------------
    // Highlight current page
    //------------------------------------------------------------

    const current = location.pathname.split("/").pop() + location.hash;

    tree.querySelectorAll( "a" ).forEach(link => {

        const href = link.getAttribute( "href" );

        if (href === current) {

            link.classList.add( "current" );

            let parent = link.closest( "li" );

            while (parent) {
                parent.classList.add( "open" );

                parent = parent.parentElement.closest( "li" );
            }
        }
    });

    saveState();

    //------------------------------------------------------------

    function saveState( ) {

        const state = [];

        tree.querySelectorAll( "li.open" ).forEach(li => {

            if (li.dataset.id)
                state.push(Number( li.dataset.id ));

        });

        localStorage.setItem(
            STORAGE_KEY,
            JSON.stringify( state )
        );
    }

});
