-- pizzeria_db

-- -----------------------------------------------------
-- Schema creation
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS pizzeria_db;


USE pizzeria_db;


-- -----------------------------------------------------
-- client table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS client (
  client_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  firstname VARCHAR(25) NOT NULL,
  lastname VARCHAR(25) NOT NULL,
  phone VARCHAR(10)
);


-- -----------------------------------------------------
-- order table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `order` (
  order_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  date DATETIME NOT NULL,
  total_price DECIMAL(6,2) NOT NULL DEFAULT 0,
  `delivery` TINYINT(1) NOT NULL DEFAULT 0,
  fk_client_id INT NOT NULL,
  FOREIGN KEY (fk_client_id)
    REFERENCES client (client_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- pizza table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS pizza (
  pizza_id TINYINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(30) NOT NULL,
  price DECIMAL(4,2) NOT NULL
);


-- -----------------------------------------------------
-- location_area table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS location_area (
  area_id TINYINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(45) NOT NULL,
  delivery_fees DECIMAL(4,2) NOT NULL DEFAULT 0
);


-- -----------------------------------------------------
-- delivery_man table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS delivery_man (
  delivery_man_id SMALLINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  firstname VARCHAR(25) NOT NULL,
  lastname VARCHAR(25) NOT NULL,
  fk_area_id TINYINT NOT NULL,
  FOREIGN KEY (fk_area_id)
    REFERENCES location_area (area_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- delivery table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS delivery (
  delivery_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  pizza_number TINYINT NOT NULL DEFAULT 0,
  fk_delivery_man_id SMALLINT NOT NULL,
  FOREIGN KEY (fk_delivery_man_id)
	REFERENCES delivery_man (delivery_man_id)
	ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- address table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS address (
  address_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  street VARCHAR(45) NOT NULL,
  number SMALLINT NOT NULL,
  fk_area_id TINYINT NOT NULL,
  FOREIGN KEY (fk_area_id)
	REFERENCES location_area (area_id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- delivery_ticket table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS delivery_ticket (
  delivery_ticket_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  delivery_fees DECIMAL(4,2) NOT NULL,
  fk_address_id INT NOT NULL,
  fk_order_id INT NOT NULL,
  fk_delivery_id INT NOT NULL,
  FOREIGN KEY (fk_order_id)
	REFERENCES `order` (order_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  FOREIGN KEY (fk_delivery_id)
    REFERENCES delivery (delivery_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  FOREIGN KEY (fk_address_id)
    REFERENCES address (address_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- payment_type table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS payment_type (
  payment_type_id TINYINT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  type VARCHAR(25) NOT NULL
);


-- -----------------------------------------------------
-- billing table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS billing (
  billing_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  fk_order_id INT NOT NULL,
  fk_payment_type_id TINYINT(10) NOT NULL,
  FOREIGN KEY (fk_order_id)
    REFERENCES `order` (order_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  FOREIGN KEY (fk_payment_type_id)
    REFERENCES payment_type (payment_type_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- order_line table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS order_line (
  fk_order_id INT NOT NULL,
  fk_pizza_id TINYINT NOT NULL,
  quantity TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (fk_order_id, fk_pizza_id),
  FOREIGN KEY (fk_order_id)
    REFERENCES `order` (order_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  FOREIGN KEY (fk_pizza_id)
    REFERENCES pizza (pizza_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

