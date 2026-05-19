--------------------------------------------------------
--  DDL for Function SUPPLIER_GRID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."SUPPLIER_GRID" (
    p_app_id               in number,
    p_app_alias            in varchar2,
    p_workspace_url        in varchar2 default null,
    p_sub_menu_l0          in varchar2,
    p_sub_menu_l1          in varchar2,
    p_sub_menu_l2          in varchar2,
    p_sub_menu_l3          in varchar2,
    p_product_type         in varchar2,
    p_menu_level_selected  in varchar2,
    p_device_type          in varchar2
) return clob is
    v_grid_html            clob := '';
    v_anchor_id            varchar2(200);
    v_product_type         varchar2(100);
    v_slider_html          clob;
    v_slider_details_html  clob;

    -- NEW: normalized workspace files base URL (works in dev/prod)
    v_ws_url               varchar2(4000);
begin
    v_ws_url := nvl(trim(p_workspace_url), v('WORKSPACE_IMAGES'));
    if v_ws_url is null then
        raise_application_error(-20001, 'Workspace files URL not available.');
    end if;
    if substr(v_ws_url, -1) <> '/' then
        v_ws_url := v_ws_url || '/';
    end if;

            IF p_product_type = 'All' or p_product_type is null
                then 
                v_product_type := 'Diagnostic Systems';
            ELSE
                v_product_type := p_product_type ;
            END IF;

                v_grid_html := '

            <style>
                .filter-by a.filter {
                    font-size: 20px !important;
                    padding: 7px 14px !important;
                }

            .name-holder h3 {
                font-weight: 600;
                line-height: 1.5;
                margin: 0 0 0px ;
            }

            .filter-by ul li:before{
                position:absolute;
                width: 0px;
                height: 1px;
                content:"";
                left: -20px;
                top: 20px;
                display:inline-block;
                z-index:0;
                background-color: #E0E0E0;
                border-radius: 50%;
            }

            ';


            v_grid_html := v_grid_html || 
            '</style>

                                <div id="suppliers_grid" class="section-no-padtop fixed-bg" >
                                <!--   <div id="suppliers_grid" class="section-no-padtop fixed-bg" style="background-image:url(''' || p_workspace_url || 'assets/images/Backgrounds/Lab_9_opaque.png'');background-size:cover"> 

                                    <div class="section-banner" id="suppliers-banner">

                                        <div class="heading full-heading-banner main-bg">
                                            <h3 class="inner-head white"><span class="heavy-font white-text-shadow">Suppliers</span></h3>
                                            <h5 class="black-color"><span class="small-heading">' || v_product_type  || '</span></h5>
                                        </div>

                                    </div> 
                                 -->';

            IF p_device_type  = 'DESKTOP' and  (p_menu_level_selected  in ('L1','L2')  or (p_menu_level_selected = 'L3' and p_product_type in ('Consumables','Reagents') ))
                        THEN
                        v_grid_html := v_grid_html ||                                  
                                     '<div  class="container-syn">                            
                                            <div class="heading main-heading centered padding-vertical-50">							
                                                <h4 class="sub-title">Our Key <span class="main-color">' || v_product_type  || ' Suppliers</span></h4>
                                                <div class="heading-separator"><span class="main-bg"></span><span class="dark-bg"></span></div>
                                            </div>
                                     </div>  ';

            END IF;


/* 


Consumables & Reagents only 
P0_MAIN_MENU	Suppliers
P0_PRODUCT_TYPE	Laboratory Consumables
P0_SUB_MENU_L1	Histopathology
P0_SUB_MENU_L2	Consumables   This is not a Product Group so it just selects all the Laboratory Consumables  

Diagnostic Systems  
P0_MAIN_MENU	Suppliers
P0_PRODUCT_TYPE	All
P0_SUB_MENU_L1	Histopathology
P0_SUB_MENU_L2	Microtomy     This is a Product Group so select all Microtomy + Microtomy Consumables & Reagents
*/



/* *********************************************************** */
/* produce grid only for group levels not individual suppliers */
/* *********************************************************** */

