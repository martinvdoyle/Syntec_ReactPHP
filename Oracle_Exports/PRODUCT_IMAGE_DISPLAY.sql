--------------------------------------------------------
--  DDL for Function PRODUCT_IMAGE_DISPLAY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."PRODUCT_IMAGE_DISPLAY" (
    p_workspace    IN VARCHAR2,
    p_directory    IN VARCHAR2,
    p_image_file   IN VARCHAR2,
    p_url_or_local IN VARCHAR2
) RETURN VARCHAR2
IS
BEGIN
    IF p_image_file IS NULL THEN
        RETURN NULL;
    END IF;

    IF REGEXP_LIKE(TRIM(p_image_file), '^https?://', 'i') THEN
        RETURN p_image_file;
    END IF;

    IF NVL(p_url_or_local, 'N') = 'Y' THEN
        RETURN p_image_file;
    END IF;

    RETURN BUILD_WORKSPACE_FILE_URL(
        p_directory  => p_directory,
        p_image_file => p_image_file
    );
END;

/
