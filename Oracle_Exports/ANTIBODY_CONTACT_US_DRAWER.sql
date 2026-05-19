--------------------------------------------------------
--  DDL for Function ANTIBODY_CONTACT_US_DRAWER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."ANTIBODY_CONTACT_US_DRAWER" 
(p_device_type IN VARCHAR2, p_workspace_url IN VARCHAR2, p_app_id IN number, p_app_alias IN VARCHAR2, p_website IN VARCHAR2, p_product_id IN VARCHAR2)

RETURN CLOB IS


v_grid_html CLOB := '';



v_anchor_id         varchar2(200);  

v_PRODUCT_TYPE  varchar2(100);


   CURSOR c_product IS
                     SELECT 
                        PRODUCT_ID,
                        PRODUCT_NAME,
                        PRODUCT_TYPE,
                        PRODUCT_IMAGE_LARGE,
                        DISCIPLINE,
                        DISCIPLINE_ID,
                        PRODUCT_GROUP,
                        PRODUCT_GROUP_ID,
                        PRODUCT_GROUP_TYPE_ALT, 
                        PRODUCT_GROUP_TYPE_ALT_ID,
                        SUPPLIER_NAME,
                        SUPPLIER_ID ,
                        SUPPLIER_LOGO_LARGE, 
                        SUPPLIER_LOGO_SMALL,
                        SUPPLIER_LOGO_LARGE_SCALE_SMALLER,
                        ROLLOVER_COLOUR,
                        PRODUCT_TYPE_ID,
                        PRODUCT_TYPE_NAME,
                        PRODUCT_ABOUT,
                        ANCHOR_ID,
                        PRODUCT_ENQUIRE,
                        PRODUCT_GROUP_ALT,
                        PRODUCT_GROUP_ALT_ID,
                        PRODUCT_IMAGE_LARGE_WIDTH, 
                        PRODUCT_IMAGE_LARGE_HEIGHT,
                        PRODUCT_LINK                       

                        FROM (
                        SELECT
                        a.ID PRODUCT_ID,
                        a.ANTIBODY_NAME PRODUCT_NAME,
                        p.PRODUCT_TYPE,
                        a.IMAGE_URL PRODUCT_IMAGE_LARGE,
                        p.DISCIPLINE,
                        d.DISCIPLINE_ID,
                        pg.PRODUCT_GROUP_NAME PRODUCT_GROUP,
                        p.PRODUCT_GROUP_ID,
                        p.PRODUCT_GROUP_TYPE_ALT_ID, 
                        pga.PRODUCT_GROUP_NAME PRODUCT_GROUP_TYPE_ALT,
                        s.SUPPLIER_ID,
                        s.SUPPLIER_NAME,
                        s.SUPPLIER_LOGO_LARGE, 
                        s.SUPPLIER_LOGO_SMALL,
                        s.CLASS_COLOUR ROLLOVER_COLOUR,
                        SUPPLIER_LOGO_LARGE_SCALE_SMALLER,
                        t.PRODUCT_TYPE_ID,
                        t.PRODUCT_TYPE_NAME,
                        PRODUCT_LINK,
                        REPLACE(
                                    REPLACE(
                                        REPLACE(ABOUT_1, '#WORKSPACE_FILES#', p_workspace_url),
                                        '&APP_ID.', p_app_id
                                    ),
                                    '&APP_ALIAS.', p_app_alias
                                ) AS PRODUCT_ABOUT,
                        GET_ANCHOR_ID ('sup',p.DISCIPLINE_ID,p.PRODUCT_GROUP_ID,p.SUPPLIER_ID,p.PRODUCT_ID,'code')  ANCHOR_ID, 
                        decode(pga.PRODUCT_GROUP_ID,null,null,pga.PRODUCT_GROUP_NAME) PRODUCT_GROUP_ALT,
                        decode(pga.PRODUCT_GROUP_ID,null,null,pga.PRODUCT_GROUP_ID) PRODUCT_GROUP_ALT_ID,
                        PRODUCT_ENQUIRE,
                        PRODUCT_IMAGE_LARGE_WIDTH, 
                        PRODUCT_IMAGE_LARGE_HEIGHT

                            FROM 
                                SUPPLIERS s,
                                PRODUCTS p,
                                PRODUCT_TYPE t,
                                PRODUCT_GROUP pg,
                                PRODUCT_GROUP pga,
                                DISCIPLINE d,
                                ANTIBODIES a
                            WHERE 
                                p.SUPPLIER_ID = s.SUPPLIER_ID
                                AND s.DELETED = 'N'
                                AND s.ACTIVE = 'Y'
                                and p.PRODUCT_GROUP_ID = pg.PRODUCT_GROUP_ID
                                and p.PRODUCT_GROUP_TYPE_ALT_ID = pga.PRODUCT_GROUP_ID(+)
                                and p.PRODUCT_TYPE_ID = t.PRODUCT_TYPE_ID
                                AND p.DELETED = 'N'
                                AND p.ACTIVE = 'Y'
                                AND pg.DELETED = 'N'
                                AND pg.ACTIVE = 'Y'
                                AND d.DISCIPLINE_ID = p.DISCIPLINE_ID
                                AND p.PRODUCT_ID  = 'PRD-0001'
                                AND a.ID = p_product_id );





            c_product_rec       c_product%ROWTYPE;  -- Define a record variable based on the cursor

