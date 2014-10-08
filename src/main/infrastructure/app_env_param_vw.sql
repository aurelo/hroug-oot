create or replace view app_env_param_vw
as
select   ap.id app_id
,        ap.code app_code
,        ap.name app_name
,        ap.description app_description
,        aev.app_version
,        adb.type db_type
,        apm.name param_name
,        aem.value param_value
,        app_pkg.get_date(aem.value) param_data_value
,        app_pkg.get_number(aem.value) param_number_value
,        app_pkg.get_varchar2(aem.value) param_varchar2_value
from     app ap
,        app_env aev
,        app_db adb
,        app_env_param aem
,        app_param apm
where    ap.id = aev.app_id
and      adb.id = aev.db_id
and      adb.code = upper (sys_context ('userenv', 'db_name'))
and      aem.apm_id = apm.id
and      aem.aev_id = aev.id
;
