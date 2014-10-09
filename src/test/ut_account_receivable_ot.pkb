create or replace package body ut_account_receivable_ot
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
  
  procedure ut_comparison
  is
     v_ac1  account_receivable_ot;
     v_ac2  account_receivable_ot;
     v_ac3  account_receivable_ot;
     v_ac1b account_receivable_ot;
     
  begin
     v_ac1  := new account_receivable_ot(1, 100, interval '2' day, 'INTREST');
     v_ac1b := new account_receivable_ot(1, 100, interval '2' day, 'INTREST');
     v_ac2  := new account_receivable_ot(2, 100, interval '20' day, 'INTREST');
     v_ac3  := new account_receivable_ot(3, 100, interval '200' day, 'INTREST');
     
     utassert.this('Equal id''s should give equal objects', v_ac1 = v_ac1b);
     utassert.this('Lower id should give lower object', v_ac1 < v_ac2 and v_ac1 < v_ac3 and v_ac2 < v_ac3);
  end;
  
  
    procedure ut_to_string
    is
       v_ac  account_receivable_ot;
    begin
       v_ac  := new account_receivable_ot(1, 435, interval '2' day, 'INTREST');
       utAssert.this('Character representation of receivable should contain every important information'
                    , v_ac.to_string like '%1%' and 
                      v_ac.to_string like '%435%' and 
                      v_ac.to_string like '%2%' and
                      v_ac.to_string like '%INTREST%');
    end;
end;
/
