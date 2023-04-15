-- Scripts to generate views

-- 1. SALES REPRESENTATIVE ACTIVITY VIEW 
-- 		This view will provide details for all performce parameters WRT a salesperson.
-- 		This view takes input from sales_rep_activity table and sales_representative table to give conversion rate, average time spent and sum total of interactions

create or replace view rep_activity_view as
select distinct(salesrep_id) as srep_id, (sr.first_name || ' ' || sr.last_name) as srep_name, 
(select round(sum(b.interaction_duration)/ count(b.interaction_duration), 2) from dev1.sales_rep_activity b where b.salesrep_id = s.salesrep_id) as avg_time_spent,
(select count(*) from dev1.sales_rep_activity a where a.salesrep_id = s.salesrep_id) as total_interactions, 
(select count(*) from dev1.sales_rep_activity sra where lower(customer_converted_flag) = 'y' and sra.salesrep_id = s.salesrep_id) as total_conversions, 
round(((select count(*) from dev1.sales_rep_activity x where lower(customer_converted_flag) = 'y' and x.salesrep_id = s.salesrep_id and lower(x.interaction_type) = 'email')*100/ (select count(*) from dev1.sales_rep_activity sra where lower(customer_converted_flag) = 'y' and sra.salesrep_id = s.salesrep_id)), 2) as per_email_conver , 
round(((select count(*) from dev1.sales_rep_activity y where lower(customer_converted_flag) = 'y' and y.salesrep_id = s.salesrep_id and lower(y.interaction_type) = 'inperson')*100/ (select count(*) from dev1.sales_rep_activity sra where lower(customer_converted_flag) = 'y' and sra.salesrep_id = s.salesrep_id)), 2) as per_inperson_converted,
round((select count(salesrep_id) from dev1.sales_rep_activity z where lower(z.customer_converted_flag) = 'y' and z.salesrep_id = s.salesrep_id and lower(z.interaction_type) = 'oncall')*100/ (select count(*) from dev1.sales_rep_activity sra where lower(customer_converted_flag) = 'y' and sra.salesrep_id = s.salesrep_id),2) as per_oncall_converted, 
round((select count(*) from dev1.sales_rep_activity sra where lower(customer_converted_flag) = 'y' and sra.salesrep_id = s.salesrep_id)* 100/ (select count(*) from dev1.sales_rep_activity a where a.salesrep_id = s.salesrep_id), 2) as conversion_percetage
from dev1.sales_rep_activity s
join dev1.sales_representative sr 
on s.salesrep_id = sr.id
order by conversion_percetage desc;


--MANDAR
-- 2. INVOICE VIEW 
-- 		This view will provide details pertaining to customer transaction.
-- 		This view takes input from external_transaction table, customer table, warehouse and product table 
-- 	    This view generates total price of order products, expected delivery date and delivery driver details 

/*
create or replace view invoice_view as
select e.transaction_id, e.customer_id, c.name as customer_name, p.name as product_name, p.selling_price as unit_price, e.quantity as qty,
case when lower(e.transaction_type) = 'p' then (p.selling_price * e.quantity)
    when lower(e.transaction_type) = 'r' then -(p.selling_price * e.quantity) end as total_price,  
sum(case when lower(e.transaction_type) = 'p' then (p.selling_price * e.quantity)
    when lower(e.transaction_type) = 'r' then -(p.selling_price * e.quantity) end) over(partition by to_char(e.date_time, 'MM'), e.customer_id) as month_total,
case when lower(e.transaction_type) = 'p' then 'PURCHASE'
    else 'RETURN' end as order_type, 
to_char(e.date_time, 'DD-MON-YY') as order_date, to_char((e.date_time + INTERVAL '7' DAY), 'DD-MON-YY') as expected_delivery_date, 
(s.first_name||' '||s.last_name) as salesrep_name, v.registration_number as vehicle_num, d.name as driver_name, d.contact as driver_contact
from dev1.external_transaction e
left join customer c 
on e.customer_id = c.id
left join product p
on e.product_id = p.id
left join warehouse w 
on c.ref_warehouse_id = w.id
left join sales_representative s 
on s.ref_warehouse_id = w.id
left join vehicle_details v
on w.vehicle_id = v.id
left join driver_details d
on v.driver_id = d.id;
*/


