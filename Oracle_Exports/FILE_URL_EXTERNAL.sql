--------------------------------------------------------
--  DDL for Function FILE_URL_EXTERNAL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "WEB"."FILE_URL_EXTERNAL" (
    p_workspace_alias in varchar2,
    p_directory       in varchar2,
    p_filename        in varchar2
) return varchar2
is
    l_prefix   varchar2(4000);
    l_base_url varchar2(2000);
    l_version  varchar2(255);
    l_dir      varchar2(2000);
begin
    if p_filename is null then
        return null;
    end if;

    -- Preferred: APEX runtime-provided workspace static prefix
    l_prefix := v('WORKSPACE_IMAGES');

    -- Fallback for non-APEX session contexts (jobs, standalone SQL)
    if l_prefix is null then
        select config_value
          into l_base_url
          from syntec_config
         where config_key = 'STATIC_FILE_BASE_URL';

        select config_value
          into l_version
          from syntec_config
         where config_key = 'STATIC_FILE_VERSION';

        l_prefix := rtrim(l_base_url, '/') || '/r/' || lower(p_workspace_alias) || '/files/static/' || l_version || '/';
    end if;

    l_dir := trim('/' from nvl(p_directory, ''));
    if l_dir is not null then
        l_dir := l_dir || '/';
    end if;

    return l_prefix || l_dir || p_filename;
end;

/
