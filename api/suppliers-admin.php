<?php

declare(strict_types=1);

require __DIR__ . '/config/cors.php';
require __DIR__ . '/config/db.php';
require __DIR__ . '/config/translate.php';

header('Content-Type: application/json; charset=utf-8');

function badRequest(string $msg): void {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => $msg], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

function readJson(): array {
    $raw = file_get_contents('php://input') ?: '';
    if ($raw === '') return [];
    $data = json_decode($raw, true);
    if (!is_array($data)) badRequest('Invalid JSON payload.');
    return $data;
}
function sanitizeAnchorId($value): ?string {
    if ($value === null) return null;
    $s = trim((string)$value);
    if ($s === '') return null;
    $s = strtolower($s);
    $s = str_replace([' ', '/', '_'], '-', $s);
    $s = preg_replace('/[^a-z0-9-]+/', '-', $s) ?? '';
    $s = preg_replace('/-+/', '-', $s) ?? '';
    $s = trim($s, '-');
    return $s === '' ? null : $s;
}
function upsertSupplierI18n(PDO $pdo, string $supplierId, string $lang, $profile1, $profile2): void {
    $up = $pdo->prepare("INSERT INTO syntec_suppliers_i18n (supplier_id, lang, profile_1, profile_2)
                         VALUES (:supplier_id, :lang, :profile_1, :profile_2)
                         ON DUPLICATE KEY UPDATE
                           profile_1 = VALUES(profile_1),
                           profile_2 = VALUES(profile_2)");
    $up->execute([
        'supplier_id' => $supplierId,
        'lang' => $lang,
        'profile_1' => $profile1,
        'profile_2' => $profile2,
    ]);
}

try {
    $pdo = db();
    $method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
    $lang = strtolower(trim((string)($_GET['lang'] ?? 'en')));
    if (!in_array($lang, ['en', 'fr', 'it'], true)) {
        $lang = 'en';
    }

    if ($method === 'GET') {
        $sql = "SELECT s.*,
                       COALESCE(si_req.profile_1, s.profile_1) AS profile_1,
                       COALESCE(si_req.profile_2, s.profile_2) AS profile_2
                FROM syntec_suppliers s
                LEFT JOIN syntec_suppliers_i18n si_req
                  ON si_req.supplier_id = s.supplier_id
                 AND si_req.lang = :lang
                ORDER BY supplier_name, supplier_id";
        $stmt = $pdo->prepare($sql);
        $stmt->execute(['lang' => $lang]);
        $rows = $stmt->fetchAll();
        echo json_encode(['ok' => true, 'items' => $rows], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }

    if ($method === 'POST' || $method === 'PUT') {
        $in = readJson();
        $supplierId = trim((string)($in['supplier_id'] ?? ''));
        if ($supplierId === '') badRequest('supplier_id is required.');
        $supplierName = trim((string)($in['supplier_name'] ?? ''));
        if ($method === 'POST' && $supplierName === '') badRequest('supplier_name is required.');

        $active = (strtoupper((string)($in['active'] ?? 'Y')) === 'N') ? 'N' : 'Y';
        $deleted = (strtoupper((string)($in['deleted'] ?? 'N')) === 'Y') ? 'Y' : 'N';
        if (array_key_exists('anchor_id', $in)) {
            $in['anchor_id'] = sanitizeAnchorId($in['anchor_id']);
        }

        if ($method === 'PUT' && (int)($in['impact_only'] ?? 0) === 1) {
            $impact = $pdo->prepare("SELECT COUNT(*) AS products_total,
                                            SUM(CASE WHEN COALESCE(active,'') <> :active OR COALESCE(deleted,'') <> :deleted THEN 1 ELSE 0 END) AS products_changed
                                     FROM syntec_products
                                     WHERE supplier_id = :supplier_id");
            $impact->execute(['supplier_id' => $supplierId, 'active' => $active, 'deleted' => $deleted]);
            $row = $impact->fetch() ?: ['products_total' => 0, 'products_changed' => 0];
            echo json_encode(['ok' => true, 'impact' => $row], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
            exit;
        }

        if ($method === 'POST') {
            $stmt = $pdo->prepare("INSERT INTO syntec_suppliers (supplier_id,supplier_name,website,profile_1,profile_2,supplier_logo_large,supplier_logo_small,supplier_image_1,supplier_image_2,supplier_image_3,supplier_image_4,supplier_image_background,active,deleted,short_name,class_id,class_colour,address_1,address_2,address_3,address_4,address_5,date_created,date_deleted,anchor_id,supplier_logo_large_scale_smaller,business)
VALUES (:supplier_id,:supplier_name,:website,:profile_1,:profile_2,:supplier_logo_large,:supplier_logo_small,:supplier_image_1,:supplier_image_2,:supplier_image_3,:supplier_image_4,:supplier_image_background,:active,:deleted,:short_name,:class_id,:class_colour,:address_1,:address_2,:address_3,:address_4,:address_5,:date_created,:date_deleted,:anchor_id,:supplier_logo_large_scale_smaller,:business)");
        } else {
            if ($lang === 'en') {
                $stmt = $pdo->prepare("UPDATE syntec_suppliers SET supplier_name=:supplier_name,website=:website,profile_1=:profile_1,profile_2=:profile_2,supplier_logo_large=:supplier_logo_large,supplier_logo_small=:supplier_logo_small,supplier_image_1=:supplier_image_1,supplier_image_2=:supplier_image_2,supplier_image_3=:supplier_image_3,supplier_image_4=:supplier_image_4,supplier_image_background=:supplier_image_background,active=:active,deleted=:deleted,short_name=:short_name,class_id=:class_id,class_colour=:class_colour,address_1=:address_1,address_2=:address_2,address_3=:address_3,address_4=:address_4,address_5=:address_5,date_created=:date_created,date_deleted=:date_deleted,anchor_id=:anchor_id,supplier_logo_large_scale_smaller=:supplier_logo_large_scale_smaller,business=:business WHERE supplier_id=:supplier_id");
            } else {
                $stmt = $pdo->prepare("UPDATE syntec_suppliers SET supplier_name=:supplier_name,website=:website,supplier_logo_large=:supplier_logo_large,supplier_logo_small=:supplier_logo_small,supplier_image_1=:supplier_image_1,supplier_image_2=:supplier_image_2,supplier_image_3=:supplier_image_3,supplier_image_4=:supplier_image_4,supplier_image_background=:supplier_image_background,active=:active,deleted=:deleted,short_name=:short_name,class_id=:class_id,class_colour=:class_colour,address_1=:address_1,address_2=:address_2,address_3=:address_3,address_4=:address_4,address_5=:address_5,date_created=:date_created,date_deleted=:date_deleted,anchor_id=:anchor_id,supplier_logo_large_scale_smaller=:supplier_logo_large_scale_smaller,business=:business WHERE supplier_id=:supplier_id");
            }
        }
        $params = [
            'supplier_id' => $supplierId,
            'supplier_name' => $supplierName,
            'website' => $in['website'] ?? null,
            'supplier_logo_large' => $in['supplier_logo_large'] ?? null,
            'supplier_logo_small' => $in['supplier_logo_small'] ?? null,
            'supplier_image_1' => $in['supplier_image_1'] ?? null,
            'supplier_image_2' => $in['supplier_image_2'] ?? null,
            'supplier_image_3' => $in['supplier_image_3'] ?? null,
            'supplier_image_4' => $in['supplier_image_4'] ?? null,
            'supplier_image_background' => $in['supplier_image_background'] ?? null,
            'active' => $active,
            'deleted' => $deleted,
            'short_name' => $in['short_name'] ?? null,
            'class_id' => $in['class_id'] ?? null,
            'class_colour' => $in['class_colour'] ?? null,
            'address_1' => $in['address_1'] ?? null,
            'address_2' => $in['address_2'] ?? null,
            'address_3' => $in['address_3'] ?? null,
            'address_4' => $in['address_4'] ?? null,
            'address_5' => $in['address_5'] ?? null,
            'date_created' => (($in['date_created'] ?? '') === '' || ($in['date_created'] ?? '') === '0000-00-00 00:00:00') ? null : $in['date_created'],
            'date_deleted' => (($in['date_deleted'] ?? '') === '' || ($in['date_deleted'] ?? '') === '0000-00-00 00:00:00') ? null : $in['date_deleted'],
            'anchor_id' => $in['anchor_id'] ?? null,
            'supplier_logo_large_scale_smaller' => $in['supplier_logo_large_scale_smaller'] ?? null,
            'business' => $in['business'] ?? null,
        ];
        if ($method === 'POST' || $lang === 'en') {
            $params['profile_1'] = $in['profile_1'] ?? null;
            $params['profile_2'] = $in['profile_2'] ?? null;
        }
        $stmt->execute($params);
        if (array_key_exists('profile_1', $in) || array_key_exists('profile_2', $in)) {
            $p1 = $in['profile_1'] ?? null;
            $p2 = $in['profile_2'] ?? null;
            if ($method === 'POST') {
                // Create initial non-EN language records once; EN remains in base table only.
                upsertSupplierI18n($pdo, $supplierId, 'fr', $p1, $p2);
                upsertSupplierI18n($pdo, $supplierId, 'it', $p1, $p2);
            } else {
                // Update only selected non-EN language; EN remains base-table managed.
                if ($lang === 'fr' || $lang === 'it') {
                    upsertSupplierI18n($pdo, $supplierId, $lang, $p1, $p2);
                }
            }
        }
        // Backend-only parity: supplier flags drive all child product flags.
        $sync = $pdo->prepare("UPDATE syntec_products SET active = :active, deleted = :deleted WHERE supplier_id = :supplier_id");
        $sync->execute(['supplier_id' => $supplierId, 'active' => $active, 'deleted' => $deleted]);
        echo json_encode(['ok' => true, 'supplier_id' => $supplierId], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }

    if ($method === 'DELETE') {
        $supplierId = trim((string)($_GET['supplier_id'] ?? ''));
        if ($supplierId === '') badRequest('supplier_id is required.');
        $stmt = $pdo->prepare('DELETE FROM syntec_suppliers WHERE supplier_id=:supplier_id');
        $stmt->execute(['supplier_id' => $supplierId]);
        echo json_encode(['ok' => true], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }

    http_response_code(405);
    echo json_encode(['ok' => false, 'error' => 'Method not allowed']);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
