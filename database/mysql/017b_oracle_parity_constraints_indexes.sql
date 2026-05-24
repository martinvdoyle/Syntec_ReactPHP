-- 017b_oracle_parity_constraints_indexes.sql
-- Oracle-parity checks on Y/N columns and key id/name columns used by legacy selects.

ALTER TABLE syntec_discipline
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL,
  MODIFY discipline_id VARCHAR(20) NULL,
  MODIFY discipline_name VARCHAR(100) NULL;

ALTER TABLE syntec_product_group
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL,
  MODIFY product_group_id VARCHAR(20) NULL,
  MODIFY product_group_name VARCHAR(100) NULL;

ALTER TABLE syntec_product_type
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL,
  MODIFY product_type_id VARCHAR(20) NULL,
  MODIFY product_type_name VARCHAR(100) NULL;

ALTER TABLE syntec_divisions
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL;

ALTER TABLE syntec_job_titles
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL;

ALTER TABLE syntec_message_enquiry_type
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL;

ALTER TABLE syntec_suppliers
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL;

ALTER TABLE syntec_products
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL;

