-- In-place Oracle mirror completion for existing runtime tables.
-- Adds missing Oracle columns and backfills safely without deleting data.

/* =========================
   SUPPLIERS: add missing Oracle columns
   ========================= */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'deleted') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN deleted CHAR(1) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'active') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN active CHAR(1) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'short_name') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN short_name VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'class_id') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN class_id VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'class_colour') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN class_colour VARCHAR(20) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'profile_2') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN profile_2 LONGTEXT NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'supplier_logo_small') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN supplier_logo_small VARCHAR(200) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'supplier_image_1') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN supplier_image_1 VARCHAR(200) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'supplier_image_2') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN supplier_image_2 VARCHAR(200) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'supplier_image_3') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN supplier_image_3 VARCHAR(200) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'supplier_image_4') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN supplier_image_4 VARCHAR(200) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'address_1') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN address_1 VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'address_2') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN address_2 VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'address_3') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN address_3 VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'address_4') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN address_4 VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'address_5') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN address_5 VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'date_created') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN date_created DATETIME NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'date_deleted') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN date_deleted DATETIME NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'anchor_id') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN anchor_id VARCHAR(50) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'supplier_image_background') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN supplier_image_background VARCHAR(200) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'supplier_logo_large_scale_smaller') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN supplier_logo_large_scale_smaller VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'business') = 0, 'ALTER TABLE syntec_suppliers ADD COLUMN business VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

/* =========================
   SUPPLIERS: normalize Oracle-compatible types on existing columns
   ========================= */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'supplier_id') = 1, 'ALTER TABLE syntec_suppliers MODIFY COLUMN supplier_id VARCHAR(20) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'supplier_name') = 1, 'ALTER TABLE syntec_suppliers MODIFY COLUMN supplier_name VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'website') = 1, 'ALTER TABLE syntec_suppliers MODIFY COLUMN website VARCHAR(200) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'supplier_logo_large') = 1, 'ALTER TABLE syntec_suppliers MODIFY COLUMN supplier_logo_large VARCHAR(200) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'profile_1') = 1, 'ALTER TABLE syntec_suppliers MODIFY COLUMN profile_1 LONGTEXT NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @supplier_id_src := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'supplier_code') = 1, "NULLIF(supplier_code, '')", "NULL");
SET @supplier_name_src := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'name') = 1, "NULLIF(name, '')", "NULL");
SET @website_src := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'website_url') = 1, "NULLIF(website_url, '')", "NULL");
SET @short_description_src := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'short_description') = 1, "NULLIF(short_description, '')", "NULL");
SET @logo_path_src := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'logo_path') = 1, "NULLIF(logo_path, '')", "NULL");
SET @banner_path_src := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'banner_path') = 1, "NULLIF(banner_path, '')", "NULL");
SET @business_unit_src := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'business_unit') = 1, "NULLIF(business_unit, '')", "NULL");

