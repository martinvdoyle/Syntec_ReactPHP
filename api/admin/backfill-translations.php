<?php

declare(strict_types=1);

require __DIR__ . '/../config/cors.php';
require __DIR__ . '/../config/db.php';
require __DIR__ . '/../config/translate.php';

header('Content-Type: application/json; charset=utf-8');

if (isset($_GET['debug']) && (string)$_GET['debug'] === '1') {
    $path = dirname(__DIR__, 2) . '/translate-config.local.php';
    loadTranslateLocalConfig();
    global $_BACKFILL_TOKEN;
    echo json_encode([
        'ok' => true,
        'debug' => [
            'resolved_path' => $path,
            'exists' => is_file($path),
            'readable' => is_readable($path),
            'token_set' => isset($_BACKFILL_TOKEN) && trim((string)$_BACKFILL_TOKEN) !== '',
            'token_len' => strlen((string)($_BACKFILL_TOKEN ?? '')),
        ],
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

function fail(int $code, string $msg): void {
    http_response_code($code);
    echo json_encode(['ok' => false, 'error' => $msg], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

function getToken(): string {
    loadTranslateLocalConfig();
    global $_BACKFILL_TOKEN;
    return (string)($_BACKFILL_TOKEN ?? (getenv('BACKFILL_TOKEN') ?: ''));
}

function requireAuth(): void {
    $expected = getToken();
    if ($expected === '') fail(500, 'BACKFILL_TOKEN is not configured.');
    $provided = trim((string)($_GET['token'] ?? ''));
    if ($provided === '' || !hash_equals($expected, $provided)) {
        fail(403, 'Invalid token.');
    }
}

function toInt(string $key, int $default, int $min, int $max): int {
    $raw = $_GET[$key] ?? null;
    if ($raw === null || $raw === '') return $default;
    $n = (int)$raw;
    if ($n < $min) $n = $min;
    if ($n > $max) $n = $max;
    return $n;
}

function upsertSupplierI18n(PDO $pdo, string $supplierId, string $lang, ?string $p1, ?string $p2): void {
    $up = $pdo->prepare("INSERT INTO syntec_suppliers_i18n (supplier_id, lang, profile_1, profile_2)
                         VALUES (:supplier_id, :lang, :profile_1, :profile_2)
                         ON DUPLICATE KEY UPDATE
                           profile_1 = VALUES(profile_1),
                           profile_2 = VALUES(profile_2)");
    $up->execute([
        'supplier_id' => $supplierId,
        'lang' => $lang,
        'profile_1' => $p1,
        'profile_2' => $p2,
    ]);
}

function upsertProductI18n(PDO $pdo, string $productId, string $lang, array $fields): void {
    $up = $pdo->prepare("INSERT INTO syntec_product_i18n
        (product_id, lang, product_name, short_name, about_1, about_2)
        VALUES
        (:product_id, :lang, :product_name, :short_name, :about_1, :about_2)
        ON DUPLICATE KEY UPDATE
          product_name = VALUES(product_name),
          short_name = VALUES(short_name),
          about_1 = VALUES(about_1),
          about_2 = VALUES(about_2)");
    $up->execute([
        'product_id' => $productId,
        'lang' => $lang,
        'product_name' => $fields['product_name'] ?? null,
        'short_name' => $fields['short_name'] ?? null,
        'about_1' => $fields['about_1'] ?? null,
        'about_2' => $fields['about_2'] ?? null,
    ]);
}

function t(?string $txt, string $lang): ?string {
    if ($txt === null || trim($txt) === '') return $txt;
    return translateText($txt, $lang);
}

requireAuth();

$mode = strtolower(trim((string)($_GET['mode'] ?? '')));
$langs = ['fr', 'it'];
$limit = toInt('limit', 50, 1, 200);
$offset = toInt('offset', 0, 0, 10000000);

try {
    $pdo = db();

    if ($mode === 'suppliers') {
        $stmt = $pdo->prepare("SELECT supplier_id, profile_1, profile_2
                               FROM syntec_suppliers
                               ORDER BY supplier_id
                               LIMIT :limit OFFSET :offset");
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        $stmt->execute();
        $rows = $stmt->fetchAll();
        $done = [];
        foreach ($rows as $r) {
            $sid = (string)$r['supplier_id'];
            $p1 = $r['profile_1'] ?? null;
            $p2 = $r['profile_2'] ?? null;
            foreach ($langs as $lang) {
                upsertSupplierI18n($pdo, $sid, $lang, t($p1, $lang), t($p2, $lang));
            }
            $done[] = $sid;
        }
        echo json_encode(['ok' => true, 'mode' => 'suppliers', 'processed' => count($done), 'ids' => $done], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }

    if ($mode === 'products') {
        $supplierId = trim((string)($_GET['supplier_id'] ?? ''));
        if ($supplierId === '') fail(400, 'supplier_id is required for mode=products.');
        $stmt = $pdo->prepare("SELECT product_id, product_name, short_name, about_1, about_2
                               FROM syntec_products
                               WHERE supplier_id = :supplier_id
                               ORDER BY product_id
                               LIMIT :limit OFFSET :offset");
        $stmt->bindValue(':supplier_id', $supplierId);
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        $stmt->execute();
        $rows = $stmt->fetchAll();
        $done = [];
        foreach ($rows as $r) {
            $pid = (string)$r['product_id'];
            foreach ($langs as $lang) {
                upsertProductI18n($pdo, $pid, $lang, [
                    'product_name' => t($r['product_name'] ?? null, $lang),
                    'short_name' => t($r['short_name'] ?? null, $lang),
                    'about_1' => t($r['about_1'] ?? null, $lang),
                    'about_2' => t($r['about_2'] ?? null, $lang),
                ]);
            }
            $done[] = $pid;
        }
        echo json_encode(['ok' => true, 'mode' => 'products', 'supplier_id' => $supplierId, 'processed' => count($done), 'ids' => $done], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }

    fail(400, 'Invalid mode. Use mode=suppliers or mode=products.');
} catch (Throwable $e) {
    fail(500, $e->getMessage());
}
