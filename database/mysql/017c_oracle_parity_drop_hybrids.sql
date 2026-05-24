-- 017c_oracle_parity_drop_hybrids.sql
-- Drop known hybrid columns after running 017a + verification.
-- Safe pattern: conditional drop.

/* suppliers */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_suppliers' AND column_name='active_flag')=1,'ALTER TABLE syntec_suppliers DROP COLUMN active_flag','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_suppliers' AND column_name='slug')=1,'ALTER TABLE syntec_suppliers DROP COLUMN slug','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_suppliers' AND column_name='sort_order')=1,'ALTER TABLE syntec_suppliers DROP COLUMN sort_order','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

/* products */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_products' AND column_name='active_flag')=1,'ALTER TABLE syntec_products DROP COLUMN active_flag','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_products' AND column_name='featured_flag')=1,'ALTER TABLE syntec_products DROP COLUMN featured_flag','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_products' AND column_name='slug')=1,'ALTER TABLE syntec_products DROP COLUMN slug','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

/* lookup hybrids */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_discipline' AND column_name='active_flag')=1,'ALTER TABLE syntec_discipline DROP COLUMN active_flag','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_group' AND column_name='active_flag')=1,'ALTER TABLE syntec_product_group DROP COLUMN active_flag','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_type' AND column_name='active_flag')=1,'ALTER TABLE syntec_product_type DROP COLUMN active_flag','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_divisions' AND column_name='active_flag')=1,'ALTER TABLE syntec_divisions DROP COLUMN active_flag','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_divisions' AND column_name='deleted_flag')=1,'ALTER TABLE syntec_divisions DROP COLUMN deleted_flag','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_job_titles' AND column_name='active_flag')=1,'ALTER TABLE syntec_job_titles DROP COLUMN active_flag','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_job_titles' AND column_name='deleted_flag')=1,'ALTER TABLE syntec_job_titles DROP COLUMN deleted_flag','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_message_enquiry_type' AND column_name='active_flag')=1,'ALTER TABLE syntec_message_enquiry_type DROP COLUMN active_flag','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_message_enquiry_type' AND column_name='deleted_flag')=1,'ALTER TABLE syntec_message_enquiry_type DROP COLUMN deleted_flag','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