BEGIN
    OPEN c_product;
    FETCH c_product INTO c_product_rec;

     v_grid_html := v_grid_html ||'<div class="col-md-12 t-center "><span class="block">'||

                CASE p_website
                WHEN 'Syntec Group' 	  		THEN  '<img class="fx animated swing"  alt="'||p_website||'" src="'||p_workspace_url || 'assets/images/Syntec_Group_Logo_Menu.png" >'
                WHEN 'Syntec Scientific' 		THEN  '<img class="fx animated swing"  alt="'||p_website||'" src="'||p_workspace_url || 'assets/images/Syntec_Scientific_Logo_Menu.png" >'
                WHEN 'Syntec International' 	THEN  '<img class="fx animated swing"  alt="'||p_website||'" src="'||p_workspace_url || 'assets/images/Syntec_International_Logo_Menu.png"   >'
                WHEN 'SyS Laboratories' 		THEN  '<img  class="fx animated swing" alt="'||p_website||'" src="'||p_workspace_url || 'assets/images/Syntec_SysLabs_Logo_Menu.png" >'
                ELSE  '<img class="fx animated swing" alt="'||p_website||'" src="'||p_workspace_url || 'assets/images/Syntec_Group_Logo_Menu.png" >'
            END 
            ||' </span></div>';  

    v_grid_html := v_grid_html || '<div class="padding-top-30 heading centered">
                            <i class="fa fa-envelope tbl main-color"  style="font-size: 30px;"></i>
                            <h3 class="uppercase head-4 bold">Message Us</h3>

                        </div>';



    IF p_device_type = 'DESKTOP' THEN
        v_grid_html := v_grid_html || 
        '<div id="'|| c_product_rec.ANCHOR_ID || '" class="centered">';


         IF p_product_id is not null
            then
                 v_grid_html := v_grid_html ||'<div class="centered-image"><img class="fx animated fadeInLeft" alt="" src="' ||  c_product_rec.PRODUCT_IMAGE_LARGE || '" ' ||
                    'style="margin-bottom:30px; ' ||
                    ' height: 200px;' 
                    || '"/></div>' ||
                    '<div class="centered-image "><img class="fx animated fadeInLeft " data-animate="fadeInLeft" alt="" src="' || p_workspace_url  || 'assets/images/Scientific/suppliers/'||c_product_rec.SUPPLIER_LOGO_LARGE||'" style="margin-bottom:30px; width:150px; '||
                        ' ">  ' ||                  
                '</div>';
            else null;
        END IF;

v_grid_html := v_grid_html || 
    '<div id="contactus-spinner" style="display:none;   margin-bottom:30px; font-size:24px; text-align:center;">' ||
        '<i class="fa fa-spinner fa-spin"></i> Sending...' ||
    '</div>';

         IF p_product_id is not null
            then
                 v_grid_html := v_grid_html || '<div class="heading main-heading centered padding-top-10">' ||
                    '<h4 class="sub-title1">' || 
                     CASE 
                        WHEN c_product_rec.PRODUCT_GROUP_ALT IS NOT NULL 
                        THEN c_product_rec.PRODUCT_GROUP_ALT ||'<span class="main-color"> - ' || c_product_rec.PRODUCT_GROUP
                        ELSE c_product_rec.PRODUCT_TYPE ||'<span class="main-color"> - ' || c_product_rec.PRODUCT_GROUP
                    END||
                     '</span></h4>' ||
                    '<div class="heading-separator"><span class="main-bg"></span><span class="dark-bg"></span></div>' ||
                '</div>';               


             v_grid_html := v_grid_html || '<div >
                        <div id="specs" style="flex: 1; min-width: 250px;">
                                      <div class="heading side-head">
                                        <div class="head-8">
                                          <h4 class="heavy-font">'||c_product_rec.PRODUCT_NAME||'</h4>
                                        </div>
                                      </div>
                                    </div>';

            else null;
        END IF;



 v_grid_html := v_grid_html ||'
