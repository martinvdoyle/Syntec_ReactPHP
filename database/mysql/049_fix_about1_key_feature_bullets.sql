-- Restore missing first-cell bullet markup in legacy ABOUT_1 key-feature tables.
--
-- Scope:
--   - ABOUT_1 only
--   - product HTML containing the legacy panel-body + 3-column Key Features table
--   - exact empty first-cell pattern: <tr><td></td><td><b>
--
-- Do not run this against Oracle exports; this is a MySQL runtime cleanup.

SELECT 'syntec_products before' AS scope, COUNT(*) AS rows_to_fix
FROM syntec_products
WHERE about_1 LIKE '%<div class="panel-body"%'
  AND about_1 LIKE '%<td colspan="3"%'
  AND about_1 LIKE '%<tr><td></td><td><b>%';

UPDATE syntec_products
SET about_1 = REPLACE(
  about_1,
  '<tr><td></td><td><b>',
  '<tr><td class="width-40 center-bullet "><i class=" icon-token lucide:circle font-8 main-color"></i></td><td><b>'
)
WHERE about_1 LIKE '%<div class="panel-body"%'
  AND about_1 LIKE '%<td colspan="3"%'
  AND about_1 LIKE '%<tr><td></td><td><b>%';

SELECT 'syntec_products after' AS scope, COUNT(*) AS rows_remaining
FROM syntec_products
WHERE about_1 LIKE '%<div class="panel-body"%'
  AND about_1 LIKE '%<td colspan="3"%'
  AND about_1 LIKE '%<tr><td></td><td><b>%';

SELECT 'syntec_products missing icon before' AS scope, COUNT(*) AS rows_to_fix
FROM syntec_products
WHERE about_1 LIKE '%<div class="panel-body"%'
  AND about_1 LIKE '%<td colspan="3"%'
  AND about_1 LIKE '%<tr><td class="width-40 center-bullet"></td><td><b>%';

UPDATE syntec_products
SET about_1 = REPLACE(
  about_1,
  '<tr><td class="width-40 center-bullet"></td><td><b>',
  '<tr><td class="width-40 center-bullet"><i class=" icon-token lucide:circle font-8 main-color"></i></td><td><b>'
)
WHERE about_1 LIKE '%<div class="panel-body"%'
  AND about_1 LIKE '%<td colspan="3"%'
  AND about_1 LIKE '%<tr><td class="width-40 center-bullet"></td><td><b>%';

SELECT 'syntec_products missing icon after' AS scope, COUNT(*) AS rows_remaining
FROM syntec_products
WHERE about_1 LIKE '%<div class="panel-body"%'
  AND about_1 LIKE '%<td colspan="3"%'
  AND about_1 LIKE '%<tr><td class="width-40 center-bullet"></td><td><b>%';

SELECT 'syntec_product_i18n before' AS scope, COUNT(*) AS rows_to_fix
FROM syntec_product_i18n
WHERE about_1 LIKE '%<div class="panel-body"%'
  AND about_1 LIKE '%<td colspan="3"%'
  AND about_1 LIKE '%<tr><td></td><td><b>%';

UPDATE syntec_product_i18n
SET about_1 = REPLACE(
  about_1,
  '<tr><td></td><td><b>',
  '<tr><td class="width-40 center-bullet "><i class=" icon-token lucide:circle font-8 main-color"></i></td><td><b>'
)
WHERE about_1 LIKE '%<div class="panel-body"%'
  AND about_1 LIKE '%<td colspan="3"%'
  AND about_1 LIKE '%<tr><td></td><td><b>%';

SELECT 'syntec_product_i18n after' AS scope, COUNT(*) AS rows_remaining
FROM syntec_product_i18n
WHERE about_1 LIKE '%<div class="panel-body"%'
  AND about_1 LIKE '%<td colspan="3"%'
  AND about_1 LIKE '%<tr><td></td><td><b>%';

SELECT 'syntec_product_i18n missing icon before' AS scope, COUNT(*) AS rows_to_fix
FROM syntec_product_i18n
WHERE about_1 LIKE '%<div class="panel-body"%'
  AND about_1 LIKE '%<td colspan="3"%'
  AND about_1 LIKE '%<tr><td class="width-40 center-bullet"></td><td><b>%';

UPDATE syntec_product_i18n
SET about_1 = REPLACE(
  about_1,
  '<tr><td class="width-40 center-bullet"></td><td><b>',
  '<tr><td class="width-40 center-bullet"><i class=" icon-token lucide:circle font-8 main-color"></i></td><td><b>'
)
WHERE about_1 LIKE '%<div class="panel-body"%'
  AND about_1 LIKE '%<td colspan="3"%'
  AND about_1 LIKE '%<tr><td class="width-40 center-bullet"></td><td><b>%';

SELECT 'syntec_product_i18n missing icon after' AS scope, COUNT(*) AS rows_remaining
FROM syntec_product_i18n
WHERE about_1 LIKE '%<div class="panel-body"%'
  AND about_1 LIKE '%<td colspan="3"%'
  AND about_1 LIKE '%<tr><td class="width-40 center-bullet"></td><td><b>%';
