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
1. `Create_Database_Object_Script`
    * Existing objects,tables,constraints are dropped.
    * Tables are created and data is inserted.
    * Constraints are applied to tables.
    * Creates view object in database
    * Creates 4 roles :
        - `Master_Admin`
        - `Sales_Rep`
        - `Warehouse_Manager` 
        - `Customer`
    * Role creation script has to be uncommented before execution for first time user.
    * Grants CRUD access database objects to roles. 

3. `Create_Procedures_Functions_Script`
    * Creates 4 Procedures 
        - `Insert_External_Transaction`
        - `Insert_Internal_Transaction`
        - `Insert_Sales_Rep_Activity` 
        - `Update_Inventory`
    * Creates function 
        - `Invoice_View_RLS`
    * Creates Triggers 
        - `Price_Log`
    * Creates Cursor 
        - `Cursor_Price_Log`       

3. `Views_Script`
    * Creates 5 views to generate detailed insights for recorded data.
        - `Sales_view`
        - `Rep_Activity_view`
        - `Shipping_view` 
        - `Invoice_view`
        - `Inventory_view`

4. `Excel file with data`
    * This excel has normalized data for each table and can load dummy transactions for all tables.