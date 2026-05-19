--------------------------------------------------------
--  DDL for Function GET_MENU_INFO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."GET_MENU_INFO" (
    p_menu_order IN VARCHAR2,
    p_level IN VARCHAR2,
    p_column IN VARCHAR2
) RETURN VARCHAR2 IS
    v_menu_id VARCHAR2(50);
    v_parent_id VARCHAR2(50);
    v_sub_menu_level VARCHAR2(10);
    v_result VARCHAR2(4000);
BEGIN
    -- Find the starting record based on p_menu_order
    SELECT MENU_ORDER, PARENT_ID, SUB_MENU_LEVEL_ID
    INTO v_menu_id, v_parent_id, v_sub_menu_level
    FROM MENU_ITEMS
    WHERE MENU_ORDER = p_menu_order;

    -- Traverse the hierarchy upwards until we find the matching level
    LOOP
        -- Check if the current level matches the requested level
        IF v_sub_menu_level = p_level THEN
            IF p_column = 'MENU_NAME' THEN
                SELECT MENU_NAME INTO v_result FROM MENU_ITEMS WHERE MENU_ORDER = v_menu_id;
            ELSIF p_column = 'MENU_ID' THEN
                SELECT MENU_ORDER INTO v_result FROM MENU_ITEMS WHERE MENU_ORDER = v_menu_id;
            ELSE
                RETURN 'Invalid column: ' || p_column;
            END IF;

            RETURN v_result; -- Return the result
        END IF;

        -- Exit if we've reached the top level with no parent
        IF v_parent_id IS NULL THEN
            RETURN NULL;
        END IF;

        -- Move up the hierarchy
        SELECT MENU_ORDER, PARENT_ID, SUB_MENU_LEVEL_ID
        INTO v_menu_id, v_parent_id, v_sub_menu_level
        FROM MENU_ITEMS
        WHERE MENU_ID = v_parent_id;
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'No data found for MENU_ORDER: ' || p_menu_order;
    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;
END;


/
