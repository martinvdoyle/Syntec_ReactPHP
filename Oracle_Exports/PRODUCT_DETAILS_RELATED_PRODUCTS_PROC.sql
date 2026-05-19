--------------------------------------------------------
--  DDL for Procedure PRODUCT_DETAILS_RELATED_PRODUCTS_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "WEB"."PRODUCT_DETAILS_RELATED_PRODUCTS_PROC" (
    p_id IN VARCHAR2,
    p_workspace_url IN VARCHAR2,
    p_device_type IN VARCHAR2,


    v_slider_html OUT CLOB,
    v_slider_details_html OUT CLOB
    
) AS 

v_slider_temp CLOB;

BEGIN

v_slider_html := v_slider_html ||'


<style>
.horizontal-slider .slick-slide {
    width: 210px !important;  /* Fixed width */
    padding:10px;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: #F2F2F2; /* Optional */
    border: 1px solid #ddd;  /* Optional */
    overflow: hidden;
}

.horizontal-slider .slick-slide img {
    max-width: 150%;
    max-height: 150%;
    object-fit: contain;
}



</style>


';


                    -- Find product related type - Consumables, Related Products , Accessories Reagents etc  
                               FOR r_related_type IN (

                                        SELECT 
                                        PRODUCT_TYPE_NAME,
                                        PRODUCT_TYPE_ID
                                        FROM (
                                            SELECT                  --  Product Consumables / Reagents / Accessories
                                                DISTINCT
                                                    t.PRODUCT_TYPE_NAME,
                                                    t.PRODUCT_TYPE_ID,
                                                    t.PRODUCT_TYPE_ORDER sort
                                                    FROM SUPPLIERS s, PRODUCT_TYPE t,PRODUCTS_RELATED r,PRODUCTS p, PRODUCTS pr
                                                    where r.PRODUCT_RELATED_ID = pr.PRODUCT_ID
                                                    AND   r.PRODUCT_ID = p.PRODUCT_ID
                                                    AND pr.SUPPLIER_ID = s.SUPPLIER_ID
                                                    AND t.PRODUCT_TYPE_ID = r.PRODUCT_TYPE_ID
                                                    AND p.DELETED = 'N' AND p.ACTIVE = 'Y'  
                                                    AND r.DELETED = 'N' AND r.ACTIVE = 'Y'  
                                                    AND r.PRODUCT_ID = p_id


                                        )
                                        ORDER BY sort
                        ) LOOP

 v_slider_html := v_slider_html || 
    '<div id="specs" style="flex: 1; min-width: 250px;">
              <div class="heading side-head">
                <div class="head-8">
                  <h4 class="heavy-font"><i>'|| r_related_type.PRODUCT_TYPE_NAME||'</i></h4>
                </div>
              </div>
    </div>

     <div class="horizontal-slider" style= text-align: center; flex-wrap: wrap;" 
            data-slides_count="2" 
            data-scroll_amount="2" 
            data-slider-loop="true"
            data-slider-autoplay="true"
            data-slider-smart-speed="300" 
            data-slider-nav="true" 
            data-slider-infinite="0" 
            data-slider-dots="true" 
            data-slider-arrows="1"

            >
