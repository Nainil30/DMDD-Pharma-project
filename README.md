# DMDD-Pharma-project
This project aims to cover the process of customer acquisition through `sales representatives` and placement of orders as per requirements of the `customer` 
(eg: Doctor, Pharmacy, Hospital) and tracks orders in transactions and gives shipment details  
## Members
```
Mandar Jadhav       2784429
Supreet Munavalli   2687930
Nainil Maladkar     2780019 
Mahavir Kathed      2749678
Bhavana Lingareddy  2797386
```
### Workflow 
- Sales Representative will hold meeting with a potential customer in `Sales_Rep_Activity table`, in his region, to convert them in permanent customers. 
- Customer will place order to sales representative, tracked under `External Transaction table` making use of details from `product`, `customer`, `inventory` table. 
- If stock available in inventory, sales representative will place the order.
- If stock is not available, Sales representative will inform warehouse manager and transaction will be logged under `internal transaction table`
- Warehouse manager will request other warehouses about requirement and internal transaction will be initiated. 
- Once the stock fullfilled in respective inventory, customer's order will be placed. 
- For every transaction, warehouse manager will assign shipping details through `vehicle and driver details tables` and order will be delivered.

### Code execution
1. `Database Object Creation and Data Insertion`
    * Existing objects,tables,constraints are dropped.
    * Tables are created and data is inserted.
    * Constraints are applied to tables.

2. `DDL_Views Creation`
    * Creates view object in database

3. `Grant Priviledges to Roles`
    * Creates 4 roles :
        - `Master_Admin`
        - `Sales_Rep`
        - `Warehouse_Manager` 
        - `Customer`
    * Role creation script has to be uncommented before execution for first time user.
    * Grants CRUD access database objects to roles. 

4. `Create Users and assign roles`
    * Creates users under spefic roles to acess vies, tables and can perform CRUD operation as per access level

5. `Excel file with data`
    * This excel has normalized data for each table and can load dummy transactions for all tables.