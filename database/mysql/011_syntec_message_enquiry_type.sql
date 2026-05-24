CREATE TABLE IF NOT EXISTS syntec_message_enquiry_type (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  enquiry_type_code VARCHAR(20) NULL,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(255) NOT NULL,
  email_address VARCHAR(255) NULL,
  active_flag TINYINT(1) NOT NULL DEFAULT 1,
  deleted_flag TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_syntec_message_enquiry_type_slug (slug),
  KEY idx_syntec_message_enquiry_type_code (enquiry_type_code),
  KEY idx_syntec_message_enquiry_type_active (active_flag)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
