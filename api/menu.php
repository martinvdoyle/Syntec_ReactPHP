<?php

declare(strict_types=1);

require __DIR__ . '/config/cors.php';
require __DIR__ . '/config/db.php';

try {
    $menuKey = $_GET['menu_key'] ?? 'main';
    $includeHidden = isset($_GET['include_hidden']) && $_GET['include_hidden'] === '1';

    $sql = <<<'SQL'
SELECT
    id,
    parent_id,
    title,
    url,
    route,
    menu_type,
    description,
    image_path,
    sort_order,
    visible,
    target,
    css_class
FROM syntec_menu_items
WHERE menu_key = :menu_key
SQL;

    if (!$includeHidden) {
        $sql .= ' AND visible = 1';
    }

    $sql .= ' ORDER BY sort_order ASC, id ASC';

    $stmt = db()->prepare($sql);
    $stmt->execute(['menu_key' => $menuKey]);
    $rows = $stmt->fetchAll();

    $items = array_map(static function (array $row): array {
        return [
            'id' => (int) $row['id'],
            'parentId' => $row['parent_id'] !== null ? (int) $row['parent_id'] : null,
            'title' => (string) $row['title'],
            'url' => $row['url'] !== null ? (string) $row['url'] : null,
            'route' => $row['route'] !== null ? (string) $row['route'] : null,
            'menuType' => (string) $row['menu_type'],
            'description' => $row['description'] !== null ? (string) $row['description'] : null,
            'imagePath' => $row['image_path'] !== null ? (string) $row['image_path'] : null,
            'sortOrder' => (int) $row['sort_order'],
            'visible' => (bool) $row['visible'],
            'target' => $row['target'] !== null ? (string) $row['target'] : '_self',
            'cssClass' => $row['css_class'] !== null ? (string) $row['css_class'] : null,
        ];
    }, $rows);

    echo json_encode([
        'ok' => true,
        'menuKey' => $menuKey,
        'count' => count($items),
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
