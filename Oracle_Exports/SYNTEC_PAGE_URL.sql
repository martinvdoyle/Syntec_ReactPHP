--------------------------------------------------------
--  DDL for Function SYNTEC_PAGE_URL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."SYNTEC_PAGE_URL" (
    p_page_id     in number,
    p_public_link in number   default 0,   -- 0=no, 1=yes
    p_app_id      in number   default null,
    p_items       in varchar2 default null,
    p_values      in varchar2 default null,
    p_clear_cache in varchar2 default null
) return varchar2
as
    l_app_id     number := nvl(p_app_id, to_number(v('APP_ID')));
    l_page_alias apex_application_pages.page_alias%type;
    l_url        varchar2(4000);
begin
    select page_alias
      into l_page_alias
      from apex_application_pages
     where application_id = l_app_id
       and page_id        = p_page_id;

    l_url := apex_page.get_url(
        p_application  => l_app_id,
        p_page         => l_page_alias,   -- alias
        p_items        => p_items,
        p_values       => p_values,
        p_clear_cache  => p_clear_cache
    );

    if p_public_link = 1 then
        l_url := regexp_replace(l_url, '\?session=[^&]+', '');
    end if;

    return l_url;

exception
    when no_data_found then
        l_url := apex_page.get_url(
            p_application  => l_app_id,
            p_page         => p_page_id,
            p_items        => p_items,
            p_values       => p_values,
            p_clear_cache  => p_clear_cache
        );

        if p_public_link = 1 then
            l_url := regexp_replace(l_url, '\?session=[^&]+', '');
        end if;

        return l_url;
end;

/
