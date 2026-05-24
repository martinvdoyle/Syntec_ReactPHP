-- MySQL equivalent of Oracle_Exports/SYNTEC_MESSAGE_ENQUIRY_TYPE_CONSTRAINT.sql

ALTER TABLE syntec_message_enquiry_type_staging
  MODIFY enquiry_type_id BIGINT NOT NULL,
  MODIFY enquiry_type_description VARCHAR(100) NOT NULL,
  MODIFY active CHAR(1) NULL,
  MODIFY deleted CHAR(1) NULL;

ALTER TABLE syntec_message_enquiry_type_staging
  ADD CONSTRAINT chk_msg_enquiry_type_stg_active_yn CHECK (active IN ('Y','N') OR active IS NULL),
  ADD CONSTRAINT chk_msg_enquiry_type_stg_deleted_yn CHECK (deleted IN ('Y','N') OR deleted IS NULL);

ALTER TABLE syntec_message_enquiry_type
  MODIFY enquiry_type_code VARCHAR(20) NOT NULL;

ALTER TABLE syntec_message_enquiry_type
  ADD UNIQUE KEY uq_syntec_message_enquiry_type_code (enquiry_type_code);
