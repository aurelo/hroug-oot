SET VERIFY OFF
SET TERMOUT ON

------------                       CREATE TABLES                      ----------
PROMPT Creating tables...
@@src/main/infrastructure/app_tables.sql


------------                       CREATE PACKAGE SPECS               ----------
PROMPT Creating package specs
@@src/main/infrastructure/app_pkg.pks
@@src/main/domain/payment_service_pkg.pks
@@src/main/domain/transaction_service_pkg.pks
@@src/main/infrastructure/payment_queue_creator_pkg.pks

------------                       CREATE TYPES                       ----------
@@src/main/domain/account_receivable.sql
@@src/main/infrastructure/message_handler_master_ot.tps
@@src/main/infrastructure/message_handler_ot.tps
@@src/main/infrastructure/message_handler_ot.tpb
@@src/main/infrastructure/output_handler_ot.tps
@@src/main/infrastructure/output_handler_ot.tpb
@@src/main/infrastructure/email_handler_ot.tps
@@src/main/infrastructure/email_handler_ot.tpb

------------                       CREATE VIEWS                       ----------
@@src/main/infrastructure/app_env_param_vw.sql


------------                       CREATE PACKAGE BODY                ----------
PROMPT Creating package bodies
@@src/main/infrastructure/app_pkg.pkb
@@src/main/domain/payment_service_pkg.pkb
@@src/main/domain/transaction_service_pkg.pkb
@@src/main/infrastructure/payment_queue_creator_pkg.pkb

PROMPT Done.