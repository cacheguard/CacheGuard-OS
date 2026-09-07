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

function drawPercentBar( zone_id, width, percent )
{
    zone = document.getElementById( zone_id );
    if (!zone) return false;

    var percent_txt = "<span class='meter-label'>" + percent + "%</span>";
    var meter = "<meter min='0' max='100' value='" + percent + "'></meter>";
    var bar = "<div class='meter-wrap'>" + meter + percent_txt + "</div>"

    zone.innerHTML = bar;
}

function drawExchangePercent( progress_id, percentage )
{
    var zone = document.getElementById( progress_id );
    if (!zone) return false;

    drawPercentBar( progress_id, 250, percentage );
}

function refreshExchangePercentError( progress_id )
{
    var zone = document.getElementById( progress_id );
    if (!zone) return false;

    drawExchangePercent( progress_id, 0 );
}

function refreshExchangeFilePercent( selector_id, progress_id, current_percentage, page )
{
    var selector_elt = document.getElementById( selector_id );
    var progress_elt = document.getElementById( progress_id );

    if (!selector_elt) return true;
    if (!progress_elt) return true;

    var selector = selector_elt.value;
    var request_page = page;

    if (selector != "") {
	request_page += "?" + selector;
    }

    var get = $.get( request_page,
		     function ( percentage, status ) {
			 switch (status) {
			 case "success":
			     if (isNaN( percentage )) {
				 refreshExchangePercentError( progress_id );
				 return false;
			     }
			     if (percentage != current_percentage) drawExchangePercent( progress_id, percentage );
			     if (percentage <= 100) {
				 setTimeout( function()
					     {
						 refreshExchangeFilePercent( selector_id, progress_id, percentage, page );
					     }, 1200 );
			     }
			     break;
			 default:
			     refreshExchangePercentError( progress_id );
			     break;
			 }
		     } );
    
    get.fail( function () { refreshExchangePercentError( progress_id ); } );
}

function initRefreshExchangeFilePercent( selector_id, progress_id, initial_percentage, page )
{
    drawExchangePercent( progress_id, initial_percentage );
    refreshExchangeFilePercent( selector_id, progress_id, initial_percentage, page );
}
