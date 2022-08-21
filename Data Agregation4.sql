-- Lab01
SELECT `department_id`, COUNT(*) AS 'Number of employees'
FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id`;

-- Lab02
SELECT `department_id`, ROUND(AVG(`salary`), 2) AS 'Average Salary'
FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id`;

-- Lab03
SELECT `department_id`, ROUND(MIN(`salary`), 2) AS 'Min Salary'
FROM `employees`
GROUP BY `department_id`
HAVING `Min Salary`> 800;

-- Lab04
SELECT COUNT(`category_id`) AS 'count'
FROM `products`
WHERE `category_id` = 2 AND `price`> 8
GROUP BY `category_id`;

-- Lab05
SELECT `category_id`, ROUND(AVG(`price`), 2) AS 'Average Price', 
ROUND(MIN(`price`), 2) AS 'Cheapest Product', ROUND(MAX(`price`), 2) AS 'Most Expensive Product'
FROM `products`
GROUP BY `category_id`;

-- Ex01
SELECT COUNT(*) AS 'count'
FROM `wizzard_deposits`;

-- Ex02
SELECT MAX(`magic_wand_size`) AS 'longest_magic_wand'
FROM `wizzard_deposits`;

-- Ex03
SELECT `deposit_group`, MAX(`magic_wand_size`) AS 'longest_magic_wand'
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `longest_magic_wand`, `deposit_group`;

-- Ex04
SELECT `deposit_group`
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY AVG(`magic_wand_size`)
LIMIT 1;

-- Ex05
SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum'
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `total_sum`;

-- Ex06
SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum'
FROM `wizzard_deposits`
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
ORDER BY `deposit_group`;

-- Ex07
SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum'
FROM `wizzard_deposits`
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
HAVING `total_sum` < 150000
ORDER BY `total_sum` DESC;

-- Ex08
SELECT `deposit_group`, `magic_wand_creator`, MIN(`deposit_charge`) AS 'min_deposit_charge'
FROM `wizzard_deposits`
GROUP BY `deposit_group`, `magic_wand_creator`
ORDER BY `magic_wand_creator`,`deposit_group`;

-- Ex09
SELECT 
(CASE
WHEN `age` < 11 THEN '[0-10]'
WHEN `age` < 21 THEN '[11-20]'
WHEN `age` < 31 THEN '[21-30]'
WHEN `age` < 41 THEN '[31-40]'
WHEN `age` < 51 THEN '[41-50]'
WHEN `age` < 61 THEN '[51-60]'
ELSE '[61+]'
END) AS `age_group`, COUNT(`first_name`) AS `wizard_count`
FROM `wizzard_deposits`
GROUP BY `age_group`
ORDER BY `age_group`;

-- Ex10
SELECT LEFT (`first_name`, 1) AS 'first_letter'
FROM `wizzard_deposits`
WHERE `deposit_group` = 'Troll Chest'
GROUP BY `first_letter`
ORDER BY `first_letter`;

-- Ex11
SELECT `deposit_group`,	`is_deposit_expired`, AVG (`deposit_interest`) AS 'average_interest'
FROM `wizzard_deposits`
WHERE `deposit_start_date` > '1985-01-01'
GROUP BY `deposit_group`, `is_deposit_expired`
ORDER BY `deposit_group` DESC, `is_deposit_expired`;

-- Ex12
SELECT `department_id`, min(`salary`) AS `minimum_salary`
FROM `employees`
WHERE `department_id` IN (2,5,7) AND `hire_date` > '2000-01-01'
GROUP BY department_id
ORDER BY department_id;

-- Ex 13
CREATE TABLE `high_paid_employees`
SELECT *  FROM `employees`
WHERE `salary` > 30000 AND `manager_id` != 42;

UPDATE  `high_paid_employees`
SET `salary` = `salary` + 5000
WHERE `department_id` = 1;

SELECT  `department_id`, AVG(`salary`) AS `avg_salary`
FROM `high_paid_employees`
GROUP BY `department_id`
ORDER BY `department_id`;


-- Ex14
SELECT `department_id`, MAX(`salary`) AS `max_salary`
FROM `employees`
GROUP BY `department_id`
HAVING `max_salary` NOT BETWEEN 30000 AND 70000
ORDER BY `department_id`;

-- Ex15
SELECT COUNT(`salary`) AS 'count'
FROM `employees`
WHERE `manager_id` IS NULL;

-- Ex16
SELECT e.`department_id`,
(SELECT DISTINCT e2.`salary` FROM `employees` AS e2 
WHERE e2.`department_id`  = e.`department_id`
ORDER BY e2.`salary` DESC
LIMIT 1 OFFSET 2 
) AS `3rd_highest_salary`
FROM `employees` AS e
GROUP BY e.`department_id`
HAVING `3rd_highest_salary` IS NOT NULL
ORDER BY e.`department_id`;

-- Ex17
SELECT e.`first_name`,e.`last_name`, e.`department_id`
FROM `employees` AS e
WHERE e.`salary` > 
(SELECT  AVG(e2.`salary`) FROM `employees` AS e2 
WHERE e2.`department_id`  = e.`department_id`
)
ORDER BY e.`department_id`, e.`employee_id`
LIMIT 10;

-- Ex18
SELECT `department_id`,  SUM(`salary`) AS 'total_sum'
FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id`;


