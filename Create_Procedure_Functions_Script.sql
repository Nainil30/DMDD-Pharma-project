--Script to run PLSQL Stored Procedure block for the following :

--Sales_Representative_Activity :
--	This procedure takes input from sales representative and inputs data for all parameters of a meeting
--	This procedure checks for conversion flag and edits all tables (customer, custmer_address,customer_contact)

/*supreet recheck
create or replace PROCEDURE insert_sales_rep_activity
(
SALESREP_ID sales_rep_activity.SALESREP_ID%TYPE,
CUSTOMER_NAME_V IN sales_rep_activity.CUSTOMER_NAME%TYPE,
INTERACTION_TYPE_V IN sales_rep_activity.INTERACTION_TYPE%TYPE,
CUSTOMER_TYPE_V IN sales_rep_activity.CUSTOMER_TYPE%TYPE,
INTERACTION_DATE_V IN sales_rep_activity.interaction_date%TYPE,
INTERACTION_DURATION_V IN sales_rep_activity.INTERACTION_DURATION%TYPE,
ADDRESS_LINE_1_V IN sales_rep_activity.ADDRESS_LINE_1%TYPE,
ADDRESS_LINE_2_V IN sales_rep_activity.ADDRESS_LINE_2%TYPE,
CITY_V IN sales_rep_activity.CITY%TYPE,
REGION_V IN sales_rep_activity.REGION%TYPE,
STATE_V IN sales_rep_activity.STATE%TYPE,
ZIPCODE_V IN sales_rep_activity.ZIPCODE%TYPE,
COUNTRY_V IN sales_rep_activity.country%TYPE,
MOBILE_NO_V IN sales_rep_activity.MOBILE_NO%TYPE,
EMAIL_V IN sales_rep_activity.EMAIL_ID%TYPE,
CUSTOMER_FLAG_V IN sales_rep_activity.CUSTOMER_CONVERTED_FLAG%TYPE
)
AS
Salesrep_id_v sales_rep_activity.SALESREP_ID%TYPE;
WAREHOUSE_V sales_representative.ref_warehouse_id%TYPE;
exc_interaction_type exception;
V_INTERACTION_TYPE sales_rep_activity.INTERACTION_TYPE%TYPE;
EXC_CUSTOMER_TYPE EXCEPTION;
V_CUSTOMER_TYPE sales_rep_activity.CUSTOMER_TYPE%TYPE;
EXC_INTERACTION_DURATION EXCEPTION;
V_INTERACTION_DURATION sales_rep_activity.INTERACTION_DURATION%TYPE;
EXC_INVALID_REP_ID EXCEPTION;
EXC_ADDRESS EXCEPTION;
EXC_PHONE_NUMBER EXCEPTION;
EXC_CUSTOMER_CONVERTED EXCEPTION;
V_CUSTOMER_CONVERTED sales_rep_activity.CUSTOMER_CONVERTED_FLAG%TYPE;
BEGIN
	select INTERACTION_TYPE_V INTO V_INTERACTION_TYPE from DUAL;
	select CUSTOMER_TYPE_V INTO V_CUSTOMER_TYPE FROM DUAL;
	select INTERACTION_DURATION_V INTO V_CUSTOMER_CONVERTED from dual;
	SELECT CUSTOMER_FLAG_V INTO V_CUSTOMER_CONVERTED FROM DUAL;
    select count(*) into Salesrep_id_v from sales_representative where id=SALESREP_ID;
    
    
    
	if SALESREP_ID_V=0 THEN
		raise EXC_INVALID_REP_ID;
	end if;

	IF lower(V_INTERACTION_TYPE) not in ('oncall','inperson','email')  THEN
		RAISE exc_interaction_type;
	END IF;


	IF lower(V_CUSTOMER_TYPE) not in ('doctor','hospital','pharmacy') THEN
        RAISE EXC_CUSTOMER_TYPE;
	END IF;

	IF INSTR(INTERACTION_DURATION_V, '.')>0 THEN
		RAISE EXC_INTERACTION_DURATION;
    END IF;

	IF length(MOBILE_NO_V) != 10 THEN
        RAISE EXC_PHONE_NUMBER;
    END IF;

	IF lower(V_CUSTOMER_CONVERTED) not in ('y','n') THEN
		RAISE EXC_CUSTOMER_CONVERTED;
	END IF;
    
    
     INSERT INTO sales_rep_activity VALUES(SALES_REP_ACTIVITY_SEQ.nextval, SALESREP_ID_V, initcap(CUSTOMER_NAME_V), upper(INTERACTION_TYPE_V), upper(CUSTOMER_TYPE_V), INTERACTION_DATE_V, 
                INTERACTION_DURATION_V, 
                initcap(ADDRESS_LINE_1_V), initcap(ADDRESS_LINE_2_V), initcap(CITY_V), initcap(REGION_V), upper(STATE_V), ZIPCODE_V, upper(COUNTRY_V),  
                MOBILE_NO_V, lower(EMAIL_V),
                upper(CUSTOMER_FLAG_V));
      COMMIT;

   IF (lower(CUSTOMER_FLAG_V) = 'y') then 
       select ref_warehouse_id into WAREHOUSE_V from sales_representative where id = SALESREP_ID_V;

         INSERT INTO customer
         VALUES(CUSTOMER_SEQ.nextval, SALES_REP_ACTIVITY_SEQ.currval, WAREHOUSE_V, initcap(CUSTOMER_NAME_V), upper(CUSTOMER_type_V));
         COMMIT;

        INSERT INTO customer_address
         VALUES(CUSTOMER_SEQ.currval,
                 initcap(ADDRESS_LINE_1_V) ,initcap(ADDRESS_LINE_2_V), initcap(CITY_V) ,initcap(REGION_V), upper(STATE_V), ZIPCODE_V, upper(COUNTRY_V));
         COMMIT;

         INSERT INTO customer_contact
         VALUES(CUSTOMER_SEQ.currval, MOBILE_NO_V, lower(EMAIL_V));
         COMMIT;   

   END IF;
EXCEPTION 

		WHEN EXC_INVALID_REP_ID THEN
           DBMS_OUTPUT.PUT_LINE('Entered sales representative id is incorrect');
		WHEN exc_interaction_type THEN
           DBMS_OUTPUT.PUT_LINE('Incorrect interaction type correct interaction type should be oncall or inperson or email');
        WHEN EXC_CUSTOMER_TYPE THEN
           DBMS_OUTPUT.PUT_LINE('Incorrect customer type correct customer type should be doctor or pharmacy or hospital');
        WHEN EXC_INTERACTION_DURATION THEN
         DBMS_OUTPUT.PUT_LINE('Interaction Duration should be in minutes');
		 WHEN EXC_PHONE_NUMBER THEN
           DBMS_OUTPUT.PUT_LINE('Mobile phone number should be 10 digit number');
        WHEN EXC_CUSTOMER_CONVERTED THEN
         DBMS_OUTPUT.PUT_LINE('Customer converted flag should be either y or n');
		when no_data_found then
			dbms_output.put_line('Incorrect Customer Details');
END;
*/




