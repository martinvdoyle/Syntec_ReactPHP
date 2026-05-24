-- Oracle SYNTEC_USERS direct migration to syntec_users

CREATE TABLE IF NOT EXISTS syntec_users_staging (
  user_id BIGINT NOT NULL,
  username VARCHAR(100) NULL,
  password VARCHAR(100) NULL,
  first_name VARCHAR(100) NULL,
  last_name VARCHAR(100) NULL,
  initials VARCHAR(10) NULL,
  email VARCHAR(200) NULL,
  alt_email VARCHAR(200) NULL,
  phone_01 VARCHAR(50) NULL,
  phone_02 VARCHAR(50) NULL,
  user_job_title BIGINT NULL,
  division BIGINT NULL,
  user_role BIGINT NULL,
  mobile VARCHAR(50) NULL,
  access_level INT NULL,
  isactive CHAR(1) NULL,
  is_deleted_yn CHAR(1) NULL,
  created DATETIME NULL,
  updated DATETIME NULL,
  locked CHAR(1) NULL,
  PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO syntec_users (
  user_code, username, first_name, last_name, full_name, email, alt_email, phone_01, phone_02, mobile,
  job_title_code, division_code, user_role_code, access_level, is_active, is_deleted_yn, locked, created_at, updated_at
)
SELECT
  CAST(s.user_id AS CHAR(20)),
  NULLIF(TRIM(s.username), ''),
  NULLIF(TRIM(s.first_name), ''),
  NULLIF(TRIM(s.last_name), ''),
  NULLIF(TRIM(CONCAT(COALESCE(s.first_name, ''), ' ', COALESCE(s.last_name, ''))), ''),
  NULLIF(TRIM(s.email), ''),
  NULLIF(TRIM(s.alt_email), ''),
  NULLIF(TRIM(s.phone_01), ''),
  NULLIF(TRIM(s.phone_02), ''),
  NULLIF(TRIM(s.mobile), ''),
  CASE WHEN s.user_job_title IS NULL THEN NULL ELSE CAST(s.user_job_title AS CHAR(20)) END,
  CASE WHEN s.division IS NULL THEN NULL ELSE CAST(s.division AS CHAR(20)) END,
  CASE WHEN s.user_role IS NULL THEN NULL ELSE CAST(s.user_role AS CHAR(20)) END,
  s.access_level,
  COALESCE(NULLIF(TRIM(s.isactive), ''), 'Y'),
  COALESCE(NULLIF(TRIM(s.is_deleted_yn), ''), 'N'),
  COALESCE(NULLIF(TRIM(s.locked), ''), 'N'),
  s.created,
  s.updated
FROM syntec_users_staging s
ON DUPLICATE KEY UPDATE
  username = VALUES(username),
  first_name = VALUES(first_name),
  last_name = VALUES(last_name),
  full_name = VALUES(full_name),
  email = VALUES(email),
  alt_email = VALUES(alt_email),
  phone_01 = VALUES(phone_01),
  phone_02 = VALUES(phone_02),
  mobile = VALUES(mobile),
  job_title_code = VALUES(job_title_code),
  division_code = VALUES(division_code),
  user_role_code = VALUES(user_role_code),
  access_level = VALUES(access_level),
  is_active = VALUES(is_active),
  is_deleted_yn = VALUES(is_deleted_yn),
  locked = VALUES(locked),
  created_at = VALUES(created_at),
  updated_at = VALUES(updated_at);

SELECT COUNT(*) AS staged_rows FROM syntec_users_staging;
SELECT COUNT(*) AS runtime_rows FROM syntec_users;
SELECT COUNT(*) AS missing_user_code FROM syntec_users WHERE user_code IS NULL OR user_code = '';
