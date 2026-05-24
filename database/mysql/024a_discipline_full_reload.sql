-- DISCIPLINE full reload (Oracle-faithful)
-- Pattern: text-date staging -> import values -> STR_TO_DATE -> cast -> runtime load -> verify

/* 1) Recreate staging v2 with date columns as text */
DROP TABLE IF EXISTS syntec_discipline_staging_v2;
CREATE TABLE syntec_discipline_staging_v2 (
  deleted CHAR(1) NULL,
  active CHAR(1) NULL,
  discipline_id VARCHAR(20) NULL,
  discipline_name VARCHAR(100) NULL,
  discipline_icon_class VARCHAR(100) NULL,
  discipline_order INT NULL,
  date_created VARCHAR(20) NULL,
  date_deleted VARCHAR(20) NULL,
  anchor_id VARCHAR(50) NULL,
  discipline_image_1 VARCHAR(200) NULL,
  discipline_image_2 VARCHAR(200) NULL
);

/* 2) IMPORT STEP
   Run your discipline values SQL here targeting syntec_discipline_staging_v2.
   (Converted from Oracle_Exports/DISCIPLINE_DATA_TABLE.sql)
*/

/* 3) Convert Oracle date text DD-MON-RR -> MySQL datetime text */
UPDATE syntec_discipline_staging_v2
SET
  date_created = CASE
    WHEN date_created IS NULL OR date_created='' THEN NULL
    ELSE DATE_FORMAT(STR_TO_DATE(date_created, '%d-%b-%y'), '%Y-%m-%d %H:%i:%s')
  END,
  date_deleted = CASE
    WHEN date_deleted IS NULL OR date_deleted='' THEN NULL
    ELSE DATE_FORMAT(STR_TO_DATE(date_deleted, '%d-%b-%y'), '%Y-%m-%d %H:%i:%s')
  END;

/* 4) Cast staging date columns back to DATETIME */
ALTER TABLE syntec_discipline_staging_v2
  MODIFY date_created DATETIME NULL,
  MODIFY date_deleted DATETIME NULL;

/* 5) Replace runtime discipline from staging */
TRUNCATE TABLE syntec_discipline;

INSERT INTO syntec_discipline (
  deleted, active, discipline_id, discipline_name, discipline_icon_class, discipline_order,
  date_created, date_deleted, anchor_id, discipline_image_1, discipline_image_2
)
SELECT
  deleted, active, discipline_id, discipline_name, discipline_icon_class, discipline_order,
  date_created, date_deleted, anchor_id, discipline_image_1, discipline_image_2
FROM syntec_discipline_staging_v2;

/* 6) Verification */
SELECT COUNT(*) AS discipline_runtime FROM syntec_discipline;
SELECT COUNT(*) AS discipline_staging_v2 FROM syntec_discipline_staging_v2;
SELECT COUNT(*) AS discipline_missing_id FROM syntec_discipline WHERE discipline_id IS NULL OR discipline_id='';
SELECT COUNT(*) AS discipline_missing_name FROM syntec_discipline WHERE discipline_name IS NULL OR discipline_name='';
SELECT discipline_id, date_created, date_deleted, discipline_image_1, discipline_image_2
FROM syntec_discipline
ORDER BY discipline_id
LIMIT 50;

