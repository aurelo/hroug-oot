create or replace package app_pkg
is
/*******************************************************************************
 Package for working with application parameters infrastructure
 Demonstrates working with anydata build in object type
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

   function get_number(
     p_anydata in anydata 
   ) 
   return number; 
   
   function get_date(
     p_anydata in anydata 
   )
   return date; 
   
   function get_varchar2(
     p_anydata in anydata 
   ) 
   return varchar2;
   
   function get_param_value(
    p_param_name     in   app_parm.name%type
   )
   return anydata;
   
end;