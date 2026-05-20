<?php

declare(strict_types=1);

require __DIR__ . '/config/cors.php';
require __DIR__ . '/config/db.php';

try {
    $includeHidden = isset($_GET['include_hidden']) && $_GET['include_hidden'] === '1';
    $business = $_GET['business'] ?? 'Ireland';
    $website = $_GET['website'] ?? 'Syntec Scientific';

    $sql = <<<'SQL'
SELECT
    id,
    parent_id,
    menu_name,
    sub_menu_name,
    url,
    url_mobile,
    icon_class,
    sub_menu_level_id,
    business,
    website,
    menu_order,
    menu_id_order,
    menu_order_clone,
    enabled,
    css_class
FROM syntec_menu_items
WHERE (
    business = :business OR business IS NULL OR business = ''
  )
  AND (
    website = :website OR website IS NULL OR website = ''
  )
SQL;

    if (!$includeHidden) {
        $sql .= " AND COALESCE(enabled, 'Y') = 'Y'";
    }

    $sql .= ' ORDER BY COALESCE(menu_order_clone, menu_order, menu_id_order, 0) ASC, id ASC';

    $stmt = db()->prepare($sql);
    $stmt->execute(['business' => $business, 'website' => $website]);
    $rows = $stmt->fetchAll();

    $items = array_map(static function (array $row): array {
        return [
            'id' => (int) $row['id'],
            'parentId' => $row['parent_id'] !== null ? (int) $row['parent_id'] : null,
            'title' => (string) (($row['sub_menu_name'] ?? '') !== '' ? $row['sub_menu_name'] : ($row['menu_name'] ?? '')),
            'url' => $row['url'] !== null ? (string) $row['url'] : null,
            'urlMobile' => $row['url_mobile'] !== null ? (string) $row['url_mobile'] : null,
            'iconClass' => $row['icon_class'] !== null ? (string) $row['icon_class'] : null,
            'menuLevel' => $row['sub_menu_level_id'] !== null ? (string) $row['sub_menu_level_id'] : null,
            'business' => $row['business'] !== null ? (string) $row['business'] : null,
            'website' => $row['website'] !== null ? (string) $row['website'] : null,
            'sortOrder' => (int) ($row['menu_order_clone'] ?? $row['menu_order'] ?? $row['menu_id_order'] ?? 0),
            'visible' => strtoupper((string) ($row['enabled'] ?? 'Y')) === 'Y',
            'cssClass' => $row['css_class'] !== null ? (string) $row['css_class'] : null,
        ];
    }, $rows);

    $indexed = [];
    foreach ($items as $item) {
        $item['children'] = [];
        $indexed[$item['id']] = $item;
    }

    $tree = [];
    foreach ($indexed as $id => $node) {
        $parentId = $node['parentId'];
        if ($parentId !== null && isset($indexed[$parentId])) {
            $indexed[$parentId]['children'][] = &$indexed[$id];
        } else {
            $tree[] = &$indexed[$id];
        }
    }

    echo json_encode([
        'ok' => true,
        'context' => ['business' => $business, 'website' => $website],
        'count' => count($items),
        'tree' => array_values($tree),
        'items' => $items,
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode([
        'ok' => false,
        'error' => 'Failed to load menu.',
        'details' => $e->getMessage(),
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
}
