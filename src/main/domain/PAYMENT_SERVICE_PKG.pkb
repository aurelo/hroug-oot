create or replace package body payment_service_pkg
as
/*******************************************************************************
 Service for closing receivables after payment has been made   
 <p>
 Package is distributed with example code for lecture Oracle Object Types given
 on HROUG 19(@link www.hroug.hr) conference.
 Contains logic to close open receivables on customer payment 

@author Zlatko Gudasić

CHANGE HISTORY (last one on top!)

When         Who 
dd.mm.yyyy   What
================================================================================
13.08.2014   Zlatko Gudasić         
             Initial creation
             
*******************************************************************************/
-------------------------------------------------------------------------------- 
-- PRIVATE FUNCTIONS AND PROCEDURES 
--------------------------------------------------------------------------------
     function colection_is_initialized(
      p_receivables_tab    in     account_receivable_tt
     )
     return boolean
     is
/**-----------------------------------------------------------------------------
colection_is_initialized:
 Checks is collection initialized (is not assigned null reference)

@param  p_receivables_tab  collection to check
------------------------------------------------------------------------------*/
     begin
         return p_receivables_tab is not null;
     end;
     
     

     function collection_is_empty(
      p_receivables_tab   in       account_receivable_tt 
     )
     return boolean
     is
/**-----------------------------------------------------------------------------
collection_is_empty:
 Checks does collection have some data

@param  p_receivables_tab  collection to check
------------------------------------------------------------------------------*/
     begin
         return colection_is_initialized(p_receivables_tab)
         and    p_receivables_tab.count = 0;
     end;


     function filter_closable(
      p_paid_amount           in     number
     ,p_sorted_receivables    in     account_receivable_tt
     )
     return account_receivable_tt
     is 
/**-----------------------------------------------------------------------------
filter_closable:
 From potential receivables returns collection of receivables that could be 
 closed with given amount

@param   p_paid_amount        Amount available for closing
@param   p_sorted_receivables collection of open receivables that need closing
@return  collection of potentially closable receivables 
------------------------------------------------------------------------------*/
         v_closable_tab       account_receivable_tt := account_receivable_tt(); 
         v_amount_left        number := p_paid_amount;
         v_closable_amount    number := 0;
     begin
         if  p_paid_amount <= 0
         or  p_sorted_receivables.count = 0
         then
            return v_closable_tab;
         end if;
         
         for i in p_sorted_receivables.first..p_sorted_receivables.last
         loop
             v_closable_amount := least(p_sorted_receivables(i).amount, v_amount_left);
             exit when v_closable_amount <= 0;
             
             v_closable_tab.extend;
             v_closable_tab(v_closable_tab.count) := p_sorted_receivables(i);
             v_closable_tab(v_closable_tab.count).amount := v_closable_amount;  
         
             v_amount_left := v_amount_left - v_closable_amount;
         end loop;
         
         return v_closable_tab;
     end;


-------------------------------------------------------------------------------- 
-- PUBLIC FUNCTIONS AND PROCEDURES 
--------------------------------------------------------------------------------
     function get_closable_receivables(
      p_paid_amount         in     number
     ,p_charge_context      in     charge_context_ot
     ,p_open_receivables    in     account_receivable_tt
     )
     return   account_receivable_tt
     is
         v_sorted_receivables       account_receivable_tt;
         v_empty_receivables_tab    account_receivable_tt;
     begin
         hroug_utils_pkg.require(colection_is_initialized(p_open_receivables)
                               , 'Uninitialized receivables collection!'
                               , hroug_utils_pkg.NULL_ARGUMENT_EXCEPTION);
              
         
         v_empty_receivables_tab := account_receivable_tt();
                          
         if   collection_is_empty(p_open_receivables)
         then
            return v_empty_receivables_tab;
         end if;

         if p_paid_amount <=0
         then
            return v_empty_receivables_tab;
         end if;
         
     
         v_sorted_receivables := receivables_sort_engine_pkg.sort_receivables(
             p_charge_context         => p_charge_context 
            ,p_receivables_tab        => p_open_receivables
         );
         
         return filter_closable(
           p_paid_amount
          ,v_sorted_receivables
         );
     end;


--------------------------------------------------------------------------------
     procedure close_receivables(
      p_account                     in     varchar2
     ,p_paid_amount         in     number
     ,p_charge_context      in     charge_context_ot
     ,p_open_receivables    in     account_receivable_tt
     )
     is
         v_receivables_to_be_closed_tab  account_receivable_tt;
     begin
         hroug_utils_pkg.require(colection_is_initialized(p_open_receivables)
                               , 'Uninitialized receivables collection!'
                               , hroug_utils_pkg.NULL_ARGUMENT_EXCEPTION);
             
         v_receivables_to_be_closed_tab := get_closable_receivables(
           p_paid_amount
          ,p_charge_context
          ,p_open_receivables
         );
         
                           
         if   collection_is_empty(v_receivables_to_be_closed_tab)
         then
             hroug_utils_pkg.log('All receivables are already closed'
                      ,$$plsql_unit
                      ,$$plsql_line
                      );
            return;
         end if;
         
         for i in v_receivables_to_be_closed_tab.first..v_receivables_to_be_closed_tab.last
         loop
             transaction_service_pkg.payment(p_account, v_receivables_to_be_closed_tab(i).amount);
         end loop;
         
     end;
    
end;
/