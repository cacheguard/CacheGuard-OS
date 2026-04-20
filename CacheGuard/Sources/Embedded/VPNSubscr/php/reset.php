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

function vpnsubscr_get_input_state( $method, $confirm_reset, $data )
{
    $errors = array( );

    switch ($method) {

    case 'GET':
        return $errors;
        break;

    case 'POST':
        break;

    default:
        array_push( $errors, array( 301, "this HTTP method is not supported." ));
        return $errors;
        break;
    }

    switch ($data[SERVICE_STATE]) {

    case SETUP_STATE_INITIALISED:
    case SETUP_STATE_MODIFIED:
    case SETUP_STATE_RESET:
        return $errors;
        break;

    default:
        break;
    }

    $service_name = $data[SERVICE_NAME];
    $domain_name = $data[PRIVATE_DOMAIN_NAME];
    $vpn_address = $data[VPN_ADDRESS];

    if ($service_name == '') {
        array_push( $errors, array( 21, "please specify a service name." ));
        $state = false;
    }
    elseif (preg_match ( '/^[a-zA-Z0-9 _.-]*$/', $service_name ) == 0) {
        array_push( $errors, array( 23, "the service identity may contain alphanumeric characters, dash, underscore and dot." ));
        $state = false;
    }

    if ($domain_name == '') {
        array_push( $errors, array( 25, "please specify a private domain name." ));
        $state = false;
    }
    elseif (preg_match ( '/^[a-zA-Z0-9]([a-zA-Z0-9])*(\-([a-zA-Z0-9])+)*([.][a-zA-Z0-9]([a-zA-Z0-9])*(\-([a-zA-Z0-9])+)*)*$/', $domain_name ) == 0) {
        array_push( $errors, array( 27, "the provided private domain name is not valid." ));
        $state = false;
    }

    switch( $confirm_reset ) {
    case '':
    case 'on':
        break;

    default:
        array_push( $errors, array( 29, "please use the official application form to submit your request." ));
        break;
    }

    if ($confirm_reset != 'on') {
        array_push( $errors, array( 31, "please confirm the reset by checking the <u>Confirm Reset</u> checkbox." ));
    }

    if ($vpn_address != '') {
        if (preg_match ( '/^[a-zA-Z0-9]([a-zA-Z0-9])*(\-([a-zA-Z0-9])+)*([.][a-zA-Z0-9]([a-zA-Z0-9])*(\-([a-zA-Z0-9])+)*)*$/', $vpn_address ) == 0) {
            array_push( $errors, array( 33, "the provided VPN address is not valid." ));
        }
    }

    return $errors;
}

