-- 047_languages_admin.sql
-- Master language table for admin-driven i18n languages.

CREATE TABLE IF NOT EXISTS syntec_languages (
  lang_code VARCHAR(5) NOT NULL,
  lang_name VARCHAR(100) NOT NULL,
  flag_path VARCHAR(255) DEFAULT NULL,
  is_active CHAR(1) NOT NULL DEFAULT 'Y',
  sort_order INT NOT NULL DEFAULT 100,
  date_created DATETIME DEFAULT CURRENT_TIMESTAMP,
  date_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (lang_code),
  KEY idx_syntec_languages_active_sort (is_active, sort_order, lang_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO syntec_languages (lang_code, lang_name, flag_path, is_active, sort_order)
VALUES
  ('en', 'English', '/assets/images/flags/gb.svg', 'Y', 10),
  ('fr', 'French', '/assets/images/flags/fr.svg', 'Y', 20),
  ('it', 'Italian', '/assets/images/flags/it.svg', 'Y', 30)
ON DUPLICATE KEY UPDATE
  lang_name = VALUES(lang_name),
  flag_path = VALUES(flag_path),
  is_active = VALUES(is_active),
  sort_order = VALUES(sort_order);
