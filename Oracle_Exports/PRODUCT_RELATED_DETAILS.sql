--------------------------------------------------------
--  DDL for Function PRODUCT_RELATED_DETAILS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."PRODUCT_RELATED_DETAILS" (
    p_id            in varchar2,
    p_workspace_url in varchar2,
    p_device_type   in varchar2
) return clob is
    v_slider_details_html clob := '';
    v_ws_url              varchar2(4000);
begin
    v_ws_url := nvl(trim(p_workspace_url), v('WORKSPACE_IMAGES'));
    if v_ws_url is null then
        raise_application_error(-20001, 'Workspace files URL not available.');
    end if;
    if substr(v_ws_url, -1) <> '/' then
        v_ws_url := v_ws_url || '/';
    end if;

    for r_related_type in (
        select product_type_name, product_type_id
        from (
            select distinct
                t.product_type_name,
                t.product_type_id,
                t.product_type_order sort
            from suppliers s, product_type t, products_related r, products p, products pr
            where r.product_related_id = pr.product_id
              and r.product_id = p.product_id
              and pr.supplier_id = s.supplier_id
              and t.product_type_id = r.product_type_id
              and p.deleted = 'N' and p.active = 'Y'
              and r.deleted = 'N' and r.active = 'Y'
              and r.product_id = p_id
        )
        order by sort
    ) loop

        for r_related_products in (
            select
                product_type_name,
                product_type_id,
                product_id,
                product_name,
                product_id_related,
                product_name_related,
                supplier_name,
                product_image_large,
                product_link,
                product_about,
                product_enquire,
                anchor_id,
                product_image_large_width,
                product_image_large_height
            from (
                select
                    t.product_type_name,
                    t.product_type_id,
                    t.product_type_order sort,
                    p.product_id, p.product_name,
                    pr.product_id product_id_related,
                    pr.product_name || 'xx' product_name_related,
                    s.supplier_name,
                    pr.product_image_large,
                    pr.product_link,
                    replace(pr.about_1, '#WORKSPACE_FILES#', v_ws_url) product_about,
                    pr.product_enquire,
                    get_anchor_id('prd', pr.discipline_id, pr.product_group_id, pr.supplier_id, pr.product_id, 'code') anchor_id,
                    pr.product_image_large_width,
                    pr.product_image_large_height
                from suppliers s, product_type t, products_related r, products p, products pr
                where r.product_related_id = pr.product_id
                  and r.product_id = p.product_id
                  and pr.supplier_id = s.supplier_id
                  and t.product_type_id = r.product_type_id
                  and p.deleted = 'N' and p.active = 'Y'
                  and r.deleted = 'N' and r.active = 'Y'
                  and r.product_id = p_id
                  and r_related_type.product_type_id = r.product_type_id
            )
            order by product_name
        ) loop

            v_slider_details_html := v_slider_details_html
                || '<div class="product-details-syn" id="' || r_related_products.product_id || '-' || r_related_products.product_id_related || '" style="display: none;">'
                || product_details_display(p_device_type, v_ws_url, r_related_products.product_id_related, 'N')
                || '</div>';

        end loop;
    end loop;

    return v_slider_details_html;
end;

/