<div id="contact" class="syn-scope contact_us_prod_container">

    <!-- Success message -->
    <div id="custom-success-message-drawer"
     class="contact_us_prod_success_message margin-bottom-50 fancy-success-message"
     style="display:none; position:relative;"
     role="status" aria-live="polite">

      <button type="button"
              class="success-close btn btn-sm"
              style="position:absolute; top:10px; right:10px; line-height:1; padding:6px 10px;"
              aria-label="Close success message">ï¿½</button>
        <i class="fa fa-thumbs-up success-icon pulse"></i>
        <p class="congrats main-color success-title">Thank You!</p>
        <p class="congratsTxt success-subtitle">Your message was sent. We''ll get back to you soon.</p>
    </div>

    <!-- Contact form -->
    <div class="form-signin cform contact_us_prod_form" id="drawerContactForm">

        <div class="contact_us_prod_input_group">
            <input type="text" class="form-control shape" id="name" placeholder="Your Name">
            <div id="name-error" class="input-error-message"></div>
        </div>

        <div class="contact_us_prod_input_group">
            <input type="text" class="form-control shape" id="organisation" placeholder="Organisation">
            <div id="organisation-error" class="input-error-message"></div>
        </div>

        <div class="contact_us_prod_input_group">
            <input type="email" class="form-control shape" id="email" placeholder="Email Address">
            <div id="email-error" class="input-error-message"></div>
        </div>

        <div class="contact_us_prod_input_group">
            <input type="text" class="form-control shape" id="phone" placeholder="Phone Number">
            <div id="phone-error" class="input-error-message"></div>
        </div>

        <div class="contact_us_prod_input_group">
            <input type="text" class="form-control shape" id="subject" placeholder="Subject">
            <div id="subject-error" class="input-error-message"></div>
        </div>

        <div class="contact_us_prod_input_group ">
            <select id="enquiryTypeDrawer" class="form-control shape new-angle contact_dropdown enquiryType" required>
                <option value="" disabled selected>-- Select Enquiry Type --</option>
            </select>
             <div class="input-error-message enquiryType-error"></div>
        </div>

        <div class="contact_us_prod_input_group">
            <textarea class="form-control shape" id="cnt_messageTxt" cols="40" rows="7" placeholder="Your Message"></textarea>
            <div id="message-error" class="input-error-message"></div>
        </div>

<!-- ? Drawer reCAPTCHA -->
<div id="recaptcha-drawer" class="g-recaptcha"
     data-sitekey="6LfK9IwrAAAAAN5gg5PX3W0AmvKx1Xj7BZm1Sl0E"
     data-callback="onCaptchaSuccess"
     data-expired-callback="onCaptchaExpired">
</div>

<div id="recaptcha-error-drawer" class="input-error-message" style="display: none;"></div>



<!-- Send Button -->
<div class="contact_us_prod_input_group clearfix margin-top-20 contact_us_prod_button_group">
<input type="submit" id="send-message-drawer"
       class="btn btn-xl main-bg submit-btn shape"
       value="Send Message"
       onclick="return false;">
</div>

</div>'


                    ||
                '</div>' ;
    ELSE
        v_grid_html := v_grid_html || 
        '<div id="'|| c_product_rec.ANCHOR_ID || '" class="centered">';


         IF c_product_rec.PRODUCT_IMAGE_LARGE is not null
            then
                 v_grid_html := v_grid_html ||'<div class="centered-image "><img class="fx animated fadeInLeft img-mobile-40" alt="" src="' ||  c_product_rec.PRODUCT_IMAGE_LARGE || '" ' ||
                    'style="margin-bottom:30px; ' ||
                    ' height: 200px;' 
                    || '"/></div>' ||
                    '<div class="centered-image "><img class="fx animated fadeInLeft  img-mobile-40" data-animate="fadeInLeft" alt="" src="' || p_workspace_url  || 'assets/images/Scientific/suppliers/'||c_product_rec.SUPPLIER_LOGO_LARGE||'" style="margin-bottom:30px; width:150px; '||
                        ' ">  ' ||                  
                '</div>';
            else null;
        END IF;

