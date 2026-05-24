-- Oracle SYNTEC_JOB_TITLES direct migration to syntec_job_titles
-- Uses an Oracle-shaped staging table, then upserts runtime fields.

CREATE TABLE IF NOT EXISTS syntec_job_titles_staging (
  job_title_id BIGINT NOT NULL,
  job_title_description VARCHAR(100) NOT NULL,
  active CHAR(1) NULL,
  deleted CHAR(1) NULL,
  sort_order INT NULL,
  PRIMARY KEY (job_title_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO syntec_job_titles (
  job_title_code,
  name,
  slug,
  sort_order,
  active_flag,
  deleted_flag,
  updated_at
)
SELECT
  CAST(s.job_title_id AS CHAR(20)),
  TRIM(s.job_title_description),
  LOWER(
    REPLACE(
      REPLACE(
        REPLACE(TRIM(s.job_title_description), ' ', '-'),
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
FROM syntec_job_titles_staging s
ON DUPLICATE KEY UPDATE
  job_title_code = VALUES(job_title_code),
  name = VALUES(name),
  slug = VALUES(slug),
  sort_order = VALUES(sort_order),
  active_flag = VALUES(active_flag),
  deleted_flag = VALUES(deleted_flag),
  updated_at = NOW();

SELECT COUNT(*) AS staged_rows FROM syntec_job_titles_staging;
SELECT COUNT(*) AS runtime_rows FROM syntec_job_titles;
SELECT COUNT(*) AS missing_job_title_code
FROM syntec_job_titles
WHERE job_title_code IS NULL OR job_title_code = '';
