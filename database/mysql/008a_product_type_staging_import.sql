-- MySQL-ready staging import for syntec_product_type_staging
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE syntec_product_type_staging;
SET FOREIGN_KEY_CHECKS=1;

INSERT INTO syntec_product_type_staging (
  deleted,active,product_type_id,product_type_name,product_type_icon_class,product_type_order,date_created,date_deleted,anchor_id
)
VALUES
('N','Y','PTY-0004','Accessories',NULL,20,STR_TO_DATE('26-MAR-25','%d-%b-%y'),NULL,NULL),
('N','Y','PTY-0005','Related Products',NULL,6,STR_TO_DATE('26-MAR-25','%d-%b-%y'),NULL,NULL),
('N','Y','PTY-0001','Diagnostic Systems',NULL,1,STR_TO_DATE('21-JAN-25','%d-%b-%y'),NULL,NULL),
('N','Y','PTY-0002','Consumables',NULL,5,STR_TO_DATE('21-JAN-25','%d-%b-%y'),NULL,NULL),
('N','Y','PTY-0003','Reagents',NULL,10,STR_TO_DATE('21-JAN-25','%d-%b-%y'),NULL,NULL);
