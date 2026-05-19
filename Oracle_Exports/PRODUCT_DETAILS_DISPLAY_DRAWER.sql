--------------------------------------------------------
--  DDL for Function PRODUCT_DETAILS_DISPLAY_DRAWER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."PRODUCT_DETAILS_DISPLAY_DRAWER" 
(p_device_type IN VARCHAR2, p_workspace_url IN VARCHAR2, p_app_id IN number, p_app_alias IN VARCHAR2, p_product_id IN VARCHAR2, p_Show_related IN VARCHAR2)

RETURN CLOB IS


v_grid_html CLOB := '';



v_anchor_id         varchar2(200);  

v_PRODUCT_TYPE  varchar2(100);


   CURSOR c_product IS
                     SELECT 
                        PRODUCT_ID,
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
                        p.PRODUCT_ID,
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
                        REPLACE(
                                    REPLACE(
                                        REPLACE(ABOUT_1, '#WORKSPACE_FILES#', p_workspace_url),
                                        '&APP_ID.', p_app_id
                                    ),
                                    '&APP_ALIAS.', p_app_alias
                                ) AS PRODUCT_ABOUT,
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
        '<h4 class="sub-title1">' || 
         CASE 
            WHEN c_product_rec.PRODUCT_GROUP_ALT IS NOT NULL 
            THEN c_product_rec.PRODUCT_GROUP_ALT ||'<span class="main-color"> - ' || c_product_rec.PRODUCT_GROUP
            ELSE c_product_rec.PRODUCT_TYPE ||'<span class="main-color"> - ' || c_product_rec.PRODUCT_GROUP
        END||
         '</span></h4>' ||
        '<div class="heading-separator"><span class="main-bg"></span><span class="dark-bg"></span></div>' ||
    '</div>';

    IF p_device_type = 'DESKTOP' THEN
        v_grid_html := v_grid_html || 
        '<div id="'|| c_product_rec.ANCHOR_ID || '" class="padding-vertical-30">' ||
            '<div class="row">' ||
                '<div class="col-md-4 center-text" style="display: flex; flex-direction: column; align-items: center;">' ||
                    '<img class="fx animated fadeInLeft" alt="" src="' || PRODUCT_IMAGE_DISPLAY(NVL(NULLIF(SYS_CONTEXT('APEX$SESSION','WORKSPACE'),''),'SYNTEC'),'assets/images/Scientific/suppliers/',c_product_rec.PRODUCT_IMAGE_LARGE,c_product_rec.PRODUCT_IMAGE_EXTERNAL)  || '" ' ||
                    'style="margin-bottom:30px; ' ||
                    CASE WHEN TRIM(c_product_rec.PRODUCT_IMAGE_LARGE_WIDTH || c_product_rec.PRODUCT_IMAGE_LARGE_HEIGHT) IS NULL THEN 'width: 100%; height: auto;' 
                    ELSE 'width: ' || c_product_rec.PRODUCT_IMAGE_LARGE_WIDTH || '; height:' || c_product_rec.PRODUCT_IMAGE_LARGE_HEIGHT || ';' END || '"/>' ||
                    '<img class="fx animated fadeInLeft" data-animate="fadeInLeft" alt="" src="' || p_workspace_url  || 'assets/images/Scientific/suppliers/'||c_product_rec.SUPPLIER_LOGO_LARGE||'" style="margin-bottom:30px; '||c_product_rec.SUPPLIER_LOGO_LARGE_SCALE_SMALLER||
                        ' "> 
                    <a href="' || c_product_rec.PRODUCT_ENQUIRE || '" 
                        class="variable-button h4 open-contact-drawer_product"
                        data-product-id="' || c_product_rec.PRODUCT_ID || '"
                        data-text="Enquire" 
                        data-texthover="' || c_product_rec.PRODUCT_NAME || '"
                        style="--hover-background-color: ' || c_product_rec.ROLLOVER_COLOUR || ';   --icon-content: ''\f08b''; --hover-icon-content: ''\f4ad'';">
                      </a>  ' ||                  
                '</div>' ||
                '<div class="col-md-8">' ||
                    '   
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap;">
                    <div id="specs" style="flex: 1; min-width: 250px;">
                              <div class="heading side-head">
                                <div class="head-8">
                                  <h4 class="heavy-font">'||c_product_rec.PRODUCT_NAME||'</h4>
                                </div>
                              </div>
                            </div>

                            <!-- Supplier Link Section (Right) -->
                            <div id="Supplier_Link" style="flex: 1; min-width: 250px; text-align: right;">';

                                             v_grid_html := v_grid_html || '
                                               <a href="' || c_product_rec.PRODUCT_LINK || '" 
                                                target="_blank"
                                                class="variable-button h4" 
                                                data-text="Supplier Info." 
                                                data-texthover="' || c_product_rec.PRODUCT_NAME || '"
                                                style="--hover-background-color: ' || c_product_rec.ROLLOVER_COLOUR || ';  --icon-content: ''\f08b''; --hover-icon-content: ''\f35d'';">
                                              </a>  
                            </div>
                     </div>
                            ' ||



                    '<p>' || c_product_rec.PRODUCT_ABOUT || '</p>' 
                    ||
                    CASE when p_Show_related = 'Y'
                    THEN
                    Product_related_slider (p_product_id ,p_workspace_url,p_device_type )
                    ELSE null
                    END||
                '</div>' ||            
            '</div>' ||
        '</div>';
    ELSE
         v_grid_html := v_grid_html || '<div id="'|| c_product_rec.ANCHOR_ID || '" class="">' ||
            '<div class="row">' ||

                         '<div class="col-md-12">
                          <!-- Flex container for Specs and Supplier Link -->
                          <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap;">
                            <!-- Specs Section (Left) -->
                            <div id="specs" style="flex: 1; min-width: 250px;">
                              <div class="heading side-head">
                                <div class="head-8">
                                  <h4 class="heavy-font">'||c_product_rec.PRODUCT_NAME||'</h4>
                                </div>
                              </div>
                            </div>
                        </div>
                        </div>'||

                '<div class="col-md-12 center-text" style="display: flex; flex-direction: column; align-items: center;">' ||
                    '<img class="fx animated fadeInLeft img-mobile-60" alt="" src="' || PRODUCT_IMAGE_DISPLAY(NVL(NULLIF(SYS_CONTEXT('APEX$SESSION','WORKSPACE'),''),'SYNTEC'),'assets/images/Scientific/suppliers/',c_product_rec.PRODUCT_IMAGE_LARGE,c_product_rec.PRODUCT_IMAGE_EXTERNAL)  || '" ' ||
                    'style="margin-bottom:30px; ' ||
                    CASE WHEN TRIM(c_product_rec.PRODUCT_IMAGE_LARGE_WIDTH || c_product_rec.PRODUCT_IMAGE_LARGE_HEIGHT) IS NULL THEN 'width: 100%; height: auto;' 
                    ELSE 'width: ' || c_product_rec.PRODUCT_IMAGE_LARGE_WIDTH || '; height:' || c_product_rec.PRODUCT_IMAGE_LARGE_HEIGHT || ';' END || '"/>' ||
                     ' <img class="fx animated fadeInLeft" data-animate="fadeInLeft" alt="" src="' || p_workspace_url  || 'assets/images/Scientific/suppliers/'||c_product_rec.SUPPLIER_LOGO_LARGE||'" style="margin-bottom:30px; '||c_product_rec.SUPPLIER_LOGO_LARGE_SCALE_SMALLER||
                        ' "> '||
                             ' <!-- Supplier Link Section (Right) -->
                            <div id="Supplier_Link_Portfolio" style="flex: 1; min-width: 250px; text-align: right;">'

                                              || '
                                               <a href="' || c_product_rec.PRODUCT_LINK || '" 
                                                target="_blank"
                                                class="variable-button h4" 
                                                data-text="Supplier Info." 
                                                data-texthover="' || c_product_rec.PRODUCT_NAME || '"
                                                style="--hover-background-color: ' || c_product_rec.ROLLOVER_COLOUR || ';  --icon-content: ''\f08b''; --hover-icon-content: ''\f35d'';">
                                              </a>  
                            </div>'||
                '</div>' ||
                '<div class="col-md-12" style="display: flex; flex-direction: column; align-items: center;">' ||

                    '<p>' || c_product_rec.PRODUCT_ABOUT || '</p>' ||
                                    '<a href="' || c_product_rec.PRODUCT_ENQUIRE || '" 

                                    class="variable-button h4 open-contact-drawer_product"
                                    data-product-id="' || c_product_rec.PRODUCT_ID || '" 
                                    data-text="Enquire" 
                                    data-texthover="' || c_product_rec.PRODUCT_NAME || '"
                                    style="--hover-background-color: ' || c_product_rec.ROLLOVER_COLOUR || ';   --icon-content: ''\f08b''; --hover-icon-content: ''\f4ad'';">
                                  </a> '||


                '</div>' ||
            '</div>' ||
        '</div>';
    END IF;

    CLOSE c_product;
    RETURN v_grid_html;
END;

/
