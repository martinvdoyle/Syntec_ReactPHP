-- Align existing syntec_products table in place (no re-import)
-- Preserves current data and prior content cleanup.

-- 1) Add canonical Oracle-mirror columns if missing
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_id') = 0,
  'ALTER TABLE syntec_products ADD COLUMN product_id VARCHAR(20) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_name') = 0,
  'ALTER TABLE syntec_products ADD COLUMN product_name VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_link') = 0,
  'ALTER TABLE syntec_products ADD COLUMN product_link VARCHAR(1024) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'about_1') = 0,
  'ALTER TABLE syntec_products ADD COLUMN about_1 LONGTEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'prouduct_sku') = 0,
  'ALTER TABLE syntec_products ADD COLUMN prouduct_sku VARCHAR(100) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_image_large') = 0,
  'ALTER TABLE syntec_products ADD COLUMN product_image_large VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_image_small') = 0,
  'ALTER TABLE syntec_products ADD COLUMN product_image_small VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_image_1') = 0,
  'ALTER TABLE syntec_products ADD COLUMN product_image_1 VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 2) Backfill canonical columns from current columns
UPDATE syntec_products
SET
  product_id = COALESCE(NULLIF(product_id, ''), NULLIF(product_code, ''), NULLIF(oracle_product_id, '')),
  product_name = COALESCE(NULLIF(product_name, ''), NULLIF(name, '')),
  about_1 = COALESCE(NULLIF(about_1, ''), NULLIF(long_description, '')),
  product_link = COALESCE(NULLIF(product_link, ''), NULLIF(external_url, '')),
  prouduct_sku = COALESCE(NULLIF(prouduct_sku, ''), NULLIF(sku, '')),
  product_image_large = COALESCE(NULLIF(product_image_large, ''), NULLIF(primary_image_path, '')),
  product_image_1 = COALESCE(NULLIF(product_image_1, ''), NULLIF(primary_image_path, ''))
WHERE
  (product_id IS NULL OR product_id = '')
  OR (product_name IS NULL OR product_name = '')
  OR (about_1 IS NULL OR about_1 = '')
  OR (product_link IS NULL OR product_link = '')
  OR (prouduct_sku IS NULL OR prouduct_sku = '')
  OR (product_image_large IS NULL OR product_image_large = '')
  OR (product_image_1 IS NULL OR product_image_1 = '');

-- 3) Add unique key on product_id if safe
SET @dupes := (SELECT COUNT(*) FROM (SELECT product_id FROM syntec_products WHERE product_id IS NOT NULL AND product_id <> '' GROUP BY product_id HAVING COUNT(*) > 1) d);
SET @sql := IF(@dupes = 0 AND (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND index_name = 'uq_syntec_products_product_id') = 0,
  'ALTER TABLE syntec_products ADD UNIQUE KEY uq_syntec_products_product_id (product_id)', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SELECT COUNT(*) AS rows_missing_product_id FROM syntec_products WHERE product_id IS NULL OR product_id = '';
SELECT COUNT(*) AS rows_missing_product_name FROM syntec_products WHERE product_name IS NULL OR product_name = '';
SELECT product_id, COUNT(*) AS c FROM syntec_products WHERE product_id IS NOT NULL AND product_id <> '' GROUP BY product_id HAVING COUNT(*) > 1;
