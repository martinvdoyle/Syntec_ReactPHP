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

    if ($method === 'GET') {
        $rows = $pdo->query("SELECT p.*, s.name AS supplier_name FROM syntec_products p LEFT JOIN syntec_suppliers s ON s.id=p.supplier_id ORDER BY p.sort_order, p.id")->fetchAll();
        echo json_encode(['ok' => true, 'items' => $rows], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }

    if ($method === 'POST') {
        $in = readJson();
        $name = trim((string)($in['name'] ?? ''));
        $slug = trim((string)($in['slug'] ?? ''));
        if ($name === '' || $slug === '') badRequest('name and slug are required.');

        $stmt = $pdo->prepare("INSERT INTO syntec_products (product_code,sku,name,slug,supplier_id,short_description,long_description,category_summary,primary_image_path,external_url,active_flag,featured_flag,sort_order)
VALUES (:product_code,:sku,:name,:slug,:supplier_id,:short_description,:long_description,:category_summary,:primary_image_path,:external_url,:active_flag,:featured_flag,:sort_order)");
        $stmt->execute([
            'product_code' => $in['product_code'] ?? null,
            'sku' => $in['sku'] ?? null,
            'name' => $name,
            'slug' => $slug,
            'supplier_id' => ($in['supplier_id'] ?? '') !== '' ? (int)$in['supplier_id'] : null,
            'short_description' => $in['short_description'] ?? null,
            'long_description' => $in['long_description'] ?? null,
            'category_summary' => $in['category_summary'] ?? null,
            'primary_image_path' => $in['primary_image_path'] ?? null,
            'external_url' => $in['external_url'] ?? null,
            'active_flag' => (($in['active_flag'] ?? '1') === '1' || ($in['active_flag'] ?? 1) === 1) ? 1 : 0,
            'featured_flag' => (($in['featured_flag'] ?? '0') === '1' || ($in['featured_flag'] ?? 0) === 1) ? 1 : 0,
            'sort_order' => (int)($in['sort_order'] ?? 0),
        ]);
        echo json_encode(['ok' => true, 'id' => (int)$pdo->lastInsertId()]);
        exit;
    }

    if ($method === 'PUT') {
        $in = readJson();
        $id = (int)($in['id'] ?? 0);
        if ($id <= 0) badRequest('id is required.');

        $stmt = $pdo->prepare("UPDATE syntec_products SET product_code=:product_code,sku=:sku,name=:name,slug=:slug,supplier_id=:supplier_id,short_description=:short_description,long_description=:long_description,category_summary=:category_summary,primary_image_path=:primary_image_path,external_url=:external_url,active_flag=:active_flag,featured_flag=:featured_flag,sort_order=:sort_order WHERE id=:id");
        $stmt->execute([
            'id' => $id,
            'product_code' => $in['product_code'] ?? null,
            'sku' => $in['sku'] ?? null,
            'name' => $in['name'] ?? null,
            'slug' => $in['slug'] ?? null,
            'supplier_id' => ($in['supplier_id'] ?? '') !== '' ? (int)$in['supplier_id'] : null,
            'short_description' => $in['short_description'] ?? null,
            'long_description' => $in['long_description'] ?? null,
            'category_summary' => $in['category_summary'] ?? null,
            'primary_image_path' => $in['primary_image_path'] ?? null,
            'external_url' => $in['external_url'] ?? null,
            'active_flag' => (($in['active_flag'] ?? '1') === '1' || ($in['active_flag'] ?? 1) === 1) ? 1 : 0,
            'featured_flag' => (($in['featured_flag'] ?? '0') === '1' || ($in['featured_flag'] ?? 0) === 1) ? 1 : 0,
            'sort_order' => (int)($in['sort_order'] ?? 0),
        ]);
        echo json_encode(['ok' => true]);
        exit;
    }

    if ($method === 'DELETE') {
        $id = (int)($_GET['id'] ?? 0);
        if ($id <= 0) badRequest('id is required.');
        $stmt = $pdo->prepare('DELETE FROM syntec_products WHERE id=:id');
        $stmt->execute(['id' => $id]);
        echo json_encode(['ok' => true]);
        exit;
    }

    http_response_code(405);
    echo json_encode(['ok' => false, 'error' => 'Method not allowed']);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
