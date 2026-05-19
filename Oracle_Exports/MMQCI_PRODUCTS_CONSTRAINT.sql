--------------------------------------------------------
--  Constraints for Table MMQCI_PRODUCTS
--------------------------------------------------------

  ALTER TABLE "WEB"."MMQCI_PRODUCTS" ADD PRIMARY KEY ("PRODUCT_ID")
  USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255 
  TABLESPACE "DATA"  ENABLE;
