-- Oracle MENU_ITEMS direct migration to syntec_menu_items (1:1 field copy)

-- 1) Staging table mirrors Oracle MENU_ITEMS export structure
CREATE TABLE IF NOT EXISTS syntec_menu_items_staging (
  menu_id VARCHAR(32) NOT NULL,
  menu_name VARCHAR(255) NOT NULL,
  sub_menu_name VARCHAR(255) NULL,
  parent_id VARCHAR(32) NULL,
  url VARCHAR(1024) NULL,
  icon_class VARCHAR(255) NULL,
  css_class VARCHAR(255) NULL,
  sub_menu_id VARCHAR(64) NULL,
  business VARCHAR(128) NULL,
  menu_order BIGINT NULL,
  website VARCHAR(128) NULL,
  website_set VARCHAR(128) NULL,
  website_anchor VARCHAR(128) NULL,
  sub_menu_level_id VARCHAR(32) NULL,
  sub_menu_text VARCHAR(255) NULL,
  menu_id_order BIGINT NULL,
  business_set VARCHAR(128) NULL,
  product_type VARCHAR(128) NULL,
  discipline_id VARCHAR(32) NULL,
  product_group_id VARCHAR(32) NULL,
  supplier_id VARCHAR(32) NULL,
  product_id VARCHAR(32) NULL,
  enabled VARCHAR(1) NULL,
  url_mobile VARCHAR(1024) NULL,
  menu_order_clone BIGINT NULL,
  PRIMARY KEY (menu_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2) Ensure syntec_menu_items carries Oracle columns (no dropping legacy columns)
SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'menu_id') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN menu_id VARCHAR(32) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'menu_name') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN menu_name VARCHAR(255) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'sub_menu_name') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN sub_menu_name VARCHAR(255) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'oracle_parent_id') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN oracle_parent_id VARCHAR(32) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'url') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN url VARCHAR(1024) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'icon_class') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN icon_class VARCHAR(255) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'css_class') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN css_class VARCHAR(255) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'sub_menu_id') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN sub_menu_id VARCHAR(64) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'business') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN business VARCHAR(128) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'menu_order') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN menu_order BIGINT NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'website') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN website VARCHAR(128) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'website_set') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN website_set VARCHAR(128) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'website_anchor') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN website_anchor VARCHAR(128) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'sub_menu_level_id') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN sub_menu_level_id VARCHAR(32) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'sub_menu_text') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN sub_menu_text VARCHAR(255) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'menu_id_order') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN menu_id_order BIGINT NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'business_set') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN business_set VARCHAR(128) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'product_type') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN product_type VARCHAR(128) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'discipline_id') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN discipline_id VARCHAR(32) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'product_group_id') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN product_group_id VARCHAR(32) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'supplier_id') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN supplier_id VARCHAR(32) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'product_id') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN product_id VARCHAR(32) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'enabled') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN enabled VARCHAR(1) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'url_mobile') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN url_mobile VARCHAR(1024) NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND column_name = 'menu_order_clone') = 0,
  'ALTER TABLE syntec_menu_items ADD COLUMN menu_order_clone BIGINT NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Helpful index for parent reconstruction/lookups by Oracle menu id
SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'syntec_menu_items' AND index_name = 'idx_syntec_menu_items_menu_id') = 0,
  'ALTER TABLE syntec_menu_items ADD INDEX idx_syntec_menu_items_menu_id (menu_id)',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 3) Direct copy: no transformation logic
DELETE FROM syntec_menu_items;

INSERT INTO syntec_menu_items (
  parent_id,
  menu_id,
  menu_name,
  sub_menu_name,
  oracle_parent_id,
  url,
  icon_class,
  css_class,
  sub_menu_id,
  business,
  menu_order,
  website,
  website_set,
  website_anchor,
  sub_menu_level_id,
  sub_menu_text,
  menu_id_order,
  business_set, 
  product_type,
  discipline_id,
  product_group_id,
  supplier_id,
  product_id,
  enabled,
  url_mobile,
  menu_order_clone
)
SELECT
  NULL,
  menu_id,
  menu_name,
  sub_menu_name,
  parent_id,
  url,
  icon_class,
  css_class,
  sub_menu_id,
  business,
  menu_order,
  website,
  website_set,
  website_anchor,
  sub_menu_level_id,
  sub_menu_text,
  menu_id_order,
  business_set,
  product_type,
  discipline_id,
  product_group_id,
  supplier_id,
  product_id,
  enabled,
  url_mobile,
  menu_order_clone
FROM syntec_menu_items_staging;

-- 4) Rebuild local FK parent_id from Oracle parent_id
UPDATE syntec_menu_items child
LEFT JOIN syntec_menu_items parent
  ON parent.menu_id = child.oracle_parent_id
SET child.parent_id = parent.id
WHERE child.oracle_parent_id IS NOT NULL;

