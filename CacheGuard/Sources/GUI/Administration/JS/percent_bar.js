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
# along with this program. If not, see 
<http://www.gnu.org/licenses/>.
#
###########################################################################
*/

function drawPercentBar( zone_id, width, percent )
{
    zone = document.getElementById( zone_id );
    if (!zone) return false;

    var color = 'FireBrick';
    var background = 'SlateGray';
    var pixels = width * (percent / 100);

    var percent_bar = "<div style=\"position: relative; line-height: 15px; background-color: " + background + "; border: 1px solid black; width: " + width + "px\">"
        + "<div style=\"height: 20px; width: " + pixels + "px; background-color:" + color + ";\"></div>"
        + "<div style=\"color:White; position: absolute; text-align: center; padding-top: 3px; width: " + width + "px; top: 0; left: 0\">" + percent + "%</div>"
        + "</div>"

    zone.innerHTML = percent_bar;
}
