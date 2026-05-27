<?php

declare(strict_types=1);

require __DIR__ . '/config/cors.php';
require __DIR__ . '/config/db.php';

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

try {
    $pdo = db();
    $method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
    $lang = strtolower(trim((string)($_GET['lang'] ?? 'en')));
    if (!in_array($lang, ['en', 'fr', 'it'], true)) {
        $lang = 'en';
    }

    $upsertI18n = $pdo->prepare("INSERT INTO syntec_product_i18n
        (product_id, lang, product_name, short_name, about_1, about_2)
        VALUES
        (:product_id, :lang, :product_name, :short_name, :about_1, :about_2)
        ON DUPLICATE KEY UPDATE
          product_name = VALUES(product_name),
          short_name = VALUES(short_name),
          about_1 = VALUES(about_1),
          about_2 = VALUES(about_2)");

    if ($method === 'GET') {
        $stmt = $pdo->prepare("SELECT p.*,
                                    COALESCE(pi.product_name, p.product_name) AS product_name,
                                    COALESCE(pi.short_name, p.short_name) AS short_name,
                                    COALESCE(pi.about_1, p.about_1) AS about_1,
                                    COALESCE(pi.about_2, p.about_2) AS about_2,
                                    COALESCE(NULLIF(p.product_image_1,''), NULLIF(p.product_image_large,'')) AS product_image_display,
                                    s.active AS supplier_active,
                                    s.deleted AS supplier_deleted,
                                    s.supplier_name AS supplier_name_join,
                                    s.class_colour AS supplier_class_colour,
                                    s.supplier_logo_small,
                                    s.supplier_logo_large
                             FROM syntec_products p
                             LEFT JOIN syntec_product_i18n pi
                               ON pi.product_id = p.product_id
                              AND pi.lang = :lang
                             LEFT JOIN syntec_suppliers s ON s.supplier_id = p.supplier_id
                             ORDER BY s.supplier_name, p.product_name, p.product_id");
        $stmt->execute(['lang' => $lang]);
        $rows = $stmt->fetchAll();
        echo json_encode(['ok' => true, 'items' => $rows], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }

    if ($method === 'POST') {
        $in = readJson();
        $name = trim((string)($in['product_name'] ?? ''));
        if ($name === '') badRequest('product_name is required.');

        $active = (strtoupper((string)($in['active'] ?? 'Y')) === 'N') ? 'N' : 'Y';
        $deleted = (strtoupper((string)($in['deleted'] ?? 'N')) === 'Y') ? 'Y' : 'N';
        $supplierId = ($in['supplier_id'] ?? '') !== '' ? (string)$in['supplier_id'] : null;
        $stmt = $pdo->prepare("INSERT INTO syntec_products (product_id,prouduct_sku,product_name,supplier_id,short_name,about_1,about_2,product_image_large,product_link,active,deleted,product_sipplier_order)
VALUES (:product_id,:prouduct_sku,:product_name,:supplier_id,:short_name,:about_1,:about_2,:product_image_large,:product_link,:active,:deleted,:product_sipplier_order)");
        $stmt->execute([
            'product_id' => $in['product_id'] ?? null,
            'prouduct_sku' => $in['prouduct_sku'] ?? null,
            'product_name' => $name,
            'supplier_id' => $supplierId,
            'short_name' => $in['short_name'] ?? null,
            'about_1' => $in['about_1'] ?? null,
            'about_2' => $in['about_2'] ?? null,
            'product_image_large' => $in['product_image_large'] ?? null,
            'product_link' => $in['product_link'] ?? null,
            'active' => $active,
            'deleted' => $deleted,
            'product_sipplier_order' => (int)($in['product_sipplier_order'] ?? 0),
        ]);
        $pid = (string)($in['product_id'] ?? '');
        if ($pid !== '') {
            // Create initial non-EN language rows once, seeded from EN base content.
            $upsertI18n->execute([
                'product_id' => $pid,
                'lang' => 'fr',
                'product_name' => $name,
                'short_name' => $in['short_name'] ?? null,
                'about_1' => $in['about_1'] ?? null,
                'about_2' => $in['about_2'] ?? null,
            ]);
            $upsertI18n->execute([
                'product_id' => $pid,
                'lang' => 'it',
                'product_name' => $name,
                'short_name' => $in['short_name'] ?? null,
                'about_1' => $in['about_1'] ?? null,
                'about_2' => $in['about_2'] ?? null,
            ]);
        }
        if ($supplierId) {
            $syncSupplier = $pdo->prepare("UPDATE syntec_suppliers SET active=:active, deleted=:deleted WHERE supplier_id=:supplier_id");
            $syncSupplier->execute(['supplier_id' => $supplierId, 'active' => $active, 'deleted' => $deleted]);
            $syncProducts = $pdo->prepare("UPDATE syntec_products SET active=:active, deleted=:deleted WHERE supplier_id=:supplier_id");
            $syncProducts->execute(['supplier_id' => $supplierId, 'active' => $active, 'deleted' => $deleted]);
        }
        echo json_encode(['ok' => true, 'product_id' => (string)($in['product_id'] ?? '')]);
        exit;
    }

    if ($method === 'PUT') {
        $in = readJson();
        $productId = trim((string)($in['product_id'] ?? ''));
        if ($productId === '') badRequest('product_id is required.');

        $active = (strtoupper((string)($in['active'] ?? 'Y')) === 'N') ? 'N' : 'Y';
        $deleted = (strtoupper((string)($in['deleted'] ?? 'N')) === 'Y') ? 'Y' : 'N';
        $supplierId = ($in['supplier_id'] ?? '') !== '' ? (string)$in['supplier_id'] : null;
        if ($lang === 'en') {
            $stmt = $pdo->prepare("UPDATE syntec_products SET prouduct_sku=:prouduct_sku,product_name=:product_name,supplier_id=:supplier_id,short_name=:short_name,about_1=:about_1,about_2=:about_2,product_image_large=:product_image_large,product_link=:product_link,active=:active,deleted=:deleted,product_sipplier_order=:product_sipplier_order WHERE product_id=:product_id");
        } else {
            $stmt = $pdo->prepare("UPDATE syntec_products SET prouduct_sku=:prouduct_sku,supplier_id=:supplier_id,product_image_large=:product_image_large,product_link=:product_link,active=:active,deleted=:deleted,product_sipplier_order=:product_sipplier_order WHERE product_id=:product_id");
        }
        $params = [
            'product_id' => $in['product_id'] ?? null,
            'prouduct_sku' => $in['prouduct_sku'] ?? null,
            'supplier_id' => $supplierId,
            'product_image_large' => $in['product_image_large'] ?? null,
            'product_link' => $in['product_link'] ?? null,
            'active' => $active,
            'deleted' => $deleted,
            'product_sipplier_order' => (int)($in['product_sipplier_order'] ?? 0),
        ];
        if ($lang === 'en') {
            $params['product_name'] = $in['product_name'] ?? null;
            $params['short_name'] = $in['short_name'] ?? null;
            $params['about_1'] = $in['about_1'] ?? null;
            $params['about_2'] = $in['about_2'] ?? null;
        }
        $stmt->execute($params);
        if ($lang === 'fr' || $lang === 'it') {
            $upsertI18n->execute([
                'product_id' => $productId,
                'lang' => $lang,
                'product_name' => $in['product_name'] ?? null,
                'short_name' => $in['short_name'] ?? null,
                'about_1' => $in['about_1'] ?? null,
                'about_2' => $in['about_2'] ?? null,
            ]);
        }
        if ($supplierId) {
            $syncSupplier = $pdo->prepare("UPDATE syntec_suppliers SET active=:active, deleted=:deleted WHERE supplier_id=:supplier_id");
            $syncSupplier->execute(['supplier_id' => $supplierId, 'active' => $active, 'deleted' => $deleted]);
            $syncProducts = $pdo->prepare("UPDATE syntec_products SET active=:active, deleted=:deleted WHERE supplier_id=:supplier_id");
            $syncProducts->execute(['supplier_id' => $supplierId, 'active' => $active, 'deleted' => $deleted]);
        }
        echo json_encode(['ok' => true]);
        exit;
    }

    if ($method === 'DELETE') {
        $productId = trim((string)($_GET['product_id'] ?? ''));
        if ($productId === '') badRequest('product_id is required.');
        $stmt = $pdo->prepare('DELETE FROM syntec_products WHERE product_id=:product_id');
        $stmt->execute(['product_id' => $productId]);
        echo json_encode(['ok' => true]);
        exit;
    }

    http_response_code(405);
    echo json_encode(['ok' => false, 'error' => 'Method not allowed']);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
