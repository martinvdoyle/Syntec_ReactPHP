--------------------------------------------------------
--  DDL for Function GENERATE_MENU_SITEMAP_UL_LI
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."GENERATE_MENU_SITEMAP_UL_LI" (
  p_app_id           in number,
  p_app_alias        in varchar2,
  p_business         in varchar2 default null,
  p_website          in varchar2 default null,
  p_main_menu_id     in varchar2 default null, -- highlight L0
  p_sub_menu_l1_id   in varchar2 default null, -- highlight L1
  p_sub_menu_l2_id   in varchar2 default null, -- highlight L2
  p_sub_menu_l3_id   in varchar2 default null  -- highlight L3
) return clob
is
  v_html clob := empty_clob();

  -- Escape for JS single-quoted args: '  ->  \'
  function jsq(p in varchar2) return varchar2 is
  begin
    return replace(replace(nvl(p,''), '''', chr(92)||''''), chr(10), ' ');
  end;

  -- Replace any <br>, <br/>, <br /> (case-insensitive) with a space
  function strip_br(p in varchar2) return varchar2 is
  begin
    return regexp_replace(nvl(p,''), '<br[[:space:]]*/?>', ' ', 1, 0, 'i');
  end;

  -- Default href fallback
  function safe_href(p in varchar2) return varchar2 is
  begin
    return nvl(p, '#');
  end;

  -- Defaults for business / website used in onclick
  function nv_business return varchar2 is
  begin
    return nvl(p_business, 'Ireland');
  end;

  function nv_website return varchar2 is
  begin
    return nvl(p_website, 'Syntec Group');
  end;

begin
  -- Container + filter
  v_html := v_html ||
    '<div class="syn-sitemap">'||
    '<div class="sitemap-toolbar">'||
    '  <input id="sitemap-filter" type="text" placeholder="Filter pagesï¿½">'||
    '</div>';

  v_html := v_html || '<ul class="sitemap-ul">';

  ---------------------------------------------------------------------------
  -- L0 (all parents with at least one child) ï¿½ NOT filtered by website
  ---------------------------------------------------------------------------
  for rec0 in (
    select
      mi.menu_id,
      mi.menu_name,
      replace(replace(mi.url, '&APP_ID.', p_app_id), '&APP_ALIAS.', p_app_alias) as url,
      mi.icon_class,
      mi.class,
      mi.product_type,
      mi.business_set,
      nvl(mi.website_set, mi.website) website_set,
      mi.website_anchor,
      mi.sub_menu_level_id,
      get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L0', 'MENU_NAME') menu_mmain_name,
      get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L0', 'MENU_ID')   menu_main_id,
      get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L1', 'MENU_NAME') menu_L1_name,
      get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L1', 'MENU_ID')   menu_L1_id,
      get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L2', 'MENU_NAME') menu_L2_name,
      get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L2', 'MENU_ID')   menu_L2_id,
      get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L3', 'MENU_NAME') menu_L3_name,
      get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L3', 'MENU_ID')   menu_L3_id
    from menu_items mi
    where mi.parent_id is null
      and mi.enabled = 'Y'
    order by mi.menu_id_order, mi.menu_id, mi.sub_menu_id, mi.sub_menu_level_id, mi.menu_order
  )
  loop
    -- Only show L0 that actually has children
    declare
      v_has_l1 number;
    begin
      select count(*) into v_has_l1
      from menu_items
      where parent_id = rec0.menu_id
        and enabled   = 'Y';

      if v_has_l1 = 0 then
        null; -- skip
      else
        v_html := v_html ||
          '<li class="node l0'||
            case when rec0.menu_main_id = p_main_menu_id then ' selected' end ||'">';

        -- L0 (href "#" + onclick using p_business/p_website)
        v_html := v_html ||
          '<a href="#" onclick="handleMenuClick(event, '''||
            jsq(strip_br(rec0.menu_mmain_name))||''', '''||
            jsq(rec0.menu_main_id)||''', '''||
            ''||''','''|| ''||''','''||               -- L1 blank
            ''||''','''|| ''||''','''||               -- L2 blank
            ''||''','''|| ''||''','''||               -- L3 blank
            jsq(rec0.product_type)||''', '''||
            jsq(nv_website)||''', '''||
            jsq(nvl(rec0.website_anchor,'main_menu'))||''', '''||
            jsq(nv_business)||''', '''||
            'L0'||''', '''||
            jsq(safe_href(rec0.url))||''')">'||
            '<div class="rowish"><i class="fa fa-bars"></i><span class="label">'||
              jsq(strip_br(rec0.menu_name))||'</span></div></a>';

        -- L1 list
        v_html := v_html || '<ul class="children l1">';

        for rec1 in (
          select mi.*,
            get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L0', 'MENU_NAME') menu_mmain_name,
            get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L0', 'MENU_ID')   menu_main_id,
            get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L1', 'MENU_NAME') menu_L1_name,
            get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L1', 'MENU_ID')   menu_L1_id,
            get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L2', 'MENU_NAME') menu_L2_name,
            get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L2', 'MENU_ID')   menu_L2_id,
            get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L3', 'MENU_NAME') menu_L3_name,
            get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L3', 'MENU_ID')   menu_L3_id
          from menu_items mi
          where mi.parent_id = rec0.menu_id
            and mi.enabled   = 'Y'
          order by mi.menu_id_order, mi.menu_id, mi.sub_menu_id, mi.sub_menu_level_id, mi.menu_order
        )
        loop
          v_html := v_html ||
            '<li class="node l1'||
              case when rec1.menu_L1_id = p_sub_menu_l1_id then ' selected' end ||'">';

          v_html := v_html ||
            '<a href="#" onclick="handleMenuClick(event, '''||
              jsq(strip_br(rec1.menu_mmain_name))||''', '''||
              jsq(rec1.menu_main_id)||''', '''||
              jsq(strip_br(rec1.menu_L1_name))||''', '''||
              jsq(rec1.menu_L1_id)||''', '''||
              ''||''', '''|| ''||''', '''||           -- L2 blank
              ''||''', '''|| ''||''', '''||           -- L3 blank
              jsq(rec1.product_type)||''', '''||
              jsq(nv_website)||''', '''||
              jsq(nvl(rec1.website_anchor, get_anchor_id('mnu', rec1.discipline_id, rec1.product_group_id, rec1.supplier_id, rec1.product_id, 'code')))||''', '''||
              jsq(nv_business)||''', '''||
              'L1'||''', '''||
              jsq(safe_href(replace(replace(rec1.url, '&APP_ID.', p_app_id), '&APP_ALIAS.', p_app_alias)))||''')">'||
              '<div class="rowish"><i class="'||jsq(nvl(rec1.icon_class,'fa fa-angle-right'))||'"></i><span class="label">'||
                jsq(strip_br(rec1.menu_name))||'</span></div></a>';

          -- L2?
          declare v_has_l2 number; begin
            select count(*) into v_has_l2
            from menu_items
            where parent_id = rec1.menu_id
              and enabled   = 'Y';

            if v_has_l2 > 0 then
              v_html := v_html || '<ul class="children l2">';

              for rec2 in (
                select mi.*,
                  get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L0', 'MENU_NAME') menu_mmain_name,
                  get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L0', 'MENU_ID')   menu_main_id,
                  get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L1', 'MENU_NAME') menu_L1_name,
                  get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L1', 'MENU_ID')   menu_L1_id,
                  get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L2', 'MENU_NAME') menu_L2_name,
                  get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L2', 'MENU_ID')   menu_L2_id,
                  get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L3', 'MENU_NAME') menu_L3_name,
                  get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L3', 'MENU_ID')   menu_L3_id
                from menu_items mi
                where mi.parent_id = rec1.menu_id
                  and mi.enabled   = 'Y'
                order by mi.menu_id_order, mi.menu_id, mi.sub_menu_id, mi.sub_menu_level_id, mi.menu_order
              )
              loop
                v_html := v_html ||
                  '<li class="node l2'||
                    case when rec2.menu_L2_id = p_sub_menu_l2_id then ' selected' end ||'">';

                v_html := v_html ||
                  '<a href="#" onclick="handleMenuClick(event, '''||
                    jsq(strip_br(rec2.menu_mmain_name))||''', '''||
                    jsq(rec2.menu_main_id)||''', '''||
                    jsq(strip_br(rec2.menu_L1_name))||''', '''||
                    jsq(rec2.menu_L1_id)||''', '''||
                    jsq(strip_br(rec2.menu_L2_name))||''', '''||
                    jsq(rec2.menu_L2_id)||''', '''||
                    ''||''', '''|| ''||''', '''||       -- L3 blank
                    jsq(rec2.product_type)||''', '''||
                    jsq(nv_website)||''', '''||
                    jsq(nvl(rec2.website_anchor, get_anchor_id('mnu', rec2.discipline_id, rec2.product_group_id, rec2.supplier_id, rec2.product_id, 'code')))||''', '''||
                    jsq(nv_business)||''', '''||
                    'L2'||''', '''||
                    jsq(safe_href(replace(replace(rec2.url, '&APP_ID.', p_app_id), '&APP_ALIAS.', p_app_alias)))||''')">'||
                    '<div class="rowish"><i class="'||jsq(nvl(rec2.icon_class,'fa fa-angle-right'))||'"></i><span class="label">'||
                      jsq(strip_br(rec2.sub_menu_name))||'</span></div></a>';

                -- L3?
                declare v_has_l3 number; begin
                  select count(*) into v_has_l3
                  from menu_items
                  where parent_id = rec2.menu_id
                    and enabled   = 'Y';

                  if v_has_l3 > 0 then
                    v_html := v_html || '<ul class="children l3">';

                    for rec3 in (
                      select mi.*,
                        get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L0', 'MENU_NAME') menu_mmain_name,
                        get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L0', 'MENU_ID')   menu_main_id,
                        get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L1', 'MENU_NAME') menu_L1_name,
                        get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L1', 'MENU_ID')   menu_L1_id,
                        get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L2', 'MENU_NAME') menu_L2_name,
                        get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L2', 'MENU_ID')   menu_L2_id,
                        get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L3', 'MENU_NAME') menu_L3_name,
                        get_menu_info (coalesce(mi.menu_order_clone, mi.menu_order), 'L3', 'MENU_ID')   menu_L3_id
                      from menu_items mi
                      where mi.parent_id = rec2.menu_id
                        and mi.enabled   = 'Y'
                      order by mi.menu_id_order, mi.menu_id, mi.sub_menu_id, mi.sub_menu_level_id, mi.menu_order
                    )
                    loop
                      v_html := v_html ||
                        '<li class="node l3'||
                          case when rec3.menu_L3_id = p_sub_menu_l3_id then ' selected' end ||'">';

                      v_html := v_html ||
                        '<a href="#" onclick="handleMenuClick(event, '''||
                          jsq(strip_br(rec3.menu_mmain_name))||''', '''||
                          jsq(rec3.menu_main_id)||''', '''||
                          jsq(strip_br(rec3.menu_L1_name))||''', '''||
                          jsq(rec3.menu_L1_id)||''', '''||
                          jsq(strip_br(rec3.menu_L2_name))||''', '''||
                          jsq(rec3.menu_L2_id)||''', '''||
                          jsq(strip_br(rec3.menu_L3_name))||''', '''||
                          jsq(rec3.menu_L3_id)||''', '''||
                          jsq(rec3.product_type)||''', '''||
                          jsq(nv_website)||''', '''||
                          jsq(nvl(rec3.website_anchor, get_anchor_id('mnu', rec3.discipline_id, rec3.product_group_id, rec3.supplier_id, rec3.product_id, 'code')))||''', '''||
                          jsq(nv_business)||''', '''||
                          'L3'||''', '''||
                          jsq(safe_href(replace(replace(rec3.url, '&APP_ID.', p_app_id), '&APP_ALIAS.', p_app_alias)))||''')">'||
                          '<div class="rowish"><i class="'||jsq(nvl(rec3.icon_class,'fa fa-angle-right'))||'"></i><span class="label">'||
                            jsq(strip_br(rec3.sub_menu_name))||'</span></div></a>';

                      v_html := v_html || '</li>';
                    end loop;

                    v_html := v_html || '</ul>'; -- L3
                  end if;
                end;

                v_html := v_html || '</li>'; -- L2
              end loop;

              v_html := v_html || '</ul>'; -- L2 list
            end if;
          end;

          v_html := v_html || '</li>'; -- L1
        end loop;

        v_html := v_html || '</ul>'; -- L1 list (under this L0)
        v_html := v_html || '</li>'; -- L0
      end if;
    end;
  end loop;

  v_html := v_html || '</ul>'; -- root UL

  ---------------------------------------------------------------------------
  -- Styles
  ---------------------------------------------------------------------------
  v_html := v_html || '<style>
/* --- base + text colors (force dark text even if page theme sets links to white) --- */
.syn-sitemap{font-size:18px;line-height:1.45; color: var(--syntec-text, #1f2937);}
.syn-sitemap, 
.syn-sitemap a, 
.syn-sitemap .label, 
.syn-sitemap i { color: var(--syntec-text, #1f2937) !important; }

/* --- filter box --- */
.syn-sitemap .sitemap-toolbar{margin:8px 0 14px}
.syn-sitemap #sitemap-filter{
  width:100%;max-width:520px;padding:10px 12px;
  border:1px solid rgba(0,0,0,.15);border-radius:8px;font-size:16px
}

/* --- list layout + indentation --- */
.syn-sitemap ul.sitemap-ul{list-style:none;margin:0;padding:0}
.syn-sitemap li.node{margin:4px 0}
.syn-sitemap li.l0{margin:10px 0 6px}   /* tighter gaps between L0 items */
.syn-sitemap li.l1{margin-left:18px}
.syn-sitemap li.l2{margin-left:36px}
.syn-sitemap li.l3{margin-left:54px}

/* --- rows --- */
.syn-sitemap .rowish{
  display:flex;align-items:center;gap:10px;
  padding:8px 10px;border-radius:8px; text-decoration:none
}
.syn-sitemap a{text-decoration:none !important}
.syn-sitemap .rowish:hover .label{text-decoration:underline}

/* --- icon sizing/align --- */
.syn-sitemap .rowish i{width:1.25em;text-align:center;opacity:.95}

/* --- type scale per level --- */
.syn-sitemap li.l0 > a .rowish{font-weight:600;font-size:18px}
.syn-sitemap li.l1 > a .rowish{font-size:16px}
.syn-sitemap li.l2 > a .rowish{font-size:15px}
.syn-sitemap li.l3 > a .rowish{font-size:15px}

/* --- selected path highlight (mirrors main menu feel) --- */
.syn-sitemap li.selected > .rowish{
  outline:2px solid var(--syntec-accent, #4ba3ff);
  background: rgba(75,163,255,.08)
}

/* keep labels on one line but allow long names to elide */
.syn-sitemap a .label{white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:100%}
</style>';

  ---------------------------------------------------------------------------
  -- Filter script
  ---------------------------------------------------------------------------
  v_html := v_html || '<script>
(function(){
  var box = document.getElementById("sitemap-filter");
  if(!box) return;
  var root = box.closest(".syn-sitemap");
  var allLi = Array.prototype.slice.call(root.querySelectorAll("li.node"));
  function setVisible(li, vis){ li.style.display = vis ? "" : "none"; }
  function showAncestors(li){
    var p = li.parentElement;
    while(p && p.tagName==="UL"){
      p = p.parentElement;
      if(p && p.tagName==="LI"){ p.style.display=""; }
    }
  }
  function onFilter(){
    var q = box.value.trim().toLowerCase();
    if(!q){
      allLi.forEach(function(li){ li.style.display=""; });
      return;
    }
    allLi.forEach(function(li){ setVisible(li,false); });
    allLi.forEach(function(li){
      var txt = li.textContent.toLowerCase();
      if(txt.indexOf(q)!==-1){
        setVisible(li,true);
        showAncestors(li);
        Array.prototype.forEach.call(li.querySelectorAll("li.node"), function(c){ c.style.display=""; });
      }
    });
  }
  box.addEventListener("input", onFilter);
})();
</script>';

  v_html := v_html || '</div>'; -- .syn-sitemap

  return v_html;
end;


/
