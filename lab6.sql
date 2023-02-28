-- Exercise 1


CREATE TABLE orders
	(orderId INT,
	date DATE,
	customerId INT,
	customerName VARCHAR(15),
	city VARCHAR(15),
	itemId INT,
	itemName VARCHAR(15),
	quantity INT,
	price REAL,
	PRIMARY KEY (orderId, customerId, itemId)
);


INSERT INTO orders VALUES ('2301', '2011-02-23', '101', 'Martin', 'Prague', '3786', 'Net', '3', '35.00');
INSERT INTO orders VALUES ('2301', '2011-02-23', '101', 'Martin', 'Prague', '4011', 'Racket', '6', '65.00');
INSERT INTO orders VALUES ('2301', '2011-02-23', '101', 'Martin', 'Prague', '9132', 'Pack-3', '8', '4.75');
INSERT INTO orders VALUES ('2302', '2012-02-25', '107', 'Herman', 'Madrid', '5794', 'Pack-6', '4', '5.00');
INSERT INTO orders VALUES ('2303', '2011-11-27', '110', 'Pedro', 'Moscow', '4011', 'Racket', '2', '65.00');
INSERT INTO orders VALUES ('2303', '2011-11-27', '110', 'Pedro', 'Moscow', '3141', 'Cover', '2', '10.00');


CREATE TABLE quantity AS
SELECT orderId,itemId,quantity
FROM orders;

ALTER TABLE quantity
ADD PRIMARY KEY (orderId,itemId);


CREATE TABLE customer AS
SELECT DISTINCT customerId,customerName,city
FROM orders;

ALTER TABLE customer
ADD PRIMARY KEY (customerId);

CREATE TABLE buyDate AS
SELECT DISTINCT orderId,customerId,date
FROM orders;

ALTER TABLE buyDate
ADD PRIMARY KEY (orderId);

CREATE TABLE price AS
SELECT DISTINCT itemId,itemName,price
FROM orders;

ALTER TABLE price
ADD PRIMARY KEY (itemId);

ALTER TABLE quantity
ADD FOREIGN KEY (orderId) references buyDate(orderId);

ALTER TABLE quantity
ADD FOREIGN KEY (itemId) REFERENCES price(itemId);

ALTER TABLE buyDate
ADD FOREIGN KEY (customerId) REFERENCES customer(customerId);


SELECT orderId,SUM(quantity.quantity) AS quantity,SUM(p.price) AS price FROM quantity Join price p on quantity.itemId = p.itemId
GROUP BY quantity.orderId;

SELECT c.customerName
FROM quantity
    JOIN price p ON quantity.itemId = p.itemId
    JOIN buydate b ON quantity.orderId = b.orderId
    JOIN customer c on b.customerId = c.customerId
GROUP BY quantity.orderId,b.customerId,c.customerName,quantity.orderId
ORDER BY SUM(p.price) DESC
LIMIT 1;
