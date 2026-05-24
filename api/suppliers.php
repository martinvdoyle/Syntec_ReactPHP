<?php

declare(strict_types=1);

require __DIR__ . '/config/cors.php';
require __DIR__ . '/config/db.php';

try {
    $activeOnly = !isset($_GET['include_inactive']) || $_GET['include_inactive'] !== '1';

    $sql = <<<'SQL'
SELECT
    id,
    COALESCE(supplier_id, supplier_code) AS supplier_id,
    COALESCE(supplier_name, name) AS supplier_name,
    slug,
    short_description,
    website_url,
    logo_path,
    banner_path,
    business_unit,
    sort_order,
    active_flag
FROM syntec_suppliers
SQL;

    if ($activeOnly) {
        $sql .= ' WHERE active_flag = 1';
    }

    $sql .= ' ORDER BY sort_order ASC, supplier_name ASC';

    $stmt = db()->query($sql);
    $rows = $stmt->fetchAll();

    $suppliers = array_map(static function (array $row): array {
        return [
            'id' => (int) $row['id'],
            'supplierId' => $row['supplier_id'] !== null ? (string) $row['supplier_id'] : null,
            'name' => (string) $row['supplier_name'],
            'slug' => (string) $row['slug'],
            'shortName' => $row['short_description'] !== null ? (string) $row['short_description'] : null,
            'website' => $row['website_url'] !== null ? (string) $row['website_url'] : null,
            'logoPath' => $row['logo_path'] !== null ? (string) $row['logo_path'] : null,
            'bannerPath' => $row['banner_path'] !== null ? (string) $row['banner_path'] : null,
            'business' => $row['business_unit'] !== null ? (string) $row['business_unit'] : null,
            'sortOrder' => (int) $row['sort_order'],
            'active' => (bool) $row['active_flag'],
        ];
    }, $rows);

    echo json_encode([
        'ok' => true,
        'count' => count($suppliers),
        'suppliers' => $suppliers,
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode([
        'ok' => false,
        'error' => 'Failed to load suppliers.',
        'details' => $e->getMessage(),
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
}
