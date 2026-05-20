<?php

/*
 * Syntec DB config template
 * Copy to db-config.local.php and set real values.
 */

if (strpos(strtolower($_SERVER['PHP_SELF'] ?? ''), 'db-config.example.php') !== false) {
    die('This file can not be used on its own!');
}

global $_DB_host, $_DB_name, $_DB_user, $_DB_pass;

$_DB_host = 'db-host.example.com';
$_DB_name = '9ng6ht_syntecdev';
$_DB_user = '9ng6ht_syntecapi';
$_DB_pass = 'replace_with_real_password';
