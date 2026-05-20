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

function nextMenuId(PDO $pdo, ?string $parentMenuId): string {
    if ($parentMenuId === null || $parentMenuId === '') {
        $stmt = $pdo->query("SELECT menu_id FROM syntec_menu_items WHERE menu_id REGEXP '^M[0-9]+$' ORDER BY CAST(SUBSTRING(menu_id,2) AS UNSIGNED) DESC LIMIT 1");
        $last = (string)($stmt->fetchColumn() ?: 'M0');
        $n = (int)substr($last, 1) + 1;
        return 'M' . $n;
    }

    $stmt = $pdo->prepare('SELECT menu_id FROM syntec_menu_items WHERE parent_id = (SELECT id FROM syntec_menu_items WHERE menu_id = :parent LIMIT 1) AND menu_id LIKE :prefix ORDER BY menu_id DESC');
    $stmt->execute(['parent' => $parentMenuId, 'prefix' => $parentMenuId . '-%']);
    $rows = $stmt->fetchAll(PDO::FETCH_COLUMN) ?: [];
    $max = 0;
    foreach ($rows as $id) {
        if (preg_match('/-(\d+)$/', (string)$id, $m)) {
            $max = max($max, (int)$m[1]);
        }
    }
    return $parentMenuId . '-' . ($max + 1);
}

function nextLevel(?string $parentLevel): string {
    $map = ['L0' => 'L1', 'L1' => 'L2', 'L2' => 'L3', 'L3' => 'L3'];
    if ($parentLevel === null || $parentLevel === '') return 'L0';
    $p = strtoupper(trim($parentLevel));
    return $map[$p] ?? 'L0';
}

