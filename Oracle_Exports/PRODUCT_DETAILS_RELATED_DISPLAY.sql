--------------------------------------------------------
--  DDL for Function PRODUCT_DETAILS_RELATED_DISPLAY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."PRODUCT_DETAILS_RELATED_DISPLAY" 
(p_device_type IN VARCHAR2, p_workspace_url IN VARCHAR2, p_product_id IN VARCHAR2 )

RETURN CLOB IS


v_grid_html CLOB := '';



v_anchor_id         varchar2(200);  

v_PRODUCT_TYPE  varchar2(100);


   CURSOR c_product IS
                     SELECT 
                        PRODUCT_NAME,
                        PRODUCT_TYPE,
                        PRODUCT_IMAGE_LARGE,
                        PRODUCT_IMAGE_EXTERNAL,
                        DISCIPLINE,
                        DISCIPLINE_ID,
                        PRODUCT_GROUP,
                        PRODUCT_GROUP_ID,
                        PRODUCT_GROUP_TYPE_ALT, 
                        PRODUCT_GROUP_TYPE_ALT_ID,
                        SUPPLIER_NAME,
                        SUPPLIER_ID ,
                        SUPPLIER_LOGO_LARGE, 
                        SUPPLIER_LOGO_SMALL,
                        SUPPLIER_LOGO_LARGE_SCALE_SMALLER,
                        ROLLOVER_COLOUR,
                        PRODUCT_TYPE_ID,
                        PRODUCT_TYPE_NAME,
                        PRODUCT_ABOUT,
                        ANCHOR_ID,
                        PRODUCT_ENQUIRE,
                        PRODUCT_GROUP_ALT,
                        PRODUCT_GROUP_ALT_ID,
                        PRODUCT_IMAGE_LARGE_WIDTH, 
                        PRODUCT_IMAGE_LARGE_HEIGHT,
                        PRODUCT_LINK                       

                        FROM (
                        SELECT
                        p.PRODUCT_NAME,
                        p.PRODUCT_TYPE,
                        PRODUCT_IMAGE_LARGE,
                        PRODUCT_IMAGE_EXTERNAL,
                        p.DISCIPLINE,
                        d.DISCIPLINE_ID,
                        pg.PRODUCT_GROUP_NAME PRODUCT_GROUP,
                        p.PRODUCT_GROUP_ID,
                        p.PRODUCT_GROUP_TYPE_ALT_ID, 
                        pga.PRODUCT_GROUP_NAME PRODUCT_GROUP_TYPE_ALT,
                        s.SUPPLIER_ID,
                        s.SUPPLIER_NAME,
                        s.SUPPLIER_LOGO_LARGE, 
                        s.SUPPLIER_LOGO_SMALL,
                        s.CLASS_COLOUR ROLLOVER_COLOUR,
                        SUPPLIER_LOGO_LARGE_SCALE_SMALLER,
                        t.PRODUCT_TYPE_ID,
                        t.PRODUCT_TYPE_NAME,
                        PRODUCT_LINK,
                        REPLACE(ABOUT_1 , '#WORKSPACE_FILES#', p_workspace_url)   PRODUCT_ABOUT,
                        GET_ANCHOR_ID ('sup',p.DISCIPLINE_ID,p.PRODUCT_GROUP_ID,p.SUPPLIER_ID,p.PRODUCT_ID,'code')  ANCHOR_ID, 
                        decode(pga.PRODUCT_GROUP_ID,null,null,pga.PRODUCT_GROUP_NAME) PRODUCT_GROUP_ALT,
                        decode(pga.PRODUCT_GROUP_ID,null,null,pga.PRODUCT_GROUP_ID) PRODUCT_GROUP_ALT_ID,
                        PRODUCT_ENQUIRE,
                        PRODUCT_IMAGE_LARGE_WIDTH, 
                        PRODUCT_IMAGE_LARGE_HEIGHT

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
                                AND p.PRODUCT_ID  = p_product_id);



            c_product_rec       c_product%ROWTYPE;  -- Define a record variable based on the cursor

