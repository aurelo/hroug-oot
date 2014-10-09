SET VERIFY OFF
SET TERMOUT ON

------------                       CREATE PACKAGE SPECS               ----------
@@src/test/ut_account_receivable_ot.pks
@@src/test/ut_payment_queue_creator_pkg.pks
@@src/test/ut_payment_service_pkg.pks
@@src/test/ut_transaction_service_pkg.pks

------------                       CREATE PACKAGE BODY                ----------
@@src/test/ut_account_receivable_ot.pkb
@@src/test/ut_payment_queue_creator_pkg.pkb
@@src/test/ut_payment_service_pkg.pkb
@@src/test/ut_transaction_service_pkg.pkb
