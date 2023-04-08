--Create Function
create or replace function row_level_security (
object_schema in varchar2,
object_name in varchar2
)
Return Varchar2
as 
predicate varchar2(4000);
begin 
predicate := 'customer_id = substr(sys_context(''USERENV'', ''SESSION_USER''), 2)';
return predicate;
end;
--Assign Policy
begin 
sys.DBMS_RLS.Add_Policy (
object_schema => 'dev1',
object_name => 'invoice_v',
policy_name => 'row_level_security',
function_schema => 'dev1',
policy_function => 'row_level_security',
statement_types => 'select'
);
End;

--Drop the function
drop function row_level_security; 

--Drop policy
begin 
DBMS_RLS.drop_Policy (
object_schema => 'dev1',
object_name => 'invoice_v',
policy_name => 'row_level_security'
);
End;

--Grant The execute DBMS_RLS to Dev1
grant execute on DBMS_RLS to dev1;

--Create User and assigning the role  
Create user C123007 identified by Customer_123007;
grant create session to C123007;
grant select on dev1.invoice_v to C123007;