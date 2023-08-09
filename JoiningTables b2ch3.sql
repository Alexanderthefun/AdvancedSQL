--Get a list of the sales that were made for each sales type.
SELECT s.sale_id, t.sales_type_name
FROM sales s 
LEFT JOIN salestypes t ON s.sales_type_id = t.sales_type_id 
ORDER BY t.sales_type_name ASC


--Get a list of sales with the VIN of the vehicle, the first name and last name of the customer, first name and last name of the employee who made the sale and the name, city and state of the dealership.
SELECT 	s.sale_id,
		v.vin, 
		c.first_name, c.Last_name, 
		e.first_name, e.last_name, 
		d.city, d.state
FROM sales s 
INNER JOIN customers c ON s.customer_id = c.customer_id 
INNER JOIN vehicles v ON s.vehicle_id = v.vehicle_id 
INNER JOIN employees e ON s.employee_id  = e.employee_id 
INNER JOIN dealerships d ON s.dealership_id = d.dealership_id 



--Get a list of all the dealerships and the employees, if any, working at each one.
SELECT 	d.business_name,
		e.first_name, e.last_name
FROM dealershipemployees de
LEFT JOIN employees e ON de.employee_id = e.employee_id 
LEFT OUTER JOIN dealerships d ON de.dealership_id = d.dealership_id 
ORDER BY d.business_name 



--Get a list of vehicles with the names of the body type, make, model and color.
SELECT v.vehicle_id,
		vt.body_type, vt.make, vt.model
FROM vehicles v 
LEFT JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id 