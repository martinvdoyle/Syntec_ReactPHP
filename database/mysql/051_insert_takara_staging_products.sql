-- Insert Takara Bio staging rows into syntec_products.
--
-- Prerequisite:
--   - Run database/mysql/050_takara_staging_product_group_id.sql first
--   - SUP-0040 must exist in syntec_suppliers
--
-- Notes:
--   - product_id is generated as PRD-8001, PRD-8002, ... by staging id order
--   - staging image column is image_1, inserted into product_image_large and product_image_1
--   - product_type_id is classified inline; no product_type_id column is required on staging
--   - duplicate protection uses supplier_id + supplier_product_id

SELECT
  COUNT(*) AS takara_rows_to_insert
FROM syntec_takara_bio_staging s
WHERE NOT EXISTS (
  SELECT 1
  FROM syntec_products p
  WHERE p.supplier_id = 'SUP-0040'
    AND p.supplier_product_id = s.product_sku
);

SELECT
  s.product_grouping,
  COUNT(*) AS missing_product_group_id_count
FROM syntec_takara_bio_staging s
WHERE s.product_group_id IS NULL
GROUP BY s.product_grouping
ORDER BY missing_product_group_id_count DESC, s.product_grouping;

INSERT INTO syntec_products
(
  deleted,
  active,
  product_id,
  prouduct_sku,
  product_name,
  supplier_id,
  supplier_name,
  product_image_large,
  product_image_1,
  discipline_id,
  discipline,
  product_group_id,
  product_group,
  product_type_id,
  product_type,
  product_group_type_alt,
  product_group_type_alt_id,
  business,
  supplier_product_id,
  product_image_external,
  product_link,
  product_enquire,
  about_1,
  date_created,
  anchor_id
)
SELECT
  'N' AS deleted,
  'Y' AS active,
  CONCAT('PRD-', 8000 + ROW_NUMBER() OVER (ORDER BY s.id)) AS product_id,
  s.product_sku AS prouduct_sku,
  s.description AS product_name,
  'SUP-0040' AS supplier_id,
  sup.supplier_name AS supplier_name,
  s.image_1 AS product_image_large,
  s.image_1 AS product_image_1,
  'DIS-0011' AS discipline_id,
  d.discipline_name AS discipline,
  s.product_group_id,
  g.product_group_name AS product_group,
  CASE
    WHEN s.product_grouping IN (
      'Agarose',
      'Cells/Media etc.',
      'Cells/Media JAP (Cellartis)',
      'Competent Cells',
      'Media (Cellartis)',
      'Mupid etc.',
      'MW Markers',
      'PCR Supplies'
    ) THEN 'PTY-0002'
    WHEN s.product_grouping IN ('Medical Devices/Other Devices') THEN 'PTY-0001'
    ELSE 'PTY-0003'
  END AS product_type_id,
  CASE
    WHEN s.product_grouping IN (
      'Agarose',
      'Cells/Media etc.',
      'Cells/Media JAP (Cellartis)',
      'Competent Cells',
      'Media (Cellartis)',
      'Mupid etc.',
      'MW Markers',
      'PCR Supplies'
    ) THEN 'Consumables'
    WHEN s.product_grouping IN ('Medical Devices/Other Devices') THEN 'Diagnostic Systems'
    ELSE 'Reagents'
  END AS product_type,
  g.product_group_name AS product_group_type_alt,
  s.product_group_id AS product_group_type_alt_id,
  'Syntec Scientific' AS business,
  s.product_sku AS supplier_product_id,
  'Y' AS product_image_external,
  '#' AS product_link,
  '#' AS product_enquire,
  CONCAT(
    '<div class="list-item last-list fx animated fadeInRight" data-animate="fadeInRight" style="opacity: 1; visibility: visible; animation-delay: 0ms;">',
    '<label class="control-label"><i class="icon-token lucide:align-justify label-icon"></i>Overview:</label>',
    '<p class="sub-heading">', COALESCE(s.long_description, ''), '<br><br></p>',
    '</div>',
    '<div class="panel-body">',
    '<table>',
    '<tbody>',
    '<tr><th colspan="2" class="left-text">Additional Information</th></tr>',
    '<tr><td class="width150">Product SKU</td><td>', COALESCE(s.product_sku, ''), '</td></tr>',
    '<tr><td class="width150">Pack Size</td><td>', COALESCE(s.pack_size, ''), '</td></tr>',
    '<tr><td class="width150">Manufacturer Name</td><td>', COALESCE(s.manufacturer_name, ''), '</td></tr>',
    '<tr><td class="width150">Shipping Temperature</td><td>', COALESCE(s.shipping_temperature, ''), '</td></tr>',
    '</tbody>',
    '</table>',
    '</div>'
  ) AS about_1,
  NOW() AS date_created,
  CONCAT('_takara-', LOWER(REPLACE(REPLACE(REPLACE(REPLACE(COALESCE(s.product_sku, ''), ' ', '-'), '/', '-'), '.', '-'), '_', '-'))) AS anchor_id
FROM syntec_takara_bio_staging s
JOIN syntec_suppliers sup
  ON sup.supplier_id = 'SUP-0040'
LEFT JOIN syntec_product_group g
  ON g.product_group_id = s.product_group_id
LEFT JOIN syntec_discipline d
  ON d.discipline_id = 'DIS-0011'
WHERE NOT EXISTS (
  SELECT 1
  FROM syntec_products p
  WHERE p.supplier_id = 'SUP-0040'
    AND p.supplier_product_id = s.product_sku
);

SELECT
  COUNT(*) AS inserted_or_existing_takara_products
FROM syntec_products
WHERE supplier_id = 'SUP-0040';
