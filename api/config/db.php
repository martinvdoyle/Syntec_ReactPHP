<?php

declare(strict_types=1);

function db(): PDO
{
    static $pdo = null;

    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $host = '';
    $name = '';
    $user = '';
    $pass = '';

    $localConfig = dirname(__DIR__, 2) . '/db-config.local.php';
    if (is_file($localConfig)) {
        require $localConfig;
        global $_DB_host, $_DB_name, $_DB_user, $_DB_pass;
        $host = (string) ($_DB_host ?? '');
        $name = (string) ($_DB_name ?? '');
        $user = (string) ($_DB_user ?? '');
        $pass = (string) ($_DB_pass ?? '');
    }

    if ($host === '' || $name === '' || $user === '') {
        $host = getenv('SYNTEC_DB_HOST') ?: '';
        $name = getenv('SYNTEC_DB_NAME') ?: '';
        $user = getenv('SYNTEC_DB_USER') ?: '';
        $pass = getenv('SYNTEC_DB_PASS') ?: '';
    }

    if ($host === '' || $name === '' || $user === '') {
        throw new RuntimeException('Database environment variables are missing.');
    }

    $dsn = "mysql:host={$host};dbname={$name};charset=utf8mb4";
    $pdo = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);

    return $pdo;
}
