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

$TIMEZONES = array(
    "Africa/Abidjan",
    "Africa/Accra",
    "Africa/Addis_Ababa",
    "Africa/Algiers",
    "Africa/Asmara",
    "Africa/Asmera",
    "Africa/Bamako",
    "Africa/Bangui",
    "Africa/Banjul",
    "Africa/Bissau",
    "Africa/Blantyre",
    "Africa/Brazzaville",
    "Africa/Bujumbura",
    "Africa/Cairo",
    "Africa/Casablanca",
    "Africa/Ceuta",
    "Africa/Conakry",
    "Africa/Dakar",
    "Africa/Dar_es_Salaam",
    "Africa/Djibouti",
    "Africa/Douala",
    "Africa/El_Aaiun",
    "Africa/Freetown",
    "Africa/Gaborone",
    "Africa/Harare",
    "Africa/Johannesburg",
    "Africa/Juba",
    "Africa/Kampala",
    "Africa/Khartoum",
    "Africa/Kigali",
    "Africa/Kinshasa",
    "Africa/Lagos",
    "Africa/Libreville",
    "Africa/Lome",
    "Africa/Luanda",
    "Africa/Lubumbashi",
    "Africa/Lusaka",
    "Africa/Malabo",
    "Africa/Maputo",
    "Africa/Maseru",
    "Africa/Mbabane",
    "Africa/Mogadishu",
    "Africa/Monrovia",
    "Africa/Nairobi",
    "Africa/Ndjamena",
    "Africa/Niamey",
    "Africa/Nouakchott",
    "Africa/Ouagadougou",
    "Africa/Porto-Novo",
    "Africa/Sao_Tome",
    "Africa/Timbuktu",
    "Africa/Tripoli",
    "Africa/Tunis",
    "Africa/Windhoek",
    "America/Adak",
    "America/Anchorage",
    "America/Anguilla",
    "America/Antigua",
    "America/Araguaina",
    "America/Argentina/Buenos_Aires",
    "America/Argentina/Catamarca",
    "America/Argentina/ComodRivadavia",
    "America/Argentina/Cordoba",
    "America/Argentina/Jujuy",
    "America/Argentina/La_Rioja",
    "America/Argentina/Mendoza",
    "America/Argentina/Rio_Gallegos",
    "America/Argentina/Salta",
    "America/Argentina/San_Juan",
    "America/Argentina/San_Luis",
    "America/Argentina/Tucuman",
    "America/Argentina/Ushuaia",
    "America/Aruba",
    "America/Asuncion",
    "America/Atikokan",
    "America/Atka",
    "America/Bahia",
    "America/Bahia_Banderas",
    "America/Barbados",
    "America/Belem",
    "America/Belize",
    "America/Blanc-Sablon",
    "America/Boa_Vista",
    "America/Bogota",
    "America/Boise",
    "America/Buenos_Aires",
    "America/Cambridge_Bay",
    "America/Campo_Grande",
    "America/Cancun",
    "America/Caracas",
    "America/Catamarca",
    "America/Cayenne",
    "America/Cayman",
    "America/Chicago",
    "America/Chihuahua",
    "America/Coral_Harbour",
    "America/Cordoba",
    "America/Costa_Rica",
    "America/Creston",
    "America/Cuiaba",
    "America/Curacao",
    "America/Danmarkshavn",
    "America/Dawson",
    "America/Dawson_Creek",
    "America/Denver",
    "America/Detroit",
    "America/Dominica",
    "America/Edmonton",
    "America/Eirunepe",
    "America/El_Salvador",
    "America/Ensenada",
    "America/Fortaleza",
    "America/Fort_Nelson",
    "America/Fort_Wayne",
    "America/Glace_Bay",
    "America/Godthab",
    "America/Goose_Bay",
    "America/Grand_Turk",
    "America/Grenada",
    "America/Guadeloupe",
    "America/Guatemala",
    "America/Guayaquil",
    "America/Guyana",
    "America/Halifax",
    "America/Havana",
    "America/Hermosillo",
    "America/Indiana/Indianapolis",
    "America/Indiana/Knox",
    "America/Indiana/Marengo",
    "America/Indiana/Petersburg",
    "America/Indianapolis",
    "America/Indiana/Tell_City",
    "America/Indiana/Vevay",
    "America/Indiana/Vincennes",
    "America/Indiana/Winamac",
    "America/Inuvik",
    "America/Iqaluit",
    "America/Jamaica",
    "America/Jujuy",
    "America/Juneau",
    "America/Kentucky/Louisville",
    "America/Kentucky/Monticello",
    "America/Knox_IN",
    "America/Kralendijk",
    "America/La_Paz",
    "America/Lima",
    "America/Los_Angeles",
    "America/Louisville",
    "America/Lower_Princes",
    "America/Maceio",
    "America/Managua",
    "America/Manaus",
    "America/Marigot",
    "America/Martinique",
    "America/Matamoros",
    "America/Mazatlan",
    "America/Mendoza",
    "America/Menominee",
    "America/Merida",
    "America/Metlakatla",
    "America/Mexico_City",
    "America/Miquelon",
    "America/Moncton",
    "America/Monterrey",
    "America/Montevideo",
    "America/Montreal",
    "America/Montserrat",
    "America/Nassau",
    "America/New_York",
    "America/Nipigon",
    "America/Nome",
    "America/Noronha",
    "America/North_Dakota/Beulah",
    "America/North_Dakota/Center",
    "America/North_Dakota/New_Salem",
    "America/Nuuk",
    "America/Ojinaga",
    "America/Panama",
    "America/Pangnirtung",
    "America/Paramaribo",
    "America/Phoenix",
    "America/Port-au-Prince",
    "America/Porto_Acre",
    "America/Port_of_Spain",
    "America/Porto_Velho",
    "America/Puerto_Rico",
    "America/Punta_Arenas",
    "America/Rainy_River",
    "America/Rankin_Inlet",
    "America/Recife",
    "America/Regina",
    "America/Resolute",
    "America/Rio_Branco",
    "America/Rosario",
    "America/Santa_Isabel",
    "America/Santarem",
    "America/Santiago",
    "America/Santo_Domingo",
    "America/Sao_Paulo",
    "America/Scoresbysund",
    "America/Shiprock",
    "America/Sitka",
    "America/St_Barthelemy",
    "America/St_Johns",
    "America/St_Kitts",
    "America/St_Lucia",
    "America/St_Thomas",
    "America/St_Vincent",
    "America/Swift_Current",
    "America/Tegucigalpa",
    "America/Thule",
    "America/Thunder_Bay",
    "America/Tijuana",
    "America/Toronto",
    "America/Tortola",
    "America/Vancouver",
    "America/Virgin",
    "America/Whitehorse",
    "America/Winnipeg",
    "America/Yakutat",
    "America/Yellowknife",
    "Antarctica/Casey",
    "Antarctica/Davis",
    "Antarctica/DumontDUrville",
    "Antarctica/Macquarie",
    "Antarctica/Mawson",
    "Antarctica/McMurdo",
    "Antarctica/Palmer",
    "Antarctica/Rothera",
    "Antarctica/South_Pole",
    "Antarctica/Syowa",
    "Antarctica/Troll",
    "Antarctica/Vostok",
    "Asia/Aden",
    "Asia/Almaty",
    "Asia/Amman",
    "Asia/Anadyr",
    "Asia/Aqtau",
    "Asia/Aqtobe",
    "Asia/Ashgabat",
    "Asia/Ashkhabad",
    "Asia/Atyrau",
    "Asia/Baghdad",
    "Asia/Bahrain",
    "Asia/Baku",
    "Asia/Bangkok",
    "Asia/Barnaul",
    "Asia/Beirut",
    "Asia/Bishkek",
    "Asia/Brunei",
    "Asia/Calcutta",
    "Asia/Chita",
    "Asia/Choibalsan",
    "Asia/Chongqing",
    "Asia/Chungking",
    "Asia/Colombo",
    "Asia/Dacca",
    "Asia/Damascus",
    "Asia/Dhaka",
    "Asia/Dili",
    "Asia/Dubai",
    "Asia/Dushanbe",
    "Asia/Famagusta",
    "Asia/Gaza",
    "Asia/Harbin",
    "Asia/Hebron",
    "Asia/Ho_Chi_Minh",
    "Asia/Hong_Kong",
    "Asia/Hovd",
    "Asia/Irkutsk",
    "Asia/Istanbul",
    "Asia/Jakarta",
    "Asia/Jayapura",
    "Asia/Jerusalem",
    "Asia/Kabul",
    "Asia/Kamchatka",
    "Asia/Karachi",
    "Asia/Kashgar",
    "Asia/Kathmandu",
    "Asia/Katmandu",
    "Asia/Khandyga",
    "Asia/Kolkata",
    "Asia/Krasnoyarsk",
    "Asia/Kuala_Lumpur",
    "Asia/Kuching",
    "Asia/Kuwait",
    "Asia/Macao",
    "Asia/Macau",
    "Asia/Magadan",
    "Asia/Makassar",
    "Asia/Manila",
    "Asia/Muscat",
    "Asia/Nicosia",
    "Asia/Novokuznetsk",
    "Asia/Novosibirsk",
    "Asia/Omsk",
    "Asia/Oral",
    "Asia/Phnom_Penh",
    "Asia/Pontianak",
    "Asia/Pyongyang",
    "Asia/Qatar",
    "Asia/Qostanay",
    "Asia/Qyzylorda",
    "Asia/Rangoon",
    "Asia/Riyadh",
    "Asia/Saigon",
    "Asia/Sakhalin",
    "Asia/Samarkand",
    "Asia/Seoul",
    "Asia/Shanghai",
    "Asia/Singapore",
    "Asia/Srednekolymsk",
    "Asia/Taipei",
    "Asia/Tashkent",
    "Asia/Tbilisi",
    "Asia/Tehran",
    "Asia/Tel_Aviv",
    "Asia/Thimbu",
    "Asia/Thimphu",
    "Asia/Tokyo",
    "Asia/Tomsk",
    "Asia/Ujung_Pandang",
    "Asia/Ulaanbaatar",
    "Asia/Ulan_Bator",
    "Asia/Urumqi",
    "Asia/Ust-Nera",
    "Asia/Vientiane",
    "Asia/Vladivostok",
    "Asia/Yakutsk",
    "Asia/Yangon",
    "Asia/Yekaterinburg",
    "Asia/Yerevan",
    "Atlantic/Azores",
    "Atlantic/Bermuda",
    "Atlantic/Canary",
    "Atlantic/Cape_Verde",
    "Atlantic/Faeroe",
    "Atlantic/Faroe",
    "Atlantic/Jan_Mayen",
    "Atlantic/Madeira",
    "Atlantic/Reykjavik",
    "Atlantic/South_Georgia",
    "Atlantic/Stanley",
    "Atlantic/St_Helena",
    "Australia/ACT",
    "Australia/Adelaide",
    "Australia/Brisbane",
    "Australia/Broken_Hill",
    "Australia/Canberra",
    "Australia/Currie",
    "Australia/Darwin",
    "Australia/Eucla",
    "Australia/Hobart",
    "Australia/LHI",
    "Australia/Lindeman",
    "Australia/Lord_Howe",
    "Australia/Melbourne",
    "Australia/North",
    "Australia/NSW",
    "Australia/Perth",
    "Australia/Queensland",
    "Australia/South",
    "Australia/Sydney",
    "Australia/Tasmania",
    "Australia/Victoria",
    "Australia/West",
    "Australia/Yancowinna",
    "Europe/Amsterdam",
    "Europe/Andorra",
    "Europe/Astrakhan",
    "Europe/Athens",
    "Europe/Belfast",
    "Europe/Belgrade",
    "Europe/Berlin",
    "Europe/Bratislava",
    "Europe/Brussels",
    "Europe/Bucharest",
    "Europe/Budapest",
    "Europe/Busingen",
    "Europe/Chisinau",
    "Europe/Copenhagen",
    "Europe/Dublin",
    "Europe/Gibraltar",
    "Europe/Guernsey",
    "Europe/Helsinki",
    "Europe/Isle_of_Man",
    "Europe/Istanbul",
    "Europe/Jersey",
    "Europe/Kaliningrad",
    "Europe/Kiev",
    "Europe/Kirov",
    "Europe/Lisbon",
    "Europe/Ljubljana",
    "Europe/London",
    "Europe/Luxembourg",
    "Europe/Madrid",
    "Europe/Malta",
    "Europe/Mariehamn",
    "Europe/Minsk",
    "Europe/Monaco",
    "Europe/Moscow",
    "Europe/Nicosia",
    "Europe/Oslo",
    "Europe/Paris",
    "Europe/Podgorica",
    "Europe/Prague",
    "Europe/Riga",
    "Europe/Rome",
    "Europe/Samara",
    "Europe/San_Marino",
    "Europe/Sarajevo",
    "Europe/Saratov",
    "Europe/Simferopol",
    "Europe/Skopje",
    "Europe/Sofia",
    "Europe/Stockholm",
    "Europe/Tallinn",
    "Europe/Tirane",
    "Europe/Tiraspol",
    "Europe/Ulyanovsk",
    "Europe/Uzhgorod",
    "Europe/Vaduz",
    "Europe/Vatican",
    "Europe/Vienna",
    "Europe/Vilnius",
    "Europe/Volgograd",
    "Europe/Warsaw",
    "Europe/Zagreb",
    "Europe/Zaporozhye",
    "Europe/Zurich",
    "Pacific/Apia",
    "Pacific/Auckland",
    "Pacific/Bougainville",
    "Pacific/Chatham",
    "Pacific/Chuuk",
    "Pacific/Easter",
    "Pacific/Efate",
    "Pacific/Enderbury",
    "Pacific/Fakaofo",
    "Pacific/Fiji",
    "Pacific/Funafuti",
    "Pacific/Galapagos",
    "Pacific/Gambier",
    "Pacific/Guadalcanal",
    "Pacific/Guam",
    "Pacific/Honolulu",
    "Pacific/Johnston",
    "Pacific/Kanton",
    "Pacific/Kiritimati",
    "Pacific/Kosrae",
    "Pacific/Kwajalein",
    "Pacific/Majuro",
    "Pacific/Marquesas",
    "Pacific/Midway",
    "Pacific/Nauru",
    "Pacific/Niue",
    "Pacific/Norfolk",
    "Pacific/Noumea",
    "Pacific/Pago_Pago",
    "Pacific/Palau",
    "Pacific/Pitcairn",
    "Pacific/Pohnpei",
    "Pacific/Ponape",
    "Pacific/Port_Moresby",
    "Pacific/Rarotonga",
    "Pacific/Saipan",
    "Pacific/Samoa",
    "Pacific/Tahiti",
    "Pacific/Tarawa",
    "Pacific/Tongatapu",
    "Pacific/Truk",
    "Pacific/Wake",
    "Pacific/Wallis",
    "Pacific/Yap"
);

