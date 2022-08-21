-- Lab01
DELIMITER &&

CREATE FUNCTION `ufn_count_employees_by_town`(town_name_param VARCHAR(45))
RETURNS VARCHAR(45)
	DETERMINISTIC
BEGIN

RETURN(SELECT COUNT(*)
FROM `employees` AS e
JOIN `addresses` AS a
ON  e.`address_id` = a.`address_id`
JOIN `towns` AS t
USING(`town_id`)
WHERE t.`name` = town_name_param
GROUP BY  t.`name`);

END&&

CALL `ufn_count_employees_by_town`('Sofia');
DELIMITER ;

-- Lab02
DELIMITER $$

CREATE PROCEDURE `usp_raise_salaries`(department_name_param VARCHAR(45))
BEGIN

UPDATE `employees` AS e
	JOIN `departments` AS d
	USING(department_id)
SET `salary` = `salary` * 1.05
WHERE d.`name` = department_name_param;

END $$

-- Lab03
DELIMITER $$

CREATE PROCEDURE `usp_raise_salary_by_id`(id INT)
BEGIN

UPDATE `employees` AS e
SET `salary` = `salary` * 1.05
WHERE e.`employee_id` = id;

END $$

-- Lab04
CREATE TABLE deleted_employees(
	employee_id INT PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	middle_name VARCHAR(20),
	job_title VARCHAR(50),
	department_id INT,
	salary DOUBLE 
);
DELIMITER $$
CREATE TRIGGER tr_deleted_employees
AFTER DELETE
ON employees
FOR EACH ROW
BEGIN
	INSERT INTO deleted_employees (first_name,last_name,middle_name,job_title,department_id,salary)
	VALUES(OLD.first_name,OLD.last_name,OLD.middle_name,OLD.job_title,OLD.department_id,OLD.salary);
END $$

-- Ex01
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_salary_above_35000`()
DETERMINISTIC
BEGIN
	SELECT first_name, last_name
	FROM `employees`
	WHERE `salary` > 35000
	ORDER BY first_name, last_name, employee_id;
END
DELIMITER $$
DELIMITER ;

-- Ex02
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_salary_above`(salary_param DECIMAL(19,4))
DETERMINISTIC
BEGIN
	SELECT first_name, last_name
	FROM `employees`
	WHERE `salary` >= salary_param
	ORDER BY first_name, last_name, employee_id;
END
DELIMITER $$
DELIMITER ;

CALL `usp_get_employees_salary_above`(45000);

-- Ex03
DELIMITER $$
CREATE PROCEDURE `usp_get_towns_starting_with`(string_param VARCHAR(45))
DETERMINISTIC
BEGIN

SELECT `name` AS 'town_name'
FROM `towns` AS t
WHERE LOWER(t.`name`) LIKE LOWER(CONCAT(string_param, '%'))
ORDER BY town_name;

END$$
DELIMITER ;

