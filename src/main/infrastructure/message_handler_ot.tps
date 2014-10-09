create or replace type message_handler_ot under message_handler_master_ot (
/*******************************************************************************
 Sub master object type for chain of responsibility pattern applied to message 
 handling abstraction.
 Two abstract object type hierarchy is used because of oracle handling of
 in memory self referencing types
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
 next_handler  message_handler_master_ot
--------------------------------------------------------------------------------
,overriding member procedure handle(
     p_level   in  number
   , p_message in  varchar2
   )
)
not final
not instantiable
/
