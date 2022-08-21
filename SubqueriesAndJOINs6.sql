-- Lab01 
SELECT e.employee_id , CONCAT( e.first_name, ' ', e.last_name) AS 'full_name', d.department_id, d.name AS 'department_name'
FROM `departments` AS d
LEFT JOIN `employees` AS e
ON d.manager_id = e.employee_id  
ORDER BY e.employee_id
LIMIT 5;

-- Lab02
SELECT t.town_id, t.name AS `town_name`, a.address_text
FROM `addresses` AS a
LEFT JOIN `towns` AS t
USING(`town_id`)
WHERE t.name IN ('San Francisco', 'Sofia','Carnation')
ORDER BY a.town_id, a.address_text;

-- Lab03
SELECT `employee_id`, `first_name`, `last_name`, `department_id`, `salary` 
FROM `employees`
WHERE `manager_id` IS NULL; 

-- Lab04
SELECT COUNT(*) AS count
FROM `employees`
WHERE `salary` >(SELECT AVG(`salary`) FROM `employees`);

-- Ex01
SELECT	e.`employee_id`, e.`job_title`,	a.`address_id`, a.`address_text`
FROM `employees` AS e
JOIN `addresses` AS a
ON  a.`address_id` = e.`address_id`
ORDER BY a.`address_id` LIMIT 5;

-- Ex02
SELECT	e.`first_name`, e.`last_name`,	t.`name`, a.`address_text`
FROM `employees` AS e
JOIN `addresses` AS a
ON  a.`address_id` = e.`address_id`
JOIN `towns` AS t
ON   t.`town_id` = a.`town_id`
ORDER BY e.`first_name`, e.`last_name` LIMIT 5;

-- Ex03
SELECT	e.`employee_id`, e.`first_name`, e.`last_name`,	d.`name` AS 'department_name'
FROM `employees` AS e
JOIN `departments` AS d
ON  d.`department_id` = e.`department_id`
WHERE d.`name`  = 'Sales'
ORDER BY e.`employee_id` DESC;



-- Ex04
SELECT	e.`employee_id`, e.`first_name`, e.`salary`, d.`name` AS 'department_name'
FROM `employees` AS e
JOIN `departments` AS d
ON  d.`department_id` = e.`department_id`
WHERE e.`salary`  > 15000
ORDER BY d.`department_id` DESC LIMIT 5;

-- Ex05
SELECT	e.`employee_id`, e.`first_name`
FROM `employees` AS e
LEFT JOIN `employees_projects` AS ep
ON  ep.`employee_id` = e.`employee_id`
WHERE  ep.`project_id`  IS NULL
ORDER BY e.`employee_id` DESC LIMIT 3;

-- Ex06
SELECT	e.`first_name`, e.`last_name`,e.`hire_date`, d.`name` AS 'dept_name'
FROM `employees` AS e
JOIN `departments` AS d
ON  d.`department_id` = e.`department_id`
WHERE d.`name`  = 'Sales'
ORDER BY e.`employee_id` DESC;

-- Ex07
SELECT	e.`employee_id`, e.`first_name`,  p.`name`
FROM `employees` AS e
JOIN `employees_projects` AS ep
ON  ep.`employee_id` = e.`employee_id`
JOIN `projects` AS p
ON p.`project_id` =  ep.`project_id` 
WHERE  p.`project_id` IS NOT NULL AND DATE (p.`start_date`) > '2002-08-13' AND DATE (p.`end_date`)  IS NULL
ORDER BY e.`first_name`, p.`name` LIMIT 5;

-- Ex08
SELECT	e.`employee_id`, e.`first_name`, IF (YEAR (p.`start_date`) > 2004,  NULL, p.`name`)AS 'project_name'
FROM `employees` AS e
JOIN `employees_projects` AS ep
ON  ep.`employee_id` = e.`employee_id`
JOIN `projects` AS p
ON p.`project_id` =  ep.`project_id` 
WHERE  e.`employee_id` = 24 
ORDER BY p.`name`;

