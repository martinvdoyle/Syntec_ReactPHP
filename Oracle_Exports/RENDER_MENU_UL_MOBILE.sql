--------------------------------------------------------
--  DDL for Function RENDER_MENU_UL_MOBILE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."RENDER_MENU_UL_MOBILE" (
  p_app_id           in number,
  p_app_alias        in varchar2,
  p_workspace_url    in varchar2,
  p_business         in varchar2,
  p_website          in varchar2,
  p_main_menu        in varchar2,
  p_main_menu_id     in varchar2,
  p_sub_menu_l1_id   in varchar2,
  p_sub_menu_l2_id   in varchar2,
  p_sub_menu_l3_id   in varchar2
) return clob is
begin
  return generate_menu_nav_ul_li(
           p_app_id, p_app_alias, p_workspace_url,
           p_business, p_website,
           p_main_menu, p_main_menu_id,
           p_sub_menu_l1_id, p_sub_menu_l2_id, p_sub_menu_l3_id,
           'MOBILE'
         );
end;


/
