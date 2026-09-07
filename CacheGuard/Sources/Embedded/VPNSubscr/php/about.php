<?php

/*
###########################################################################
#
# MODULE:       VPN Subscription
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
<?php vpnsubscr_display_html_header( ); ?>
  <body>
    <?php vpnsubscr_display_header( ); ?>
    <div class='centered-container'>
      <div class='centered-nested'>
	  <table class='highlight-form'>
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
      </div>
    </div>
    <?php vpnsubscr_display_footer( ); ?>
  </body>
</html>
