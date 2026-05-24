-- Post-migration constraints for Oracle-style Y/N flags
-- Safe to re-run.

/* Drop numeric CHECK constraints where they exist */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_products' AND constraint_name = 'chk_syntec_products_active_flag') = 1, 'ALTER TABLE syntec_products DROP CHECK chk_syntec_products_active_flag', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_products' AND constraint_name = 'chk_syntec_products_featured_flag') = 1, 'ALTER TABLE syntec_products DROP CHECK chk_syntec_products_featured_flag', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

/* Normalize column types/defaults for Y/N fields */
ALTER TABLE syntec_products
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL;

ALTER TABLE syntec_suppliers
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL;

ALTER TABLE syntec_discipline
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL;

ALTER TABLE syntec_product_group
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL;

ALTER TABLE syntec_product_type
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL;

ALTER TABLE syntec_divisions
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL;

ALTER TABLE syntec_job_titles
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL;

ALTER TABLE syntec_message_enquiry_type
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL;

/* Add Y/N CHECK constraints if missing */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_products' AND constraint_name = 'chk_syntec_products_active_yn') = 0, 'ALTER TABLE syntec_products ADD CONSTRAINT chk_syntec_products_active_yn CHECK (active IN (''Y'',''N'') OR active IS NULL)', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_products' AND constraint_name = 'chk_syntec_products_deleted_yn') = 0, 'ALTER TABLE syntec_products ADD CONSTRAINT chk_syntec_products_deleted_yn CHECK (deleted IN (''Y'',''N'') OR deleted IS NULL)', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_suppliers' AND constraint_name = 'chk_syntec_suppliers_active_yn') = 0, 'ALTER TABLE syntec_suppliers ADD CONSTRAINT chk_syntec_suppliers_active_yn CHECK (active IN (''Y'',''N'') OR active IS NULL)', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_suppliers' AND constraint_name = 'chk_syntec_suppliers_deleted_yn') = 0, 'ALTER TABLE syntec_suppliers ADD CONSTRAINT chk_syntec_suppliers_deleted_yn CHECK (deleted IN (''Y'',''N'') OR deleted IS NULL)', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_discipline' AND constraint_name = 'chk_syntec_discipline_active_yn') = 0, 'ALTER TABLE syntec_discipline ADD CONSTRAINT chk_syntec_discipline_active_yn CHECK (active IN (''Y'',''N'') OR active IS NULL)', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_discipline' AND constraint_name = 'chk_syntec_discipline_deleted_yn') = 0, 'ALTER TABLE syntec_discipline ADD CONSTRAINT chk_syntec_discipline_deleted_yn CHECK (deleted IN (''Y'',''N'') OR deleted IS NULL)', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_product_group' AND constraint_name = 'chk_syntec_product_group_active_yn') = 0, 'ALTER TABLE syntec_product_group ADD CONSTRAINT chk_syntec_product_group_active_yn CHECK (active IN (''Y'',''N'') OR active IS NULL)', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_product_group' AND constraint_name = 'chk_syntec_product_group_deleted_yn') = 0, 'ALTER TABLE syntec_product_group ADD CONSTRAINT chk_syntec_product_group_deleted_yn CHECK (deleted IN (''Y'',''N'') OR deleted IS NULL)', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_product_type' AND constraint_name = 'chk_syntec_product_type_active_yn') = 0, 'ALTER TABLE syntec_product_type ADD CONSTRAINT chk_syntec_product_type_active_yn CHECK (active IN (''Y'',''N'') OR active IS NULL)', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_product_type' AND constraint_name = 'chk_syntec_product_type_deleted_yn') = 0, 'ALTER TABLE syntec_product_type ADD CONSTRAINT chk_syntec_product_type_deleted_yn CHECK (deleted IN (''Y'',''N'') OR deleted IS NULL)', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_divisions' AND constraint_name = 'chk_syntec_divisions_active_yn') = 0, 'ALTER TABLE syntec_divisions ADD CONSTRAINT chk_syntec_divisions_active_yn CHECK (active IN (''Y'',''N'') OR active IS NULL)', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_divisions' AND constraint_name = 'chk_syntec_divisions_deleted_yn') = 0, 'ALTER TABLE syntec_divisions ADD CONSTRAINT chk_syntec_divisions_deleted_yn CHECK (deleted IN (''Y'',''N'') OR deleted IS NULL)', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_job_titles' AND constraint_name = 'chk_syntec_job_titles_active_yn') = 0, 'ALTER TABLE syntec_job_titles ADD CONSTRAINT chk_syntec_job_titles_active_yn CHECK (active IN (''Y'',''N'') OR active IS NULL)', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_job_titles' AND constraint_name = 'chk_syntec_job_titles_deleted_yn') = 0, 'ALTER TABLE syntec_job_titles ADD CONSTRAINT chk_syntec_job_titles_deleted_yn CHECK (deleted IN (''Y'',''N'') OR deleted IS NULL)', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_message_enquiry_type' AND constraint_name = 'chk_syntec_message_enquiry_type_active_yn') = 0, 'ALTER TABLE syntec_message_enquiry_type ADD CONSTRAINT chk_syntec_message_enquiry_type_active_yn CHECK (active IN (''Y'',''N'') OR active IS NULL)', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = DATABASE() AND table_name = 'syntec_message_enquiry_type' AND constraint_name = 'chk_syntec_message_enquiry_type_deleted_yn') = 0, 'ALTER TABLE syntec_message_enquiry_type ADD CONSTRAINT chk_syntec_message_enquiry_type_deleted_yn CHECK (deleted IN (''Y'',''N'') OR deleted IS NULL)', 'SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