function vpnsubscr_get_reset( )
{
    $setup = vpnsubscr_get_setup_data( );

    $errors = $setup[ERRORS];
    $setup_data = $setup[DATA];

    $data = array( );
    $data[SERVICE_NAME] = $setup_data[SERVICE_NAME];
    $data[PRIVATE_DOMAIN_NAME] = $setup_data[PRIVATE_DOMAIN_NAME];
    $data[VPN_ADDRESS] = $setup_data[VPN_ADDRESS];
    $data[SERVICE_STATE] = $setup_data[SERVICE_STATE];

    $method = isset( $_SERVER['REQUEST_METHOD']  ) ? $_SERVER['REQUEST_METHOD']  : '';
    $method = filter_var( $method, FILTER_SANITIZE_FULL_SPECIAL_CHARS );

    switch ($method) {

    case 'GET':
        $confirm_reset = '';
        break;

    case 'POST':
        $data[SERVICE_NAME] = isset( $_POST[SERVICE_NAME] ) ? $_POST[SERVICE_NAME] : VPN_NAME;
        $data[PRIVATE_DOMAIN_NAME] = isset( $_POST[PRIVATE_DOMAIN_NAME] ) ? $_POST[PRIVATE_DOMAIN_NAME] : DEFAULT_PRIVATE_DOMAIN_NAME;
        $data[VPN_ADDRESS] = isset( $_POST[VPN_ADDRESS] ) ? $_POST[VPN_ADDRESS] : '';
        $confirm_reset = isset( $_POST[CONFIRM_RESET] ) ? $_POST[CONFIRM_RESET] : '';

        foreach ($data as $key => $value) {
            $data[$key] = filter_var( $value, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
        }
        $confirm_reset = filter_var( $confirm_reset, FILTER_SANITIZE_FULL_SPECIAL_CHARS );

        $data[VPN_ADDRESS] = vpnsubscr_remove_useless_whitespaces( $data[VPN_ADDRESS] );

        $errors = vpnsubscr_get_input_state( $method, $confirm_reset, $data );
        break;

    default:
        $method = 'NONE';
        $confirm_reset = '';
        break;
    }

    return array(
        METHOD => $method,
        ERRORS => $errors,
        CONFIRM_RESET => $confirm_reset,
        DATA => $data
    );
}

function vpnsubscr_submit_reset( $data )
{
    $errors = array( );

    $service = $data[SERVICE_STATE];

    switch ($service) {

    case SETUP_STATE_INEXISTANT:
        $message = "the service has never been setup to be reset!";
        array_push( $errors, array( 101, $message ));
        return array( SERVICE_STATE => $service, ERRORS => $errors );
        break;

    default:
        $db_record = vpnsubscr_db_connect( SQLITE3_OPEN_READWRITE );
        $error = $db_record['error'];
        $message = $db_record['message'];
        $db = $db_record['link'];

        if ($error != 0) {
            array_push( $errors, array( $error, $message ));
            return array( SERVICE_STATE => $service, ERRORS => $errors );
        }

        $service_name = $data[SERVICE_NAME];
        $domain_name = $data[PRIVATE_DOMAIN_NAME];
        $vpn_address = $data[VPN_ADDRESS];

        try {
            $service = SETUP_STATE_RESET;
            $query = "UPDATE `setup` SET `service_name` = '$service_name', `domain_name` = '$domain_name', `vpn_address` = '$vpn_address', `service` = '$service' WHERE `id` = '0';";
            $statement = $db->prepare( $query );
            $result = $statement->execute( );
            $result->finalize( );
        }
        catch (Exception $e) {
            $message = vpnsubscr_get_unexpected_error_message( $e->getMessage( ));
            array_push( $errors, array( 103, $message ));
            return array( SERVICE_STATE => $service, ERRORS => $errors );
        }
        break;
    }

    return array( SERVICE_STATE => $service, ERRORS => $errors );
}

function vpnsubscr_display_title( )
{
    $refresh_title = 'Refresh';
    $refresh_icon = " <a href='reset.php'><img src='/image/refresh.png' title='$refresh_title' alt='$refresh_title' /></a>";

    echo "Reset Service $refresh_icon";
}

function vpnsubscr_display_form( $reset )
{
    $input_size = 28;
    $input_maxlength = 64;

    $method = $reset[METHOD];
    $errors = $reset[ERRORS];
    $confirm_reset = $reset[CONFIRM_RESET];
    $data = $reset[DATA];

    if ($method == 'POST' and !$errors) {
        $result = vpnsubscr_submit_reset( $data );
        $errors = $result[ERRORS];
        $data[SERVICE_STATE] = $result[SERVICE_STATE];
    }

    $service_name = $data[SERVICE_NAME];
    $domain_name = $data[PRIVATE_DOMAIN_NAME];
    $vpn_address = $data[VPN_ADDRESS];
    $service_state = $data[SERVICE_STATE];

    $service_name_id = SERVICE_NAME;
    $domain_name_id = PRIVATE_DOMAIN_NAME;
    $confirm_reset_id = CONFIRM_RESET;
    $vpn_address_id = VPN_ADDRESS;

    $service_name_id_html = "id='$service_name_id' name='$service_name_id'";
    $domain_name_id_html = "id='$domain_name_id' name='$domain_name_id'";
    $confirm_reset_id_html = "id='$confirm_reset_id' name='$confirm_reset_id'";
    $vpn_address_id_html = "id='$vpn_address_id' name='$vpn_address_id'";

    $mandatory = "<font color='firebrick'> *</font>";
    vpnsubscr_display_setup_help( 'reset', $service_state );
    echo "<form name='submit-vpnsubscr-form' id='submit-vpnsubscr-form' action='/reset.php' method='POST'>";

    vpnsubscr_print_all_errors( $errors );

    echo "<center>\n";
    echo "<table class='box-form'>\n";

    echo "<tr class='separator'><td><strong>VPN Settings</strong></td><td></td></tr>\n";

    echo "<tr><td>Service State</td><td>";

    switch ($service_state) {
    case SETUP_STATE_INEXISTANT:
        $title = 'New Setup';
        $icon = 'unknown.png';
        $log = false;
        break;
    case SETUP_STATE_RESET:
        $icon = 'working.gif';
        $title = 'Reset Service Ongoing';
        $log = false;
        break;
    case SETUP_STATE_RESET_FAILED:
        $icon = 'ko.png';
        $title = 'Faulty Setup';
        $log = true;
        break;
    default:
        $icon = 'ok.png';
        $title = 'Setup Done';
        $log = false;
        break;
    }

    if ($log) {
        echo "<a href='report.php'><img src='/image/$icon' title='$title' alt='$title' /></a>";
    }
    else {
        echo "<img src='/image/$icon' title='$title' alt='$title' />";
    }

    echo "<tr><td>Service Identity Name</td><td>";
    switch ($service_state) {
    case SETUP_STATE_ACTIVATED:
    case SETUP_STATE_RESET_FAILED:
        if ($method == 'GET' or $errors) {
            echo "<input maxlength='$input_maxlength' size='$input_size' value='$service_name' $service_name_id_html />$mandatory\n";
        }
        elseif ($method == "POST") {
            echo "<input type='hidden' value='$service_name' $service_name_id_html /><strong>$service_name</strong>\n";
        }
        break;

    default:
        echo "<strong>$service_name</strong>";
        break;
    }
    echo "</td></tr>\n";

    echo "<tr><td>Private Domain Name</td><td>";
    switch ($service_state) {
    case SETUP_STATE_ACTIVATED:
    case SETUP_STATE_RESET_FAILED:
        if ($method == 'GET' or $errors) {
            echo "<input maxlength='$input_maxlength' size='$input_size' value='$domain_name' $domain_name_id_html />$mandatory\n";
        }
        elseif ($method == "POST") {
            echo "<input type='hidden' value='$domain_name' $domain_name_id_html />$domain_name\n";
        }
        break;

    default:
        echo "<strong>$domain_name</strong>";
        break;
    }
    echo "</td></tr>\n";

    switch ($service_state) {
    case SETUP_STATE_ACTIVATED:
    case SETUP_STATE_RESET_FAILED:
        echo "<tr><td><label for='$confirm_reset_id'>Confirm Reset</label></td>";
        echo "<td>";
        echo "<input type='checkbox' $confirm_reset_id_html />";
        echo "</td></tr>\n";
        break;

    default:
        break;
    }

    $visible_vpn_address = empty( $vpn_address ) ? '<i>&lt;default&gt;</i>' : $vpn_address;
    echo "<tr><td>VPN Server Address</td><td>";
    switch ($service_state) {
    case SETUP_STATE_ACTIVATED:
    case SETUP_STATE_RESET_FAILED:
        if ($method == 'GET' or $errors) {
            echo "<input maxlength='$input_maxlength' size='$input_size' value='$vpn_address' $vpn_address_id_html />\n";
            echo "<div class='box-comment'>Leave blank to use your public IP address.</div>\n";
        }
        elseif ($method == "POST") {
            echo "<input type='hidden' value='$vpn_address' $vpn_address_id_html />$visible_vpn_address\n";
        }
        break;

    default:
        echo "$visible_vpn_address";
        break;
    }
    echo "</td></tr>\n";

    switch ($service_state) {
    case SETUP_STATE_ACTIVATED:
    case SETUP_STATE_RESET_FAILED:
        echo "<tr><td></td><td><input class='valid-button' type='submit' value='Validate' /></td></tr>\n";
        break;

    default:
        break;
    }

    echo <<< EOT
</table>
</center>

EOT;
    switch ($service_state) {
    case SETUP_STATE_ACTIVATED:
    case SETUP_STATE_FAILED:
        echo "</form>\n";
        break;

    default:
        break;
    }
}

// Main( )

$RESET = vpnsubscr_get_reset( );

?>
<!DOCTYPE html>
<html>
  <head>
    <title><?php echo vpnsubscr_get_org_name( ); ?> Reset Service</title>

    <link rel="shortcut icon" type="image/x-image" href="/image/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="/chromestyle.css" />
    <link rel="stylesheet" type="text/css" href="/style.css" />

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow, noarchive, noarchive, nosnippet, noodp, noydir" />
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
	<div class='page-title'>Setup &gt; <?php vpnsubscr_display_title( ); ?></div>
	<?php vpnsubscr_display_form( $RESET ); ?>
      </div>
    </div>
    <?php vpnsubscr_display_footer( ); ?>
  </body>
</html>
