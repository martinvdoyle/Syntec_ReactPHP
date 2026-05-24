-- Oracle PRODUCT_TYPE direct migration to syntec_product_type
-- Uses an Oracle-shaped staging table, then upserts runtime fields.

CREATE TABLE IF NOT EXISTS syntec_product_type_staging (
  deleted CHAR(1) NULL,
  active CHAR(1) NULL,
  product_type_id VARCHAR(20) NOT NULL,
  product_type_name VARCHAR(100) NOT NULL,
  product_type_icon_class VARCHAR(100) NULL,
  product_type_order INT NULL,
  date_created DATETIME NULL,
  date_deleted DATETIME NULL,
  anchor_id VARCHAR(50) NULL,
  PRIMARY KEY (product_type_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO syntec_product_type (
  product_type_code,
  name,
  slug,
  description,
  icon,
  sort_order,
  active_flag,
  created_at,
  updated_at
)
SELECT
  s.product_type_id,
  TRIM(s.product_type_name),
  CASE
    WHEN TRIM(COALESCE(s.anchor_id, '')) <> '' THEN
      LOWER(TRIM(LEADING '_' FROM s.anchor_id))
    ELSE
      LOWER(
        REPLACE(
          REPLACE(
            REPLACE(TRIM(s.product_type_name), ' ', '-'),
            '/',
            '-'
          ),
          '&',
          'and'
        )
      )
  END,
  NULL,
  NULLIF(TRIM(s.product_type_icon_class), ''),
  COALESCE(s.product_type_order, 0),
  CASE WHEN COALESCE(s.active, 'Y') = 'Y' THEN 1 ELSE 0 END,
  s.date_created,
  NOW()
FROM syntec_product_type_staging s
ON DUPLICATE KEY UPDATE
  product_type_code = VALUES(product_type_code),
  name = VALUES(name),
  slug = VALUES(slug),
  description = VALUES(description),
  icon = VALUES(icon),
  sort_order = VALUES(sort_order),
  active_flag = VALUES(active_flag),
  updated_at = NOW();

SELECT COUNT(*) AS staged_rows FROM syntec_product_type_staging;
SELECT COUNT(*) AS runtime_rows FROM syntec_product_type;
SELECT COUNT(*) AS missing_product_type_code
FROM syntec_product_type
WHERE product_type_code IS NULL OR product_type_code = '';