--Internal_Transaction :
--This procedure takes input from warehouse manager  by accepting parameters(warehouse_from ,warehouse_to,product_id,quantity) 
--This procedure updates stock present in inventory automatically  

create or replace Procedure insert_int_tran
    (war_fr internal_transaction.warehouse_from%type,
    war_to internal_transaction.warehouse_to%type,
    prod_id internal_transaction.product_id%type,
    tran_date internal_transaction.date_time%type,
    qty internal_transaction.quantity%type) --prod_id int, qty int
As
    old_qty_fr internal_transaction.product_id%type;
    new_qty_fr internal_transaction.product_id%type;
    old_qty_to internal_transaction.product_id%type;
    new_qty_to internal_transaction.product_id%type;
	exc_warehouse exception;
	exc_warehouse1 exception;
	exc_product exception;
    exc_same_warehouse exception;
	c_name int;
	c_name1 int;
	c_prod int;

Begin 

		select count(*) into c_name  from warehouse where id=war_fr;
		select count(*) into c_name1  from warehouse where id=war_to;
		select count(*) into c_prod  from product where id=prod_id;

	if c_name=0 THEN
		raise exc_warehouse;
	end IF;

	if c_name1=0 THEN
		raise exc_warehouse1;
	end if;

	if c_prod=0 THEN
		raise exc_product;
	end if; 

    if (war_fr = war_to) THEN
        raise exc_SAME_WAREHOUSE;
    end if;


        select product_quantity into old_qty_fr from inventory where warehouse_id = war_fr and  product_id = prod_id;
        select product_quantity into old_qty_to from inventory where warehouse_id = war_to and  product_id = prod_id;
        new_qty_fr := old_qty_fr - qty;
        new_qty_to := old_qty_to + qty;
        
    If (old_qty_fr >= qty) then 
    
       insert into internal_transaction values (internAL_TRANSACTION_SEQ.NEXTVAL, war_fr, war_to, prod_id, tran_date, qty); 
        commit;
        update inventory set product_quantity = new_qty_fr where product_id = prod_id and warehouse_id = war_fr;
       commit;
        update inventory set product_quantity = new_qty_to where product_id = prod_id and warehouse_id = war_to;
        commit; 
    end if;

	if (old_qty_fr < qty) then 
        dbms_output.put_line('Maximum Quantity Available in Warehouse ' ||  war_fr || ' is ' || old_qty_fr);
    end if;



