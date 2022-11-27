DROP SCHEMA seminar2; -- с чистого листа
CREATE SCHEMA seminar2;
USE seminar2;

-- Создание таблицы товаров
CREATE TABLE goods (
  goods_id INT AUTO_INCREMENT PRIMARY KEY, # первичный ключ (NOT NULL автоматически)
  goods_name VARCHAR(100) NOT NULL UNIQUE, # название товара (обязательное поле, уникальное)
  goods_category ENUM('Категория А', 'Категория В', 'Категория С') DEFAULT NULL, # категория товара из списка (необязательное поле)
  goods_tag VARCHAR(100) DEFAULT NULL # тег для разработчика
); 

SHOW TABLES; 	# показать все таблицы БД

INSERT INTO goods 		# заполнение таблицы товаров  
  (goods_name, goods_category)
VALUES
  ('Товар А', 1),
  ('Товар В', 2),
  ('Товар С', 1),
  ('Товар D', 3);

SELECT 		# отобразить таблицу товаров
	goods_name AS 'Название товара',
    goods_category AS 'Категория товара'
FROM goods;
  
-- Создание таблицы продаж
CREATE TABLE sales (
  sales_id INT AUTO_INCREMENT PRIMARY KEY, # первичный ключ
  sales_goods_name INT UNIQUE,
  sales_price NUMERIC(10, 2) NOT NULL, # цена товара у.е. (обязательное поле)
  sales_amount MEDIUMINT DEFAULT NULL, # количество в наличии (необязательное поле)
  sales_tag VARCHAR(100) DEFAULT NULL # тег для разработчика
);
  
ALTER TABLE sales 	# добавление внешнего ключа
	ADD FOREIGN KEY (sales_goods_name)
	REFERENCES goods (goods_id) 
	ON DELETE CASCADE; 	# удаление записи в случае удаления товара
  
SHOW TABLES;

INSERT INTO sales 		# заполнение таблицы продаж  
  (sales_goods_name, sales_price, sales_amount)
VALUES
  (1, 154000.50, 200),
  (2, 250556.00, 500),
  (3, 523555.80, 350),
  (4, 1002000.00, 50);

SELECT 		# отобразить таблицу продаж 
	CONCAT_WS(": ", goods_name, goods_category) AS "Название товара",
    sales_price AS "Цена",
	sales_amount AS "В наличии"
FROM goods JOIN sales
ON sales_goods_name = goods_id;

-- Группировка в 3 сегмента по количеству товара (используя CASE)
SELECT 		# отобразить таблицу продаж 
	CONCAT_WS(": ", goods_name, goods_category) AS "Название товара",
    sales_price AS "Цена",
    CASE
		WHEN sales_amount = 0
        THEN 'товар отсутствует'
		WHEN sales_amount < 100
        THEN 'меньше 100'
        WHEN sales_amount >= 100 AND sales_amount < 300
        THEN '100 - 300'
        WHEN sales_amount >= 300
        THEN 'больше 300'
		ELSE 'не указано'
    END AS 'В наличии'
FROM goods JOIN sales
ON sales_goods_name = goods_id;

-- Таблица заказчиков (дополнительно)
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL UNIQUE
    -- ----- что-то еще
);

INSERT INTO customers 		# заполнение таблицы заказчиков  
  (customer_name)
VALUES
  ('Загадалкин Петр Петрович'),
  ('Пузиков Николай Иванович'),
  ('Leroy Merlin'),
  ('ИП Гладков ББ'),
  ('Школа 1482');
    
-- Создание таблицы заказов
CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY, # первичный ключ
  order_customer INT NOT NULL, # заказчик
  order_goods_name INT NOT NULL, # название товара
  order_amount MEDIUMINT DEFAULT 1, # требуемое количество 
  order_status ENUM('A', 'B', 'C', 'D', 'E') DEFAULT 'A', # статус заказа
  order_tag VARCHAR(100) DEFAULT NULL, # тег для разработчика
  FOREIGN KEY (order_customer) REFERENCES customers (customer_id), # удаление заказчика будет невозможно, как заказ не выполнен
  FOREIGN KEY (order_goods_name) REFERENCES goods (goods_id) # то же	
);  

SHOW TABLES;

INSERT INTO orders 		# заполнение таблицы заказов  
  (order_customer, order_goods_name, order_amount, order_status)
VALUES
  (1, 1, 20, 2),
  (2, 1, 10, 4),
  (3, 3, 50, 5),
  (4, 2, 800, 3),
  (4, 4, 12, 4);

SELECT 		# отобразить таблицу заказов
	order_id AS '№ п/п',
    customer_name AS 'Заказчик',
	CONCAT_WS(": ", goods_name, goods_category) AS "Название товара",
    order_amount AS "Кол-во запрошено",
	order_status AS "Статус"
FROM orders LEFT JOIN customers
ON order_customer = customer_id
LEFT JOIN goods
ON order_goods_name = goods_id;

-- Вывести "полный" статус заказа заказчика "ИП Гладков ББ"
SELECT 
    customer_name AS 'Заказчик',
	CONCAT_WS(": ", goods_name, goods_category) AS "Название товара",
    CASE 
		WHEN sales_amount < order_amount
        THEN CONCAT_WS(" запрошено, в наличии ", order_amount, sales_amount)
        ELSE order_amount
    END AS "Количество",
    Case
		WHEN sales_amount < order_amount
        THEN 'Отказ: много просите'
		WHEN order_status = 'A'
        THEN 'Новый'
        WHEN order_status = 'B'
        THEN 'Согласован'
		WHEN order_status = 'C'
        THEN 'Скомплектован'
        WHEN order_status = 'D'
        THEN 'Выполнен'
        WHEN order_status = 'E'
        THEN 'Возврат'
        ELSE 'Неизвестен'
    END AS "Статус"
FROM orders LEFT JOIN customers ON order_customer = customer_id
LEFT JOIN goods ON order_goods_name = goods_id
LEFT JOIN sales ON sales_goods_name = goods_id 
WHERE customer_name = 'ИП Гладков ББ';

-- Чем NULL отличается от 0?
/*
	Null указывает на то, что поле в записи является пустым (не содержит никаких значений).
    0 указывает на то, что поле в записи содержит значение, равное числу 0.
*/