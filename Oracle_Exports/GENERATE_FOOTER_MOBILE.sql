--------------------------------------------------------
--  DDL for Function GENERATE_FOOTER_MOBILE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."GENERATE_FOOTER_MOBILE" (
    p_app_id        IN number,
    p_app_alias     IN VARCHAR2,
    p_workspace_url IN VARCHAR2
) RETURN CLOB IS
    v_footer_html CLOB := '';
BEGIN
    v_footer_html :=
    q'~<footer id="footWrapper" class="footer-light">
        <!-- Scoped fix: disable UT heading decoration just for this footer -->
        <style>
          #footWrapper .no-heading-dec:before,
          #footWrapper .no-heading-dec:after { display: none !important; }
        </style>

        <div class="footer-top main-bg">
            <div class="container-syn-banner">
                <div class="f-center t-center">
                    <span class="uppercase bold">
                        <span class="dark-text bold">Syntec Group</span>
                        Supplier of Premium Scientific and Clinical Instruments, Products &amp; Services to Irish and International Markets
                    </span>
                </div>
            </div>
        </div>

        <div class="footer-middle">
            <div class="container-syn">
                <div class="row">

                    <!-- Brand + short blurb -->
                    <div class="col-md-12 first foot-text-widget">
                        <div class="margin-bottom-20 t-center" style="padding-top:15px;">
                            <a href="~' || syntec_page_url(3, 1) || q'~"
                               onclick="updateMenuItems('Syntec Group','1000','','','','','','','','Syntec Group','','','L0')">
                                <img alt="Syntec Group" src="~' || p_workspace_url || q'~assets/images/Syntec_Group_Logo_Small.png">
                            </a>
                        </div>

                        <p class="t-center" style="margin:0 10px 15px;">
                            Supplier of Premium Scientific and Clinical Instruments, Products &amp; Services to Irish and International Markets.
                            <br><br>
                            Syntec is committed to providing the very best service quality and customer support to our clients.
                            Syntec is an ISO 13485 accredited company.
                        </p>
                    </div>

                    <!-- Contact -->
                    <div class="col-md-12 last contact-widget t-center">
                        <h3 class="t-center no-heading-dec"
                            style="display:inline-block; border-bottom:2px solid #000; padding-bottom:4px; margin-bottom:15px;">
                            Contact Us
                        </h3>

                        <ul class="details" style="display:inline-block; text-align:left; max-width:480px; margin:0 auto;">
                            <li>
                                <i class="fa fa-map-marker shape"></i>
                                <span>
                                    <span class="heavy-font">Address: </span>
                                    Syntec,<br/>Unit 618 Northwest&nbsp;Logistics&nbsp;Park,<br/>
                                    Ballycoolin, Dublin&nbsp;15,<br/>D15PY00, Ireland
                                </span>
                            </li>
                            <li>
                                <i class="fa fa-envelope shape"></i>
                                <span><span class="heavy-font">Email: </span>info@syntec.ie</span>
                            </li>
                            <li>
                                <i class="fa fa-phone shape"></i>
                                <span><span class="heavy-font">Tel: </span>+353 1 8612100</span>
                            </li>
                            <li>
                                <i class="fa fa-fax shape"></i>
                                <span><span class="heavy-font">Fax: </span>+353 1 8612101</span>
                            </li>
                        </ul>

                        <!-- Centered social icons -->
                        <ul class="social-list-syn"
                            style="margin-top:15px; display:inline-flex; justify-content:center; gap:12px; list-style:none; padding:0;">
                            <li><a data-toggle="tooltip" data-placement="top" title="Facebook"
                                   href="https://www.facebook.com/SyntecGroup.ie/" target="_blank"
                                   class="fa fa-facebook shape sm">facebook</a></li>
                            <li><a data-toggle="tooltip" data-placement="top" title="LinkedIn"
                                   href="https://www.linkedin.com/company/syntec-scientific/" target="_blank"
                                   class="fa fa-linkedin shape sm">linkedin</a></li>
                            <li><a data-toggle="tooltip" data-placement="top" title="Twitter/X"
                                   href="https://x.com/syntec_group" target="_blank"
                                   class="fa fa-twitter shape sm">twitter</a></li>
                        </ul>
                    </div>

                </div>
            </div>
        </div>

        <!-- Bottom bar -->
        <div class="footer-bottom">
            <div class="container-syn">
                <div class="row">
                    <div class="copyrights first t-center">
                      COPYRIGHTÂ© 2022
                      <a href="'|| syntec_page_url(1, 1) ||'"
                         onclick="handleMenuClick(event, 'Syntec Group', '1000', '','','','','','','','Syntec Group', 'main_menu', '', 'L0')">
                         <b class="main-color">SYNTEC GROUP</b>
                      </a>
                      | <a href="javascript:void(0)" id="openPrivacyPolicy"><b class="main-color">PRIVACY POLICY</b></a>
                      | <a href="javascript:void(0)" id="openTermsPolicy"><b class="main-color">TERMS OF USE</b></a>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <!-- Back to top -->
    <a id="to-top"><span class="fa fa-chevron-up shape main-bg"></span></a>~';

    RETURN v_footer_html;
END;

/
