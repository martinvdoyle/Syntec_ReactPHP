--------------------------------------------------------
--  DDL for Function GENERATE_MENU_NAV_UL_LI
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."GENERATE_MENU_NAV_UL_LI" (
p_app_id IN number,p_app_alias IN VARCHAR2,p_workspace_url IN VARCHAR2,p_business IN varchar2,p_website IN varchar2,
p_main_menu  IN varchar, p_main_menu_id IN varchar, p_sub_menu_l1_id IN varchar, p_sub_menu_l2_id IN varchar, p_sub_menu_l3_id IN varchar,p_device_type IN varchar)
RETURN CLOB IS
    v_menu_html CLOB := '';
    v_business varchar2(50);

    v_main_menu varchar2(100);
    v_sub_menu_L1 varchar2(100);
    v_sub_menu_L2 varchar2(100);
    v_sub_menu_L3 varchar2(100);
    v_product_type varchar2(100);

    v_main_menu_id      varchar2(10);
    v_sub_menu_Level_id  varchar2(10);    
    v_sub_menu_L1_id  varchar2(10);
    v_sub_menu_L2_id  varchar2(10);
    v_sub_menu_L3_id  varchar2(10);

    v_menu_name         varchar2(100);
    v_menu_icon         varchar2(100);
    v_menu_url          varchar2(400);  
    v_menu_class        varchar2(100);    
    v_menu_sub_text     varchar2(100);

    v_anchor_id         varchar2(200); 
    v_menu_anchor_id    varchar2(200); 
    v_website_set       varchar2(100);   
    v_business_set      varchar2(100);   
    v_website_anchor    varchar2(100);   
    v_mobile_chevron    varchar2(200); 

    CURSOR menu_items_cur IS
                select
                menu_id,
                menu_name,
                sub_menu_name        sub_menu_name,
                nvl(website_set,website) website_set,
                parent_id,
                replace(replace(url, '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias) AS url, 

                   CASE 
                       WHEN p_device_type = 'MOBILE' THEN 
                           TRIM(
                               REPLACE(
                                   REPLACE(class, 'mega-menu', ''), 
                                   'col-md-4', ''
                               )
                           )
                       ELSE class
                   END AS  class,

                CASE 
                        WHEN p_device_type = 'MOBILE' AND url_mobile ='#' THEN 
                            '<i class="chevron fas fa-chevron-down"></i>'
                        ELSE 
                            ''
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
    -- Start the HTML output with the top bar and header

IF p_business is null
        then v_business := 'Ireland';
ELSE        
        v_business := p_business;
end if;

    v_menu_html := '

 <ul class="main-menu">';

-- Loop through each main menu item
FOR r_menu IN menu_items_cur LOOP

    v_menu_name := r_menu.menu_name; 
    v_menu_icon := r_menu.icon_class;   
    v_main_menu := v_menu_name;
    v_menu_url  := r_menu.url;
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

     IF r_menu.menu_unique_id IN (p_main_menu_id, p_sub_menu_l1_id, p_sub_menu_l2_id, p_sub_menu_l3_id) THEN
        v_menu_class := v_menu_class || ' selected';
     END IF;

    v_mobile_chevron :=  r_menu.mobile_chevron;  

    IF v_website_anchor is null THEN
        v_anchor_id := 'main_menu';
    ELSE
        v_anchor_id :=  v_website_anchor;                    
    END IF;


    IF r_menu.parent_id IS NULL THEN
        -- Main menu item with id and onclick event
                    v_menu_html := v_menu_html || '<li id="' || v_anchor_id || '" class="' || v_menu_class || '">';

                    IF v_menu_class LIKE '%mega-menu%' THEN
                      v_menu_html := v_menu_html || '<span class="inner-mega">';
                    END IF;

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
                                              || v_menu_url || ''')">';

                    v_menu_html := v_menu_html || '<i class="' || v_menu_icon || '"></i> ';
                    v_menu_html := v_menu_html || v_menu_name || '</a>';

                    IF v_menu_class LIKE '%mega-menu%' THEN
                      v_menu_html := v_menu_html || '</span>';
                    END IF;

                    v_menu_html := v_menu_html || v_mobile_chevron;


        -- Check if submenus exist
        DECLARE
            v_sub_menu_exists NUMBER;
        BEGIN
            SELECT COUNT(*) INTO v_sub_menu_exists 
            FROM MENU_ITEMS 
            WHERE parent_id = r_menu.menu_id
            AND (BUSINESS = v_business OR BUSINESS IS NULL);


            IF v_sub_menu_exists > 0 THEN
                v_menu_html := v_menu_html || '<ul id="' || v_menu_name || '" '||
               (CASE 
                    WHEN v_menu_class LIKE '%mega-menu%' and p_device_type = 'DESKTOP' THEN 'class="mega-menu_pos"'
                    ELSE NULL 
                END)            
                || '> ';

            FOR r_sub IN (

            SELECT
                menu_id,
                menu_name,
                sub_menu_name        sub_menu_name,
                nvl(website_set,website) website_set,
                parent_id,
                replace(replace(url, '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias) AS url,	
                   CASE 
                       WHEN p_device_type = 'MOBILE' THEN 
                           TRIM(
                               REPLACE(
                                   REPLACE(class, 'mega-menu', ''), 
                                   'col-md-4', ''
                               )
                           )
                       ELSE class
                   END AS  class,

	                CASE 
                        WHEN p_device_type = 'MOBILE' AND url_mobile ='#' THEN 
                            '<i class="chevron fas fa-chevron-down"></i>'
                        ELSE 
                            ''
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
            FROM
                menu_items
            WHERE
                    parent_id = r_menu.menu_id
                AND ( business = v_business
                      OR business IS NULL )
                and enabled = 'Y'
            ORDER BY
                MENU_ID_ORDER,
                menu_id,
                sub_menu_id,
                sub_menu_level_id,
                menu_order            
            ) LOOP


            v_menu_name := r_sub.menu_name; 
            v_menu_icon := r_sub.icon_class;   

            v_menu_url  := r_sub.url;
            v_menu_class  := r_sub.class;

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

            v_mobile_chevron :=  r_sub.mobile_chevron; 

            IF v_website_anchor is null THEN
                v_anchor_id := GET_ANCHOR_ID ('sup',r_sub.DISCIPLINE_ID,r_sub.PRODUCT_GROUP_ID,r_sub.SUPPLIER_ID, r_sub.PRODUCT_ID,'code');
                v_menu_anchor_id := GET_ANCHOR_ID ('mnu',r_sub.DISCIPLINE_ID,r_sub.PRODUCT_GROUP_ID,r_sub.SUPPLIER_ID, r_sub.PRODUCT_ID,'code');
            ELSE
                v_anchor_id :=  v_website_anchor;                    
            END IF;

                    v_menu_html := v_menu_html || '<li id="' ||v_menu_anchor_id ||'" class="' || v_menu_class || '">';

                    -- Add the sub-menu item with onclick event
                    IF INSTR(v_menu_class, 'col-md-4') > 0 THEN

                            IF p_device_type = 'MOBILE'
                                    THEN
                                    v_menu_html := v_menu_html || '<i class="' || v_menu_icon || '"></i> '||  '<h4>'  
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
                                              || v_menu_url || ''')">'
                                    ||v_menu_name||'</a></h4>  ' ||v_mobile_chevron;
                                    ELSE
                                    v_menu_html := v_menu_html || '<div class="col-md-4-menu-h4"><i class="' || v_menu_icon || '"></i> '||  '<h4>'  
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
                                              || v_menu_url || ''')">'
                                    ||v_menu_name||'</a></h4> </div>';                                    
                              END IF;      





                    ELSE
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
                                                      || v_menu_url || ''')">';
                        v_menu_html := v_menu_html || '<i class="' || v_menu_icon || '"></i> '; -- Add icon class
                        v_menu_html := v_menu_html || v_menu_name || '</a> '||v_mobile_chevron;
                    END IF;

                    -- Check for further submenus (if no sub menus prevent <ul></ul> output so 'hasChildren' class is not added by script.js
                    DECLARE
                        v_sub_sub_menu_exists NUMBER;
                    BEGIN
                        SELECT COUNT(*) INTO v_sub_sub_menu_exists 
                        FROM MENU_ITEMS 
                        WHERE parent_id = r_sub.menu_id
                        AND (BUSINESS = v_business OR BUSINESS IS NULL);

                        IF v_sub_sub_menu_exists > 0 THEN
                            v_menu_html := v_menu_html || '<ul id="' ||v_menu_name || '">';

                    FOR r_sub_sub IN (
                    SELECT
                    menu_id,
                    menu_name,
                    sub_menu_name        sub_menu_name,
                    nvl(website_set,website) website_set,
                    parent_id,
                    replace(replace(url, '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias) AS url,	
                       CASE 
                           WHEN p_device_type = 'MOBILE' THEN 
                               TRIM(
                                   REPLACE(
                                       REPLACE(class, 'mega-menu', ''), 
                                       'col-md-4', ''
                                   )
                               )
                           ELSE class
                       END AS  class,
	                CASE 
                        WHEN p_device_type = 'MOBILE' AND url_mobile ='#' THEN 
                            '<i class="chevron fas fa-chevron-down"></i>'
                        ELSE 
                            ''
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
                    FROM
                        menu_items
                    WHERE
                            parent_id = r_sub.menu_id
                        AND ( business = v_business
                              OR business IS NULL )
                    and enabled = 'Y'
                    ORDER BY
                        MENU_ID_ORDER,
                        menu_id,
                        sub_menu_id,
                        sub_menu_level_id,
                        menu_order

                    ) LOOP


                    v_menu_name := r_sub_sub.sub_menu_name; 
                    v_menu_icon := r_sub_sub.icon_class;   

                    v_menu_url  := r_sub_sub.url;
                    v_menu_class  := r_sub_sub.class;
                    v_website_set := r_sub_sub.website_set;     
                    v_website_anchor := r_sub_sub.website_anchor;
                    v_menu_sub_text := r_sub_sub.sub_menu_text;
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

                    v_mobile_chevron :=  r_sub_sub.mobile_chevron;

                    IF v_website_anchor is null THEN
                        v_anchor_id      := GET_ANCHOR_ID ('sup',r_sub_sub.DISCIPLINE_ID,r_sub_sub.PRODUCT_GROUP_ID,r_sub_sub.SUPPLIER_ID, r_sub_sub.PRODUCT_ID,'code');
                        v_menu_anchor_id := GET_ANCHOR_ID ('mnu',r_sub_sub.DISCIPLINE_ID,r_sub_sub.PRODUCT_GROUP_ID,r_sub_sub.SUPPLIER_ID, r_sub_sub.PRODUCT_ID,'code');
                    ELSE
                        v_anchor_id :=  v_website_anchor;                    
                    END IF;


                        v_menu_html := v_menu_html || '<li id="' || v_menu_anchor_id ||  '" class="' || v_menu_class || '">';

                        -- Add Anchor for Sub-Menu Item
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
                                                      || v_menu_url || ''')">';
                        v_menu_html := v_menu_html || '<i class="' || v_menu_icon || '"></i> '; -- Add icon class
                        v_menu_html := v_menu_html || v_menu_name || '</a> '||v_mobile_chevron;

                        -- Process L2 and L3 Submenus If They Exist
                        IF r_sub_sub.sub_menu_level_id = 'L2' THEN
                            DECLARE
                                v_l3_menu_exists NUMBER;
                            BEGIN
                                SELECT COUNT(*) INTO v_l3_menu_exists 
                                FROM MENU_ITEMS
                                WHERE parent_id = r_sub_sub.menu_id
                                AND (BUSINESS = v_business OR BUSINESS IS NULL);

                                IF v_l3_menu_exists > 0 THEN


                                        v_menu_html := v_menu_html || '<ul>'; -- Open L2 submenu
                    FOR r_sub_sub_sub IN (
                        SELECT
                        menu_id,
                        menu_name,
                        sub_menu_name        sub_menu_name,
                        nvl(website_set,website) website_set,
                        parent_id,
                        replace(replace(url, '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias) AS url,
                           CASE 
                               WHEN p_device_type = 'MOBILE' THEN 
                                   TRIM(
                                       REPLACE(
                                           REPLACE(class, 'mega-menu', ''), 
                                           'col-md-4', ''
                                       )
                                   )
                               ELSE class
                           END AS  class,
	                CASE 
                        WHEN p_device_type = 'MOBILE' AND url_mobile ='#' THEN 
                            '<i class="chevron fas fa-chevron-down"></i>'
                        ELSE 
                            ''
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
                        FROM
                            menu_items
                        WHERE
                                parent_id = r_sub_sub.menu_id
                            AND ( business = v_business
                                  OR business IS NULL )
                            and enabled = 'Y'
                        ORDER BY
                            MENU_ID_ORDER,
                            menu_id,
                            sub_menu_id,
                            sub_menu_level_id,
                            menu_order
                    ) LOOP


                    v_menu_name := r_sub_sub_sub.sub_menu_name; 
                    v_menu_icon := r_sub_sub_sub.icon_class;   

                    v_menu_url  := r_sub_sub_sub.url;
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

                        -- Open L2 list item
                        v_menu_html := v_menu_html || '<li id="' || v_menu_anchor_id ||  '" class="' || v_menu_class || '">';

                        -- Link with icon and text (block display for full width, flexbox for alignment)
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
                                                      || v_menu_url || ''')" ';

                        v_menu_html := v_menu_html || 'style="display: block; text-decoration: none; padding: 5px;  ">';

                        -- Use a flex container for the icon and text alignment
                        v_menu_html := v_menu_html || '<div style="display: flex; align-items: center;">';

                        -- Icon
                        v_menu_html := v_menu_html || '<i class="' || v_menu_icon || '" style="vertical-align: middle;"></i>';

                        -- Menu name and sub-menu text (stacked vertically)
                        v_menu_html := v_menu_html || '<div>';
                        v_menu_html := v_menu_html || '<span>' || v_menu_name || '</span>';

                        -- SUB_MENU_TEXT immediately under SUB_MENU_NAME, aligned properly
                        IF v_menu_sub_text IS NOT NULL THEN
                            v_menu_html := v_menu_html || '<br><span style="font-size: 0.9em; color: #999; display: inline-block;font-style: italic">' || v_menu_sub_text || '</span>';
                        END IF;

                        v_menu_html := v_menu_html || '</div>'; -- Close inner div for text
                        v_menu_html := v_menu_html || '</div>'; -- Close flex container

                        v_menu_html := v_menu_html || '</a> '||v_mobile_chevron; -- Close link
                        v_menu_html := v_menu_html || '</li>'; -- Close list item
                    END LOOP;




                                                        v_menu_html := v_menu_html || '</ul>'; -- Close L2 submenu
                                                            END IF;
                                                        END;



                                                    END IF;

                                                    -- Close Sub-Menu LI
                                                    v_menu_html := v_menu_html || '</li>';
                                                END LOOP;

                                                v_menu_html := v_menu_html || '</ul>'; -- Close sub-sub-menu
                                            END IF;
                                        END;

                                        v_menu_html := v_menu_html || '</li>'; -- Close sub-menu item
                                    END LOOP;

                                    v_menu_html := v_menu_html || '</ul>'; -- Close sub-menu
                                END IF;
                            END;

                            v_menu_html := v_menu_html || '</li>'; -- Close main menu item
                        END IF;
                    END LOOP;



    v_menu_html := v_menu_html || '</ul>'; -- Close main menu


    RETURN v_menu_html;
END;


/
