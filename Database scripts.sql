SET SERVEROUTPUT ON
/
DECLARE
v_table_exists varchar(1) := 'Y'; 
v_sql varchar(2000);
CURSOR c_fk IS SELECT table_name,constraint_name FROM user_constraints WHERE constraint_type = 'R'; --cursor to store table name and constraint name
i Number:=0;                                                                                        --Declare and initalize variable i
V_COUNT NUMBER :=0;                                                                                 --Declare counter 
BEGIN
WHILE i<3                                                                                           --WHILE LOOP TO ITERATE i VARIABLE UNTIL I VALUE IS LESS THAN 3
	LOOP
		i:=i+1;                                                                                     --INCREMENT I VALUE
		SELECT COUNT(*) into V_COUNT FROM user_constraints WHERE constraint_type = 'R';				--SELECT QUERY TO INSERT NUMBER OF REFRENTIAL KEYS INTO VARIABLE V_COUNT
			if i=1 and V_COUNT>0 THEN                                                               --IF CLAUSE TO CHECK i VALUE AND NUMBER OF VALUES IN V_COUNT VARIABLE
					FOR fk IN c_fk LOOP                                                             --FOR LOOP TO ITERATE CURSOR C_FK
					EXECUTE IMMEDIATE 'ALTER TABLE ' || fk.table_name || ' DROP CONSTRAINT ' || fk.constraint_name; --DROP ALL FOREIGN KEY CONSTRAINTS IN DATABASE
					DBMS_OUTPUT.PUT_LINE('DROPPING FOREIGN KEY CONSTRAINTS FOR TABLE '||fk.table_name);             --DISPLAY DROPPING MESSAGE TO CONSOLE
					END LOOP;
			ELSE IF i=2 THEN                                                                         --CHECK ELSE CONDITION
					for i in(
					SELECT 'CUSTOMER_ADDRESS' TABLE_NAME from dual union all                         --FOR LOOP INITIALIZE TO ITERATE 12 TIMES
					SELECT 'EXTERNAL_TRANSACTION' TABLE_NAME from dual union all
					SELECT 'INTERNAL_TRANSACTION' TABLE_NAME from dual union all
					SELECT 'SALES_REP_ACTIVITY' TABLE_NAME from dual union all
					SELECT 'WAREHOUSE' TABLE_NAME from dual union all
					SELECT 'DRIVER_DETAILS' TABLE_NAME from dual union all
					SELECT 'VEHICLE_DETAILS' TABLE_NAME from dual union all
					SELECT 'PRODUCT' TABLE_NAME from dual union all
					SELECT 'CUSTOMER_CONTACT' TABLE_NAME from dual union all
					SELECT 'CUSTOMER' TABLE_NAME from dual union all
					SELECT 'SALES_REPRESENTATIVE' TABLE_NAME from dual union all
					SELECT 'INVENTORY' TABLE_NAME from dual
					)
					loop
					DBMS_OUTPUT.PUT_LINE('DROPPING TABLE ' || i.TABLE_NAME);									--PRINTING OUTPUT TO CONSOLE WITH DROPPING TABLE NAME															
						BEGIN
							select 'Y' into v_table_exists	from USER_TABLES where TABLE_NAME=i.table_name;		--CHECK IF TABLE EXISTS FROM DATA DICTIONARY VIEW
							v_sql := 'drop table '||i.table_name;                                               
							execute immediate v_sql;
							dbms_output.put_line('Table '||i.table_name||' dropped successfully');              --DROP TABLES PRESENT IN DATABASE
       
							EXCEPTION                                                                           --EXCEPTION HANDLING BLOCK
							when no_data_found then
							dbms_output.put_line('Table already dropped');                                
						END;
					END LOOP;
				dbms_output.put_line('Schema cleanup successfully completed');                                  -- DISPLAYING MESSAGE TO CONSOLE
			END IF;
	END IF;                                                                                                     --END LOOP AND IF STATEMENTS
 END LOOP;
