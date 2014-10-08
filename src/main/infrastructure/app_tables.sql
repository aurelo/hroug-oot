-------------------------------------------------------------------------------
PROMPT Creating table APP...
create table app
(
  id           number                           not null,
  code         varchar2(5 char)                 not null,
  name         varchar2(50 char)                not null,
  description  varchar2(4000 char)              not null
)
;
alter table app add constraint 
  app_pk primary key
  (id);

-------------------------------------------------------------------------------
PROMPT Creating table APP_PARAM...
create table app_param
(
  id        integer                             not null,
  name      varchar2(500 char)                  not null,
  comments  varchar2(4000 char)
);

alter table app_param add constraint 
  app_param_pk primary key
  (id);
-------------------------------------------------------------------------------
PROMPT Creating table APP_DB...
create table app_db
(
  id    integer                                 not null,
  code  varchar2(20 char)                       not null,
  type  varchar2(20 char)                       not null
);

alter table app_db add constraint
   app_db_pk primary key (id);
alter table app_db add constraint
   app_db_uk unique (code);
-------------------------------------------------------------------------------
PROMPT Creating table APP_ENV...
create table app_env
(
  id           integer                          not null,
  app_id       integer                          not null,
  env_name     varchar2(80 char)                not null,
  db_id        integer                          not null,
  app_version  varchar2(20 char)
);

alter table app_env add constraint
  app_env_pk primary key (id);
alter table app_env add constraint app_env_uk
  unique (app_id, env_name);

alter table app_env add (
  constraint aev_app_id_fk 
  foreign key (app_id) 
  references app (id),
  constraint aev_db_id_fk 
  foreign key (db_id) 
  references app_db (id));
-------------------------------------------------------------------------------
PROMPT Creating table APP_ENV_PARAM...
create table app_env_param
(
  id                      number                not null,
  apm_id                  number                not null,
  aev_id                  number                not null,
  value                   sys.anydata
)
;
alter table app_env_param add 
  constraint aem_pk
  primary key
  (id);
alter table app_env_param add (
  constraint aem_aev_fk 
  foreign key (aev_id) 
  references app_env (id)
);