IF (p_menu_level_selected  in ('L1','L2')  or (p_menu_level_selected = 'L3' and p_product_type in ('Consumables','Reagents') )) and p_device_type != 'MOBILE'
THEN


            v_grid_html := v_grid_html ||'
                                    <div  class="container-syn  padding-bottom-50">
                                        <div class="filter-by" >
                                            <ul id="filters">
            ';


                    -- Loop supplier Grid Tabs    
                               FOR r_tab IN (

                                        SELECT 
                                        DISCIPLINE_TAB,
                                        DISCIPLINE, 
                                        DATA_FILTER
                                        FROM (
                                            SELECT DISTINCT
                                                d.DISCIPLINE_ORDER sort,
                                                dpg.DISCIPLINE DISCIPLINE_TAB,
                                                dpg.DISCIPLINE DISCIPLINE,
                                                '.Filter' || d.ANCHOR_ID DATA_FILTER

                                            FROM 
                                                SUPPLIERS s,
                                                PRODUCT_GROUP g,
                                                DISCIPLINE d,
                                                DISCIPLINE_PRODUCT_GROUP_VIEW dpg
                        WHERE
                            dpg.SUPPLIER_ID = s.SUPPLIER_ID
                        and    d.DISCIPLINE_ID = dpg.DISCIPLINE_ID
                        AND g.PRODUCT_GROUP_ID(+) =  nvl(dpg.PRODUCT_GROUP_TYPE_ALT_ID,dpg.PRODUCT_GROUP_ID)

                        AND ((p_sub_menu_l0 = 'Suppliers' and p_sub_menu_l1 is null) or p_sub_menu_l1 = 'All Suppliers' or p_sub_menu_l1= dpg.DISCIPLINE)
                                                AND (
                                                        (p_sub_menu_l0 = 'Suppliers' AND p_sub_menu_l1 IS NULL)
                                                        OR p_sub_menu_l1 = 'All Suppliers' 
                                                        OR p_sub_menu_l1 = dpg.DISCIPLINE
                                                    )
                                                    AND (
                                                            -- Conditional evaluation of the AND clause
                                                            (
                                                                (p_product_type = 'All' OR p_product_type IS NULL)
                                                                AND (p_sub_menu_l2 IS NULL OR p_sub_menu_l2 = dpg.PRODUCT_GROUP)
                                                            )
                                                            OR (
                                                                -- Include regular product filtering for non-'All' or non-NULL p_product_type
                                                                p_product_type != 'All' 
                                                                AND p_product_type IS NOT NULL 
                                                                AND dpg.PRODUCT_TYPE = p_product_type
                                                            )
                                                        ) 
                                                    AND  (  (p_product_type not in ('Consumables','Reagents')
                                                             and ((p_menu_level_selected = 'L2'
                                                             and  dpg.PRODUCT_GROUP = p_sub_menu_l2 
                                                             and  p_sub_menu_l3 is null
                                                             ) or (p_menu_level_selected != 'L2'
                                                                   and  dpg.PRODUCT_GROUP = p_sub_menu_l2) )
                                                         )


                                                            or (p_product_type in ('Consumables','Reagents')
                                                                    -- Add condition based on p_menu_level_selected L2 - only select the group if it's a group menu
                                                                and (p_menu_level_selected = 'L2'
                                                                     and nvl(dpg.PRODUCT_GROUP_TYPE_ALT,dpg.PRODUCT_GROUP) = p_sub_menu_l2  -- use ALT Group Description if it exists ie for Consumables and Reagents - flip from the actual group to the Alt group so they appear in the same section
                                                                     and  p_sub_menu_l3 is null)
                                                                     or
                                                                     (p_menu_level_selected = 'L3'

                                                                      and dpg.PRODUCT_GROUP = p_sub_menu_l3)

                                                                )  
                                                             or (p_product_type is null)
                                                            )

                                            UNION

                                            SELECT
                                                0 sort,
                                                'All' DISCIPLINE_TAB,
                                                'All Suppliers' DISCIPLINE,
                                                '*' FILTER_ANCHOR
                                            FROM 
                                                dual
                                                where (p_sub_menu_l0 = 'Suppliers' and p_sub_menu_l1 is null) or p_sub_menu_l1 = 'All Suppliers'
                                        )
                                        ORDER BY sort           
                        ) LOOP




                            v_grid_html := v_grid_html || '<li class="'|| 
                                    CASE 
                                    WHEN r_tab.DISCIPLINE = p_sub_menu_l1 THEN 'active' 
                                    WHEN p_sub_menu_l0 = 'Suppliers' and p_sub_menu_l1 is null and r_tab.DISCIPLINE ='All Suppliers' THEN 'active'
                                    ELSE '' 
                                    END                       
                            ||'"><a href="#" class="filter main-color" data-filter="'|| r_tab.DATA_FILTER||'"><i class="fa fa-tags"></i> '||r_tab.DISCIPLINE_TAB||'</a></li>' || CHR(10);

                    END LOOP;


              v_grid_html :=v_grid_html ||'</ul></div>';







              v_grid_html := v_grid_html ||'<div class="portfolio p-4-cols p-style4" id="container">';

                    -- Loop supplier Grid Images   
                                FOR r_grid_image IN (


                                        SELECT 
                                        DISCIPLINE, 
                                        PRODUCT_TYPE,
                                        DATA_FILTER,
                                        PRODUCT_GROUP,
                                        SUPPLIER_NAME,
                                        image_400x267,
                                        ANCHOR_ID SUPPLIER_ANCHOR
                                        FROM (
                                            SELECT DISTINCT
                                                d.DISCIPLINE_ORDER sort1,
                                                g.PRODUCT_GROUP_ORDER sort2,
                                                pt.PRODUCT_TYPE_ORDER sort3,
                                                dpg.DISCIPLINE DISCIPLINE,
                                                 'Filter' || d.ANCHOR_ID DATA_FILTER,
                                                dpg.PRODUCT_GROUP PRODUCT_GROUP,
                                                dpg.PRODUCT_TYPE PRODUCT_TYPE,
                                                s.SUPPLIER_NAME SUPPLIER_NAME,
                                                s.SUPPLIER_IMAGE_1 image_400x267,
                                                GET_ANCHOR_ID ('sup',dpg.DISCIPLINE_ID,dpg.PRODUCT_GROUP_ID,dpg.SUPPLIER_ID, '','code')  ANCHOR_ID


                                            FROM 
                                                SUPPLIERS s,
                                                PRODUCT_TYPE pt,
                                                PRODUCT_GROUP g,
                                                DISCIPLINE d,
                                                DISCIPLINE_PRODUCT_GROUP_VIEW dpg
                        WHERE
                            dpg.SUPPLIER_ID = s.SUPPLIER_ID
                        and    d.DISCIPLINE_ID = dpg.DISCIPLINE_ID
                        AND g.PRODUCT_GROUP_ID(+) =  nvl(dpg.PRODUCT_GROUP_TYPE_ALT_ID,dpg.PRODUCT_GROUP_ID)
                        AND pt.PRODUCT_TYPE_ID(+) = nvl(dpg.PRODUCT_GROUP_TYPE_ALT_ID,dpg.PRODUCT_GROUP_ID)

                        AND ((p_sub_menu_l0 = 'Suppliers' and p_sub_menu_l1 is null) or p_sub_menu_l1 = 'All Suppliers' or p_sub_menu_l1= dpg.DISCIPLINE)
                                                AND (
                                                        (p_sub_menu_l0 = 'Suppliers' AND p_sub_menu_l1 IS NULL)
                                                        OR p_sub_menu_l1 = 'All Suppliers' 
                                                        OR p_sub_menu_l1 = dpg.DISCIPLINE
                                                    )
                                                    AND (
                                                            -- Conditional evaluation of the AND clause
                                                            (
                                                                (p_product_type = 'All' OR p_product_type IS NULL)
                                                                AND (p_sub_menu_l2 IS NULL OR p_sub_menu_l2 = dpg.PRODUCT_GROUP)
                                                            )
                                                            OR (
                                                                -- Include regular product filtering for non-'All' or non-NULL p_product_type
                                                                p_product_type != 'All' 
                                                                AND p_product_type IS NOT NULL 
                                                                AND dpg.PRODUCT_TYPE = p_product_type
                                                            )
                                                        ) 
                                                    AND  (  (p_product_type not in ('Consumables','Reagents')
                                                             and ((p_menu_level_selected = 'L2'
                                                             and  dpg.PRODUCT_GROUP = p_sub_menu_l2 
                                                             and  p_sub_menu_l3 is null
                                                             ) or (p_menu_level_selected != 'L2' 
                                                                   and  dpg.PRODUCT_GROUP = p_sub_menu_l2) )
                                                         )


                                                            or (p_product_type in ('Consumables','Reagents')
                                                                    -- Add condition based on p_menu_level_selected L2 - only select the group if it's a group menu
                                                                and (p_menu_level_selected = 'L2'
                                                                     and nvl(dpg.PRODUCT_GROUP_TYPE_ALT,dpg.PRODUCT_GROUP) = p_sub_menu_l2  -- use ALT Group Description if it exists ie for Consumables and Reagents - flip from the actual group to the Alt group so they appear in the same section
                                                                     and  p_sub_menu_l3 is null)
                                                                     or
                                                                     (p_menu_level_selected = 'L3'

                                                                      and dpg.PRODUCT_GROUP = p_sub_menu_l3)

                                                                )  
                                                            or (p_product_type is null)
                                                            )



                                        )
                                        ORDER BY sort1 , sort2 , sort3 , SUPPLIER_NAME
                        ) LOOP

                            --  <a href="f?p=SYNTEC_GROUP:4:::#'||r_grid_image.SUPPLIER_ANCHOR||'" class="main-bg link "   style="left: 40%; top: 40%;"><i class="fa-custom fa-solid fa-circle-info"  title="'||r_grid_image.SUPPLIER_NAME||' Profile"></i></a>

                                        v_grid_html := v_grid_html || '	
                                        <div class="portfolio-item '||r_grid_image.DATA_FILTER  ||' img-shadow">
                                                <div class="img-holder">
                                                    <div class="img-over"  >
                                                        <a href="javascript:void(0);" onclick="scrollToAnchor('''||r_grid_image.SUPPLIER_ANCHOR||''')"
                                                         class="main-bg link "   style="left: 40%; top: 40%;"><i class="fa-custom fa-solid fa-circle-info"  title="'||r_grid_image.SUPPLIER_NAME||' Profile"></i></a>
                                                    </div>
                                                    <img alt="" src="' || v_ws_url  || 'assets/images/Scientific/suppliers/'||r_grid_image.image_400x267||'">
                                                </div>
                                                <div class="name-holder">
                                                    <h3><span class="main-color">'||r_grid_image.SUPPLIER_NAME||'</span></h3>
                                                    <h4><span class="main-color">'||r_grid_image.DISCIPLINE||'</span></h4>
                                                    <span class="main-color-secondary" style="font-size:20px;"><b>'||r_grid_image.PRODUCT_GROUP||'</b></span>
                                                    <h4><span class="main-color" <i>'||r_grid_image.PRODUCT_TYPE||'</i></span></h4>
                                                </div>
                                            </div>' || CHR(10);                  



                    END LOOP;



              v_grid_html :=v_grid_html ||'</div>';

              -- Sectioin End
             v_grid_html :=v_grid_html ||'</div>';

