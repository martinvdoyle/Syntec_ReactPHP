<?php

declare(strict_types=1);

require __DIR__ . '/../api/config/translate.php';

$source = __DIR__ . '/../Oracle_Exports/SUPPLIERS_DATA_TABLE.sql';
$out = __DIR__ . '/../database/mysql/042_suppliers_i18n_from_oracle_best_effort.sql';

if (!is_file($source)) {
    fwrite(STDERR, "Missing source file: {$source}\n");
    exit(1);
}

$raw = file_get_contents($source);
if ($raw === false) {
    fwrite(STDERR, "Failed reading source file.\n");
    exit(1);
}

preg_match_all("/Insert into WEB\\.SUPPLIERS\\s*\\((.*?)\\)\\s*values\\s*\\((.*?)\\);/is", $raw, $matches, PREG_SET_ORDER);

if (!$matches) {
    fwrite(STDERR, "No supplier insert rows found.\n");
    exit(1);
}

function splitSqlValues(string $s): array {
    $out = [];
    $buf = '';
    $inQuote = false;
    $len = strlen($s);
    for ($i = 0; $i < $len; $i++) {
        $ch = $s[$i];
        if ($ch === "'") {
            if ($inQuote && $i + 1 < $len && $s[$i + 1] === "'") {
                $buf .= "''";
                $i++;
                continue;
            }
            $inQuote = !$inQuote;
            $buf .= $ch;
            continue;
        }
        if ($ch === ',' && !$inQuote) {
            $out[] = trim($buf);
            $buf = '';
            continue;
        }
        $buf .= $ch;
    }
    if (trim($buf) !== '') $out[] = trim($buf);
    return $out;
}

function sqlTokenToPhp(?string $token): ?string {
    if ($token === null) return null;
    $t = trim($token);
    if ($t === '' || strcasecmp($t, 'null') === 0) return null;
    if (preg_match("/^'(.*)'$/s", $t, $m)) {
        return str_replace("''", "'", $m[1]);
    }
    return $t;
}

function escSql(?string $s): string {
    if ($s === null) return "NULL";
    return "'" . str_replace("'", "''", $s) . "'";
}

$rows = [];
foreach ($matches as $m) {
    $cols = array_map('trim', explode(',', $m[1]));
    $vals = splitSqlValues($m[2]);
    if (count($cols) !== count($vals)) continue;
    $assoc = [];
    foreach ($cols as $idx => $col) {
        $assoc[strtoupper($col)] = sqlTokenToPhp($vals[$idx] ?? null);
    }
    $sid = (string)($assoc['SUPPLIER_ID'] ?? '');
    if ($sid === '') continue;
    $rows[$sid] = [
        'supplier_id' => $sid,
        'profile_1' => $assoc['PROFILE_1'] ?? null,
        'profile_2' => $assoc['PROFILE_2'] ?? null,
    ];
}

$sql = [];
$sql[] = "-- Generated from Oracle_Exports/SUPPLIERS_DATA_TABLE.sql";
$sql[] = "-- Best-effort FR/IT translation placeholders (no external API).";
$sql[] = "";
$sql[] = "INSERT INTO syntec_suppliers_i18n (supplier_id, lang, profile_1, profile_2)";
$sql[] = "VALUES";

$values = [];
foreach ($rows as $r) {
    foreach (['fr', 'it'] as $lang) {
        $p1 = $r['profile_1'] ? translateTextBestEffort((string)$r['profile_1'], $lang) : null;
        $p2 = $r['profile_2'] ? translateTextBestEffort((string)$r['profile_2'], $lang) : null;
        $values[] = "(" . escSql($r['supplier_id']) . ", " . escSql($lang) . ", " . escSql($p1) . ", " . escSql($p2) . ")";
    }
}
$sql[] = implode(",\n", $values);
$sql[] = "ON DUPLICATE KEY UPDATE";
$sql[] = "  profile_1 = VALUES(profile_1),";
$sql[] = "  profile_2 = VALUES(profile_2),";
$sql[] = "  updated_at = CURRENT_TIMESTAMP;";
$sql[] = "";

file_put_contents($out, implode("\n", $sql));
echo "Generated: {$out}\n";
echo "Suppliers: " . count($rows) . "\n";

