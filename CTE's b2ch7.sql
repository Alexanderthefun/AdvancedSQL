--insert some oil change records into the database.
insert into oilchangelogs
	(date_occured, vehicle_id)
values
	('2020-01-09', 1),
	('2021-10-30', 2),
	('2019-02-20', 3),
	('2022-03-17', 4)
;


--create a CTE to get cars that require an oil change service.
--Once that is defined, you can now query that set of results as part 
--of a larger query to get all of the information needed.
with vehicles_needing_service as
(
	select
		v.vehicle_id,
		v.year_of_car,
		v.miles_count,
		TO_CHAR(o.date_occured, 'YYYY-MM-DD') date_of_last_change
	from vehicles v
	join oilchangelogs o
		on v.vehicle_id = o.vehicle_id
	where o.date_occured < '2022-01-01'
)
select
	vs.vehicle_id,
	vs.miles_count,
	s.purchase_date,
	e.first_name || ' ' || e.last_name seller,
	c.first_name || ' ' || c.last_name purchaser,
	c.email
from vehicles_needing_service vs 
join sales s
	on s.vehicle_id  = vs.vehicle_id
join employees e
	on s.employee_id = e.employee_id
join customers c
	on s.customer_id = c.customer_id
order by
	vs.vehicle_id,
	s.purchase_date desc;
	

--Since multiple people can purchase the same car over time, the service manager only wants the last purchaser. 
--You can break this part of the SQL out into another CTE. You can use multiple CTEs as part of the query.
-- You separate them with a comma.
with vehicles_needing_service as
(
	select
		v.vehicle_id,
		v.year_of_car,
		v.miles_count,
		TO_CHAR(o.date_occured, 'YYYY-MM-DD') date_of_last_change
	from vehicles v
	join oilchangelogs o
		on v.vehicle_id = o.vehicle_id
	where o.date_occured < '2022-01-01'
),
last_purchase as (
	select
		s.vehicle_id,
		max(s.purchase_date) purchased
	from sales s
	group by s.vehicle_id
)
select
	vs.vehicle_id,       -- Get vehicle id from first CTE
	vs.miles_count,      -- Get miles from first CTE
	lp.purchased,        -- Get purchase date from second CTE
	e.first_name || ' ' || e.last_name seller,
	c.first_name || ' ' || c.last_name purchaser,
	c.email
from vehicles_needing_service vs
join last_purchase lp   -- Join the second CTE
	on lp.vehicle_id  = vs.vehicle_id
join sales s
	on lp.vehicle_id = s.vehicle_id
	and lp.purchased = s.purchase_date
join employees e
	on s.employee_id = e.employee_id
join customers c
	on s.customer_id = c.customer_id
;


--For the top 5 dealerships, which employees made the most sales? 
--*Note: to get a list of the top 5 employees with the associated dealership, you will need to use a 
--Windows function (next chapter). There are other ways you can interpret this query to not return that strict of data.
WITH topDealerships AS (
	SELECT 
		s.dealership_id,
		d.business_name,
		count(DISTINCT sale_id) AS total_sales
		FROM 
		sales s
		JOIN dealerships d ON s.dealership_id = d.dealership_id
		GROUP BY s.dealership_id, d.business_name 
		ORDER BY total_sales DESC 
		LIMIT 5
),
maxSalesPerDealership AS (
	SELECT 
		dealership_id,
		max(sale_count) AS max_sales
		FROM (
			SELECT 
			s.dealership_id,
			s.employee_id,
			Count(DISTINCT s.sale_id) AS sale_count
			FROM
			sales s
			WHERE 
			s.dealership_id IN (SELECT dealership_id FROM topDealerships)
			GROUP BY 
			s.dealership_id, s.employee_id
		) AS EmployeeSales 
		GROUP BY 
		EmployeeSales.dealership_id 
)
SELECT 
	s.dealership_id,
	s.employee_id,
	e.first_name || ' ' || e.last_name seller,
	Count(DISTINCT s.sale_id) AS employee_sales
	FROM sales s
	JOIN employees e ON s.employee_id = e.employee_id 
	JOIN maxSalesPerDealership ms ON s.dealership_id = ms.dealership_id
	WHERE s.dealership_id IN (SELECT dealership_id FROM topDealerships)
	GROUP BY 
	s.dealership_id, s.employee_id, seller, ms.max_sales
	HAVING 
	count(DISTINCT s.sale_id) = ms.max_sales;



	

