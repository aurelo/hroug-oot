CREATE OR REPLACE package body hroug_utils_pkg
/*******************************************************************************
@author Zlatko Gudasiæ

CHANGE HISTORY (last one on top!)

When         Who 
dd.mm.yyyy   What
================================================================================
13.08.2014   Zlatko Gudasiæ         
             Initial creation
             
*******************************************************************************/
as
------------------------------------------------------------------------------*/
    function bundle_stack_lines
    return   stack_data_tab_type
    as
       v_call_stack  varchar2(4096) default dbms_utility.format_call_stack;
       v_pos  pls_integer := 0;
       v_line  varchar2(255);
       v_cnt  pls_integer := 0;
       v_stack_data_tab    stack_data_tab_type;
    begin
       v_pos := instr(v_call_stack,chr(10),1,3); --bypasses header lines
       v_call_stack := substr(v_call_stack, v_pos + 1); --removes header lines

       -- loop through lines in stack and pull out good stuff into array
       while (v_call_stack is not null) loop
          v_cnt := v_cnt + 1;

          v_pos := instr(v_call_stack,chr(10)); -- get pos of next linefeed

          exit when (v_pos is null or v_pos = 0); -- should exit when no more linefeeds

          v_line := substr(v_call_stack, 1, v_pos - 1);
          v_call_stack := substr(v_call_stack, v_pos + 1);

          -- Trip address off left side of line
          v_line := ltrim(substr(v_line, instr(v_line,chr(32))));
          
          -- First thing we care about is the line number
          v_stack_data_tab(v_cnt).line_number := to_number(substr(v_line, 1, instr(v_line,chr(32))-1));

          -- Need whatever's left after the line number
          v_line := ltrim(substr(v_line, length(v_stack_data_tab(v_cnt).line_number)+2));

          if (v_line like 'pr%') then
             v_pos := length('procedure ');
          elsif (v_line like 'fun%') then
             v_pos := length('function ');
          elsif (v_line like 'package body%') then
             v_pos := length('package body ');
          elsif (v_line like 'pack%') then
             v_pos := length('package ');
          elsif (v_line like 'anonymous%') then
             v_pos := length('anonymous block ');
          else
             v_pos := null;
          end if;

          if (v_pos is not null) then
             v_stack_data_tab(v_cnt).object_type := ltrim(rtrim(upper(substr(v_line, 1, v_pos - 1))));
          else
             v_stack_data_tab(v_cnt).object_type := 'TRIGGER';
          end if;

          v_line := substr(v_line, nvl(v_pos, 1));
          v_pos := instr(v_line, '.');

          if (v_pos > 0) then
             v_stack_data_tab(v_cnt).owner := ltrim(rtrim(substr(v_line, 1, v_pos - 1)));
             v_stack_data_tab(v_cnt).object_name := ltrim(rtrim(substr(v_line, v_pos + 1)));
          else
             v_stack_data_tab(v_cnt).owner := sys_context('userenv', 'current_schema');
             v_stack_data_tab(v_cnt).object_name := 'ANONYMOUSBLOCK';
          end if;
       end loop;

       return v_stack_data_tab;

    end bundle_stack_lines;

--------------------------------------------------------------------------------
    procedure assert(
     p_condition        in    boolean
    ,p_message          in    varchar2
    ,p_error_id         in    pls_integer
    )
    is
    begin
       if  p_condition is null
       or  p_condition = false
       then
           if p_error_id between -20999 and -20000
           then
              raise_application_error(p_error_id, p_message);
           else 
              raise_application_error(-20000, p_message); 
           end if;
       end if;
    end;

--------------------------------------------------------------------------------
    procedure require(
     p_condition        in    boolean
    ,p_message          in    varchar2
    ,p_error_id         in    pls_integer
    )
    is
    begin
          assert(p_condition, p_message, p_error_id);
    end;
    
--------------------------------------------------------------------------------
    procedure ensure(
     p_condition        in    boolean
    ,p_message          in    varchar2
    ,p_error_id         in    pls_integer
    )
    is
    begin
           assert(p_condition, p_message, p_error_id);
    end;


--------------------------------------------------------------------------------
    procedure log(
      p_message      in   varchar2
     ,p_plsql_unit   in   varchar2
     ,p_plsql_line   in   integer
    )
    is
    pragma autonomous_transaction;
    begin
        insert into hroug_log
        (
         message
        ,plsql_unit
        ,plsql_line
        )
        values
        (
         p_message
        ,p_plsql_unit
        ,p_plsql_line
        )
        ;
        commit;
    end;


--------------------------------------------------------------------------------
    procedure clear_log_tab
    is
    begin
        delete from hroug_log;
    end;


--------------------------------------------------------------------------------
    function log_tab_count
    return   pls_integer
    is
       v_cnt     pls_integer;
    begin
       select   count(*)
       into     v_cnt
       from     hroug_log hl
       ;
       
       return v_cnt;
    end;
    
    
--------------------------------------------------------------------------------
    function log_tab_filled_from(
     p_plsql_unit     in    varchar2
    )
    return boolean
    is
        v_cnt     pls_integer;
    begin
        select   count(*)
        into     v_cnt
        from     dual
        where    exists (
         select   null
         from     hroug_log hl
         where    instr(upper(hl.plsql_unit), upper(p_plsql_unit)) > 0
        )
        ;

        return v_cnt > 0;
    end;
    
    
--------------------------------------------------------------------------------
    function log_tab_contains(
     p_message     in    varchar2
    )
    return boolean
    is
        v_cnt     pls_integer;
    begin
        select   count(*)
        into     v_cnt
        from     dual
        where    exists (
         select   null
         from     hroug_log hl
         where    instr(upper(hl.message), upper(message)) > 0
        )
        ;
        
        return v_cnt > 0;
    end;


    
--------------------------------------------------------------------------------
  function who_called_me(p_stack_level in pls_integer default 1)  
  return   stack_data_tab_type
  is

    v_stack_data_tab  stack_data_tab_type;
  begin
   return bundle_stack_lines;
  end;

  

end hroug_utils_pkg;
/