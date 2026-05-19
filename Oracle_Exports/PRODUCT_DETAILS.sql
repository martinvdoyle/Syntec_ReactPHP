--------------------------------------------------------
--  DDL for Function PRODUCT_DETAILS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."PRODUCT_DETAILS" 
(p_device_type IN VARCHAR2, p_workspace_url IN VARCHAR2, p_PRODUCT_GROUP_ALT IN VARCHAR2, p_PRODUCT_TYPE IN VARCHAR2, 
p_ANCHOR_ID IN VARCHAR2, p_PRODUCT_IMAGE_LARGE IN VARCHAR2, p_PRODUCT_IMAGE_EXTERNAL IN VARCHAR2, p_PRODUCT_IMAGE_LARGE_WIDTH IN VARCHAR2, 
p_PRODUCT_IMAGE_LARGE_HEIGHT IN VARCHAR2, p_SUPPLIER_LOGO_LARGE IN VARCHAR2,
p_SUPPLIER_LOGO_LARGE_SCALE_SMALLER IN VARCHAR2, p_PRODUCT_ENQUIRE  IN VARCHAR2, p_PRODUCT_ID  IN VARCHAR2, p_PRODUCT_NAME  IN VARCHAR2,  p_ROLLOVER_COLOUR IN VARCHAR2,  
p_PRODUCT_LINK IN VARCHAR2, p_PRODUCT_ABOUT IN CLOB)

            RETURN CLOB IS
            
        
                v_grid_html CLOB := '';


                v_slider CLOB;
                v_slider_details CLOB;

                v_anchor_id         varchar2(200);  

                v_PRODUCT_TYPE  varchar2(100);

            BEGIN


                       v_grid_html :=  v_grid_html || '<div class="heading main-heading centered padding-top-10 ">							
                                                <h4 class="sub-title1">'
                                                ||    CASE 
                                                            WHEN p_PRODUCT_GROUP_ALT IS NOT NULL 
                                                            THEN p_PRODUCT_GROUP_ALT 
                                                            ELSE '' -- Using an empty string instead of NULL to avoid concatenation issues
                                                        END
                                                ||
                                                '<span class="main-color"> '||p_PRODUCT_TYPE||'</span></h4>
                                                <div class="heading-separator"><span class="main-bg"></span><span class="dark-bg"></span></div>
                                            </div> ';

        IF p_device_type  = 'DESKTOP'
                     THEN
                                        -- Add PRODUCT header
                                         v_grid_html :=  v_grid_html || 

                            '




                            <div id="'||p_ANCHOR_ID||'" class="container-syn padding-vertical-30">

                                    <div class="row">
                                        <div class="clearfix"></div>



                            <div class="col-md-12">
                                <div class="row">

                                <!-- Image Column -->
                            <div class="col-md-4 center-text" style="display: flex; flex-direction: column; align-items: center;">

                                <img class="fx animated fadeInLeft" data-animate="fadeInLeft" alt="" src="' || PRODUCT_IMAGE_DISPLAY(NVL(NULLIF(SYS_CONTEXT('APEX$SESSION','WORKSPACE'),''),'SYNTEC'),'assets/images/Scientific/suppliers/',p_PRODUCT_IMAGE_LARGE,p_PRODUCT_IMAGE_EXTERNAL) ||'" style="margin-bottom:30px; ';

                           IF trim( p_PRODUCT_IMAGE_LARGE_WIDTH||p_PRODUCT_IMAGE_LARGE_HEIGHT) is null
                            THEN
                            v_grid_html :=  v_grid_html || ' width: 100%; height: auto; ';
                            ELSE
                            v_grid_html :=  v_grid_html || ' width: '||p_PRODUCT_IMAGE_LARGE_WIDTH||'; height:'||p_PRODUCT_IMAGE_LARGE_HEIGHT||'; ';
                           END IF;


                            v_grid_html :=  v_grid_html ||  '">

                            <img class="fx animated fadeInLeft" data-animate="fadeInLeft" alt="" src="' || p_workspace_url  || 'assets/images/Scientific/suppliers/'||p_SUPPLIER_LOGO_LARGE||'" style="margin-bottom:30px; '||p_SUPPLIER_LOGO_LARGE_SCALE_SMALLER||
                    ' "> ';

                            v_grid_html := v_grid_html || '
                               <a href="' || p_PRODUCT_ENQUIRE || '" 
                                class="variable-button h4 open-contact-drawer"
                                data-product-id="' || p_PRODUCT_ID || '"  
                                data-text="Enquire" 
                                data-texthover="' || p_PRODUCT_NAME || '"
                                style="--hover-background-color: ' || p_ROLLOVER_COLOUR || ';   --icon-content: ''\f08b''; --hover-icon-content: ''\f4ad'';">
                              </a>  ';

                            v_grid_html :=  v_grid_html ||   

                            '
