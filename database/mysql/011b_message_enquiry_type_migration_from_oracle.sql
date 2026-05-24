-- Oracle SYNTEC_MESSAGE_ENQUIRY_TYPE direct migration to syntec_message_enquiry_type

CREATE TABLE IF NOT EXISTS syntec_message_enquiry_type_staging (
  enquiry_type_id BIGINT NOT NULL,
  enquiry_type_description VARCHAR(100) NOT NULL,
  email_address VARCHAR(255) NULL,
  active CHAR(1) NULL,
  deleted CHAR(1) NULL,
  PRIMARY KEY (enquiry_type_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO syntec_message_enquiry_type (
  enquiry_type_code,
  name,
  slug,
  email_address,
  active_flag,
  deleted_flag,
  updated_at
)
SELECT
  CAST(s.enquiry_type_id AS CHAR(20)),
  TRIM(s.enquiry_type_description),
  LOWER(
    REPLACE(
      REPLACE(
        REPLACE(TRIM(s.enquiry_type_description), ' ', '-'),
        '/',
        '-'
      ),
      '&',
      'and'
    )
  ),
  NULLIF(TRIM(s.email_address), ''),
  CASE WHEN COALESCE(s.active, 'Y') = 'Y' THEN 1 ELSE 0 END,
  CASE WHEN COALESCE(s.deleted, 'N') = 'Y' THEN 1 ELSE 0 END,
  NOW()
FROM syntec_message_enquiry_type_staging s
ON DUPLICATE KEY UPDATE
  enquiry_type_code = VALUES(enquiry_type_code),
  name = VALUES(name),
  slug = VALUES(slug),
  email_address = VALUES(email_address),
  active_flag = VALUES(active_flag),
  deleted_flag = VALUES(deleted_flag),
  updated_at = NOW();

SELECT COUNT(*) AS staged_rows FROM syntec_message_enquiry_type_staging;
SELECT COUNT(*) AS runtime_rows FROM syntec_message_enquiry_type;
SELECT COUNT(*) AS missing_enquiry_type_code
FROM syntec_message_enquiry_type
WHERE enquiry_type_code IS NULL OR enquiry_type_code = '';
