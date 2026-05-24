-- MySQL-ready staging import for syntec_divisions_staging
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE syntec_divisions_staging;
SET FOREIGN_KEY_CHECKS=1;

INSERT INTO syntec_divisions_staging (
  division_id,division_description,active,deleted,sort_order
)
VALUES
(6,'Sales','Y','N',10),
(7,'Logistics','Y','N',20),
(8,'Service','Y','N',30),
(9,'Accounts','Y','N',40),
(10,'Laboratory','Y','N',50),
(20,'Technology','Y','N',60);
