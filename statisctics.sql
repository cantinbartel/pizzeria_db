USE pizzeria_db;
-- -----------------------------------------------------
-- ORDER PRICE STATS
-- -----------------------------------------------------
SELECT 
	MAX(total_price) AS 'Most Expensive Order',
    ROUND(AVG(total_price), 2) AS 'Average Order Price',
    MIN(total_price) AS 'Cheapest Order',
    COUNT(*) AS 'Number of Orders',
    SUM(total_price) AS 'Total Money Earned'
FROM `order`;

-- -----------------------------------------------------
-- WHO ORDER THE MOST EXPENSIVE ORDER AND WHEN
-- -----------------------------------------------------
SELECT 
	client_id,  
    firstname,
    lastname,
    date
FROM client, `order`
WHERE client_id IN (
	SELECT fk_client_id
    FROM `order`
    WHERE total_price = (
		SELECT MAX(total_price)
        FROM `order`
    )
) AND date IN (
	SELECT date
    FROM `order`
    WHERE total_price = (
		SELECT MAX(total_price)
        FROM `order`
    )
);
-- IN is used instead of = because it can have more than one order equal to the MAX(total_price) value 


-- -----------------------------------------------------
-- WHO ORDER THE MOST EXPENSIVE ORDER AND WHEN
-- -----------------------------------------------------
SELECT 
	client_id,  
    firstname,
    lastname,
    date
FROM client c
LEFT JOIN `order` o
	ON c.client_id = o.fk_client_id
    WHERE o.total_price IN (
		SELECT MAX(total_price)
        FROM `order`
    );
-- IN is used instead of = because it can have more than one order equal to the MAX(total_price) value 


-- -----------------------------------------------------
-- THE MOST FREQUENT ADDRESS(ES)
-- -----------------------------------------------------
SELECT 
	a.street,
    a.number,
    la.name,
    COUNT(*) AS 'Number of delivery'
FROM address a
LEFT JOIN location_area la
	ON a.fk_area_id = la.area_id
GROUP BY a.street, a.number, la.name
HAVING COUNT(*) = (
	SELECT COUNT(*)
    FROM address
    GROUP BY street, number
    ORDER BY COUNT(*) DESC LIMIT 1
);


-- -----------------------------------------------------
-- PIZZA POPULARITY RANKING
-- -----------------------------------------------------
SELECT 
	p.name,
    SUM(ol.quantity) AS 'Total number of ordered pizza'
FROM order_line ol
LEFT JOIN pizza p
	ON p.pizza_id = ol.fk_pizza_id
GROUP BY fk_pizza_id
ORDER BY SUM(ol.quantity) DESC;


