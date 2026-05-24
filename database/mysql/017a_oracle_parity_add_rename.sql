-- 017a_oracle_parity_add_rename.sql
-- Goal: enforce Oracle column-name parity by adding Oracle-named columns and backfilling from current hybrid columns.
-- Safe to re-run.

/* 1) DISCIPLINE */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_discipline' AND column_name='discipline_id')=0,'ALTER TABLE syntec_discipline ADD COLUMN discipline_id VARCHAR(20) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_discipline' AND column_name='discipline_name')=0,'ALTER TABLE syntec_discipline ADD COLUMN discipline_name VARCHAR(100) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_discipline' AND column_name='discipline_icon_class')=0,'ALTER TABLE syntec_discipline ADD COLUMN discipline_icon_class VARCHAR(100) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_discipline' AND column_name='discipline_order')=0,'ALTER TABLE syntec_discipline ADD COLUMN discipline_order INT NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_discipline' AND column_name='date_created')=0,'ALTER TABLE syntec_discipline ADD COLUMN date_created DATETIME NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_discipline' AND column_name='date_deleted')=0,'ALTER TABLE syntec_discipline ADD COLUMN date_deleted DATETIME NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_discipline' AND column_name='anchor_id')=0,'ALTER TABLE syntec_discipline ADD COLUMN anchor_id VARCHAR(50) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_discipline' AND column_name='discipline_image_1')=0,'ALTER TABLE syntec_discipline ADD COLUMN discipline_image_1 VARCHAR(200) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_discipline' AND column_name='discipline_image_2')=0,'ALTER TABLE syntec_discipline ADD COLUMN discipline_image_2 VARCHAR(200) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
UPDATE syntec_discipline SET
discipline_id = COALESCE(NULLIF(discipline_id,''), NULLIF(discipline_code,'')),
discipline_name = COALESCE(NULLIF(discipline_name,''), NULLIF(name,'')),
discipline_icon_class = COALESCE(NULLIF(discipline_icon_class,''), NULLIF(icon,'')),
discipline_order = COALESCE(discipline_order, sort_order),
date_created = COALESCE(date_created, created_at),
anchor_id = COALESCE(NULLIF(anchor_id,''), NULLIF(slug,'')),
active = COALESCE(NULLIF(active,''), CASE WHEN COALESCE(active_flag,1)=1 THEN 'Y' ELSE 'N' END),
deleted = COALESCE(NULLIF(deleted,''), 'N');

/* 2) PRODUCT_GROUP */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_group' AND column_name='product_group_id')=0,'ALTER TABLE syntec_product_group ADD COLUMN product_group_id VARCHAR(20) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_group' AND column_name='product_group_name')=0,'ALTER TABLE syntec_product_group ADD COLUMN product_group_name VARCHAR(100) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_group' AND column_name='product_group_icon_class')=0,'ALTER TABLE syntec_product_group ADD COLUMN product_group_icon_class VARCHAR(100) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_group' AND column_name='product_group_order')=0,'ALTER TABLE syntec_product_group ADD COLUMN product_group_order INT NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_group' AND column_name='date_created')=0,'ALTER TABLE syntec_product_group ADD COLUMN date_created DATETIME NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_group' AND column_name='date_deleted')=0,'ALTER TABLE syntec_product_group ADD COLUMN date_deleted DATETIME NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_group' AND column_name='anchor_id')=0,'ALTER TABLE syntec_product_group ADD COLUMN anchor_id VARCHAR(50) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_group' AND column_name='product_group_image_1')=0,'ALTER TABLE syntec_product_group ADD COLUMN product_group_image_1 VARCHAR(200) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_group' AND column_name='product_group_image_2')=0,'ALTER TABLE syntec_product_group ADD COLUMN product_group_image_2 VARCHAR(200) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
UPDATE syntec_product_group SET
product_group_id = COALESCE(NULLIF(product_group_id,''), NULLIF(product_group_code,'')),
product_group_name = COALESCE(NULLIF(product_group_name,''), NULLIF(name,'')),
product_group_icon_class = COALESCE(NULLIF(product_group_icon_class,''), NULLIF(icon,'')),
product_group_order = COALESCE(product_group_order, sort_order),
date_created = COALESCE(date_created, created_at),
anchor_id = COALESCE(NULLIF(anchor_id,''), NULLIF(slug,'')),
product_group_image_1 = COALESCE(NULLIF(product_group_image_1,''), NULLIF(image_path,'')),
product_group_image_2 = COALESCE(NULLIF(product_group_image_2,''), NULLIF(image_path_2,'')),
active = COALESCE(NULLIF(active,''), CASE WHEN COALESCE(active_flag,1)=1 THEN 'Y' ELSE 'N' END),
deleted = COALESCE(NULLIF(deleted,''), 'N');

