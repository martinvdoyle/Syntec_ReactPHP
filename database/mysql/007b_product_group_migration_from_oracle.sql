-- Oracle PRODUCT_GROUP direct migration to syntec_product_group
-- Uses an Oracle-shaped staging table, then upserts runtime fields.

CREATE TABLE IF NOT EXISTS syntec_product_group_staging (
  deleted CHAR(1) NULL,
  active CHAR(1) NULL,
  product_group_id VARCHAR(20) NOT NULL,
  product_group_name VARCHAR(100) NOT NULL,
  discipline_name VARCHAR(100) NULL,
  product_group_icon_class VARCHAR(100) NULL,
  product_group_order INT NULL,
  date_created DATETIME NULL,
  date_deleted DATETIME NULL,
  anchor_id VARCHAR(50) NULL,
  discipline_id VARCHAR(20) NULL,
  product_group_image_1 VARCHAR(200) NULL,
  product_group_image_2 VARCHAR(200) NULL,
  PRIMARY KEY (product_group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO syntec_product_group (
  product_group_code,
  name,
  slug,
  discipline_code,
  discipline_name,
  description,
  image_path,
  image_path_2,
  icon,
  sort_order,
  active_flag,
  created_at,
  updated_at
)
SELECT
  s.product_group_id,
  TRIM(s.product_group_name),
  CASE
    WHEN TRIM(COALESCE(s.anchor_id, '')) <> '' THEN
      LOWER(TRIM(LEADING '_' FROM s.anchor_id))
    ELSE
      LOWER(
        REPLACE(
          REPLACE(
            REPLACE(TRIM(s.product_group_name), ' ', '-'),
            '/',
            '-'
          ),
          '&',
          'and'
        )
      )
  END,
  NULLIF(TRIM(s.discipline_id), ''),
  NULLIF(TRIM(s.discipline_name), ''),
  NULL,
  NULLIF(TRIM(s.product_group_image_1), ''),
  NULLIF(TRIM(s.product_group_image_2), ''),
  NULLIF(TRIM(s.product_group_icon_class), ''),
  COALESCE(s.product_group_order, 0),
  CASE WHEN COALESCE(s.active, 'Y') = 'Y' THEN 1 ELSE 0 END,
  s.date_created,
  NOW()
FROM syntec_product_group_staging s
ON DUPLICATE KEY UPDATE
  product_group_code = VALUES(product_group_code),
  name = VALUES(name),
  slug = VALUES(slug),
  discipline_code = VALUES(discipline_code),
  discipline_name = VALUES(discipline_name),
  description = VALUES(description),
  image_path = VALUES(image_path),
  image_path_2 = VALUES(image_path_2),
  icon = VALUES(icon),
  sort_order = VALUES(sort_order),
  active_flag = VALUES(active_flag),
  updated_at = NOW();

SELECT COUNT(*) AS staged_rows FROM syntec_product_group_staging;
SELECT COUNT(*) AS runtime_rows FROM syntec_product_group;
SELECT COUNT(*) AS missing_product_group_code
FROM syntec_product_group
WHERE product_group_code IS NULL OR product_group_code = '';