v_grid_html := v_grid_html || 
    '<div id="contactus-spinner" style="display:none;   margin-bottom:30px; font-size:24px; text-align:center;">' ||
        '<i class="fa fa-spinner fa-spin"></i> Sending...' ||
    '</div>';

         IF c_product_rec.PRODUCT_IMAGE_LARGE is not null
            then
                 v_grid_html := v_grid_html || '<div class="heading main-heading centered padding-top-10">' ||
                    '<h4 class="sub-title1">' || 
                     CASE 
                        WHEN c_product_rec.PRODUCT_GROUP_ALT IS NOT NULL 
                        THEN c_product_rec.PRODUCT_GROUP_ALT ||'<span class="main-color"> - ' || c_product_rec.PRODUCT_GROUP
                        ELSE c_product_rec.PRODUCT_TYPE ||'<span class="main-color"> - ' || c_product_rec.PRODUCT_GROUP
                    END||
                     '</span></h4>' ||
                    '<div class="heading-separator"><span class="main-bg"></span><span class="dark-bg"></span></div>' ||
                '</div>';               


             v_grid_html := v_grid_html || '<div >
                        <div id="specs" style="flex: 1; min-width: 250px;">
                                      <div class="heading side-head">
                                        <div class="head-8">
                                          <h4 class="heavy-font">'||c_product_rec.PRODUCT_NAME||'</h4>
                                        </div>
                                      </div>
                                    </div>';

            else null;
        END IF;



 v_grid_html := v_grid_html ||'
<div id="contact" class="syn-scope contact_us_prod_container">

    <!-- Success message -->
    <div id="custom-success-message-drawer"
     class="contact_us_prod_success_message margin-bottom-50 fancy-success-message"
     style="display:none; position:relative;"
     role="status" aria-live="polite">

      <button type="button"
              class="success-close btn btn-sm"
              style="position:absolute; top:10px; right:10px; line-height:1; padding:6px 10px;"
              aria-label="Close success message">ï¿½</button>
        <i class="fa fa-thumbs-up success-icon pulse"></i>
        <p class="congrats main-color success-title">Thank You!</p>
        <p class="congratsTxt success-subtitle">Your message was sent. We''ll get back to you soon.</p>
    </div>

    <!-- Contact form -->
    <div class="form-signin cform contact_us_prod_form" id="drawerContactForm">

        <div class="contact_us_prod_input_group">
            <input type="text" class="form-control shape" id="name" placeholder="Your Name">
            <div id="name-error" class="input-error-message"></div>
        </div>

        <div class="contact_us_prod_input_group">
            <input type="text" class="form-control shape" id="organisation" placeholder="Organisation">
            <div id="organisation-error" class="input-error-message"></div>
        </div>

        <div class="contact_us_prod_input_group">
            <input type="email" class="form-control shape" id="email" placeholder="Email Address">
            <div id="email-error" class="input-error-message"></div>
        </div>

        <div class="contact_us_prod_input_group">
            <input type="text" class="form-control shape" id="phone" placeholder="Phone Number">
            <div id="phone-error" class="input-error-message"></div>
        </div>

        <div class="contact_us_prod_input_group">
            <input type="text" class="form-control shape" id="subject" placeholder="Subject">
            <div id="subject-error" class="input-error-message"></div>
        </div>

        <div class="contact_us_prod_input_group ">
            <select id="enquiryTypeDrawer" class="form-control shape new-angle contact_dropdown enquiryType" required>
                <option value="" disabled selected>-- Select Enquiry Type --</option>
            </select>
             <div class="input-error-message enquiryType-error"></div>
        </div>

        <div class="contact_us_prod_input_group">
            <textarea class="form-control shape" id="cnt_messageTxt" cols="40" rows="7" placeholder="Your Message"></textarea>
            <div id="message-error" class="input-error-message"></div>
        </div>

<!-- ? Drawer reCAPTCHA -->
<div id="recaptcha-drawer" class="g-recaptcha"
     data-sitekey="6LfK9IwrAAAAAN5gg5PX3W0AmvKx1Xj7BZm1Sl0E"
     data-callback="onCaptchaSuccess"
     data-expired-callback="onCaptchaExpired">
</div>

<div id="recaptcha-error-drawer" class="input-error-message" style="display: none;"></div>



<!-- Send Button -->
<div class="contact_us_prod_input_group clearfix margin-top-20 contact_us_prod_button_group">
<input type="submit" id="send-message-drawer"
       class="btn btn-xl main-bg submit-btn shape"
       value="Send Message"
       onclick="return false;">
</div>

</div>'


                    ||
                '</div>' ;
    END IF;

    CLOSE c_product;
    RETURN v_grid_html;
END;


/
