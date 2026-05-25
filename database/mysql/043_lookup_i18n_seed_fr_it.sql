-- 043_lookup_i18n_seed_fr_it.sql
-- Purpose: Create/seed i18n rows for existing lookup records (non-EN only),
--          matching discipline manual-translation pattern.
-- Behavior: Inserts missing fr/it rows from current EN/base text; never overwrites existing fr/it.

CREATE TABLE IF NOT EXISTS syntec_product_group_i18n (
  product_group_id VARCHAR(50) NOT NULL,
  lang VARCHAR(5) NOT NULL,
  product_group_name VARCHAR(255) NULL,
  PRIMARY KEY (product_group_id, lang)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_syntec_product_group_i18n_lang ON syntec_product_group_i18n (lang);

CREATE TABLE IF NOT EXISTS syntec_product_type_i18n (
  product_type_id VARCHAR(50) NOT NULL,
  lang VARCHAR(5) NOT NULL,
  product_type_name VARCHAR(255) NULL,
  PRIMARY KEY (product_type_id, lang)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_syntec_product_type_i18n_lang ON syntec_product_type_i18n (lang);

CREATE TABLE IF NOT EXISTS syntec_divisions_i18n (
  division_id VARCHAR(50) NOT NULL,
  lang VARCHAR(5) NOT NULL,
  division_description VARCHAR(255) NULL,
  PRIMARY KEY (division_id, lang)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_syntec_divisions_i18n_lang ON syntec_divisions_i18n (lang);

CREATE TABLE IF NOT EXISTS syntec_job_titles_i18n (
  job_title_id VARCHAR(50) NOT NULL,
  lang VARCHAR(5) NOT NULL,
  job_title_description VARCHAR(255) NULL,
  PRIMARY KEY (job_title_id, lang)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_syntec_job_titles_i18n_lang ON syntec_job_titles_i18n (lang);

CREATE TABLE IF NOT EXISTS syntec_message_enquiry_type_i18n (
  enquiry_type_id VARCHAR(50) NOT NULL,
  lang VARCHAR(5) NOT NULL,
  enquiry_type_description VARCHAR(255) NULL,
  PRIMARY KEY (enquiry_type_id, lang)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_syntec_message_enquiry_type_i18n_lang ON syntec_message_enquiry_type_i18n (lang);

CREATE TABLE IF NOT EXISTS syntec_message_types_i18n (
  message_type_id VARCHAR(50) NOT NULL,
  lang VARCHAR(5) NOT NULL,
  message_description VARCHAR(255) NULL,
  PRIMARY KEY (message_type_id, lang)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_syntec_message_types_i18n_lang ON syntec_message_types_i18n (lang);

CREATE TABLE IF NOT EXISTS syntec_sources_i18n (
  source_type_id VARCHAR(50) NOT NULL,
  lang VARCHAR(5) NOT NULL,
  source_description VARCHAR(255) NULL,
  PRIMARY KEY (source_type_id, lang)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_syntec_sources_i18n_lang ON syntec_sources_i18n (lang);

-- Seed FR/IT rows for existing base records (insert missing only).
INSERT INTO syntec_product_group_i18n (product_group_id, lang, product_group_name)
SELECT g.product_group_id, l.lang, g.product_group_name
FROM syntec_product_group g
CROSS JOIN (SELECT 'fr' AS lang UNION ALL SELECT 'it') l
WHERE NOT EXISTS (
  SELECT 1
  FROM syntec_product_group_i18n x
  WHERE x.product_group_id = g.product_group_id
    AND x.lang = l.lang
);

INSERT INTO syntec_product_type_i18n (product_type_id, lang, product_type_name)
SELECT t.product_type_id, l.lang, t.product_type_name
FROM syntec_product_type t
CROSS JOIN (SELECT 'fr' AS lang UNION ALL SELECT 'it') l
WHERE NOT EXISTS (
  SELECT 1
  FROM syntec_product_type_i18n x
  WHERE x.product_type_id = t.product_type_id
    AND x.lang = l.lang
);

INSERT INTO syntec_divisions_i18n (division_id, lang, division_description)
SELECT d.division_id, l.lang, d.division_description
FROM syntec_divisions d
CROSS JOIN (SELECT 'fr' AS lang UNION ALL SELECT 'it') l
WHERE NOT EXISTS (
  SELECT 1
  FROM syntec_divisions_i18n x
  WHERE x.division_id = d.division_id
    AND x.lang = l.lang
);

INSERT INTO syntec_job_titles_i18n (job_title_id, lang, job_title_description)
SELECT j.job_title_id, l.lang, j.job_title_description
FROM syntec_job_titles j
CROSS JOIN (SELECT 'fr' AS lang UNION ALL SELECT 'it') l
WHERE NOT EXISTS (
  SELECT 1
  FROM syntec_job_titles_i18n x
  WHERE x.job_title_id = j.job_title_id
    AND x.lang = l.lang
);

INSERT INTO syntec_message_enquiry_type_i18n (enquiry_type_id, lang, enquiry_type_description)
SELECT e.enquiry_type_id, l.lang, e.enquiry_type_description
FROM syntec_message_enquiry_type e
CROSS JOIN (SELECT 'fr' AS lang UNION ALL SELECT 'it') l
WHERE NOT EXISTS (
  SELECT 1
  FROM syntec_message_enquiry_type_i18n x
  WHERE x.enquiry_type_id = e.enquiry_type_id
    AND x.lang = l.lang
);

INSERT INTO syntec_message_types_i18n (message_type_id, lang, message_description)
SELECT m.message_type_id, l.lang, m.message_description
FROM syntec_message_types m
CROSS JOIN (SELECT 'fr' AS lang UNION ALL SELECT 'it') l
WHERE NOT EXISTS (
  SELECT 1
  FROM syntec_message_types_i18n x
  WHERE x.message_type_id = m.message_type_id
    AND x.lang = l.lang
);

INSERT INTO syntec_sources_i18n (source_type_id, lang, source_description)
SELECT s.source_type_id, l.lang, s.source_description
FROM syntec_sources s
CROSS JOIN (SELECT 'fr' AS lang UNION ALL SELECT 'it') l
WHERE NOT EXISTS (
  SELECT 1
  FROM syntec_sources_i18n x
  WHERE x.source_type_id = s.source_type_id
    AND x.lang = l.lang
);
