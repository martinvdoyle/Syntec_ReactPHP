--------------------------------------------------------
--  DDL for Function CONTACT_US_GENERAL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."CONTACT_US_GENERAL" (
    p_device_type        IN VARCHAR2,
    p_workspace_url      IN VARCHAR2,
    p_app_id             IN NUMBER,
    p_app_alias          IN VARCHAR2,
    p_website            IN VARCHAR2,
    p_user_id            IN VARCHAR2,
    p_contact_us_style   IN VARCHAR2
)
RETURN CLOB IS
    v_grid_html CLOB := '';
BEGIN
    -- Logo
    v_grid_html := v_grid_html || '<div class="col-md-12 t-center "><span class="block">' ||
        CASE p_website
            WHEN 'Syntec Group'         THEN '<img class="fx animated swing" alt="' || p_website || '" src="' || p_workspace_url || 'assets/images/Syntec_Group_Logo_Menu.png">'
            WHEN 'Syntec Scientific'    THEN '<img class="fx animated swing" alt="' || p_website || '" src="' || p_workspace_url || 'assets/images/Syntec_Scientific_Logo_Menu.png">'
            WHEN 'Syntec International' THEN '<img class="fx animated swing" alt="' || p_website || '" src="' || p_workspace_url || 'assets/images/Syntec_International_Logo_Menu.png">'
            WHEN 'SyS Laboratories'     THEN '<img class="fx animated swing" alt="' || p_website || '" src="' || p_workspace_url || 'assets/images/Syntec_SysLabs_Logo_Menu.png">'
            ELSE '<img class="fx animated swing" alt="' || p_website || '" src="' || p_workspace_url || 'assets/images/Syntec_Group_Logo_Menu.png">'
        END || 
        '</span></div>';

    -- Heading
    v_grid_html := v_grid_html || '
    <div class="padding-top-30 heading centered">
        <i class="fa fa-envelope tbl main-color" style="font-size: 30px;"></i>
        <h3 class="uppercase head-4 bold">Message Us</h3>
    </div>';

    -- Drawer contact details
    IF p_contact_us_style = 'Drawer_Team' THEN
        FOR r IN (
            SELECT u.USER_ID,
                   u.FIRST_NAME || ' ' || u.LAST_NAME AS FULL_NAME,
                   jt.JOB_TITLE_DESCRIPTION AS TITLE,
                   d.DIVISION_DESCRIPTION AS GROUP_NAME,
                   u.EMAIL,
                   u.PHONE_01 AS PHONE,
                   jt.SORT_ORDER AS JOB_SORT_ORDER
              FROM SYNTEC_USERS u
              JOIN SYNTEC_JOB_TITLES jt ON jt.JOB_TITLE_ID = u.USER_JOB_TITLE
              JOIN SYNTEC_DIVISIONS d ON d.DIVISION_ID = u.DIVISION
             WHERE u.IS_DELETED_YN = 'N'
               AND u.ISACTIVE = 'Y'
               AND u.USER_ID = p_user_id
        ) LOOP
            v_grid_html := v_grid_html || '<div class="portfolio-item form-contact ' ||
                LOWER(REPLACE(r.GROUP_NAME, ' ', '')) || ' img-shadow" data-contact-id="' ||
                htf.escape_sc(NVL(r.USER_ID, '')) || '">' ||

                '<div class="banner">' || INITCAP(r.GROUP_NAME) || '</div>' ||
                '<div class="name-holder">' ||

                '<h4 style="font-size:20px;"><span>' || htf.escape_sc(r.FULL_NAME) || '</span></h4>' ||
                '<h4 style="font-size:18px;"><span class="main-color">' || htf.escape_sc(NVL(r.TITLE, '&nbsp;')) || '</span></h4>' ||
                '<h4><a href="#"><i class="fa-regular fa-envelope"></i>&nbsp;&nbsp;' || htf.escape_sc(NVL(r.EMAIL, '&nbsp;')) || '</a></h4>' ||
                '<h4 style="margin-top:4px;"><i class="fa fa-phone main-color"></i>&nbsp;&nbsp;' || htf.escape_sc(NVL(r.PHONE, '&nbsp;')) || '</h4>' ||

                '</div></div>';
        END LOOP;
    END IF;

    -- Spinner
    v_grid_html := v_grid_html || '
    <div id="contactus-spinner" style="display:none; margin-bottom:30px; font-size:24px; text-align:center;">
        <i class="fa fa-spinner fa-spin"></i> Sending...
    </div>';

    -- ? Dynamic ID for wrapper: drawerContactForm or inlineContactForm
    v_grid_html := v_grid_html || '
    <div id="' || 
        CASE 
            WHEN p_contact_us_style = 'Drawer_Team' THEN 'drawerContactForm'
            ELSE 'inlineContactForm'
        END || '" class="syn-scope contact_us_prod_container mlr-20-mobile">

        <!-- Success message -->
        <div id="' || CASE 
               WHEN p_contact_us_style = 'Drawer_Team' THEN 'custom-success-message-drawer'
               ELSE 'custom-success-message-inline' 
            END || '" class="contact_us_prod_success_message margin-bottom-50 fancy-success-message" style="display:none; position:relative;" role="status" aria-live="polite">
          <button type="button"
              class="success-close btn btn-sm"
              style="position:absolute; top:10px; right:10px; line-height:1; padding:6px 10px;"
              aria-label="Close success message">ï¿½</button>

            <i class="fa fa-thumbs-up success-icon pulse"></i>
            <p class="congrats main-color success-title">Thank You!</p>
            <p class="congratsTxt success-subtitle">Your message was sent. We''ll get back to you soon.</p>
        </div>

        <!-- Contact form -->
        <div class="form-signin cform contact_us_prod_form" id="' || CASE 
               WHEN p_contact_us_style = 'Drawer_Team' THEN 'contactform-drawer'
               ELSE 'contactform-inline' 
            END || '">

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

            <div class="contact_us_prod_input_group">
                <select  ' ||  CASE 
            WHEN p_contact_us_style = 'Drawer_Team' THEN 'id="enquiryTypeDrawer"'
            ELSE ''
                 END

                ||' class="form-control shape new-angle contact_dropdown enquiryType" required>
                    <option value="" disabled selected>-- Select Enquiry Type --</option>
                </select>
                <div class="input-error-message enquiryType-error"></div>
            </div>

            <div class="contact_us_prod_input_group">
                <textarea class="form-control shape" id="cnt_messageTxt" cols="40" rows="7" placeholder="Your Message"></textarea>
                <div id="message-error" class="input-error-message"></div>
            </div>';

    -- Recaptcha and send button
    IF p_contact_us_style = 'Drawer_Team' THEN
        v_grid_html := v_grid_html || '
            <!-- ? new Drawer reCAPTCHA -->
            <div           id="recaptcha-drawer">
            </div>

            <div id="recaptcha-error-drawer" class="input-error-message" style="display: none;"></div>

            <!-- Send Button -->
            <div class="contact_us_prod_input_group clearfix margin-top-20 contact_us_prod_button_group">
                <input type="submit" id="send-message-drawer"
                       class="btn btn-xl main-bg submit-btn shape"
                       value="Send Message"
                       onclick="return false;">
            </div>';
    ELSE
        v_grid_html := v_grid_html || '
            <!-- ? Inline reCAPTCHA -->
            <div id="recaptcha-inline" class="g-recaptcha"
                data-sitekey="6LfK9IwrAAAAAN5gg5PX3W0AmvKx1Xj7BZm1Sl0E"
                data-callback="onCaptchaSuccess"
                data-expired-callback="onCaptchaExpired">
            </div>

            <div id="recaptcha-error-inline" class="input-error-message" style="display: none;"></div>

            <!-- Send Button -->
            <div class="contact_us_prod_input_group clearfix margin-top-20 contact_us_prod_button_group">
                <input type="submit" id="send-message-inline"
                       class="btn btn-xl main-bg submit-btn shape"
                       value="Send Message"
                       onclick="return false;">
            </div>';
    END IF;

    -- Close containers
    v_grid_html := v_grid_html || '
        </div> <!-- /#contactform -->
    </div> <!-- /#drawerContactForm or #inlineContactForm -->';

    RETURN v_grid_html;
END;


/
