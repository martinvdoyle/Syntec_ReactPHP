-- 048_replace_workspace_files_assets_paths.sql
-- Purpose:
--   Replace Oracle APEX #WORKSPACE_FILES# asset placeholder with web-root path.
--   Canonical mapping confirmed in local app:
--   #WORKSPACE_FILES#assets/  ->  /assets/
--
-- Scope:
--   syntec_products.about_1
--   syntec_suppliers.profile_1
--
-- Notes:
--   - Uses WHERE guards so only matching rows are updated.
--   - Safe to re-run; once replaced, rows no longer match the WHERE pattern.

UPDATE syntec_products
SET about_1 = REPLACE(about_1, '#WORKSPACE_FILES#assets/', '/assets/')
WHERE about_1 LIKE '%#WORKSPACE_FILES#assets/%';

UPDATE syntec_suppliers
SET profile_1 = REPLACE(profile_1, '#WORKSPACE_FILES#assets/', '/assets/')
WHERE profile_1 LIKE '%#WORKSPACE_FILES#assets/%';