-- Ex09
SELECT	e.`employee_id`, e.`first_name`, m.`employee_id` AS 'manager_id', m.`first_name` AS 'manager_name'
FROM `employees` AS e
JOIN `employees` AS m
ON  m.`employee_id` = e.`manager_id`
WHERE  e.`manager_id` IN (3, 7)
ORDER BY `first_name`;

-- E10
SELECT	e.`employee_id`, CONCAT_WS(' ', e.`first_name`, e.`last_name`) AS 'employee_name' ,CONCAT_WS(' ', m.`first_name`, m.`last_name`) AS 'manager_name',
d.`name` AS 'department_name'
FROM `employees` AS e
JOIN `employees` AS m
ON  m.`employee_id` = e.`manager_id`
JOIN `departments` AS d
ON  d.`department_id` = e.`department_id`
ORDER BY `employee_id` LIMIT 5;

-- E11
SELECT AVG(`salary`) AS 'min_average_salary'
FROM `employees`
GROUP BY `department_id`
ORDER BY `min_average_salary` LIMIT 1;

-- E12
SELECT c.`country_code`, m.`mountain_range`, p.`peak_name`, p.`elevation`
FROM `countries` AS c
JOIN `mountains_countries` AS mc
ON  c.`country_code` = mc.`country_code`
JOIN `mountains` AS m
ON  m.`id` = mc.`mountain_id`
JOIN `peaks` AS p
ON  p.`mountain_id` = mc.`mountain_id`
WHERE p.`elevation`> 2835 AND c.`country_code`= 'BG'
ORDER BY p.`elevation` DESC;

-- E13
SELECT mc.`country_code`, COUNT(m.`id`) AS 'm_count'
FROM `mountains` AS m
JOIN `mountains_countries` AS mc
ON  mc.`mountain_id` = m.`id`
WHERE  mc.`country_code` IN ('BG', 'US','RU')
GROUP BY mc.`country_code`
ORDER BY `m_count` DESC;

-- E14
SELECT c.`country_name`, r.`river_name`
FROM `countries` AS c
LEFT JOIN `countries_rivers` AS cr
ON  c.`country_code` = cr.`country_code`
LEFT JOIN `rivers` AS r
ON  cr.`river_id` = r.`id`
WHERE  c.`continent_code`= 'AF'
ORDER BY c.`country_name` LIMIT 5;

-- Ex15
SELECT `continent_code`, `currency_code`, COUNT(`country_name`) AS 'currency_usage'
FROM `countries` AS c
GROUP BY `continent_code`,`currency_code`
HAVING currency_usage =(
SELECT  COUNT(`country_code`) AS 'coun'
FROM `countries` AS c1
WHERE  c1.`continent_code`= c.`continent_code` 
GROUP BY `currency_code`
ORDER BY `coun` DESC
LIMIT 1
) AND `currency_usage` > 1
ORDER BY `continent_code`, `currency_code`;

-- Ex16
SELECT COUNT(c.`country_code`) AS 'country_count'
FROM `countries` AS c
LEFT JOIN `mountains_countries` AS mc
ON  c.`country_code` = mc.`country_code`
WHERE mc.`mountain_id` IS NULL;

-- E17
SELECT c.`country_name`, MAX(p.`elevation`) AS 'highest_peak_elevation', MAX(r.`length`) AS 'longest_river_length'
FROM `countries` AS c
JOIN `mountains_countries` AS mc
USING (`country_code`)
JOIN `peaks` as p
USING (`mountain_id`)
JOIN `countries_rivers` AS cr
ON  mc.`country_code` = cr.`country_code`
JOIN `rivers` AS r
ON  cr.`river_id` = r.`id`
GROUP BY c.`country_name`
ORDER BY `highest_peak_elevation` DESC, `longest_river_length` DESC, c.`country_name` LIMIT 5 ;