/* 3) PRODUCT_TYPE */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_type' AND column_name='product_type_id')=0,'ALTER TABLE syntec_product_type ADD COLUMN product_type_id VARCHAR(20) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_type' AND column_name='product_type_name')=0,'ALTER TABLE syntec_product_type ADD COLUMN product_type_name VARCHAR(100) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_type' AND column_name='product_type_icon_class')=0,'ALTER TABLE syntec_product_type ADD COLUMN product_type_icon_class VARCHAR(100) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_type' AND column_name='product_type_order')=0,'ALTER TABLE syntec_product_type ADD COLUMN product_type_order INT NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_type' AND column_name='date_created')=0,'ALTER TABLE syntec_product_type ADD COLUMN date_created DATETIME NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_type' AND column_name='date_deleted')=0,'ALTER TABLE syntec_product_type ADD COLUMN date_deleted DATETIME NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_product_type' AND column_name='anchor_id')=0,'ALTER TABLE syntec_product_type ADD COLUMN anchor_id VARCHAR(50) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
UPDATE syntec_product_type SET
product_type_id = COALESCE(NULLIF(product_type_id,''), NULLIF(product_type_code,'')),
product_type_name = COALESCE(NULLIF(product_type_name,''), NULLIF(name,'')),
product_type_icon_class = COALESCE(NULLIF(product_type_icon_class,''), NULLIF(icon,'')),
product_type_order = COALESCE(product_type_order, sort_order),
date_created = COALESCE(date_created, created_at),
anchor_id = COALESCE(NULLIF(anchor_id,''), NULLIF(slug,'')),
active = COALESCE(NULLIF(active,''), CASE WHEN COALESCE(active_flag,1)=1 THEN 'Y' ELSE 'N' END),
deleted = COALESCE(NULLIF(deleted,''), 'N');

/* 4) DIVISIONS */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_divisions' AND column_name='division_id')=0,'ALTER TABLE syntec_divisions ADD COLUMN division_id VARCHAR(20) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_divisions' AND column_name='division_description')=0,'ALTER TABLE syntec_divisions ADD COLUMN division_description VARCHAR(100) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_divisions' AND column_name='active')=0,'ALTER TABLE syntec_divisions ADD COLUMN active CHAR(1) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_divisions' AND column_name='deleted')=0,'ALTER TABLE syntec_divisions ADD COLUMN deleted CHAR(1) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
UPDATE syntec_divisions SET
active = COALESCE(NULLIF(active,''), CASE WHEN COALESCE(active_flag,1)=1 THEN 'Y' ELSE 'N' END),
deleted = COALESCE(NULLIF(deleted,''), CASE WHEN COALESCE(deleted_flag,0)=1 THEN 'Y' ELSE 'N' END),
division_id = COALESCE(NULLIF(division_id,''), NULLIF(division_code,'')),
division_description = COALESCE(NULLIF(division_description,''), NULLIF(name,''));

/* 5) JOB TITLES */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_job_titles' AND column_name='job_title_id')=0,'ALTER TABLE syntec_job_titles ADD COLUMN job_title_id VARCHAR(20) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_job_titles' AND column_name='job_title_description')=0,'ALTER TABLE syntec_job_titles ADD COLUMN job_title_description VARCHAR(100) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_job_titles' AND column_name='active')=0,'ALTER TABLE syntec_job_titles ADD COLUMN active CHAR(1) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_job_titles' AND column_name='deleted')=0,'ALTER TABLE syntec_job_titles ADD COLUMN deleted CHAR(1) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
UPDATE syntec_job_titles SET
active = COALESCE(NULLIF(active,''), CASE WHEN COALESCE(active_flag,1)=1 THEN 'Y' ELSE 'N' END),
deleted = COALESCE(NULLIF(deleted,''), CASE WHEN COALESCE(deleted_flag,0)=1 THEN 'Y' ELSE 'N' END),
job_title_id = COALESCE(NULLIF(job_title_id,''), NULLIF(job_title_code,'')),
job_title_description = COALESCE(NULLIF(job_title_description,''), NULLIF(name,''));

