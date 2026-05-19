--------------------------------------------------------
--  DDL for Function GENERATE_MENU_NAV_UL_LI_MOBILE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."GENERATE_MENU_NAV_UL_LI_MOBILE" (
  p_app_id IN number, p_app_alias IN VARCHAR2, p_workspace_url IN VARCHAR2,
  p_business IN varchar2, p_website IN varchar2,
  p_main_menu IN varchar, p_main_menu_id IN varchar,
  p_sub_menu_l1_id IN varchar, p_sub_menu_l2_id IN varchar, p_sub_menu_l3_id IN varchar
)
RETURN CLOB IS
    v_device_type constant varchar2(10) := 'MOBILE';
    v_menu_html CLOB := '';
    v_business varchar2(50);

    v_main_menu varchar2(100);
    v_sub_menu_L1 varchar2(100);
    v_sub_menu_L2 varchar2(100);
    v_sub_menu_L3 varchar2(100);
    v_product_type varchar2(100);

    v_main_menu_id      varchar2(10);
    v_sub_menu_Level_id varchar2(10);    
    v_sub_menu_L1_id    varchar2(10);
    v_sub_menu_L2_id    varchar2(10);
    v_sub_menu_L3_id    varchar2(10);

    v_menu_name     varchar2(100);
    v_menu_icon     varchar2(100);
    v_menu_url      varchar2(400);  
    v_menu_href     varchar2(4000);  -- NEW
    v_menu_class    varchar2(100);    
    v_menu_sub_text varchar2(100);

    v_anchor_id      varchar2(200); 
    v_menu_anchor_id varchar2(200); 
    v_website_set    varchar2(100);   
    v_business_set   varchar2(100);   
    v_website_anchor varchar2(100);   
    v_mobile_chevron varchar2(200); 

    CURSOR menu_items_cur IS
        select
          menu_id, menu_name, sub_menu_name,
          nvl(website_set,website) website_set,
          parent_id,
          url,  -- CHANGED
          CASE 
            WHEN v_device_type = 'MOBILE'
            THEN TRIM(REPLACE(REPLACE(class,'mega-menu',''),'col-md-4',''))
            ELSE class
          END class,
          CASE 
            WHEN v_device_type = 'MOBILE' AND url_mobile = '#'
            THEN '<i class="chevron fas fa-chevron-down"></i>'
            ELSE ''
          END mobile_chevron,
          icon_class, sub_menu_id, website_anchor, sub_menu_level_id,
          sub_menu_text, product_type,
          discipline_id, product_group_id, supplier_id, product_id,
          GET_MENU_INFO (COALESCE(MENU_ORDER_CLONE,MENU_ORDER),'L0','MENU_NAME') menu_mmain_name,
          GET_MENU_INFO (COALESCE(MENU_ORDER_CLONE,MENU_ORDER),'L0','MENU_ID')   menu_main_id,
          GET_MENU_INFO (COALESCE(MENU_ORDER_CLONE,MENU_ORDER),'L1','MENU_NAME') menu_L1_name,
          GET_MENU_INFO (COALESCE(MENU_ORDER_CLONE,MENU_ORDER),'L1','MENU_ID')   menu_L1_id,
          GET_MENU_INFO (COALESCE(MENU_ORDER_CLONE,MENU_ORDER),'L2','MENU_NAME') menu_L2_name,
          GET_MENU_INFO (COALESCE(MENU_ORDER_CLONE,MENU_ORDER),'L2','MENU_ID')   menu_L2_id,
          GET_MENU_INFO (COALESCE(MENU_ORDER_CLONE,MENU_ORDER),'L3','MENU_NAME') menu_L3_name,
          GET_MENU_INFO (COALESCE(MENU_ORDER_CLONE,MENU_ORDER),'L3','MENU_ID')   menu_L3_id,
          business_set,
          MENU_ORDER menu_unique_id
        from MENU_ITEMS
        where (business = v_business or business is null)
          and (website is null or website = p_website)
          and enabled = 'Y'
        order by MENU_ID_ORDER, MENU_ID, SUB_MENU_ID, SUB_MENU_LEVEL_ID, MENU_ORDER;

BEGIN
    v_business := coalesce(p_business,'Ireland');
    v_menu_html := '<ul class="main-menu">';

    FOR r_menu IN menu_items_cur LOOP
      v_menu_url := r_menu.url;

      -- NEW: friendly URL
      v_menu_href := case
                       when regexp_like(v_menu_url,'^\d+$')
                       then syntec_page_url(to_number(v_menu_url),1)
                       else v_menu_url
                     end;

      /* unchanged logic below â€” only last param changed */
      v_menu_html := v_menu_html || '<li class="'||r_menu.class||'">'||
        '<a href="#" onclick="handleMenuClick(event, '''||
        r_menu.menu_mmain_name||''','''||r_menu.menu_main_id||''','''||
        r_menu.menu_L1_name||''','''||r_menu.menu_L1_id||''','''||
        r_menu.menu_L2_name||''','''||r_menu.menu_L2_id||''','''||
        r_menu.menu_L3_name||''','''||r_menu.menu_L3_id||''','''||
        r_menu.product_type||''','''||
        r_menu.website_set||''','''||
        coalesce(r_menu.website_anchor,'main_menu')||''','''||
        r_menu.business_set||''','''||
        r_menu.sub_menu_level_id||''','''||
        v_menu_href||''')">'||
        '<i class="'||r_menu.icon_class||'"></i> '||
        r_menu.menu_name||'</a>'||
        r_menu.mobile_chevron||
        '</li>';
    END LOOP;

    v_menu_html := v_menu_html || '</ul>';
    return v_menu_html;
END;

/
