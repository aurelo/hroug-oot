create or replace package ut_account_receivable_ot
as
  procedure ut_setup;
  procedure ut_teardown;
  
  procedure ut_comparison;
  
  procedure ut_to_string;
end;
/
