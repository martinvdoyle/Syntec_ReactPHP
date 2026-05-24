CREATE TABLE IF NOT EXISTS syntec_message_types (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  message_type_code VARCHAR(20) NULL,
  name VARCHAR(30) NULL,
  slug VARCHAR(255) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_syntec_message_types_slug (slug),
  KEY idx_syntec_message_types_code (message_type_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
