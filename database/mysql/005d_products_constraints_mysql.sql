-- MySQL equivalent of Oracle_Exports/PRODUCTS_CONSTRAINT.sql

ALTER TABLE syntec_products_staging
  MODIFY product_id VARCHAR(20) NOT NULL,
  MODIFY product_name VARCHAR(255) NOT NULL,
  MODIFY supplier_id VARCHAR(20) NOT NULL;

ALTER TABLE syntec_products_staging
  ADD CONSTRAINT chk_products_stg_deleted_yn CHECK (deleted IN ('Y','N') OR deleted IS NULL),
  ADD CONSTRAINT chk_products_stg_active_yn CHECK (active IN ('Y','N') OR active IS NULL);

ALTER TABLE syntec_products
  MODIFY product_id VARCHAR(20) NOT NULL,
  MODIFY product_name VARCHAR(255) NOT NULL,
  MODIFY supplier_id VARCHAR(20) NOT NULL;

ALTER TABLE syntec_products
  ADD UNIQUE KEY uq_syntec_products_product_id (product_id);

ALTER TABLE syntec_products
  ADD CONSTRAINT chk_syntec_products_active_flag CHECK (active_flag IN (0,1)),
  ADD CONSTRAINT chk_syntec_products_featured_flag CHECK (featured_flag IN (0,1));
