  -- MySQL-ready staging import for syntec_sources_staging
  SET FOREIGN_KEY_CHECKS=0;
  TRUNCATE TABLE syntec_sources_staging;
  SET FOREIGN_KEY_CHECKS=1;

  INSERT INTO syntec_sources_staging (
    source_type_id,source_description
  )
  VALUES
  (1,'Products'),
  (2,'Contact Us Form'),
  (3,'Contact Us Team'),
  (4,'Contact Us Team Sales, Support & Servicing');