BEGIN
    OPEN c_product;
    FETCH c_product INTO c_product_rec;

    v_grid_html := v_grid_html || '<div class="heading main-heading centered padding-top-10">' ||
        '<h4 class="sub-title1">' || NVL(c_product_rec.PRODUCT_GROUP_ALT, '') ||
        '<span class="main-color"> ' || c_product_rec.PRODUCT_TYPE || '</span></h4>' ||
        '<div class="heading-separator"><span class="main-bg"></span><span class="dark-bg"></span></div>' ||
    '</div>';

    IF p_device_type = 'DESKTOP' THEN
        v_grid_html := v_grid_html || '<div id="'|| c_product_rec.ANCHOR_ID || '" class="container-syn padding-vertical-30">' ||
            '<div class="row">' ||
                '<div class="col-md-4 center-text" style="display: flex; flex-direction: column; align-items: center;">' ||
                    '<img class="fx animated fadeInLeft" alt="" src="' || PRODUCT_IMAGE_DISPLAY(NVL(NULLIF(SYS_CONTEXT('APEX$SESSION','WORKSPACE'),''),'SYNTEC'),'assets/images/Scientific/suppliers/',c_product_rec.PRODUCT_IMAGE_LARGE,c_product_rec.PRODUCT_IMAGE_EXTERNAL)  || '" ' ||
                    'style="margin-bottom:30px; ' ||
                    CASE WHEN TRIM(c_product_rec.PRODUCT_IMAGE_LARGE_WIDTH || c_product_rec.PRODUCT_IMAGE_LARGE_HEIGHT) IS NULL THEN 'width: 100%; height: auto;' 
                    ELSE 'width: ' || c_product_rec.PRODUCT_IMAGE_LARGE_WIDTH || '; height:' || c_product_rec.PRODUCT_IMAGE_LARGE_HEIGHT || ';' END || '"/>' ||
                           ' <img class="fx animated fadeInLeft" data-animate="fadeInLeft" alt="" src="' || p_workspace_url  || 'assets/images/Scientific/suppliers/'||c_product_rec.SUPPLIER_LOGO_LARGE||'" style="margin-bottom:30px; '||c_product_rec.SUPPLIER_LOGO_LARGE_SCALE_SMALLER||
                        ' "> '||

                '</div>' ||
                '<div class="col-md-8">' ||
                    '<h4 class="heavy-font">' || c_product_rec.PRODUCT_NAME || '</h4>' ||
                    '<p>' || c_product_rec.PRODUCT_ABOUT || '</p>' ||
                '</div>' ||
            '</div>' ||
        '</div>';
    ELSE
        v_grid_html := v_grid_html || '<div id="'|| c_product_rec.ANCHOR_ID || '" class="container-syn">' ||
            '<div class="row">' ||
                '<div class="col-md-12 center-text">' ||
                    '<img class="fx animated fadeInLeft" alt="" src="' || PRODUCT_IMAGE_DISPLAY(NVL(NULLIF(SYS_CONTEXT('APEX$SESSION','WORKSPACE'),''),'SYNTEC'),'assets/images/Scientific/suppliers/',c_product_rec.PRODUCT_IMAGE_LARGE,c_product_rec.PRODUCT_IMAGE_EXTERNAL)  || '" ' ||
                    'style="margin-bottom:30px; ' ||
                    CASE WHEN TRIM(c_product_rec.PRODUCT_IMAGE_LARGE_WIDTH || c_product_rec.PRODUCT_IMAGE_LARGE_HEIGHT) IS NULL THEN 'width: 100%; height: auto;' 
                    ELSE 'width: ' || c_product_rec.PRODUCT_IMAGE_LARGE_WIDTH || '; height:' || c_product_rec.PRODUCT_IMAGE_LARGE_HEIGHT || ';' END || '"/>' ||
                '</div>' ||
                '<div class="col-md-12">' ||
                    '<h4 class="heavy-font">' || c_product_rec.PRODUCT_NAME || '</h4>' ||
                    '<p>' || c_product_rec.PRODUCT_ABOUT || '</p>' ||
                '</div>' ||
            '</div>' ||
        '</div>';
    END IF;

    CLOSE c_product;
    RETURN v_grid_html;
END;

/
