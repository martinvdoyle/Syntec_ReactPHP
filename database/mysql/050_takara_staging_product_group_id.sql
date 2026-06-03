-- Add and populate product_group_id on Takara staging products.
--
-- Scope:
--   - syntec_takara_bio_staging only
--   - maps product_grouping to syntec_product_group.product_group_id
--   - no product type classification here

ALTER TABLE syntec_takara_bio_staging
  ADD COLUMN product_group_id VARCHAR(20) NULL AFTER product_grouping;

-- Sanity check: SKU should be unique before using it for later product updates/import joins.
SELECT
  product_sku,
  COUNT(*) AS sku_count
FROM syntec_takara_bio_staging
GROUP BY product_sku
HAVING COUNT(*) > 1
ORDER BY sku_count DESC, product_sku;

-- Map Takara staging group names to the generated Syntec product-group lookup rows.
UPDATE syntec_takara_bio_staging s
JOIN syntec_product_group g
  ON TRIM(g.product_group_name) = TRIM(s.product_grouping)
SET s.product_group_id = g.product_group_id
WHERE s.product_grouping IS NOT NULL
  AND TRIM(s.product_grouping) <> ''
  AND g.discipline_id = 'DIS-0011';

-- Review any staging groups that did not map to a product_group_id.
SELECT
  s.product_grouping,
  COUNT(*) AS product_count
FROM syntec_takara_bio_staging s
WHERE s.product_group_id IS NULL
GROUP BY s.product_grouping
ORDER BY product_count DESC, s.product_grouping;

-- Review mapped group distribution.
SELECT
  product_group_id,
  product_grouping,
  COUNT(*) AS product_count
FROM syntec_takara_bio_staging
GROUP BY product_group_id, product_grouping
ORDER BY product_count DESC, product_grouping;
