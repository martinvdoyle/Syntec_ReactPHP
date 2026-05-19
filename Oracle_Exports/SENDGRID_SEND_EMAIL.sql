--------------------------------------------------------
--  DDL for Procedure SENDGRID_SEND_EMAIL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "WEB"."SENDGRID_SEND_EMAIL" (
  p_to      IN VARCHAR2,
  p_from    IN VARCHAR2,
  p_subject IN VARCHAR2,
  p_body    IN VARCHAR2
) AS
  l_url          VARCHAR2(32767) := 'https://api.sendgrid.com/v3/mail/send';
  l_http_req     UTL_HTTP.req;
  l_http_resp    UTL_HTTP.resp;
  l_response_txt VARCHAR2(32767);
  l_status_code  NUMBER;
  l_payload      CLOB;
BEGIN
  -- Construct the JSON payload
  l_payload := '{
    "personalizations": [{
      "to": [{"email": "' || p_to || '"}]
    }],
    "from": {"email": "' || p_from || '"},
    "subject": "' || REPLACE(p_subject, '"', '\"') || '",
    "content": [{
      "type": "text/plain",
      "value": "' || REPLACE(p_body, '"', '\"') || '"
    }]
  }';

  -- Wallet (for TLS)
  UTL_HTTP.set_wallet('file:/usr/lib/oracle/21/client64/lib/network/admin', NULL);

  -- HTTP POST to SendGrid API
  l_http_req := UTL_HTTP.begin_request(l_url, 'POST', 'HTTP/1.1');
  UTL_HTTP.set_header(l_http_req, 'Content-Type', 'application/json');
  UTL_HTTP.set_header(l_http_req, 'Authorization', 'Bearer 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'); -- Replace this

  -- Send JSON body
  UTL_HTTP.write_text(l_http_req, l_payload);
  l_http_resp := UTL_HTTP.get_response(l_http_req);

  -- Read response status
  l_status_code := l_http_resp.status_code;
  DBMS_OUTPUT.put_line('HTTP Status: ' || l_status_code);

  -- Read response text
  BEGIN
    LOOP
      UTL_HTTP.read_text(l_http_resp, l_response_txt, 32767);
      DBMS_OUTPUT.put_line('Response: ' || l_response_txt);
    END LOOP;
  EXCEPTION
    WHEN UTL_HTTP.end_of_body THEN
      NULL;
  END;

  UTL_HTTP.end_response(l_http_resp);

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('Error sending email: ' || SQLERRM);
    DBMS_OUTPUT.put_line(DBMS_UTILITY.format_error_stack);
    DBMS_OUTPUT.put_line(DBMS_UTILITY.format_error_backtrace);
END;


/