EXCEPTION 
	    WHEN exc_warehouse THEN
           DBMS_OUTPUT.PUT_LINE('WAREHOUSE FROM ID INVALID');
        WHEN exc_warehouse1 THEN
           DBMS_OUTPUT.PUT_LINE('WAREHOUSE TO ID INVALID');
        WHEN exc_product THEN
         DBMS_OUTPUT.PUT_LINE('INVALID PRODUCT_ID');
        WHEN exc_same_warehouse THEN
         DBMS_OUTPUT.PUT_LINE('WAREHOUSE SOURCE AND DESTINATION CANNOT BE SAME');
        when others then
         DBMS_OUTPUT.PUT_LINE('INVALID TRANSACTION');
End;
/



--External_Transaction :
--This procedure takes input from sales representative by accepting paameters(product_id,customer_id,transaction_type,quantity) 
--and place transaction based on return and purchase and updates 

create or replace Procedure insert_Ext_tran(
prod_id external_transaction.product_id%type, 
cust_id external_transaction.customer_id%type ,
trans_type external_transaction.transaction_type%type, 
dt_time external_transaction.date_time%type,
qnt external_transaction.quantity%type
)	
As
    ref_war customer.ref_warehouse_id%type;
    sales_rep sales_representative.id%type;
    old_qty inventory.product_quantity%type;
    new_qty inventory.product_quantity%type;
    inv_val inventory.product_quantity%type;
	exc_product exception;
	exc_customer exception;
    exc_insufficient_qty exception;
	exc_incorrect_tran_type exception;
    c_product int;
	c_customer integer;


Begin
	select count(*) into c_product from product where id=prod_id;
	select count(*) into c_customer from customer where id=cust_id;

	if c_product=0 THEN
		raise exc_product;
	end if;

	if c_customer=0 THEN
		raise exc_customer;
	end if;


	if lower(trans_type) not in ('p', 'r') then
        raise exc_incorrect_tran_type;
    end if; 
    
    select ref_warehouse_id into ref_war from customer where id = cust_id;
    select id into sales_rep from sales_representative where ref_warehouse_id = ref_war;
    select product_quantity into inv_val from inventory where product_id = prod_id and warehouse_id = ref_war; 
    select product_quantity into old_qty from inventory where product_id = prod_id and warehouse_id = ref_war;
        
	if (inv_val < qnt and lower(trans_type) = 'p') then
        raise exc_insufficient_qty;
    end if;
    
	if (inv_val >= qnt and lower(trans_type) = 'p') then 
        insert into external_transaction values (EXTERNAL_TRANSACTION_SEQ.NEXTVAL, prod_id, cust_id, upper(trans_type), dt_time ,qnt);
        commit;
        new_qty := old_qty - qnt;
        update inventory set product_quantity = new_qty where product_id = prod_id and warehouse_id = ref_war;
        commit;
	end if;

	if (lower(trans_type) = 'r') then 
        insert into external_transaction values (EXTERNAL_TRANSACTION_SEQ.NEXTVAL, prod_id, cust_id, upper(trans_type), dt_time ,qnt);
        commit;
        new_qty := old_qty + qnt;
        update inventory set product_quantity = new_qty where product_id = prod_id and warehouse_id = ref_war;
        commit;
    end if;

 exception
		WHEN exc_product THEN
           DBMS_OUTPUT.PUT_LINE('Entered product id is incorrect');
        WHEN exc_customer THEN
           DBMS_OUTPUT.PUT_LINE('Entered customer id is incorrect');
        WHEN exc_insufficient_qty THEN
           DBMS_OUTPUT.PUT_LINE('Maximum '|| inv_val || ' quantity can be purchased. Please inform warehouse manager for more quantity required');
       WHEN exc_incorrect_tran_type THEN
           DBMS_OUTPUT.PUT_LINE('Incorrect Transaction Type transaction type should be p for purachase and r for return');
		when others then 
			dbms_output.put_line('Incorrect Transaction Details');
