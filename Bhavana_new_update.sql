--1)Selling Price value can be updated by using UpdateSellingPriceTrigger.

create or replace TRIGGER UpdateSellingPriceTrigger
BEFORE INSERT ON PRODUCT
FOR EACH ROW
Declare
    Selling_price Product.cost_price%type;
BEGIN
    SELLING_PRICE := :NEW.COST_PRICE * 1.2;
END;


--Display new customer name when new customer data is inserted
create or replace TRIGGER CUSTOMER_1
AFTER INSERT ON CUSTOMER
FOR EACH ROW
DECLARE
  v_customer_name CUSTOMER.NAME%TYPE; 
BEGIN
  v_customer_name := :NEW.name;
  SELECT name INTO v_customer_name FROM customer
  WHERE id = :NEW.id; 
 DBMS_OUTPUT.PUT_LINE('Customer Name: ' || :NEW.NAME);
END;

--when quantity details is updated on INTERNAL_TRANSACTION table then quantity will also be updated on INVENTORY table.

create or replace TRIGGER UpdateInventoryTrigger_Internal1 
AFTER INSERT ON INTERNAL_TRANSACTION
FOR EACH ROW
DECLARE
    product_quantity Internal_Transaction.quantity%TYPE;
BEGIN    
    UPDATE INVENTORY 
    SET PRODUCT_QUANTITY = PRODUCT_QUANTITY - :NEW.QUANTITY 
    WHERE PRODUCT_ID = :NEW.PRODUCT_ID AND WAREHOUSE_ID = :NEW.WAREHOUSE_FROM;
END;

--When quantity details is updated on EXTERNAL_TRANSACTION table then quantity will also be updated on INVENTORY table.
CREATE OR REPLACE TRIGGER UpdateInventoryTrigg
AFTER INSERT ON EXTERNAL_TRANSACTION
FOR EACH ROW
DECLARE
    product_quantity External_Transaction.quantity%TYPE;
BEGIN
    UPDATE INVENTORY
    SET PRODUCT_QUANTITY = PRODUCT_QUANTITY - :NEW.QUANTITY
    WHERE PRODUCT_ID = :NEW.PRODUCT_ID AND WAREHOUSE_ID = :NEW.REF_WAREHOUSE_ID;
END;



create or replace TRIGGER ShowCustomerDetail
AFTER INSERT ON customer_address
FOR EACH ROW
DECLARE
    mobile_number VARCHAR(30);
    customer_name VARCHAR(50);
BEGIN
    SELECT MOBILE_NO INTO mobile_number FROM customer_contact WHERE ID = :NEW.ID;
    SELECT NAME INTO customer_name FROM customer WHERE ID = :NEW.ID;
    INSERT INTO temp_table VALUES ('New Customer Name: ' || customer_name || 
        ' Mobile Number: ' || mobile_number || ' from region ' || :NEW.REGION || ' got onboarded');
END;
