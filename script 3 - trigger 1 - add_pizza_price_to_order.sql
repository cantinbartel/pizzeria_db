-- Once the script is executed, the trigger will be created
-- Then every time a record is inserted into the order_line table, this TRIGGER will be executed automatically
USE pizzeria_db;

DELIMITER $$

CREATE TRIGGER add_pizza_price_to_order
	AFTER INSERT ON order_line
    FOR EACH ROW 
BEGIN
	DECLARE pizza_price DECIMAL(4,2);
	DECLARE pizza_by_quantity_price FLOAT;
    
    SET pizza_price = (
		SELECT price
        FROM pizza
        WHERE pizza_id = NEW.fk_pizza_id
	);
    SET pizza_by_quantity_price = NEW.quantity * pizza_price;
    
    -- Updates order total price by adding the pizza price multiplied by the quantity chosen 
	UPDATE `order`
	SET total_price = total_price + pizza_by_quantity_price
    WHERE order_id = NEW.fk_order_id;
END $$

DELIMITER ;