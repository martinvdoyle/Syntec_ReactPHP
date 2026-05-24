-- Oracle SYNTEC_MESSAGES direct migration to syntec_messages

CREATE TABLE IF NOT EXISTS syntec_messages_staging (
  message_id BIGINT NOT NULL,
  name VARCHAR(100) NULL,
  organisation VARCHAR(100) NULL,
  email VARCHAR(100) NULL,
  phone VARCHAR(30) NULL,
  message_date DATE NULL,
  message_time VARCHAR(8) NULL,
  message_type BIGINT NULL,
  source_type BIGINT NULL,
  created_date DATE NULL,
  product_id VARCHAR(200) NULL,
  subject VARCHAR(255) NULL,
  enquiry_type_id BIGINT NULL,
  ip_address VARCHAR(45) NULL,
  city VARCHAR(100) NULL,
  region VARCHAR(100) NULL,
  country_name VARCHAR(100) NULL,
  device_type VARCHAR(50) NULL,
  browser_type VARCHAR(50) NULL,
  user_agent VARCHAR(4000) NULL,
  os VARCHAR(50) NULL,
  website_user_email VARCHAR(255) NULL,
  message_ref VARCHAR(30) NULL,
  PRIMARY KEY (message_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO syntec_messages (
  message_code, name, organisation, email, phone, message, message_date, message_time,
  message_type_code, source_type_code, created_date, product_id, subject, enquiry_type_code,
  ip_address, city, region, country_name, device_type, browser_type, user_agent, os,
  website_user_email, message_ref, updated_at
)
SELECT
  CAST(s.message_id AS CHAR(20)),
  NULLIF(TRIM(s.name), ''),
  NULLIF(TRIM(s.organisation), ''),
  NULLIF(TRIM(s.email), ''),
  NULLIF(TRIM(s.phone), ''),
  NULL,
  s.message_date,
  NULLIF(TRIM(s.message_time), ''),
  CASE WHEN s.message_type IS NULL THEN NULL ELSE CAST(s.message_type AS CHAR(20)) END,
  CASE WHEN s.source_type IS NULL THEN NULL ELSE CAST(s.source_type AS CHAR(20)) END,
  s.created_date,
  NULLIF(TRIM(s.product_id), ''),
  NULLIF(TRIM(s.subject), ''),
  CASE WHEN s.enquiry_type_id IS NULL THEN NULL ELSE CAST(s.enquiry_type_id AS CHAR(20)) END,
  NULLIF(TRIM(s.ip_address), ''),
  NULLIF(TRIM(s.city), ''),
  NULLIF(TRIM(s.region), ''),
  NULLIF(TRIM(s.country_name), ''),
  NULLIF(TRIM(s.device_type), ''),
  NULLIF(TRIM(s.browser_type), ''),
  NULLIF(TRIM(s.user_agent), ''),
  NULLIF(TRIM(s.os), ''),
  NULLIF(TRIM(s.website_user_email), ''),
  NULLIF(TRIM(s.message_ref), ''),
  NOW()
FROM syntec_messages_staging s
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  organisation = VALUES(organisation),
  email = VALUES(email),
  phone = VALUES(phone),
  message = VALUES(message),
  message_date = VALUES(message_date),
  message_time = VALUES(message_time),
  message_type_code = VALUES(message_type_code),
  source_type_code = VALUES(source_type_code),
  created_date = VALUES(created_date),
  product_id = VALUES(product_id),
  subject = VALUES(subject),
  enquiry_type_code = VALUES(enquiry_type_code),
  ip_address = VALUES(ip_address),
  city = VALUES(city),
  region = VALUES(region),
  country_name = VALUES(country_name),
  device_type = VALUES(device_type),
  browser_type = VALUES(browser_type),
  user_agent = VALUES(user_agent),
  os = VALUES(os),
  website_user_email = VALUES(website_user_email),
  message_ref = VALUES(message_ref),
  updated_at = NOW();

SELECT COUNT(*) AS staged_rows FROM syntec_messages_staging;
SELECT COUNT(*) AS runtime_rows FROM syntec_messages;
SELECT COUNT(*) AS missing_message_code FROM syntec_messages WHERE message_code IS NULL OR message_code = '';
