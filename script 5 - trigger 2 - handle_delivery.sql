-- Once the script is executed, the trigger will be created
-- Then every time a record is inserted into the address table, this TRIGGER will be executed automatically
USE pizzeria_db;

DELIMITER $$

CREATE TRIGGER handle_delivery
	AFTER INSERT ON address
    FOR EACH ROW
BEGIN
	SET @delivery_fees = (
		SELECT delivery_fees
        FROM location_area
        WHERE area_id = NEW.fk_area_id
    );
    
	-- Finds the delivery man assigned to the area corresponding to the delivery adress area gived by the client
    SET @corresponding_delivery_man = (
		SELECT delivery_man_id
		FROM delivery_man
		WHERE fk_area_id = NEW.fk_area_id
	);
    
    -- A delivery is composed of many delivery tickets
    -- A delivery is assigned to a specific delivery man depending on a certain area
    -- This statement finds the latest delivery assigned to this delivery man
    SET @last_corresponding_delivery = (
		SELECT delivery_id
		FROM delivery
		where fk_delivery_man_id = @corresponding_delivery_man
		ORDER BY delivery_id DESC LIMIT 1
    );
    
    -- Total number of pizza in the latest delivery found above (composed of many different order tickets) 
    SET @nb_of_pizza_already_in_delivery = (
		SELECT pizza_number
        FROM delivery 
        WHERE delivery_id = @last_corresponding_delivery
    );
    
	SET @latest_order_id = (
		SELECT order_id
		FROM `order`
		ORDER BY order_id DESC LIMIT 1
	);
    
    -- Finds the total number of pizzas corresponding on the current order
    SET @corresponding_order_pizza_number = (
		SELECT
			SUM(quantity) AS sum_pizza
		FROM order_line
		WHERE fk_order_id = @latest_order_id
		GROUP BY fk_order_id
    );
    
    -- Finds the number of deliveries already assigned to a delivery man
    SET @number_of_deliveries_by_transporter = (
		SELECT count(*)
		FROM delivery
		WHERE fk_delivery_man_id = @corresponding_delivery_man
    );
    
    -- If no previous deliveries assigned to the delivery man found 
    -- or the last delivery already contains more than a certain amount of pizza
    -- then create a new delivery 
    -- else update number of pizza in the current delivery
    IF @number_of_deliveries_by_transporter = 0 OR @nb_of_pizza_already_in_delivery > 10 THEN
        INSERT INTO delivery (fk_delivery_man_id, pizza_number)
		SELECT @corresponding_delivery_man, @corresponding_order_pizza_number;
	ELSE 
		UPDATE delivery
		SET pizza_number = pizza_number + @corresponding_order_pizza_number
		WHERE delivery_id = @last_corresponding_delivery;
    END IF;
    
    -- Link the delivery ticket to the current delivery
	INSERT INTO delivery_ticket (
		delivery_fees,
		fk_address_id,
		fk_order_id,
		fk_delivery_id) 
    SELECT
		@delivery_fees, NEW.address_id, @latest_order_id , delivery_id
        FROM delivery
        WHERE delivery_id = (
				SELECT delivery_id
				FROM delivery
                WHERE fk_delivery_man_id = @corresponding_delivery_man
				ORDER BY delivery_id DESC LIMIT 1
		);
	
    -- Delivery fees are finally added to the order total price
	UPDATE `order`
    SET total_price = total_price + @delivery_fees
    WHERE order_id = @latest_order_id;    
END $$

DELIMITER ;