CREATE TABLE IF NOT EXISTS syntec_discipline (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  discipline_code VARCHAR(64) NULL,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL,
  description TEXT NULL,
  image_path VARCHAR(1024) NULL,
  icon VARCHAR(128) NULL,
  sort_order INT NOT NULL DEFAULT 0,
  active_flag TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_syntec_discipline_slug (slug),
  KEY idx_syntec_discipline_active_sort (active_flag, sort_order),
  KEY idx_syntec_discipline_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