END;
/
CREATE TABLE PRODUCT(                                                                                           --DDL STATEMENT TO CREATE TABLE PRODUCT
ID NUMBER,
NAME VARCHAR2(30) NOT NULL,
COST_PRICE NUMBER(20,2) NOT NULL,
SELLING_PRICE NUMBER(20,2) NOT NULL,
PRODUCT_DESCRIPTION VARCHAR2(250) NOT NULL,
CONSTRAINT PRODUCT_ID_PK PRIMARY KEY(ID)
)
/
insert into product(ID, NAME, COST_PRICE, SELLING_PRICE, PRODUCT_DESCRIPTION)                                      --INSERTING DATA INTO PRODUCT TABLE
select 223001, 'Tylenol', 8.25,10.5,'It is used to relieve mild headache, toothaches and muscle aches.' from dual union all
select 223002, 'Pepto bismol', 7.75, 9.75, 'It is used to treat heart burn, nausea and upset stomach.'  from dual union all
select 223003, 'Nyquil syrup',  14, 17.25, 'It is used to relieve coughing,stuffy and runny nose and also for sore throat and sneezing.' from dual union all
select 223004, 'Imodium',  17.5, 20, 'It is used to treat sudden diarrhea.' from dual union all
select 223005, 'Mucinex', 22.5,25.5, 'It is used to release chest congestion.' from dual;
/
commit;
/
select *from PRODUCT;                                                                                             
/
CREATE TABLE CUSTOMER(                                                                             --DDL STATEMENT TO CREATE CUSTOMER TABLE
ID NUMBER,
CUSTOMER_MEETING_ID NUMBER,
REF_WAREHOUSE_ID NUMBER,
NAME VARCHAR2(50) NOT NULL,
TYPE VARCHAR2(20) NOT NULL,
CONSTRAINT CUSTOMER_ID_PK PRIMARY KEY(ID)
)
/
INSERT INTO CUSTOMER (ID,CUSTOMER_MEETING_ID,REF_WAREHOUSE_ID,NAME,TYPE)                           --DML STATEMENTS TO INSERT DATA INTO CUSTOMER TABLE
SELECT 123001,	55112201,	6601,	'Nancy Davolio','Doctor' FROM DUAL UNION ALL
SELECT 123002,	55112203,	6602,	'Massachusetts General Hospital','Hospital' FROM DUAL UNION ALL
SELECT 123003,	55112205,	6603,	'CVS Pharmacy','Pharmacy' FROM DUAL UNION ALL 
SELECT 123004,	55112207,	6604,	'Janet Leverling','Doctor' FROM DUAL UNION ALL
SELECT 123005,	55112209,	6604,	'Brigham and Womens Hospital','Hospital' FROM DUAL UNION ALL
SELECT 123006,	55112211,	6602,	'Walgreens','Pharmacy' FROM DUAL UNION ALL
SELECT 123007,	55112213,	6601,	'Michael Suyama','Doctor' FROM DUAL UNION ALL
SELECT 123008,	55112215,	6602,	'Clevland Clinic Hospital','Hospital' FROM DUAL UNION ALL
SELECT 123009,	55112217,	6603,	'Healthb Mart' ,'Pharmacy' FROM DUAL UNION ALL
SELECT 123010,	55112219,	6603,	'Robert King','Doctor' FROM DUAL UNION ALL
SELECT 123011,	55112221,	6601,	'John Hopkins Hospital','Hospital' FROM DUAL UNION ALL
SELECT 123012,	55112223,	6602,	'Good Neighbor Pharmacy','Pharmacy' FROM DUAL UNION ALL
SELECT 123013,	55112225,	6601,	'Anne Dodsworth','Doctor' FROM DUAL UNION ALL
SELECT 123014,	55112227,	6604,	'MD Anderson Cancer Center','Hospital' FROM DUAL UNION ALL
SELECT 123015,	55112229,	6603,	'GNC Live Well','Pharmacy' FROM DUAL UNION ALL
SELECT 123016,	55112231,	6604,	'Emmy Robinson','Doctor' FROM DUAL UNION ALL
SELECT 123017,	55112233,	6601,	'North General Hospital','Hospital' FROM DUAL UNION ALL
SELECT 123018,	55112235,	6603,	'Safeway Pharmacy','Pharmacy' FROM DUAL UNION ALL
SELECT 123019,	55112237,	6602,	'Paul Carmody','Doctor' FROM DUAL UNION ALL
SELECT 123020,	55112239,	6603,	'Tucson Medical Center','Hospital' FROM DUAL;
/
COMMIT;
/
SELECT *FROM CUSTOMER;
/
CREATE TABLE CUSTOMER_ADDRESS(                                                                    --DDL STATEMENT TO CREATE CUSTOMER_ADDRESS TABLE
ID NUMBER,
ADDRESS_LINE_1 VARCHAR2(100),
ADDRESS_LINE_2 VARCHAR2(100),
CITY VARCHAR2(50) NOT NULL,
REGION VARCHAR2(50)NOT NULL,
STATE VARCHAR2(50),
ZIP_CODE NUMBER,
COUNTRY VARCHAR2(50)
)
/
insert into CUSTOMER_ADDRESS (ID, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, REGION, STATE, ZIP_CODE, COUNTRY) --DML STATEMENT TO INSERT TABLE INTO CUSTOMER_ADDRESS TABLE
select 123001, '56C', 'Cape Cod Homes', 'Boston', 'Cambridge', 'MA', 21140, 'USA'  from dual union all
select 123002, '42B', 'Common Wealth', 'Boston', 'Common Wealth', 'MA', 22340, 'USA'  from dual union all
select 123003, '147B', 'Preserve Park Way', 'Boston', 'Roxbury', 'MA', 23634, 'USA'  from dual union all
select 123004, '56C', 'Long Point Road', 'Boston', 'Cambridge', 'MA', 24361, 'USA'  from dual union all
select 123005, '10021', 'Hertiage Port', 'Boston', 'Roxbury', 'MA', 23958, 'USA'  from dual union all
select 123006, '515A', 'Silvia street', 'Boston', 'Common Wealth', 'MA', 21569, 'USA'  from dual union all
select 123007, '500A', '31st Street', 'Boston', 'Cambridge', 'MA', 23569, 'USA'  from dual union all
select 123008, '100W', '38th Street', 'Boston', 'Quincy', 'MA', 22698, 'USA'  from dual union all
select 123009, '555W', 'Lee Road', 'Boston', 'Common Wealth', 'MA', 23200, 'USA'  from dual union all
select 123010, '11535', 'Rockville park', 'Boston', 'Roxbury', 'MA', 21851, 'USA'  from dual union all
select 123011, '18A', 'Hudson Street', 'Boston', 'Cambridge', 'MA', 22978, 'USA'  from dual union all
select 123012, '71C', 'Moody Street', 'Boston', 'Common Wealth', 'MA', 21635, 'USA'  from dual union all
select 123013, '91B', 'Tremont Street', 'Boston', 'Cambridge', 'MA', 24390, 'USA'  from dual union all
select 123014, '107F', 'Summer Street', 'Boston', 'Quincy', 'MA', 23987, 'USA'  from dual union all
select 123015, '56G', '360 Huntington Avenue', 'Boston', 'Roxbury', 'MA', 24548, 'USA'  from dual union all
select 123016, '65L', 'Park Drive', 'Boston', 'Quincy', 'MA', 21578, 'USA'  from dual union all
select 123017, '235S', 'Lower Roxbury', 'Boston', 'Cambridge', 'MA', 23936, 'USA'  from dual union all
select 123018, '125G', 'Parker Hill', 'Boston', 'Roxbury', 'MA', 22546, 'USA'  from dual union all
select 123019, '635C', 'Commonwealth Avenue', 'Boston', 'Common Wealth', 'MA', 23879, 'USA'  from dual union all
select 123020, '32J', 'Washington Street', 'Boston', 'Roxbury', 'MA', 24390, 'USA'  from dual;
/
commit;
/
SELECT *FROM CUSTOMER_ADDRESS;
/
CREATE TABLE CUSTOMER_CONTACT(                                                                 			 --CREATE TABLE CUSTOMER_CONTACT
ID NUMBER,
MOBILE_NO VARCHAR2(30),
EMAIL VARCHAR2(50)
)
/
insert into customer_contact (ID, MOBILE_NO, EMAIL)                                             		 --INSERTING DATA INTO CUSTOMER CONTACT
select 123001, '617-906-1253', 'nancydavolio@gmail.com' from dual union all
select 123002, '857-376-1862', 'salesdept@mgh.org' from dual union all
select 123003, '224-756-7417', 'purchase@cvs.org' from dual union all
select 123004, '224-763-6325', 'janetleverling@gmail.com' from dual union all
select 123005, '732-846-3225', 'salesdept@bwh.org' from dual union all
select 123006, '732-856-3115', 'purchase@walgreens.org'   from dual union all
select 123007, '212-475-5838', 'michaelsuyama@gmail.com'   from dual union all
select 123008, '212-567-6949', 'salesdept@cch.org'   from dual union all
select 123009, '224-875-5415', 'purchase@healthhubmart.org'   from dual union all
select 123010, '857-746-8535', 'robertking@gmail.com'   from dual union all
select 123011, '989-896-5698', 'salesdept@jhh.org'   from dual union all
select 123012, '589-532-8759', 'purchase@.gnp.org'   from dual union all
select 123013, '547-859-7893', 'annedodsworth@gmail.com'   from dual union all
select 123014, '245-589-8965', 'salesdept@macc.org'   from dual union all
select 123015, '896-587-9632', 'purchase@gnclivewall.org'   from dual union all
select 123016, '859-879-6985', 'emmyrobinson@gmail.com'   from dual union all
select 123017, '617-589-9876', 'salesdept@ngh.org'   from dual union all
select 123018, '987-962-5698', 'purchase@safeway.org'   from dual union all
select 123019, '514-859-7892', 'paulcarmody@gmail.com'   from dual union all
select 123020, '879-965-4591', 'salesdept@tmc.org'   from dual;
/
commit;
/
SELECT *FROM CUSTOMER_CONTACT;                            
/
CREATE TABLE SALES_REPRESENTATIVE(                                                              			--CREATE TABLE SALES_REPRESENTATIVE
ID NUMBER,
REF_WAREHOUSE_ID NUMBER,
FIRST_NAME VARCHAR2(50) NOT NULL,
MIDDLE_NAME VARCHAR2(50),
LAST_NAME VARCHAR2(50),
CONTACT VARCHAR2(30),
EMAIL VARCHAR2(50),
CONSTRAINT SALESREP_ID_PK PRIMARY KEY(ID)
)
/
insert into sales_representative (ID, REF_WAREHOUSE_ID, FIRST_NAME, MIDDLE_NAME, LAST_NAME, CONTACT, EMAIL)  --INSERTING DATA TO  SALES_REPRESENTATIVE TABLE
select 323001, 6601, 'John', 'Robert', 'Kenedy', 224-756-1862, 'kennedy.j@organization.com' from dual union all
select 323002, 6602, 'Nick', 'Robin', 'Peter', 857-376-1963, 'peter.n@organization.com' from dual union all
select 323003, 6603, 'Rock', 'Thomas', 'Edison', 224-876-1932, 'edison.r@organization.com' from dual union all
select 323004, 6604, 'Kevin', 'Peter', 'Hart', 857-476-1752, 'hart.k@organization.com' from dual;
/
commit;
/
SELECT *FROM SALES_REPRESENTATIVE
/ 
CREATE TABLE EXTERNAL_TRANSACTION(																			--CREATING EXTERNAL TRANSACTION TABLE
TRANSACTION_ID NUMBER,
PRODUCT_ID NUMBER,
CUSTOMER_ID NUMBER,
REF_WAREHOUSE_ID NUMBER,
SALESREP_ID NUMBER,
TRANSACTION_TYPE VARCHAR2(20) NOT NULL,
DATE_TIME TIMESTAMP,
QUANTITY NUMBER NOT NULL,
CONSTRAINT TRANSACTION_ID_PK PRIMARY KEY(TRANSACTION_ID)
)
/
INSERT INTO EXTERNAL_TRANSACTION(TRANSACTION_ID,PRODUCT_ID,CUSTOMER_ID,REF_WAREHOUSE_ID,SALESREP_ID,TRANSACTION_TYPE,DATE_TIME,QUANTITY)  --INSERTING DATA INTO EXTERNAL TRANSACTION TABLE
SELECT 23210001,223001,123004,6604,323004,'P',TO_TIMESTAMP('2023-02-27 11:45:11', 'YYYY-MM-DD HH24:MI:SS'),100 from dual union all
SELECT 23210002,223002,123006,6602,323002,'P',TO_TIMESTAMP('2023-03-02 10:10:02', 'YYYY-MM-DD HH24:MI:SS'),45 from dual union all
SELECT 23210003,223003,123007,6601,323001,'P',TO_TIMESTAMP('2023-03-07 16:00:39', 'YYYY-MM-DD HH24:MI:SS'),54 from dual union all
SELECT 23210004,223004,123003,6603,323003,'R',TO_TIMESTAMP('2023-03-16 10:45:44', 'YYYY-MM-DD HH24:MI:SS'),63 from dual union all
SELECT 23210005,223005,123005,6604,323004,'P',TO_TIMESTAMP('2023-03-17 9:19:44', 'YYYY-MM-DD HH24:MI:SS'),53 from dual union all
SELECT 23210006,223002,123009,6603,323003,'P',TO_TIMESTAMP('2023-03-17 9:16:44', 'YYYY-MM-DD HH24:MI:SS'),54 from dual union all
SELECT 23210007,223003,123012,6602,323002,'P',TO_TIMESTAMP('2023-03-17 9:15:44', 'YYYY-MM-DD HH24:MI:SS'),59 from dual union all
SELECT 23210008,223002,123013,6601,323001,'R',TO_TIMESTAMP('2023-03-17 9:18:44', 'YYYY-MM-DD HH24:MI:SS'),84 from dual union all
SELECT 23210009,223003,123014,6604,323004,'R',TO_TIMESTAMP('2023-03-17 9:18:44', 'YYYY-MM-DD HH24:MI:SS'),57 from dual union all
SELECT 23210010,223003,123015,6603,323003,'P',TO_TIMESTAMP('2023-03-18 11:49:44', 'YYYY-MM-DD HH24:MI:SS'),25 from dual union all
SELECT 23210011,223001,123016,6604,323004,'P',TO_TIMESTAMP('2023-03-18 11:56:44', 'YYYY-MM-DD HH24:MI:SS'),35 from dual union all
SELECT 23210012,223002,123019,6602,323002,'R',TO_TIMESTAMP('2023-03-18 11:59:44','YYYY-MM-DD HH24:MI:SS'),65 from dual union all
SELECT 23210013,223001,123020,6603,323003,'R',TO_TIMESTAMP('2023-03-19 12:40:44', 'YYYY-MM-DD HH24:MI:SS'),25 from dual union all
SELECT 23210014,223003,123010,6603,323003,'P',TO_TIMESTAMP('2023-03-20 11:50:44', 'YYYY-MM-DD HH24:MI:SS'),96 from dual union all
SELECT 23210015,223001,123011,6601,323001,'P',TO_TIMESTAMP('2023-03-20 11:55:44', 'YYYY-MM-DD HH24:MI:SS'),35 from dual union all
SELECT 23210016,223004,123006,6602,323002,'P',TO_TIMESTAMP('2023-03-20 11:59:44', 'YYYY-MM-DD HH24:MI:SS'),32 from dual;
/
commit;
/
SELECT *FROM EXTERNAL_TRANSACTION
/
CREATE TABLE INTERNAL_TRANSACTION(                                                             --CREATING INTERNAL TRANSACTION TABLE 
TRANSACTION_ID NUMBER,
WAREHOUSE_FROM VARCHAR2(30),
WAREHOUSE_TO VARCHAR2(30),
PRODUCT_ID NUMBER,
SALESREP_ID NUMBER,
DATE_TIME TIMESTAMP,
QUANTITY NUMBER NOT NULL,
CONSTRAINT TRANSACTION_ID1_PK PRIMARY KEY(TRANSACTION_ID)
)
/
insert into INTERNAL_TRANSACTION (TRANSACTION_ID, WAREHOUSE_FROM, WAREHOUSE_TO, PRODUCT_ID, DATE_TIME, QUANTITY)      --INSERTING DATA INTO INTERNAL TRANSACTION TABLE 
select 23110001, 6601, 6602, 223002,  TO_TIMESTAMP('2/27/2023 11:02:11', 'MM-DD-YYYY HH24:MI:SS'), 88  from dual union all
select 23110002, 6602, 6604, 223003,  TO_TIMESTAMP('3/2/2023 10:30:02', 'MM-DD-YYYY HH24:MI:SS'), 270  from dual union all
select 23110003, 6603, 6602, 223005, TO_TIMESTAMP('3/7/2023 16:09:39', 'MM-DD-YYYY HH24:MI:SS'), 100 from dual union all
select 23110004, 6604, 6603, 223004,  TO_TIMESTAMP('3/16/2023 10:40:44', 'MM-DD-YYYY HH24:MI:SS'), 140 from dual union all
select 23110005, 7705, 6601, 223001, TO_TIMESTAMP('3/17/2023 9:15:44', 'MM-DD-YYYY HH24:MI:SS'), 1000 from dual union all
select 23110006, 7705, 6602, 223001,  TO_TIMESTAMP('3/17/2023 9:16:44', 'MM-DD-YYYY HH24:MI:SS'), 1000  from dual union all
select 23110007, 7705, 6603, 223001, TO_TIMESTAMP('3/17/2023 9:17:44', 'MM-DD-YYYY HH24:MI:SS'), 1000  from dual union all
select 23110008, 7705, 6604, 223001, TO_TIMESTAMP('3/17/2023 9:18:44', 'MM-DD-YYYY HH24:MI:SS'), 1000  from dual union all
select 23110009, 6601, 6602, 223003,  TO_TIMESTAMP('3/18/2023 10:40:44', 'MM-DD-YYYY HH24:MI:SS'), 88  from dual union all
select 23110010, 6602, 6603, 223005,  TO_TIMESTAMP('3/18/2023 11:40:44', 'MM-DD-YYYY HH24:MI:SS'), 270  from dual union all
select 23110011, 6603, 6604, 223002,  TO_TIMESTAMP('3/18/2023 11:30:44', 'MM-DD-YYYY HH24:MI:SS'), 333 from dual union all
select 23110012, 6604, 6603, 223005,  TO_TIMESTAMP('3/18/2023 11:40:44', 'MM-DD-YYYY HH24:MI:SS'), 140  from dual union all
select 23110013, 6603, 6601, 223002,  TO_TIMESTAMP('3/19/2023 11:40:44', 'MM-DD-YYYY HH24:MI:SS'), 236 from dual union all
select 23110014, 6602, 6604, 223005,  TO_TIMESTAMP('3/19/2023 11:50:44', 'MM-DD-YYYY HH24:MI:SS'), 245  from dual union all
select 23110015, 6601, 6603, 223001,  TO_TIMESTAMP('3/19/2023 11:55:44', 'MM-DD-YYYY HH24:MI:SS'), 250 from dual union all
select 23110016, 6604, 6601, 223004,  TO_TIMESTAMP('3/19/2023 11:59:44', 'MM-DD-YYYY HH24:MI:SS'), 320 from dual;
/
COMMIT;
/
SELECT *FROM INTERNAL_TRANSACTION;
/ 
CREATE TABLE SALES_REP_ACTIVITY(                                                               --CREATING SALES_REP_ACTIVITY
MEETING_ID NUMBER,
SALESREP_ID NUMBER,
CUSTOMER_NAME VARCHAR2(50) NOT NULL,
INTERACTION_TYPE VARCHAR2(30),
CUSTOMER_TYPE VARCHAR2(30),
INTERACTION_DATE TIMESTAMP NOT NULL,
INTERACTION_DURATION NUMBER,
COMMENTS VARCHAR2(100),
ADDRESS_LINE_1 VARCHAR2(200),
ADDRESS_LINE_2 VARCHAR2(200),
CITY VARCHAR2(50),
REGION VARCHAR2(50),
STATE  VARCHAR2(50),
ZIPCODE NUMBER,
CUSTOMER_CONVERTED_FLAG VARCHAR2(20),
CONSTRAINT MEETING_ID_PK PRIMARY KEY(MEETING_ID)
)
/
INSERT INTO SALES_REP_ACTIVITY(MEETING_ID,SALESREP_ID,CUSTOMER_NAME,INTERACTION_TYPE,CUSTOMER_TYPE,INTERACTION_DATE,INTERACTION_DURATION,COMMENTS,ADDRESS_LINE_1,ADDRESS_LINE_2,CITY,REGION,STATE,ZIPCODE,CUSTOMER_CONVERTED_FLAG)   --INSERTING DATA INTO SALES_REP_ACTIVITY
select 55112201, 323001, 'Nancy Davolio', 'IN PERSON','Doctor', TO_TIMESTAMP('2023-01-10 1:02:10', 'YYYY-MM-DD HH24:MI:SS'), 90, '6601', '56C', 'Cape Cod Homes', 'Boston', 'Cambridge', 'MA', 21140, 'Y' from dual union all
select 55112202, 323004, 'Mother care', 'EMAIL','Pharmacy', TO_TIMESTAMP('2023-01-11 1:02:10', 'YYYY-MM-DD HH24:MI:SS'), 5, '6604', '23D', 'Avenue', 'Boston', 'QUINCY', 'MA', 24661, 'N' from dual union all
select 55112203, 323002, 'Massachusetts General Hospital', 'ON CALL','Hospital', TO_TIMESTAMP('2023-01-13 14:02:15', 'YYYY-MM-DD HH24:MI:SS'), 25, '6602', '42B', 'Common wealth', 'Boston', 'Common Wealth', 'MA', 22340, 'Y' from dual union all
select 55112204, 323002, 'Sarthak Kaur', 'EMAIL','Doctor', TO_TIMESTAMP('2023-01-14 14:02:10', 'YYYY-MM-DD HH24:MI:SS'), 45, '6602', '67H', 'Drive', 'Drive', 'Common Wealth', 'MA', 22667, 'N' from dual union all
select 55112205, 323003, 'CVS Pharmacy', 'ON CALL','Pharmacy', TO_TIMESTAMP('2023-01-21 15:02:20', 'YYYY-MM-DD HH24:MI:SS'), 40, '6603', '147B', 'Preserve Park way', 'Boston', 'Roxbury', 'MA', 23634, 'Y' from dual union all
select 55112206, 323003, 'Children Hospital', 'ON CALL','Hospital', TO_TIMESTAMP('2023-01-24 15:02:10', 'YYYY-MM-DD HH24:MI:SS'), 55, '6603', '55R', 'Cross', 'Boston', 'Roxbury', 'MA', 23997, 'N' from dual union all
select 55112207, 323004, 'Janet Leverling', 'EMAIL','Doctor', TO_TIMESTAMP('2023-01-25 18:02:14', 'YYYY-MM-DD HH24:MI:SS'), 5, '6604', '100C', 'Long point road', 'Boston', 'Quincy', 'MA', 24361, 'Y' from dual union all
select 55112208, 323001, 'Life Care', 'EMAIL','Pharmacy', TO_TIMESTAMP('2023-01-26 18:02:10', 'YYYY-MM-DD HH24:MI:SS'), 5, '6601', '778C', 'Longway', 'Boston', 'Cambridge', 'MA', 21339,'N' from dual union all
select 55112209, 323004, 'Brigham and Womens Hospital', 'IN PERSON','Doctor', TO_TIMESTAMP('2023-02-01 20:02:11', 'YYYY-MM-DD HH24:MI:SS'), 40, '6604', '515A', 'Heritage port', 'Boston', 'Quincy', 'MA', 23958, 'Y' from dual union all
select 55112210, 323002, 'Dev Patel', 'ON CALL','Doctor', TO_TIMESTAMP('2023-02-03 9:02:10', 'YYYY-MM-DD HH24:MI:SS'), 50, '6602', '88K', 'Fenway', 'Boston', 'Common Wealth', 'MA', 22768, 'N' from dual union all
select 55112211, 323002, 'Walgreens', 'IN PERSON','Pharmacy', TO_TIMESTAMP('2023-02-04 9:02:10', 'YYYY-MM-DD HH24:MI:SS'), 25, '6602', '500A', 'Silvia street', 'Boston', 'Common Wealth', 'MA', 22598, 'Y' from dual union all
select 55112212, 323003, 'Oscar care Hospital', 'ON CALL','Hospital', TO_TIMESTAMP('2023-02-05 10:02:10', 'YYYY-MM-DD HH24:MI:SS'), 5, '6603', '589S', 'Subway', 'Boston', 'Roxbury', 'MA', 23998, 'N' from dual union all
select 55112213, 323001, 'Michael Suyama', 'EMAIL','Doctor', TO_TIMESTAMP('2023-02-07 8:12:10', 'YYYY-MM-DD HH24:MI:SS'), 15, '6601', '100W', '31st Street', 'Boston', 'Cambridge', 'MA', 21569, 'Y' from dual union all
select 55112214, 323002, 'Access Pharma', 'IN PERSON ','Pharmacy', TO_TIMESTAMP('2023-02-07 10:02:10', 'YYYY-MM-DD HH24:MI:SS'), 35, '6602', '234C', 'Highland', 'Boston', 'Common Wealth', 'MA', 22567, 'N' from dual union all
select 55112215, 323002, 'Clevland Clinic Hospital', 'ON CALL','Hospital', TO_TIMESTAMP('2023-02-12 10:02:10', 'YYYY-MM-DD HH24:MI:SS'), 45, '6602', '555W', '38th Street', 'Boston', 'Roxbury', 'MA', 23569, 'Y' from dual union all
SELECT 55112216,323004,'Rodrigues',	'ON CALL','Doctor',	TO_TIMESTAMP('2023-02-12 10:02:10','YYYY-MM-DD HH24:MI:SS'),45,'6604','64Q','Kirkland','Boston','Quincy','MA',24778,'N' from dual union all
SELECT 55112217,323003,'Healthb Mart', 'EMAIL','Pharmacy',TO_TIMESTAMP('2023-02-13 13:02:10','YYYY-MM-DD HH24:MI:SS'),5,'6603','115A','Lee Road','Boston','Common Wealth','MA',22698,'Y' from dual union all
SELECT 55112218,323004,'MediMart','EMAIL','Pharmacy',TO_TIMESTAMP('2023-02-14 13:02:10','YYYY-MM-DD HH24:MI:SS'),5,'6604','225C',	'Street','Boston','Quincy',	'MA',24864,'N' from dual union all
SELECT 55112219,323003,'Robert King','ON CALL','Doctor',TO_TIMESTAMP('2023-03-07 19:09:18','YYYY-MM-DD HH24:MI:SS'),10,'6603','18A','Rockville park','Boston','Roxbury','MA',23200,'Y' from dual union all
SELECT 55112220,323001,'Shelly SeniorHospital','EMAIL',	'Hospital',TO_TIMESTAMP('2023-03-08 19:09:18','YYYY-MM-DD HH24:MI:SS'),5,'6601','33A','Range Rock','Boston','Cambridge','MA',	21339,'N' from dual union all
SELECT 55112221,323001,'John Hopkins Hospital','EMAIL','Hospital',TO_TIMESTAMP('2023-03-08 17:02:10','YYYY-MM-DD HH24:MI:SS'),5 ,'6601','71C','Hudson Street','Boston','Cambridge','MA',21851,'Y' from dual union all
SELECT 55112222,323002,'Ravi Sinha','ON CALL','Doctor',TO_TIMESTAMP('2023-03-09 7:02:10','YYYY-MM-DD HH24:MI:SS'),25,'6602','23V','Stepping Stone','Boston','Common Wealth','MA',22556,'N' from dual union all
SELECT 55112223,323002,'Good Neighbor Pharmacy','EMAIL','Pharmacy',TO_TIMESTAMP('2023-03-09 10:08:40','YYYY-MM-DD HH24:MI:SS'),5,'6602','91B','Moody Steet','Boston','Common Wealth','MA',22978,'Y' from dual union all
SELECT 55112224,323003,'City Hospital',	'IN PERSON','Hospital',TO_TIMESTAMP('2023-03-09 15:08:40','YYYY-MM-DD HH24:MI:SS'),45,'6603','78H','Wellington','Boston','Roxbury','MA',23557,'N' from dual union all
SELECT 55112225,323001,'Anne Dodsworth'	,'ON CALL',	'Doctor',TO_TIMESTAMP('2023-03-09 16:02:10','YYYY-MM-DD HH24:MI:SS'),30,'6601','107F','Tremont Street','Boston','Cambridge','MA',21635,'Y' from dual union all
SELECT 55112226,323004,'Medical', 'EMAIL','Pharmacy',TO_TIMESTAMP('2023-03-09 18:02:10','YYYY-MM-DD HH24:MI:SS'),5,'6604','875F','Washington Avenue','Boston','Quincy','MA',24775,'N' from dual union all
SELECT 55112227,323004,'MD Anderson Cancer Center', 'EMAIL','Hospital',TO_TIMESTAMP('2023-03-09 20:02:10','YYYY-MM-DD HH24:MI:SS'),5,'6604','56G','Summer Street','Boston','Quincy','MA',	24390,'Y' from dual union all
SELECT 55112228,323001,'Wellness Forever',	'ON CALL','Pharmacy',TO_TIMESTAMP('2023-03-09 21:02:10','YYYY-MM-DD HH24:MI:SS'),40,'6601','778C','Driver loop','Boston','Cambridge','MA',21339,'N' from dual union all
SELECT 55112229,323003,'GNC Live Well','IN PERSON','Pharmacy',TO_TIMESTAMP('2023-03-10 9:02:10','YYYY-MM-DD HH24:MI:SS'),85,'6603','65L','360 Huntington Avenue','Boston','Roxbury','MA',23987,'Y' from dual union all
SELECT 55112230,323003,'Early Responder Hospital','ON CALL','Hospital',TO_TIMESTAMP('2023-03-10 10:02:10','YYYY-MM-DD HH24:MI:SS'),55,'6603','556D','Nusa','Boston','Roxbury','MA',23667,'N'from dual union all
SELECT 55112231,323004,'Emmy Robinson','EMAIL','Doctor',TO_TIMESTAMP('2023-03-10 10:02:10','YYYY-MM-DD HH24:MI:SS'),5,'6604','235S','Park Drive','Boston','Quincy','MA',24548,'Y' from dual union all
SELECT 55112232,323004,'Patient Care','IN PERSON' ,'Pharmacy',TO_TIMESTAMP('2023-03-10 14:22:19','YYYY-MM-DD HH24:MI:SS'),75,'6604','1332F','Square street','Boston','Quincy','MA',24335,'N' from dual union all
SELECT 55112233,323001,'North General Hospital','EMAIL','Hospital',TO_TIMESTAMP('2023-03-10 15:42:50','YYYY-MM-DD HH24:MI:SS'),5,'6601','125G','Lower Roxbury','Boston','Cambridge','MA',21578,'Y' from dual union all
SELECT 55112234,323002,'Suburban Hospital','IN PERSON','Hospital',TO_TIMESTAMP('2023-03-10 18:42:50','YYYY-MM-DD HH24:MI:SS'),100,'6602','668R','Grip Square','Boston','Common Wealth','MA',22889,'N' from dual union all
SELECT 55112235,323003,'Safeway Pharmacy','ON CALL','Pharmacy',TO_TIMESTAMP('2023-03-11 9:47:35','YYYY-MM-DD HH24:MI:SS'),15,'6603','635C','Parker Hill','Boston','Roxbury','MA',23936,'Y' from dual union all
SELECT 55112236,323002,'Dorthy Pollen','EMAIL','Doctor',TO_TIMESTAMP('2023-03-11 11:47:35','YYYY-MM-DD HH24:MI:SS'),5,'6602','67G','Sanhok','Boston','Common Wealth','MA',22453,'N' from dual union all
SELECT 55112237,323002,'Paul Carmody','EMAIL','Doctor',TO_TIMESTAMP('2023-03-11 12:24:10','YYYY-MM-DD HH24:MI:SS'),5,'6602','65D','Commonwealth Avenue','Boston','Common Wealth','MA',22546,'Y' from dual union all
SELECT 55112238,323004,'Highway' ,'ON CALL','Pharmacy',TO_TIMESTAMP('2023-03-11 14:24:10','YYYY-MM-DD HH24:MI:SS'),30,'6603','63E','Closer loop','Boston','Roxbury','MA',23421,'N' from dual union all
SELECT 55112239,323003,'Tucson Medical Center' ,'IN PERSON','Hospital',TO_TIMESTAMP('2023-03-11 19:05:15','YYYY-MM-DD HH24:MI:SS'),95,'6603','32J','Washington Street','Boston','Roxbury','MA',23879,'Y' from dual union all
SELECT 55112240,323003,'Vedicare Hospital','EMAIL','Hospital',TO_TIMESTAMP('2023-03-12 10:05:15','YYYY-MM-DD HH24:MI:SS'),5,'6603','55W','Mission Hill','Boston','Roxbury','MA',23786,'N' from dual union all
SELECT 55112241,323001,'Wellington','IN PERSON','Doctor',TO_TIMESTAMP('2023-03-13 10:05:15','YYYY-MM-DD HH24:MI:SS'),70,'6601','78S','Mission Main','Boston','Cambridge','MA',21334,'N' from dual union all
SELECT 55112242,323004,'Red Cross' ,'ON CALL','Pharmacy',TO_TIMESTAMP('2023-03-13 15:05:15','YYYY-MM-DD HH24:MI:SS'),25,'6604','60R','Liberty rock','Boston','Quincy','MA',24321,'N' from dual union all
SELECT 55112243,323002,'Life Saver','EMAIL','Pharmacy',TO_TIMESTAMP('2023-03-13 19:05:15','YYYY-MM-DD HH24:MI:SS'),	5,'6602','43T','Pochinki','Boston','Common Wealth','MA',22346,'N' from dual union all
SELECT 55112244,323001,'Kelly Sanders','IN PERSON','Doctor',TO_TIMESTAMP('2023-03-14 10:05:15','YYYY-MM-DD HH24:MI:SS'),75,'6601','65F','Military street','Boston','Cambridge','MA',21346,'N' from dual union all
SELECT 55112245,323001,'Bankers Hospital','IN PERSON','Hospital',TO_TIMESTAMP('2023-03-15 10:05:15','YYYY-MM-DD HH24:MI:SS'),65,'6601','435G','Townhall','Boston','Cambridge','MA',21347,'N' from dual; 
/
commit;
/
SELECT *FROM SALES_REP_ACTIVITY
/
CREATE TABLE INVENTORY(                                                                           --CREATING TABLE INVENTORY
ID NUMBER,
PRODUCT_ID NUMBER,
WAREHOUSE_ID NUMBER,
PRODUCT_QUANTITY NUMBER NOT NULL,
CONSTRAINT INVENTORY_ID_PK PRIMARY KEY(ID)
)
/
insert into inventory (ID, PRODUCT_ID, WAREHOUSE_ID, PRODUCT_QUANTITY)                           --INSERTING DATA INTO INVENTORY TABLE
select 723001, 223001, 6601, 350 from dual union all
select 723002, 223002, 6601, 350 from dual union all
select 723003, 223003, 6601, 350 from dual union all
select 723013, 223003, 6603, 350 from dual union all
select 723014, 223004, 6603, 350 from dual union all
select 723015, 223005, 6603, 350 from dual union all
select 723016, 223001, 6604, 350 from dual union all
select 723017, 223002, 6604, 350 from dual union all
select 723018, 223003, 6604, 350 from dual union all
select 723019, 223004, 6604, 350 from dual union all
select 723020, 223005, 6604, 350 from dual;
/
COMMIT;
/
SELECT *FROM INVENTORY
/
CREATE TABLE WAREHOUSE(                                                                --CREATING WAREHOUSE TABLE
ID NUMBER,
NAME VARCHAR2(50),
ADDRESS VARCHAR2(50),
LOCATION VARCHAR2(50),
REGION VARCHAR2(30),
VEHICLE_ID NUMBER,
CONSTRAINT  WAREHOUSE_ID_PK PRIMARY KEY(ID)
)
/
insert into WAREHOUSE (ID, NAME, ADDRESS, LOCATION, REGION, VEHICLE_ID)                --INSERTING DATA INTO WAREHOUSE TABLE
select 6601, 'BOS1C','7 Crown Drive, 02169','BOSTON','Cambridge', 823001 from dual union all
select 6602, 'BOS2W','7583, Common Bridge street, 77054','BOSTON','Commom Wealth', 823002 from dual union all
select 6603, 'BOS3R','Frank 57 West, 10019', 'BOSTON','Roxbury', 823003 from dual union all
select 6604, 'BOS4Q','11 Ave Port, 07093','BOSTON','Quincy', 823004 from dual union all
select 7705, 'CBOSM','235 Park Drive, 02215','BOSTON','Suffolk', 823005 from dual;
/
COMMIT;
/
SELECT *FROM WAREHOUSE;
/
CREATE TABLE DRIVER_DETAILS(                                                             --CREATING DRIVER_DETAILS TABLE 
ID NUMBER,
NAME VARCHAR2(50),
CONTACT VARCHAR2(30),
EFFECTIVE_DATE DATE,
LICENCE VARCHAR2(30),
CONSTRAINT DRIVER_ID_PK PRIMARY KEY(ID)
)
/
insert into DRIVER_DETAILS (ID, NAME, CONTACT, EFFECTIVE_DATE, LICENCE)                   --INSERTING DATA INTO DRIVER_DETAILS TABLE
select 923001, 'John', '212-756-6523', TO_DATE('28/02/2022','DD/MM/YYYY'), 'SA9988776'  from dual union all
select 923002, 'Nick', '616-609-8797', TO_DATE('7/3/2022','DD/MM/YYYY'), 'S99888017' from dual union all
select 923003, 'Adam', '716-878-5676', TO_DATE('9/3/2022','DD/MM/YYYY'), 'S15778890' from dual union all
select 923004, 'Peter','221-656-6232', TO_DATE('13/3/2022','DD/MM/YYYY'), 'SA8986672' from dual union all
select 923005, 'Samuel','331-334-5567', TO_DATE('11/3/2022','DD/MM/YYYY'), 'SW668925' from dual;
/
commit;
/
SELECT *FROM DRIVER_DETAILS;
/
CREATE TABLE VEHICLE_DETAILS(                                                               --CREATING VEHICLE_DETAILS TABLE
ID NUMBER,
DRIVER_ID NUMBER,
REGISTRATION_NUMBER VARCHAR2(50),
CONSTRAINT VEHICLE_ID_PK PRIMARY KEY(ID)
)
/
INSERT INTO VEHICLE_DETAILS(ID,DRIVER_ID,REGISTRATION_NUMBER)                               --INSERTING DATA INTO VEHICLE DETAILS TABLE                       
select 823001,923001,'AB-90156' from dual union all
select 823002,923002,'AE-11078'	from dual union all
select 823003,923003,'AG-80765'	from dual union all
select 823004,923004,'AL-90123'	from dual union all
select 823005,923005,'SQ-76431' from dual;
/
COMMIT;
/
SELECT *FROM VEHICLE_DETAILS;
/
ALTER TABLE CUSTOMER ADD CONSTRAINT "CUSTOMER_MEETING_ID_FK" FOREIGN KEY ("CUSTOMER_MEETING_ID") REFERENCES "SALES_REP_ACTIVITY" ("MEETING_ID")    --CREATING FOREIGN KEY CONSTRAINTS
/
ALTER TABLE CUSTOMER ADD CONSTRAINT "REF_WAREHOUSE_ID_FK" FOREIGN KEY ("REF_WAREHOUSE_ID") REFERENCES "WAREHOUSE" ("ID");
/
ALTER TABLE CUSTOMER_ADDRESS ADD CONSTRAINT "CUSTOMER_ID_FK" FOREIGN KEY ("ID") REFERENCES "CUSTOMER" ("ID");
/
ALTER TABLE CUSTOMER_CONTACT ADD CONSTRAINT "CUSTOMER_ID1_FK" FOREIGN KEY ("ID") REFERENCES "CUSTOMER" ("ID")
/
ALTER TABLE SALES_REPRESENTATIVE ADD CONSTRAINT "REF_WAREHOUSE_ID1_FK" FOREIGN KEY ("REF_WAREHOUSE_ID") REFERENCES "WAREHOUSE" ("ID")
/
ALTER TABLE EXTERNAL_TRANSACTION ADD CONSTRAINT "PRODUCT_ID_FK" FOREIGN KEY ("PRODUCT_ID") REFERENCES "PRODUCT" ("ID")
/
ALTER TABLE EXTERNAL_TRANSACTION ADD CONSTRAINT "CUSTOMER_ID2_FK" FOREIGN KEY ("CUSTOMER_ID") REFERENCES "CUSTOMER" ("ID")
/
ALTER TABLE EXTERNAL_TRANSACTION ADD CONSTRAINT "REF_WAREHOUSE_ID2_FK" FOREIGN KEY ("REF_WAREHOUSE_ID") REFERENCES "WAREHOUSE" ("ID")
/
ALTER TABLE EXTERNAL_TRANSACTION ADD CONSTRAINT "SALESREP_ID_FK" FOREIGN KEY ("SALESREP_ID") REFERENCES "SALES_REPRESENTATIVE" ("ID")
/
ALTER TABLE INTERNAL_TRANSACTION ADD CONSTRAINT "PRODUCT_ID_FK1" FOREIGN KEY ("PRODUCT_ID") REFERENCES "PRODUCT" ("ID")
/
ALTER TABLE INTERNAL_TRANSACTION ADD CONSTRAINT "SALESREP_ID_FK1" FOREIGN KEY ("SALESREP_ID") REFERENCES "SALES_REPRESENTATIVE" ("ID")
/
ALTER TABLE SALES_REP_ACTIVITY ADD CONSTRAINT "SALESREP_ID_FK2" FOREIGN KEY ("SALESREP_ID") REFERENCES "SALES_REPRESENTATIVE" ("ID")
/
ALTER TABLE INVENTORY ADD CONSTRAINT "PRODUCT_ID2_FK" FOREIGN KEY ("PRODUCT_ID") REFERENCES "PRODUCT" ("ID")
/
ALTER TABLE INVENTORY ADD CONSTRAINT "WAREHOUSE_ID_FK" FOREIGN KEY ("WAREHOUSE_ID") REFERENCES "WAREHOUSE" ("ID")
/
ALTER TABLE VEHICLE_DETAILS ADD CONSTRAINT "DRIVER_ID_FK" FOREIGN KEY ("DRIVER_ID") REFERENCES "DRIVER_DETAILS" ("ID");