SET @sql := CONCAT(
  'UPDATE syntec_suppliers SET ',
  'supplier_id = COALESCE(NULLIF(supplier_id, ''''), ', @supplier_id_src, '), ',
  'supplier_name = COALESCE(NULLIF(supplier_name, ''''), ', @supplier_name_src, '), ',
  'website = COALESCE(NULLIF(website, ''''), ', @website_src, '), ',
  'profile_1 = COALESCE(NULLIF(profile_1, ''''), ', @short_description_src, '), ',
  'supplier_logo_large = COALESCE(NULLIF(supplier_logo_large, ''''), ', @logo_path_src, '), ',
  'supplier_image_background = COALESCE(NULLIF(supplier_image_background, ''''), ', @banner_path_src, '), ',
  'business = COALESCE(NULLIF(business, ''''), ', @business_unit_src, '), ',
  'short_name = COALESCE(NULLIF(short_name, ''''), ', @short_description_src, '), ',
  'deleted = COALESCE(NULLIF(deleted, ''''), ''N''), ',
  'active = COALESCE(NULLIF(active, ''''), CASE WHEN active_flag = 1 THEN ''Y'' ELSE ''N'' END), ',
  'date_created = COALESCE(date_created, created_at), ',
  'anchor_id = COALESCE(NULLIF(anchor_id, ''''), NULLIF(slug, '''')) ',
  'WHERE 1=1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

/* Fill remaining supplier Oracle columns with safe defaults/backfills */
UPDATE syntec_suppliers
SET
  class_id = COALESCE(NULLIF(class_id, ''), 'DEFAULT'),
  class_colour = COALESCE(NULLIF(class_colour, ''), '#000000'),
  profile_2 = COALESCE(profile_2, profile_1),
  supplier_logo_small = COALESCE(NULLIF(supplier_logo_small, ''), NULLIF(supplier_logo_large, '')),
  supplier_image_1 = COALESCE(NULLIF(supplier_image_1, ''), NULLIF(supplier_logo_large, '')),
  supplier_image_2 = COALESCE(NULLIF(supplier_image_2, ''), NULLIF(supplier_image_1, '')),
  supplier_image_3 = COALESCE(NULLIF(supplier_image_3, ''), NULLIF(supplier_image_1, '')),
  supplier_image_4 = COALESCE(NULLIF(supplier_image_4, ''), NULLIF(supplier_image_1, '')),
  supplier_logo_large_scale_smaller = COALESCE(NULLIF(supplier_logo_large_scale_smaller, ''), 'N'),
  date_deleted = COALESCE(date_deleted, NULL)
WHERE 1=1;

/* =========================
   PRODUCTS: add missing Oracle columns
   ========================= */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'deleted') = 0, 'ALTER TABLE syntec_products ADD COLUMN deleted CHAR(1) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'active') = 0, 'ALTER TABLE syntec_products ADD COLUMN active CHAR(1) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_name_web') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_name_web VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'short_name') = 0, 'ALTER TABLE syntec_products ADD COLUMN short_name VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_sipplier_order') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_sipplier_order INT NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'discipline') = 0, 'ALTER TABLE syntec_products ADD COLUMN discipline VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_group') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_group VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_type') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_type VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'class_id') = 0, 'ALTER TABLE syntec_products ADD COLUMN class_id VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'class_colour') = 0, 'ALTER TABLE syntec_products ADD COLUMN class_colour VARCHAR(20) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'about_2') = 0, 'ALTER TABLE syntec_products ADD COLUMN about_2 LONGTEXT NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_enquire') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_enquire VARCHAR(800) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_image_2') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_image_2 VARCHAR(200) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_image_3') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_image_3 VARCHAR(200) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_image_4') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_image_4 VARCHAR(200) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_parent_id') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_parent_id VARCHAR(20) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'date_created') = 0, 'ALTER TABLE syntec_products ADD COLUMN date_created DATETIME NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'date_deleted') = 0, 'ALTER TABLE syntec_products ADD COLUMN date_deleted DATETIME NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'anchor_id') = 0, 'ALTER TABLE syntec_products ADD COLUMN anchor_id VARCHAR(50) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_image_large_width') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_image_large_width VARCHAR(20) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_image_large_height') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_image_large_height VARCHAR(20) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_image_small_width') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_image_small_width VARCHAR(20) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_image_small_height') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_image_small_height VARCHAR(20) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'supplier_name') = 0, 'ALTER TABLE syntec_products ADD COLUMN supplier_name VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'discipline_id') = 0, 'ALTER TABLE syntec_products ADD COLUMN discipline_id VARCHAR(20) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_group_id') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_group_id VARCHAR(20) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_type_id') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_type_id VARCHAR(20) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_group_type_alt') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_group_type_alt VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_group_type_alt_id') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_group_type_alt_id VARCHAR(20) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'business') = 0, 'ALTER TABLE syntec_products ADD COLUMN business VARCHAR(200) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_image_external') = 0, 'ALTER TABLE syntec_products ADD COLUMN product_image_external VARCHAR(1) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'supplier_product_id') = 0, 'ALTER TABLE syntec_products ADD COLUMN supplier_product_id VARCHAR(200) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

/* =========================
   PRODUCTS: normalize Oracle-compatible types on existing columns
   ========================= */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_products' AND constraint_name = 'fk_syntec_products_supplier' AND constraint_type = 'FOREIGN KEY') = 1, 'ALTER TABLE syntec_products DROP FOREIGN KEY fk_syntec_products_supplier', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'supplier_id') = 1, 'ALTER TABLE syntec_products MODIFY COLUMN supplier_id VARCHAR(20) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_id') = 1, 'ALTER TABLE syntec_products MODIFY COLUMN product_id VARCHAR(20) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_name') = 1, 'ALTER TABLE syntec_products MODIFY COLUMN product_name VARCHAR(150) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_link') = 1, 'ALTER TABLE syntec_products MODIFY COLUMN product_link VARCHAR(800) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_image_large') = 1, 'ALTER TABLE syntec_products MODIFY COLUMN product_image_large VARCHAR(200) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_image_small') = 1, 'ALTER TABLE syntec_products MODIFY COLUMN product_image_small VARCHAR(200) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_image_1') = 1, 'ALTER TABLE syntec_products MODIFY COLUMN product_image_1 VARCHAR(200) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_sipplier_order') = 1, 'ALTER TABLE syntec_products MODIFY COLUMN product_sipplier_order INT NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'prouduct_sku') = 1, 'ALTER TABLE syntec_products MODIFY COLUMN prouduct_sku VARCHAR(100) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

