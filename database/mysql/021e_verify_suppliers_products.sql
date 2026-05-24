-- Verification after strict reload

SELECT COUNT(*) AS suppliers_runtime FROM syntec_suppliers;
SELECT COUNT(*) AS suppliers_staging_v2 FROM syntec_suppliers_staging_v2;
SELECT COUNT(*) AS products_runtime FROM syntec_products;
SELECT COUNT(*) AS products_staging_v2 FROM syntec_products_staging_v2;

SELECT COUNT(*) AS suppliers_missing_id FROM syntec_suppliers WHERE supplier_id IS NULL OR supplier_id='';
SELECT COUNT(*) AS suppliers_missing_name FROM syntec_suppliers WHERE supplier_name IS NULL OR supplier_name='';
SELECT COUNT(*) AS products_missing_id FROM syntec_products WHERE product_id IS NULL OR product_id='';
SELECT COUNT(*) AS products_missing_name FROM syntec_products WHERE product_name IS NULL OR product_name='';

SELECT supplier_id, supplier_logo_large, supplier_image_1, supplier_image_2, supplier_image_3, supplier_image_4
FROM syntec_suppliers
ORDER BY supplier_id
LIMIT 50;

SELECT product_id, product_name, product_image_1, product_image_2, product_image_3, product_image_4, product_link
FROM syntec_products
ORDER BY product_id
LIMIT 50;

