create or replace package message_factory_pkg
as
   function  regulator_check_msg_handler
   return    message_handler_ot;

end;
