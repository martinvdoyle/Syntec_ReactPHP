-- MySQL equivalent of Oracle_Exports/PRODUCT_TYPE_CONSTRAINT.sql
-- Oracle had:
--  - PRODUCT_TYPE_ID NOT NULL
--  - PRODUCT_TYPE_NAME NOT NULL
--  - deleted IN ('Y','N')
--  - active IN ('Y','N')
--  - PK on PRODUCT_TYPE_ID

-- 1) Staging (Oracle-shaped)
ALTER TABLE syntec_product_type_staging
  MODIFY product_type_id VARCHAR(20) NOT NULL,
  MODIFY product_type_name VARCHAR(100) NOT NULL,
  MODIFY deleted CHAR(1) NULL,
  MODIFY active CHAR(1) NULL;

ALTER TABLE syntec_product_type_staging
  ADD CONSTRAINT chk_product_type_stg_deleted_yn CHECK (deleted IN ('Y','N') OR deleted IS NULL),
  ADD CONSTRAINT chk_product_type_stg_active_yn CHECK (active IN ('Y','N') OR active IS NULL);

-- 2) Runtime (syntec_product_type)
ALTER TABLE syntec_product_type
  MODIFY product_type_code VARCHAR(20) NOT NULL;

ALTER TABLE syntec_product_type
  ADD UNIQUE KEY uq_syntec_product_type_code (product_type_code);
