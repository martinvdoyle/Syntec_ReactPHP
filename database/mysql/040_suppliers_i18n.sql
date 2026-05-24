-- Suppliers i18n for profile fields (EN/FR/IT pilot).
-- Base table remains Oracle-parity source for non-language fields.

CREATE TABLE IF NOT EXISTS syntec_suppliers_i18n (
  supplier_id VARCHAR(100) NOT NULL,
  lang CHAR(2) NOT NULL,
  profile_1 MEDIUMTEXT NULL,
  profile_2 MEDIUMTEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (supplier_id, lang),
  CONSTRAINT fk_syntec_suppliers_i18n_supplier
    FOREIGN KEY (supplier_id)
    REFERENCES syntec_suppliers (supplier_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_syntec_suppliers_i18n_lang ON syntec_suppliers_i18n (lang);
