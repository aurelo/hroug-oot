SET VERIFY OFF
SET TERMOUT ON
-- Script is part of examples provided for HROUG19 conference - Oracle Object Types speech 
PROMPT Installation script for custom schema
PROMPT
ACCEPT hroug_schema CHAR DEFAULT 'HROUG19' PROMPT "Enter the schema name (Default is HROUG19): "
ACCEPT hroug_pswd CHAR DEFAULT 'HROUG19' PROMPT "Enter the schema password (Default is HROUG19): " HIDE
ACCEPT default_tablespace CHAR DEFAULT 'USERS' PROMPT "Enter the schema's default tablespace (Default is USERS): "
ACCEPT temp_tablespace CHAR DEFAULT 'TEMP' PROMPT "Enter the schema's default temp tablespace (Default is TEMP): "
PROMPT Creating user &&hroug_schema...

------------                       CREATE USER                        ----------
CREATE USER &&hroug_schema
  IDENTIFIED BY "&&hroug_pswd"
  DEFAULT TABLESPACE &&default_tablespace
  TEMPORARY TABLESPACE &&temp_tablespace
  QUOTA UNLIMITED ON &&default_tablespace
  ;

PROMPT Granting appropriate privileges to &&hroug_schema...

grant connect, create session to &&hroug_schema;

-- Grant/Revoke role privileges 
grant select_catalog_role to &&hroug_schema;
grant execute_catalog_role to &&hroug_schema;
grant select any dictionary to &&hroug_schema;

grant resource to &&hroug_schema;

grant create table to &&hroug_schema;
grant create sequence to &&hroug_schema;
grant create type to &&hroug_schema;
grant create view to &&hroug_schema;
grant create procedure to &&hroug_schema;
grant aq_administrator_role to &&hroug_schema;
grant aq_user_role  to &&hroug_schema;
grant execute on dbms_aqadm to &&hroug_schema;
grant execute on dbms_aq to &&hroug_schema;



PROMPT Done.