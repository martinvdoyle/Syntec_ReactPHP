  -- MySQL equivalent of Oracle_Exports/PRODUCT_GROUP_CONSTRAINT.sql
  -- Oracle had:
  --  - PRODUCT_GROUP_ID NOT NULL
  --  - PRODUCT_GROUP_NAME NOT NULL
  --  - deleted IN ('Y','N')
  --  - active IN ('Y','N')
  --  - PK on PRODUCT_GROUP_ID

  -- 1) Staging (Oracle-shaped)
  ALTER TABLE syntec_product_group_staging
    MODIFY product_group_id VARCHAR(20) NOT NULL,
    MODIFY product_group_name VARCHAR(100) NOT NULL,
    MODIFY deleted CHAR(1) NULL,
    MODIFY active CHAR(1) NULL;

  ALTER TABLE syntec_product_group_staging
    ADD CONSTRAINT chk_product_group_stg_deleted_yn CHECK (deleted IN ('Y','N') OR deleted IS NULL),
    ADD CONSTRAINT chk_product_group_stg_active_yn CHECK (active IN ('Y','N') OR active IS NULL);

  -- 2) Runtime (syntec_product_group)
  ALTER TABLE syntec_product_group
    MODIFY product_group_code VARCHAR(20) NOT NULL;

  ALTER TABLE syntec_product_group
    ADD UNIQUE KEY uq_syntec_product_group_code (product_group_code);