/* 6) MESSAGE_ENQUIRY_TYPE */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_message_enquiry_type' AND column_name='enquiry_type_id')=0,'ALTER TABLE syntec_message_enquiry_type ADD COLUMN enquiry_type_id VARCHAR(20) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_message_enquiry_type' AND column_name='enquiry_type_description')=0,'ALTER TABLE syntec_message_enquiry_type ADD COLUMN enquiry_type_description VARCHAR(100) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_message_enquiry_type' AND column_name='active')=0,'ALTER TABLE syntec_message_enquiry_type ADD COLUMN active CHAR(1) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_message_enquiry_type' AND column_name='deleted')=0,'ALTER TABLE syntec_message_enquiry_type ADD COLUMN deleted CHAR(1) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
UPDATE syntec_message_enquiry_type SET
active = COALESCE(NULLIF(active,''), CASE WHEN COALESCE(active_flag,1)=1 THEN 'Y' ELSE 'N' END),
deleted = COALESCE(NULLIF(deleted,''), CASE WHEN COALESCE(deleted_flag,0)=1 THEN 'Y' ELSE 'N' END),
enquiry_type_id = COALESCE(NULLIF(enquiry_type_id,''), NULLIF(enquiry_type_code,'')),
enquiry_type_description = COALESCE(NULLIF(enquiry_type_description,''), NULLIF(name,''));

/* 7) MESSAGE_TYPES */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_message_types' AND column_name='message_type_id')=0,'ALTER TABLE syntec_message_types ADD COLUMN message_type_id VARCHAR(20) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_message_types' AND column_name='message_description')=0,'ALTER TABLE syntec_message_types ADD COLUMN message_description VARCHAR(200) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
UPDATE syntec_message_types SET
message_type_id = COALESCE(NULLIF(message_type_id,''), NULLIF(message_type_code,'')),
message_description = COALESCE(NULLIF(message_description,''), NULLIF(name,''));

/* 8) SOURCES */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_sources' AND column_name='source_type_id')=0,'ALTER TABLE syntec_sources ADD COLUMN source_type_id VARCHAR(20) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_sources' AND column_name='source_description')=0,'ALTER TABLE syntec_sources ADD COLUMN source_description VARCHAR(200) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
UPDATE syntec_sources SET
source_type_id = COALESCE(NULLIF(source_type_id,''), NULLIF(source_type_code,'')),
source_description = COALESCE(NULLIF(source_description,''), NULLIF(name,''));

/* 9) USERS */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_users' AND column_name='user_id')=0,'ALTER TABLE syntec_users ADD COLUMN user_id VARCHAR(20) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_users' AND column_name='isactive')=0,'ALTER TABLE syntec_users ADD COLUMN isactive CHAR(1) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_users' AND column_name='created')=0,'ALTER TABLE syntec_users ADD COLUMN created DATETIME NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_users' AND column_name='updated')=0,'ALTER TABLE syntec_users ADD COLUMN updated DATETIME NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
UPDATE syntec_users SET
user_id = COALESCE(NULLIF(user_id,''), NULLIF(user_code,'')),
isactive = COALESCE(NULLIF(isactive,''), NULLIF(is_active,'')),
created = COALESCE(created, created_at),
updated = COALESCE(updated, updated_at);

/* 10) MESSAGES */
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_messages' AND column_name='message_id')=0,'ALTER TABLE syntec_messages ADD COLUMN message_id VARCHAR(20) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_messages' AND column_name='message_type')=0,'ALTER TABLE syntec_messages ADD COLUMN message_type VARCHAR(20) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_messages' AND column_name='source_type')=0,'ALTER TABLE syntec_messages ADD COLUMN source_type VARCHAR(20) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='syntec_messages' AND column_name='enquiry_type_id')=0,'ALTER TABLE syntec_messages ADD COLUMN enquiry_type_id VARCHAR(20) NULL','SELECT 1'); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
UPDATE syntec_messages SET
message_id = COALESCE(message_id, message_code),
message_type = COALESCE(message_type, message_type_code),
source_type = COALESCE(source_type, source_type_code),
enquiry_type_id = COALESCE(enquiry_type_id, enquiry_type_code);
