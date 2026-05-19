--------------------------------------------------------
--  DDL for View VW_PRODUCT_ANTIBODY_FACETS_COMPAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WEB"."VW_PRODUCT_ANTIBODY_FACETS_COMPAT" ("PRODUCT_ID", "SUPPLIER_PRODUCT_ID", "HOST", "CLONE", "ANTIBODY_TYPE", "BRAND", "APPLICATION_CATEGORIES", "VISUALIZATION") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select p.PRODUCT_ID,
       p.SUPPLIER_PRODUCT_ID,
       max(case when d.FACET_CODE = 'HOST' then v.FACET_VALUE end) as HOST,
       max(case when d.FACET_CODE = 'CLONE' then v.FACET_VALUE end) as CLONE,
       max(case when d.FACET_CODE = 'ANTIBODY_TYPE' then v.FACET_VALUE end) as ANTIBODY_TYPE,
       max(case when d.FACET_CODE = 'BRAND' then v.FACET_VALUE end) as BRAND,
       listagg(case when d.FACET_CODE = 'SPECIALTIES' then v.FACET_VALUE end, ' | ')
         within group (order by v.FACET_VALUE) as APPLICATION_CATEGORIES,
       listagg(case when d.FACET_CODE = 'VISUALIZATION' then v.FACET_VALUE end, ', ')
         within group (order by v.FACET_VALUE) as VISUALIZATION
  from PRODUCTS p
  left join PRODUCT_FACET_VALUE v
    on v.CANONICAL_PRODUCT_ID = p.PRODUCT_ID
   and v.ACTIVE_YN = 'Y'
  left join FACET_DEFINITION d
    on d.FACET_ID = v.FACET_ID
 where p.SUPPLIER_ID = 'SUP-0003'
 group by p.PRODUCT_ID, p.SUPPLIER_PRODUCT_ID
;
