Create or replace Procedure insert_Ext_tran
    (prod_id int, customer_id int ,
    transaction_type external_transaction.transaction_type%type, quantity int)
As
    ref_war int;
    sales_rep int;
    old_qty int;
    new_qty int;
    inv_val int;
Begin
    select ref_warehouse_id into ref_war from customer where id = customer_id;
    select id into sales_rep from sales_representative where ref_warehouse_id = ref_war;
    select product_quantity into inv_val from inventory where product_id = prod_id and warehouse_id = ref_war; 
    select product_quantity into old_qty from inventory where product_id = prod_id and warehouse_id = ref_war;
    if (inv_val >= quantity and transaction_type = 'P') then 
        insert into external_transaction values (EXTERNAL_TRANSACTION_SEQ.NEXTVAL, prod_id, customer_id, ref_war, sales_rep,
        transaction_type, sysdate ,quantity);
        commit;
        new_qty := old_qty - quantity;
        update inventory set product_quantity = new_qty where product_id = prod_id and warehouse_id = ref_war;
        commit;
end if;
    if (transaction_type = 'R') then 
        insert into external_transaction values (EXTERNAL_TRANSACTION_SEQ.NEXTVAL, prod_id, customer_id, ref_war, sales_rep,
        transaction_type, sysdate ,quantity);
        commit;
        new_qty := old_qty + quantity;
        update inventory set product_quantity = new_qty where product_id = prod_id and warehouse_id = ref_war;
        commit;
    end if;
    if (inv_val < quantity and transaction_type = 'P') then
    dbms_output.put_line('Maximum '|| inv_val || ' quantity can be purchased. Please inform warehouse manager for more quantity required'); 
    end if;
    if transaction_type not in ('P', 'R') then
    dbms_output.put_line('Incorrect Transaction Type');
    end if;  
exception when others then 
    dbms_output.put_line('Incorrect Transaction Details');
end;
