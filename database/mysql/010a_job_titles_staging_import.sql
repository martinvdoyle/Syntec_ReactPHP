-- MySQL-ready staging import for syntec_job_titles_staging
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE syntec_job_titles_staging;
SET FOREIGN_KEY_CHECKS=1;

INSERT INTO syntec_job_titles_staging (
  job_title_id,job_title_description,active,deleted,sort_order
)
VALUES
(12,'Founder & CEO','Y','N',10),
(13,'Sales Director','Y','N',20),
(14,'Business Development Executive','Y','N',30),
(15,'Product Sales Specialist','Y','N',40),
(16,'Key Account Manager','Y','N',50),
(17,'General Operations Manager','Y','N',60),
(18,'Logistics Manager','Y','N',70),
(19,'Warehouse Logistics Operator','Y','N',80),
(20,'Service Engineer','Y','N',90),
(21,'Accounts Manager','Y','N',100),
(22,'Chief Scientific Officer','Y','N',110),
(30,'IT Support','Y','N',120);
