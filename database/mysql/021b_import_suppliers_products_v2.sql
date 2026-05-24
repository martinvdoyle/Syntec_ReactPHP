-- Import raw Oracle-export values into v2 staging.
-- IMPORTANT:
-- 1) Convert Oracle INSERT syntax to MySQL INSERT syntax first.
-- 2) Put converted suppliers values into 021b_suppliers_values_v2.sql
-- 3) Put converted products values into 021b_products_values_v2.sql
-- 4) Run this file in mysql CLI (SOURCE supported), not phpMyAdmin SQL textbox.

TRUNCATE TABLE syntec_suppliers_staging_v2;
TRUNCATE TABLE syntec_products_staging_v2;

SOURCE database/mysql/021b_suppliers_values_v2.sql;
SOURCE database/mysql/021b_products_values_v2.sql;

