DROP SCHEMA IF EXISTS seminar6; -- с чистого листа
CREATE SCHEMA seminar6;
USE seminar6;

-- Создайте функцию, которая принимает кол-во сек и формат их в кол-во дней часов.
-- Пример: 123456 ->'1 days 10 hours 17 minutes 36 seconds '
DELIMITER $$
CREATE FUNCTION sec_to_days (sec INT)
RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
	DECLARE days DOUBLE;
    DECLARE hrs DOUBLE;
    DECLARE mins DOUBLE;
    DECLARE secs DOUBLE;
    
    SET days = sec / 86400;
    SET hrs = (days - TRUNCATE(days, 0)) * 24;
    SET mins = (hrs - TRUNCATE(hrs, 0)) * 60;
    SET secs = (mins - TRUNCATE(mins, 0)) * 60;
    
	RETURN CONCAT(sec, ' secs -> ', TRUNCATE(days, 0), ' days ', TRUNCATE(hrs, 0), ' hours ', TRUNCATE(mins, 0), ' minutes ', ROUND(secs), ' seconds');
END $$

DELIMITER ;

SET @sec := 123456;
SELECT sec_to_days(@sec) AS 'sec_to_days';


-- Выведите только четные числа от 1 до 10.
-- Пример: 2,4,6,8,10
DELIMITER $$
CREATE FUNCTION even_numb(lim_lo INT, lim_hi INT)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	DECLARE res VARCHAR(255) DEFAULT '';
    IF (lim_lo%2 = 1) THEN SET lim_lo = lim_lo + 1; END IF;
    IF (lim_lo >= lim_hi) THEN RETURN lim_lo; END IF;
    WHILE lim_lo <= lim_hi DO
		SET res = CONCAT(res, ' ', lim_lo);
        SET lim_lo = lim_lo + 2;
    END WHILE;
    RETURN res;
END $$

DELIMITER ;

SET @lim_l = 1;
SET @lim_h = 10;
SELECT even_numb(@lim_l, @lim_h) AS 'even numbers';