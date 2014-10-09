create or replace type body email_handler_ot 
is

  constructor function email_handler_ot(
     p_threshold   in  number
    ,p_email       in  varchar2
  ) return self as result
  is
  begin
     self.threshold := p_threshold;
     self.email     := p_email;
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
        --v_message_handler :=  treat (self as message_handler_ot);  
        --v_message_handler.handle(p_level, p_message);
  end;

--------------------------------------------------------------------------------
  overriding  member procedure process_request(p_message in varchar2)
  is
  begin
      -- Needs to be replaced with code that sends email 
      dbms_output.put_line ('SENDING email to '||self.email||': '||p_message);
  end;
  
end;
/