--MAHAVIR
-- 3. INVENTORY VIEW 
-- 		This view gives parameters of all products available in warehouses, updated as per transactions.
-- 		This view takes input from customer, product,warehouse external_transaction tables. 
--		This view generates a summary of inventory products availabe in warehouse and gives a count and total value as per recorded transactions

/*create or replace view inventory_view as 
select  i.warehouse_id, i.product_id, p.name,  i.product_quantity, p.cost_price,
(i.product_quantity * p.cost_price) as inventory_cost, 
sum(i.product_quantity * p.cost_price) over (partition by  i.warehouse_id) as aggregate_inventory_cost from inventory i 
left join product p 
on i.product_id = p.id;
*/

--SUPREET
-- 4. SALES VIEW 
-- 		This view gives sales metrics for all transactions based on prices provided.
-- 		This view takes input from customer, product,warehouse external_transaction tables. 
--		This view gives profit values based on transaction and quantity of products sold
/*
create or replace view sales_view as 
SELECT
    t."WAREHOUSE_ID",
    t."PROD_ID",
    t.month,
    t."PRODUCT_NAME",
    t."TOTAL_PROFIT",
    SUM(t.total_profit)OVER(PARTITION BY t.warehouse_id, t.month ORDER BY t.month desc) AS warehouse_agg_profit
FROM
    (
        SELECT
            warehouse_id,
            prod_id,
            product_name,
            month,
            SUM(profit) AS total_profit
        FROM
            (
                SELECT
                    w.id                        AS warehouse_id,
                    p.id                        AS prod_id,
                    p.name                      AS product_name,
                    p.selling_price             AS unit_price,
                    to_char(e.date_time, 'Mon') AS month,
                    (
                        CASE
                            WHEN lower(e.transaction_type) = 'p' THEN
                                ( ( p.selling_price - p.cost_price ) * e.quantity )
                            WHEN lower(e.transaction_type) = 'r' THEN
                                - ( ( p.selling_price - p.cost_price ) * e.quantity )
                        END
                    )                           AS profit
                FROM
                    external_transaction e
                    LEFT JOIN customer             c ON e.customer_id = c.id
                    LEFT JOIN product              p ON e.product_id = p.id
                    LEFT JOIN warehouse            w ON c.ref_warehouse_id = w.id
                WHERE
                    to_char(sysdate, 'MM') - to_char(e.date_time, 'MM') <= 1
            )
        GROUP BY
            warehouse_id,
            prod_id,
            product_name,
            month,
            unit_price
    ) t;
*/


--BHAVANA
-- 5. SHIPMENT VIEW 
-- 		This view gives the driver, details for delivering products based on transactions
-- 		This view takes input from  product,driver_details, vehicle_details external_transaction tables. 
--		This view gives profit values based on transaction and quantity of products sold

/*
Create or replace view Shipping_view as 
SELECT
    w.id as warehouse_id, 
    to_char(e.date_time, 'ww')                             AS shipping_week,
    v.registration_number                                  AS vehicle_num,
    d.name                                                 AS driver_name,
    d.contact                                              AS driver_contact,
    listagg(e.transaction_id, ', ') as transaction_ids, 
    e.customer_id,
    c.name                                                 AS customer_name, 
    (ca.address_line_1||' '||ca.address_line_2 ||', '||ca.city||', '||ca.state||'-'||ca.zip_code||', '||ca.country) as customer_address,
    (cco.mobile_no) as customer_contact
FROM
    dev1.external_transaction e
    LEFT JOIN customer                  c ON e.customer_id = c.id
    LEFT JOIN customer_address          ca ON c.id = ca.id
    LEFT JOIN customer_contact          cco ON c.id = cco.id
    LEFT JOIN product                   p ON e.product_id = p.id
    LEFT JOIN warehouse                 w ON c.ref_warehouse_id = w.id
    LEFT JOIN sales_representative      s ON s.ref_warehouse_id = w.id
    LEFT JOIN vehicle_details           v ON w.vehicle_id = v.id
    LEFT JOIN driver_details            d ON v.driver_id = d.id
    Group by ( w.id, e.customer_id,
    c.name, 
    (ca.address_line_1||' '||ca.address_line_2 ||', '||ca.city||', '||ca.state||'-'||ca.zip_code||', '||ca.country),
    (cco.mobile_no),
    to_char(e.date_time, 'ww'), 
    v.registration_number,
    d.name,
    d.contact)
    order by to_char(e.date_time, 'ww') desc, driver_name;
*/