GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.PRODUCT TO MASTER_ADMIN;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.CUSTOMER TO MASTER_ADMIN;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.CUSTOMER_ADDRESS TO MASTER_ADMIN;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.CUSTOMER_CONTACT TO MASTER_ADMIN;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.DRIVER_DETAILS TO MASTER_ADMIN;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.EXTERNAL_TRANSACTION TO MASTER_ADMIN;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.INTERNAL_TRANSACTION TO MASTER_ADMIN;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.INVENTORY TO MASTER_ADMIN;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.SALES_REP_ACTIVITY TO MASTER_ADMIN;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.SALES_REPRESENTATIVE TO MASTER_ADMIN;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.VEHICLE_DETAILS TO MASTER_ADMIN;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.WAREHOUSE TO MASTER_ADMIN;

GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.PRODUCT TO WAREHOUSE_MANAGER;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.DRIVER_DETAILS TO WAREHOUSE_MANAGER;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.INTERNAL_TRANSACTION TO WAREHOUSE_MANAGER;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.INVENTORY TO WAREHOUSE_MANAGER;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.VEHICLE_DETAILS TO WAREHOUSE_MANAGER;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.WAREHOUSE TO WAREHOUSE_MANAGER;



GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.PRODUCT TO SALES_REP;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.CUSTOMER TO SALES_REP;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.CUSTOMER_ADDRESS TO SALES_REP;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.CUSTOMER_CONTACT TO SALES_REP;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.EXTERNAL_TRANSACTION TO SALES_REP;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.SALES_REP_ACTIVITY TO SALES_REP;
GRANT UPDATE,DELETE,INSERT,SELECT ON DEV1.SALES_REPRESENTATIVE TO SALES_REP;

