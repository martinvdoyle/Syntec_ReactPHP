--------------------------------------------------------
--  DDL for View DISCIPLINE_PRODUCT_GROUP_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WEB"."DISCIPLINE_PRODUCT_GROUP_VIEW" ("PRODUCT_TYPE", "DISCIPLINE", "DISCIPLINE_ID", "PRODUCT_GROUP", "PRODUCT_GROUP_ID", "PRODUCT_GROUP_TYPE_ALT", "PRODUCT_GROUP_TYPE_ALT_ID", "SUPPLIER_NAME", "SUPPLIER_ID", "PRODUCT_TYPE_ID", "PRODUCT_TYPE_NAME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 
                                        PRODUCT_TYPE,
                                        DISCIPLINE,
                                        DISCIPLINE_ID,
                                        PRODUCT_GROUP,
                                        PRODUCT_GROUP_ID,
                                        PRODUCT_GROUP_TYPE_ALT, 
                                        PRODUCT_GROUP_TYPE_ALT_ID,

                                        SUPPLIER_NAME,
                                        SUPPLIER_ID ,
                                        PRODUCT_TYPE_ID,
                                        PRODUCT_TYPE_NAME
                                        FROM (
                                            SELECT DISTINCT
                                        p.PRODUCT_TYPE,
                                        p.DISCIPLINE,
                                        d.DISCIPLINE_ID,
                                        pg.PRODUCT_GROUP_NAME PRODUCT_GROUP,
                                        p.PRODUCT_GROUP_ID,
                                        p.PRODUCT_GROUP_TYPE_ALT_ID, 
                                        pga.PRODUCT_GROUP_NAME PRODUCT_GROUP_TYPE_ALT,
                                        s.SUPPLIER_ID,
                                        s.SUPPLIER_NAME,
                                        t.PRODUCT_TYPE_ID,
                                        t.PRODUCT_TYPE_NAME
                                            FROM 
                                                SUPPLIERS s,
                                                PRODUCTS p,
                                                PRODUCT_TYPE t,
                                                PRODUCT_GROUP pg,
                                                PRODUCT_GROUP pga,
                                                DISCIPLINE d
                                            WHERE 
                                                p.SUPPLIER_ID = s.SUPPLIER_ID
                                                AND s.DELETED = 'N'
                                                AND s.ACTIVE = 'Y'
                                                and p.PRODUCT_GROUP_ID = pg.PRODUCT_GROUP_ID
                                                and p.PRODUCT_GROUP_TYPE_ALT_ID = pga.PRODUCT_GROUP_ID(+)
                                                and p.PRODUCT_TYPE_ID = t.PRODUCT_TYPE_ID
                                                AND p.DELETED = 'N'
                                                AND p.ACTIVE = 'Y'
                                                AND pg.DELETED = 'N'
                                                AND pg.ACTIVE = 'Y'
                                                AND d.DISCIPLINE_ID = p.DISCIPLINE_ID
                                                and p.BUSINESS = 'Syntec Scientific')
;
