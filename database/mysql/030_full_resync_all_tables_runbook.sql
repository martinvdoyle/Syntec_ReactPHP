-- FULL RESYNC RUNBOOK (Oracle source -> staging -> runtime)
-- Execute in order. Do not skip verification gates.

-- 0) Freeze writes to admin while running.

-- 1) Core order (dependencies-safe):
--    discipline
--    product_group
--    product_type
--    syntec_divisions
--    syntec_job_titles
--    syntec_message_enquiry_type
--    syntec_message_types
--    syntec_sources
--    syntec_users
--    syntec_messages
--    suppliers
--    products

-- 2) For each table T:
--    A) Recreate T_staging_v2 with Oracle columns only.
--    B) Keep date columns as VARCHAR(20) during import.
--    C) Import converted Oracle values file for T into T_staging_v2.
--    D) Convert dates with STR_TO_DATE('%d-%b-%y').
--    E) Cast staging date columns back to DATETIME/DATE.
--    F) TRUNCATE runtime T.
--    G) INSERT runtime T SELECT ... FROM T_staging_v2 (1:1 mapping only).
--    H) Verify counts and required keys.

-- 3) Global verification queries after all tables:
SELECT 'syntec_discipline' t, COUNT(*) c FROM syntec_discipline
UNION ALL SELECT 'syntec_product_group', COUNT(*) FROM syntec_product_group
UNION ALL SELECT 'syntec_product_type', COUNT(*) FROM syntec_product_type
UNION ALL SELECT 'syntec_divisions', COUNT(*) FROM syntec_divisions
UNION ALL SELECT 'syntec_job_titles', COUNT(*) FROM syntec_job_titles
UNION ALL SELECT 'syntec_message_enquiry_type', COUNT(*) FROM syntec_message_enquiry_type
UNION ALL SELECT 'syntec_message_types', COUNT(*) FROM syntec_message_types
UNION ALL SELECT 'syntec_sources', COUNT(*) FROM syntec_sources
UNION ALL SELECT 'syntec_users', COUNT(*) FROM syntec_users
UNION ALL SELECT 'syntec_messages', COUNT(*) FROM syntec_messages
UNION ALL SELECT 'syntec_suppliers', COUNT(*) FROM syntec_suppliers
UNION ALL SELECT 'syntec_products', COUNT(*) FROM syntec_products;

-- 4) Required key checks:
SELECT COUNT(*) AS suppliers_missing_id FROM syntec_suppliers WHERE supplier_id IS NULL OR supplier_id='';
SELECT COUNT(*) AS products_missing_id  FROM syntec_products  WHERE product_id  IS NULL OR product_id='';
SELECT COUNT(*) AS discipline_missing_id FROM syntec_discipline WHERE discipline_id IS NULL OR discipline_id='';
SELECT COUNT(*) AS product_group_missing_id FROM syntec_product_group WHERE product_group_id IS NULL OR product_group_id='';
SELECT COUNT(*) AS product_type_missing_id FROM syntec_product_type WHERE product_type_id IS NULL OR product_type_id='';
SELECT COUNT(*) AS divisions_missing_id FROM syntec_divisions WHERE division_id IS NULL OR division_id='';
SELECT COUNT(*) AS job_titles_missing_id FROM syntec_job_titles WHERE job_title_id IS NULL OR job_title_id='';
SELECT COUNT(*) AS msg_enquiry_missing_id FROM syntec_message_enquiry_type WHERE enquiry_type_id IS NULL OR enquiry_type_id='';
SELECT COUNT(*) AS msg_types_missing_id FROM syntec_message_types WHERE message_type_id IS NULL OR message_type_id='';
SELECT COUNT(*) AS sources_missing_id FROM syntec_sources WHERE source_type_id IS NULL OR source_type_id='';
SELECT COUNT(*) AS users_missing_id FROM syntec_users WHERE user_id IS NULL OR user_id='';
SELECT COUNT(*) AS messages_missing_id FROM syntec_messages WHERE message_id IS NULL OR message_id='';

