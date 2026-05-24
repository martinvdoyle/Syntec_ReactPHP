CREATE TABLE IF NOT EXISTS syntec_job_titles (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  job_title_code VARCHAR(20) NULL,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(255) NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  active_flag TINYINT(1) NOT NULL DEFAULT 1,
  deleted_flag TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_syntec_job_titles_slug (slug),
  KEY idx_syntec_job_titles_code (job_title_code),
  KEY idx_syntec_job_titles_active_sort (active_flag, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
