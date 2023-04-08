set serveroutput on

--Store Procedure For Inserting External Transaction Table 
Create or replace Procedure insert_Ext_tran
    (transaction_id int ,prod_id int, customer_id int ,
    transaction_type dev1.external_transaction.transaction_type%type, quantity int)
As
    ref_war int;
    sales_rep int;
    old_qty int;
    new_qty int;
    inv_val int;
Begin
    select ref_warehouse_id into ref_war from dev1.customer where id = customer_id;
    select id into sales_rep from dev1.sales_representative where ref_warehouse_id = ref_war;
    select product_quantity into inv_val from dev1.inventory where product_id = prod_id and warehouse_id = ref_war; 
    select product_quantity into old_qty from dev1.inventory where product_id = prod_id and warehouse_id = ref_war;
    if (inv_val >= quantity and transaction_type = 'P') then 
        insert into dev1.external_transaction values (transaction_id, prod_id, customer_id, ref_war, sales_rep,
        transaction_type, sysdate ,quantity);
        commit;
        new_qty := old_qty - quantity;
        update dev1.inventory set product_quantity = new_qty where product_id = prod_id and warehouse_id = ref_war;
        commit;
    end if;
    if (transaction_type = 'R') then 
        insert into dev1.external_transaction values (transaction_id, prod_id, customer_id, ref_war, sales_rep,
        transaction_type, sysdate ,quantity);
        commit;
        new_qty := old_qty + quantity;
        update dev1.inventory set product_quantity = new_qty where product_id = prod_id and warehouse_id = ref_war;
        commit;
    end if;
    if (inv_val < quantity and transaction_type = 'P') then
    dbms_output.put_line('Maximum '|| inv_val || ' quantity can be purchased. Please inform warehouse manager for more quantity required'); 
    end if;
    if transaction_type not in ('P', 'R') then
    dbms_output.put_line('Incorrect Transaction Type');
    end if;  
exception when no_data_found then 
    dbms_output.put_line('Incorrect Transaction Details');
end;


execute insert_Ext_tran (23210037, 223003, 123007, 'R', 120);

--Store Procedure For Inserting Internal Transaction Table  
select * from dev1.internal_transaction;
select * from dev1.inventory order by product_id, warehouse_id;
select * from dev1.customer;


Create or replace Procedure insert_int_tran
    (transaction_id int, war_fr int, war_to int , prod_id int, qty int)
As
    old_qty_fr int;
    new_qty_fr int;
    old_qty_to int;
    new_qty_to int;
Begin 
        select product_quantity into old_qty_fr from dev1.inventory where warehouse_id = war_fr and  product_id = prod_id;
        select product_quantity into old_qty_to from dev1.inventory where warehouse_id = war_to and  product_id = prod_id;
        new_qty_fr := old_qty_fr - qty;
        new_qty_to := old_qty_to + qty;
    If (old_qty_fr >= qty) then 
        insert into dev1.internal_transaction values (transaction_id, war_fr, war_to, prod_id, 323001 , sysdate, qty); 
        commit;
        
        update dev1.inventory set product_quantity = new_qty_fr where product_id = prod_id and warehouse_id = war_fr;
        commit;
        update dev1.inventory set product_quantity = new_qty_to where product_id = prod_id and warehouse_id = war_to;
        commit; 
    end if; 
    if (old_qty_fr < qty) then 
        dbms_output.put_line('Maximum Quantity Available in Warehouse ' ||  war_fr || ' is ' || old_qty_fr);
    end if;     
End; 

execute insert_int_tran(23110023, 6604, 6601, 223001, 500);



