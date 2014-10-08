CREATE OR REPLACE package hroug_utils_pkg
/*******************************************************************************
 Utility package for HROUG 19 conference - Oracle Object Types lecture  
 <p>
 Package is distributed with example code for lecture Oracle Object Types given
 on HROUG 19(@link www.hroug.hr) conference.
 Package contains miscellaneous, often unrelated, functions and procedures that 
 are not essential for core concepts demonstrated in lecture, but are necessary
 for example completeness

%author Zlatko Gudasiæ

CHANGE HISTORY (last one on top!)

When         Who 
dd.mm.yyyy   What
================================================================================
13.08.2014   Zlatko Gudasiæ         
             Initial creation
             
*******************************************************************************/
as
  NULL_ARGUMENT_EXCEPTION constant pls_integer := -20191;
  
  type stack_data_rec is record (
   owner            all_objects.object_name%type
  ,object_name      all_objects.object_name%type
  ,object_type      all_objects.object_name%type
  ,line_number      number
  );
  
  type stack_data_tab_type is table of stack_data_rec 
  index by binary_integer;
  

/**-----------------------------------------------------------------------------
assert:
 Function to perform assertion (statement of fact)

@param   p_condition       Condition to check
@param   p_message         Message if condition is false
@param   p_error_id        Custom identifier for raised exception 
------------------------------------------------------------------------------*/
    procedure assert(
     p_condition        in    boolean
    ,p_message          in    varchar2
    ,p_error_id         in    pls_integer
    );

/**-----------------------------------------------------------------------------
require:
 Function to perform precondition (condition under which a call to routine is
 legitimate)

@param   p_condition       Condition to check
@param   p_message         Message if condition is false
@param   p_error_id        Custom identifier for raised exception
------------------------------------------------------------------------------*/
    procedure require(
     p_condition        in    boolean
    ,p_message          in    varchar2
    ,p_error_id         in    pls_integer
    );
    
    
/**-----------------------------------------------------------------------------
ensure:
 Function to perform postcondition (conditions that must be ensured by the 
 routine on return)

@param   p_condition       Condition to check
@param   p_message         Message if condition is false
@param   p_error_id        Custom identifier for raised exception
------------------------------------------------------------------------------*/
    procedure ensure(
     p_condition        in    boolean
    ,p_message          in    varchar2
    ,p_error_id         in    pls_integer
    )
    ;
    
    
/**-----------------------------------------------------------------------------
log:
 Logs message to hroug_log table. This function is in context of code examples 
 often used to replace real implementations and to provide testing hooks  

@param   p_message         Message to log
@param   p_plsql_unit      plsql unit calling log
@param   p_plsql_line      line from plsql unit calling log
------------------------------------------------------------------------------*/
    procedure log(
      p_message      in   varchar2
     ,p_plsql_unit   in   varchar2
     ,p_plsql_line   in   integer
    );
    
    
/**-----------------------------------------------------------------------------
clear_log_tab:
 deletes rows from hroug_log logging table  
------------------------------------------------------------------------------*/
    procedure clear_log_tab;


/**-----------------------------------------------------------------------------
log_tab_count:
 Returns count of rows in hroug_log table 

@return number of rows in hroug_log table
------------------------------------------------------------------------------*/
    function log_tab_count
    return   pls_integer;
    
    
/**-----------------------------------------------------------------------------
log_tab_filled_from:
 Checks whether hroug_log table has been filled from certain plsql unit    

@param   p_plsql_unit      plsql unit to check
@return  true if log table was filled from plsql unit in question, false 
         otherwise
------------------------------------------------------------------------------*/
    function log_tab_filled_from(
     p_plsql_unit     in    varchar2
    )
    return boolean;
    
    
/**-----------------------------------------------------------------------------
log_tab_contains:
 Checks whether hroug_log table has been filled with certain message  

@param   p_message         Message to check
@return  true if log table was filled with message in question, false 
         otherwise
------------------------------------------------------------------------------*/
    function log_tab_contains(
     p_message     in    varchar2
    )
    return boolean;
    
    
    
/**-----------------------------------------------------------------------------
who_called_me:
 By default, returns the name of the package or standalone one level further up
 in the call stack, which represents the caller of the routine that called this
 function. When called indirectly by another layer in the framework, the stack
 level needs to be increased from the default to find out who the real 
 caller's caller is.

@credit Tom Kyte.

@param i_stack_level The depth in the stack to look for caller info.
------------------------------------------------------------------------------*/
  function who_called_me(p_stack_level in pls_integer default 1)  
  return   stack_data_tab_type;
    
end hroug_utils_pkg;
/
