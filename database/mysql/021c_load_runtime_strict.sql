-- Strict load: runtime tables replaced from v2 staging using direct column mapping only.
-- No fallback cloning, no derived defaults.

SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE syntec_products;
TRUNCATE TABLE syntec_suppliers;
SET FOREIGN_KEY_CHECKS=1;

INSERT INTO syntec_suppliers (
  active, deleted, supplier_id, supplier_name, short_name, class_id, class_colour, profile_1, profile_2,
  website, supplier_logo_large, supplier_logo_small, supplier_image_1, supplier_image_2, supplier_image_3, supplier_image_4,
  address_1, address_2, address_3, address_4, address_5, date_created, date_deleted, anchor_id,
  supplier_image_background, supplier_logo_large_scale_smaller, business
)
SELECT
  active, deleted, supplier_id, supplier_name, short_name, class_id, class_colour, profile_1, profile_2,
  website, supplier_logo_large, supplier_logo_small, supplier_image_1, supplier_image_2, supplier_image_3, supplier_image_4,
  address_1, address_2, address_3, address_4, address_5,
  NULLIF(date_created, '0000-00-00 00:00:00'),
  NULLIF(date_deleted, '0000-00-00 00:00:00'),
  anchor_id, supplier_image_background, supplier_logo_large_scale_smaller, business
FROM syntec_suppliers_staging_v2;

INSERT INTO syntec_products (
  deleted, active, product_id, product_name, product_name_web, short_name, product_sipplier_order, supplier_id,
  discipline, product_group, product_type, class_id, class_colour, about_1, about_2, product_link, product_enquire,
  product_image_large, product_image_small, product_image_1, product_image_2, product_image_3, product_image_4, product_parent_id,
  date_created, date_deleted, anchor_id, product_image_large_width, product_image_large_height, product_image_small_width,
  product_image_small_height, supplier_name, discipline_id, product_group_id, product_type_id, product_group_type_alt,
  product_group_type_alt_id, business, product_image_external, prouduct_sku, supplier_product_id
)
SELECT
  deleted, active, product_id, product_name, product_name_web, short_name, product_sipplier_order, supplier_id,
  discipline, product_group, product_type, class_id, class_colour, about_1, about_2, product_link, product_enquire,
  product_image_large, product_image_small, product_image_1, product_image_2, product_image_3, product_image_4, product_parent_id,
  NULLIF(date_created, '0000-00-00 00:00:00'),
  NULLIF(date_deleted, '0000-00-00 00:00:00'),
  anchor_id, product_image_large_width, product_image_large_height, product_image_small_width,
  product_image_small_height, supplier_name, discipline_id, product_group_id, product_type_id, product_group_type_alt,
  product_group_type_alt_id, business, product_image_external, prouduct_sku, supplier_product_id
FROM syntec_products_staging_v2;

