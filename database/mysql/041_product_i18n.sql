-- Product i18n table (non-EN translations only by convention).

CREATE TABLE IF NOT EXISTS syntec_product_i18n (
  product_id VARCHAR(100) NOT NULL,
  lang CHAR(2) NOT NULL,
  product_name VARCHAR(255) NULL,
  short_name TEXT NULL,
  about_1 MEDIUMTEXT NULL,
  about_2 MEDIUMTEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (product_id, lang),
  CONSTRAINT fk_syntec_product_i18n_product
    FOREIGN KEY (product_id)
    REFERENCES syntec_products (product_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_syntec_product_i18n_lang ON syntec_product_i18n (lang);
