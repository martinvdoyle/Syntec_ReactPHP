--------------------------------------------------------
--  Ref Constraints for Table PRODUCT_FACET_VALUE
--------------------------------------------------------

  ALTER TABLE "WEB"."PRODUCT_FACET_VALUE" ADD CONSTRAINT "FK_PROD_FACET_DEF" FOREIGN KEY ("FACET_ID")
	  REFERENCES "WEB"."FACET_DEFINITION" ("FACET_ID") ENABLE;
