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

function vpnsubscr_subscribers_print_error( $code, $message )
{
    echo "<div class='box-error'>\n";
    vpnsubscr_print_error( $code, $message );
    echo "</div>\n";
}

function vpnsubscr_display_subscribers( )
{
    $title = 'Refresh';
        echo <<< EOT
<table class='box-list'>
<tr>
  <td>Username</td>
  <td>Contact</td>
  <td>Status</td>
  <td>Profile</td>
  <td>Password</td>
  <td>Edit</td>
</tr>

EOT;
    $method = isset( $_SERVER['REQUEST_METHOD']  ) ? $_SERVER['REQUEST_METHOD']  : '';
    $method = filter_var( $method, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
        
    if ($method != 'GET') {
        vpnsubscr_subscribers_print_error( 101, "this HTTP method is not allowed." );
        return false;
    }

    $db_record = vpnsubscr_db_connect( SQLITE3_OPEN_READWRITE );
    $error = $db_record['error'];
    $message = $db_record['message'];
    $db = $db_record['link'];

    if ($error != 0) {
        vpnsubscr_subscribers_print_error( $error, $message );
        return false;
    }

    $edit_title = "Edit the Subscriber Account";
    $subscribers = 0;
    $max_subscribers = MAX_SUBSCRIBERS;

    try {
        $query = "SELECT `username`, `email_address`, `first_name`, `last_name`, `device`, `phone`, `alive_date`, `tls_password`, `service` FROM `subscriber` ORDER BY `username`;";
        $statement = $db->prepare( $query );
        $result = $statement->execute( );

        while($row = $result->fetchArray( )) {

            $username = $row['username'];
            $email = $row['email_address'];
            $first_name = $row['first_name'];
            $last_name = $row['last_name'];
            $phone = $row['phone'];
            $device = $row['device'];
            $alive_date = $row['alive_date'];
            $tls_password = $row['tls_password'];
            $service = $row['service'];

            if ($service != SUBSCRIBER_STATE_CANCELLED) {
                $subscribers++;
            }

            $name = vpnsubscr_get_contact_name( $first_name, $last_name, $email );
            $to = vpnsubscr_get_contact_to( $first_name, $last_name, $email );
            $visible_to = vpnsubscr_get_visible_contact_to( $name, $email );
            $download_profile_link = vpnsubscr_get_profile_link( $username, $device );

            if (is_null( $download_profile_link )) {
                $unavailable_message = vpnsubscr_get_unavailable_message( $alive_date, $service );
                $profile_link = $unavailable_message;
                $password_icons = $unavailable_message;
            }
            else {
                $instructions_link = vpnsubscr_get_instructions_link( $username, $to );
                $profile_link = "$download_profile_link $instructions_link";
                $password_icons = vpnsubscr_subscriber_get_password_icons( $username, $name, $phone, $tls_password );
            }
            $service_icon = vpnsubscr_subscriber_service_icon( $service, $alive_date );
            $username_encoded = vpnsubscr_get_encoded( $username );
            $operation_edit_encoded = vpnsubscr_get_encoded( OPERATION_EDIT );
            $args = OPERATION . "={$operation_edit_encoded}&" . USERNAME . "={$username_encoded}";
            $edit = "<a href='subscriber.php?$args'><img src='/image/edit.png' title='$edit_title' alt='$edit_title' /></a>";

            echo <<< EOT
<tr>
  <td>$username</td>
  <td><a href='mailto:$to'>$visible_to</a></td>
  <td><center>$service_icon</center></td>
  <td><center>$profile_link</center></td>
  <td><center>$password_icons</center></td>
  <td><center>$edit</center></td>
</tr>

EOT;
        }
        $remaining_subscribers = $max_subscribers - $subscribers;
        echo <<< EOT
</table>
<center>[<u>$remaining_subscribers / $max_subscribers Remaining Subscriber Accounts</u>]</center>

EOT;
    }
    catch (Exception $e) {
        $message = vpnsubscr_get_unexpected_error_message( $e->getMessage( ) );
        vpnsubscr_subscribers_print_error( 103, $message );
        return false;
    }
}

function vpnsubscr_display_title( )
{
    $refresh_title = 'Refresh';
    $refresh_icon = " <a href='subscribers.php'><img src='/image/refresh.png' title='$refresh_title' alt='$refresh_title' /></a>";
    echo "Subscribers &gt; All Subscribers $refresh_icon";
}

?>
<!DOCTYPE html>
<html>
  <head>
    <title><?php echo vpnsubscr_get_org_name( ); ?> Subscribers</title>
    
    <link rel="shortcut icon" type="image/x-image" href="/image/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="/chromestyle.css" />
    <link rel="stylesheet" type="text/css" href="/style.css" />
    
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow, noarchive, noarchive, nosnippet, noodp, noydir" >
    <meta name="description" content="This page allows you to manage VPN subscribers." />

    <script type="text/javascript" src="/js/chrome.js"></script>
    <script type="text/javascript" src="/js/vpnsubscr.js"></script>
    <script type="text/javascript" src="/js/printmenu.js"></script>
    <script type="text/javascript" src="/js/logout.js"></script>
  </head>

  <body>
    <?php vpnsubscr_display_header( ); ?>
    <div class='box-centered-container'>
      <div class='box-centered-nested'>
	<div class='page-title'><?php vpnsubscr_display_title( ); ?></div>
	<div class="box-help">
	  Click on an item to perform the associated action on a subscriber.
	</div>
	<?php vpnsubscr_display_subscribers( ); ?>
      </div>
    </div>
    <?php vpnsubscr_display_footer( ); ?>
  </body>
</html>
