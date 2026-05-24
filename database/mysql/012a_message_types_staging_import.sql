-- MySQL-ready staging import for syntec_message_types_staging
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE syntec_message_types_staging;
SET FOREIGN_KEY_CHECKS=1;

INSERT INTO syntec_message_types_staging (
  message_type_id,message_description
)
VALUES
(1,'Website');
