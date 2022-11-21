USE pizzeria_db;

-- -----------------------------------------------------
-- ENTER CLIENT DETAILS
-- -----------------------------------------------------
SET @firstname = 'Véronique';
SET @lastname = 'Vieslet';
SET @phone = '0477679850';	# varchar(10)
SET @delivery = 1;	# 1 = true  => Delivery / 0 = false  => Take away
SET @street = 'rue du Blé';
SET @number = 5;
SET @area = 'Lyon 03';
SET @payment_method = 'Carte de débit';	# Cash / Carte de débit / Visa / Mastercard / Ticket restaurant


-- If client does not already exist, it will create a new client record
INSERT INTO client (firstname, lastname, phone) 
SELECT @firstname, @lastname, @phone
WHERE NOT EXISTS (
	SELECT firstname, lastname, phone 
    FROM client 
    WHERE firstname = @firstname AND lastname = @lastname AND phone = @phone
) LIMIT 1;


-- Order Initialization
INSERT INTO `order` (date, delivery, fk_client_id)
SELECT NOW(), @delivery, client_id
FROM client 
WHERE firstname = @firstname AND lastname = @lastname AND phone = @phone
LIMIT 1;

    
SET @latest_order_id = (
	SELECT order_id
	FROM `order`
	ORDER BY order_id DESC LIMIT 1
);

-- -----------------------------------------------------
-- SELECT PIZZAS
-- -----------------------------------------------------
INSERT INTO order_line (fk_order_id, fk_pizza_id, quantity)
SELECT @latest_order_id, pizza_id, 1
FROM pizza
WHERE
	pizza_id = (
		SELECT pizza_id
        FROM pizza
        WHERE name = 'Kebab'
    );
# AFTER INSERT ON order_line => TRIGGER add_pizza_price_to_order is called


INSERT INTO order_line (fk_order_id, fk_pizza_id, quantity)
SELECT @latest_order_id, pizza_id, 2
FROM pizza
WHERE
	pizza_id = (
		SELECT pizza_id
        FROM pizza
        WHERE name = 'Hawaïenne'
    );
# AFTER INSERT ON order_line => TRIGGER add_pizza_price_to_order is called 


INSERT INTO order_line (fk_order_id, fk_pizza_id, quantity)
SELECT @latest_order_id, pizza_id, 1
FROM pizza
WHERE
	pizza_id = (
		SELECT pizza_id
        FROM pizza
        WHERE name = 'Prise de masse'
    );
# AFTER INSERT ON order_line => TRIGGER add_pizza_price_to_order is called     


-- STORED PROCEDURE - checks if order.delivery is true or not
CALL check_for_delivery(@area);


-- Generates a bill    
INSERT INTO billing (fk_order_id, fk_payment_type_id)
SELECT @latest_order_id, payment_type_id
FROM payment_type
WHERE type = @payment_method;

