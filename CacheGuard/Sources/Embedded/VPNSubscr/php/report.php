<?php

/*
###########################################################################
#
# MODULE:       VPN Subscription
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

require "tools.php";

vpnsubscr_check_login( );

function vpnsubscr_display_report( )
{
    echo "<center>\n";
    echo "<table class='box-report'>\n";

    if (!file_exists( LOG_FILE )) {
        echo "<tr><td><font color='SeaGreen'>All requested operations have been successfully performed.</font></td></tr>\n";
    }
    else {
        try {
            $handle = fopen( LOG_FILE, 'r' );
            if (!$handle) {
                throw new Exception( "5" );
            }

            while (($line = fgets( $handle )) !== false) {
                $line = htmlspecialchars( $line );
                echo "<tr><td>$line</td></tr>\n";
            }

            fclose( $handle );
        }
        catch (Exception $e) {
            $message = $e->getMessage( );
            $code = intval( $message );

            switch ($code) {
            case 5:
                break;

            default:
                break;
            }
        }
    }

    echo "</table>\n";
    echo "</center>\n";
}

?>
<!DOCTYPE html>
<html>
  <head>
    <title><?php echo vpnsubscr_get_org_name( ); ?> Operations Report</title>
    
    <link rel="shortcut icon" type="image/x-image" href="/image/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="/chromestyle.css" />
    <link rel="stylesheet" type="text/css" href="/style.css" />

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow, noarchive, noarchive, nosnippet, noodp, noydir" />
    <meta name="description" content="This page dsiplays the latest action report." />

    <script type="text/javascript" src="/js/chrome.js"></script>
    <script type="text/javascript" src="/js/vpnsubscr.js"></script>
    <script type="text/javascript" src="/js/printmenu.js"></script>
    <script type="text/javascript" src="/js/logout.js"></script>
  </head>

  <body>
    <?php vpnsubscr_display_header( ); ?>
    <div class='box-centered-container'>
      <div class='box-centered-nested'>
	<div class='page-title'>Operations Report <a href='report.php'><img src='/image/refresh.png' title='Refresh' alt='Refresh' /></a></div>
	<div class='box-help'>Here you can find a report on the latest requested operation.</div>
	<?php vpnsubscr_display_report( ); ?>
      </div>
    </div>
    <?php vpnsubscr_display_footer( ); ?>
  </body>
</html>
