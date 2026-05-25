<?php
declare(strict_types=1);

require __DIR__ . '/config/cors.php';
require __DIR__ . '/config/db.php';
header('Content-Type: application/json; charset=utf-8');

function out(array $x, int $code = 200): void { http_response_code($code); echo json_encode($x, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES); exit; }
function bad(string $m): void { out(['ok'=>false,'error'=>$m], 400); }
function readJson(): array { $r=file_get_contents('php://input')?:''; if($r==='') return []; $j=json_decode($r,true); if(!is_array($j)) bad('Invalid JSON.'); return $j; }
function isLang(string $x): bool { return (bool)preg_match('/^[a-z]{2,5}$/', strtolower(trim($x))); }
function tableExists(PDO $pdo, string $t): bool {
  $s=$pdo->prepare("SELECT 1 FROM information_schema.tables WHERE table_schema=DATABASE() AND table_name=:t LIMIT 1");
  $s->execute(['t'=>$t]); return (bool)$s->fetchColumn();
}

try {
  $pdo = db();
  $m = $_SERVER['REQUEST_METHOD'] ?? 'GET';
  $mode = (string)($_GET['mode'] ?? '');

  $seedDefs = [
    ['base'=>'syntec_suppliers','i18n'=>'syntec_suppliers_i18n','pk'=>'supplier_id','cols'=>['profile_1','profile_2']],
    ['base'=>'syntec_products','i18n'=>'syntec_product_i18n','pk'=>'product_id','cols'=>['product_name','short_name','about_1','about_2']],
    ['base'=>'syntec_discipline','i18n'=>'syntec_discipline_i18n','pk'=>'discipline_id','cols'=>['discipline_name']],
    ['base'=>'syntec_product_group','i18n'=>'syntec_product_group_i18n','pk'=>'product_group_id','cols'=>['product_group_name']],
    ['base'=>'syntec_product_type','i18n'=>'syntec_product_type_i18n','pk'=>'product_type_id','cols'=>['product_type_name']],
    ['base'=>'syntec_divisions','i18n'=>'syntec_divisions_i18n','pk'=>'division_id','cols'=>['division_description']],
    ['base'=>'syntec_job_titles','i18n'=>'syntec_job_titles_i18n','pk'=>'job_title_id','cols'=>['job_title_description']],
    ['base'=>'syntec_message_enquiry_type','i18n'=>'syntec_message_enquiry_type_i18n','pk'=>'enquiry_type_id','cols'=>['enquiry_type_description']],
    ['base'=>'syntec_message_types','i18n'=>'syntec_message_types_i18n','pk'=>'message_type_id','cols'=>['message_description']],
    ['base'=>'syntec_sources','i18n'=>'syntec_sources_i18n','pk'=>'source_type_id','cols'=>['source_description']],
  ];

  if ($m === 'GET') {
    if ($mode === 'impact') {
      $lang = strtolower(trim((string)($_GET['lang_code'] ?? '')));
      if ($lang === '' || !isLang($lang)) bad('lang_code is required.');
      $tot = ['i18n_rows'=>0,'by_table'=>[]];
      foreach ($seedDefs as $d) {
        if (!tableExists($pdo, $d['i18n'])) continue;
        $s = $pdo->prepare("SELECT COUNT(*) FROM {$d['i18n']} WHERE lang = :lang");
        $s->execute(['lang'=>$lang]);
        $c = (int)$s->fetchColumn();
        $tot['by_table'][$d['i18n']] = $c;
        $tot['i18n_rows'] += $c;
      }
      out(['ok'=>true,'impact'=>$tot]);
    }
    $rows = $pdo->query("SELECT lang_code, lang_name, flag_path, is_active, sort_order FROM syntec_languages ORDER BY sort_order, lang_code")->fetchAll();
    out(['ok'=>true,'items'=>$rows]);
  }

  if ($m === 'POST') {
    $in = readJson();
    $lang = strtolower(trim((string)($in['lang_code'] ?? '')));
    $name = trim((string)($in['lang_name'] ?? ''));
    if (!isLang($lang)) bad('Invalid lang_code.');
    if ($name === '') bad('lang_name is required.');
    $flag = trim((string)($in['flag_path'] ?? ''));
    $active = strtoupper(trim((string)($in['is_active'] ?? 'Y'))) === 'N' ? 'N' : 'Y';
    $sort = (int)($in['sort_order'] ?? 100);

    $up = $pdo->prepare("INSERT INTO syntec_languages (lang_code, lang_name, flag_path, is_active, sort_order) VALUES (:c,:n,:f,:a,:s)
                         ON DUPLICATE KEY UPDATE lang_name=VALUES(lang_name), flag_path=VALUES(flag_path), is_active=VALUES(is_active), sort_order=VALUES(sort_order)");
    $up->execute(['c'=>$lang,'n'=>$name,'f'=>$flag === '' ? null : $flag,'a'=>$active,'s'=>$sort]);

    if ($lang !== 'en') {
      foreach ($seedDefs as $d) {
        if (!tableExists($pdo, $d['base']) || !tableExists($pdo, $d['i18n'])) continue;
        $colList = implode(',', $d['cols']);
        $selCols = implode(',', array_map(static fn($c) => "b.{$c}", $d['cols']));
        $setUpd = implode(',', array_map(static fn($c) => "{$c}=VALUES({$c})", $d['cols']));
        $sql = "INSERT INTO {$d['i18n']} ({$d['pk']}, lang, {$colList})
                SELECT b.{$d['pk']}, :lang, {$selCols}
                FROM {$d['base']} b
                WHERE NOT EXISTS (
                  SELECT 1 FROM {$d['i18n']} x WHERE x.{$d['pk']} = b.{$d['pk']} AND x.lang = :lang2
                )";
        $pdo->prepare($sql)->execute(['lang'=>$lang,'lang2'=>$lang]);
      }
    }
    out(['ok'=>true]);
  }

  if ($m === 'DELETE') {
    $lang = strtolower(trim((string)($_GET['lang_code'] ?? '')));
    if ($lang === '' || !isLang($lang)) bad('lang_code is required.');
    if ($lang === 'en') bad('Cannot delete base language en.');
    $confirm = (int)($_GET['confirm'] ?? 0) === 1;
    $tot = ['i18n_rows'=>0,'by_table'=>[]];
    foreach ($seedDefs as $d) {
      if (!tableExists($pdo, $d['i18n'])) continue;
      $s = $pdo->prepare("SELECT COUNT(*) FROM {$d['i18n']} WHERE lang = :lang");
      $s->execute(['lang'=>$lang]);
      $c = (int)$s->fetchColumn();
      $tot['by_table'][$d['i18n']] = $c;
      $tot['i18n_rows'] += $c;
    }
    if (!$confirm) out(['ok'=>true,'impact_only'=>true,'impact'=>$tot]);
    foreach ($seedDefs as $d) {
      if (!tableExists($pdo, $d['i18n'])) continue;
      $pdo->prepare("DELETE FROM {$d['i18n']} WHERE lang = :lang")->execute(['lang'=>$lang]);
    }
    $pdo->prepare("DELETE FROM syntec_languages WHERE lang_code = :lang")->execute(['lang'=>$lang]);
    out(['ok'=>true,'deleted_lang'=>$lang,'impact'=>$tot]);
  }

  out(['ok'=>false,'error'=>'Method not allowed'], 405);
} catch (Throwable $e) {
  out(['ok'=>false,'error'=>$e->getMessage()], 500);
}

