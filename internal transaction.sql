Create or replace Procedure insert_int_tran
    (war_fr int, war_to int , prod_id int, qty int)
As
    old_qty_fr int;
    new_qty_fr int;
    old_qty_to int;
    new_qty_to int;
Begin 
        select product_quantity into old_qty_fr from inventory where warehouse_id = war_fr and  product_id = prod_id;
        select product_quantity into old_qty_to from inventory where warehouse_id = war_to and  product_id = prod_id;
        new_qty_fr := old_qty_fr - qty;
        new_qty_to := old_qty_to + qty;
    If (old_qty_fr >= qty) then 
        insert into internal_transaction values (INTERNAL_TRANSACTION_SEQ.NEXTVAL, war_fr, war_to, prod_id, 323001 , sysdate, qty); 
        commit;
        update inventory set product_quantity = new_qty_fr where product_id = prod_id and warehouse_id = war_fr;
        commit;
        update inventory set product_quantity = new_qty_to where product_id = prod_id and warehouse_id = war_to;
        commit; 
    end if; 
if (old_qty_fr < qty) then 
        dbms_output.put_line('Maximum Quantity Available in Warehouse ' ||  war_fr || ' is ' || old_qty_fr);
    end if;     
End;