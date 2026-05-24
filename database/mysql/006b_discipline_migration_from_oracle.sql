-- Oracle DISCIPLINE direct migration to syntec_discipline
-- Uses a full Oracle-shaped staging table, then upserts runtime fields.

CREATE TABLE IF NOT EXISTS syntec_discipline_staging (
  deleted CHAR(1) NULL,
  active CHAR(1) NULL,
  discipline_id VARCHAR(20) NOT NULL,
  discipline_name VARCHAR(100) NOT NULL,
  discipline_icon_class VARCHAR(100) NULL,
  discipline_order INT NULL,
  date_created DATETIME NULL,
  date_deleted DATETIME NULL,
  anchor_id VARCHAR(50) NULL,
  discipline_image_1 VARCHAR(200) NULL,
  discipline_image_2 VARCHAR(200) NULL,
  PRIMARY KEY (discipline_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO syntec_discipline (
  discipline_code,
  name,
  slug,
  description,
  image_path,
  icon,
  sort_order,
  active_flag,
  created_at,
  updated_at
)
SELECT
  s.discipline_id,
  TRIM(s.discipline_name),
  CASE
    WHEN TRIM(COALESCE(s.anchor_id, '')) <> '' THEN
      LOWER(TRIM(LEADING '_' FROM s.anchor_id))
    ELSE
      LOWER(
        REPLACE(
          REPLACE(
            REPLACE(TRIM(s.discipline_name), ' ', '-'),
            '/',
            '-'
          ),
          '&',
          'and'
        )
      )
  END,
  NULL,
  COALESCE(NULLIF(TRIM(s.discipline_image_1), ''), NULLIF(TRIM(s.discipline_image_2), '')),
  NULLIF(TRIM(s.discipline_icon_class), ''),
  COALESCE(s.discipline_order, 0),
  CASE WHEN COALESCE(s.active, 'Y') = 'Y' THEN 1 ELSE 0 END,
  COALESCE(s.date_created, NOW()),
  NOW()
FROM syntec_discipline_staging s
ON DUPLICATE KEY UPDATE
  discipline_code = VALUES(discipline_code),
  name = VALUES(name),
  slug = VALUES(slug),
  description = VALUES(description),
  image_path = VALUES(image_path),
  icon = VALUES(icon),
  sort_order = VALUES(sort_order),
  active_flag = VALUES(active_flag),
  updated_at = NOW();

SELECT COUNT(*) AS staged_rows FROM syntec_discipline_staging;
SELECT COUNT(*) AS runtime_rows FROM syntec_discipline;
SELECT COUNT(*) AS missing_discipline_code
FROM syntec_discipline
WHERE discipline_code IS NULL OR discipline_code = '';
