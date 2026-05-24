-- MySQL equivalent of Oracle_Exports/SYNTEC_SOURCES_CONSTRAINT.sql

ALTER TABLE syntec_sources_staging
  MODIFY source_type_id BIGINT NOT NULL;

ALTER TABLE syntec_sources
  MODIFY source_type_code VARCHAR(20) NOT NULL;

ALTER TABLE syntec_sources
  ADD UNIQUE KEY uq_syntec_sources_code (source_type_code);