function vpnsubscr_print_timezones( $selected_timezone = NULL)
{
    global $TIMEZONES;

    foreach($TIMEZONES as $timezone) {
        if ($timezone == $selected_timezone) {
            $selected_html = " selected";
        }
        else {
            $selected_html = '';
        }
        echo "  <option value='$timezone'$selected_html>$timezone</option>\n";
    }
}

function vpnsubscr_get_input_state( $method, $license_acceptance, $data )
{
    global $TIMEZONES;

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
    $timezone = $data[TIMEZONE];
    $service_state = $data[SERVICE_STATE];
    $max_len = 32;

    if ($service_name == '') {
        array_push( $errors, array( 21, "please specify a service identity name." ));
    }
    elseif (strlen( $service_name ) > $max_len) {
        array_push( $errors, array( 23, "the maximum allowed length for the service identity is $max_len." ));
    }
    elseif (preg_match ( '/^[a-zA-Z0-9 _.-]*$/', $service_name ) == 0) {
        array_push( $errors, array( 25, "the service identity may contain alphanumeric characters, dash, underscore and dot." ));
    }

    if ($domain_name == '') {
        array_push( $errors, array( 27, "please specify a private domain name." ));
    }
    elseif (strlen( $domain_name ) > $max_len) {
        array_push( $errors, array( 29, "the maximum allowed length for the domain name is $max_len." ));
    }
    elseif (preg_match ( '/^[a-zA-Z0-9]([a-zA-Z0-9])*(\-([a-zA-Z0-9])+)*([.][a-zA-Z0-9]([a-zA-Z0-9])*(\-([a-zA-Z0-9])+)*)*$/', $domain_name ) == 0) {
        array_push( $errors, array( 31, "the provided private domain name is not valid." ));
    }

    if ($vpn_address != '') {
        if (preg_match ( '/^[a-zA-Z0-9]([a-zA-Z0-9])*(\-([a-zA-Z0-9])+)*([.][a-zA-Z0-9]([a-zA-Z0-9])*(\-([a-zA-Z0-9])+)*)*$/', $vpn_address ) == 0) {
            array_push( $errors, array( 33, "the provided VPN address is not valid." ));
        }
    }

    if (!in_array( $timezone, $TIMEZONES )) {
        array_push( $errors, array( 35, "please enter a valid timezone." ));
    }

    switch ($service_state) {
    case SETUP_STATE_INEXISTANT:

        switch( $license_acceptance ) {
        case '':
        case 'on':
            break;

        default:
            array_push( $errors, array( 37, "please use the official application form to submit your request." ));
            break;
        }

        if ($license_acceptance == '') {
            array_push( $errors, array( 39, "please read and accept the terms of usage." ));
        }
        break;

    default:
        break;
    }

    return $errors;
}

