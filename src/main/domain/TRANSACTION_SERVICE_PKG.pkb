create or replace package body transaction_service_pkg
as
--------------------------------------------------------------------------------
-- PRIVATE PROCEDURES AND FUNCTIONS
--------------------------------------------------------------------------------
      procedure enqueue_payment_event(
      p_payment_info    in   payment_ot
    )
    is
       queue_options       dbms_aq.enqueue_options_t;
       message_properties  dbms_aq.message_properties_t;
       message_id raw(16);
    begin
   
      dbms_aq.enqueue
      ( queue_name         => payment_queue_creator_pkg.get_payment_queue_name
      , enqueue_options    => queue_options
      , message_properties => message_properties
      , payload            => p_payment_info
      , msgid              => message_id
      );
      commit;
    end;
--------------------------------------------------------------------------------
-- PUBLIC PROCEDURES AND FUNCTIONS
--------------------------------------------------------------------------------
    procedure payment(
     p_from_account    in    varchar2
    ,p_amount          in    number
    )
    is
    begin
        -- domain logic left out because it would be too complex and  is 
        -- irrelevant for example
        hroug_utils_pkg.log('Transfering '||p_amount||' from '||p_from_account, $$plsql_unit, $$plsql_line);
        
        enqueue_payment_event(new payment_ot(p_from_account, p_amount));
        
        commit;
    end;
end transaction_service_pkg;
/