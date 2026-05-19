--------------------------------------------------------
--  DDL for Function GET_ANCHOR_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."GET_ANCHOR_ID" (
    p_prefix IN VARCHAR2,
    p_discipline_id IN VARCHAR2,
    p_product_group_id IN VARCHAR2,
    p_supplier_id IN VARCHAR2, 
    p_product_id IN VARCHAR2,
    p_anchor_type IN VARCHAR2
) RETURN VARCHAR2 IS
    v_anchor_all    VARCHAR2(200);
    v_anchor        VARCHAR2(200);
    v_error         VARCHAR2(200);
BEGIN
            v_anchor_all := p_prefix;

            v_error := 'Discipline: '||p_discipline_id;
            IF p_discipline_id is not null THEN
                IF upper(p_anchor_type) = 'CODE'
                THEN
                v_anchor_all := v_anchor_all || '_' || p_discipline_id;
                ELSE
                SELECT ANCHOR_ID INTO v_anchor FROM DISCIPLINE WHERE DISCIPLINE_ID = p_discipline_id;
                v_anchor_all := v_anchor_all || v_anchor;
                END IF;
            END IF;

            IF p_product_group_id is not null THEN
                IF upper(p_anchor_type) = 'CODE'
                THEN
                v_anchor_all := v_anchor_all || '_' || p_product_group_id;
                ELSE            
                SELECT ANCHOR_ID INTO v_anchor FROM PRODUCT_GROUP where PRODUCT_GROUP_ID = p_product_group_id;
                v_anchor_all := v_anchor_all || v_anchor;
                END IF;
            END IF;            

            IF p_supplier_id is not null THEN
                IF upper(p_anchor_type) = 'CODE'
                THEN
                v_anchor_all := v_anchor_all || '_' || p_supplier_id;
                ELSE
                SELECT ANCHOR_ID INTO v_anchor FROM SUPPLIERS where SUPPLIER_ID = p_supplier_id;
                v_anchor_all := v_anchor_all || v_anchor;
                END IF;
            END IF;            

            IF p_product_id is not null THEN
                IF upper(p_anchor_type) = 'CODE'
                THEN
                v_anchor_all := v_anchor_all || '_' || p_product_id;
                ELSE
                SELECT ANCHOR_ID INTO v_anchor FROM PRODUCTS where PRODUCT_ID = p_product_id;
                v_anchor_all := v_anchor_all || v_anchor;
                END IF;
            END IF; 



            RETURN v_anchor_all; -- Return the result


EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'No data found for ANCHOR_ID: ' || v_error;
    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;
END;


/
