-- Rebuild syntec_products.anchor_id for public slug use.
-- Source format: supplier_id + product_id.
-- Then enforce uniqueness with a unique key on anchor_id.

SET @widen_anchor_sql := IF(
  (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'syntec_products'
      AND column_name = 'anchor_id'
      AND (
        character_maximum_length IS NULL
        OR character_maximum_length < 255
      )
  ) > 0,
  'ALTER TABLE syntec_products MODIFY COLUMN anchor_id VARCHAR(255) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @widen_anchor_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT
  COUNT(*) AS blank_anchor_count
FROM syntec_products
WHERE anchor_id IS NULL OR TRIM(anchor_id) = '';

SELECT
  normalized_anchor,
  COUNT(*) AS duplicate_count
FROM (
  SELECT
    NULLIF(
      TRIM(BOTH '-' FROM REGEXP_REPLACE(
        REGEXP_REPLACE(
          LOWER(
            CONCAT(
              COALESCE(NULLIF(TRIM(supplier_id), ''), 'no-supplier'),
              '-',
              COALESCE(NULLIF(TRIM(product_id), ''), 'no-product')
            )
          ),
          '[^a-z0-9-]+',
          '-'
        ),
        '-+',
        '-'
      )),
      ''
    ) AS normalized_anchor
  FROM syntec_products
) anchors
WHERE normalized_anchor IS NOT NULL
GROUP BY normalized_anchor
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, normalized_anchor;

DROP TEMPORARY TABLE IF EXISTS tmp_syntec_product_anchor_slug;

CREATE TEMPORARY TABLE tmp_syntec_product_anchor_slug AS
WITH anchor_base AS (
  SELECT
    p.product_id,
    NULLIF(
      TRIM(BOTH '-' FROM REGEXP_REPLACE(
        REGEXP_REPLACE(
          LOWER(
            CONCAT(
              COALESCE(NULLIF(TRIM(p.supplier_id), ''), 'no-supplier'),
              '-',
              COALESCE(NULLIF(TRIM(p.product_id), ''), 'no-product')
            )
          ),
          '[^a-z0-9-]+',
          '-'
        ),
        '-+',
        '-'
      )),
      ''
    ) AS base_anchor
  FROM syntec_products p
),
anchor_ranked AS (
  SELECT
    product_id,
    base_anchor,
    COUNT(*) OVER (PARTITION BY base_anchor) AS base_count
  FROM anchor_base
)
SELECT
  product_id,
  CASE
    WHEN base_anchor IS NULL OR base_anchor = '' THEN LOWER(REPLACE(product_id, '_', '-'))
    WHEN base_count = 1 THEN base_anchor
    ELSE CONCAT(base_anchor, '-', LOWER(REPLACE(product_id, '_', '-')))
  END AS final_anchor
FROM anchor_ranked;

UPDATE syntec_products p
JOIN tmp_syntec_product_anchor_slug a
  ON a.product_id = p.product_id
SET p.anchor_id = a.final_anchor;

SET @add_anchor_unique_sql := IF(
  (
    SELECT COUNT(*)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'syntec_products'
      AND index_name = 'uk_syntec_products_anchor_id'
  ) = 0,
  'ALTER TABLE syntec_products ADD UNIQUE KEY uk_syntec_products_anchor_id (anchor_id)',
  'SELECT 1'
);
PREPARE stmt FROM @add_anchor_unique_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT
  COUNT(*) AS null_anchor_count_after
FROM syntec_products
WHERE anchor_id IS NULL OR TRIM(anchor_id) = '';

SELECT
  anchor_id,
  COUNT(*) AS duplicate_count_after
FROM syntec_products
GROUP BY anchor_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count_after DESC, anchor_id;
