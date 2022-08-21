-- Lab01
SELECT `title` FROM books
WHERE substr(title, 1,3) ='The';-

-- Lab02
SELECT REPLACE(`title`, 'The', '***')AS 'title'
FROM `books`
WHERE SUBSTRING(title, 1, 3) = 'The';

-- Lab03
SELECT ROUND(SUM(cost), 2) AS 'Total costs'
FROM `books`;

-- Lab04
SELECT concat_ws(' ', `first_name`, `last_name`) AS 'Full Name', timestampdiff(day,`born`,`died`) AS 'Days Lived'
FROM `authors`;

-- Lab05
SELECT `title` FROM books
WHERE title LIKE "%Harry%"
ORDER BY `id`;

-- Ex01
SELECT `first_name`, `last_name` FROM `employees`
WHERE substr(first_name, 1,2) ='Sa'
ORDER BY `employee_id`;

-- Ex02
SELECT `first_name`, `last_name` FROM `employees`
WHERE `last_name` LIKE '%ei%'
ORDER BY `employee_id`;

-- Ex03
SELECT `first_name`
FROM `employees`
WHERE `department_id` IN (3, 10) 
AND YEAR(`hire_date`) BETWEEN 1995 AND 2005
ORDER BY `employee_id`;

-- Ex04
SELECT `first_name`, `last_name` FROM `employees`
WHERE `job_title` NOT LIKE '%engineer%' 
ORDER BY `employee_id`;

-- Ex05
SELECT `name` FROM towns
WHERE char_length(`name`)  IN (5,6)
ORDER BY `name`;

-- Ex06
SELECT `town_id`, `name` FROM towns
WHERE left (`name`, 1) IN ('M', 'K', 'B' ,'E') 
ORDER BY `name`;

-- Ex07
SELECT `town_id`, `name` FROM towns
WHERE left (`name`, 1) NOT IN ('R', 'B', 'D') 
ORDER BY `name`;

-- Ex08
CREATE VIEW `v_employees_hired_after_2000` AS
SELECT `first_name`, `last_name` FROM `employees`
WHERE YEAR(`hire_date`) > 2000;

SELECT * FROM `v_employees_hired_after_2000`;

-- Ex09
SELECT `first_name`, `last_name` FROM `employees`
WHERE CHAR_LENGTH(`last_name`) = 5;

-- Ex10
SELECT `country_name`, `iso_code` FROM `countries`
WHERE `country_name` LIKE '%A%A%A%'
ORDER BY `iso_code`;

-- Ex11
SELECT `peak_name`, `river_name` ,
LOWER(CONCAT(`peak_name`,SUBSTRING(`river_name`, 2))) AS 'mix'
FROM`peaks`, `rivers`
WHERE RIGHT(peak_name, 1) = LEFT( river_name, 1)
ORDER BY `mix`;

-- Ex12
SELECT `name`,  DATE_FORMAT(`start`, '%Y-%m-%d')
FROM `games`
WHERE YEAR(`start`) BETWEEN 2011 AND 2012
ORDER BY `start`, `name`
LIMIT 50;

-- Ex13
SELECT `user_name`, 
SUBSTRING(`email`,LOCATE('@', `email`) + 1) AS 'email_provider'
FROM `users`
ORDER BY `email_provider`,`user_name` ;

-- Ex14
SELECT `user_name` , `ip_address`FROM `users`
WHERE `ip_address` LIKE '___.1%.%.___'
ORDER BY `user_name`;

-- Ex15
SELECT `name`, 
(CASE
WHEN HOUR (`start`) < 12 THEN 'Morning'
WHEN HOUR (`start`) < 18 THEN 'Afternoon'
ELSE 'Evening'
END) AS 'Part of the Day',
(CASE
WHEN `duration` < 4 THEN 'Extra Short'
WHEN `duration` < 7 THEN 'Short'
WHEN `duration` < 11 THEN 'Long'
ELSE 'Extra Long'
END) AS 'Duration'
FROM `games`;

-- Ex16
SELECT `product_name`, `order_date`,
DATE_ADD(`order_date`, INTERVAL 3 DAY) AS `pay_due`,
DATE_ADD(`order_date`, INTERVAL 1 MONTH) AS `deliver_due`
FROM `orders`;

