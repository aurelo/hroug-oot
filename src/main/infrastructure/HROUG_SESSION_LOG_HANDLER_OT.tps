create or replace type hroug_session_log_handler_ot under message_handler_ot(
  constructor function hroug_session_log_handler_ot(
     p_threshold   in  number
  ) return self as result
  
,overriding member procedure handle(
     p_level   in  number
   , p_message in  varchar2
   )
  
,overriding  member procedure process_request(p_message in varchar2)
)
/