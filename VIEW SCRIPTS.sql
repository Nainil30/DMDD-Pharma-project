
/*script to create SALES VIEW.
It can be accessed by Sales Representatives */ 
CREATE OR REPLACE VIEW SALES_V as (
select w.id as "WAREHOUSE_ID",
w.name as "WAREHOUSE_NAME",
p.id "PRODUCT_ID",
p.name "PRODUCT_NAME",
to_char(et.date_time,'DD') "DAY",
to_char(et.date_time,'Mon') "MONTH",
to_char(et.date_time,'YYYY') "YEAR",
p.selling_price "SELLING_PRICE",
et.quantity "QUANTITY",
p.selling_price * et.quantity as "TOTAL_SALES_COST"
from DEV1.external_transaction et
inner join DEV1.product p
    on et.product_id = p.id
inner join DEV1.warehouse w
    on et.ref_warehouse_id = w.id
);


/*script to create SALES REPRESENTATIVE ACTIVITY VIEW.
It can be used to check performance of Sales Representatives*/
CREATE OR REPLACE VIEW SALES_REP_ACTIVITY_V as (
select
sr.id as "REP_ID",
sr.first_name || sr.last_name as "REP_NAME",
to_char(interaction_date,'MON') as "MONTH",
to_char(interaction_date,'YYYY') as "YEAR",
count(sra.meeting_id) as "TOTAL_MEETINGS_SCHEDULED",
count(sra.interaction_duration) as "TOTAL_MEETIN_DURATION",
count(sra.customer_converted_flag) as "TOTAL_CUSTOMERS_CONVERTED"
from DEV1.sales_rep_activity sra
inner join DEV1.sales_representative sr
on sr.id = sra.salesrep_id
where sra.customer_converted_flag = 'Y'
group by 
sr.id, 
sr.first_name || sr.last_name,
to_char(interaction_date,'MON'),
to_char(interaction_date,'YYYY')
);


/*script to create INVENTORY VIEW
It can be accessed by Sales Representatives to check available quantity of products.*/
CREATE OR REPLACE VIEW INVENTORY_V as (
select 
w.id "WAREHOUSE_ID",
w.name "WAREHOUSE_Name",
p.id "PRODUCT_ID",
p.name "PRODUCT_Name",
sum(it.quantity) "QUANTITY LEFT"
from DEV1.internal_transaction it
inner join DEV1.warehouse w
on w.id = it.warehouse_to
inner join DEV1.product p
on it.product_id = p.id
group by
w.id,
w.name,
p.id,
p.name
);



/*script to create INVOICE VIEW
It is for customers to check the delivery time and qunatity of products.*/
CREATE OR REPLACE VIEW INVOICE_V as (
select 
c.id "CUSTOMER_ID",
c.name "CUSTOMER_NAME",
et.transaction_id "TRANSACTION_ID",
p.id "Product_ID",
p.name "PRODUCT_NAME",
et.quantity "QUANTITY",
p.selling_price "PRICE",
p.selling_price * et.quantity "TOTAL_COST",
to_char(et.date_time,'DD-Mon-YYYY') "TRANSACTION_DATE",
v.id "VEHICLE_ID",
d.name "DRIVER_NAME",
to_char((et.date_time + 7),'DD-Mon-YYYY') "EXPECTED_DELIVERY_DATE"
from DEV1.external_transaction et
inner join DEV1.customer c
on c.id = et.customer_id
inner join DEV1.product p
on p.id = et.product_id
inner join DEV1.warehouse w
on w.id = et.ref_warehouse_id
inner join DEV1.vehicle_details v
on w.vehicle_id = v.id
inner join DEV1.driver_details d
on v.driver_id = d.id
);

