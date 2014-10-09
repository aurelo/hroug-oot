create or replace type body message_handler_ot
is

 overriding member procedure handle(     
     p_level   in  number
   , p_message in  varchar2
 )
 is
 begin
 --TODO
 /*
     if (self.threshold <= p_level)
     then
        self.process_request(p_message);
     end if;
     */
 
     if self.next_handler is null
     then
        return;
     end if;
 
     self.next_handler.handle(p_level, p_message);
 end handle;
end;
/
