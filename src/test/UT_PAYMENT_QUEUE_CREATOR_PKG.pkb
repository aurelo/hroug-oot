create or replace package body ut_payment_queue_creator_pkg
as
   procedure ut_setup
   is
   begin
       null;
   end;
   
   procedure ut_teardown
   is
   begin
       null;
   end;
   
   procedure ut_create
   is
   begin
       payment_queue_creator_pkg.create_and_start_payment_queue;
       utassert.this('Should create queue', payment_queue_creator_pkg.payment_queue_exists);
       utassert.this('Should create queue table', payment_queue_creator_pkg.payment_queue_table_exists);
   end;
   
   
   procedure ut_idempotent_create
   is
   begin
       payment_queue_creator_pkg.create_and_start_payment_queue;
       utassert.this('Should create queue', payment_queue_creator_pkg.payment_queue_exists);
       utassert.this('Should create queue table', payment_queue_creator_pkg.payment_queue_table_exists);
       
       payment_queue_creator_pkg.create_and_start_payment_queue;
       utassert.this('Queue should exists after repeated create operation', payment_queue_creator_pkg.payment_queue_exists);
       utassert.this('Queue table should exists after repeated create operation', payment_queue_creator_pkg.payment_queue_table_exists);
   end;
   
   procedure ut_drop
   is
   begin
       payment_queue_creator_pkg.drop_payment_queue;
       utassert.this('Queue should not exists', not payment_queue_creator_pkg.payment_queue_exists);
       utassert.this('Queue table should not exists', not payment_queue_creator_pkg.payment_queue_table_exists);
   end;
   
   procedure ut_create_drop_create
   is
   begin
       payment_queue_creator_pkg.create_and_start_payment_queue;
       utassert.this('Create should create queue', payment_queue_creator_pkg.payment_queue_exists);
       utassert.this('Create should create queue table', payment_queue_creator_pkg.payment_queue_table_exists);
       
       payment_queue_creator_pkg.drop_payment_queue;
       utassert.this('After drop queue should not exists', not payment_queue_creator_pkg.payment_queue_exists);
       utassert.this('After drop queue table should not exists', not payment_queue_creator_pkg.payment_queue_table_exists);
       
       payment_queue_creator_pkg.create_and_start_payment_queue;
       utassert.this('After recreate queue should exists again', payment_queue_creator_pkg.payment_queue_exists);
       utassert.this('After recreate queue table should exists again', payment_queue_creator_pkg.payment_queue_table_exists);
   end;
   
   procedure ut_idempotent_sub_creation
   is
   begin
       payment_queue_creator_pkg.create_queue_subscribers;
       utassert.this('Queue subscriber should exists'
                   , payment_queue_creator_pkg.payment_queue_sub_exists(payment_queue_creator_pkg.get_sms_sub_name)
                 and payment_queue_creator_pkg.payment_queue_sub_exists(payment_queue_creator_pkg.get_regulator_check_sub_name)
                   );
                   
       payment_queue_creator_pkg.create_queue_subscribers;
       utassert.this('Queue subscriber should also exists after recreation'
                   , payment_queue_creator_pkg.payment_queue_sub_exists(payment_queue_creator_pkg.get_sms_sub_name)
                 and payment_queue_creator_pkg.payment_queue_sub_exists(payment_queue_creator_pkg.get_regulator_check_sub_name)
                   );
         
       payment_queue_creator_pkg.drop_queue_subscribers;
       utassert.this('Queue subscriber should NOT exists after drop'
                   , not payment_queue_creator_pkg.payment_queue_sub_exists(payment_queue_creator_pkg.get_sms_sub_name)
                 and not payment_queue_creator_pkg.payment_queue_sub_exists(payment_queue_creator_pkg.get_regulator_check_sub_name)
                   );
                 
                   
       payment_queue_creator_pkg.create_queue_subscribers;
       utassert.this('Queue subscriber should exists after new creation'
                   , payment_queue_creator_pkg.payment_queue_sub_exists(payment_queue_creator_pkg.get_sms_sub_name)
                 and payment_queue_creator_pkg.payment_queue_sub_exists(payment_queue_creator_pkg.get_regulator_check_sub_name)
                   );
   end;
   

end;
/
