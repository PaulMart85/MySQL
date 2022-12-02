DROP SCHEMA seminar3; -- с чистого листа
CREATE SCHEMA seminar3;
USE seminar3;

-- Создание таблицы
CREATE TABLE employees (
  employee_id INT AUTO_INCREMENT PRIMARY KEY, # первичный ключ (NOT NULL автоматически)
  employee_name VARCHAR(15) NOT NULL, # имя работника (обязательное поле)
  employee_surname VARCHAR(30) NOT NULL, # фамилия работника (обязательное поле)
  employee_specialty ENUM('стажер', 'начальник', 'инженер', 'рабочий', 'уборщик') DEFAULT 'стажер', # специальность
  employee_seniority TINYINT DEFAULT 0, # стаж работы
  employee_salary INT DEFAULT NULL, # зарплата (необязательное поле)
  employee_age TINYINT DEFAULT NULL, # возраст (необязательное поле)
  employee_tag VARCHAR(100) DEFAULT NULL # тег для разработчика
); 

INSERT INTO employees 		# заполнение таблицы  
VALUES
  (NULL, 'Вася', 'Васькин', 2, 40, 100000, 60, NULL),
  (NULL, 'Петя', 'Петькин', 2, 8, 70000, 30, NULL),
  (NULL, 'Катя', 'Каткина', 3, 2, 70000, 25, NULL),
  (NULL, 'Саша', 'Сашкин', 3, 12, 50000, 35, NULL),
  (NULL, 'Иван', 'Иванов', 4, 40, 30000, 59, NULL),
  (NULL, 'Петр', 'Петров', 4, 20, 25000, 40, NULL),
  (NULL, 'Сидор', 'Сидоров', 4, 10, 30000, 35, NULL),
  (NULL, 'Антон', 'Антонов', 4, 8, 19000, 28, NULL),
  (NULL, 'Юра', 'Юркин', 4, 5, 15000, 25, NULL),
  (NULL, 'Максим', 'Воронин', 4, 2, 11000, 22, NULL),
  (NULL, 'Юра', 'Галкин', 4, 3, 12000, 24, NULL),
  (NULL, 'Люся', 'Люськина', 5, 10, 10000, 49, NULL);

SELECT 
	employee_id AS 'id',
    employee_name AS 'name',
    employee_surname AS 'surname',
    employee_specialty AS 'specialty',
    employee_seniority AS 'seniority',
    employee_salary AS 'salary',
    employee_age AS 'age'
FROM employees;

-- Сортировка поля “зарплата” (salary) в порядке 
	# убывания:
SELECT 
    employee_salary AS 'salary desc'
FROM employees
ORDER BY employee_salary DESC;

    # возрастания:
SELECT 
	employee_salary AS 'salary asc'
FROM employees
ORDER BY employee_salary;

-- Вывод 5 максимальных зарплат (salary)
SELECT 
    employee_salary AS 'salary 5max'
FROM employees
ORDER BY employee_salary DESC
LIMIT 5;

-- Подсчет суммарной зарплаты (salary) по каждой специальности (post)
SELECT
	employee_specialty AS 'specialty',
    SUM(employee_salary) AS 'sum salary'
FROM employees
GROUP BY specialty;

-- Поиск количества сотрудников по специальности “Рабочий” (post) в возрасте от 24 до 42 лет
SELECT
	employee_specialty AS 'specialty',
    COUNT(*) AS 'count of age 24-42'
FROM employees
WHERE employee_age BETWEEN 24 AND 42
GROUP BY employee_specialty
HAVING employee_specialty = 'рабочий';

-- Поиск количества специальностей
SELECT COUNT(DISTINCT employee_specialty) AS 'count of specialties' FROM employees;

-- Вывод специальностей, у которых средний возраст сотрудника меньше 44 лет
SELECT
	employee_specialty AS 'spclty of avg_age less 44'
FROM employees
GROUP BY employee_specialty
HAVING AVG(employee_age) < 44;

-- Если не ID, то в качестве первичного ключа можно добавить поле с данными о каком-либо
-- удостоверяющем документе, например, паспортные данные, или водительское.