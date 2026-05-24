-- MySQL-ready staging import for syntec_message_enquiry_type_staging
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE syntec_message_enquiry_type_staging;
SET FOREIGN_KEY_CHECKS=1;

INSERT INTO syntec_message_enquiry_type_staging (
  enquiry_type_id,enquiry_type_description,email_address,active,deleted
)
VALUES
(1,'Sales','syntec.website@gmail.com','Y','N'),
(2,'Support','syntec.website@gmail.com','Y','N'),
(3,'Accounts','syntec.website@gmail.com','Y','N'),
(4,'Service','syntec.website@gmail.com','Y','N'),
(30,'General Enquiry','syntec.website@gmail.com','Y','N'),
(5,'Distribution','syntec.website@gmail.com','Y','N');
