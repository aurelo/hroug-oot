-------------------------------------------------------------------------------- 
-- TYPE SPECIFICATION
--------------------------------------------------------------------------------
create or replace type account_receivable_ot as object(
 id          integer
,amount      number
,age         interval day(9) to second(0)
,type        varchar2(16)
,member function  to_string
 return varchar2
,final member procedure output
,map member  function compare_ids return integer
)
/
-------------------------------------------------------------------------------- 
-- TYPE BODY
--------------------------------------------------------------------------------
create or replace type body account_receivable_ot
as
 member function  to_string
 return varchar2
 is
 begin
    return 'receivable id: '||self.id
         ||' of type: '||self.type
         ||' with amount: '||self.amount
         ||' old: '||extract (DAY from self.age)||' days';
 end;
 
 final member procedure output
 is
 begin
    dbms_output.put_line(self.to_string);   
 end;
 
 map member function compare_ids 
 return integer
 is
 begin
    return id;
 end;
end;
/
-------------------------------------------------------------------------------- 
-- TABLE TYPE
--------------------------------------------------------------------------------
create or replace type account_receivable_tt
is table of account_receivable_ot
/



