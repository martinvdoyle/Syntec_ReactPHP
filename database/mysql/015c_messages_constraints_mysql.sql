-- MySQL equivalent constraints for SYNTEC_MESSAGES

ALTER TABLE syntec_messages_staging
  MODIFY message_id BIGINT NOT NULL;

ALTER TABLE syntec_messages
  MODIFY message_code VARCHAR(20) NOT NULL;

ALTER TABLE syntec_messages
  ADD CONSTRAINT fk_syntec_messages_message_type_code
    FOREIGN KEY (message_type_code) REFERENCES syntec_message_types (message_type_code),
  ADD CONSTRAINT fk_syntec_messages_source_type_code
    FOREIGN KEY (source_type_code) REFERENCES syntec_sources (source_type_code),
  ADD CONSTRAINT fk_syntec_messages_enquiry_type_code
    FOREIGN KEY (enquiry_type_code) REFERENCES syntec_message_enquiry_type (enquiry_type_code);
