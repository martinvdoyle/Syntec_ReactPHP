CREATE TABLE IF NOT EXISTS syntec_product_type (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  product_type_code VARCHAR(20) NULL,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(255) NOT NULL,
  description TEXT NULL,
  icon VARCHAR(100) NULL,
  sort_order INT NOT NULL DEFAULT 0,
  active_flag TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_syntec_product_type_slug (slug),
  KEY idx_syntec_product_type_code (product_type_code),
  KEY idx_syntec_product_type_active_sort (active_flag, sort_order),
  KEY idx_syntec_product_type_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
