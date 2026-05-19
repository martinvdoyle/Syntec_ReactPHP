--------------------------------------------------------
--  DDL for Function GENERATE_MENU_NAV_UL_LI_DESKTOP
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."GENERATE_MENU_NAV_UL_LI_DESKTOP" (
    p_app_id IN number,p_app_alias IN VARCHAR2,p_workspace_url IN VARCHAR2,
    p_business IN varchar2,p_website IN varchar2,
    p_main_menu  IN varchar, p_main_menu_id IN varchar, p_sub_menu_l1_id IN varchar,
    p_sub_menu_l2_id IN varchar, p_sub_menu_l3_id IN varchar
  )
  RETURN CLOB IS
      v_device_type constant varchar2(10) := 'DESKTOP';
      v_menu_html CLOB := '';
      v_business varchar2(50);

      v_main_menu varchar2(4000);
      v_sub_menu_L1 varchar2(4000);
      v_sub_menu_L2 varchar2(4000);
      v_sub_menu_L3 varchar2(4000);
      v_product_type varchar2(4000);

      v_main_menu_id       varchar2(4000);
      v_sub_menu_Level_id  varchar2(4000);    
      v_sub_menu_L1_id     varchar2(4000);
      v_sub_menu_L2_id     varchar2(4000);
      v_sub_menu_L3_id     varchar2(4000);

      v_menu_name          varchar2(100);
      v_menu_icon          varchar2(100);
      v_menu_url           varchar2(400);  
      v_menu_href          varchar2(4000); -- NEW: computed URL (friendly) used in onclick
      v_menu_class         varchar2(4000);    
      v_menu_sub_text      varchar2(100);
      v_col_group_class    varchar2(50);

      v_anchor_id          varchar2(200); 
      v_menu_anchor_id     varchar2(200); 
      v_website_set        varchar2(100);   
      v_business_set       varchar2(100);   
      v_website_anchor     varchar2(100);   
      v_mobile_chevron     varchar2(200);  -- stays but will be '' on DESKTOP
      v_has_col_groups     number := 0;
      v_is_grouped_menu    number := 0;
      v_col_group_num      number := 0;
      v_prev_col_group_num number := 0;
      v_skip_l1_wrapper    number := 0;

      CURSOR menu_items_cur IS
          select
            menu_id,
            menu_name,
            sub_menu_name        sub_menu_name,
            nvl(website_set,website) website_set,
            parent_id,
            url, -- CHANGED (was replace/replace)
            CASE 
              WHEN v_device_type = 'MOBILE' THEN 
                TRIM(REPLACE(REPLACE(class, 'mega-menu', ''),'col-md-4',''))
              ELSE class
            END AS  class,
            CASE 
              WHEN v_device_type = 'MOBILE' AND url_mobile ='#' THEN 
                '<i class="chevron fas fa-chevron-down"></i>'
              ELSE ''
            END AS mobile_chevron, 
            icon_class,
            sub_menu_id,
            website_anchor,
            sub_menu_level_id,
            sub_menu_text,
            product_type,
            discipline_id, 
            product_group_id, 
            supplier_id, 
            product_id,
            GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L0','MENU_NAME') menu_mmain_name,
            GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L0','MENU_ID') menu_main_id,
            GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L1','MENU_NAME') menu_L1_name,
            GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L1','MENU_ID') menu_L1_id,
            GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L2','MENU_NAME') menu_L2_name,
            GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L2','MENU_ID') menu_L2_id,
            GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L3','MENU_NAME') menu_L3_name,
            GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L3','MENU_ID') menu_L3_id,                
            business_set,
            MENU_ORDER menu_unique_id
          FROM MENU_ITEMS
          where (BUSINESS = v_business or BUSINESS is null)
            and (website is null or website = p_website)
            and enabled = 'Y'
          ORDER BY MENU_ID_ORDER,MENU_ID,SUB_MENU_ID,SUB_MENU_LEVEL_ID,MENU_ORDER;
  BEGIN
      IF p_business is null then v_business := 'Ireland'; ELSE v_business := p_business; end if;

      v_menu_html := v_menu_html || '<ul class="main-menu">';

      -- L0
      FOR r_menu IN menu_items_cur LOOP
        v_menu_name := r_menu.menu_name; 
        v_menu_icon := r_menu.icon_class;   
        v_main_menu := v_menu_name;
        v_menu_url  := r_menu.url;

        -- NEW: compute friendly URL for menus if numeric page_id, else fallback
        v_menu_href := case
                        when regexp_like(v_menu_url, '^\d+$')
                        then syntec_page_url(to_number(v_menu_url), 1)
                        else v_menu_url
                      end;

        v_menu_class  := r_menu.class;
        v_anchor_id := v_main_menu;
        v_website_set := r_menu.website_set;     
        v_website_anchor := r_menu.website_anchor;
        v_menu_sub_text := r_menu.sub_menu_text;
        v_business_set := r_menu.business_set;    
        v_product_type := r_menu.product_type;

        v_main_menu    := r_menu.menu_mmain_name;
        v_sub_menu_Level_id := r_menu.sub_menu_level_id;
        v_sub_menu_L1  := r_menu.menu_L1_name;
        v_sub_menu_L2  := r_menu.menu_L2_name;
        v_sub_menu_L3  := r_menu.menu_L3_name;

        v_main_menu_id   := r_menu.menu_main_id;
        v_sub_menu_L1_id := r_menu.menu_L1_id;
        v_sub_menu_L2_id := r_menu.menu_L2_id;
        v_sub_menu_L3_id := r_menu.menu_L3_id;  

        -- Force Portfolio to use standard dropdown container (same behavior as Suppliers)
        IF upper(nvl(v_main_menu,'')) = 'PORTFOLIO'
          OR upper(nvl(r_menu.menu_name,'')) = 'PORTFOLIO'
          OR upper(nvl(r_menu.menu_mmain_name,'')) = 'PORTFOLIO' THEN
          v_menu_class := replace(v_menu_class, 'mega-menu', '');
        END IF;

        IF r_menu.menu_unique_id IN (p_main_menu_id, p_sub_menu_l1_id, p_sub_menu_l2_id, p_sub_menu_l3_id) THEN
          v_menu_class := v_menu_class || ' selected';
        END IF;

        v_mobile_chevron :=  r_menu.mobile_chevron;  -- '' on DESKTOP

        IF v_website_anchor is null THEN
          v_anchor_id := 'main_menu';
        ELSE
          v_anchor_id :=  v_website_anchor;                    
        END IF;

        IF r_menu.parent_id IS NULL THEN
          v_menu_html := v_menu_html || '<li id="' || v_anchor_id || '" class="' || v_menu_class || '"';
          IF v_menu_class LIKE '%mega-menu%' THEN
            v_menu_html := v_menu_html || ' style="overflow:visible !important;"';
          END IF;
          v_menu_html := v_menu_html || '>';


          v_menu_html := v_menu_html || '<a href="#" onclick="handleMenuClick(event, ''' 
                || v_main_menu || ''', ''' 
                || v_main_menu_id || ''', ''' 
                || v_sub_menu_L1 || ''',''' 
                || v_sub_menu_L1_id || ''','''                                             
                || v_sub_menu_L2 || ''',''' 
                || v_sub_menu_L2_id || ''','''    
                || v_sub_menu_L3 || ''',''' 
                || v_sub_menu_L3_id || ''','''    
                || v_product_type || ''','''                                            
                || v_website_set || ''', ''' 
                || v_anchor_id || ''', ''' 
                || v_business_set || ''', ''' 
                || v_sub_menu_Level_id || ''', ''' 
                || v_menu_href || ''')">';

          v_menu_html := v_menu_html || '<i class="' || v_menu_icon || '"></i> '|| v_menu_name || '</a>';


          -- Has L1?
          DECLARE v_sub_menu_exists NUMBER; BEGIN
            SELECT COUNT(*) INTO v_sub_menu_exists 
            FROM MENU_ITEMS 
            WHERE parent_id = r_menu.menu_id
              AND (BUSINESS = v_business OR BUSINESS IS NULL);

            IF v_sub_menu_exists > 0 THEN
              SELECT COUNT(*)
                INTO v_has_col_groups
                FROM MENU_ITEMS
              WHERE parent_id = r_menu.menu_id
                AND enabled = 'Y'
                AND (BUSINESS = v_business OR BUSINESS IS NULL)
                AND INSTR(NVL(class,''), 'col-group-') > 0;

              v_menu_html := v_menu_html || '<ul id="' || v_menu_name || '" '||
                (CASE 
                      WHEN v_menu_class LIKE '%mega-menu%' and v_device_type = 'DESKTOP' THEN
                        CASE
                          WHEN v_has_col_groups > 0 THEN 'class="mega-menu_pos mega-menu_pos-grouped" style="display:flex !important;flex-flow:column wrap !important;align-content:stretch !important;height:560px !important;overflow:hidden !important;margin-left:0 !important;padding-left:0 !important;border-left:2px solid #8dc63f !important;"'
                          ELSE 'class="mega-menu_pos" style="left:0 !important;right:auto !important;margin-left:0 !important;padding-left:0 !important;border-left:2px solid #8dc63f !important;"'
                        END
                      ELSE 'style="border-left:2px solid #8dc63f !important;"' 
                  END) || '> ';
              IF v_has_col_groups > 0 THEN
                v_is_grouped_menu := 1;
              ELSE
                v_is_grouped_menu := 0;
              END IF;

              v_prev_col_group_num := 0;

              -- L1
              FOR r_sub IN (
                SELECT
                  menu_id,
                  menu_name,
                  sub_menu_name        sub_menu_name,
                  nvl(website_set,website) website_set,
                  parent_id,
                  url, -- CHANGED (was replace/replace)
                  CASE 
                    WHEN v_device_type = 'MOBILE' THEN TRIM(REPLACE(REPLACE(class, 'mega-menu', ''),'col-md-4',''))
                    ELSE class
                  END AS  class,
                  CASE 
                    WHEN v_device_type = 'MOBILE' AND url_mobile ='#' THEN '<i class="chevron fas fa-chevron-down"></i>'
                    ELSE ''
                  END AS mobile_chevron,
                  icon_class,
                  sub_menu_id,
                  website_anchor,
                  sub_menu_level_id,
                  sub_menu_text,
                  product_type,  
                  discipline_id, product_group_id, supplier_id, product_id,
                  GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L0','MENU_NAME') menu_mmain_name,
                  GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L0','MENU_ID') menu_main_id,
                  GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L1','MENU_NAME') menu_L1_name,
                  GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L1','MENU_ID') menu_L1_id,
                  GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L2','MENU_NAME') menu_L2_name,
                  GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L2','MENU_ID') menu_L2_id,
                  GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L3','MENU_NAME') menu_L3_name,
                  GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L3','MENU_ID') menu_L3_id,                
                  business_set,
                  MENU_ORDER menu_unique_id
                FROM menu_items
                WHERE parent_id = r_menu.menu_id
                  AND ( business = v_business OR business IS NULL )
                  and enabled = 'Y'
                ORDER BY MENU_ID_ORDER,menu_id,sub_menu_id,sub_menu_level_id,menu_order            
              ) LOOP

                v_menu_name := r_sub.menu_name; 
                v_menu_icon := r_sub.icon_class;   
                v_menu_url  := r_sub.url;

                -- NEW
                v_menu_href := case
                                when regexp_like(v_menu_url, '^\d+$')
                                then syntec_page_url(to_number(v_menu_url), 1)
                                else v_menu_url
                              end;

                v_menu_class  := r_sub.class;
                v_col_group_class := '';
                v_website_set := r_sub.website_set;     
                v_website_anchor := r_sub.website_anchor;  
                v_menu_sub_text := r_sub.sub_menu_text;  
                v_business_set := r_sub.business_set;
                v_product_type := r_sub.product_type;

                v_main_menu    := r_sub.menu_mmain_name;
                v_sub_menu_Level_id := r_sub.sub_menu_level_id;
                v_sub_menu_L1  := r_sub.menu_L1_name;
                v_sub_menu_L2  := r_sub.menu_L2_name;
                v_sub_menu_L3  := r_sub.menu_L3_name;

                v_main_menu_id   := r_sub.menu_main_id;
                v_sub_menu_L1_id := r_sub.menu_L1_id;
                v_sub_menu_L2_id := r_sub.menu_L2_id;
                v_sub_menu_L3_id := r_sub.menu_L3_id;    

                IF r_sub.menu_unique_id IN (p_main_menu_id, p_sub_menu_l1_id, p_sub_menu_l2_id, p_sub_menu_l3_id) THEN
                  v_menu_class := v_menu_class || ' selected';
                END IF; 

                v_skip_l1_wrapper := 0;

                -- Optional explicit mega-column grouping, e.g. class contains: col-group-1..col-group-4
                IF INSTR(v_menu_class, 'col-group-1') > 0 THEN
                  v_col_group_class := ' mega-col-group-1';
                  v_col_group_num := 1;
                ELSIF INSTR(v_menu_class, 'col-group-2') > 0 THEN
                  v_col_group_class := ' mega-col-group-2';
                  v_col_group_num := 2;
                ELSIF INSTR(v_menu_class, 'col-group-3') > 0 THEN
                  v_col_group_class := ' mega-col-group-3';
                  v_col_group_num := 3;
                ELSIF INSTR(v_menu_class, 'col-group-4') > 0 THEN
                  v_col_group_class := ' mega-col-group-4';
                  v_col_group_num := 4;
                ELSE
                  v_col_group_num := 0;
                END IF;

                IF v_has_col_groups > 0
                  AND v_col_group_num > 0
                  AND v_prev_col_group_num > 0
                  AND v_col_group_num <> v_prev_col_group_num THEN
                  v_col_group_class := v_col_group_class || ' mega-col-start';
                END IF;
                IF v_col_group_num > 0 THEN
                  v_prev_col_group_num := v_col_group_num;
                END IF;

                v_mobile_chevron :=  r_sub.mobile_chevron; -- '' on desktop

                IF v_website_anchor is null THEN
                  v_anchor_id := GET_ANCHOR_ID ('sup',r_sub.DISCIPLINE_ID,r_sub.PRODUCT_GROUP_ID,r_sub.SUPPLIER_ID, r_sub.PRODUCT_ID,'code');
                  v_menu_anchor_id := GET_ANCHOR_ID ('mnu',r_sub.DISCIPLINE_ID,r_sub.PRODUCT_GROUP_ID,r_sub.SUPPLIER_ID, r_sub.PRODUCT_ID,'code');
                ELSE
                  v_anchor_id :=  v_website_anchor;                    
                END IF;

                IF v_skip_l1_wrapper = 0 THEN
                  v_menu_html := v_menu_html || '<li id="' ||v_menu_anchor_id ||'" class="' || v_menu_class || v_col_group_class || '"';
                  IF v_is_grouped_menu = 1 THEN
                    v_menu_html := v_menu_html || ' style="display:block !important;width:25% !important;float:none !important;break-inside:avoid !important;-webkit-column-break-inside:avoid !important;page-break-inside:avoid !important;"';
                  END IF;
                  v_menu_html := v_menu_html || '>';
                END IF;

                -- col-md-4 branch: DESKTOP path
                IF v_skip_l1_wrapper = 0 AND (INSTR(v_menu_class, 'col-md-4') > 0 OR INSTR(v_menu_class, 'col-md-3') > 0) THEN
                  v_menu_html := v_menu_html || '<div class="col-md-4-menu-h4 mega-menu-cat-head"><i class="' || v_menu_icon || '"></i> '||  '<h4 class="mega-menu-h4">'  
                      || '<a href="#" onclick="handleMenuClick(event, ''' 
                      || v_main_menu || ''', ''' 
                      || v_main_menu_id || ''', ''' 
                      || v_sub_menu_L1 || ''',''' 
                      || v_sub_menu_L1_id || ''','''                                             
                      || v_sub_menu_L2 || ''',''' 
                      || v_sub_menu_L2_id || ''','''    
                      || v_sub_menu_L3 || ''',''' 
                      || v_sub_menu_L3_id || ''','''    
                      || v_product_type || ''','''                                            
                      || v_website_set || ''', ''' 
                      || v_anchor_id || ''', ''' 
                      || v_business_set || ''', ''' 
                      || v_sub_menu_Level_id || ''', ''' 
                      || v_menu_href || ''')">'
                      ||v_menu_name||'</a></h4> </div>';                                    
                ELSIF v_skip_l1_wrapper = 0 THEN
                  v_menu_html := v_menu_html ||'<a href="#" onclick="handleMenuClick(event, ''' 
                        || v_main_menu || ''', ''' 
                        || v_main_menu_id || ''', ''' 
                        || v_sub_menu_L1 || ''',''' 
                        || v_sub_menu_L1_id || ''','''                                             
                        || v_sub_menu_L2 || ''',''' 
                        || v_sub_menu_L2_id || ''','''    
                        || v_sub_menu_L3 || ''',''' 
                        || v_sub_menu_L3_id || ''','''    
                        || v_product_type || ''','''                                            
                        || v_website_set || ''', ''' 
                        || v_anchor_id || ''', ''' 
                        || v_business_set || ''', ''' 
                        || v_sub_menu_Level_id || ''', ''' 
                        || v_menu_href || ''')">';
                  v_menu_html := v_menu_html || '<i class="' || v_menu_icon || '"></i> ';
                  v_menu_html := v_menu_html || v_menu_name || '</a>'; -- no mobile chevron
                END IF;

                -- Portfolio uses standard menu_items hierarchy path (same pattern as Suppliers).
                -- L2 existence?
                DECLARE v_sub_sub_menu_exists NUMBER; BEGIN
                  SELECT COUNT(*) INTO v_sub_sub_menu_exists 
                  FROM MENU_ITEMS 
                  WHERE parent_id = r_sub.menu_id
                    AND (BUSINESS = v_business OR BUSINESS IS NULL);

                  IF v_sub_sub_menu_exists > 0 THEN
                    v_menu_html := v_menu_html || '<ul data-syntec-fix="l2-reset-from-generate_menu_nav_ul_li_desktop" style="left:100% !important;margin-left:0 !important;padding-left:0 !important;margin-top:0 !important;padding-top:0 !important;list-style:none !important;">';

                    -- L2
                    FOR r_sub_sub IN (
                      SELECT
                        menu_id,
                        menu_name,
                        sub_menu_name        sub_menu_name,
                        nvl(website_set,website) website_set,
                        parent_id,
                        url, -- CHANGED
                        CASE 
                          WHEN v_device_type = 'MOBILE' THEN TRIM(REPLACE(REPLACE(class, 'mega-menu', ''),'col-md-4',''))
                          ELSE class
                        END AS  class,
                        CASE 
                          WHEN v_device_type = 'MOBILE' AND url_mobile ='#' THEN '<i class="chevron fas fa-chevron-down"></i>'
                          ELSE ''
                        END AS mobile_chevron,                           
                        icon_class,
                        sub_menu_id,
                        website_anchor,
                        sub_menu_level_id,
                        sub_menu_text,
                        product_type, 
                        discipline_id, product_group_id, supplier_id, product_id,
                        GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L0','MENU_NAME') menu_mmain_name,
                        GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L0','MENU_ID') menu_main_id,
                        GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L1','MENU_NAME') menu_L1_name,
                        GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L1','MENU_ID') menu_L1_id,
                        GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L2','MENU_NAME') menu_L2_name,
                        GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L2','MENU_ID') menu_L2_id,
                        GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L3','MENU_NAME') menu_L3_name,
                        GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L3','MENU_ID') menu_L3_id,                
                        business_set,
                        MENU_ORDER menu_unique_id
                      FROM menu_items
                      WHERE parent_id = r_sub.menu_id
                        AND ( business = v_business OR business IS NULL )
                        and enabled = 'Y'
                      ORDER BY MENU_ID_ORDER,menu_id,sub_menu_id,sub_menu_level_id,menu_order
                    ) LOOP
                      v_menu_name := r_sub_sub.sub_menu_name; 
                      v_menu_icon := r_sub_sub.icon_class;   
                      v_menu_url  := r_sub_sub.url;

                      -- NEW
                      v_menu_href := case
                                      when r_sub_sub.sub_menu_level_id = 'L2'
                                        and upper(nvl(r_sub_sub.menu_mmain_name,'')) in ('PORTFOLIO','SYNTEC SCIENTIFIC')
                                      then 'f?p=' || p_app_id || ':22:' || v('APP_SESSION')
                                            || '::::'
                                            || 'P0_NAV_MODE,P0_DIAGNOSTIC_ID_CTX,P0_PRODUCT_LINE_ID_CTX,P0_CONTEXT_SOURCE'
                                            || ':HIERARCHY,'
                                            || nvl(r_sub_sub.discipline_id,'')
                                            || ','
                                            || nvl(r_sub_sub.product_group_id,'')
                                            || ','
                                            || case
                                                when upper(nvl(r_sub_sub.menu_mmain_name,'')) = 'PORTFOLIO' then 'PORTFOLIO'
                                                else 'MEGA'
                                              end
                                      when regexp_like(v_menu_url, '^\d+$')
                                      then syntec_page_url(to_number(v_menu_url), 1)
                                      else v_menu_url
                                    end;

                      v_menu_class  := r_sub_sub.class;
                      v_website_set := r_sub_sub.website_set;     
                      v_website_anchor := r_sub_sub.website_anchor;
                      v_menu_sub_text  := r_sub_sub.sub_menu_text;
                      v_business_set := r_sub_sub.business_set;
                      v_product_type := r_sub_sub.product_type;

                      v_main_menu    := r_sub_sub.menu_mmain_name;
                      v_sub_menu_Level_id := r_sub_sub.sub_menu_level_id;
                      v_sub_menu_L1  := r_sub_sub.menu_L1_name;
                      v_sub_menu_L2  := r_sub_sub.menu_L2_name;
                      v_sub_menu_L3  := r_sub_sub.menu_L3_name;

                      v_main_menu_id   := r_sub_sub.menu_main_id;
                      v_sub_menu_L1_id := r_sub_sub.menu_L1_id;
                      v_sub_menu_L2_id := r_sub_sub.menu_L2_id;
                      v_sub_menu_L3_id := r_sub_sub.menu_L3_id;      

                      IF r_sub_sub.menu_unique_id IN (p_main_menu_id, p_sub_menu_l1_id, p_sub_menu_l2_id, p_sub_menu_l3_id) THEN
                        v_menu_class := v_menu_class || ' selected';
                      END IF; 

                      v_mobile_chevron :=  r_sub_sub.mobile_chevron; -- '' on desktop

                      IF v_website_anchor is null THEN
                        v_anchor_id      := GET_ANCHOR_ID ('sup',r_sub_sub.DISCIPLINE_ID,r_sub_sub.PRODUCT_GROUP_ID,r_sub_sub.SUPPLIER_ID, r_sub_sub.PRODUCT_ID,'code');
                        v_menu_anchor_id := GET_ANCHOR_ID ('mnu',r_sub_sub.DISCIPLINE_ID,r_sub_sub.PRODUCT_GROUP_ID,r_sub_sub.SUPPLIER_ID, r_sub_sub.PRODUCT_ID,'code');
                      ELSE
                        v_anchor_id :=  v_website_anchor;                    
                      END IF;

                      v_menu_html := v_menu_html || '<li id="' || v_menu_anchor_id ||  '" class="' || v_menu_class || '">';

                      v_menu_html := v_menu_html || '<a href="#" onclick="handleMenuClick(event, ''' 
                                || v_main_menu || ''', ''' 
                                || v_main_menu_id || ''', ''' 
                                || v_sub_menu_L1 || ''',''' 
                                || v_sub_menu_L1_id || ''','''                                             
                                || v_sub_menu_L2 || ''',''' 
                                || v_sub_menu_L2_id || ''','''    
                                || v_sub_menu_L3 || ''',''' 
                                || v_sub_menu_L3_id || ''','''    
                                || v_product_type || ''','''                                            
                                || v_website_set || ''', ''' 
                                || v_anchor_id || ''', ''' 
                                || v_business_set || ''', ''' 
                                || v_sub_menu_Level_id || ''', ''' 
                                || v_menu_href || ''')" ';

                      v_menu_html := v_menu_html || 'class="mega-item-link">';

                      v_menu_html := v_menu_html || '<div class="mega-item-wrap">';
                      v_menu_html := v_menu_html || '<i class="' || v_menu_icon || '"></i>';
                      v_menu_html := v_menu_html || '<div class="mega-item-text"><span>' || v_menu_name || '</span>';

                      IF v_menu_sub_text IS NOT NULL THEN
                        v_menu_html := v_menu_html || '<br><span style="font-size: 0.9em; color: #999; display: inline-block;font-style: italic">' || v_menu_sub_text || '</span>';
                      END IF;

                      v_menu_html := v_menu_html || '</div></div></a>';

                      --------------------------------------------------------------------------------
                      -- RESTORED L3 BLOCK (Desktop): if this L2 has children, render nested UL + L3
                      --------------------------------------------------------------------------------
                      IF r_sub_sub.sub_menu_level_id = 'L2' THEN
                        DECLARE v_l3_menu_exists NUMBER; BEGIN
                          SELECT COUNT(*) INTO v_l3_menu_exists 
                          FROM MENU_ITEMS
                          WHERE parent_id = r_sub_sub.menu_id
                            AND (BUSINESS = v_business OR BUSINESS IS NULL);

                          IF v_l3_menu_exists > 0 THEN
                            v_menu_html := v_menu_html || '<ul data-syntec-fix="l3-reset-from-generate_menu_nav_ul_li_desktop" style="left:100% !important;margin-left:0 !important;padding-left:0 !important;margin-top:0 !important;padding-top:0 !important;list-style:none !important;">';

                            FOR r_sub_sub_sub IN (
                              SELECT
                                menu_id,
                                menu_name,
                                sub_menu_name        sub_menu_name,
                                nvl(website_set,website) website_set,
                                parent_id,
                                url, -- CHANGED
                                CASE 
                                  WHEN v_device_type = 'MOBILE' THEN TRIM(REPLACE(REPLACE(class, 'mega-menu', ''),'col-md-4',''))
                                  ELSE class
                                END AS  class,
                                CASE 
                                  WHEN v_device_type = 'MOBILE' AND url_mobile ='#' THEN '<i class="chevron fas fa-chevron-down"></i>'
                                  ELSE ''
                                END AS mobile_chevron,
                                icon_class,
                                sub_menu_id,
                                website_anchor,
                                sub_menu_level_id,
                                sub_menu_text,
                                product_type,
                                discipline_id, product_group_id, supplier_id, product_id,
                                GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L0','MENU_NAME') menu_mmain_name,
                                GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L0','MENU_ID') menu_main_id,
                                GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L1','MENU_NAME') menu_L1_name,
                                GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L1','MENU_ID') menu_L1_id,
                                GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L2','MENU_NAME') menu_L2_name,
                                GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L2','MENU_ID') menu_L2_id,
                                GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L3','MENU_NAME') menu_L3_name,
                                GET_MENU_INFO ( COALESCE(MENU_ORDER_CLONE, MENU_ORDER),'L3','MENU_ID') menu_L3_id,
                                business_set,
                                MENU_ORDER menu_unique_id
                              FROM menu_items
                              WHERE parent_id = r_sub_sub.menu_id
                                AND ( business = v_business OR business IS NULL )
                                and enabled = 'Y'
                              ORDER BY MENU_ID_ORDER,menu_id,sub_menu_id,sub_menu_level_id,menu_order
                            ) LOOP
                              v_menu_name := r_sub_sub_sub.sub_menu_name; 
                              v_menu_icon := r_sub_sub_sub.icon_class;   
                              v_menu_url  := r_sub_sub_sub.url;

                              -- NEW
                              v_menu_href := case
                                              when regexp_like(v_menu_url, '^\d+$')
                                              then syntec_page_url(to_number(v_menu_url), 1)
                                              else v_menu_url
                                            end;

                              v_menu_class  := r_sub_sub_sub.class;
                              v_website_set := r_sub_sub_sub.website_set;     
                              v_website_anchor := r_sub_sub_sub.website_anchor;
                              v_menu_sub_text  := r_sub_sub_sub.sub_menu_text;
                              v_business_set := r_sub_sub_sub.business_set;
                              v_product_type := r_sub_sub_sub.product_type;

                              v_main_menu    := r_sub_sub_sub.menu_mmain_name;
                              v_sub_menu_Level_id := r_sub_sub_sub.sub_menu_level_id;
                              v_sub_menu_L1  := r_sub_sub_sub.menu_L1_name;
                              v_sub_menu_L2  := r_sub_sub_sub.menu_L2_name;
                              v_sub_menu_L3  := r_sub_sub_sub.menu_L3_name;

                              v_main_menu_id   := r_sub_sub_sub.menu_main_id;
                              v_sub_menu_L1_id := r_sub_sub_sub.menu_L1_id;
                              v_sub_menu_L2_id := r_sub_sub_sub.menu_L2_id;
                              v_sub_menu_L3_id := r_sub_sub_sub.menu_L3_id;  

                              IF r_sub_sub_sub.menu_unique_id IN (p_main_menu_id, p_sub_menu_l1_id, p_sub_menu_l2_id, p_sub_menu_l3_id) THEN
                                v_menu_class := v_menu_class || ' selected';
                              END IF;

                              v_mobile_chevron :=  r_sub_sub_sub.mobile_chevron; 

                              IF v_website_anchor is null THEN
                                v_anchor_id      := GET_ANCHOR_ID ('sup',r_sub_sub_sub.DISCIPLINE_ID,r_sub_sub_sub.PRODUCT_GROUP_ID,r_sub_sub_sub.SUPPLIER_ID, r_sub_sub_sub.PRODUCT_ID,'code');
                                v_menu_anchor_id := GET_ANCHOR_ID ('mnu',r_sub_sub_sub.DISCIPLINE_ID,r_sub_sub_sub.PRODUCT_GROUP_ID,r_sub_sub_sub.SUPPLIER_ID, r_sub_sub_sub.PRODUCT_ID,'code');
                              ELSE
                                v_anchor_id :=  v_website_anchor;                    
                              END IF;

                              v_menu_html := v_menu_html || '<li id="' || v_menu_anchor_id ||  '" class="' || v_menu_class || '">';
                              v_menu_html := v_menu_html || '<a href="#" onclick="handleMenuClick(event, ''' 
                                    || v_main_menu || ''', ''' 
                                    || v_main_menu_id || ''', ''' 
                                    || v_sub_menu_L1 || ''',''' 
                                    || v_sub_menu_L1_id || ''','''                                             
                                    || v_sub_menu_L2 || ''',''' 
                                    || v_sub_menu_L2_id || ''','''    
                                    || v_sub_menu_L3 || ''',''' 
                                    || v_sub_menu_L3_id || ''','''    
                                    || v_product_type || ''','''                                            
                                    || v_website_set || ''', ''' 
                                    || v_anchor_id || ''', ''' 
                                    || v_business_set || ''', ''' 
                                    || v_sub_menu_Level_id || ''', ''' 
                                    || v_menu_href || ''')" ';
                              v_menu_html := v_menu_html || 'class="mega-item-link">';
                              v_menu_html := v_menu_html || '<div class="mega-item-wrap">';
                              v_menu_html := v_menu_html || '<i class="' || v_menu_icon || '"></i>';
                              v_menu_html := v_menu_html || '<div class="mega-item-text">';
                              v_menu_html := v_menu_html || '<span>' || v_menu_name || '</span>';
                              IF v_menu_sub_text IS NOT NULL THEN
                                v_menu_html := v_menu_html || '<br><span style="font-size: 0.9em; color: #999; display: inline-block;font-style: italic">' || v_menu_sub_text || '</span>';
                              END IF;
                              v_menu_html := v_menu_html || '</div></div></a></li>';
                            END LOOP;

                            v_menu_html := v_menu_html || '</ul>'; -- Close L3 UL
                          END IF;
                        END;
                      END IF;
                      --------------------------------------------------------------------------------

                      v_menu_html := v_menu_html || '</li>'; -- close L2 li
                    END LOOP;

                    v_menu_html := v_menu_html || '</ul>'; -- close L2 UL
                  END IF;
                END;

                IF v_skip_l1_wrapper = 0 THEN
                  v_menu_html := v_menu_html || '</li>'; -- close L1 li
                END IF;
              END LOOP;

              v_menu_html := v_menu_html || '</ul>'; -- close L1 UL
            END IF;
          END;

          v_menu_html := v_menu_html || '</li>'; -- close L0 li
        END IF;
      END LOOP;

      v_menu_html := v_menu_html || '</ul>'; -- Close main menu

      RETURN v_menu_html;
  END;


/
