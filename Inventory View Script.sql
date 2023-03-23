create view Inventory_View as (
select 
w.id "Warehouse_ID",
w.name "Warehouse_Name",
p.id "Product_ID",
p.name "Product_Name",
sum(it.quantity) "Quantity Left"
from internal_transaction it
inner join warehouse w
on w.id = it.warehouse_to
inner join product p
on it.product_id = p.id
group by
w.id,
w.name,
p.id,
p.name
)
;