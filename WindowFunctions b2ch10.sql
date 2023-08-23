--Which model of vehicle has the lowest current inventory? 
--This will help dealerships know which models the purchase from manufacturers.

SELECT 
	v.vehicle_id,
	vt.make || ' ' || vt.model vehicle_type,
	