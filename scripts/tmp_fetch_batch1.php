<?php
require __DIR__ . '/../api/config/db.php';
$pdo=db();
$ids=['SUP-0001','SUP-0002','SUP-0003','SUP-0004','SUP-0005'];
$in = "'" . implode("','", $ids) . "'";
$sql = "SELECT supplier_id, supplier_name, profile_1, profile_2 FROM syntec_suppliers WHERE supplier_id IN ($in) ORDER BY supplier_id";
$rows=$pdo->query($sql)->fetchAll(PDO::FETCH_ASSOC);
echo json_encode($rows, JSON_PRETTY_PRINT|JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);
