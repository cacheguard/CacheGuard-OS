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

function display_cg_os( )
{
    $os_name = OS_NAME;
    $os_generation = OS_GENERATION;

    $cur_version = OS_CUR_VERSION;
    $new_version = OS_NEW_VERSION;

    echo "<tr>\n";
    echo "<td>$os_name-OS</td>\n";
    echo "<td>Version $os_generation-$cur_version</td>\n";
    echo "</tr>\n";

    if (empty( $new_version )) {
        return true;
    }

    if ($cur_version == $new_version) {
        return true;
    }

    $link = OS_UPGRADE_LINK;
    $title = "New Version Available - Upgrade";

    echo "<tr>\n";
    echo "<td></td>\n";
    echo "<td><a href='$link' target='_blank'><img src='/image/upgrade.png' title='$title' alt='$title' /> Upgrade</a></td>\n";
    echo "</tr>\n";
}

?>
<!DOCTYPE html>
<html>
  <head>
    <title>About <?php echo vpnsubscr_get_org_name( ); ?></title>
    
    <link rel="shortcut icon" type="image/x-image" href="/image/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="/chromestyle.css" />
    <link rel="stylesheet" type="text/css" href="/style.css" />

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow, noarchive, noarchive, nosnippet, noodp, noydir" />
    <meta name="description" content="This page gives information about the application." />

    <script type="text/javascript" src="/js/chrome.js"></script>
    <script type="text/javascript" src="/js/vpnsubscr.js"></script>
    <script type="text/javascript" src="/js/printmenu.js"></script>
    <script type="text/javascript" src="/js/logout.js"></script>
  </head>

  <body>
    <?php vpnsubscr_display_header( ); ?>
    <div class='box-centered-container'>
      <div class='box-centered-nested'>
	<center>
	  <table class='box-form'>
	    <tr>
	      <td>Application Name</td>
	      <td><?php echo COMMERCIAL_NAME; ?></td>
	    </tr>
	    <tr>
	      <td>Application Version</td>
	      <td><?php echo APP_VERSION; ?></td>
	    </tr>
	    <tr>
	      <td>Capacity</td>
	      <td><?php echo MAX_SUBSCRIBERS; ?> Subscribers</td>
	    </tr>
        <?php display_cg_os( ); ?>
	  </table>
	</center>
      </div>
    </div>
    <?php vpnsubscr_display_footer( ); ?>
  </body>
</html>