/* Convert legacy numeric supplier FK values to Oracle supplier codes */
SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'id') = 1
  AND
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'supplier_id') = 1,
  "UPDATE syntec_products p
   JOIN syntec_suppliers s ON CAST(p.supplier_id AS UNSIGNED) = s.id
   SET p.supplier_id = s.supplier_id
   WHERE p.supplier_id REGEXP '^[0-9]+$'
     AND s.supplier_id IS NOT NULL
     AND s.supplier_id <> ''",
  'SELECT 1'
); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @product_code_src := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_code') = 1, "NULLIF(product_code, '')", "NULL");
SET @oracle_product_id_src := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'oracle_product_id') = 1, "NULLIF(oracle_product_id, '')", "NULL");
SET @name_src := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'name') = 1, "NULLIF(name, '')", "NULL");
SET @sku_src := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'sku') = 1, "NULLIF(sku, '')", "NULL");
SET @oracle_supplier_code_src := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'oracle_supplier_code') = 1, "NULLIF(oracle_supplier_code, '')", "NULL");
SET @long_description_src := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'long_description') = 1, "NULLIF(long_description, '')", "NULL");
SET @external_url_src := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'external_url') = 1, "NULLIF(external_url, '')", "NULL");
SET @primary_image_path_src := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'primary_image_path') = 1, "NULLIF(primary_image_path, '')", "NULL");
SET @short_description_src_p := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'short_description') = 1, "NULLIF(short_description, '')", "NULL");

