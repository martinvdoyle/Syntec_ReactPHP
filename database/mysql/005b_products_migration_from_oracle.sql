-- Oracle PRODUCTS direct migration to syntec_products (with full Oracle-shaped staging)

CREATE TABLE IF NOT EXISTS syntec_products_staging (
  deleted CHAR(1) NULL,
  active CHAR(1) NULL,
  product_id VARCHAR(20) NOT NULL,
  product_name VARCHAR(255) NOT NULL,
  product_name_web VARCHAR(255) NULL,
  short_name VARCHAR(255) NULL,
  product_sipplier_order BIGINT NULL,
  supplier_id VARCHAR(20) NULL,
  discipline VARCHAR(255) NULL,
  product_group VARCHAR(255) NULL,
  product_type VARCHAR(255) NULL,
  class_id VARCHAR(255) NULL,
  class_colour VARCHAR(64) NULL,
  about_1 LONGTEXT NULL,
  about_2 LONGTEXT NULL,
  product_link VARCHAR(1024) NULL,
  product_enquire VARCHAR(1024) NULL,
  product_image_large VARCHAR(255) NULL,
  product_image_small VARCHAR(255) NULL,
  product_image_1 VARCHAR(255) NULL,
  product_image_2 VARCHAR(255) NULL,
  product_image_3 VARCHAR(255) NULL,
  product_image_4 VARCHAR(255) NULL,
  product_parent_id VARCHAR(20) NULL,
  date_created DATETIME NULL,
  date_deleted DATETIME NULL,
  anchor_id VARCHAR(255) NULL,
  product_image_large_width VARCHAR(32) NULL,
  product_image_large_height VARCHAR(32) NULL,
  product_image_small_width VARCHAR(32) NULL,
  product_image_small_height VARCHAR(32) NULL,
  supplier_name VARCHAR(255) NULL,
  discipline_id VARCHAR(20) NULL,
  product_group_id VARCHAR(20) NULL,
  product_type_id VARCHAR(20) NULL,
  product_group_type_alt VARCHAR(255) NULL,
  product_group_type_alt_id VARCHAR(20) NULL,
  business VARCHAR(255) NULL,
  product_image_external VARCHAR(1) NULL,
  prouduct_sku VARCHAR(100) NULL,
  supplier_product_id VARCHAR(255) NULL,
  PRIMARY KEY (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'oracle_product_id') = 0,
  'ALTER TABLE syntec_products ADD COLUMN oracle_product_id VARCHAR(64) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND index_name = 'idx_syntec_products_oracle_product_id') = 0,
  'ALTER TABLE syntec_products ADD INDEX idx_syntec_products_oracle_product_id (oracle_product_id)',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'oracle_supplier_code') = 0,
  'ALTER TABLE syntec_products ADD COLUMN oracle_supplier_code VARCHAR(64) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

INSERT INTO syntec_products (
  oracle_product_id,
  oracle_supplier_code,
  product_code,
  sku,
  name,
  slug,
  supplier_id,
  short_description,
  long_description,
  category_summary,
  primary_image_path,
  external_url,
  active_flag,
  featured_flag,
  sort_order,
  created_at,
  updated_at
)
SELECT
  s.product_id,
  s.supplier_id,
  s.product_id,
  NULLIF(s.prouduct_sku, ''),
  s.product_name,
  COALESCE(NULLIF(s.anchor_id, ''), LOWER(REPLACE(REPLACE(REPLACE(s.product_name, ' ', '-'), '/', '-'), '&', 'and'))),
  sup.id,
  NULLIF(s.short_name, ''),
  NULLIF(s.about_1, ''),
  CONCAT_WS(' | ', NULLIF(s.discipline, ''), NULLIF(s.product_group, ''), NULLIF(s.product_type, '')),
  COALESCE(NULLIF(s.product_image_large, ''), NULLIF(s.product_image_small, ''), NULLIF(s.product_image_1, '')),
  NULLIF(s.product_link, ''),
  CASE WHEN COALESCE(s.active, 'Y') = 'Y' THEN 1 ELSE 0 END,
  0,
  COALESCE(s.product_sipplier_order, 0),
  COALESCE(s.date_created, NOW()),
  NOW()
FROM syntec_products_staging s
LEFT JOIN syntec_suppliers sup
  ON sup.supplier_code = s.supplier_id
ON DUPLICATE KEY UPDATE
  oracle_supplier_code = VALUES(oracle_supplier_code),
  product_code = VALUES(product_code),
  sku = VALUES(sku),
  name = VALUES(name),
  slug = VALUES(slug),
  supplier_id = VALUES(supplier_id),
  short_description = VALUES(short_description),
  long_description = VALUES(long_description),
  category_summary = VALUES(category_summary),
  primary_image_path = VALUES(primary_image_path),
  external_url = VALUES(external_url),
  active_flag = VALUES(active_flag),
  sort_order = VALUES(sort_order),
  updated_at = NOW();

SELECT COUNT(*) AS staged_rows FROM syntec_products_staging;
SELECT COUNT(*) AS runtime_rows FROM syntec_products;
SELECT COUNT(*) AS unresolved_supplier_links
FROM syntec_products
WHERE oracle_supplier_code IS NOT NULL
  AND supplier_id IS NULL;
