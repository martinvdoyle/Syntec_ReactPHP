--------------------------------------------------------
--  DDL for Function GENERATE_FOOTER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."GENERATE_FOOTER" (p_app_id IN number,p_app_alias IN VARCHAR2,p_workspace_url IN VARCHAR)
RETURN CLOB IS
    v_footer_html CLOB := '';



BEGIN


    v_footer_html := '
		    	<!-- Footer start -->
				<footer id="footWrapper"class="footer-light" >
			    	<div class="footer-top main-bg">
			    		<div class="container-syn-banner">

			    				<div class="f-center  t-center "><span class="uppercase"><span class="dark-text bolder">Syntec Group</span> Supplier of Premium Scientific and Clinical Instruments, Products & Services to Irish and International Markets</span></div>

			    		</div>
			    	</div>
			    	<div class="footer-middle">
					    <div class="container-syn">
						    <div class="row">

						    	<!-- main menu footer cell start -->
							    <div class="col-md-3 first foot-text-widget ">
								    <div class="margin-bottom-30">
								    	<a href="'
                                        ||
                                        replace(replace('f?p=&APP_ALIAS.:3:::', '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias)||'" onclick="updateMenuItems(''Syntec Group'', ''1000'', '''','''','''','''','''','''','''',''Syntec Group'', '''', '''', ''L0'')"'         
                                        ||
                                        '"><img alt="" src="'||P_WORKSPACE_URL || 'assets/images/Syntec_Group_Logo_Small.png"></a>
								    </div>
								    <p >
								    	Supplier of Premium Scientific and Clinical Instruments, Products & Services to Irish and International Markets.<br><br>

								    	Syntec is committed to providing the very best service quality and customer support to our clients. Syntce is a ISO 13485 accredited company.
								    </p>
							    </div>
							    <!-- main menu footer cell start -->

								    	<!-- main menu footer cell start -->
							    <div class="col-md-3 first">
								    <h3>Quick Links</h3>
								    <ul class="menu-widget">
									    <li>
                                        <a href="'
                                        ||
                                        replace(replace('f?p=&APP_ALIAS.:1:::', '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias)||'" onclick="updateMenuItems(''Syntec Group'', ''1000'', '''','''','''','''','''','''','''',''Syntec Group'', '''', '''', ''L0'')"'         
                                        ||
                                        '">Home Page</a>
                                        </li>


									    <li>
                                        <a href="'
                                        ||
                                        replace(replace('f?p=&APP_ALIAS.:1:::', '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias)||'" onclick="updateMenuItems(''Syntec Group'', ''1000'', '''','''','''','''','''','''','''',''Syntec Group'', ''about_group'', '''', ''L0'')"'         
                                        ||
                                        '">About Us</a>
                                        </li>



									    <li>
                                        <a href="'
                                        ||
                                        replace(replace('f?p=&APP_ALIAS.:3:::', '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias)||'" onclick="updateMenuItems(''Syntec Group'', ''1000'', '''','''','''','''','''','''','''',''Syntec Group'', ''contact_us'', '''', ''L0'')"'         
                                        ||
                                        '">Contact Us</a>
                                        </li>


							    </div>
							    <!-- Our Friends footer cell start -->

							    <!-- Useful Links footer cell start -->
                                    <div class="col-md-3 last contact-widget">
                                        <h3>Divisions</h3>
                                        <ul class="details ">
                                            <li>
                                                <i class="fa fa-external-link shape"></i>
                                                <span>
                                                    <span >
                                                    <a href="'
                                                    ||
                                                    replace(replace('f?p=&APP_ALIAS.:10:::', '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias)||'" onclick="updateMenuItems(''Syntec Scientific'', ''4000'', '''','''','''','''','''','''','''',''Syntec Scientific'', ''main_menu'', ''Ireland'', ''L0'')"'           
                                                    ||
                                                    '">
                                                    <img src="'||P_WORKSPACE_URL || 'assets/images/Syntec_Scientific_Logo_Menu.png" alt="Syntec Scientific Logo"  />
                                                    </a>
                                                </span>
                                            </li>
                                            <li>
                                                <i class="fa fa-external-link shape"></i>
                                                <span>
                                                    <a href="'
                                                    ||
                                                    replace(replace('f?p=&APP_ALIAS.:20:::', '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias)||'" onclick="updateMenuItems(''Syntec International'', ''5000'', '''','''','''','''','''','''','''',''Syntec International'', ''main_menu'', ''International'', ''L0'')"'           
                                                    ||
                                                    '">                
                                                    <img src="'||P_WORKSPACE_URL || 'assets/images/Syntec_International_Logo_Menu.png" alt="Syntec International Logo"  />
                                                    </a>
                                                </span>
                                            </li>
                                            <li>
                                                <i class="fa fa-external-link shape"></i>
                                                <span>
                                                    <a href="'
                                                    ||
                                                    replace(replace('f?p=&APP_ALIAS.:30:::', '&APP_ID.', p_app_id),'&APP_ALIAS.',p_app_alias)||'" onclick="updateMenuItems(''SyS Laboratories'', ''6000'', '''','''','''','''','''','''','''',''SyS Laboratories'', ''main_menu'', ''Ireland'', ''L0'')"'           
                                                    ||
                                                    '">                
                                                    <img src="'||P_WORKSPACE_URL || 'assets/images/Syntec_SysLabs_Logo_Menu.png" alt="SyS Laboratories Logo" " />
                                                    </a>
                                                </span>
                                            </li>
                                        </ul>
                                    </div>


							    <div class="col-md-3 last contact-widget">
								    <h3>Contact Us</h3>

								    <ul class="details">

								    	<li><i class="fa fa-map-marker shape"></i><span><span class="heavy-font">Address: </span>Syntec,<br/>Unit 618 Northwest&nbsp;Logistics&nbsp;Park,<br/>Ballycoolin, Dublin&nbsp;15,<br/>D15PY00, Ireland</span></li>
								    	<li><i class="fa fa-envelope shape"></i><span><span class="heavy-font">Email: </span>info@syntec.ie</span></li>
								    	<li><i class="fa fa-phone shape"></i><span><span class="heavy-font">Tel: </span>+353 1 8612100</span></li>
								    	<li><i class="fa fa-fax shape"></i><span><span class="heavy-font">Fax: </span>+353 1 8612101</span></li>
								    </ul>
                                    <ul class="social-list-syn  padding-horizontal-45 ">
									    <li><a data-toggle="tooltip" data-placement="top" title="Facebook" href="https://www.facebook.com/SyntecGroup.ie/" target="_blank" class="fa fa-facebook shape sm">facebook</a></li>
									    <li><a data-toggle="tooltip" data-placement="top" title="Linkedin" href="https://www.linkedin.com/company/syntec-scientific/" target="_blank" class="fa fa-linkedin shape sm">linkedin</a></li>
									    <li><a data-toggle="tooltip" data-placement="top" title="Twitter" href="https://x.com/syntec_group" target="_blank" class="fa fa-twitter shape sm">twitter</a></li>

								    </ul>
							    </div>
							    <!-- Tags Cloud footer cell start -->

						    </div>
					    </div>
				    </div>

				    <!-- footer bottom bar start -->
				    <div class="footer-bottom">
					    <div class="container-syn ">
				    		<div class="row">
					    		<!-- footer copyrights left cell -->
					    		<div class="copyrights col-md-12 first ">COPYRIGHT ï¿½ 2022 <a href="#"><b class="main-color">SYNTEC GROUP</b></a> | <a href="javascript:void(0)" id="openPrivacyPolicy"><b class="main-color">PRIVACY POLICY</b></a> | <a href="javascript:void(0)"  id="openTermsPolicy"><b class="main-color">TERMS OF USE</b></a></div>







				    		</div>
					    </div>
				    </div>
				    <!-- footer bottom bar end -->

			    </footer>
		    	<!-- Footer end -->

	<!-- Back to top Link -->
	    <a id="to-top"><span class="fa fa-chevron-up shape main-bg"></span></a>




';

    RETURN v_footer_html;
END;


/
