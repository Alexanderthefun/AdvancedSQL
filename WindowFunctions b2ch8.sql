--a list of total sales per employee in the database.
select distinct
	employees.last_name || ', ' || employees.first_name employee_name,
	sales.employee_id,
	sum(sales.price) over() total_sales,
	sum(sales.price) over(partition by employees.employee_id) total_employee_sales
from
	employees
join
	sales
on
	sales.employee_id = employees.employee_id
order by employee_name
   
--Write a query that shows the total purchase sales income per dealership.
SELECT DISTINCT 
	d.dealership_id,
	d.business_name,
	sum(s.price) over(PARTITION BY d.dealership_id) total_dealership_sales
FROM 
	dealerships d 
JOIN 
	sales s ON s.dealership_id = d.dealership_id 
ORDER BY total_dealership_sales DESC 

--Write a query that shows the purchase sales income per dealership for July of 2020.
SELECT DISTINCT 
	d.dealership_id,
	d.business_name,
	sum(s.price) over(PARTITION BY d.dealership_id) total_dealership_sales
FROM 
	dealerships d 
JOIN 
	sales s ON s.dealership_id = d.dealership_id 
WHERE s.purchase_date >= '2020-07-01' AND s.purchase_date < '2020-08-01'
ORDER BY total_dealership_sales DESC 

--Write a query that shows the purchase sales income per dealership for all of 2020.
SELECT DISTINCT 
	d.dealership_id,
	d.business_name,
	sum(s.price) over(PARTITION BY d.dealership_id) total_dealership_sales
FROM 
	dealerships d 
JOIN 
	sales s ON s.dealership_id = d.dealership_id 
WHERE s.purchase_date >= '2020-01-01' AND s.purchase_date < '2021-01-01'
ORDER BY total_dealership_sales DESC

--Write a query that shows the total lease income per dealership.
SELECT DISTINCT 
	d.dealership_id,
	d.business_name,
	sum(s.price) over(PARTITION BY d.dealership_id) total_dealership_sales
FROM 
	dealerships d 
JOIN 
	sales s ON s.dealership_id = d.dealership_id 
WHERE s.sales_type_id = 2
ORDER BY total_dealership_sales DESC

--Write a query that shows the lease income per dealership for Jan of 2020.
SELECT DISTINCT 
	d.dealership_id,
	d.business_name,
	sum(s.price) over(PARTITION BY d.dealership_id) total_dealership_sales
FROM 
	dealerships d 
JOIN 
	sales s ON s.dealership_id = d.dealership_id 
WHERE s.purchase_date >= '2020-01-01' AND s.purchase_date < '2021-02-01' AND s.sales_type_id = 2
ORDER BY total_dealership_sales DESC

--Write a query that shows the lease income per dealership for all of 2019.
SELECT DISTINCT 
	d.dealership_id,
	d.business_name,
	sum(s.price) over(PARTITION BY d.dealership_id) total_dealership_sales
FROM 
	dealerships d 
JOIN 
	sales s ON s.dealership_id = d.dealership_id 
WHERE s.purchase_date >= '2019-01-01' AND s.purchase_date < '2020-01-01' AND s.sales_type_id = 2
ORDER BY total_dealership_sales DESC

--Write a query that shows the total income (purchase and lease) per employee.
SELECT DISTINCT 
	e.employee_id,
	e.first_name || ' ' || e.last_name employee_name,
	sum(s.price) over(PARTITION BY e.employee_id) total_Employee_Sales
FROM 
	employees e 
JOIN 
	sales s ON s.employee_id = e.employee_id
ORDER BY total_Employee_Sales DESC