try {
    $pdo = db();
    $method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

    if ($method === 'GET') {
        if (isset($_GET['next_menu_id'])) {
            $parentMenuId = isset($_GET['parent_menu_id']) ? trim((string)$_GET['parent_menu_id']) : null;
            $nextLevel = 'L0';
            if ($parentMenuId) {
                $stmt = $pdo->prepare('SELECT sub_menu_level_id FROM syntec_menu_items WHERE menu_id=:menu_id LIMIT 1');
                $stmt->execute(['menu_id' => $parentMenuId]);
                $parentLevel = $stmt->fetchColumn();
                $nextLevel = nextLevel($parentLevel !== false ? (string)$parentLevel : null);
            }
            echo json_encode(['ok' => true, 'nextMenuId' => nextMenuId($pdo, $parentMenuId ?: null), 'nextLevel' => $nextLevel]);
            exit;
        }

        if (isset($_GET['reorder']) && isset($_GET['id']) && isset($_GET['direction'])) {
            $id = (int)$_GET['id'];
            $direction = strtolower((string)$_GET['direction']);
            if (!in_array($direction, ['up', 'down'], true)) badRequest('direction must be up or down');

            $stmt = $pdo->prepare("SELECT id,parent_id,COALESCE(menu_order_clone,menu_order,menu_id_order,0) AS ord FROM syntec_menu_items WHERE id=:id LIMIT 1");
            $stmt->execute(['id' => $id]);
            $current = $stmt->fetch();
            if (!$current) badRequest('menu item not found');

            $cmp = $direction === 'up' ? '<' : '>';
            $sort = $direction === 'up' ? 'DESC' : 'ASC';
            $stmt = $pdo->prepare("SELECT id,COALESCE(menu_order_clone,menu_order,menu_id_order,0) AS ord FROM syntec_menu_items WHERE " .
                ($current['parent_id'] === null ? 'parent_id IS NULL' : 'parent_id=:pid') .
                " AND COALESCE(menu_order_clone,menu_order,menu_id_order,0) {$cmp} :ord ORDER BY COALESCE(menu_order_clone,menu_order,menu_id_order,0) {$sort}, id {$sort} LIMIT 1");
            $params = ['ord' => $current['ord']];
            if ($current['parent_id'] !== null) $params['pid'] = (int)$current['parent_id'];
            $stmt->execute($params);
            $swap = $stmt->fetch();
            if ($swap) {
                $u = $pdo->prepare("UPDATE syntec_menu_items SET menu_order_clone=:ord WHERE id=:id");
                $u->execute(['ord' => $swap['ord'], 'id' => $current['id']]);
                $u->execute(['ord' => $current['ord'], 'id' => $swap['id']]);
            }
            echo json_encode(['ok' => true]);
            exit;
        }

        $rows = $pdo->query("SELECT id,parent_id,menu_id,menu_name,sub_menu_name,sub_menu_id,sub_menu_level_id,sub_menu_text,icon_class,css_class,url,url_mobile,business,business_set,website,website_set,website_anchor,enabled,menu_order,menu_id_order,menu_order_clone,product_type,discipline_id,product_group_id,supplier_id,product_id,oracle_parent_id FROM syntec_menu_items ORDER BY COALESCE(menu_order_clone,menu_order,menu_id_order,0), id")->fetchAll();
        echo json_encode(['ok' => true, 'items' => $rows], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }

    if ($method === 'POST') {
        $in = readJson();
        $menuId = trim((string)($in['menu_id'] ?? ''));
        $menuName = trim((string)($in['menu_name'] ?? ''));
        if ($menuId === '' || $menuName === '') badRequest('menu_id and menu_name are required.');

        $parentId = null;
        $parentMenuId = trim((string)($in['parent_menu_id'] ?? ''));
        if ($parentMenuId !== '') {
            $stmt = $pdo->prepare('SELECT id FROM syntec_menu_items WHERE menu_id = :menu_id LIMIT 1');
            $stmt->execute(['menu_id' => $parentMenuId]);
            $parentId = $stmt->fetchColumn();
            if (!$parentId) badRequest('parent_menu_id not found.');
        }

        $stmt = $pdo->prepare("INSERT INTO syntec_menu_items (parent_id,menu_id,menu_name,sub_menu_name,sub_menu_id,sub_menu_level_id,sub_menu_text,icon_class,css_class,url,url_mobile,business,business_set,website,website_set,website_anchor,enabled,menu_order,menu_id_order,menu_order_clone,product_type,discipline_id,product_group_id,supplier_id,product_id,oracle_parent_id)
VALUES (:parent_id,:menu_id,:menu_name,:sub_menu_name,:sub_menu_id,:sub_menu_level_id,:sub_menu_text,:icon_class,:css_class,:url,:url_mobile,:business,:business_set,:website,:website_set,:website_anchor,:enabled,:menu_order,:menu_id_order,:menu_order_clone,:product_type,:discipline_id,:product_group_id,:supplier_id,:product_id,:oracle_parent_id)");
        $stmt->execute([
            'parent_id' => $parentId ?: null,
            'menu_id' => $menuId,
            'menu_name' => $menuName,
            'sub_menu_name' => $in['sub_menu_name'] ?? null,
            'sub_menu_id' => $in['sub_menu_id'] ?? null,
            'sub_menu_level_id' => $in['sub_menu_level_id'] ?? null,
            'sub_menu_text' => $in['sub_menu_text'] ?? null,
            'icon_class' => $in['icon_class'] ?? null,
            'css_class' => $in['css_class'] ?? null,
            'url' => $in['url'] ?? null,
            'url_mobile' => $in['url_mobile'] ?? null,
            'business' => $in['business'] ?? null,
            'business_set' => $in['business_set'] ?? null,
            'website' => $in['website'] ?? null,
            'website_set' => $in['website_set'] ?? null,
            'website_anchor' => $in['website_anchor'] ?? null,
            'enabled' => $in['enabled'] ?? 'Y',
            'menu_order' => $in['menu_order'] ?? null,
            'menu_id_order' => $in['menu_id_order'] ?? null,
            'menu_order_clone' => $in['menu_order_clone'] ?? null,
            'product_type' => $in['product_type'] ?? null,
            'discipline_id' => $in['discipline_id'] ?? null,
            'product_group_id' => $in['product_group_id'] ?? null,
            'supplier_id' => $in['supplier_id'] ?? null,
            'product_id' => $in['product_id'] ?? null,
            'oracle_parent_id' => $in['oracle_parent_id'] ?? null,
        ]);
        echo json_encode(['ok' => true, 'id' => (int)$pdo->lastInsertId()]);
        exit;
    }

    if ($method === 'PUT') {
        $in = readJson();
        $id = (int)($in['id'] ?? 0);
        if ($id <= 0) badRequest('id is required.');

        $parentId = null;
        $parentMenuId = trim((string)($in['parent_menu_id'] ?? ''));
        if ($parentMenuId !== '') {
            $stmt = $pdo->prepare('SELECT id FROM syntec_menu_items WHERE menu_id = :menu_id LIMIT 1');
            $stmt->execute(['menu_id' => $parentMenuId]);
            $parentId = $stmt->fetchColumn();
            if (!$parentId) badRequest('parent_menu_id not found.');
        }

        $stmt = $pdo->prepare("UPDATE syntec_menu_items SET parent_id=:parent_id,menu_id=:menu_id,menu_name=:menu_name,sub_menu_name=:sub_menu_name,sub_menu_id=:sub_menu_id,sub_menu_level_id=:sub_menu_level_id,sub_menu_text=:sub_menu_text,icon_class=:icon_class,css_class=:css_class,url=:url,url_mobile=:url_mobile,business=:business,business_set=:business_set,website=:website,website_set=:website_set,website_anchor=:website_anchor,enabled=:enabled,menu_order=:menu_order,menu_id_order=:menu_id_order,menu_order_clone=:menu_order_clone,product_type=:product_type,discipline_id=:discipline_id,product_group_id=:product_group_id,supplier_id=:supplier_id,product_id=:product_id,oracle_parent_id=:oracle_parent_id WHERE id=:id");
        $stmt->execute([
            'id' => $id,
            'parent_id' => $parentId ?: null,
            'menu_id' => $in['menu_id'] ?? null,
            'menu_name' => $in['menu_name'] ?? null,
            'sub_menu_name' => $in['sub_menu_name'] ?? null,
            'sub_menu_id' => $in['sub_menu_id'] ?? null,
            'sub_menu_level_id' => $in['sub_menu_level_id'] ?? null,
            'sub_menu_text' => $in['sub_menu_text'] ?? null,
            'icon_class' => $in['icon_class'] ?? null,
            'css_class' => $in['css_class'] ?? null,
            'url' => $in['url'] ?? null,
            'url_mobile' => $in['url_mobile'] ?? null,
            'business' => $in['business'] ?? null,
            'business_set' => $in['business_set'] ?? null,
            'website' => $in['website'] ?? null,
            'website_set' => $in['website_set'] ?? null,
            'website_anchor' => $in['website_anchor'] ?? null,
            'enabled' => $in['enabled'] ?? 'Y',
            'menu_order' => $in['menu_order'] ?? null,
            'menu_id_order' => $in['menu_id_order'] ?? null,
            'menu_order_clone' => $in['menu_order_clone'] ?? null,
            'product_type' => $in['product_type'] ?? null,
            'discipline_id' => $in['discipline_id'] ?? null,
            'product_group_id' => $in['product_group_id'] ?? null,
            'supplier_id' => $in['supplier_id'] ?? null,
            'product_id' => $in['product_id'] ?? null,
            'oracle_parent_id' => $in['oracle_parent_id'] ?? null,
        ]);
        echo json_encode(['ok' => true]);
        exit;
    }

    if ($method === 'DELETE') {
        $id = (int)($_GET['id'] ?? 0);
        if ($id <= 0) badRequest('id is required.');
        $stmt = $pdo->prepare('DELETE FROM syntec_menu_items WHERE id = :id');
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
