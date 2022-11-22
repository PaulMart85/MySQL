DROP SCHEMA IF EXISTS seminar1; -- с чистого листа
CREATE SCHEMA seminar1;
USE seminar1;

-- Создание таблицы производителей мобильных телефонов  
CREATE TABLE manufacturer (
  manufacturer_id INT NOT NULL AUTO_INCREMENT, -- первичный ключ
  manufacturer_name VARCHAR(100) NOT NULL UNIQUE, -- название производителя (уникальное)
  manufacturer_address VARCHAR(140) NOT NULL, -- юр адрес производства (может совпадать у разных производителей)
  manufacturer_tag VARCHAR(100) DEFAULT NULL, -- тег для разработчика
  PRIMARY KEY (manufacturer_id)
);  

-- Заполнение таблицы производителей  
INSERT INTO manufacturer
  (manufacturer_name, manufacturer_address)
VALUES
  ('Samsung', '85 Challenger Rd. Ridgefield Park, New Jersey 07660 USA'),
  ('Nokia', 'Karakaari 7 02610 Espoo, Finland'),
  ('LG', '111 Sylvan Ave, Englewood Cliffs, NJ 07632');
  
-- Создание таблицы мобильных телефонов
CREATE TABLE mobile_phones (
  mobile_phone_id INT NOT NULL AUTO_INCREMENT, -- первичный ключ
  mobile_phone_brand INT, -- марка (в качестве вторичного ключа - название производителя)
  mobile_phone_model VARCHAR(50) NOT NULL, -- модель
  mobile_phone_tag VARCHAR(100) DEFAULT NULL, -- тег для разработчика
  UNIQUE KEY b_m (mobile_phone_brand, mobile_phone_model), -- пара марка-модель не должна повторяться
  PRIMARY KEY (mobile_phone_id),
  FOREIGN KEY (mobile_phone_brand) REFERENCES manufacturer (manufacturer_id) ON DELETE CASCADE -- удаление записи в случае удаления производителя  
  );
  
-- Заполнение таблицы мобильных телефонов данными  
INSERT INTO mobile_phones
  (mobile_phone_brand, mobile_phone_model) -- id в автоинкременте, тег заполняется null по умолчанию
VALUES
  (1, 'Galaxy S22 Ultra'),
  (1, 'Galaxy Z Fold4'),
  (2, 'C30'),
  (2, 'XR20'),
  (1, 'Galaxy Z Flip4 5G'),
  (3, 'Zero H650K');

-- Создание сводной таблицы: товар, цена, количество
CREATE TABLE shop (
  shop_id INT NOT NULL AUTO_INCREMENT, -- первичный ключ
  shop_product_name INT UNIQUE, -- название товара (мобильного телефона) - вторичный ключ
  shop_product_price MEDIUMINT NOT NULL, -- цена товара у.е.
  shop_product_amount MEDIUMINT DEFAULT NULL, -- количество в наличии 
  shop_tag VARCHAR(100) DEFAULT NULL, -- тег для разработчика
  PRIMARY KEY (shop_id),
  FOREIGN KEY (shop_product_name) REFERENCES mobile_phones (mobile_phone_id) ON DELETE CASCADE -- удаление записи в случае удаления товара  
);  

-- Заполнение таблицы товаров (мобильных телефонов)
INSERT INTO shop
  (shop_product_name, shop_product_price, shop_product_amount) -- id в автоинкременте, тег заполняется null по умолчанию
VALUES
  (1, 10200, 10),
  (2, 12250, 2),
  (3, 9800, 5),
  (4, 11500, 6),
  (5, 16800, 1),
  (6, 14000, 4);

-- Вывод названия, производителя и цены для товаров, количество которых превышает 2
SELECT 
	CONCAT_WS(" ", manufacturer_name, mobile_phone_model)  as "Название",
    shop_product_price as "Цена",
	shop_product_amount as "Количество"
FROM manufacturer RIGHT JOIN mobile_phones
ON mobile_phone_brand = manufacturer_id
LEFT JOIN shop 
ON mobile_phone_id = shop_product_name
WHERE shop_product_amount > 2
GROUP BY shop_product_name;

-- Вывод всего ассортимента товаров марки "Samsung"
SELECT 
	CONCAT_WS(" ", manufacturer_name, mobile_phone_model)  as "Название"
FROM manufacturer RIGHT JOIN mobile_phones
ON mobile_phone_brand = manufacturer_id
WHERE mobile_phone_brand = 1

