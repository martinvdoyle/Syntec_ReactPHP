-- MySQL equivalent of Oracle_Exports/SYNTEC_JOB_TITLES_CONSTRAINT.sql
-- Oracle had:
--  - JOB_TITLE_ID NOT NULL
--  - JOB_TITLE_DESCRIPTION NOT NULL
--  - ACTIVE IN ('Y','N')
--  - DELETED IN ('Y','N')
--  - PK on JOB_TITLE_ID

-- 1) Staging (Oracle-shaped)
ALTER TABLE syntec_job_titles_staging
  MODIFY job_title_id BIGINT NOT NULL,
  MODIFY job_title_description VARCHAR(100) NOT NULL,
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL;

ALTER TABLE syntec_job_titles_staging
  ADD CONSTRAINT chk_job_titles_stg_active_yn CHECK (active IN ('Y','N') OR active IS NULL),
  ADD CONSTRAINT chk_job_titles_stg_deleted_yn CHECK (deleted IN ('Y','N') OR deleted IS NULL);

-- 2) Runtime (syntec_job_titles)
ALTER TABLE syntec_job_titles
  MODIFY job_title_code VARCHAR(20) NOT NULL;

ALTER TABLE syntec_job_titles
  ADD UNIQUE KEY uq_syntec_job_titles_code (job_title_code);
