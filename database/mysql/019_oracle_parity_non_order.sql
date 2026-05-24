-- Oracle parity non-order fixes
-- Static ALTER script (no information_schema access required)

/* =========================
   syntec_product_group
   ========================= */
ALTER TABLE syntec_product_group
  ADD COLUMN discipline_id VARCHAR(20) NULL;

ALTER TABLE syntec_product_group
  DROP COLUMN discipline_code;

ALTER TABLE syntec_product_group
  DROP COLUMN image_path_2;

/* =========================
   syntec_divisions
   ========================= */
ALTER TABLE syntec_divisions
  ADD COLUMN sort_order INT NULL;

/* =========================
   syntec_job_titles
   ========================= */
ALTER TABLE syntec_job_titles
  ADD COLUMN sort_order INT NULL;

/* =========================
   syntec_users - add missing Oracle columns
   ========================= */
ALTER TABLE syntec_users
  ADD COLUMN `password` VARCHAR(255) NULL,
  ADD COLUMN initials VARCHAR(20) NULL,
  ADD COLUMN user_job_title VARCHAR(100) NULL,
  ADD COLUMN division VARCHAR(100) NULL,
  ADD COLUMN user_role VARCHAR(100) NULL,
  ADD COLUMN address_line1 VARCHAR(255) NULL,
  ADD COLUMN address_line2 VARCHAR(255) NULL,
  ADD COLUMN address_line3 VARCHAR(255) NULL,
  ADD COLUMN town VARCHAR(100) NULL,
  ADD COLUMN county VARCHAR(100) NULL,
  ADD COLUMN country VARCHAR(100) NULL,
  ADD COLUMN eircode VARCHAR(30) NULL,
  ADD COLUMN linkedin VARCHAR(255) NULL,
  ADD COLUMN facebook VARCHAR(255) NULL,
  ADD COLUMN twitter VARCHAR(255) NULL,
  ADD COLUMN title VARCHAR(100) NULL,
  ADD COLUMN post_code VARCHAR(30) NULL,
  ADD COLUMN photo_blob LONGBLOB NULL,
  ADD COLUMN photo_name VARCHAR(255) NULL,
  ADD COLUMN photo_mimetype VARCHAR(255) NULL,
  ADD COLUMN photo_charset VARCHAR(100) NULL,
  ADD COLUMN photo_lastupd DATETIME NULL,
  ADD COLUMN isactive CHAR(1) NULL,
  ADD COLUMN deleted_by VARCHAR(100) NULL,
  ADD COLUMN deleted_on DATETIME NULL,
  ADD COLUMN created_by VARCHAR(100) NULL,
  ADD COLUMN updated_by VARCHAR(100) NULL;

/* =========================
   syntec_users - drop non-Oracle extras
   ========================= */
ALTER TABLE syntec_users DROP COLUMN full_name;
ALTER TABLE syntec_users DROP COLUMN job_title_code;
ALTER TABLE syntec_users DROP COLUMN division_code;
ALTER TABLE syntec_users DROP COLUMN user_role_code;
ALTER TABLE syntec_users DROP COLUMN is_active;

