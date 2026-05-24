-- MySQL equivalent of Oracle_Exports/SYNTEC_USERS_CONSTRAINT.sql

ALTER TABLE syntec_users_staging
  MODIFY user_id BIGINT NOT NULL;

ALTER TABLE syntec_users
  MODIFY user_code VARCHAR(20) NOT NULL;

ALTER TABLE syntec_users
  ADD UNIQUE KEY uq_syntec_users_user_code_enforced (user_code);