end;
/


-- INVENTORY UPDATE:
--	This procedure takes input from warehouse manager(warehouse_id,product_id,quantity) and updates inventory 
CREATE OR REPLACE PROCEDURE UPDATE_INVENTORY
(
WAR_ID INVENTORY.WAREHOUSE_ID%TYPE, 
PROD_ID INVENTORY.PRODUCT_ID%TYPE,
QTY INVENTORY.PRODUCT_QUANTITY%TYPE
) 
AS 
OLD_QTY INVENTORY.PRODUCT_QUANTITY%TYPE;
NEW_QTY INVENTORY.PRODUCT_QUANTITY%TYPE;
EXC_WAREHOUSE EXCEPTION;
EXC_PRODUCT EXCEPTION;
C_NAME INT;
P_NAME INT;

BEGIN 
SELECT COUNT(*) INTO C_NAME FROM WAREHOUSE WHERE ID = WAR_ID;
SELECT COUNT(*) INTO P_NAME FROM PRODUCT WHERE ID = PROD_ID;

IF C_NAME=0 THEN
		RAISE EXC_WAREHOUSE;
	END IF;

IF P_NAME=0 THEN
		RAISE EXC_PRODUCT;
	END IF;

SELECT PRODUCT_QUANTITY INTO OLD_QTY FROM INVENTORY  WHERE PRODUCT_ID = PROD_ID AND WAREHOUSE_ID = WAR_ID;
NEW_QTY := OLD_QTY + QTY;
UPDATE INVENTORY SET PRODUCT_QUANTITY = NEW_QTY WHERE PRODUCT_ID = PROD_ID AND WAREHOUSE_ID = WAR_ID;
COMMIT;

EXCEPTION
        WHEN EXC_WAREHOUSE THEN
        DBMS_OUTPUT.PUT_LINE('INVALID WAREHOUSE ID');
        WHEN EXC_PRODUCT THEN
        DBMS_OUTPUT.PUT_LINE('INVALID PRODUCT_ID');
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('INVALID INPUT');
END;
/

--Supreet recheck
--	This package takes input from sales representative and inputs data for all parameters of a meeting
--	This package checks for conversion flag and edits all tables (customer, custmer_address,customer_contact)
create or replace PROCEDURE insert_sales_rep_activity
CREATE OR REPLACE PACKAGE CUSTOMER_ONBOARDING 
AS
 PROCEDURE ONBOARD_DETAILS;
 PROCEDURE insert_sales_rep_activity
