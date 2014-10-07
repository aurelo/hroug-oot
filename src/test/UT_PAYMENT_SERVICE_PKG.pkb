create or replace package body ut_payment_service_pkg
as
   g_empty_receivables_tab  account_receivable_tt;
   
   g_age_charge_context            charge_context_ot;
   g_type_charge_context           charge_context_ot;
   
   g_intrest1               account_receivable_ot;
   g_intrest2               account_receivable_ot;

   procedure ut_setup
   is
   begin
       g_age_charge_context  := new charge_context_ot(age_charge_strategy_ot.empty_instance);
       g_type_charge_context := new charge_context_ot(type_charge_strategy_ot.empty_instance);
       
       g_empty_receivables_tab := account_receivable_tt();
       
       g_intrest1 := new account_receivable_ot(
           id          => 1
          ,amount      => 120
         ,age         => interval '15' day
         ,type        => 'INTEREST'
        );
        
       g_intrest2 := new account_receivable_ot(
           id          => 2
          ,amount      => 325.45
         ,age         => interval '150' day
         ,type        => 'INTEREST'
        );
   end;
   
   procedure ut_teardown
   is
   begin
       null;
   end;
   
   procedure ut_uninit
   is
   begin
      utassert.throws('Illegal argument exception'
                     ,q'<
      ut_payment_service_pkg.g_receivables_to_be_closed_tab :=
      payment_service_pkg.get_closable_receivables(
          p_paid_amount         => -1
         ,p_charge_context      => new charge_context_ot(age_charge_strategy_ot.empty_instance)
         ,p_open_receivables    => null
         );>'
                     ,hroug_utils_pkg.NULL_ARGUMENT_EXCEPTION
                     );
                     
      utassert.throws('Illegal argument exception'
                     ,q'<
      payment_service_pkg.close_receivables(
          p_account             => '11223344'
         ,p_paid_amount         => -1
         ,p_charge_context      => new charge_context_ot(age_charge_strategy_ot.empty_instance)
         ,p_open_receivables    => null
         );>'
                     ,hroug_utils_pkg.NULL_ARGUMENT_EXCEPTION
                     );
   end;
   
   
   procedure ut_nothing_to_pay
   is
   begin
      g_receivables_to_be_closed_tab := 
          payment_service_pkg.get_closable_receivables(
              p_paid_amount         => 100
             ,p_charge_context      => g_age_charge_context
             ,p_open_receivables    => g_empty_receivables_tab
             );
      utassert.this('Nothing is closed for customer that already paid everything', g_receivables_to_be_closed_tab.count = 0);
      
      
   end;
   
   
   procedure ut_negative_amounts
   is
      v_receivables_tab               account_receivable_tt := account_receivable_tt();
   begin
      v_receivables_tab.extend;
      v_receivables_tab(v_receivables_tab.count) := g_intrest1;
   
      g_receivables_to_be_closed_tab := 
         payment_service_pkg.get_closable_receivables(
                  p_paid_amount         => -100
                 ,p_charge_context      => g_age_charge_context
                 ,p_open_receivables    => v_receivables_tab
                 );
                 
      utassert.this('Nothing is closed for negative paiment amounts', g_receivables_to_be_closed_tab.count = 0);
      
   end;

   
   procedure ut_close_fully
   is
      v_receivables_tab   account_receivable_tt := account_receivable_tt();
   begin
      v_receivables_tab.extend;
      v_receivables_tab(v_receivables_tab.count) := g_intrest1; 
   
      g_receivables_to_be_closed_tab := 
          payment_service_pkg.get_closable_receivables(
              p_paid_amount         => 250
             ,p_charge_context      => g_age_charge_context
             ,p_open_receivables    => v_receivables_tab
             );
      utassert.this('Should fully close receivable on larger payment', g_receivables_to_be_closed_tab(1).amount = 120);
      
      
      v_receivables_tab.extend;
      v_receivables_tab(v_receivables_tab.count) := g_intrest2;
   
      g_receivables_to_be_closed_tab := 
          payment_service_pkg.get_closable_receivables(
              p_paid_amount         => 850
             ,p_charge_context      => g_age_charge_context
             ,p_open_receivables    => v_receivables_tab
             );
      
      utassert.this('Should fully close receivable on larger payment', g_receivables_to_be_closed_tab(1).amount = 325.45);
      utassert.this('Should fully close receivable on larger payment', g_receivables_to_be_closed_tab(2).amount = 120);
      
   end;
   
   
   procedure ut_close_partially
   is
      v_receivables_tab   account_receivable_tt := account_receivable_tt();
   begin
      v_receivables_tab.extend;
      v_receivables_tab(v_receivables_tab.count) := g_intrest1;
   
      g_receivables_to_be_closed_tab := 
          payment_service_pkg.get_closable_receivables(
              p_paid_amount         => 70
             ,p_charge_context      => g_age_charge_context
             ,p_open_receivables    => v_receivables_tab
             );
      utassert.this('Should close partially on lower payment', g_receivables_to_be_closed_tab(1).amount = 70);
      
      
      v_receivables_tab.extend;
      v_receivables_tab(v_receivables_tab.count) := g_intrest2;
   
      g_receivables_to_be_closed_tab := 
          payment_service_pkg.get_closable_receivables(
              p_paid_amount         => 345
             ,p_charge_context      => g_age_charge_context
             ,p_open_receivables    => v_receivables_tab
             );
      
      utassert.this('Should fully close oldest receivable', g_receivables_to_be_closed_tab(1).amount = 325.45);
      utassert.this('Should close partially younger receivable', g_receivables_to_be_closed_tab(2).amount = (345 - 325.45));
   end;
   
   
end;
/