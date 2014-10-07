create or replace package transaction_service_pkg
as
/*******************************************************************************
 Transaction service mock
 
 <p>
 Package is distributed with example code for lecture Oracle Object Types given
 on HROUG 19(@link www.hroug.hr) conference. 

@author Zlatko Gudasiæ

CHANGE HISTORY (last one on top!)

When         Who 
dd.mm.yyyy   What
================================================================================
13.08.2014   Zlatko Gudasiæ         
             Initial creation
             
*******************************************************************************/
/**-----------------------------------------------------------------------------
payment:
 Payment mock assuming account paid appropriate amount.
 Raises payment event after being called

@param  p_from_account     Amount paid by customer that will be used for closing
@param  p_amount           Amount being paid 
------------------------------------------------------------------------------*/
    procedure payment(
     p_from_account    in    varchar2
    ,p_amount          in    number
    );
    
end transaction_service_pkg;
/