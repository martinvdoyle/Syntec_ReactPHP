-- 017d_oracle_parity_verification.sql
-- Verify Oracle-named columns exist and hybrid _flag columns are gone.

/* should all be 0 */
SELECT 'suppliers_active_flag' AS check_name, COUNT(*) AS present_cols
FROM information_schema.columns
WHERE table_schema=DATABASE() AND table_name='syntec_suppliers' AND column_name='active_flag'
UNION ALL
SELECT 'products_active_flag', COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_products' AND column_name='active_flag'
UNION ALL
SELECT 'products_featured_flag', COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_products' AND column_name='featured_flag'
UNION ALL
SELECT 'discipline_active_flag', COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_discipline' AND column_name='active_flag'
UNION ALL
SELECT 'product_group_active_flag', COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_group' AND column_name='active_flag'
UNION ALL
SELECT 'product_type_active_flag', COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_type' AND column_name='active_flag'
UNION ALL
SELECT 'divisions_active_flag', COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_divisions' AND column_name='active_flag'
UNION ALL
SELECT 'divisions_deleted_flag', COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_divisions' AND column_name='deleted_flag'
UNION ALL
SELECT 'job_titles_active_flag', COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_job_titles' AND column_name='active_flag'
UNION ALL
SELECT 'job_titles_deleted_flag', COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_job_titles' AND column_name='deleted_flag'
UNION ALL
SELECT 'msg_enquiry_active_flag', COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_message_enquiry_type' AND column_name='active_flag'
UNION ALL
SELECT 'msg_enquiry_deleted_flag', COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_message_enquiry_type' AND column_name='deleted_flag';

/* should all be 0 invalid rows */
SELECT COUNT(*) AS suppliers_active_invalid FROM syntec_suppliers WHERE active IS NOT NULL AND active NOT IN ('Y','N');
SELECT COUNT(*) AS products_active_invalid FROM syntec_products WHERE active IS NOT NULL AND active NOT IN ('Y','N');
SELECT COUNT(*) AS products_deleted_invalid FROM syntec_products WHERE deleted IS NOT NULL AND deleted NOT IN ('Y','N');

