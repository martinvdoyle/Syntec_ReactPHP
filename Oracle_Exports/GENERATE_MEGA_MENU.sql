--------------------------------------------------------
--  DDL for Function GENERATE_MEGA_MENU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."GENERATE_MEGA_MENU" (p_app_id IN number,p_app_alias IN VARCHAR2,p_workspace_url IN VARCHAR2,p_business IN varchar2,
p_website IN varchar2,p_main_menu  IN varchar, p_main_menu_id IN varchar, p_sub_menu_l1_id IN varchar, p_sub_menu_l2_id IN varchar, p_sub_menu_l3_id IN varchar,p_device_type IN varchar)
RETURN CLOB IS
    v_menu_html CLOB := '';
    v_business varchar2(50);



BEGIN
    -- Start the HTML output with the top bar and header

IF p_business is null
        then v_business := 'Ireland';
ELSE        
        v_business := p_business;
end if;

    v_menu_html := '
        <!-- Top Bar Start -->
    <div class="top-bar header-light">
        <div class="container-syn">
            <ul class="f-left">
                <li><a href="#" class="shape info_syntec">
  <i class="fa fa-envelope"></i>info@syntec.ie
</a></li>
                <li><span><i class="fa fa-phone"></i>(+353)-1-8612100</span></li>
            </ul>
            <ul class="mobile-hide">
                <li class="dropdown"><a href="#" class="shape" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" id="cert-bx"><i class="fa fa-certificate"></i>ISO certificates</a>
                    <div class="dropdown-menu white-bg" style="z-index: 9999;">
                        <div class="center-tbl  padding-top-20  padding-bottom-20">
                            <a href="'||p_workspace_url || 'assets/PDFs/Syntec_Scientific_ISO_9001_2015.pdf" target="_blank"><img alt="" src="'||p_workspace_url || 'assets/images/ISO_9001_2015_Official.png"  width="130px" /></a>
                        </div>
                        <div class="center-tbl  padding-bottom-30">
                            <a href="'||p_workspace_url || 'assets/PDFs/Syntec_Scientific_ISO_133485_2016.pdf" target="_blank"><img alt="" src="'||p_workspace_url || 'assets/images/ISO_13485_2016_Official.png"  width="130px"/></a>
                        </div>

                    </div>



                </li>
                <li><a class="shape" href="sitemap.html"><i class="fa fa-sitemap"></i> Site map</a></li>
            </ul>
            <ul class="social-list-syn f-right alter-gry shape mobile-hide">
                <li><a href="https://www.facebook.com/SyntecGroup.ie/" target="_blank" class="fa fa-facebook" data-tooltip="true" data-title="facebook" data-position="bottom"></a></li>
                <li><a href="https://www.linkedin.com/company/syntec-scientific/" target="_blank" class="fa fa-linkedin" data-tooltip="true" data-title="linkedin" data-position="bottom"></a></li>
                <li><a href="https://x.com/syntec_group" target="_blank" class="fa fa-twitter" data-tooltip="true" data-title="twitter" data-position="bottom"></a></li>
            </ul>
        </div>
    </div>
    <!-- Top Bar End -->
