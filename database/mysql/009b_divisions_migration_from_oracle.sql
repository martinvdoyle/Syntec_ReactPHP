-- Oracle SYNTEC_DIVISIONS direct migration to syntec_divisions
-- Uses an Oracle-shaped staging table, then upserts runtime fields.

CREATE TABLE IF NOT EXISTS syntec_divisions_staging (
  division_id BIGINT NOT NULL,
  division_description VARCHAR(100) NOT NULL,
  active CHAR(1) NULL,
  deleted CHAR(1) NULL,
  sort_order INT NULL,
  PRIMARY KEY (division_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO syntec_divisions (
  division_code,
  name,
  slug,
  sort_order,
  active_flag,
  deleted_flag,
  updated_at
)
SELECT
  CAST(s.division_id AS CHAR(20)),
  TRIM(s.division_description),
  LOWER(
    REPLACE(
      REPLACE(
        REPLACE(TRIM(s.division_description), ' ', '-'),
        '/',
        '-'
      ),
      '&',
      'and'
    )
  ),
  COALESCE(s.sort_order, 0),
  CASE WHEN COALESCE(s.active, 'Y') = 'Y' THEN 1 ELSE 0 END,
  CASE WHEN COALESCE(s.deleted, 'N') = 'Y' THEN 1 ELSE 0 END,
  NOW()
FROM syntec_divisions_staging s
ON DUPLICATE KEY UPDATE
  division_code = VALUES(division_code),
  name = VALUES(name),
  slug = VALUES(slug),
  sort_order = VALUES(sort_order),
  active_flag = VALUES(active_flag),
  deleted_flag = VALUES(deleted_flag),
  updated_at = NOW();

SELECT COUNT(*) AS staged_rows FROM syntec_divisions_staging;
SELECT COUNT(*) AS runtime_rows FROM syntec_divisions;
SELECT COUNT(*) AS missing_division_code
FROM syntec_divisions
WHERE division_code IS NULL OR division_code = '';