SET @sql := CONCAT(
  'UPDATE syntec_products SET ',
  'product_id = COALESCE(NULLIF(product_id, ''''), ', @product_code_src, ', ', @oracle_product_id_src, '), ',
  'product_name = COALESCE(NULLIF(product_name, ''''), ', @name_src, '), ',
  'prouduct_sku = COALESCE(NULLIF(prouduct_sku, ''''), ', @sku_src, '), ',
  'supplier_id = COALESCE(NULLIF(supplier_id, ''''), ', @oracle_supplier_code_src, '), ',
  'about_1 = COALESCE(NULLIF(about_1, ''''), ', @long_description_src, '), ',
  'product_link = COALESCE(NULLIF(product_link, ''''), ', @external_url_src, '), ',
  'product_image_large = COALESCE(NULLIF(product_image_large, ''''), ', @primary_image_path_src, '), ',
  'product_image_small = COALESCE(NULLIF(product_image_small, ''''), ', @primary_image_path_src, '), ',
  'product_image_1 = COALESCE(NULLIF(product_image_1, ''''), ', @primary_image_path_src, '), ',
  'short_name = COALESCE(NULLIF(short_name, ''''), ', @short_description_src_p, '), ',
  'product_sipplier_order = COALESCE(product_sipplier_order, sort_order), ',
  'deleted = COALESCE(NULLIF(deleted, ''''), ''N''), ',
  'active = COALESCE(NULLIF(active, ''''), CASE WHEN active_flag = 1 THEN ''Y'' ELSE ''N'' END), ',
  'date_created = COALESCE(date_created, created_at), ',
  'anchor_id = COALESCE(NULLIF(anchor_id, ''''), NULLIF(slug, '''')) ',
  'WHERE 1=1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

/* Fill remaining product Oracle columns with safe defaults/backfills */
UPDATE syntec_products
SET
  product_name_web = COALESCE(NULLIF(product_name_web, ''), NULLIF(product_name, '')),
  discipline = COALESCE(NULLIF(discipline, ''), 'General'),
  product_group = COALESCE(NULLIF(product_group, ''), 'General'),
  product_type = COALESCE(NULLIF(product_type, ''), 'General'),
  class_id = COALESCE(NULLIF(class_id, ''), 'DEFAULT'),
  class_colour = COALESCE(NULLIF(class_colour, ''), '#000000'),
  about_2 = COALESCE(about_2, about_1),
  product_enquire = COALESCE(NULLIF(product_enquire, ''), NULLIF(product_link, '')),
  product_image_2 = COALESCE(NULLIF(product_image_2, ''), NULLIF(product_image_1, '')),
  product_image_3 = COALESCE(NULLIF(product_image_3, ''), NULLIF(product_image_1, '')),
  product_image_4 = COALESCE(NULLIF(product_image_4, ''), NULLIF(product_image_1, '')),
  product_parent_id = COALESCE(NULLIF(product_parent_id, ''), NULL),
  date_deleted = COALESCE(date_deleted, NULL),
  product_image_large_width = COALESCE(NULLIF(product_image_large_width, ''), '0'),
  product_image_large_height = COALESCE(NULLIF(product_image_large_height, ''), '0'),
  product_image_small_width = COALESCE(NULLIF(product_image_small_width, ''), '0'),
  product_image_small_height = COALESCE(NULLIF(product_image_small_height, ''), '0'),
  discipline_id = COALESCE(NULLIF(discipline_id, ''), '0'),
  product_group_id = COALESCE(NULLIF(product_group_id, ''), '0'),
  product_type_id = COALESCE(NULLIF(product_type_id, ''), '0'),
  product_group_type_alt = COALESCE(NULLIF(product_group_type_alt, ''), NULLIF(product_group, '')),
  product_group_type_alt_id = COALESCE(NULLIF(product_group_type_alt_id, ''), NULLIF(product_group_id, '0')),
  business = COALESCE(NULLIF(business, ''), 'General'),
  product_image_external = COALESCE(NULLIF(product_image_external, ''), 'N'),
  supplier_product_id = COALESCE(NULLIF(supplier_product_id, ''), NULLIF(prouduct_sku, ''))
WHERE 1=1;

UPDATE syntec_products p
JOIN syntec_suppliers s ON s.supplier_id = p.supplier_id
SET p.supplier_name = COALESCE(NULLIF(p.supplier_name, ''), NULLIF(s.supplier_name, ''))
WHERE (p.supplier_name IS NULL OR p.supplier_name = '')
  AND s.supplier_name IS NOT NULL
  AND s.supplier_name <> '';

/* =========================
   Verification
   ========================= */
SELECT COUNT(*) AS suppliers_missing_supplier_id FROM syntec_suppliers WHERE supplier_id IS NULL OR supplier_id = '';
SELECT COUNT(*) AS suppliers_missing_supplier_name FROM syntec_suppliers WHERE supplier_name IS NULL OR supplier_name = '';
SELECT COUNT(*) AS products_missing_product_id FROM syntec_products WHERE product_id IS NULL OR product_id = '';
SELECT COUNT(*) AS products_missing_product_name FROM syntec_products WHERE product_name IS NULL OR product_name = '';

/* =========================
   Cleanup: remove hybrid columns (run after verifying API/admin uses Oracle names)
   ========================= */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'supplier_code') = 1, 'ALTER TABLE syntec_suppliers DROP COLUMN supplier_code', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'name') = 1, 'ALTER TABLE syntec_suppliers DROP COLUMN name', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'short_description') = 1, 'ALTER TABLE syntec_suppliers DROP COLUMN short_description', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'website_url') = 1, 'ALTER TABLE syntec_suppliers DROP COLUMN website_url', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'logo_path') = 1, 'ALTER TABLE syntec_suppliers DROP COLUMN logo_path', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'banner_path') = 1, 'ALTER TABLE syntec_suppliers DROP COLUMN banner_path', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'business_unit') = 1, 'ALTER TABLE syntec_suppliers DROP COLUMN business_unit', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'product_code') = 1, 'ALTER TABLE syntec_products DROP COLUMN product_code', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'sku') = 1, 'ALTER TABLE syntec_products DROP COLUMN sku', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'name') = 1, 'ALTER TABLE syntec_products DROP COLUMN name', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'short_description') = 1, 'ALTER TABLE syntec_products DROP COLUMN short_description', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'long_description') = 1, 'ALTER TABLE syntec_products DROP COLUMN long_description', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'category_summary') = 1, 'ALTER TABLE syntec_products DROP COLUMN category_summary', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'primary_image_path') = 1, 'ALTER TABLE syntec_products DROP COLUMN primary_image_path', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'external_url') = 1, 'ALTER TABLE syntec_products DROP COLUMN external_url', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'oracle_product_id') = 1, 'ALTER TABLE syntec_products DROP COLUMN oracle_product_id', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'oracle_supplier_code') = 1, 'ALTER TABLE syntec_products DROP COLUMN oracle_supplier_code', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
