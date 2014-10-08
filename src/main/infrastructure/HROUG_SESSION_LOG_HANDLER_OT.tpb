CREATE OR REPLACE type body hroug_session_log_handler_ot
is
--------------------------------------------------------------------------------
  constructor function hroug_session_log_handler_ot(
     p_threshold   in  number
  ) return self as result
  is
  begin
      self.threshold := p_threshold;
      return;
  end;
  
--------------------------------------------------------------------------------
 overriding member procedure handle(
     p_level   in  number
   , p_message in  varchar2
   )
  is
     v_message_handler  message_handler_ot;
  begin
     if (p_level >= self.threshold)
     then
        self.process_request(p_message);
     end if;
     
     --CHANGE
     if self.next_handler is not null
     then
        self.next_handler.handle(p_level, p_message);
     end if;
        --v_message_handler := treat (self as message_handler_ot);  
        --v_message_handler.handle(p_level, p_message);
  end;

--------------------------------------------------------------------------------
  overriding  member procedure process_request(p_message in varchar2)
  is
      v_data_tab     hroug_utils_pkg.stack_data_tab_type;
      v_plsql_unit   user_objects.object_name%type;
      v_line_number  number;
  begin
      
      v_data_tab := hroug_utils_pkg.who_called_me;
      
      if v_data_tab.count = 0
      then
         v_plsql_unit  := 'NA';
         v_line_number := -1;
      else
         v_plsql_unit  := v_data_tab(v_data_tab.last).object_name;
         v_line_number := v_data_tab(v_data_tab.last).line_number;
      end if;
      
      hroug_utils_pkg.log(p_message, v_plsql_unit, v_line_number);

  end;
end;
/
