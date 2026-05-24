<?php

declare(strict_types=1);

require __DIR__ . '/../api/config/db.php';

/**
 * Rough estimator:
 * - tokens ~= chars / 4
 * - output tokens ~= input tokens * output_ratio
 */

$pdo = db();

// Update these to whichever model you plan to use.
$inputPerM = 0.75;   // USD per 1M input tokens (example: GPT-5.4 mini)
$outputPerM = 4.50;  // USD per 1M output tokens
$outputRatio = 1.05; // translated output length vs input tokens (rough)
$targetLanguages = 2; // FR + IT

function sumChars(PDO $pdo, string $sql): int {
    $row = $pdo->query($sql)->fetch();
    return (int)($row['chars_total'] ?? 0);
}

$supplierChars = sumChars(
    $pdo,
    "SELECT
      COALESCE(SUM(CHAR_LENGTH(COALESCE(profile_1, '')) + CHAR_LENGTH(COALESCE(profile_2, ''))), 0) AS chars_total
     FROM syntec_suppliers"
);

$productChars = sumChars(
    $pdo,
    "SELECT
      COALESCE(SUM(
        CHAR_LENGTH(COALESCE(product_name, '')) +
        CHAR_LENGTH(COALESCE(short_name, '')) +
        CHAR_LENGTH(COALESCE(about_1, '')) +
        CHAR_LENGTH(COALESCE(about_2, ''))
      ), 0) AS chars_total
     FROM syntec_products"
);

$totalChars = $supplierChars + $productChars;
$inputTokensPerLang = $totalChars / 4.0;
$outputTokensPerLang = $inputTokensPerLang * $outputRatio;

$inputTokensAll = $inputTokensPerLang * $targetLanguages;
$outputTokensAll = $outputTokensPerLang * $targetLanguages;

$inputCost = ($inputTokensAll / 1_000_000.0) * $inputPerM;
$outputCost = ($outputTokensAll / 1_000_000.0) * $outputPerM;
$totalCost = $inputCost + $outputCost;

echo "Translation Cost Estimator (rough)\n";
echo "---------------------------------\n";
echo "Suppliers chars: " . number_format($supplierChars) . "\n";
echo "Products  chars: " . number_format($productChars) . "\n";
echo "Total     chars: " . number_format($totalChars) . "\n";
echo "Targets languages: {$targetLanguages}\n";
echo "Input tokens total (all targets): " . number_format((int)round($inputTokensAll)) . "\n";
echo "Output tokens total (all targets): " . number_format((int)round($outputTokensAll)) . "\n";
echo "\n";
echo "Pricing used (USD / 1M): input={$inputPerM}, output={$outputPerM}\n";
echo "Estimated one-off backfill cost (USD):\n";
echo "  Input : $" . number_format($inputCost, 2) . "\n";
echo "  Output: $" . number_format($outputCost, 2) . "\n";
echo "  Total : $" . number_format($totalCost, 2) . "\n";
echo "\n";
echo "Notes:\n";
echo "- This is a rough estimate; actual tokenization and output length vary.\n";
echo "- HTML-heavy fields can increase token count.\n";
echo "- Ongoing cost after backfill should be low if updates are infrequent.\n";

