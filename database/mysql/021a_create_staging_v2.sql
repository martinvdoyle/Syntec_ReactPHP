-- Fresh Oracle-parity staging tables (no hybrid columns)

DROP TABLE IF EXISTS syntec_suppliers_staging_v2;
CREATE TABLE syntec_suppliers_staging_v2 LIKE syntec_suppliers;

DROP TABLE IF EXISTS syntec_products_staging_v2;
CREATE TABLE syntec_products_staging_v2 LIKE syntec_products;

TRUNCATE TABLE syntec_suppliers_staging_v2;
TRUNCATE TABLE syntec_products_staging_v2;

