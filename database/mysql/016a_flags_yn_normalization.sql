-- Post-migration flag normalization to Oracle-style Y/N (no hybrid 1/0 flags)
-- Safe to run multiple times.

/* =========================
   PRODUCTS
   ========================= */
-- Ensure Oracle-style flag columns exist.
SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'active') = 0,
  'ALTER TABLE syntec_products ADD COLUMN active CHAR(1) NULL',
  'SELECT 1'
); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_products' AND column_name = 'deleted') = 0,
  'ALTER TABLE syntec_products ADD COLUMN deleted CHAR(1) NULL',
  'SELECT 1'
); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Backfill Y/N from numeric flags, preserving existing populated Y/N.
UPDATE syntec_products
SET
  active = COALESCE(NULLIF(active, ''), CASE WHEN COALESCE(active_flag, 1) = 1 THEN 'Y' ELSE 'N' END),
  deleted = COALESCE(NULLIF(deleted, ''), 'N');

/* =========================
   SUPPLIERS
   ========================= */
-- Ensure Oracle-style flag columns exist.
SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'active') = 0,
  'ALTER TABLE syntec_suppliers ADD COLUMN active CHAR(1) NULL',
  'SELECT 1'
); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'deleted') = 0,
  'ALTER TABLE syntec_suppliers ADD COLUMN deleted CHAR(1) NULL',
  'SELECT 1'
); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE syntec_suppliers
SET
  active = COALESCE(NULLIF(active, ''), CASE WHEN COALESCE(active_flag, 1) = 1 THEN 'Y' ELSE 'N' END),
  deleted = COALESCE(NULLIF(deleted, ''), 'N');

/* =========================
   LOOKUP TABLES (1-6 in import set that had 1/0 runtime columns)
   ========================= */
-- Discipline
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_discipline' AND column_name = 'active') = 0, 'ALTER TABLE syntec_discipline ADD COLUMN active CHAR(1) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_discipline' AND column_name = 'deleted') = 0, 'ALTER TABLE syntec_discipline ADD COLUMN deleted CHAR(1) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
UPDATE syntec_discipline SET active = COALESCE(NULLIF(active, ''), CASE WHEN COALESCE(active_flag, 1) = 1 THEN 'Y' ELSE 'N' END), deleted = COALESCE(NULLIF(deleted, ''), 'N');

-- Product group
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_product_group' AND column_name = 'active') = 0, 'ALTER TABLE syntec_product_group ADD COLUMN active CHAR(1) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_product_group' AND column_name = 'deleted') = 0, 'ALTER TABLE syntec_product_group ADD COLUMN deleted CHAR(1) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
UPDATE syntec_product_group SET active = COALESCE(NULLIF(active, ''), CASE WHEN COALESCE(active_flag, 1) = 1 THEN 'Y' ELSE 'N' END), deleted = COALESCE(NULLIF(deleted, ''), 'N');

-- Product type
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_product_type' AND column_name = 'active') = 0, 'ALTER TABLE syntec_product_type ADD COLUMN active CHAR(1) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_product_type' AND column_name = 'deleted') = 0, 'ALTER TABLE syntec_product_type ADD COLUMN deleted CHAR(1) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
UPDATE syntec_product_type SET active = COALESCE(NULLIF(active, ''), CASE WHEN COALESCE(active_flag, 1) = 1 THEN 'Y' ELSE 'N' END), deleted = COALESCE(NULLIF(deleted, ''), 'N');

-- Divisions
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_divisions' AND column_name = 'active') = 0, 'ALTER TABLE syntec_divisions ADD COLUMN active CHAR(1) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_divisions' AND column_name = 'deleted') = 0, 'ALTER TABLE syntec_divisions ADD COLUMN deleted CHAR(1) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
UPDATE syntec_divisions SET active = COALESCE(NULLIF(active, ''), CASE WHEN COALESCE(active_flag, 1) = 1 THEN 'Y' ELSE 'N' END), deleted = COALESCE(NULLIF(deleted, ''), CASE WHEN COALESCE(deleted_flag, 0) = 1 THEN 'Y' ELSE 'N' END);

-- Job titles
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_job_titles' AND column_name = 'active') = 0, 'ALTER TABLE syntec_job_titles ADD COLUMN active CHAR(1) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_job_titles' AND column_name = 'deleted') = 0, 'ALTER TABLE syntec_job_titles ADD COLUMN deleted CHAR(1) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
UPDATE syntec_job_titles SET active = COALESCE(NULLIF(active, ''), CASE WHEN COALESCE(active_flag, 1) = 1 THEN 'Y' ELSE 'N' END), deleted = COALESCE(NULLIF(deleted, ''), CASE WHEN COALESCE(deleted_flag, 0) = 1 THEN 'Y' ELSE 'N' END);

-- Message enquiry type
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_message_enquiry_type' AND column_name = 'active') = 0, 'ALTER TABLE syntec_message_enquiry_type ADD COLUMN active CHAR(1) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_message_enquiry_type' AND column_name = 'deleted') = 0, 'ALTER TABLE syntec_message_enquiry_type ADD COLUMN deleted CHAR(1) NULL', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
UPDATE syntec_message_enquiry_type SET active = COALESCE(NULLIF(active, ''), CASE WHEN COALESCE(active_flag, 1) = 1 THEN 'Y' ELSE 'N' END), deleted = COALESCE(NULLIF(deleted, ''), CASE WHEN COALESCE(deleted_flag, 0) = 1 THEN 'Y' ELSE 'N' END);

