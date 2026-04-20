<?php

/*
###########################################################################
#
# MODULE:       Scripts
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

define( 'DEBUG_MODE', False );

if (DEBUG_MODE) {
    error_reporting( E_ALL );
    ini_set( "display_errors", 1 );
}
else {
    error_reporting( 0 );
    ini_set( "display_errors", 0 );
}

function main( $argv )
{
    if (count( $argv ) < 2) {
        exit( 11 );
    }

    $json_string = $argv[1];
    $json_array = @json_decode( $json_string, true );

    $ip = $json_array['loadbalancer']['publicIpAddresses'][0]['frontendIpAddress'];

    echo "$ip";
}

main( $argv );

?>
