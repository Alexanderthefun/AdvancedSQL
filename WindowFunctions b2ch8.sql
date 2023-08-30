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
order by total_employee_sales desc
   
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


--Create a view that shows the employee at 
--each dealership with the most number of sales.
WITH employee_sales_count AS (
    SELECT 
        s.employee_id, 
        d.dealership_id, 
        d.business_name,
        concat(e.last_name, ', ', e.first_name) AS employee_name,
        count(s.sale_id) OVER (PARTITION BY s.employee_id) AS emp_sales
    FROM sales s
    JOIN employees e ON s.employee_id = e.employee_id
    JOIN dealerships d ON d.dealership_id = s.dealership_id
),
ranked_employees AS (
    SELECT 
        business_name, 
        employee_name, 
        emp_sales,
        ROW_NUMBER() OVER (PARTITION BY dealership_id ORDER BY emp_sales DESC) as row_num
    FROM employee_sales_count
)
SELECT 
    business_name, 
    employee_name, 
    emp_sales AS highest_sales_emp
FROM ranked_employees
WHERE row_num = 1
ORDER BY business_name;
