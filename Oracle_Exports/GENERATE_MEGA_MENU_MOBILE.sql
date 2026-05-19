--------------------------------------------------------
--  DDL for Function GENERATE_MEGA_MENU_MOBILE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."GENERATE_MEGA_MENU_MOBILE" (
  p_app_id         IN number,
  p_app_alias      IN VARCHAR2,
  p_workspace_url  IN VARCHAR2,
  p_business       IN varchar2,
  p_website        IN varchar2
) RETURN CLOB IS
  v_html     CLOB := '';
  v_business varchar2(50);
BEGIN
  v_business := COALESCE(p_business,'Ireland');

  v_html := '
<!-- MOBILE HEADER (top bar + logo bar; UT sticky) -->
<div id="MOBILE_HEADER" class="mbl-header-wrap">
  <div class="mbl-top-bar">
    <div class="mbl-top-bar__left info_syntec">
      <a href="mailto:info@syntec.ie"><i class="fa fa-envelope"></i> info@syntec.ie</a>
    </div>
    <div class="mbl-top-bar__right">
      <a href="tel:+35318612100"><i class="fa fa-phone"></i> (+353)-1-8612100</a>
    </div>
  </div>

  <!-- IMPORTANT: use UT sticky header classes/attribute -->
  <header class="top-head header-9 sticky-nav" data-sticky="true">
    <div class="mbl-container">
      <div class="mbl-logo">
        <a href="'||
          CASE p_website
            WHEN 'Syntec Group'         THEN syntec_page_url(1,  1)
            WHEN 'Syntec Scientific'    THEN syntec_page_url(10, 1)
            WHEN 'Syntec International' THEN syntec_page_url(20, 1)
            WHEN 'SyS Laboratories'     THEN syntec_page_url(6,  1)
            ELSE                             syntec_page_url(1,  1)
          END || '">
          <img alt="'||p_website||'" src="'||
            CASE p_website
              WHEN 'Syntec Group'         THEN p_workspace_url||'assets/images/Syntec_Group_Logo_Menu.png'
              WHEN 'Syntec Scientific'    THEN p_workspace_url||'assets/images/Syntec_Scientific_Logo_Menu.png'
              WHEN 'Syntec International' THEN p_workspace_url||'assets/images/Syntec_International_Logo_Menu.png'
              WHEN 'SyS Laboratories'     THEN p_workspace_url||'assets/images/Syntec_SysLabs_Logo_Menu.png'
              ELSE p_workspace_url||'assets/images/Syntec_Group_Logo_Menu.png'
            END || '" />
        </a>
      </div>

      <!-- Burger lives in its own region; nothing inline here -->
    </div>
  </header>
</div>';

  RETURN v_html;
END;

/
