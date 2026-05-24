-- MySQL-ready staging import for syntec_users_staging
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE syntec_users_staging;
SET FOREIGN_KEY_CHECKS=1;

INSERT INTO syntec_users_staging (user_id,username,password,first_name,last_name,initials,email,alt_email,phone_01,phone_02,user_job_title,division,user_role,mobile,access_level,isactive,is_deleted_yn,created,updated,locked) VALUES
(1,NULL,NULL,'Raymond','Sinnott',NULL,'ray.sinnott@syntec.ie',NULL,'(+353)-1-8612100',NULL,12,6,NULL,NULL,NULL,'Y','N',NULL,NULL,'N'),
(2,NULL,NULL,'Conor','Drysdale',NULL,'conor.drysdale@syntec.ie',NULL,'(+353)-1-8612100',NULL,13,6,NULL,NULL,NULL,'Y','N',NULL,NULL,'N'),
(3,NULL,NULL,'Brian','Shalloe',NULL,'brian.shalloe@syntec.ie',NULL,'(+353)-1-8612100',NULL,14,6,NULL,NULL,NULL,'Y','N',NULL,NULL,'N'),
(4,NULL,NULL,'Karen','Sherlock',NULL,'Karen.Sherlock@syntec.ie',NULL,'(086) 0842089',NULL,15,6,NULL,NULL,NULL,'N','Y',NULL,NULL,'N'),
(5,NULL,NULL,'Peter','English',NULL,'peter.english@syntec.ie',NULL,'(+353)-1-8612100',NULL,16,6,NULL,NULL,NULL,'Y','N',NULL,NULL,'N'),
(6,NULL,NULL,'Hannah-May','Godkin',NULL,'hannahmay_godkin@syntec.ie',NULL,'(086) 0842087',NULL,15,6,NULL,NULL,NULL,'Y','N',NULL,NULL,'N'),
(7,NULL,NULL,'Mark','Sprague',NULL,'mark.sprague@syntec.ie',NULL,'(+353)-1-8612100',NULL,17,7,NULL,NULL,NULL,'Y','N',NULL,NULL,'N'),
(8,NULL,NULL,'Padraig','Carey',NULL,'padraig.carey@syntec.ie',NULL,'(+353)-1-8612100',NULL,18,7,NULL,NULL,NULL,'Y','N',NULL,NULL,'N'),
(9,NULL,NULL,'Peter','Day',NULL,'peter.day@syntec.ie',NULL,'(+353)-1-8612100',NULL,19,7,NULL,NULL,NULL,'Y','N',NULL,NULL,'N'),
(10,NULL,NULL,'Ken','Mullen',NULL,'ken.mullen@syntec.ie',NULL,'(+353)-1-8612100',NULL,19,7,NULL,NULL,NULL,'Y','N',NULL,NULL,'N'),
(11,NULL,NULL,'Robert','English',NULL,'robert.english@syntec.ie',NULL,'(+353)-860351325',NULL,20,8,NULL,NULL,NULL,'Y','N',NULL,NULL,'N'),
(12,NULL,NULL,'Alice','White',NULL,'alice.white@syntec.ie',NULL,'(+353)-1-8612100',NULL,21,9,NULL,NULL,NULL,'Y','N',NULL,NULL,'N'),
(13,NULL,NULL,'John','O''Loughlin',NULL,'john.oloughlin@syntec.ie',NULL,'(+353)-1-8612100',NULL,22,10,NULL,NULL,NULL,'Y','N',NULL,NULL,'N'),
(14,NULL,NULL,'Kerr','Livingston',NULL,'kerrlivingston@syntec.ie',NULL,'(+353)-1-8612100',NULL,23,10,NULL,NULL,NULL,'Y','N',NULL,NULL,'N'),
(21,NULL,NULL,'Martin','Doyle',NULL,'martinvdoyle@gmail.com',NULL,'(+353)-87-2523344',NULL,30,20,NULL,NULL,NULL,'N','N',NULL,NULL,'N'),
(22,'id_test_014334554',NULL,'Id','Test',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','N',NULL,NULL,'N');
