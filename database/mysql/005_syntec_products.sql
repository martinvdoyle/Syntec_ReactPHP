CREATE TABLE IF NOT EXISTS syntec_products (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  product_code VARCHAR(64) NULL,
  sku VARCHAR(64) NULL,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL,
  supplier_id BIGINT UNSIGNED NULL,
  short_description TEXT NULL,
  long_description LONGTEXT NULL,
  category_summary TEXT NULL,
  primary_image_path VARCHAR(1024) NULL,
  external_url VARCHAR(1024) NULL,
  active_flag TINYINT(1) NOT NULL DEFAULT 1,
  featured_flag TINYINT(1) NOT NULL DEFAULT 0,
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_syntec_products_slug (slug),
  KEY idx_syntec_products_supplier (supplier_id),
  KEY idx_syntec_products_active_sort (active_flag, sort_order),
  KEY idx_syntec_products_name (name),
  CONSTRAINT fk_syntec_products_supplier
    FOREIGN KEY (supplier_id)
    REFERENCES syntec_suppliers(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
