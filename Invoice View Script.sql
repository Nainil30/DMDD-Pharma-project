create view Invoice_View as (
select 
c.id "Customer_ID",
c.name "Customer_Name",
et.transaction_id "Transaction_ID",
p.id "Product_ID",
p.name "Product_Name",
et.quantity "Quantity",
p.selling_price "Price",
p.selling_price * et.quantity "Total_Cost",
to_char(et.date_time,'DD-Mon-YYYY') "Transaction_Date",
v.id "Vehicle_ID",
d.name "Driver_Name",
to_char((et.date_time + 7),'DD-Mon-YYYY') "Expected_Delivery_Date"
from external_transaction et
inner join customer c
on c.id = et.customer_id

inner join product p
on p.id = et.product_id

inner join warehouse w
on w.id = et.ref_warehouse_id

inner join vehicle_details v
on w.vehicle_id = v.id

inner join driver_details d
on v.driver_id = d.id
)
;
