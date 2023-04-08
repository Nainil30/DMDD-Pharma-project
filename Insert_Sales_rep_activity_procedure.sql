
set serveroutput on;
Create or replace PROCEDURE insert_sales_rep_activity
(
MEETING_ID_V IN dev1.sales_rep_activity.MEETING_ID%TYPE,
CUSTOMER_NAME_V IN dev1.sales_rep_activity.CUSTOMER_NAME%TYPE,
INTERACTION_TYPE_V IN dev1.sales_rep_activity.INTERACTION_TYPE%TYPE,
CUSTOMER_TYPE_V IN dev1.sales_rep_activity.CUSTOMER_TYPE%TYPE,
INTERACTION_DATE_V IN dev1.sales_rep_activity.interaction_date%TYPE,
INTERACTION_DURATION_V IN dev1.sales_rep_activity.INTERACTION_DURATION%TYPE,

ADDRESS_LINE_1_V IN dev1.sales_rep_activity.ADDRESS_LINE_1%TYPE,
ADDRESS_LINE_2_V IN dev1.sales_rep_activity.ADDRESS_LINE_2%TYPE,
CITY_V IN dev1.sales_rep_activity.CITY%TYPE,
REGION_V IN dev1.sales_rep_activity.REGION%TYPE,
STATE_V IN dev1.sales_rep_activity.STATE%TYPE,
ZIPCODE_V IN dev1.sales_rep_activity.ZIPCODE%TYPE,
COUNTRY_V IN dev1.sales_rep_activity.country%TYPE,
MOBILE_NO_V IN dev1.sales_rep_activity.MOBILE_NO%TYPE,
EMAIL_V IN dev1.sales_rep_activity.EMAIL_ID%TYPE,
CUSTOMER_FLAG_V IN dev1.sales_rep_activity.CUSTOMER_CONVERTED_FLAG%TYPE,

CUSTOMER_id_V IN dev1.CUSTOMER.ID%TYPE
)

AS
SALESREP_ID_V dev1.sales_rep_activity.SALESREP_ID%TYPE;
WAREHOUSE_V dev1.sales_representative.ref_warehouse_id%TYPE;

BEGIN
--SALESREP_ID_V := substr(MEETING_ID_V, 2);
--SALESREP_ID_V := substr(sys_context('USERENV', 'SESSION_USER'), 2);
--SALESREP_ID_V := substr(sys_context('USERENV', 'SESSION_USER'), 2);
select to_number(substr(username, 2)) into SALESREP_ID_V from all_users where username = sys_context('USERENV', 'SESSION_USER');
--dbms_output.put_line(predicate);  
     INSERT INTO dev1.sales_rep_activity VALUES(MEETING_ID_V, SALESREP_ID_V, CUSTOMER_NAME_V, INTERACTION_TYPE_V, CUSTOMER_TYPE_V, INTERACTION_DATE_V, 
                INTERACTION_DURATION_V, 
                ADDRESS_LINE_1_V, ADDRESS_LINE_2_V, CITY_V, REGION_V, STATE_V, ZIPCODE_V, COUNTRY_V,  
                MOBILE_NO_V, EMAIL_V,
                CUSTOMER_FLAG_V);
      COMMIT;
     
    IF (CUSTOMER_FLAG_V = 'y') then 
    dbms_output.put_line('In Transaction Details');
       select ref_warehouse_id into WAREHOUSE_V from dev1.sales_representative where id = SALESREP_ID_V;
      dbms_output.put_line(WAREHOUSE_V); 
       dbms_output.put_line(SALESREP_ID_V); 
      
         INSERT INTO dev1.customer
         VALUES(CUSTOMER_id_V, MEETING_ID_V, WAREHOUSE_V, CUSTOMER_NAME_V, CUSTOMER_type_V);
         COMMIT;
      
    
       
        INSERT INTO dev1.customer_address
         VALUES(CUSTOMER_id_V,
                 ADDRESS_LINE_1_V,ADDRESS_LINE_2_V, CITY_V ,REGION_V, STATE_V, ZIPCODE_V, COUNTRY_V);
         COMMIT;
         
         INSERT INTO dev1.customer_contact
         VALUES(CUSTOMER_id_V, MOBILE_NO_V, EMAIL_V);
         COMMIT;   

    END IF;
EXCEPTION when no_data_found then
     dbms_output.put_line('Incorrect Transaction Details');
END;


select substr(username, 2) from all_users where username = sys_context('USERENV', 'SESSION_USER');

execute insert_sales_rep_activity (4323003, 'CVS_Pharma', 'email', 'doctor', sysdate , 65, '65A', 'Huntington avenue', 'Boston', 'Roxbury', 'MA', 02120 , 'USA', '3698759544', 'CVS@gmail.com', 'y', 123880); 


execute insert_sales_rep_activity (5323003, 'CVS_Pharma', 'inperson', 'doctor', sysdate, 65, '65A', 'Huntington avenue', 'Boston', 'Roxbury', 'MA', 02120 , 'USA', '3698759544', 'CVS@gmail.com', 'y', 123480);


--Create the salesperson 
Create user S323002 identified by Salesrep_323002;
grant create session to S323002;
grant unlimited tablespace to S323002;
grant select, insert, update, delete on dev1.sales_rep_activity to S323002;
grant select, insert, update, delete on dev1.customer to S323002;
grant select, insert, update, delete on dev1.customer_address to S323002;
grant select, insert, update, delete on dev1.customer_contact to S323002;
grant select on dev1.sales_representative to S323002;
grant execute on insert_sales_rep_activity to S323002;