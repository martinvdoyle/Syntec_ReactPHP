-- MySQL equivalent of Oracle_Exports/SUPPLIERS_CONSTRAINT.sql

ALTER TABLE syntec_suppliers_staging
  MODIFY supplier_id VARCHAR(20) NOT NULL,
  MODIFY supplier_name VARCHAR(255) NOT NULL,
  MODIFY deleted CHAR(1) NULL,
  MODIFY active CHAR(1) NULL;

ALTER TABLE syntec_suppliers_staging
  ADD CONSTRAINT chk_suppliers_stg_deleted_yn CHECK (deleted IN ('Y','N') OR deleted IS NULL),
  ADD CONSTRAINT chk_suppliers_stg_active_yn CHECK (active IN ('Y','N') OR active IS NULL);

ALTER TABLE syntec_suppliers
  MODIFY supplier_id VARCHAR(20) NOT NULL,
  MODIFY supplier_name VARCHAR(255) NOT NULL;

ALTER TABLE syntec_suppliers
  ADD UNIQUE KEY uq_syntec_suppliers_supplier_id (supplier_id);