***************** Start Related
            ';


                     -- Find products for  related type - Consumables, Related Products , Accessories Reagents etc  
                               FOR r_related_products IN (

                                        SELECT 
                                        PRODUCT_TYPE_NAME,
                                        PRODUCT_TYPE_ID,
                                        PRODUCT_ID,
                                        PRODUCT_NAME,
                                        PRODUCT_ID_RELATED,
                                        PRODUCT_NAME_RELATED,
                                        supplier_name,
                                        PRODUCT_IMAGE_LARGE,
                                        PRODUCT_LINK,
                                        PRODUCT_ABOUT,
                                        PRODUCT_ENQUIRE,
                                        ANCHOR_ID, 
                                        PRODUCT_IMAGE_LARGE_WIDTH,
                                        PRODUCT_IMAGE_LARGE_HEIGHT 

                                        FROM (
                                            SELECT                  --  Product Consumables / Reagents / Accessories
                                                    t.PRODUCT_TYPE_NAME,
                                                    t.PRODUCT_TYPE_ID,
                                                    t.PRODUCT_TYPE_ORDER sort,
                                                    p.PRODUCT_ID,p.PRODUCT_NAME,
                                                    pr.PRODUCT_ID PRODUCT_ID_RELATED,pr.PRODUCT_NAME||'xx' PRODUCT_NAME_RELATED,
                                                    s.supplier_name,
                                                    pr.PRODUCT_IMAGE_LARGE,pr.PRODUCT_LINK,REPLACE(pr.ABOUT_1 , '#WORKSPACE_FILES#', p_workspace_url)  PRODUCT_ABOUT,pr.PRODUCT_ENQUIRE,
                                                    GET_ANCHOR_ID ('prd',pr.DISCIPLINE_ID,pr.PRODUCT_GROUP_ID,pr.SUPPLIER_ID,pr.PRODUCT_ID,'code')  ANCHOR_ID, 
                                                    pr.PRODUCT_IMAGE_LARGE_WIDTH, pr.PRODUCT_IMAGE_LARGE_HEIGHT 
                                                    FROM SUPPLIERS s, PRODUCT_TYPE t,PRODUCTS_RELATED r,PRODUCTS p, PRODUCTS pr
                                                    where r.PRODUCT_RELATED_ID = pr.PRODUCT_ID
                                                    AND   r.PRODUCT_ID = p.PRODUCT_ID
                                                    AND pr.SUPPLIER_ID = s.SUPPLIER_ID
                                                    AND t.PRODUCT_TYPE_ID = r.PRODUCT_TYPE_ID
                                                    AND p.DELETED = 'N' AND p.ACTIVE = 'Y'  
                                                    AND r.DELETED = 'N' AND r.ACTIVE = 'Y'  
                                                    AND r.PRODUCT_ID = p_id
                                                    and r_related_type.PRODUCT_TYPE_ID = r.PRODUCT_TYPE_ID



                                        )
                                        ORDER BY PRODUCT_NAME
                        ) LOOP

                         v_slider_html := v_slider_html ||' 
                            <!-- '||r_related_products.PRODUCT_NAME||' -->
                            <div style="flex: 1 1 120px; display: flex; flex-direction: column; align-items: center; margin-right: 25px; justify-content: center; " data-target="'||r_related_products.PRODUCT_ID||'-'||r_related_products.PRODUCT_ID_RELATED||'" data-product-id="'||r_related_products.PRODUCT_ID||'-'||r_related_products.PRODUCT_ID_RELATED||'" class="slick-slide slick-active product-syn" index="0">
                              <a href="#" style="display: flex; flex-direction: column; align-items: center; text-align: center;">
                                <div style="height: 100px; display: flex; justify-content: center; align-items: center;">
                                  <img alt="'||r_related_products.PRODUCT_NAME_RELATED||'" src="' || p_workspace_url  || 'assets/images/Scientific/suppliers/'||r_related_products.PRODUCT_IMAGE_LARGE||'" style="max-height: 100%; max-width: 100%; object-fit: contain;">
                                </div>
                                <span class="main-color" style="font-weight: bold; margin-top: 8px;">'||r_related_products.PRODUCT_NAME_RELATED||'</span>
                              </a>
                            </div>';


                           v_slider_temp :=   v_slider_temp ||  '<div class="product-details-syn" id="'||r_related_products.PRODUCT_ID||'-'||r_related_products.PRODUCT_ID_RELATED||'" style="display: none;">bbbbbbbbbbbbbbbbbbb '||r_related_products.PRODUCT_ID_RELATED

                          ||Product_details_related_display (p_device_type, p_workspace_url, r_related_products.PRODUCT_ID_RELATED )

                           ||'aaaaaaaaaaaaaaaaaaaaaaaaa</div>';

--                          v_slider_details_html := v_slider_details_html ||' 
--                                 <div class="product-details-syn" id="'||r_related_products.PRODUCT_ID||'-'||r_related_products.PRODUCT_ID_RELATED||'" style="display: none;">Details about '||r_related_products.PRODUCT_NAME_RELATED||'</div>';




                    END LOOP;

                    v_slider_html := v_slider_html ||'***************** End Related </div>     <!-- horizontal-slider -->';
                    v_slider_details_html := v_slider_temp;

                    END LOOP;


END;


/
