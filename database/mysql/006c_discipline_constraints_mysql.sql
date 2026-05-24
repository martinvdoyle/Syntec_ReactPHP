-- MySQL equivalent of Oracle_Exports/DISCIPLINE_CONSTRAINT.sql
-- Oracle had:
--  - DISCIPLINE_ID NOT NULL
--  - DISCIPLINE_NAME NOT NULL
--  - deleted IN ('Y','N')
--  - active IN ('Y','N')
--  - PK on DISCIPLINE_ID

-- 1) Staging (Oracle-shaped)
ALTER TABLE syntec_discipline_staging
  MODIFY discipline_id VARCHAR(20) NOT NULL,
  MODIFY discipline_name VARCHAR(100) NOT NULL,
  MODIFY deleted CHAR(1) NULL,
  MODIFY active CHAR(1) NULL;

ALTER TABLE syntec_discipline_staging
  ADD CONSTRAINT chk_discipline_stg_deleted_yn CHECK (deleted IN ('Y','N') OR deleted IS NULL),
  ADD CONSTRAINT chk_discipline_stg_active_yn CHECK (active IN ('Y','N') OR active IS NULL);

-- 2) Runtime (syntec_discipline)
ALTER TABLE syntec_discipline
  MODIFY discipline_code VARCHAR(64) NOT NULL;

ALTER TABLE syntec_discipline
  ADD UNIQUE KEY uq_syntec_discipline_discipline_code (discipline_code);
