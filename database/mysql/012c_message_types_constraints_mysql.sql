  -- MySQL equivalent of Oracle_Exports/SYNTEC_MESSAGE_TYPES_CONSTRAINT.sql

  ALTER TABLE syntec_message_types_staging
    MODIFY message_type_id BIGINT NOT NULL;

  ALTER TABLE syntec_message_types
    MODIFY message_type_code VARCHAR(20) NOT NULL;

  ALTER TABLE syntec_message_types
    ADD UNIQUE KEY uq_syntec_message_types_code (message_type_code);
