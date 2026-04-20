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

function vpnsubscr_display_welcome( )
{
    $commercial_name = COMMERCIAL_NAME;
    $welcome_msg = "Welcome to the CacheGuard <strong>$commercial_name</strong> application. This application allows you to easily create and manage VPN accounts for the members of your group.";

    $setup = vpnsubscr_get_setup_data( );
    $errors = $setup[ERRORS];

    if ($errors) {
        foreach ($errors as $message) {
            vpnsubscr_print_error( $message[0], $message[1] );
            exit( 0);
        }
    }

    $data = $setup[DATA];

    switch ($data[SERVICE_STATE]) {
    case SETUP_STATE_INEXISTANT:
        $welcome_msg .= " Please read the <a href='help.html' target='_blank'>Documentation</a> and then proceed with the <a href='setup.php'>First Setup</a> before creating VPN accounts.";
        break;

    default:
        $welcome_msg .= " Please refer to the <a href='help.html' target='_blank'>Documentation</a> to learn how to use this application.";
        break;
    }

    echo "<div class='box-highlight'>$welcome_msg</div>";
}

?>
<!DOCTYPE html>
<html>
  <head>
    <title><?php echo vpnsubscr_get_org_name( ); ?></title>
    
    <link rel="shortcut icon" type="image/x-image" href="/image/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="/chromestyle.css" />
    <link rel="stylesheet" type="text/css" href="/style.css" />

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow, noarchive, noarchive, nosnippet, noodp, noydir" />
    <meta name="description" content="This page allows you to administrate your VPN application." />

    <script type="text/javascript" src="/js/chrome.js"></script>
    <script type="text/javascript" src="/js/vpnsubscr.js"></script>
    <script type="text/javascript" src="/js/printmenu.js"></script>
    <script type="text/javascript" src="/js/logout.js"></script>
  </head>

  <body>
    <?php vpnsubscr_display_header( ); ?>
  	<?php vpnsubscr_display_welcome( ); ?>
    <div class='box-centered-container'>
      <div class='box-centered-nested'>
	<center><div class='box-diagram'><img src='/image/BeVyPN-Network-Architecture.png' width='100%' /></div></center>
      </div>
    </div>
    <?php vpnsubscr_display_footer( ); ?>
  </body>
</html>
