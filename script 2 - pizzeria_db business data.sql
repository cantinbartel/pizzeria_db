USE pizzeria_db;

-- -----------------------------------------------------
-- INSERT PIZZA DATA
-- -----------------------------------------------------
INSERT INTO pizza (name, price) 
VALUES 
	('Margarita', 7),
	('Peppéroni', 8.5),
	('Napolitaine', 9),
    ('Hawaïenne', 8.5),
    ('Orientale', 10),
    ('Forestière', 11),
    ('Mexicaine', 10.5),
    ('Prise de masse', 15),
    ('Kebab', 12),
    ('Premier prix', 3.5);
    

-- -----------------------------------------------------
-- INSERT LOCATION AREA DATA
-- -----------------------------------------------------
INSERT INTO location_area (name, delivery_fees)
VALUES 
	('Lyon 01', 3),
    ('Lyon 02', 3),
    ('Lyon 03', 4),
    ('Lyon 04', 5),
    ('Lyon 05', 4),
    ('Lyon 06', 5),
    ('Lyon 07', 5),
    ('Lyon 08', 5),
    ('Lyon 09', 4),
    ('Villeurbanne', 6);
    
    
-- -----------------------------------------------------
-- INSERT DELIVERY MAN DATA
-- -----------------------------------------------------
INSERT INTO delivery_man (
	firstname, 
    lastname,
    fk_area_id)
VALUES 
	('Jean-Kevin', 'Delabarrière', 1),
    ('Selma', 'Hayek', 2),
    ('Karl', 'Marx', 3),
    ('John', 'Smith', 4),
    ('Jack', 'Daniels', 5),
    ('Johny', 'Walker', 6),
    ('Kelly', 'Rowland', 7),
    ('Cerise', 'Pasdechance', 8),
    ('Mao', 'Zedong', 9),
    ('Ramzan', 'Kadyrov', 10);


-- -----------------------------------------------------
-- INSERT PAYMENT TYPE DATA
-- -----------------------------------------------------
INSERT INTO payment_type (type)
VALUES 
	('Cash'),
    ('Carte de débit'),
    ('Visa'),
    ('Mastercard'),
    ('Ticket restaurant')
    