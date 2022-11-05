-- PROCEDURE checks wheter the delivery option is true or false
-- If true --> INSERT the address record into the address table

USE pizzeria_db;

DELIMITER $$

CREATE PROCEDURE check_for_delivery(area varchar(45))
BEGIN
	SET @latest_order_delivery_option = (
		SELECT delivery
		FROM `order`
		ORDER BY order_id DESC LIMIT 1
	);
	IF @latest_order_delivery_option = 1 THEN
		INSERT INTO address (street, number, fk_area_id)
		SELECT @street, @number, area_id
		FROM location_area
		WHERE area_id = (
			SELECT area_id
			FROM location_area
			WHERE name = area
		);
	# AFTER INSERT ON address => TRIGGER handle_delivery is called
	END IF;
END $$

DELIMITER ;