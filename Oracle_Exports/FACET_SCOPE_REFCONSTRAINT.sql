--------------------------------------------------------
--  Ref Constraints for Table FACET_SCOPE
--------------------------------------------------------

  ALTER TABLE "WEB"."FACET_SCOPE" ADD CONSTRAINT "FK_FACET_SCOPE_DEF" FOREIGN KEY ("FACET_ID")
	  REFERENCES "WEB"."FACET_DEFINITION" ("FACET_ID") ENABLE;