<header class="top-head header-9 sticky-nav" data-sticky="true">


    <div class=" nav-container-syn">
        <!-- Logo (Left-aligned) -->
        <div id="logo-mainmenu" class="logo fx animated fadeInLeft desktop-hide" data-animate="fadeInLeft">
            <a href="'
              || CASE p_website
                WHEN 'Syntec Group' THEN  replace(replace('f?p=&APP_ALIAS.:1:::', '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias)||'" onclick="updateMenuItems(''Syntec Group'', ''1000'', '''','''','''','''','''','''','''',''Syntec Group'', ''main_menu'', '''', ''L0'')"'
                ||'><img alt="'||p_website||'" src="'||p_workspace_url || 'assets/images/Syntec_Group_Logo_Menu.png" ></a>'
                WHEN 'Syntec Scientific' THEN  replace(replace('f?p=&APP_ALIAS.:10:::', '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias)||'" onclick="updateMenuItems(''Syntec Scientific'', ''4000'', '''','''','''','''','''','''','''',''Syntec Scientific'', ''main_menu'', ''Ireland'', ''L0'')"'
                ||'><img alt="'||p_website||'" src="'||p_workspace_url || 'assets/images/Syntec_Scientific_Logo_Menu.png" ></a>'
                WHEN 'Syntec International' THEN  replace(replace('f?p=&APP_ALIAS.:20:::', '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias)||'" onclick="updateMenuItems(''Syntec International'', ''5000'', '''','''','''','''','''','''','''',''Syntec International'', ''main_menu'', ''International'', ''L0'')"'
                ||'><img alt="'||p_website||'" src="'||p_workspace_url || 'assets/images/Syntec_International_Logo_Menu.png"   ></a>'
                WHEN 'SyS Laboratories' THEN  replace(replace('f?p=&APP_ALIAS.:6:::', '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias)||'" onclick="updateMenuItems(''SyS Laboratories'', ''6000'', '''','''','''','''','''','''','''',''SyS Laboratories'', ''main_menu'', ''Ireland'', ''L0'')"'
                ||'><img alt="'||p_website||'" src="'||p_workspace_url || 'assets/images/Syntec_SysLabs_Logo_Menu.png" ></a>'
                ELSE replace(replace('f?p=&APP_ALIAS.:1:::', '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias)||'" onclick="updateMenuItems(''Syntec Group'', ''1000'', '''','''','''','''','''','''','''',''Syntec Group'', ''main_menu'', '''', ''L0'')"'
                ||'><img alt="'||p_website||'" src="'||p_workspace_url || 'assets/images/Syntec_Group_Logo_Menu.png" ></a>'
            END 
            ||'        </div> 


        <!-- Desktop Menu -->
        <nav class="menu-wrapper-syn">




	<div class="container-syn-mainmenu">

        <div id="logo-mainmenu" class="logo fx animated fadeInLeft" data-animate="fadeInLeft">
            <a href="'
              || CASE p_website
                WHEN 'Syntec Group' THEN  replace(replace('f?p=&APP_ALIAS.:1:::', '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias)||'" onclick="updateMenuItems(''Syntec Group'', ''1000'', '''','''','''','''','''','''','''',''Syntec Group'', ''main_menu'', '''', ''L0'')"'
                ||'><img alt="'||p_website||'" src="'||p_workspace_url || 'assets/images/Syntec_Group_Logo_Menu.png" ></a>'
                WHEN 'Syntec Scientific' THEN  replace(replace('f?p=&APP_ALIAS.:10:::', '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias)||'" onclick="updateMenuItems(''Syntec Scientific'', ''4000'', '''','''','''','''','''','''','''',''Syntec Scientific'', ''main_menu'', ''Ireland'', ''L0'')"'
                ||'><img alt="'||p_website||'" src="'||p_workspace_url || 'assets/images/Syntec_Scientific_Logo_Menu.png" ></a>'
                WHEN 'Syntec International' THEN  replace(replace('f?p=&APP_ALIAS.:20:::', '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias)||'" onclick="updateMenuItems(''Syntec International'', ''5000'', '''','''','''','''','''','''','''',''Syntec International'', ''main_menu'', ''International'', ''L0'')"'
                ||'><img alt="'||p_website||'" src="'||p_workspace_url || 'assets/images/Syntec_International_Logo_Menu.png"   ></a>'
                WHEN 'SyS Laboratories' THEN  replace(replace('f?p=&APP_ALIAS.:6:::', '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias)||'" onclick="updateMenuItems(''SyS Laboratories'', ''6000'', '''','''','''','''','''','''','''',''SyS Laboratories'', ''main_menu'', ''Ireland'', ''L0'')"'
                ||'><img alt="'||p_website||'" src="'||p_workspace_url || 'assets/images/Syntec_SysLabs_Logo_Menu.png" ></a>'
                ELSE replace(replace('f?p=&APP_ALIAS.:1:::', '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias)||'" onclick="updateMenuItems(''Syntec Group'', ''1000'', '''','''','''','''','''','''','''',''Syntec Group'', ''main_menu'', '''', ''L0'')"'
                ||'><img alt="'||p_website||'" src="'||p_workspace_url || 'assets/images/Syntec_Group_Logo_Menu.png" ></a>'
            END 
            ||'
        </div> 

		<div id="main_menu" class="main-menu-container-mainmenu">
        			<nav class=" top-nav nav-animate to-bottom ">'||

                            web.generate_menu_nav_ul_li (p_app_id,p_app_alias,p_workspace_url,v_business,p_website,p_main_menu, p_main_menu_id, p_sub_menu_l1_id, p_sub_menu_l2_id, p_sub_menu_l3_id ,p_device_type)                  


                   ||' </nav>
		</div>
	</div>





			<!-- top navigation menu start -->

                <div id="Business"  class="business-container-mainmenu">

                        <!-- Business Dropdown -->
                        <div class="language-container padding-horizontal-10 ">
                            <div class="dropdown">
                                <select id="businessSelect" style="width: 140px;" onchange="updateBusinessValue(this.value, '''||p_app_alias||''')">
                                    <option value="Group">Syntec Group</option>
                                    <option value="Ireland">Ireland</option>
                                    <option value="International">International</option>
                                </select>
                            </div>
                        </div>



                        <!-- Language Dropdown -->
                      <div class="language-container  ">
                            <div class="dropdown">
                                <button class="dropbtn" id="flagButton" title="English">
                                    <img id="flagImage" src="https://flagcdn.com/w20/gb.png" alt="English" class="flag-circle" />
                                </button>
                                <div class="dropdown-content">
                                    <a href="#" onclick="FlagchangeLanguage(''ie'', ''https://flagcdn.com/w20/gb.png'', ''English'')">
                                        <img src="https://flagcdn.com/w20/ie.png" alt="English" class="flag-circle" /> English (ie)
                                    </a>
                                    <a href="#" onclick="FlagchangeLanguage(''en'', ''https://flagcdn.com/w20/gb.png'', ''English'')">
                                        <img src="https://flagcdn.com/w20/gb.png" alt="English" class="flag-circle" /> English
                                    </a>
                                    <a href="#" onclick="FlagchangeLanguage(''fr'', ''https://flagcdn.com/w20/fr.png'', ''French'')">
                                        <img src="https://flagcdn.com/w20/fr.png" alt="French" class="flag-circle" /> French
                                    </a>
                                    <a href="#" onclick="FlagchangeLanguage(''es'', ''https://flagcdn.com/w20/es.png'', ''Spanish'')">
                                        <img src="https://flagcdn.com/w20/es.png" alt="Spanish" class="flag-circle" /> Spanish
                                    </a>
                                </div>
                            </div>
                        </div>

                </div>            



        </nav>


<!-- Mobile Navigation Menu (new-nav-syn) -->
        <div class="responsive-nav">


                        <nav class="new-nav-syn top-nav nav-animate to-bottom">'||

                            web.generate_menu_nav_ul_li (p_app_id,p_app_alias,p_workspace_url,v_business,p_website,p_main_menu, p_main_menu_id, p_sub_menu_l1_id, p_sub_menu_l2_id, p_sub_menu_l3_id,p_device_type)                  


                   ||'</nav>
        </div>
</div>
</header>



';

    RETURN v_menu_html;
END;

/
