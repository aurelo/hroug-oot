create or replace package body message_factory_pkg
as

--------------------------------------------------------------------------------
   function  regulator_check_msg_handler
   return    message_handler_ot
   is
       v_email_handler     message_handler_ot;
       v_output_handler    message_handler_ot;
       v_hrog_log_handler  message_handler_ot;
   begin
       v_email_handler    := new email_handler_ot(
                        app_pkg.get_number(app_pkg.get_param_value('REGULATOR_CHECK_EMAIL_THRESHOLD')) 
                       ,app_pkg.get_varchar2(app_pkg.get_param_value('REGULATOR_CHECK_EMAIL'))
                        );
       v_output_handler   := output_handler_ot(0);
       v_hrog_log_handler := hroug_session_log_handler_ot(0);
       
       v_email_handler.next_handler  := v_output_handler;
       v_output_handler.next_handler := v_hrog_log_handler;
       
       return v_email_handler;
   end;

end;
