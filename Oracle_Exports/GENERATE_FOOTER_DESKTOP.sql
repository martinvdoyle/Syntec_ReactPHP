--------------------------------------------------------
--  DDL for Function GENERATE_FOOTER_DESKTOP
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."GENERATE_FOOTER_DESKTOP" 
(
    p_app_id        IN number,
    p_app_alias     IN varchar2,
    p_workspace_url IN varchar
)
RETURN CLOB
IS
    v_footer_html CLOB := '';
BEGIN

    v_footer_html := '
        <!-- Footer start -->
        <footer id="footWrapper" class="footer-light">
            <div class="footer-top main-bg">
                <div class="container-syn-banner">
                    <div class="f-center t-center">
                        <span class="uppercase bold">
                            <span class="dark-text bold">Syntec Group</span>
                            Supplier of Premium Scientific and Clinical Instruments, Products & Services to Irish and International Markets
                        </span>
                    </div>
                </div>
            </div>

            <div class="footer-middle">
                <div class="container-syn">
                    <div class="row">

                        <!-- Logo -->
                        <div class="col-md-3 first foot-text-widget">
                            <div class="margin-bottom-30">
                                <a href="'|| syntec_page_url(3,1) ||'"
                                   onclick="updateMenuItems(''Syntec Group'',''1000'','''','''','''','''','''','''','''',''Syntec Group'','''','''',''L0'')">
                                    <img alt="" src="'||p_workspace_url||'assets/images/Syntec_Group_Logo_Small.png">
                                </a>
                            </div>
                            <p>
                                Supplier of Premium Scientific and Clinical Instruments, Products & Services to Irish and International Markets.<br><br>
                                Syntec is committed to providing the very best service quality and customer support to our clients.
                                Syntec is an ISO 13485 accredited company.
                            </p>
                        </div>

                        <!-- Quick Links -->
                        <div class="col-md-3 first">
                            <h3>Quick Links</h3>
                            <ul class="menu-widget">
                                <li>
                                    <a href="'|| syntec_page_url(1,1) ||'"
                                       onclick="updateMenuItems(''Syntec Group'',''1000'','''','''','''','''','''','''','''',''Syntec Group'','''','''',''L0'')">
                                        Home Page
                                    </a>
                                </li>

                                <li>
                                    <a href="'|| syntec_page_url(1,1) ||'"
                                       onclick="updateMenuItems(''Syntec Group'',''1000'','''','''','''','''','''','''','''',''Syntec Group'',''about_group'','''',''L0'')">
                                        About Us
                                    </a>
                                </li>

                                <li>
                                    <a href="'|| syntec_page_url(3,1) ||'"
                                       onclick="updateMenuItems(''Syntec Group'',''1000'','''','''','''','''','''','''','''',''Syntec Group'',''contact_us'','''',''L0'')">
                                        Contact Us
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <!-- Divisions -->
                        <div class="col-md-3 last contact-widget">
                            <h3>Divisions</h3>
                            <ul class="details">
                                <li>
                                    <a href="'|| syntec_page_url(10,1) ||'"
                                       onclick="updateMenuItems(''Syntec Scientific'',''4000'','''','''','''','''','''','''','''',''Syntec Scientific'',''main_menu'',''Ireland'',''L0'')">
                                        <img src="'||p_workspace_url||'assets/images/Syntec_Scientific_Logo_Menu.png">
                                    </a>
                                </li>

                                <li>
                                    <a href="'|| syntec_page_url(20,1) ||'"
                                       onclick="updateMenuItems(''Syntec International'',''5000'','''','''','''','''','''','''','''',''Syntec International'',''main_menu'',''International'',''L0'')">
                                        <img src="'||p_workspace_url||'assets/images/Syntec_International_Logo_Menu.png">
                                    </a>
                                </li>

                                <li>
                                    <a href="'|| syntec_page_url(6,1) ||'"
                                       onclick="updateMenuItems(''SyS Laboratories'',''6000'','''','''','''','''','''','''','''',''SyS Laboratories'',''main_menu'',''Ireland'',''L0'')">
                                        <img src="'||p_workspace_url||'assets/images/Syntec_SysLabs_Logo_Menu.png">
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <!-- Contact -->
                        <div class="col-md-3 last contact-widget">
                            <h3>Contact Us</h3>
                            <ul class="details">
                                <li><i class="fa fa-map-marker shape"></i>Syntec, Unit 618 Northwest Logistics Park, Ballycoolin, Dublin 15</li>
                                <li><i class="fa fa-envelope shape"></i>info@syntec.ie</li>
                                <li><i class="fa fa-phone shape"></i>+353 1 8612100</li>
                                <li><i class="fa fa-fax shape"></i>+353 1 8612101</li>
                            </ul>
                        </div>

                    </div>
                </div>
            </div>

            <div class="footer-bottom">
                <div class="container-syn">
                    <div class="copyrights">
                        COPYRIGHTÂ© 2022 <b class="main-color">SYNTEC GROUP</b>
                    </div>
                </div>
            </div>
        </footer>
        <!-- Footer end -->
    ';

    RETURN v_footer_html;
END;

/
