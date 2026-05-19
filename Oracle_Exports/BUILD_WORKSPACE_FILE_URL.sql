--------------------------------------------------------
--  DDL for Function BUILD_WORKSPACE_FILE_URL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."BUILD_WORKSPACE_FILE_URL" (
    p_directory  IN VARCHAR2,
    p_image_file IN VARCHAR2
) RETURN VARCHAR2
IS
    v_dir          VARCHAR2(4000) := NVL(p_directory, '');
    v_file         VARCHAR2(4000) := p_image_file;
    v_service_name VARCHAR2(255)  := UPPER(SYS_CONTEXT('USERENV', 'SERVICE_NAME'));
    v_alias        VARCHAR2(255);
    v_version      VARCHAR2(100);
    v_is_dev       BOOLEAN := FALSE;
BEGIN
    IF v_file IS NULL THEN
        RETURN NULL;
    END IF;

    IF v_dir <> '' AND SUBSTR(v_dir, -1) <> '/' THEN
        v_dir := v_dir || '/';
    END IF;

    v_is_dev := v_service_name LIKE '%DEV%';

    BEGIN
        IF v_is_dev THEN
            SELECT config_value INTO v_alias
            FROM syntec_config
            WHERE config_key = 'STATIC_ALIAS_DEV';
        ELSE
            SELECT config_value INTO v_alias
            FROM syntec_config
            WHERE config_key = 'STATIC_ALIAS_PROD';
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_alias := CASE WHEN v_is_dev THEN 'syntec_dev' ELSE 'syntec' END;
    END;

    BEGIN
        IF v_is_dev THEN
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
            v_version := CASE WHEN v_is_dev THEN 'v3931' ELSE 'v3211' END;
    END;

    RETURN 'r/' || LOWER(v_alias) || '/files/static/' || v_version || '/' || v_dir || v_file;
END;

/