-- Ex04
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_from_town`(town_name VARCHAR(45))
DETERMINISTIC
BEGIN
	SELECT first_name, last_name
	FROM `employees` AS e
	JOIN addresses AS a USING (address_id)
	JOIN towns AS t USING (town_id)
	WHERE LOWER(t.`name`) LIKE LOWER(town_name)
	ORDER BY first_name, last_name, employee_id;

END$$
DELIMITER ;

-- Ex05
DELIMITER $$
CREATE FUNCTION `ufn_get_salary_level`(salary DECIMAL(19,4))
 RETURNS varchar(10)
    DETERMINISTIC
BEGIN
DECLARE salary_level  VARCHAR(10);

	IF (salary < 30000)
    THEN SET salary_level := 'Low';
	ELSEIF (salary <= 50000)
    THEN SET salary_level := 'Average';
	ELSE SET salary_level := 'High';
	END IF;
    
RETURN salary_level;
END
DELIMITER ;

-- Ex06
DELIMITER $$
CREATE FUNCTION `ufn_get_salary_level`(salary DECIMAL(19,4))
RETURNS varchar(10) 
    DETERMINISTIC
BEGIN
DECLARE salary_level  VARCHAR(10);

	IF (salary < 30000)
    THEN SET salary_level := 'Low';
	ELSEIF (salary <= 50000)
    THEN SET salary_level := 'Average';
	ELSE SET salary_level := 'High';
	END IF;
    
RETURN salary_level;
END;

CREATE PROCEDURE `usp_get_employees_by_salary_level`(salary_level VARCHAR(20))
    DETERMINISTIC
BEGIN
SELECT e.`first_name`, e.`last_name`
FROM `employees` AS e
WHERE (SELECT`ufn_get_salary_level`(e.`salary`) = salary_level)
ORDER BY first_name DESC, last_name DESC;
END

DELIMITER ;

-- Ex07
DELIMITER $$
CREATE FUNCTION `ufn_is_word_comprised`(set_of_letters varchar(50), word varchar(50))
 RETURNS BIT
    DETERMINISTIC
BEGIN
RETURN (SELECT word regexp(CONCAT('^[', set_of_letters, ']+$')));
END$$
DELIMITER ;

-- Ex08
DELIMITER $$
CREATE PROCEDURE `usp_get_holders_full_name`()
    DETERMINISTIC
BEGIN
SELECT distinct(CONCAT_WS(' ', ah.first_name, ah.last_name)) AS 'full_name'
FROM `account_holders` AS ah
JOIN `accounts` AS a
ON a.`account_holder_id`= ah.`id`
ORDER BY `full_name`;
END$$
DELIMITER ;

-- Ex09
SELECT distinct( ah.first_name), ah.last_name 
FROM `account_holders` AS ah
JOIN `accounts` AS a
ON a.`account_holder_id`= ah.`id`
GROUP BY a.`account_holder_id`
HAVING SUM(a.`balance`) > 7000
ORDER BY ah.`id`;

-- Ex10
DELIMITER $$
CREATE FUNCTION `ufn_calculate_future_value`(sum DECIMAL(19,4), yearly_interest_rate double, years int ) RETURNS decimal(19,4)
    DETERMINISTIC
BEGIN
RETURN (SELECT sum * POWER((1 + yearly_interest_rate), years));
END$$
DELIMITER ;

-- Ex11
DELIMITER $$
CREATE FUNCTION `ufn_calculate_future_value`(sum DECIMAL(19,4), yearly_interest_rate double, years int ) RETURNS decimal(19,4)
    DETERMINISTIC
BEGIN
RETURN (SELECT sum * POWER((1 + yearly_interest_rate), years));
END;

CREATE PROCEDURE `usp_calculate_future_value_for_account`(acc_id INT, interest_rate DECIMAL(19,4))
    DETERMINISTIC
BEGIN
SELECT a.`id` AS account_id, ah.first_name, ah.last_name, a.balance AS current_balance, 
(SELECT`ufn_calculate_future_value`(a.balance, interest_rate, 5)) AS balance_in_5_years
FROM `account_holders` AS ah
JOIN `accounts` AS a
ON a.`account_holder_id`= ah.`id`
WHERE a.id = acc_id;
END$$
DELIMITER ;

-- Ex12
DELIMITER $$
CREATE PROCEDURE `usp_withdraw_money`(account_id INT, money_amount DECIMAL(19,4))
    DETERMINISTIC
BEGIN
IF(money_amount > 0)
AND
(SELECT a.id AS account_id FROM accounts AS a WHERE a.id = account_id) IS NOT NULL
THEN 
START transaction;
UPDATE accounts AS a SET balance = balance + money_amount
WHERE a.id = account_id;

IF(SELECT balance FROM accounts AS a WHERE a.id = account_id) < 0
THEN ROLLBACK;
ELSE COMMIT;
END IF;

END IF;

END$$
DELIMITER ;

-- Ex13
DELIMITER $$
CREATE PROCEDURE `usp_withdraw_money`(account_id INT, money_amount DECIMAL(19,4))
    DETERMINISTIC
BEGIN
IF(money_amount > 0)
AND
(SELECT a.id AS account_id FROM accounts AS a WHERE a.id = account_id) IS NOT NULL
THEN 
START transaction;
UPDATE accounts AS a SET balance = balance - money_amount
WHERE a.id = account_id;

IF(SELECT balance FROM accounts AS a WHERE a.id = account_id) < 0
THEN ROLLBACK;
ELSE COMMIT;
END IF;

END IF;

END$$
DELIMITER ;

-- Ex14
DELIMITER $$
CREATE PROCEDURE `usp_transfer_money`(from_account_id INT, to_account_id INT, money_amount DECIMAL(19,4))
    DETERMINISTIC
BEGIN
IF(money_amount > 0)
AND
(SELECT a.id AS account_id FROM accounts AS a WHERE a.id = from_account_id) IS NOT NULL
AND
(SELECT a.id AS account_id FROM accounts AS a WHERE a.id = to_account_id) IS NOT NULL
THEN 
START transaction;
UPDATE accounts AS a SET balance = balance - money_amount
WHERE a.id = from_account_id;

UPDATE accounts AS a SET balance = balance + money_amount
WHERE a.id = to_account_id;

IF(SELECT balance FROM accounts AS a WHERE a.id = from_account_id) < 0
THEN ROLLBACK;
ELSE COMMIT;
END IF;

END IF;

END$$
DELIMITER ;

-- Ex15

CREATE TABLE `logs`(log_id INT PRIMARY KEY AUTO_INCREMENT, account_id INT,
 old_sum DECIMAL(19,4), new_sum DECIMAL(19,4));

DELIMITER $$
CREATE TRIGGER tr_balance_change
AFTER UPDATE 
ON accounts
FOR EACH ROW
BEGIN
	
    INSERT INTO `logs` (account_id, old_sum, new_sum) 
    VALUES (old.id, old.balance, new.balance);
    
END$$
DELIMITER ;

-- Ex16
CREATE TABLE `logs`(
log_id INT PRIMARY KEY AUTO_INCREMENT, 
account_id INT,
old_sum DECIMAL(19,4), 
new_sum DECIMAL(19,4));

DELIMITER $$
CREATE TRIGGER tr_balance_change
AFTER UPDATE 
ON accounts
FOR EACH ROW
BEGIN
	
    INSERT INTO `logs` (account_id, old_sum, new_sum) 
    VALUES (old.id, old.balance, new.balance);
    
END $$
DELIMITER ;
CREATE TABLE `notification_emails` (
    `id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `recipient` INT(11) NOT NULL,
    `subject` VARCHAR(50) NOT NULL,
    `body` VARCHAR(255) NOT NULL
);
 
DELIMITER $$
CREATE TRIGGER `tr_notif_emails`
AFTER UPDATE ON `logs`
FOR EACH ROW
BEGIN
    INSERT INTO `notification_emails` 
        (`recipient`, `subject`, `body`)
    VALUES (
        NEW.account_id, 
        CONCAT('Balance change for account: ', NEW.account_id), 
        CONCAT('On ', DATE_FORMAT(NOW(), '%b %d %Y at %r'), ' your balance was changed from ', ROUND(NEW.old_sum, 2), ' to ', ROUND(NEW.new_sum, 2), '.'));
END $$
DELIMITER ;


