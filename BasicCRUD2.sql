-- Ex1
SELECT * FROM `departments`
ORDER BY `department_id`;

-- Ex2
SELECT name FROM `departments`
ORDER BY `department_id`;

-- Ex3
SELECT `first_name`, `last_name`, `salary` FROM `employees`
ORDER BY `employee_id`;

-- Ex4
SELECT `first_name`, `middle_name`, `last_name` FROM `employees`
ORDER BY `employee_id`;

-- Ex5
SELECT concat(`first_name`, '.', `last_name`, '@softuni.bg') 
AS 'full_ email_address'
FROM `employees`;

-- Ex6
SELECT DISTINCT `salary` FROM `employees`;
# ORDER BY `employee_id`;

-- Ex7
SELECT * FROM `employees`
WHERE `job_title` = 'Sales Representative'
ORDER BY `employee_id`;

-- Ex8
SELECT `first_name`, `last_name`, `job_title` FROM `employees`
WHERE `salary` BETWEEN 20000 AND 30000
# WHERE `salary` >= 20000 AND `salary` <= 30000
ORDER BY `employee_id`;

-- Ex9
SELECT  CONCAT_WS (' ', `first_name`, `middle_name`, `last_name`) AS 'Full Name' FROM `employees`
WHERE `salary` IN ( 25000, 14000, 12500 , 23600);

-- Ex10
SELECT `first_name`, `last_name` FROM `employees`
WHERE `manager_id` IS NULL;

-- Ex11
SELECT `first_name`, `last_name`, `salary` FROM `employees`
WHERE `salary` > 50000
ORDER BY `salary` DESC;

-- Ex12
SELECT `first_name`, `last_name`  FROM `employees`
ORDER BY `salary` DESC
LIMIT 5;

-- Ex13
SELECT `first_name`, `last_name`  FROM `employees`
WHERE `department_id` != 4 ;

-- Ex14
SELECT *  FROM `employees`
ORDER BY `salary` DESC, `first_name`, `last_name` DESC, `middle_name`;

-- Ex15
CREATE VIEW `v_employees_salaries` AS 
SELECT `first_name`, `last_name`,`salary` 
FROM `employees`;
SELECT * FROM `v_employees_salaries`;


-- Ex16
CREATE VIEW `v_employees_job_titles` AS 
SELECT CONCAT_WS (' ', `first_name`,`middle_name`, `last_name`) AS `full_name`, `job_title`
FROM `employees`;
SELECT * FROM `v_employees_job_titles`;

-- Ex17
SELECT DISTINCT `job_title` FROM `employees`
ORDER BY `job_title`;

-- Ex18
SELECT * FROM `projects`
ORDER BY `start_date`, `name`, `project_id`
LIMIT 10;

-- Ex19
SELECT `first_name`, `last_name`,`hire_date` 
FROM `employees`
ORDER BY `hire_date` DESC
LIMIT 7;

-- Ex20
#SELECT  * FROM `employees`;
UPDATE `employees`
SET `salary` = `salary` * 1.12
WHERE `department_id` IN (1, 2, 4 ,11);
SELECT `salary` FROM `employees`;

-- Ex21
SELECT peak_name FROM `peaks`
ORDER BY `peak_name`;

-- Ex22
SELECT `country_name`, `population` FROM `countries`
WHERE `continent_code` = 'EU'
ORDER BY `population` DESC, `country_name`
LIMIT 30;

-- Ex23
SELECT `country_name`, `country_code`,
IF (`currency_code` = 'EUR', 'Euro', 'Not Euro') AS `currency`
FROM `countries`
ORDER BY `country_name`;

-- Ex24
SELECT `name` FROM `characters`
ORDER BY `name`;










