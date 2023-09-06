CREATE FUNCTION set_pickup_date()
	RETURNS TRIGGER 
	LANGUAGE PLPGSQL
AS $$
BEGIN 
	UPDATE sales 
	SET pickup_date = NEW.purchase_date + integer '7'
	WHERE sales.sale_id = NEW.sale_id;
RETURN NULL;
END;
$$

CREATE TRIGGER new_sale_made
AFTER INSERT 
ON sales
FOR EACH ROW 
EXECUTE PROCEDURE set_pickup_date();

--quick insert to sales
INSERT INTO sales (sales_type_id, vehicle_id, employee_id, customer_id, dealership_id, price, deposit, purchase_date, pickup_date, invoice_number, payment_method, sale_returned)
VALUES (1, 3, 394, 857, 12, 20227.27, 2270, '2023-09-01', '2023-09-02', 1002705227, 'bankcard', false)

--create a tigger function that will automatically adjust the format of a newly inserted or updated 
--dealership to: 'http://www.carnivalcars.com/{name of the dealership with underscores separating words'
CREATE FUNCTION set_url()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
AS $$
BEGIN 
	UPDATE dealerships 
	SET website = 'http://www.carnivalcars.com/' || REPLACE(LOWER(NEW.business_name), ' ', '_');
	WHERE dealership_id = NEW.dealership_id
RETURN NULL; 
END;
$$

CREATE TRIGGER new_dealership_made
AFTER INSERT 
ON dealerships
FOR EACH ROW 
EXECUTE PROCEDURE set_url();

--If a phone number is not provided for a new dealership, set the phone number 
--to the default customer care number 777-111-0305.
CREATE FUNCTION set_phone_number()
	RETURNS TRIGGER 
	LANGUAGE PLPGSQL
AS $$
BEGIN 
	IF NEW.phone IS NULL THEN
	NEW.phone = '777-111-0305';
	END IF;
RETURN NULL;
END;
$$;

CREATE TRIGGER dealer_phone
BEFORE INSERT ON dealerships
FOR EACH ROW
EXECUTE FUNCTION set_phone_number();

--For accounting purposes, the name of the state needs to be part of the dealership's tax id. At the end.
CREATE FUNCTION set_tax_id()
	RETURNS TRIGGER 
	LANGUAGE PLPGSQL
AS $$
DECLARE 
	d_state_name varchar;
BEGIN 
	SELECT state INTO d_state_name FROM dealerships WHERE dealership_id = NEW.dealership_id;
	IF POSITION(d_state_name IN NEW.tax_id) = 0 THEN 
		NEW.tax_id = NEW.tax_id || '--' || d_state_name;
END IF;
RETURN NEW;
END;
$$; 

CREATE TRIGGER set_tax_id
BEFORE INSERT OR UPDATE ON dealerships
FOR EACH ROW 
EXECUTE FUNCTION set_tax_id();


INSERT INTO dealerships(business_name, phone, city, state, website, tax_id)
VALUES ('Toyota of Hell', NULL, 'Nashville', 'Tennessee', 'http://www.boomersofNashville.com', 'si-214-tn-b82h')

SELECT * FROM dealerships 
WHERE business_name = 'Toyota of Hell'
LIMIT 3




	