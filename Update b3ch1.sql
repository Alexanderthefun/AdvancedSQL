--Update Kristpher Blumfield's dealership that he works at to 20 instead of 9.
UPDATE dealershipemployees de
SET dealership_id = 20
WHERE employee_id IN (
	SELECT 
		e.employee_id
		FROM employees e
		WHERE e.first_name = 'Kristopher' AND e.last_name = 'Blumfield'
		AND de.dealership_id = 9
);


--Update Customer, Ernestus Abeau Sales record which 
--has an invoice number of 9086714242, to a payment method of Mastercard instead of JCB
UPDATE sales s
SET payment_method = 'Mastercard'
WHERE invoice_number = '9086714242';

