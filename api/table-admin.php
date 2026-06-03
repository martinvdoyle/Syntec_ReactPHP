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
    $s = str_replace([' ', '/', '_'], '-', $s);
    $s = preg_replace('/[^a-z0-9-]+/', '-', $s) ?? '';
    $s = preg_replace('/-+/', '-', $s) ?? '';
    $s = trim($s, '-');
    return $s === '' ? null : $s;
}
function tableExists(PDO $pdo, string $tableName): bool {
    $stmt = $pdo->prepare("SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = :t LIMIT 1");
    $stmt->execute(['t' => $tableName]);
    return (bool)$stmt->fetchColumn();
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
$i18nConfig = [
    'syntec_discipline' => ['table' => 'syntec_discipline_i18n', 'pk' => 'discipline_id', 'field' => 'discipline_name'],
    'syntec_product_group' => ['table' => 'syntec_product_group_i18n', 'pk' => 'product_group_id', 'field' => 'product_group_name'],
    'syntec_product_type' => ['table' => 'syntec_product_type_i18n', 'pk' => 'product_type_id', 'field' => 'product_type_name'],
    'syntec_divisions' => ['table' => 'syntec_divisions_i18n', 'pk' => 'division_id', 'field' => 'division_description'],
    'syntec_job_titles' => ['table' => 'syntec_job_titles_i18n', 'pk' => 'job_title_id', 'field' => 'job_title_description'],
    'syntec_message_enquiry_type' => ['table' => 'syntec_message_enquiry_type_i18n', 'pk' => 'enquiry_type_id', 'field' => 'enquiry_type_description'],
    'syntec_message_types' => ['table' => 'syntec_message_types_i18n', 'pk' => 'message_type_id', 'field' => 'message_description'],
    'syntec_sources' => ['table' => 'syntec_sources_i18n', 'pk' => 'source_type_id', 'field' => 'source_description'],
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
        if (isset($i18nConfig[$table]) && tableExists($pdo, $i18nConfig[$table]['table'])) {
            $cfg = $i18nConfig[$table];
            $i18nTable = $cfg['table'];
            $i18nPk = $cfg['pk'];
            $i18nField = $cfg['field'];
            $sql = "SELECT d.*,
                           COALESCE(di_req.{$i18nField}, d.{$i18nField}) AS {$i18nField}
                    FROM {$table} d
                    LEFT JOIN {$i18nTable} di_req
                      ON di_req.{$i18nPk} = d.{$i18nPk}
                     AND di_req.lang = :lang
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
        if (isset($i18nConfig[$table])) {
            $cfg = $i18nConfig[$table];
            $field = $cfg['field'];
            $baseName = $in[$field . '_base'] ?? (($lang === 'en') ? ($in[$field] ?? null) : null);
            if ($baseName !== null) $in[$field] = $baseName;
            else unset($in[$field]);
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
        if (isset($i18nConfig[$table]) && tableExists($pdo, $i18nConfig[$table]['table'])) {
            $cfg = $i18nConfig[$table];
            $rowId = (string)($in[$cfg['pk']] ?? '');
            $field = $cfg['field'];
            if ($rowId !== '' && array_key_exists($field, $in)) {
                $seedVal = (string)($in[$field] ?? '');
                $up = $pdo->prepare("INSERT INTO {$cfg['table']} ({$cfg['pk']}, lang, {$field})
                                     VALUES (:row_id, :lang, :field_val)
                                     ON DUPLICATE KEY UPDATE {$field} = VALUES({$field})");
                foreach (['fr', 'it'] as $seedLang) {
                    $fieldVal = $seedVal;
                    if ($lang !== 'en' && $lang === $seedLang) {
                        $fieldVal = (string)($in[$field] ?? '');
                    }
                    $up->execute([
                        'row_id' => $rowId,
                        'lang' => $seedLang,
                        'field_val' => $fieldVal,
                    ]);
                }
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
        if (isset($i18nConfig[$table])) {
            $cfg = $i18nConfig[$table];
            $field = $cfg['field'];
            $baseName = $in[$field . '_base'] ?? (($lang === 'en') ? ($in[$field] ?? null) : null);
            if ($baseName !== null) $in[$field] = $baseName;
            else unset($in[$field]);
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
        if (isset($i18nConfig[$table]) && tableExists($pdo, $i18nConfig[$table]['table'])) {
            $cfg = $i18nConfig[$table];
            $field = $cfg['field'];
            if (array_key_exists($field, $in) && $lang !== 'en') {
                $up = $pdo->prepare("INSERT INTO {$cfg['table']} ({$cfg['pk']}, lang, {$field})
                                     VALUES (:row_id, :lang, :field_val)
                                     ON DUPLICATE KEY UPDATE {$field} = VALUES({$field})");
                $up->execute([
                    'row_id' => $key,
                    'lang' => $lang,
                    'field_val' => $in[$field],
                ]);
            }
        }
        if (!$updCols && !(isset($i18nConfig[$table]) && isset($field) && array_key_exists($field, $in) && $lang !== 'en')) {
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
