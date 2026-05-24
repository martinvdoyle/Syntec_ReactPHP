<?php

declare(strict_types=1);

function loadTranslateLocalConfig(): void
{
    static $loaded = false;
    if ($loaded) return;
    $loaded = true;
    $localConfig = dirname(__DIR__, 2) . '/translate-config.local.php';
    if (is_file($localConfig)) {
        $before = get_defined_vars();
        require $localConfig;
        foreach (['_TRANSLATE_ENABLED', '_TRANSLATE_PROVIDER', '_BACKFILL_TOKEN', '_OPENAI_API_KEY', '_OPENAI_TRANSLATE_MODEL'] as $name) {
            if (array_key_exists($name, get_defined_vars())) {
                $GLOBALS[$name] = get_defined_vars()[$name];
            }
        }
    }
}

function isTranslateEnabled(): bool
{
    loadTranslateLocalConfig();
    global $_TRANSLATE_ENABLED;
    $v = (string)($_TRANSLATE_ENABLED ?? (getenv('TRANSLATE_ENABLED') ?: '0'));
    $v = strtolower(trim($v));
    return in_array($v, ['1', 'true', 'yes', 'on'], true);
}

function getTranslateProvider(): string
{
    loadTranslateLocalConfig();
    global $_TRANSLATE_PROVIDER;
    $p = (string)($_TRANSLATE_PROVIDER ?? (getenv('TRANSLATE_PROVIDER') ?: 'best_effort'));
    $p = strtolower(trim($p));
    return $p === 'openai' ? 'openai' : 'best_effort';
}

function translateTextBestEffort(string $text, string $targetLang): string
{
    $prefix = $targetLang === 'fr' ? '[FR draft] ' : ($targetLang === 'it' ? '[IT draft] ' : '');
    if ($prefix === '') return $text;

    // Stronger placeholder translator for demo mode:
    // - keeps HTML tags intact
    // - applies phrase + word substitutions to text segments only
    $phraseMap = $targetLang === 'fr'
        ? [
            'about us' => 'à propos de nous',
            'contact us' => 'contactez-nous',
            'our products' => 'nos produits',
            'our services' => 'nos services',
            'product range' => 'gamme de produits',
            'learn more' => 'en savoir plus',
            'read more' => 'lire la suite',
            'high quality' => 'haute qualité',
            'customer support' => 'assistance client',
            'laboratory solutions' => 'solutions de laboratoire',
        ]
        : [
            'about us' => 'chi siamo',
            'contact us' => 'contattaci',
            'our products' => 'i nostri prodotti',
            'our services' => 'i nostri servizi',
            'product range' => 'gamma di prodotti',
            'learn more' => 'scopri di più',
            'read more' => 'leggi di più',
            'high quality' => 'alta qualità',
            'customer support' => 'supporto clienti',
            'laboratory solutions' => 'soluzioni di laboratorio',
        ];

    $wordMap = $targetLang === 'fr'
        ? [
            'supplier' => 'fournisseur',
            'suppliers' => 'fournisseurs',
            'product' => 'produit',
            'products' => 'produits',
            'service' => 'service',
            'services' => 'services',
            'quality' => 'qualité',
            'solution' => 'solution',
            'solutions' => 'solutions',
            'support' => 'assistance',
            'laboratory' => 'laboratoire',
            'diagnostics' => 'diagnostic',
            'research' => 'recherche',
            'medical' => 'médical',
            'scientific' => 'scientifique',
        ]
        : [
            'supplier' => 'fornitore',
            'suppliers' => 'fornitori',
            'product' => 'prodotto',
            'products' => 'prodotti',
            'service' => 'servizio',
            'services' => 'servizi',
            'quality' => 'qualità',
            'solution' => 'soluzione',
            'solutions' => 'soluzioni',
            'support' => 'supporto',
            'laboratory' => 'laboratorio',
            'diagnostics' => 'diagnostica',
            'research' => 'ricerca',
            'medical' => 'medico',
            'scientific' => 'scientifico',
        ];

    $parts = preg_split('/(<[^>]+>)/', $text, -1, PREG_SPLIT_DELIM_CAPTURE);
    if (!is_array($parts)) return $prefix . $text;

    $convert = static function (string $segment) use ($phraseMap, $wordMap): string {
        $out = $segment;
        foreach ($phraseMap as $en => $tr) {
            $out = preg_replace('/\b' . preg_quote($en, '/') . '\b/i', $tr, $out) ?? $out;
        }
        foreach ($wordMap as $en => $tr) {
            $out = preg_replace('/\b' . preg_quote($en, '/') . '\b/i', $tr, $out) ?? $out;
        }
        return $out;
    };

    $translated = '';
    foreach ($parts as $part) {
        if ($part === '') continue;
        if ($part[0] === '<') {
            $translated .= $part;
        } else {
            $translated .= $convert($part);
        }
    }

    return $prefix . $translated;
}

function translateTextOpenAI(string $text, string $targetLang): string
{
    $text = trim($text);
    if ($text === '') return '';

    loadTranslateLocalConfig();
    global $_OPENAI_API_KEY, $_OPENAI_TRANSLATE_MODEL;
    $apiKey = (string)($_OPENAI_API_KEY ?? (getenv('OPENAI_API_KEY') ?: ''));
    if ($apiKey === '') {
        throw new RuntimeException('OPENAI_API_KEY is missing.');
    }
    $model = (string)($_OPENAI_TRANSLATE_MODEL ?? (getenv('OPENAI_TRANSLATE_MODEL') ?: 'gpt-4.1-mini'));

    $payload = [
        'model' => $model,
        'input' => [[
            'role' => 'system',
            'content' => [
                ['type' => 'input_text', 'text' => 'Translate user-provided website copy. Preserve HTML tags and attributes exactly. Output only translated text.']
            ],
        ], [
            'role' => 'user',
            'content' => [
                ['type' => 'input_text', 'text' => "Target language: {$targetLang}\n\nText:\n{$text}"]
            ],
        ]],
    ];

    $ch = curl_init('https://api.openai.com/v1/responses');
    curl_setopt_array($ch, [
        CURLOPT_POST => true,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_HTTPHEADER => [
            'Authorization: Bearer ' . $apiKey,
            'Content-Type: application/json',
        ],
        CURLOPT_POSTFIELDS => json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES),
        CURLOPT_TIMEOUT => 60,
    ]);
    $raw = curl_exec($ch);
    if ($raw === false) {
        $err = curl_error($ch);
        curl_close($ch);
        throw new RuntimeException('Translation request failed: ' . $err);
    }
    $code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    $json = json_decode($raw, true);
    if ($code >= 400) {
        $msg = $json['error']['message'] ?? 'Translation API error.';
        throw new RuntimeException($msg);
    }
    $out = trim((string)($json['output_text'] ?? ''));
    if ($out === '') {
        throw new RuntimeException('Empty translation response.');
    }
    return $out;
}

function translateText(string $text, string $targetLang): string
{
    if (!isTranslateEnabled()) {
        return translateTextBestEffort($text, $targetLang);
    }
    if (getTranslateProvider() === 'openai') {
        return translateTextOpenAI($text, $targetLang);
    }
    return translateTextBestEffort($text, $targetLang);
}
