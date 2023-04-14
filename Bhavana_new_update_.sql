--Customer name can be updated in procedure using customer ID.

CREATE OR REPLACE PROCEDURE UpdateCustomerName(
    customer_id IN NUMBER,
    new_name IN VARCHAR2
)
IS
BEGIN
    UPDATE CUSTOMER SET Name = new_name WHERE ID = customer_id;
END;

--ID name and region of customer is passed into procedure arguments, then the procedure will check whether the ID and region already exists in the table then the Customer onboarded message is displayed.
CREATE OR REPLACE PROCEDURE CustomerInsert(
    new_id IN INT,
    new_name IN VARCHAR2,
    new_region IN VARCHAR2
)
IS
    TotalAddressCount INT;
    TotalContactCount INT;
BEGIN
    SELECT COUNT(*) INTO TotalAddressCount FROM CUSTOMER_ADDRESS WHERE ID = new_id;
    SELECT COUNT(*) INTO TotalContactCount FROM CUSTOMER_CONTACT WHERE ID = new_id;
     
    IF TotalAddressCount > 0 AND TotalContactCount > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Customer ' || new_name || ' got onboarded in region ' || new_region);
    END IF;
END;
/

--call CustomerInsert(123020, 'Stella', 'Cambridge');

--Customer Address is inserted for customers using below procedure.

CREATE OR REPLACE PROCEDURE AddCustomerAddress(
    customer_id IN INT,
    address_line_1 IN VARCHAR2,
    address_line_2 IN VARCHAR2,
    city IN VARCHAR2,
    region IN VARCHAR2,
    state IN VARCHAR2,
    zip_code IN INT,
    country IN VARCHAR2
)
IS
BEGIN
    INSERT INTO CUSTOMER_ADDRESS (ID, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, REGION, STATE, ZIP_CODE, COUNTRY)
    VALUES (customer_id, address_line_1, address_line_2, city, region, state, zip_code, country);
END;