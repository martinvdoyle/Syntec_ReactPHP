-- MySQL-ready staging import for syntec_discipline_staging
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE syntec_discipline_staging;
SET FOREIGN_KEY_CHECKS=1;

INSERT INTO syntec_discipline_staging (deleted,active,discipline_id,discipline_name,discipline_icon_class,discipline_order,date_created,date_deleted,anchor_id,discipline_image_1,discipline_image_2) VALUES
('N','Y','DIS-0001','Histopathology',NULL,1,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Histopathology','assets/images/sliders/Home/Home_1_1800x700.jpg',NULL),
('N','Y','DIS-0002','Immunology',NULL,2,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Immunology','assets/images/sliders/DNA/DNA_2.jpg',NULL),
('N','Y','DIS-0003','Microbiology',NULL,3,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Microbiology','assets/images/sliders/Home/Home_2.jpg',NULL),
('N','Y','DIS-0004','Molecular Diagnostics',NULL,4,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Molecular','assets/images/sliders/Home/Home_5.jpg',NULL),
('N','Y','DIS-0010','Regenerative Sports & Wellness Surgery',NULL,4,STR_TO_DATE('14-JUL-25','%d-%b-%y'),NULL,'_Wellness Surgery',NULL,NULL),
('N','Y','DIS-0005','Homogenization',NULL,4,STR_TO_DATE('11-JUL-25','%d-%b-%y'),NULL,'_Homogenization',NULL,NULL),
('N','Y','DIS-0006','Flow Cytometry',NULL,4,STR_TO_DATE('11-JUL-25','%d-%b-%y'),NULL,'_Flow_Cytometry',NULL,NULL),
('N','Y','DIS-0007','Regenerative Surgery',NULL,4,STR_TO_DATE('11-JUL-25','%d-%b-%y'),NULL,'_Regenerative_Surgery',NULL,NULL),
('N','Y','DIS-0008','Elite Sports Recovery',NULL,4,STR_TO_DATE('14-JUL-25','%d-%b-%y'),NULL,'_Sports_Recovery',NULL,NULL),
('N','Y','DIS-0009','Sports Performance Testing',NULL,4,STR_TO_DATE('14-JUL-25','%d-%b-%y'),NULL,'_Sports_Performance',NULL,NULL);
