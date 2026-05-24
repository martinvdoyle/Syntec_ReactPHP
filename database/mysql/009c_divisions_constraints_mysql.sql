-- MySQL equivalent of Oracle_Exports/SYNTEC_DIVISIONS_CONSTRAINT.sql
-- Oracle had:
--  - DIVISION_ID NOT NULL
--  - DIVISION_DESCRIPTION NOT NULL
--  - ACTIVE IN ('Y','N')
--  - DELETED IN ('Y','N')
--  - PK on DIVISION_ID

-- 1) Staging (Oracle-shaped)
ALTER TABLE syntec_divisions_staging
  MODIFY division_id BIGINT NOT NULL,
  MODIFY division_description VARCHAR(100) NOT NULL,
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL;

ALTER TABLE syntec_divisions_staging
  ADD CONSTRAINT chk_divisions_stg_active_yn CHECK (active IN ('Y','N') OR active IS NULL),
  ADD CONSTRAINT chk_divisions_stg_deleted_yn CHECK (deleted IN ('Y','N') OR deleted IS NULL);

-- 2) Runtime (syntec_divisions)
ALTER TABLE syntec_divisions
  MODIFY division_code VARCHAR(20) NOT NULL;

ALTER TABLE syntec_divisions
  ADD UNIQUE KEY uq_syntec_divisions_code (division_code);
