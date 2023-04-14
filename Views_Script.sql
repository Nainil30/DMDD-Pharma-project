-- Scripts to generate views

-- 1. SALES REPRESENTATIVE ACTIVITY VIEW 
-- 		This view will provide details for all performce parameters WRT a salesperson.
-- 		This view takes input from sales_rep_activity table and sales_representative table to give conversion rate, average time spent and sum total of interactions


select distinct(salesrep_id) as srep_id, (sr.first_name || ' ' || sr.last_name) as srep_name, 
(select round(sum(b.interaction_duration)/ count(b.interaction_duration), 2) from dev1.sales_rep_activity b where b.salesrep_id = s.salesrep_id) as avg_time_spent,
(select count(*) from dev1.sales_rep_activity a where a.salesrep_id = s.salesrep_id) as total_interactions, 
(select count(*) from dev1.sales_rep_activity sra where lower(customer_converted_flag) = 'y' and sra.salesrep_id = s.salesrep_id) as total_conversions, 
round(((select count(*) from dev1.sales_rep_activity x where lower(customer_converted_flag) = 'y' and x.salesrep_id = s.salesrep_id and lower(x.interaction_type) = 'email')*100/ (select count(*) from dev1.sales_rep_activity sra where lower(customer_converted_flag) = 'y' and sra.salesrep_id = s.salesrep_id)), 2) as per_email_conver , 
round(((select count(*) from dev1.sales_rep_activity y where lower(customer_converted_flag) = 'y' and y.salesrep_id = s.salesrep_id and lower(y.interaction_type) = 'inperson')*100/ (select count(*) from dev1.sales_rep_activity sra where lower(customer_converted_flag) = 'y' and sra.salesrep_id = s.salesrep_id)), 2) as per_inperson_converted,
round((select count(salesrep_id) from dev1.sales_rep_activity z where lower(z.customer_converted_flag) = 'y' and z.salesrep_id = s.salesrep_id and lower(z.interaction_type) = 'oncall')*100/ (select count(*) from dev1.sales_rep_activity sra where lower(customer_converted_flag) = 'y' and sra.salesrep_id = s.salesrep_id),2) as per_oncall_converted, 
round((select count(*) from dev1.sales_rep_activity sra where lower(customer_converted_flag) = 'y' and sra.salesrep_id = s.salesrep_id)* 100/ (select count(*) from dev1.sales_rep_activity a where a.salesrep_id = s.salesrep_id), 2) as per_total_conversion
from dev1.sales_rep_activity s
join dev1.sales_representative sr 
on s.salesrep_id = sr.id
order by per_total_conversion desc;



-- 2. INVOICE VIEW 
-- 		This view will provide details pertaining to customer transaction.
-- 		This view takes input from external_transaction table, customer table, warehouse and product table 
-- 	    This view generates total price of order products, expected delivery date and delivery driver details 



-- 3. INVENTORY VIEW 
-- 		This view gives parameters of all products available in warehouses, updated as per transactions.
-- 		This view takes input from customer, product,warehouse external_transaction tables. 
--		This view generates a summary of inventory products availabe in warehouse and gives a count and total value as per recorded transactions




-- 4. SALES VIEW 
-- 		This view gives sales metrics for all transactions based on prices provided.
-- 		This view takes input from customer, product,warehouse external_transaction tables. 
--		This view gives profit values based on transaction and quantity of products sold



-- 5. SHIPMENT VIEW 
-- 		This view gives the driver, details for delivering products based on transactions
-- 		This view takes input from  product,driver_details, vehicle_details external_transaction tables. 
--		This view gives profit values based on transaction and quantity of products sold
