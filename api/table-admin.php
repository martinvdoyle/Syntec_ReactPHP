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
function sanitizeAnchorId($value): ?string {
    if ($value === null) return null;
    $s = trim((string)$value);
    if ($s === '') return null;
    $s = strtolower($s);
    $s = str_replace([' ', '/'], '-', $s);
    $s = preg_replace('/[^a-z0-9_-]+/', '-', $s) ?? '';
    $s = preg_replace('/-+/', '-', $s) ?? '';
    $s = trim($s, '-');
    return $s === '' ? null : $s;
}

$allowedTables = [
    'syntec_discipline',
    'syntec_product_group',
    'syntec_product_type',
    'syntec_divisions',
    'syntec_job_titles',
    'syntec_message_enquiry_type',
    'syntec_message_types',
    'syntec_sources',
    'syntec_users',
    'syntec_messages',
];
$primaryKeyMap = [
    'syntec_discipline' => 'discipline_id',
    'syntec_product_group' => 'product_group_id',
    'syntec_product_type' => 'product_type_id',
    'syntec_divisions' => 'division_id',
    'syntec_job_titles' => 'job_title_id',
    'syntec_message_enquiry_type' => 'enquiry_type_id',
    'syntec_message_types' => 'message_type_id',
    'syntec_sources' => 'source_type_id',
    'syntec_users' => 'user_id',
    'syntec_messages' => 'message_id',
];

try {
    $pdo = db();
    $method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
    $table = (string)($_GET['table'] ?? '');
    $lang = strtolower(trim((string)($_GET['lang'] ?? 'en')));
    if (!in_array($lang, ['en', 'fr', 'it'], true)) {
        $lang = 'en';
    }

    if (!in_array($table, $allowedTables, true)) {
        badRequest('Invalid table parameter.');
    }

    $pk = $primaryKeyMap[$table] ?? null;
    if (!$pk) badRequest('Primary key mapping missing for table.');

    $colStmt = $pdo->query("SHOW COLUMNS FROM {$table}");
    $columns = array_map(static fn(array $r): string => $r['Field'], $colStmt->fetchAll());
    if (!$columns) badRequest('Table columns not found.');

    if ($method === 'GET') {
        if ($table === 'syntec_discipline') {
            $sql = "SELECT d.*,
                           COALESCE(di_req.discipline_name, di_en.discipline_name, d.discipline_name) AS discipline_name
                    FROM syntec_discipline d
                    LEFT JOIN syntec_discipline_i18n di_req
                      ON di_req.discipline_id = d.discipline_id
                     AND di_req.lang = :lang
                    LEFT JOIN syntec_discipline_i18n di_en
                      ON di_en.discipline_id = d.discipline_id
                     AND di_en.lang = 'en'
                    ORDER BY d.{$pk} DESC";
            $stmt = $pdo->prepare($sql);
            $stmt->execute(['lang' => $lang]);
            $rows = $stmt->fetchAll();
        } else {
            $rows = $pdo->query("SELECT * FROM {$table} ORDER BY {$pk} DESC")->fetchAll();
        }
        echo json_encode(['ok' => true, 'items' => $rows, 'columns' => $columns], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }

    if ($method === 'POST') {
        $in = readJson();
        if (array_key_exists('anchor_id', $in)) {
            $in['anchor_id'] = sanitizeAnchorId($in['anchor_id']);
        }
        if ($table === 'syntec_discipline') {
            // Keep base Oracle-parity name in sync for English only.
            $baseName = $in['discipline_name_base'] ?? (($lang === 'en') ? ($in['discipline_name'] ?? null) : null);
            if ($baseName !== null) {
                $in['discipline_name'] = $baseName;
            } else {
                unset($in['discipline_name']);
            }
        }
        $insCols = array_values(array_filter($columns, static fn(string $c): bool => array_key_exists($c, $in)));
        if (!$insCols) badRequest('No insertable fields provided.');

        $colSql = implode(',', $insCols);
        $valSql = implode(',', array_map(static fn(string $c): string => ':' . $c, $insCols));
        $stmt = $pdo->prepare("INSERT INTO {$table} ({$colSql}) VALUES ({$valSql})");
        $params = [];
        foreach ($insCols as $c) {
            $params[$c] = $in[$c];
        }
        $stmt->execute($params);
        if ($table === 'syntec_discipline') {
            $disciplineId = (string)($in['discipline_id'] ?? '');
            if ($disciplineId !== '' && array_key_exists('discipline_name', $in)) {
                $up = $pdo->prepare("INSERT INTO syntec_discipline_i18n (discipline_id, lang, discipline_name)
                                     VALUES (:discipline_id, :lang, :discipline_name)
                                     ON DUPLICATE KEY UPDATE discipline_name = VALUES(discipline_name)");
                $up->execute([
                    'discipline_id' => $disciplineId,
                    'lang' => $lang,
                    'discipline_name' => $in['discipline_name'],
                ]);
            }
        }
        echo json_encode(['ok' => true, 'key' => $in[$pk] ?? null]);
        exit;
    }

    if ($method === 'PUT') {
        $in = readJson();
        if (array_key_exists('anchor_id', $in)) {
            $in['anchor_id'] = sanitizeAnchorId($in['anchor_id']);
        }
        $key = (string)($in[$pk] ?? '');
        if ($key === '') badRequest("{$pk} is required.");
        if ($table === 'syntec_discipline') {
            $baseName = $in['discipline_name_base'] ?? (($lang === 'en') ? ($in['discipline_name'] ?? null) : null);
            if ($baseName !== null) {
                $in['discipline_name'] = $baseName;
            } else {
                unset($in['discipline_name']);
            }
        }

        $updCols = array_values(array_filter($columns, static fn(string $c): bool => $c !== $pk && array_key_exists($c, $in)));
        if ($updCols) {
            $setSql = implode(',', array_map(static fn(string $c): string => "{$c} = :{$c}", $updCols));
            $stmt = $pdo->prepare("UPDATE {$table} SET {$setSql} WHERE {$pk} = :__pk");
            $params = ['__pk' => $key];
            foreach ($updCols as $c) {
                $params[$c] = $in[$c];
            }
            $stmt->execute($params);
        }
        if ($table === 'syntec_discipline' && array_key_exists('discipline_name', $in)) {
            $up = $pdo->prepare("INSERT INTO syntec_discipline_i18n (discipline_id, lang, discipline_name)
                                 VALUES (:discipline_id, :lang, :discipline_name)
                                 ON DUPLICATE KEY UPDATE discipline_name = VALUES(discipline_name)");
            $up->execute([
                'discipline_id' => $key,
                'lang' => $lang,
                'discipline_name' => $in['discipline_name'],
            ]);
        } elseif (!$updCols) {
            badRequest('No updatable fields provided.');
        }
        echo json_encode(['ok' => true]);
        exit;
    }

    if ($method === 'DELETE') {
        $key = (string)($_GET[$pk] ?? '');
        if ($key === '') badRequest("{$pk} is required.");
        $stmt = $pdo->prepare("DELETE FROM {$table} WHERE {$pk} = :__pk");
        $stmt->execute(['__pk' => $key]);
        echo json_encode(['ok' => true]);
        exit;
    }

    http_response_code(405);
    echo json_encode(['ok' => false, 'error' => 'Method not allowed']);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
