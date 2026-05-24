-- Oracle SYNTEC_SOURCES direct migration to syntec_sources

CREATE TABLE IF NOT EXISTS syntec_sources_staging (
  source_type_id BIGINT NOT NULL,
  source_description VARCHAR(255) NULL,
  PRIMARY KEY (source_type_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO syntec_sources (
  source_type_code,
  name,
  slug,
  updated_at
)
SELECT
  CAST(s.source_type_id AS CHAR(20)),
  NULLIF(TRIM(s.source_description), ''),
  CASE
    WHEN TRIM(COALESCE(s.source_description, '')) = '' THEN NULL
    ELSE LOWER(REPLACE(TRIM(s.source_description), ' ', '-'))
  END,
  NOW()
FROM syntec_sources_staging s
ON DUPLICATE KEY UPDATE
  source_type_code = VALUES(source_type_code),
  name = VALUES(name),
  slug = VALUES(slug),
  updated_at = NOW();

SELECT COUNT(*) AS staged_rows FROM syntec_sources_staging;
SELECT COUNT(*) AS runtime_rows FROM syntec_sources;
SELECT COUNT(*) AS missing_source_type_code
FROM syntec_sources
WHERE source_type_code IS NULL OR source_type_code = '';
