CREATE OR REPLACE package payment_queue_creator_pkg
as
/*******************************************************************************
 Contains infrastructure for creating payment queue as well as couple of
 queue subscribers.
 Infrastructure is used to demonstrate Oracle Advanced Queuing API and is
 used by transaction service      
 <p>
 Package is distributed with example code for lecture Oracle Object Types given
 on HROUG 19(@link www.hroug.hr) conference. 

%author Zlatko Gudasiæ

CHANGE HISTORY (last one on top!)

When         Who 
dd.mm.yyyy   What
================================================================================
13.08.2014   Zlatko Gudasiæ         
             Initial creation
             
*******************************************************************************/
/**-----------------------------------------------------------------------------
payment_queue_exists:
 Checks if payment queue exists
------------------------------------------------------------------------------*/
   function payment_queue_exists
   return   boolean;
   
/**-----------------------------------------------------------------------------
payment_queue_exists:
 Checks if payment queue table exists
------------------------------------------------------------------------------*/
   function payment_queue_table_exists
   return   boolean;
   
/**-----------------------------------------------------------------------------
get_payment_queue_name:
 Returns payment queue name
------------------------------------------------------------------------------*/
   function get_payment_queue_name
   return   user_objects.object_name%type;
   
/**-----------------------------------------------------------------------------
create_and_start_payment_queue:
 Creates and starts payment queue used in transaction service
------------------------------------------------------------------------------*/
   procedure create_and_start_payment_queue;

/**-----------------------------------------------------------------------------
drop_payment_queue:
 Drops payment queue and surrounding infrastructure
------------------------------------------------------------------------------*/
   procedure drop_payment_queue;


/**-----------------------------------------------------------------------------
payment_queue_sub_exists:
 Checks if queue subscribers exists
 
@param p_subscriber_name  name of queue subscriber
------------------------------------------------------------------------------*/   
   function payment_queue_sub_exists(
    p_subscriber_name     in    user_objects.object_name%type
   )
   return   boolean;

/**-----------------------------------------------------------------------------
create_queue_subscribers:
 Registers payment queue subscribers
------------------------------------------------------------------------------*/   
   procedure create_queue_subscribers;
   
/**-----------------------------------------------------------------------------
drop_queue_subscribers:
 Drops payment queue subscribers
------------------------------------------------------------------------------*/   
   procedure drop_queue_subscribers;
   
/**-----------------------------------------------------------------------------
get_sms_sub_name:
 Returns name of sms payment queue subscriber name
------------------------------------------------------------------------------*/
   function get_sms_sub_name
   return   user_objects.object_name%type;

/**-----------------------------------------------------------------------------
get_regulator_check_sub_name:
 Returns name of regulator check payment queue subscriber name
------------------------------------------------------------------------------*/   
   function get_regulator_check_sub_name
   return   user_objects.object_name%type;

end;
/
