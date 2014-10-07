create or replace package payment_service_pkg
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

/**-----------------------------------------------------------------------------
get_closable_receivables:
 From the list of open receivables return list of receipts and appropriate 
 amounts that are closable by paid amount using certain charge strategy

@param  p_paid_amount      Amount paid by customer that will be used for closing
@param  p_charge_context   Priority of closing strategy
@param  p_open_receivables Colleciton of open recevables 
------------------------------------------------------------------------------*/
     function get_closable_receivables(
      p_paid_amount         in     number
     ,p_charge_context      in     charge_context_ot
     ,p_open_receivables    in     account_receivable_tt
     )
     return   account_receivable_tt;  
     
     
/**-----------------------------------------------------------------------------
close_receivables:
 Closes given receivables 

@param  p_account
@param  p_paid_amount      Amount paid by customer that will be used for closing
@param  p_charge_context   Priority of closing strategy
@param  p_open_receivables collection of all open receivables
------------------------------------------------------------------------------*/
     procedure close_receivables(
      p_account             in     varchar2
     ,p_paid_amount         in     number
     ,p_charge_context      in     charge_context_ot
     ,p_open_receivables    in     account_receivable_tt
     );


end;
/