(
SALESREP_ID_V  sales_rep_activity.SALESREP_ID%TYPE,
CUSTOMER_NAME_V IN  sales_rep_activity.CUSTOMER_NAME%TYPE,
INTERACTION_TYPE_V IN  sales_rep_activity.INTERACTION_TYPE%TYPE,
CUSTOMER_TYPE_V IN  sales_rep_activity.CUSTOMER_TYPE%TYPE,
INTERACTION_DATE_V IN  sales_rep_activity.interaction_date%TYPE,
INTERACTION_DURATION_V IN  sales_rep_activity.INTERACTION_DURATION%TYPE,
ADDRESS_LINE_1_V IN  sales_rep_activity.ADDRESS_LINE_1%TYPE,
ADDRESS_LINE_2_V IN  sales_rep_activity.ADDRESS_LINE_2%TYPE,
CITY_V IN  sales_rep_activity.CITY%TYPE,
REGION_V IN  sales_rep_activity.REGION%TYPE,
STATE_V IN  sales_rep_activity.STATE%TYPE,
ZIPCODE_V IN  sales_rep_activity.ZIPCODE%TYPE,
COUNTRY_V IN  sales_rep_activity.country%TYPE,
MOBILE_NO_V IN  sales_rep_activity.MOBILE_NO%TYPE,
EMAIL_V IN  sales_rep_activity.EMAIL_ID%TYPE,
CUSTOMER_FLAG_V IN  sales_rep_activity.CUSTOMER_CONVERTED_FLAG%TYPE
);
END CUSTOMER_ONBOARDING;
/
CREATE OR REPLACE PACKAGE BODY CUSTOMER_ONBOARDING AS 
PROCEDURE insert_sales_rep_activity
PROCEDURE insert_sales_rep_activity
(
SALESREP_ID sales_rep_activity.SALESREP_ID%TYPE,
CUSTOMER_NAME_V IN sales_rep_activity.CUSTOMER_NAME%TYPE,
INTERACTION_TYPE_V IN sales_rep_activity.INTERACTION_TYPE%TYPE,
CUSTOMER_TYPE_V IN sales_rep_activity.CUSTOMER_TYPE%TYPE,
INTERACTION_DATE_V IN sales_rep_activity.interaction_date%TYPE,
INTERACTION_DURATION_V IN sales_rep_activity.INTERACTION_DURATION%TYPE,
ADDRESS_LINE_1_V IN sales_rep_activity.ADDRESS_LINE_1%TYPE,
ADDRESS_LINE_2_V IN sales_rep_activity.ADDRESS_LINE_2%TYPE,
CITY_V IN sales_rep_activity.CITY%TYPE,
REGION_V IN sales_rep_activity.REGION%TYPE,
STATE_V IN sales_rep_activity.STATE%TYPE,
ZIPCODE_V IN sales_rep_activity.ZIPCODE%TYPE,
COUNTRY_V IN sales_rep_activity.country%TYPE,
MOBILE_NO_V IN sales_rep_activity.MOBILE_NO%TYPE,
EMAIL_V IN sales_rep_activity.EMAIL_ID%TYPE,
CUSTOMER_FLAG_V IN sales_rep_activity.CUSTOMER_CONVERTED_FLAG%TYPE
)
AS
Salesrep_id_v sales_rep_activity.SALESREP_ID%TYPE;
WAREHOUSE_V sales_representative.ref_warehouse_id%TYPE;
exc_interaction_type exception;
V_INTERACTION_TYPE sales_rep_activity.INTERACTION_TYPE%TYPE;
EXC_CUSTOMER_TYPE EXCEPTION;
V_CUSTOMER_TYPE sales_rep_activity.CUSTOMER_TYPE%TYPE;
EXC_INTERACTION_DURATION EXCEPTION;
V_INTERACTION_DURATION sales_rep_activity.INTERACTION_DURATION%TYPE;
EXC_INVALID_REP_ID EXCEPTION;
EXC_ADDRESS EXCEPTION;
EXC_PHONE_NUMBER EXCEPTION;
EXC_CUSTOMER_CONVERTED EXCEPTION;
V_CUSTOMER_CONVERTED sales_rep_activity.CUSTOMER_CONVERTED_FLAG%TYPE;
BEGIN
	select INTERACTION_TYPE_V INTO V_INTERACTION_TYPE from DUAL;
	select CUSTOMER_TYPE_V INTO V_CUSTOMER_TYPE FROM DUAL;
	select INTERACTION_DURATION_V INTO V_CUSTOMER_CONVERTED from dual;
	SELECT CUSTOMER_FLAG_V INTO V_CUSTOMER_CONVERTED FROM DUAL;
    select count(*) into Salesrep_id_v from sales_representative where id=SALESREP_ID;
    
    
    
	if SALESREP_ID_V=0 THEN
		raise EXC_INVALID_REP_ID;
	end if;

	IF lower(V_INTERACTION_TYPE) not in ('oncall','inperson','email')  THEN
		RAISE exc_interaction_type;
	END IF;


	IF lower(V_CUSTOMER_TYPE) not in ('doctor','hospital','pharmacy') THEN
        RAISE EXC_CUSTOMER_TYPE;
	END IF;

	IF INSTR(INTERACTION_DURATION_V, '.')>0 THEN
		RAISE EXC_INTERACTION_DURATION;
    END IF;

	IF length(MOBILE_NO_V) != 10 THEN
        RAISE EXC_PHONE_NUMBER;
    END IF;

	IF lower(V_CUSTOMER_CONVERTED) not in ('y','n') THEN
		RAISE EXC_CUSTOMER_CONVERTED;
	END IF;
    
    
     INSERT INTO sales_rep_activity VALUES(SALES_REP_ACTIVITY_SEQ.nextval, SALESREP_ID_V, initcap(CUSTOMER_NAME_V), upper(INTERACTION_TYPE_V), upper(CUSTOMER_TYPE_V), INTERACTION_DATE_V, 
                INTERACTION_DURATION_V, 
                initcap(ADDRESS_LINE_1_V), initcap(ADDRESS_LINE_2_V), initcap(CITY_V), initcap(REGION_V), upper(STATE_V), ZIPCODE_V, upper(COUNTRY_V),  
                MOBILE_NO_V, lower(EMAIL_V),
                upper(CUSTOMER_FLAG_V));
      COMMIT;

   IF (lower(CUSTOMER_FLAG_V) = 'y') then 
       select ref_warehouse_id into WAREHOUSE_V from sales_representative where id = SALESREP_ID_V;

         INSERT INTO customer
         VALUES(CUSTOMER_SEQ.nextval, SALES_REP_ACTIVITY_SEQ.currval, WAREHOUSE_V, initcap(CUSTOMER_NAME_V), upper(CUSTOMER_type_V));
         COMMIT;

        INSERT INTO customer_address
         VALUES(CUSTOMER_SEQ.currval,
                 initcap(ADDRESS_LINE_1_V) ,initcap(ADDRESS_LINE_2_V), initcap(CITY_V) ,initcap(REGION_V), upper(STATE_V), ZIPCODE_V, upper(COUNTRY_V));
         COMMIT;

         INSERT INTO customer_contact
         VALUES(CUSTOMER_SEQ.currval, MOBILE_NO_V, lower(EMAIL_V));
         COMMIT;   

   END IF;
