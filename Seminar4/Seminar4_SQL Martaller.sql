DROP SCHEMA seminar4; -- с чистого листа
CREATE SCHEMA seminar4;
USE seminar4;

CREATE TABLE  AUTO 
(       
	REGNUM VARCHAR(10) PRIMARY KEY, 
	MARK VARCHAR(10), 
	COLOR VARCHAR(15),
	RELEASEDT DATE, 
	PHONENUM VARCHAR(15)
);

INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111114,'LADA', 'КРАСНЫЙ', date'2008-01-01', '9152222221');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111115,'VOLVO', 'КРАСНЫЙ', date'2013-01-01', '9173333334');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111116,'BMW', 'СИНИЙ', date'2015-01-01', '9173333334');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111121,'AUDI', 'СИНИЙ', date'2009-01-01', '9173333332');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111122,'AUDI', 'СИНИЙ', date'2011-01-01', '9213333336');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111113,'BMW', 'ЗЕЛЕНЫЙ', date'2007-01-01', '9214444444');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111126,'LADA', 'ЗЕЛЕНЫЙ', date'2005-01-01', null);


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111117,'BMW', 'СИНИЙ', date'2005-01-01', null);


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111119,'LADA', 'СИНИЙ', date'2017-01-01', 9213333331);

SELECT * FROM AUTO;

-- Вывод на экран количества машин каждого цвета для машин марок BMW и LADA
SELECT COLOR, COUNT(COLOR) AS 'count among BMW & LADA'
FROM AUTO
WHERE MARK = 'BMW' OR MARK = 'LADA'
GROUP BY COLOR;
	
-- Вывод на экран марки авто и количества AUTO не этой марки
WITH TMP AS # временная таблица, содержит кол-во авто каждой марки и общее число всех авто
(
	WITH distinct_count AS (
		SELECT
			MARK,
			COUNT(*) AS CNT
		FROM AUTO
		GROUP BY MARK
	) 
	SELECT 
		MARK,
		CNT,
		SUM(CNT) OVER() AS TOTAL
	FROM distinct_count
)
SELECT # результирующая таблица
	MARK,
	TOTAL - CNT AS 'count of another mark'
FROM TMP;

-- Задание №3
create table test_a (id INT, dat CHAR(1));
create table test_b (id INT);
insert into test_a(id, dat) values
(10, 'A'),
(20, 'A'),
(30, 'F'),
(40, 'D'),
(50, 'C');
insert into test_b(id) values
(10),
(30),
(50);

-- Вывод строк из таблицы test_a, id которых нет в таблице test_b, НЕ используя ключевого слова NOT
SELECT test_a.id, dat FROM test_a
LEFT JOIN test_b
ON test_a.id = test_b.id
WHERE test_b.id IS NULL;