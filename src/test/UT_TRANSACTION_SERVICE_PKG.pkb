create or replace package body ut_transaction_service_pkg
as
   function queue_table_contains(
    p_account   in    varchar2
   ,p_amount    in    number
   )
   return boolean
   is
       v_cnt    integer;
   begin
       select   count(*)
       into     v_cnt
       from     dual
       where exists (
          select   null
          from     payment_qt pqt
          where    pqt.user_data.account = p_account
          and      pqt.user_data.amount = p_amount
         );
       
       return v_cnt > 0;        
   end;


   procedure ut_setup
   is
   begin
       null;
   end;
   
   procedure ut_teardown
   is
   begin
       null;
   end;
   
   procedure ut_payment
   is
   begin
       transaction_service_pkg.payment('123456789', 42);
       utAssert.this('Should post on payment queue', queue_table_contains('123456789',42));

       utAssert.this('Callbacks are being called', hroug_utils_pkg.log_tab_filled_from('payment_queue_consumers_pkg'));
       
--       utAssert.this('SMS callback should be called', hroug_utils_pkg.log_tab_filled_from('payment_queue_consumers_pkg'));
--       utAssert.this('Regulator check callback should be called', hroug_utils_pkg.log_tab_filled_from('payment_queue_consumers_pkg'));
   end;
   
end;