EXCEPTION 

		WHEN EXC_INVALID_REP_ID THEN
           DBMS_OUTPUT.PUT_LINE('Entered sales representative id is incorrect');
		WHEN exc_interaction_type THEN
           DBMS_OUTPUT.PUT_LINE('Incorrect interaction type correct interaction type should be oncall or inperson or email');
        WHEN EXC_CUSTOMER_TYPE THEN
           DBMS_OUTPUT.PUT_LINE('Incorrect customer type correct customer type should be doctor or pharmacy or hospital');
        WHEN EXC_INTERACTION_DURATION THEN
         DBMS_OUTPUT.PUT_LINE('Interaction Duration should be in minutes');
		 WHEN EXC_PHONE_NUMBER THEN
           DBMS_OUTPUT.PUT_LINE('Mobile phone number should be 10 digit number');
        WHEN EXC_CUSTOMER_CONVERTED THEN
         DBMS_OUTPUT.PUT_LINE('Customer converted flag should be either y or n');
		when no_data_found then
			dbms_output.put_line('Incorrect Customer Details');
END;
PROCEDURE ONBOARD_DETAILS
AS
BEGIN
DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
DBMS_OUTPUT.PUT_LINE('TO ONBOARD CUSTOMER BELOW DETAILS OF CUSTOMER ARE REQUIRED');
DBMS_OUTPUT.PUT_LINE('CUSTOMER DETAILS');
DBMS_OUTPUT.PUT_LINE('CUSTOMER_NAME');
DBMS_OUTPUT.PUT_LINE('ADDRESS_LINE_1');
DBMS_OUTPUT.PUT_LINE('ADDRESS_LINE_2');
DBMS_OUTPUT.PUT_LINE('CITY');
DBMS_OUTPUT.PUT_LINE('REGION');
DBMS_OUTPUT.PUT_LINE('STATE');
DBMS_OUTPUT.PUT_LINE('ZIPCODE');
DBMS_OUTPUT.PUT_LINE('COUNTRY');
DBMS_OUTPUT.PUT_LINE('MOBILE_NO');
DBMS_OUTPUT.PUT_LINE('EMAIL');
DBMS_OUTPUT.PUT_LINE('INTERACTION_TYPE');
DBMS_OUTPUT.PUT_LINE('CUSTOMER_TYPE');
DBMS_OUTPUT.PUT_LINE('INTERACTION_DATE');
DBMS_OUTPUT.PUT_LINE('INTERACTION_DURATION');
DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
DBMS_OUTPUT.PUT_LINE('EXECUTE CUSTOMER_ONBOARD.INSERT_SALES_REP_ACTIVITY TO ONBOARD CUSTOMER');
END; 
END CUSTOMER_ONBOARDING; 
/


