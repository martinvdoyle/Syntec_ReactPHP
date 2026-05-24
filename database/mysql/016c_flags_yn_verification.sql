-- Defensive verification for Oracle-style Y/N flag normalization
-- Works even if some tables are missing in current schema.

DROP TEMPORARY TABLE IF EXISTS _flag_checks;
CREATE TEMPORARY TABLE _flag_checks (
  check_name VARCHAR(128) NOT NULL,
  bad_rows BIGINT NOT NULL
);

SET @sql = '';

-- products
SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'syntec_products') = 1,
  "INSERT INTO _flag_checks SELECT 'syntec_products.active_invalid', COUNT(*) FROM syntec_products WHERE active IS NOT NULL AND active NOT IN ('Y','N');
   INSERT INTO _flag_checks SELECT 'syntec_products.deleted_invalid', COUNT(*) FROM syntec_products WHERE deleted IS NOT NULL AND deleted NOT IN ('Y','N');",
  "INSERT INTO _flag_checks VALUES ('syntec_products.active_invalid', -1), ('syntec_products.deleted_invalid', -1);"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- suppliers
SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers') = 1,
  "INSERT INTO _flag_checks SELECT 'syntec_suppliers.active_invalid', COUNT(*) FROM syntec_suppliers WHERE active IS NOT NULL AND active NOT IN ('Y','N');
   INSERT INTO _flag_checks SELECT 'syntec_suppliers.deleted_invalid', COUNT(*) FROM syntec_suppliers WHERE deleted IS NOT NULL AND deleted NOT IN ('Y','N');",
  "INSERT INTO _flag_checks VALUES ('syntec_suppliers.active_invalid', -1), ('syntec_suppliers.deleted_invalid', -1);"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- discipline
SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'syntec_discipline') = 1,
  "INSERT INTO _flag_checks SELECT 'syntec_discipline.active_invalid', COUNT(*) FROM syntec_discipline WHERE active IS NOT NULL AND active NOT IN ('Y','N');
   INSERT INTO _flag_checks SELECT 'syntec_discipline.deleted_invalid', COUNT(*) FROM syntec_discipline WHERE deleted IS NOT NULL AND deleted NOT IN ('Y','N');",
  "INSERT INTO _flag_checks VALUES ('syntec_discipline.active_invalid', -1), ('syntec_discipline.deleted_invalid', -1);"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- product_group
SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'syntec_product_group') = 1,
  "INSERT INTO _flag_checks SELECT 'syntec_product_group.active_invalid', COUNT(*) FROM syntec_product_group WHERE active IS NOT NULL AND active NOT IN ('Y','N');
   INSERT INTO _flag_checks SELECT 'syntec_product_group.deleted_invalid', COUNT(*) FROM syntec_product_group WHERE deleted IS NOT NULL AND deleted NOT IN ('Y','N');",
  "INSERT INTO _flag_checks VALUES ('syntec_product_group.active_invalid', -1), ('syntec_product_group.deleted_invalid', -1);"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- product_type
SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'syntec_product_type') = 1,
  "INSERT INTO _flag_checks SELECT 'syntec_product_type.active_invalid', COUNT(*) FROM syntec_product_type WHERE active IS NOT NULL AND active NOT IN ('Y','N');
   INSERT INTO _flag_checks SELECT 'syntec_product_type.deleted_invalid', COUNT(*) FROM syntec_product_type WHERE deleted IS NOT NULL AND deleted NOT IN ('Y','N');",
  "INSERT INTO _flag_checks VALUES ('syntec_product_type.active_invalid', -1), ('syntec_product_type.deleted_invalid', -1);"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- divisions
SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'syntec_divisions') = 1,
  "INSERT INTO _flag_checks SELECT 'syntec_divisions.active_invalid', COUNT(*) FROM syntec_divisions WHERE active IS NOT NULL AND active NOT IN ('Y','N');
   INSERT INTO _flag_checks SELECT 'syntec_divisions.deleted_invalid', COUNT(*) FROM syntec_divisions WHERE deleted IS NOT NULL AND deleted NOT IN ('Y','N');",
  "INSERT INTO _flag_checks VALUES ('syntec_divisions.active_invalid', -1), ('syntec_divisions.deleted_invalid', -1);"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- job_titles
SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'syntec_job_titles') = 1,
  "INSERT INTO _flag_checks SELECT 'syntec_job_titles.active_invalid', COUNT(*) FROM syntec_job_titles WHERE active IS NOT NULL AND active NOT IN ('Y','N');
   INSERT INTO _flag_checks SELECT 'syntec_job_titles.deleted_invalid', COUNT(*) FROM syntec_job_titles WHERE deleted IS NOT NULL AND deleted NOT IN ('Y','N');",
  "INSERT INTO _flag_checks VALUES ('syntec_job_titles.active_invalid', -1), ('syntec_job_titles.deleted_invalid', -1);"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- message_enquiry_type
SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'syntec_message_enquiry_type') = 1,
  "INSERT INTO _flag_checks SELECT 'syntec_message_enquiry_type.active_invalid', COUNT(*) FROM syntec_message_enquiry_type WHERE active IS NOT NULL AND active NOT IN ('Y','N');
   INSERT INTO _flag_checks SELECT 'syntec_message_enquiry_type.deleted_invalid', COUNT(*) FROM syntec_message_enquiry_type WHERE deleted IS NOT NULL AND deleted NOT IN ('Y','N');",
  "INSERT INTO _flag_checks VALUES ('syntec_message_enquiry_type.active_invalid', -1), ('syntec_message_enquiry_type.deleted_invalid', -1);"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SELECT * FROM _flag_checks ORDER BY check_name;

SELECT table_name, column_name, data_type, column_type
FROM information_schema.columns
WHERE table_schema = DATABASE()
  AND table_name IN (
    'syntec_products',
    'syntec_suppliers',
    'syntec_discipline',
    'syntec_product_group',
    'syntec_product_type',
    'syntec_divisions',
    'syntec_job_titles',
    'syntec_message_enquiry_type'
  )
  AND column_name IN ('active','deleted','active_flag','deleted_flag','featured_flag')
ORDER BY table_name, column_name;

