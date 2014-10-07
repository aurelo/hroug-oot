create or replace package ut_payment_service_pkg
as
   g_receivables_to_be_closed_tab  account_receivable_tt;


   procedure ut_setup;
   procedure ut_teardown;
   
   
   procedure ut_uninit;
   procedure ut_nothing_to_pay;
   
   procedure ut_negative_amounts;
   
   procedure ut_close_fully;
   procedure ut_close_partially;
   
end;
/