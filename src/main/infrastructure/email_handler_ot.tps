create or replace type email_handler_ot under message_handler_ot(
/*******************************************************************************
 Object type for chain of responsibility pattern applied to message 
 handling abstraction.
 Handles emailing messages
 <p>
 Package is distributed with example code for lecture Oracle Object Types given
 on HROUG 19(@link www.hroug.hr) conference.

%author Zlatko Gudasic

CHANGE HISTORY (last one on top!)

When         Who 
dd.mm.yyyy   What
================================================================================
13.08.2014   Zlatko Gudasic         
             Initial creation
             
*******************************************************************************/
   email       varchar2(64)
--------------------------------------------------------------------------------
,overriding member procedure handle(
     p_level   in  number
   , p_message in  varchar2
   )
--------------------------------------------------------------------------------
  ,constructor function email_handler_ot(
     p_threshold   in  number
    ,p_email       in  varchar2
  ) return self as result
--------------------------------------------------------------------------------
  ,overriding  member procedure process_request(p_message in varchar2)
)
;
/
