-- Syntec Discipline i18n pilot (en/fr/it)
-- Oracle-parity-safe: base table remains unchanged; translated text is isolated.

CREATE TABLE IF NOT EXISTS syntec_discipline_i18n (
  discipline_id VARCHAR(100) NOT NULL,
  lang CHAR(2) NOT NULL,
  discipline_name VARCHAR(255) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (discipline_id, lang),
  CONSTRAINT fk_syntec_discipline_i18n_discipline
    FOREIGN KEY (discipline_id)
    REFERENCES syntec_discipline (discipline_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_syntec_discipline_i18n_lang
  ON syntec_discipline_i18n (lang);

-- Seed English from current Oracle-parity base column.
INSERT INTO syntec_discipline_i18n (discipline_id, lang, discipline_name)
SELECT d.discipline_id, 'en', d.discipline_name
FROM syntec_discipline d
WHERE NOT EXISTS (
  SELECT 1
  FROM syntec_discipline_i18n x
  WHERE x.discipline_id = d.discipline_id
    AND x.lang = 'en'
);
