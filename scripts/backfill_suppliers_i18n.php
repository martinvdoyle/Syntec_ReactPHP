<?php

declare(strict_types=1);

require __DIR__ . '/../api/config/db.php';
require __DIR__ . '/../api/config/translate.php';

$pdo = db();

$rows = $pdo->query("SELECT supplier_id, profile_1, profile_2 FROM syntec_suppliers ORDER BY supplier_id")->fetchAll();
$up = $pdo->prepare("INSERT INTO syntec_suppliers_i18n (supplier_id, lang, profile_1, profile_2)
                     VALUES (:supplier_id, :lang, :profile_1, :profile_2)
                     ON DUPLICATE KEY UPDATE
                       profile_1 = VALUES(profile_1),
                       profile_2 = VALUES(profile_2)");

$total = count($rows);
$done = 0;
foreach ($rows as $r) {
    $id = (string)$r['supplier_id'];
    $p1 = $r['profile_1'];
    $p2 = $r['profile_2'];

    foreach (['fr', 'it'] as $lang) {
        $tp1 = ($p1 === null || trim((string)$p1) === '') ? null : translateText((string)$p1, $lang);
        $tp2 = ($p2 === null || trim((string)$p2) === '') ? null : translateText((string)$p2, $lang);
        $up->execute(['supplier_id' => $id, 'lang' => $lang, 'profile_1' => $tp1, 'profile_2' => $tp2]);
    }
    $done++;
    echo "[{$done}/{$total}] {$id}\n";
}

echo "Backfill complete.\n";
