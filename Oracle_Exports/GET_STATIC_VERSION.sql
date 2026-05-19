--------------------------------------------------------
--  DDL for Function GET_STATIC_VERSION
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."GET_STATIC_VERSION" 
RETURN VARCHAR2
IS
  v_service_name VARCHAR2(255) := UPPER(SYS_CONTEXT('USERENV', 'SERVICE_NAME'));
  v_version      VARCHAR2(100);
BEGIN
  BEGIN
    IF v_service_name LIKE '%DEV%' THEN
      SELECT config_value INTO v_version
      FROM syntec_config
      WHERE config_key = 'STATIC_VERSION_DEV';
    ELSE
      SELECT config_value INTO v_version
      FROM syntec_config
      WHERE config_key = 'STATIC_VERSION_PROD';
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_version := CASE WHEN v_service_name LIKE '%DEV%' THEN 'v3931' ELSE 'v3211' END;
  END;

  RETURN v_version;
END;

/
