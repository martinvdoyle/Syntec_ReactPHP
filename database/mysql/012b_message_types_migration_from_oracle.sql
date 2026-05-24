  -- Oracle SYNTEC_MESSAGE_TYPES direct migration to syntec_message_types

  CREATE TABLE IF NOT EXISTS syntec_message_types_staging (
    message_type_id BIGINT NOT NULL,
    message_description VARCHAR(30) NULL,
    PRIMARY KEY (message_type_id)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

  INSERT INTO syntec_message_types (
    message_type_code,
    name,
    slug,
    updated_at
  )
  SELECT
    CAST(s.message_type_id AS CHAR(20)),
    NULLIF(TRIM(s.message_description), ''),
    CASE
      WHEN TRIM(COALESCE(s.message_description, '')) = '' THEN NULL
      ELSE LOWER(REPLACE(TRIM(s.message_description), ' ', '-'))
    END,
    NOW()
  FROM syntec_message_types_staging s
  ON DUPLICATE KEY UPDATE
    message_type_code = VALUES(message_type_code),
    name = VALUES(name),
    slug = VALUES(slug),
    updated_at = NOW();

  SELECT COUNT(*) AS staged_rows FROM syntec_message_types_staging;
  SELECT COUNT(*) AS runtime_rows FROM syntec_message_types;
  SELECT COUNT(*) AS missing_message_type_code
  FROM syntec_message_types
  WHERE message_type_code IS NULL OR message_type_code = '';