END IF;

/* ********************************************************************** */
/* End Grid:  produce grid only for group levels not individual suppliers */
/* ********************************************************************** */

                -- First loop: DISCIPLINE/PRODUCT_GROUP level
                FOR r_discipline IN (
                        SELECT 
                        DISTINCT d.DISCIPLINE_ORDER,
                        g.PRODUCT_GROUP_ORDER,
                        pt.PRODUCT_TYPE_ORDER, 
                        dpg.DISCIPLINE,
                        dpg.DISCIPLINE_ID,
                        nvl(dpg.PRODUCT_GROUP_TYPE_ALT,dpg.PRODUCT_GROUP) PRODUCT_GROUP,
                        nvl(dpg.PRODUCT_GROUP_TYPE_ALT_ID,dpg.PRODUCT_GROUP_ID) PRODUCT_GROUP_ID,
                        decode(dpg.PRODUCT_GROUP_TYPE_ALT_ID,null,null,dpg.PRODUCT_GROUP) PRODUCT_GROUP_ALT,
                        decode(dpg.PRODUCT_GROUP_TYPE_ALT_ID,null,null,dpg.PRODUCT_GROUP_ID) PRODUCT_GROUP_ALT_ID,
                        dpg.PRODUCT_TYPE,
                        dpg.PRODUCT_TYPE_ID,
                        nvl(g.PRODUCT_GROUP_IMAGE_1,d.DISCIPLINE_IMAGE_1) DISCIPLINE_IMAGE_1,
                        GET_ANCHOR_ID ('sup',dpg.DISCIPLINE_ID,nvl(dpg.PRODUCT_GROUP_TYPE_ALT_ID,dpg.PRODUCT_GROUP_ID),'', '','code')  ANCHOR_ID

                        FROM 
                        DISCIPLINE d, 
                        PRODUCT_GROUP g, 
                        PRODUCT_TYPE pt, 
                        DISCIPLINE_PRODUCT_GROUP_VIEW dpg
                        WHERE
                            d.DISCIPLINE_ID = dpg.DISCIPLINE_ID
                        AND g.PRODUCT_GROUP_ID(+) =  nvl(dpg.PRODUCT_GROUP_TYPE_ALT_ID,dpg.PRODUCT_GROUP_ID)
                        AND pt.PRODUCT_TYPE_ID(+) = nvl(dpg.PRODUCT_GROUP_TYPE_ALT_ID,dpg.PRODUCT_GROUP_ID)

                        AND ((p_sub_menu_l0 = 'Suppliers' and p_sub_menu_l1 is null) or p_sub_menu_l1 = 'All Suppliers' or p_sub_menu_l1= dpg.DISCIPLINE)
                                                AND (
                                                        (p_sub_menu_l0 = 'Suppliers' AND p_sub_menu_l1 IS NULL)
                                                        OR p_sub_menu_l1 = 'All Suppliers' 
                                                        OR p_sub_menu_l1 = dpg.DISCIPLINE
                                                    )
                                                    AND (
                                                            -- Conditional evaluation of the AND clause
                                                            (
                                                                (p_product_type = 'All' OR p_product_type IS NULL)
                                                                AND (p_sub_menu_l2 IS NULL OR p_sub_menu_l2 = dpg.PRODUCT_GROUP)
                                                            )
                                                            OR (
                                                                -- Include regular product filtering for non-'All' or non-NULL p_product_type
                                                                p_product_type != 'All' 
                                                                AND p_product_type IS NOT NULL 
                                                                AND dpg.PRODUCT_TYPE = p_product_type
                                                            )
                                                        ) 
                                                    AND  (  (p_product_type not in ('Consumables','Reagents')
                                                             and ((p_menu_level_selected = 'L2'
                                                             and  dpg.PRODUCT_GROUP = p_sub_menu_l2 
                                                             and  p_sub_menu_l3 is null
                                                             ) or (p_menu_level_selected != 'L2'
                                                                   and  dpg.PRODUCT_GROUP = p_sub_menu_l2) )
                                                         )


                                                            or (p_product_type in ('Consumables','Reagents')
                                                                    -- Add condition based on p_menu_level_selected L2 - only select the group if it's a group menu
                                                                and (p_menu_level_selected = 'L2'
                                                                     and nvl(dpg.PRODUCT_GROUP_TYPE_ALT,dpg.PRODUCT_GROUP) = p_sub_menu_l2  -- use ALT Group Description if it exists ie for Consumables and Reagents - flip from the actual group to the Alt group so they appear in the same section
                                                                     and  p_sub_menu_l3 is null)
                                                                     or
                                                                     (p_menu_level_selected = 'L3'

                                                                      and dpg.PRODUCT_GROUP = p_sub_menu_l3)

                                                                )   
                                                           or (p_product_type is null)
                                                            )
                        ORDER BY 1,2,3
                ) LOOP
                    -- Add DISCIPLINE/PRODUCT_GROUP header

            IF  p_device_type  = 'DESKTOP'
                        THEN
                        v_grid_html := v_grid_html ||' 

                            <div id="'|| r_discipline.ANCHOR_ID ||'" class="section  fixed-bg"  style="background-image:url(''' || v_ws_url || r_discipline.DISCIPLINE_IMAGE_1 || ''');background-size:cover">


                                         <div class="discipline-banner  img-shadow_button ">
                                                    <span class="inner-head-narrow-top white lighter-font"><span class="heavy-font white-text-shadow">'|| r_discipline.DISCIPLINE ||'</span></span>
                                                    <span >
                                                        <span class="small-heading-narrow heavy-font white-text-shadow">'||r_discipline.PRODUCT_GROUP_ALT||' '||r_discipline.PRODUCT_GROUP||'</span>
                                                    </span>

                                        </div>   

                            </div>  ' || CHR(10);
                        ELSE
                        v_grid_html := v_grid_html ||' 

                            <div id="'|| r_discipline.ANCHOR_ID ||'" class="section  fixed-bg"  style="background-image:url(''' || v_ws_url || r_discipline.DISCIPLINE_IMAGE_1 || ''');background-size:cover">


                                         <div class="discipline-banner  img-shadow_button ">
                                                    <span class="inner-head-narrow-top white lighter-font"><span class="heavy-font white-text-shadow">'|| r_discipline.DISCIPLINE ||'</span></span>
                                                    <span >
                                                        <span class="small-heading-narrow heavy-font white-text-shadow">'||r_discipline.PRODUCT_GROUP_ALT||'    '||r_discipline.PRODUCT_GROUP||'</span>
                                                    </span>

                                        </div>   

                            </div>  ' || CHR(10);

            END IF;



                    -- Second loop: SUPPLIER level
                    FOR r_supplier IN (
                        SELECT  s.SUPPLIER_NAME, s.SUPPLIER_ID,s.SUPPLIER_IMAGE_BACKGROUND,s.SUPPLIER_LOGO_LARGE,s.WEBSITE, REPLACE(PROFILE_1, '#WORKSPACE_FILES#', v_ws_url) PROFILE_1,
                        GET_ANCHOR_ID ('sup',dpg.DISCIPLINE_ID,dpg.PRODUCT_GROUP_ID,dpg.SUPPLIER_ID, '','code')  ANCHOR_ID,
                        s.CLASS_COLOUR ROLLOVER_COLOUR,count(p.PRODUCT_ID) supplier_products , s.SUPPLIER_LOGO_LARGE_SCALE_SMALLER
                        FROM 
                        DISCIPLINE d, 
                        PRODUCT_GROUP g, 
                        SUPPLIERS s,
                        PRODUCTS p, 
                        DISCIPLINE_PRODUCT_GROUP_VIEW dpg
                        WHERE s.SUPPLIER_ID = dpg.SUPPLIER_ID
                          AND d.DISCIPLINE_ID = dpg.DISCIPLINE_ID
                          AND g.PRODUCT_GROUP_ID = dpg.PRODUCT_GROUP_ID
                          AND dpg.DISCIPLINE_ID = r_discipline.DISCIPLINE_ID
                          AND dpg.PRODUCT_GROUP_ID = nvl(r_discipline.PRODUCT_GROUP_ALT_ID,r_discipline.PRODUCT_GROUP_ID)
                          AND dpg.PRODUCT_TYPE_ID = r_discipline.PRODUCT_TYPE_ID
                          AND dpg.DISCIPLINE_ID = p.DISCIPLINE_ID(+)
                          AND dpg.PRODUCT_GROUP_ID = p.PRODUCT_GROUP_ID(+)
                          and p.PRODUCT_TYPE_ID = dpg.PRODUCT_TYPE_ID
                          and dpg.SUPPLIER_ID = p.supplier_id(+)
                          AND p.DELETED(+) = 'N' AND p.ACTIVE(+) = 'Y'

                    Group by
                    s.SUPPLIER_NAME, s.SUPPLIER_ID,s.SUPPLIER_IMAGE_BACKGROUND,s.SUPPLIER_LOGO_LARGE,s.WEBSITE,REPLACE(PROFILE_1, '#WORKSPACE_FILES#', v_ws_url),GET_ANCHOR_ID ('sup',dpg.DISCIPLINE_ID,dpg.PRODUCT_GROUP_ID,dpg.SUPPLIER_ID, '','code'),s.CLASS_COLOUR  , s.SUPPLIER_LOGO_LARGE_SCALE_SMALLER
                    ) LOOP
                        -- Add SUPPLIER header

            IF p_device_type  = 'DESKTOP'
                        THEN
                                 v_grid_html := v_grid_html ||
                                 ' <div id="'||r_supplier.ANCHOR_ID||'" class="section-no-padtop  fixed-bg" style="background-image:url(''' || v_ws_url || r_supplier.SUPPLIER_IMAGE_BACKGROUND || ''');background-size:cover">


                                   <!-- <div class="container-syn  ">   -->
                                   <!--     <div id="About" class="heading  img-shadow_button full-heading-narrow main-bg"> -->
                                   <!--         <div class="inner-head-narrow white lighter-font"><span class="heavy-font white-text-shadow" style="color:'||r_supplier.ROLLOVER_COLOUR||';">'|| r_supplier.SUPPLIER_NAME ||'</span></div> -->
                                   <!--         <div class="inner-head-narrow white lighter-font"><span class="medium-heading-narrow heavy-font white-text-shadow">'||r_discipline.DISCIPLINE||' - '||r_discipline.PRODUCT_GROUP||'</span></div> -->            
                                   <!--         <div class="inner-head-narrow white lighter-font"><span class="medium-heading-narrow heavy-font white-text-shadow">'||r_discipline.PRODUCT_TYPE||'</span></div> -->            
                                   <!--     </div> -->
                                   <!-- </div> -->




                                    <div class="container-syn padding-vertical-60">
                                        <div class="row" style="display: flex; flex-wrap: wrap;"



                                            <!-- Static Section -->
                                            <div class="col-md-4 hideable static-section" style="display: flex; flex-direction: column; position: relative; ">
                                                <img src="' || v_ws_url  || 'assets/images/Scientific/suppliers/'||r_supplier.SUPPLIER_LOGO_LARGE||'" class="hideable" style="padding-top: 0px;">';


                                                 v_grid_html := v_grid_html || '
                                    <div style="padding-top:50px">
                                       <a href="' || r_supplier.WEBSITE || '" 
                                        target="_blank"
                                        class="variable-button h4" 
                                        data-text="Visit Website" 
                                        data-texthover="' || r_supplier.SUPPLIER_NAME || '"
                                        style="--hover-background-color: ' || r_supplier.ROLLOVER_COLOUR || ';  --icon-content: ''\f08b''; --hover-icon-content: ''\f35d'';">
                                      </a> 
                                      </div>';







                                            v_grid_html := v_grid_html || '</div>

                                            <!-- Tabs and Dynamic Content -->
                                            <div class="col-md-8  margin-top-10">

                                                <div class="heading side-head">
                                                    <div class="head-8">
                                                        <h1 class="heavy-font  head-6  white-text-shadow" style="color:'||r_supplier.ROLLOVER_COLOUR||';">'||r_supplier.SUPPLIER_NAME||'</h1>
                                                    </div>
                                                </div>
                                                <div class="centered-image scaled-image-50 desktop-hide " style="margin-bottom: 20px;">
                                                    <img src="' || v_ws_url  || 'assets/images/Scientific/suppliers/'||r_supplier.SUPPLIER_LOGO_LARGE||'" >
                                                </div>
                                                <div class="tabs-style-ballon">'||r_supplier.PROFILE_1||'</div>
                                             </div>
                                    </div>
                                    </div>

                                </div>'|| CHR(10);
            ELSE
                                  v_grid_html := v_grid_html ||
                                 ' <div id="'||r_supplier.ANCHOR_ID||'" class="section-no-padtop  fixed-bg" style="background-image:url(''' || v_ws_url || r_supplier.SUPPLIER_IMAGE_BACKGROUND || ''');background-size:cover">


                                         <!-- Tabs and Dynamic Content -->
                                        <div class="container-syn  ">
                                            <div class="margin-top-30">

                                                <div class="heading side-head">
                                                    <div class="head-8">
                                                        <h1 class="heavy-font  head-6  white-text-shadow" style="color:'||r_supplier.ROLLOVER_COLOUR||';">'||r_supplier.SUPPLIER_NAME||'</h1>
                                                    </div>
                                                </div>
                                                <div class="centered-image scaled-image-50 desktop-hide " style="margin-bottom: 20px;">
                                                    <img src="' || v_ws_url  || 'assets/images/Scientific/suppliers/'||r_supplier.SUPPLIER_LOGO_LARGE||'" >
                                                </div>
                                                <div class="tabs-style-ballon">'||r_supplier.PROFILE_1||'</div>
                                                </div>
                                            </div>

                                              <div class="col-md-4 hideable static-section" style="display: flex; flex-direction: column; position: relative; ">
                                                <img src="' || v_ws_url  || 'assets/images/Scientific/suppliers/'||r_supplier.SUPPLIER_LOGO_LARGE||'" class="hideable" style="padding-top: 0px;">';


                                                 v_grid_html := v_grid_html || '
                                                <div style="padding-top:20px">
                                                   <a href="' || r_supplier.WEBSITE || '" 
                                                    target="_blank"
                                                    class="variable-button h4" 
                                                    data-text="Visit Website" 
                                                    data-texthover="' || r_supplier.SUPPLIER_NAME || '"
                                                    style="--hover-background-color: ' || r_supplier.ROLLOVER_COLOUR || ';  --icon-content: ''\f08b''; --hover-icon-content: ''\f35d'';">
                                                  </a> 
                                                </div>
                                            </div>

                                        </div>



                                </div>'|| CHR(10);           



            END IF;

            IF r_supplier.supplier_products > 0
              THEN
            v_grid_html :=  v_grid_html ||

             '<div id="'|| r_supplier.SUPPLIER_NAME ||'_products" class="section-no-padtop  white-bg" > ';



                        -- Third loop: PRODUCT level (for each supplier and discipline/product group)
                        FOR r_product IN (
                            SELECT p.PRODUCT_ID,p.PRODUCT_NAME,p.PRODUCT_IMAGE_LARGE,PRODUCT_LINK,REPLACE(ABOUT_1, '#WORKSPACE_FILES#', v_ws_url)  PRODUCT_ABOUT,PRODUCT_ENQUIRE,
                            GET_ANCHOR_ID ('sup',dpg.DISCIPLINE_ID,dpg.PRODUCT_GROUP_ID,dpg.SUPPLIER_ID,p.PRODUCT_ID,'code')  ANCHOR_ID, 
                            p.PRODUCT_IMAGE_LARGE_WIDTH, p.PRODUCT_IMAGE_LARGE_HEIGHT 
                            FROM PRODUCTS p
                            JOIN DISCIPLINE_PRODUCT_GROUP_VIEW dpg 
                              ON p.SUPPLIER_ID = dpg.SUPPLIER_ID
                             AND p.DISCIPLINE_ID = dpg.DISCIPLINE_ID  -- Ensure same discipline
                             AND p.PRODUCT_GROUP_ID = dpg.PRODUCT_GROUP_ID  -- Ensure same product group
                            WHERE dpg.SUPPLIER_ID = r_supplier.SUPPLIER_ID
                              AND dpg.DISCIPLINE_ID = r_discipline.DISCIPLINE_ID
                              and p.PRODUCT_TYPE_ID = dpg.PRODUCT_TYPE_ID
                              AND dpg.PRODUCT_GROUP_ID = nvl(r_discipline.PRODUCT_GROUP_ALT_ID,r_discipline.PRODUCT_GROUP_ID)
                              AND dpg.PRODUCT_TYPE_ID = r_discipline.PRODUCT_TYPE_ID
                              AND p.DELETED = 'N' AND p.ACTIVE = 'Y'            
                                ORDER BY p.PRODUCT_ID
                        ) LOOP

                       -- Product Details
                       v_grid_html :=  v_grid_html || Product_details_display (p_device_type, v_ws_url, r_product.PRODUCT_ID, 'Y' );




                         v_grid_html :=  v_grid_html ||'



';





                         v_grid_html :=  v_grid_html 
                         ||'
                        '  || CHR(10);

                        v_grid_html :=  v_grid_html ||'<div class="container-syn grylight-bg" style="border: 1px solid #ccc; ">' ||  
                                 Product_related_details   ( r_product.PRODUCT_ID ,v_ws_url,p_device_type )
                        ||'</div>';
                        END LOOP;


             v_grid_html :=v_grid_html || CHR(10);

            END iF;

                    END LOOP;
             v_grid_html :=v_grid_html || CHR(10);
                END LOOP;  




                RETURN v_grid_html;
            END;

/
