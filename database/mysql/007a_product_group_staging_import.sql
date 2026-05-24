-- MySQL-ready staging import for syntec_product_group_staging
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE syntec_product_group_staging;
SET FOREIGN_KEY_CHECKS=1;

INSERT INTO syntec_product_group_staging (
  deleted,active,product_group_id,product_group_name,discipline_name,product_group_icon_class,product_group_order,date_created,date_deleted,anchor_id,discipline_id,product_group_image_1,product_group_image_2
)
VALUES
('N','Y','PRG-0021','IFA Testing','Immunology',NULL,1,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_IFA','DIS-0002','assets/images/images_misc/Misc_86.jpg',NULL),
('N','Y','PRG-0022','Pipettes','Microbiology',NULL,1,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Pipettes','DIS-0003','assets/images/images_misc/Misc_92.jpg',NULL),
('N','Y','PRG-0034','Transport Media','Molecular Diagnostics',NULL,1,STR_TO_DATE('04-MAR-25','%d-%b-%y'),NULL,'_Transport_Media','DIS-0004','assets/images/images_misc/Misc_105.jpg',NULL),
('N','Y','PRG-0093','Consumables','Immunology',NULL,99,STR_TO_DATE('07-JAN-25','%d-%b-%y'),NULL,'_Consumables','DIS-0002','assets/images/images_misc/Misc_90.jpg',NULL),
('N','Y','PRG-0095','Consumables','Histopathology',NULL,99,STR_TO_DATE('07-JAN-25','%d-%b-%y'),NULL,'_Consumables','DIS-0001','assets/images/images_misc/Misc_87.jpg',NULL),
('N','Y','PRG-0094','Consumables','Microbiology',NULL,99,STR_TO_DATE('07-JAN-25','%d-%b-%y'),NULL,'_Consumables','DIS-0003','assets/images/images_misc/Misc_103.jpg',NULL),
('N','Y','PRG-0097','Reagents','Microbiology',NULL,99,STR_TO_DATE('07-JAN-25','%d-%b-%y'),NULL,'_Reagents','DIS-0003','assets/images/images_misc/Misc_104.jpg',NULL),
('N','Y','PRG-0096','Reagents','Histopathology',NULL,99,STR_TO_DATE('07-JAN-25','%d-%b-%y'),NULL,'_Reagents','DIS-0001','assets/images/images_misc/Misc_88.jpg',NULL),
('N','Y','PRG-0035','Molecular PCR','Molecular Diagnostics',NULL,1,STR_TO_DATE('04-MAR-25','%d-%b-%y'),NULL,'_Molecular PCR','DIS-0004','assets/images/images_misc/Misc_106.jpg',NULL),
('N','Y','PRG-0036','Next Gen. Sequencing','Molecular Diagnostics',NULL,1,STR_TO_DATE('04-MAR-25','%d-%b-%y'),NULL,'_Next_Generation','DIS-0004','assets/images/images_misc/Misc_107.jpg',NULL),
('N','Y','PRG-0030','Liquid-Handling','Microbiology',NULL,1,STR_TO_DATE('04-MAR-25','%d-%b-%y'),NULL,'_Liquid-Handling','DIS-0003','assets/images/images_misc/Misc_99.jpg',NULL),
('N','Y','PRG-0031','Lab-Ware','Microbiology',NULL,1,STR_TO_DATE('04-MAR-25','%d-%b-%y'),NULL,'_Lab-Ware','DIS-0003','assets/images/images_misc/Misc_100.jpg',NULL),
('N','Y','PRG-0032','Life Science','Microbiology',NULL,1,STR_TO_DATE('04-MAR-25','%d-%b-%y'),NULL,'_Life-Science','DIS-0003','assets/images/images_misc/Misc_101.jpg',NULL),
('N','Y','PRG-0033','Cryo','Microbiology',NULL,1,STR_TO_DATE('04-MAR-25','%d-%b-%y'),NULL,'_Cryo','DIS-0003','assets/images/images_misc/Misc_102.jpg',NULL),
('N','Y','PRG-0099','Consumables','Molecular Diagnostics',NULL,99,STR_TO_DATE('07-JAN-25','%d-%b-%y'),NULL,'_Consumables','DIS-0004','assets/images/images_misc/Misc_87.jpg',NULL),
('N','Y','PRG-0049','Cellular Therapies','Regenerative Sports & Wellness Surgery',NULL,1,STR_TO_DATE('14-JUL-25','%d-%b-%y'),NULL,'_Cellular_Therapies','DIS-0010',NULL,NULL),
('N','Y','PRG-0098','Molecular Controls','Molecular Diagnostics',NULL,1,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Molecular_Diagnostics','DIS-0004','assets/images/images_misc/Misc_108.jpg',NULL),
('N','Y','PRG-0001','Antibodies','Histopathology',NULL,3,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Antibodies','DIS-0001','assets/images/images_misc/Misc_77.jpg',NULL),
('N','Y','PRG-0002','Digital Analysis','Histopathology',NULL,2,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Digital','DIS-0001','assets/images/images_misc/Misc_78.jpg',NULL),
('N','Y','PRG-0003','Frozen Section','Histopathology',NULL,5,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Frozen','DIS-0001','assets/images/images_misc/Misc_79.jpg',NULL),
('N','Y','PRG-0004','Grossing','Histopathology',NULL,4,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Grossing','DIS-0001','assets/images/images_misc/Misc_80.jpg',NULL),
('N','Y','PRG-0005','Microtomy','Histopathology',NULL,1,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Microtomy','DIS-0001','assets/images/images_misc/Misc_81.jpg',NULL),
('N','Y','PRG-0006','Sample Handling','Histopathology',NULL,6,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Sample','DIS-0001','assets/images/images_misc/Misc_82.jpg',NULL),
('N','Y','PRG-0007','Staining & Coverslipping','Histopathology',NULL,7,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Staining','DIS-0001','assets/images/images_misc/Misc_83.jpg',NULL),
('N','Y','PRG-0008','Tissue Processing','Histopathology',NULL,8,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Tissue','DIS-0001','assets/images/images_misc/Misc_84.jpg',NULL),
('N','Y','PRG-0020','Staining','Microbiology',NULL,1,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Staining','DIS-0003','assets/images/images_misc/Misc_91.jpg',NULL),
('N','Y','PRG-0024','Culture Media','Microbiology',NULL,2,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Culture','DIS-0003','assets/images/images_misc/Misc_94.jpg',NULL),
('N','Y','PRG-0023','Incubators & Cabinets','Microbiology',NULL,1,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Incubators','DIS-0003','assets/images/images_misc/Misc_93.jpg',NULL),
('N','Y','PRG-0025','Molecular Controls','Microbiology',NULL,1,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Molecular_Microbiology','DIS-0003','assets/images/images_misc/Misc_95.jpg',NULL),
('N','Y','PRG-0026','Refrigeration','Microbiology',NULL,1,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Refrigeration','DIS-0003','assets/images/images_misc/Misc_96.jpg',NULL),
('N','Y','PRG-0027','Cellular Analytics','Microbiology',NULL,1,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Cellular','DIS-0003','assets/images/images_misc/Misc_97.jpg',NULL),
('N','Y','PRG-0028','Test kits','Microbiology',NULL,1,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Test_kits','DIS-0003','assets/images/images_misc/Misc_98.jpg',NULL),
('N','Y','PRG-0029','Autoimmunity','Immunology',NULL,1,STR_TO_DATE('05-JAN-25','%d-%b-%y'),NULL,'_Autoimmunity','DIS-0002','assets/images/images_misc/Misc_89.jpg',NULL),
('N','Y','PRG-0040','Sample Preparation','Homogenization',NULL,1,STR_TO_DATE('11-JUL-25','%d-%b-%y'),NULL,'_Sample_Preparation','DIS-0005',NULL,NULL),
('N','Y','PRG-0042','Tissue Preparation','Regenerative Surgery',NULL,1,STR_TO_DATE('11-JUL-25','%d-%b-%y'),NULL,'_Tissue_Preparation','DIS-0007',NULL,NULL),
('N','Y','PRG-0041','Sample Preparation','Flow Cytometry',NULL,1,STR_TO_DATE('11-JUL-25','%d-%b-%y'),NULL,'_Sample_Preparation','DIS-0006',NULL,NULL),
('N','Y','PRG-0043','Metabolic Testing','Sports Performance Testing',NULL,1,STR_TO_DATE('14-JUL-25','%d-%b-%y'),NULL,'_Metabolic_Testing','DIS-0009',NULL,NULL),
('N','Y','PRG-0044','Regenerative Therapies','Elite Sports Recovery',NULL,1,STR_TO_DATE('14-JUL-25','%d-%b-%y'),NULL,'_Regenerative_Therapies','DIS-0008',NULL,NULL),
('N','Y','PRG-0045','Restorative Therapies','Elite Sports Recovery',NULL,1,STR_TO_DATE('14-JUL-25','%d-%b-%y'),NULL,'_Restorative_Therapies','DIS-0008',NULL,NULL),
('N','Y','PRG-0046','Cryotherapy','Elite Sports Recovery',NULL,1,STR_TO_DATE('14-JUL-25','%d-%b-%y'),NULL,'_Cryotherapy','DIS-0008',NULL,NULL),
('N','Y','PRG-0047','Muscle Therapy','Elite Sports Recovery',NULL,1,STR_TO_DATE('14-JUL-25','%d-%b-%y'),NULL,'_Muscle_Therapy','DIS-0008',NULL,NULL),
('N','Y','PRG-0048','Light Therapy','Elite Sports Recovery',NULL,1,STR_TO_DATE('14-JUL-25','%d-%b-%y'),NULL,'_Light_Therapy','DIS-0008',NULL,NULL),
('N','Y','PRG-0100','Reagents','Molecular Diagnostics',NULL,99,STR_TO_DATE('10-JAN-25','%d-%b-%y'),NULL,'_Reagents','DIS-0004','assets/images/images_misc/Misc_104.jpg',NULL);