--Mahavir
--This procedure is used to calculate the profit from start of the year till todays date of every product this profit takes consideration
--of change in cost in this duration

create or replace procedure PRODUCTWISE_PROFIT 
as 
v_transaction_quantity external_transaction.quantity%type; 
v_transaction_quantity_p external_transaction.quantity%type;
v_transaction_quantity_r external_transaction.quantity%type;
v_profit external_transaction.quantity%type;
v_product_profit external_transaction.quantity%type;
Cursor c_ext_trans is select transaction_id, product_id, customer_id, transaction_type, date_time, quantity from external_transaction;
Cursor c_price_log is select * from (select price_table.id, price_table.name, price_table.old_cost_price, price_table.old_selling_price, 
        lag(price_table.date_of_change, 1, '01-JAN-2023') over (partition by id order by date_of_change) price_from_date, price_table.date_of_change as price_date_to
        from (select * from product_price_log
        union 
        select id, name, cost_price, selling_price, sysdate from product) price_table) price_log; 
Cursor c_product is select * from product;

begin 
for k in c_product
loop 
dbms_output.put_line('PRODUCT:  '||upper(k.name));
    v_product_profit := 0;
        for i in c_price_log
        loop
            v_transaction_quantity := 0;
            v_profit:= 0;
            v_transaction_quantity_p := 0;
            v_transaction_quantity_r := 0;
            if k.id = i.id then 
                for j in c_ext_trans
                loop
                    if (i.id = j.product_id and j.date_time < i.price_date_to and j.date_time >= i.price_from_date and lower(j.transaction_type) = 'p') then 
                    v_transaction_quantity_p := v_transaction_quantity_p + j.quantity;
                    end if;  
                    if (i.id = j.product_id and j.date_time < i.price_date_to and j.date_time >= i.price_from_date and lower(j.transaction_type) = 'r') then 
                    v_transaction_quantity_r := v_transaction_quantity_r - j.quantity;
                    end if; 
                    v_transaction_quantity := v_transaction_quantity_p + v_transaction_quantity_r;
                end loop;
            v_profit := v_transaction_quantity * (i.old_selling_price - i.old_cost_price); 
            v_product_profit := v_product_profit + v_profit;
            dbms_output.put_line('Total_quantity_sold from date '||i.price_from_date||' to '||i.price_date_to||' is '||v_transaction_quantity||' and profit is $'|| v_profit);       
            end if;
        end loop;
dbms_output.put_line('    ');
dbms_output.put_line('Total profit to date '||sysdate||' in the year 2023 for product   '||upper(k.name)|| '  is $ '||v_product_profit);  

dbms_output.put_line('    ');
dbms_output.put_line('    ');
end loop;
end;
/



