create or replace package body app_pkg
is
--------------------------------------------------------------------------------
-- PRIVATE PROCEDURES AND FUNCTIONS
--------------------------------------------------------------------------------
    function get_type(
      p_anydata in anydata
    )
    return pls_integer
    is
         v_type ANYType;
         v_type_code pls_integer;
    begin
         v_type_code := p_anydata.gettype(v_type);
         return v_type_code;
    end;
    
--------------------------------------------------------------------------------    
    function is_number(
     p_anydata    in   anydata
    )
    return boolean
    is
    begin
        return get_type(p_anydata) = dbms_types.TYPECODE_NUMBER;
    end;
    
--------------------------------------------------------------------------------
    function is_varchar2(
     p_anydata   in   anydata
    )
    return boolean
    is
    begin
        return get_type(p_anydata) = dbms_types.TYPECODE_VARCHAR2;
    end;
--------------------------------------------------------------------------------
    function is_date(
     p_anydata   in   anydata
    )
    return boolean
    is
    begin
        return get_type(p_anydata) = dbms_types.TYPECODE_DATE;
    end;
--------------------------------------------------------------------------------
-- PRIVATE PROCEDURES AND FUNCTIONS
--------------------------------------------------------------------------------
   function get_number(
     p_anydata in anydata
   )
   return number
   is
   begin
         if is_number(p_anydata)
         then
             return p_anydata.accessNumber;
         end if;

         return null;
   end;

--------------------------------------------------------------------------------
   function get_date(
     p_anydata in anydata
   )
   return date
   is
   begin
         if is_date(p_anydata)
         then
             return p_anydata.accessDate;
         end if;

         return null;
   end;

--------------------------------------------------------------------------------
   function get_varchar2(
     p_anydata in anydata
   )
   return varchar2
   is
   begin
        if  is_varchar2(p_anydata)
        then
            return p_anydata.accessVarchar2;
        end if;

        return null;
   end;


--------------------------------------------------------------------------------
   function get_param_value(
    p_param_name     in   app_param.name%type
   )
   return anydata
   is
       cursor cur_app_param
       is
        select   aepw.param_value
        from     app_env_param_vw aepw
        where    aepw.param_name = p_param_name
        ;

        v_param_value anydata;
   begin
       open cur_app_param;

       fetch cur_app_param
       into  v_param_value;

       close cur_app_param;

       return v_param_value;

   end;

end;
/
