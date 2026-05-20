CREATE TABLE IF NOT EXISTS syntec_suppliers (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  supplier_code VARCHAR(64) NULL,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL,
  short_description TEXT NULL,
  website_url VARCHAR(1024) NULL,
  logo_path VARCHAR(1024) NULL,
  banner_path VARCHAR(1024) NULL,
  business_unit VARCHAR(128) NULL,
  sort_order INT NOT NULL DEFAULT 0,
  active_flag TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_syntec_suppliers_slug (slug),
  KEY idx_syntec_suppliers_active_sort (active_flag, sort_order),
  KEY idx_syntec_suppliers_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO syntec_suppliers
  (id, supplier_code, name, slug, short_description, website_url, logo_path, business_unit, sort_order, active_flag)
VALUES
  (1, 'SUP-0001', 'Syntec Scientific', 'syntec-scientific', 'Scientific diagnostic suppliers and brands.', 'https://www.syntec.ie', '/assets/images/Syntec_Scientific_Logo_Small.png', 'Scientific', 10, 1),
  (2, 'SUP-0002', 'Syntec International', 'syntec-international', 'International diagnostic and laboratory solutions.', 'https://www.syntec.ie', '/assets/images/Syntec_International_Logo_Small.png', 'International', 20, 1),
  (3, 'SUP-0003', 'SyS Laboratories', 'sys-laboratories', 'Surgery and specialist laboratory product suppliers.', 'https://www.syntec.ie', '/assets/images/Syntec_SysLabs_Logo_Small.png', 'SysLabs', 30, 1)
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  short_description = VALUES(short_description),
  website_url = VALUES(website_url),
  logo_path = VALUES(logo_path),
  business_unit = VALUES(business_unit),
  sort_order = VALUES(sort_order),
  active_flag = VALUES(active_flag);
