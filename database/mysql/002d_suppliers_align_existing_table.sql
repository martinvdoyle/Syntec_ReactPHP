-- Align existing syntec_suppliers table in place (no re-import)

SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'supplier_id') = 0,
  'ALTER TABLE syntec_suppliers ADD COLUMN supplier_id VARCHAR(20) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'supplier_name') = 0,
  'ALTER TABLE syntec_suppliers ADD COLUMN supplier_name VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'website') = 0,
  'ALTER TABLE syntec_suppliers ADD COLUMN website VARCHAR(1024) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'profile_1') = 0,
  'ALTER TABLE syntec_suppliers ADD COLUMN profile_1 LONGTEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND column_name = 'supplier_logo_large') = 0,
  'ALTER TABLE syntec_suppliers ADD COLUMN supplier_logo_large VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE syntec_suppliers
SET
  supplier_id = COALESCE(NULLIF(supplier_id, ''), NULLIF(supplier_code, '')),
  supplier_name = COALESCE(NULLIF(supplier_name, ''), NULLIF(name, '')),
  website = COALESCE(NULLIF(website, ''), NULLIF(website_url, '')),
  profile_1 = COALESCE(NULLIF(profile_1, ''), NULLIF(short_description, '')),
  supplier_logo_large = COALESCE(NULLIF(supplier_logo_large, ''), NULLIF(logo_path, ''))
WHERE
  (supplier_id IS NULL OR supplier_id = '')
  OR (supplier_name IS NULL OR supplier_name = '')
  OR (website IS NULL OR website = '')
  OR (profile_1 IS NULL OR profile_1 = '')
  OR (supplier_logo_large IS NULL OR supplier_logo_large = '');

SET @dupes := (SELECT COUNT(*) FROM (SELECT supplier_id FROM syntec_suppliers WHERE supplier_id IS NOT NULL AND supplier_id <> '' GROUP BY supplier_id HAVING COUNT(*) > 1) d);
SET @sql := IF(@dupes = 0 AND (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'syntec_suppliers' AND index_name = 'uq_syntec_suppliers_supplier_id') = 0,
  'ALTER TABLE syntec_suppliers ADD UNIQUE KEY uq_syntec_suppliers_supplier_id (supplier_id)', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SELECT COUNT(*) AS rows_missing_supplier_id FROM syntec_suppliers WHERE supplier_id IS NULL OR supplier_id = '';
SELECT COUNT(*) AS rows_missing_supplier_name FROM syntec_suppliers WHERE supplier_name IS NULL OR supplier_name = '';
SELECT supplier_id, COUNT(*) AS c FROM syntec_suppliers WHERE supplier_id IS NOT NULL AND supplier_id <> '' GROUP BY supplier_id HAVING COUNT(*) > 1;