function vpnsubscr_get_setup( )
{
    $setup = vpnsubscr_get_setup_data( );

    $method = isset( $_SERVER['REQUEST_METHOD']  ) ? $_SERVER['REQUEST_METHOD']  : '';
    $method = filter_var( $method, FILTER_SANITIZE_FULL_SPECIAL_CHARS );

    switch ($method) {

    case 'GET':
        $errors = $setup[ERRORS];
        $data = $setup[DATA];

        if ($data[SERVICE_NAME] == '') $data[SERVICE_NAME] = VPN_NAME;
        if ($data[PRIVATE_DOMAIN_NAME] == '') $data[PRIVATE_DOMAIN_NAME] = DEFAULT_PRIVATE_DOMAIN_NAME;
        if ($data[TIMEZONE] == '') $data[TIMEZONE] = DEFAULT_TIMEZONE;

        $license_acceptance = '';
        break;

    case 'POST':
        $data[SERVICE_NAME] = isset( $_POST[SERVICE_NAME] ) ? $_POST[SERVICE_NAME] : VPN_NAME;
        $data[PRIVATE_DOMAIN_NAME] = isset( $_POST[PRIVATE_DOMAIN_NAME] ) ? $_POST[PRIVATE_DOMAIN_NAME] : DEFAULT_PRIVATE_DOMAIN_NAME;
        $data[VPN_ADDRESS] = isset( $_POST[VPN_ADDRESS] ) ? $_POST[VPN_ADDRESS] : '';
        $data[TIMEZONE] = isset( $_POST[TIMEZONE] ) ? $_POST[TIMEZONE] : DEFAULT_TIMEZONE;

        foreach ($data as $key => $value) {
            $data[$key] = filter_var( $value, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
        }

        $data[VPN_ADDRESS] = vpnsubscr_remove_useless_whitespaces( $data[VPN_ADDRESS] );

        $data[SERVICE_STATE] = $setup[DATA][SERVICE_STATE];

        switch ($data[SERVICE_STATE]) {
        case SETUP_STATE_INEXISTANT:
            $license_acceptance = isset( $_POST[LICENSE_ACCEPTANCE] ) ? $_POST[LICENSE_ACCEPTANCE] : '';
            $license_acceptance = filter_var( $license_acceptance, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
            break;

        default:
            $license_acceptance = NULL;
            break;
        }

        $errors = vpnsubscr_get_input_state( $method, $license_acceptance, $data );
        break;

    default:
        $method = 'NONE';
        break;
    }

    return array(
        METHOD => $method,
        ERRORS => $errors,
        DATA => $data
    );
}

function vpnsubscr_submit_setup( $data )
{
    $errors = array( );
    $service = SETUP_STATE_UNKNOWN;

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
    $timezone = $data[TIMEZONE];
    $service = $data[SERVICE_STATE];

    switch ($service) {

    case SETUP_STATE_INEXISTANT:
        $service = SETUP_STATE_INITIALISED;
        $query = "UPDATE `setup` SET `service_name` = '$service_name', `previous_service_name` = '$service_name', `domain_name` = '$domain_name', `timezone` = '$timezone', `vpn_address` = '$vpn_address', `service` = '$service' WHERE `id` = '0';";
        break;

    default:
        $service = SETUP_STATE_MODIFIED;
        $query = "UPDATE `setup` SET `domain_name` = '$domain_name', `timezone` = '$timezone', `vpn_address` = '$vpn_address', `service` = '$service' WHERE `id` = '0';";
        break;
    }

    try {
        $statement = $db->prepare( $query );
        $result = $statement->execute( );
        $result->finalize( );
        
    }
    catch (Exception $e) {
        $message = vpnsubscr_get_unexpected_error_message( $e->getMessage( ));
        array_push( $errors, array( 101, $message ));
        return array( SERVICE_STATE => $service, ERRORS => $errors );
    }

    return array( SERVICE_STATE => $service, ERRORS => $errors );
}

function vpnsubscr_display_title( )
{
    $refresh_title = 'Refresh';
    $refresh_icon = " <a href='setup.php'><img src='/image/refresh.png' title='$refresh_title' alt='$refresh_title' /></a>";

    echo "General Setup $refresh_icon";
}

function vpnsubscr_display_form( $setup )
{
    $input_size = 28;
    $input_maxlength = 32;
    $select_width = '306px';

    $method = $setup[METHOD];
    $errors = $setup[ERRORS];
    $data = $setup[DATA];

    if ($method == 'POST' and !$errors) {
        $result = vpnsubscr_submit_setup( $data );
        $errors = $result[ERRORS];
        $data[SERVICE_STATE] = $result[SERVICE_STATE];
    }

    $service_name = $data[SERVICE_NAME];
    $domain_name = $data[PRIVATE_DOMAIN_NAME];
    $vpn_address = $data[VPN_ADDRESS];
    $timezone = $data[TIMEZONE];
    $service_state = $data[SERVICE_STATE];

    $service_name_id = SERVICE_NAME;
    $domain_name_id = PRIVATE_DOMAIN_NAME;
    $vpn_address_id = VPN_ADDRESS;
    $timezone_id = TIMEZONE;
    $license_acceptance_id = LICENSE_ACCEPTANCE;

    $service_name_id_html = "id='$service_name_id' name='$service_name_id'";
    $domain_name_id_html = "id='$domain_name_id' name='$domain_name_id'";
    $vpn_address_id_html = "id='$vpn_address_id' name='$vpn_address_id'";
    $timezone_id_html = "id='$timezone_id' name='$timezone_id'";
    $license_acceptance_id_html = "id='$license_acceptance_id' name='$license_acceptance_id'";

    $mandatory = "<font color='firebrick'> *</font>";

    vpnsubscr_display_setup_help( 'setup', $service_state );
    echo "<form name='submit-vpnsubscr-form' id='submit-vpnsubscr-form' action='/setup.php' method='POST'>\n";
    vpnsubscr_print_all_errors( $errors );

    echo "<center>\n";
    echo "<table class='box-form'>\n";

    echo "<tr class='separator'><td><strong>Service Identity</strong></td><td></td></tr>\n";

    echo "<tr><td>Service State</td><td>";

    switch ($service_state) {

    case SETUP_STATE_INEXISTANT:
        $title = 'New Setup';
        $icon = 'unknown.png';
        $log = false;
        break;

    case SETUP_STATE_INITIALISED:
        $icon = 'working.gif';
        $title = 'New Setup Ongoing';
        $log = false;
        break;

    case SETUP_STATE_MODIFIED:
        $icon = 'working.gif';
        $title = 'Setup Modification Ongoing';
        $log = false;
        break;

    case SETUP_STATE_INIT_FAILED:
    case SETUP_STATE_FAILED:
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
    echo "</td></tr>\n";

    $hidden = "<input type='hidden' value='$service_name' $service_name_id_html /><strong>$service_name</strong>\n";
    echo "<tr><td>Service Identity Name</td><td>";
    switch ($service_state) {
    case SETUP_STATE_INEXISTANT:
    case SETUP_STATE_INIT_FAILED:
        if ($method == 'GET' or $errors) {
            echo "<input maxlength='$input_maxlength' size='$input_size' value='$service_name' $service_name_id_html />$mandatory\n";
        }
        elseif ($method == 'POST') {
            echo $hidden;
        }
        break;

    default:
        echo $hidden;
        break;
    }
    echo "</td></tr>\n";

    $hidden = "<input type='hidden' value='$domain_name' $domain_name_id_html />$domain_name\n";
    echo "<tr><td>Private Domain Name</td><td>";
    switch ($service_state) {
    case SETUP_STATE_INEXISTANT:
    case SETUP_STATE_INIT_FAILED:
        if ($method == 'GET' or $errors) {
            echo "<input maxlength='$input_maxlength' size='$input_size' value='$domain_name' $domain_name_id_html />$mandatory\n";
        }
        elseif ($method == 'POST') {
            echo $hidden;
        }
        break;

    default:
        echo $hidden;
        break;
    }
    echo "</td></tr>\n";

    if (empty( $vpn_address )) {
        $visible_vpn_address = "<i>&lt;public IP address&gt;</i>";
    }
    else {
        $visible_vpn_address = $vpn_address;
    }

    $hidden = "<input type='hidden' value='$vpn_address' $vpn_address_id_html />$visible_vpn_address\n";
    echo "<tr><td>VPN Server Address</td><td>";
    switch ($service_state) {
    case SETUP_STATE_INEXISTANT:
    case SETUP_STATE_INIT_FAILED:
        if ($method == 'GET' or $errors) {
            echo "<input maxlength='15' size='$input_size' value='$vpn_address' $vpn_address_id_html />\n";
            echo "<div class='box-comment'>Leave blank to use your public IP address.</div>\n";
        }
        elseif ($method == 'POST') {
            echo $hidden;
        }
        break;

    default:
        echo $hidden;
        break;
    }
    echo "</td></tr>\n";

    echo "<tr class='separator'><td><strong>Other Settings</strong></td><td></td></tr>\n";
    echo "<tr><td>Timezone</td><td>";

    switch ($service_state) {
    case SETUP_STATE_INITIALISED:
    case SETUP_STATE_MODIFIED:
    case SETUP_STATE_RESET:
        echo "$timezone";
        break;

    default:
        if ($method == 'GET' or $errors) {
            echo "<select style='width:$select_width;' value='$timezone' $timezone_id_html>";
            vpnsubscr_print_timezones( $timezone );
            echo "</select>$mandatory";
        }
        elseif ($method == "POST") {
            echo "<input type='hidden' value='$timezone' $timezone_id_html />$timezone\n";
        }
        break;
    }
    echo "</td></tr>\n";

    switch ($service_state) {
    case SETUP_STATE_INEXISTANT:
        if ($method == 'GET' or $errors) {
            $license_url = LICENSE_URL;
            $license_link = "<a target='_blank' href='$license_url'>CacheGuard OS License</a>";
            echo "<tr class='separator'><td><strong>License Agreement</strong></td><td></td></tr>\n";
            echo "<tr><td><label for='$license_acceptance_id'>Acceptance Terms</label>\n</td>";
            echo "<td>\n";
            echo "<input type='checkbox' checked $license_acceptance_id_html />$mandatory<br /><label for='$license_acceptance_id'><br />I have read and accepted<br />the $license_link</label><p>\n";
            echo "</td></tr>\n";
        }
        break;

    default:
        break;
    }

    switch ($service_state) {
    case SETUP_STATE_INITIALISED:
    case SETUP_STATE_MODIFIED:
    case SETUP_STATE_RESET:
        break;

    default:
        echo "<tr><td></td><td><input class='valid-button' type='submit' value='Validate' /></td></tr>\n";
        break;
    }

    echo <<< EOT
</table>
</center>

EOT;
    switch ($service_state) {
    case SETUP_STATE_INITIALISED:
    case SETUP_STATE_MODIFIED:
    case SETUP_STATE_RESET:
        break;

    default:
        echo "</form>\n";
    }
}

// Main( )

$SETUP = vpnsubscr_get_setup( );

?>
<!DOCTYPE html>
<html>
  <head>
    <title><?php echo vpnsubscr_get_org_name( ); ?> General Setup</title>

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
	<?php vpnsubscr_display_form( $SETUP ); ?>
      </div>
    </div>
    <?php vpnsubscr_display_footer( ); ?>
  </body>
</html>