$$$$$$$$$ col-md-4 End 
                          <!-- col-md-4 End -->         
                            </div>


                        <div class="col-md-8">
                          <!-- Flex container for Specs and Supplier Link -->
                          <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap;">
                            <!-- Specs Section (Left) -->
                            <div id="specs" style="flex: 1; min-width: 250px;">
                              <div class="heading side-head">
                                <div class="head-8">
                                  <h4 class="heavy-font">'||p_PRODUCT_NAME||'</h4>
                                </div>
                              </div>
                            </div>

                            <!-- Supplier Link Section (Right) -->
                            <div id="Supplier_Link" style="flex: 1; min-width: 250px; text-align: right;">';

                             v_grid_html := v_grid_html || '
                               <a href="' || p_PRODUCT_LINK || '" 
                                target="_blank"
                                class="variable-button h4" 
                                data-text="Supplier Info." 
                                data-texthover="' || p_PRODUCT_NAME || '"
                                style="--hover-background-color: ' || p_ROLLOVER_COLOUR || ';  --icon-content: ''\f08b''; --hover-icon-content: ''\f35d'';">
                              </a>  
                            </div>';




                         v_grid_html :=  v_grid_html ||'
                            <!-- col-md-4 End --> 
                          </div>

                          <!-- About Section (Spans Full Width Below) -->
                          <div id="About" style="width: 100%; margin-top: 20px;">
                        '|| p_PRODUCT_ABOUT ||'
                          </div>';









        ELSE /* Mobile */
                            -- Add PRODUCT header
                             v_grid_html :=  v_grid_html || 

                                 '<div id="'||p_ANCHOR_ID||'" class="">

                    <div class="row">
                        <div class="clearfix"></div>


                        <div class="col-md-12">
                          <!-- Flex container for Specs and Supplier Link -->
                          <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap;">
                            <!-- Specs Section (Left) -->
                            <div id="specs" style="flex: 1; min-width: 250px;">
                              <div class="heading side-head">
                                <div class="head-8">
                                  <h4 class="heavy-font">'||p_PRODUCT_NAME||'</h4>
                                </div>
                              </div>
                            </div>
                        </div>
                        </div>


                    <!-- Image Column -->
                <div class="col-md-12 center-text" style="display: flex; flex-direction: column; align-items: center;">

                                    <img class="fx animated fadeInLeft" data-animate="fadeInLeft" alt="" src="' || PRODUCT_IMAGE_DISPLAY(NVL(NULLIF(SYS_CONTEXT('APEX$SESSION','WORKSPACE'),''),'SYNTEC'),'assets/images/Scientific/suppliers/',p_PRODUCT_IMAGE_LARGE,p_PRODUCT_IMAGE_EXTERNAL) ||'" style="margin-bottom:30px; ';

                               IF trim( p_PRODUCT_IMAGE_LARGE_WIDTH||p_PRODUCT_IMAGE_LARGE_HEIGHT) is null
                                THEN
                                v_grid_html :=  v_grid_html || ' width: 100%; height: auto; ';
                                ELSE
                                v_grid_html :=  v_grid_html || ' width: '||p_PRODUCT_IMAGE_LARGE_WIDTH||'; height:'||p_PRODUCT_IMAGE_LARGE_HEIGHT||'; ';
                               END IF;


                                v_grid_html :=  v_grid_html ||  '">

                                <img class="fx animated fadeInLeft" data-animate="fadeInLeft" alt="" src="' || p_workspace_url  || 'assets/images/Scientific/suppliers/'||p_SUPPLIER_LOGO_LARGE||'" style="margin-bottom:30px; '||p_SUPPLIER_LOGO_LARGE_SCALE_SMALLER||
                        ' "> ';

                           v_grid_html :=  v_grid_html ||'
                           <!-- About Section (Spans Full Width Below) -->
                          <div id="About" style="width: 100%;">
                        '|| p_PRODUCT_ABOUT ||'
                          </div>';



                                v_grid_html := v_grid_html || '
                                   <a href="' || p_PRODUCT_ENQUIRE || '" 
                                    class="variable-button h4 open-contact-drawer"
                                    data-product-id="' || p_PRODUCT_ID || '" 
                                    data-text="Enquire" 
                                    data-texthover="' || p_PRODUCT_NAME || '"
                                    style="--hover-background-color: ' || p_ROLLOVER_COLOUR || ';   --icon-content: ''\f08b''; --hover-icon-content: ''\f4ad'';">
                                  </a>  ';



                v_grid_html :=  v_grid_html ||   '

              <!-- col-md-4 End -->         
              </div>


                                <div class="toolsBar">

                                        <div class="col-md-10 left products-filter-top">
                                        </div>
                                </div>




            </div>
           </div>
            '  || CHR(10);


        END IF;


                RETURN v_grid_html;
            END;

/
