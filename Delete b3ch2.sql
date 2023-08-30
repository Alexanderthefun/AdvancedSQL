--delete the Sales record with an invoice number of '2436217483'.
DELETE FROM sales 
WHERE invoice_number = '2436217483';


--Delete the employee with employee_id of 35

-- (change to a cascade delete since theres a fk_constraint on dealershipemployees)
ALTER TABLE dealershipemployees
DROP CONSTRAINT dealershipemployees_employee_id_fkey,
ADD CONSTRAINT dealershipemployees_employee_id_fkey
	FOREIGN KEY (employee_id)
	REFERENCES employees (employee_id)
	ON DELETE CASCADE;
-- (change to a cascade delete since theres a fk_constraint on sales)
ALTER TABLE sales
DROP CONSTRAINT sales_employee_id_fkey,
ADD CONSTRAINT sales_employee_id_fkey
	FOREIGN KEY (employee_id)
	REFERENCES employees (employee_id)
	ON DELETE CASCADE;
-- finally execute the deletion
DELETE FROM employees 
WHERE employee_id = '35';
