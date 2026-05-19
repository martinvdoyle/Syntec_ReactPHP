--------------------------------------------------------
--  DDL for Index PK_PRODUCTS_RELATED
--------------------------------------------------------

  CREATE UNIQUE INDEX "WEB"."PK_PRODUCTS_RELATED" ON "WEB"."PRODUCTS_RELATED" ("PRODUCT_ID", "PRODUCT_RELATED_ID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "DATA" ;
