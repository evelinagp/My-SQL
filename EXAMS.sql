# EXAM_09.02.2020

CREATE schema fsd;
USE fsd;

-- 01
CREATE TABLE `players`(
id INT Primary Key AUTO_INCREMENT,
first_name VARCHAR (10) NOT NULL,
last_name VARCHAR (20) NOT NULL,
age INT NOT NULL default 0,
position CHAR(1) NOT NULL,
salary DECIMAL (10,2) NOT NULL default 0,
hire_date DATETIME,
skills_data_id INT NOT NULL,
team_id INT
-- TO DO FK
);

CREATE TABLE players_coaches(
player_id INT,
coach_id INT,
CONSTRAINT `pk_players_coaches`
PRIMARY KEY (player_id, coach_id)
);

CREATE TABLE coaches(
id INT Primary Key AUTO_INCREMENT,
first_name VARCHAR (10) NOT NULL,
last_name VARCHAR (20) NOT NULL,
salary DECIMAL (10,2) NOT NULL default 0,
coach_level INT NOT NULL default 0
);


CREATE TABLE skills_data(
id INT Primary Key AUTO_INCREMENT,
dribbling INT default 0,
pace INT default 0,
passing INT default 0,
shooting INT default 0,
speed INT default 0,
strength INT default 0
);

CREATE TABLE countries(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (45) NOT NULL);


CREATE TABLE towns(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (45) NOT NULL,
country_id INT NOT NULL,
constraint `fk_towns_countries`
foreign key (country_id)
references countries(id)
);

CREATE TABLE stadiums(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (45) NOT NULL,
capacity INT NOT NULL,
town_id INT NOT NULL,
constraint `fk_stadiums_towns`
foreign key (town_id)
references towns(id)
);

CREATE TABLE teams(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (45) NOT NULL,
established DATE NOT NULL,
fan_base BIGINT (20) NOT NULL default 0,
stadium_id INT NOT NULL,
constraint `fk_teams_stadiums`
foreign key (stadium_id)
references stadiums(id)
);

ALTER TABLE players
ADD constraint `fk_players_skills_data`
foreign key (skills_data_id)
references skills_data(id);

ALTER TABLE players
ADD constraint `fk_players_teams`
foreign key (team_id)
references teams(id);

ALTER TABLE players_coaches
ADD constraint `fk_players_coaches_players`
foreign key (player_id)
references players(id);

ALTER TABLE players_coaches
ADD constraint `fk_players_coaches_coaches`
foreign key (coach_id)
references coaches(id);

-- 02
INSERT INTO coaches(first_name, last_name, salary, coach_level)
SELECT first_name, last_name, salary * 2 , char_length(first_name) AS coach_level 
FROM players
WHERE age >=45;

-- 3
UPDATE coaches AS c
JOIN players_coaches AS pc
ON pc.coach_id = c.id
SET `coach_level` = `coach_level` + 1
WHERE first_name LIKE 'A%';

-- 4
DELETE FROM players
WHERE age >=45;

-- 5
SELECT first_name, age, salary
FROM players
ORDER BY salary DESC;

-- 6
SELECT p.id, CONCAT(p.first_name, ' ', p.last_name) AS full_name, age, p.position, p.hire_date
FROM players AS p
JOIN skills_data AS sd
ON sd.id = p.skills_data_id
WHERE p.age < 23 AND p.position= 'A'AND p.hire_date IS NULL AND sd.strength > 50
ORDER BY salary, age;

-- 7
SELECT t.`name` AS team_name,  t.established,  t.fan_base, count(p.id) AS players_count
FROM players AS p 
RIGHT JOIN teams AS t
ON p.team_id = t.id
group by  t.id
ORDER BY players_count DESC, t.fan_base DESC;

-- 8
SELECT MAX(sd.speed) AS max_speed, towns.name AS town_name
FROM players AS p	
JOIN skills_data AS sd ON sd.id = p.skills_data_id
RIGHT JOIN teams AS t ON t.id = p.team_id
JOIN stadiums AS s ON s.id = t.stadium_id
JOIN towns ON towns.id = s.town_id
WHERE t.`name` != 'Devify'
GROUP BY town_name
ORDER BY max_speed DESC, town_name;

-- 9
SELECT c.`name`, count(p.id) AS total_count_of_players, SUM(p.salary) AS total_sum_of_salaries
FROM players AS p	
RIGHT JOIN teams AS t ON t.id = p.team_id
RIGHT JOIN stadiums AS s ON s.id = t.stadium_id
RIGHT JOIN towns ON towns.id = s.town_id
RIGHT JOIN countries AS c ON towns.country_id = c.id
GROUP BY c.`name`
ORDER BY total_count_of_players DESC, c.`name`;

-- 10
DELIMITER $$
CREATE FUNCTION `udf_stadium_players_count` (stadium_name VARCHAR(30))
RETURNS INT
    DETERMINISTIC
BEGIN
RETURN (SELECT count(p.id)
FROM players AS p
RIGHT JOIN teams AS t ON t.id = p.team_id
RIGHT JOIN stadiums AS s ON s.id = t.stadium_id
WHERE s.`name` = stadium_name);
END$$
DELIMITER ;

-- 11
DELIMITER $$
CREATE PROCEDURE `udp_find_playmaker`(min_dribble_points INT, team_name VARCHAR(45))
DETERMINISTIC
BEGIN
	SELECT CONCAT(first_name, ' ', last_name) AS full_name, p.age, p.salary, sd.dribbling, sd.speed, t.`name` AS team_name
	FROM players AS p
	RIGHT JOIN teams AS t ON t.id = p.team_id
	RIGHT JOIN skills_data AS sd ON sd.id = p.skills_data_id
	WHERE sd.dribbling > 20 AND t.`name` ='Skyble' 
	AND sd.speed > (SELECT AVG(speed) FROM skills_data)
	ORDER BY sd.speed DESC LIMIT 1;
END$$
DELIMITER ;

# EXAM_18 Oct 2020 part 2
CREATE DATABASE softuni_stores_system;
USE softuni_stores_system;

# EXAM 18_OCT_2020
# 01
CREATE TABLE towns(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (20) NOT NULL UNIQUE);

CREATE TABLE addresses(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (50) NOT NULL UNIQUE,
town_id INT NOT NULL,
constraint `fk_addresses_towns`
foreign key (town_id)
references towns(id)
);

CREATE TABLE stores(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (20) NOT NULL UNIQUE,
rating FLOAT NOT NULL,
has_parking TINYINT (1) DEFAULT FALSE,
address_id INT NOT NULL,
constraint `fk_stores_addresses`
foreign key (address_id)
references addresses(id)
);

CREATE TABLE `employees`(
id INT Primary Key AUTO_INCREMENT,
first_name VARCHAR (15) NOT NULL,
middle_name CHAR (1) ,
last_name VARCHAR (20) NOT NULL,
salary DECIMAL (19,2) NOT NULL default 0,
hire_date DATE NOT NULL,
manager_id INT ,
store_id INT NOT NULL,
constraint `fk_employees_stores`
foreign key (store_id)
references stores(id),
CONSTRAINT `fk_managers_employees`
FOREIGN KEY (`manager_id`)
REFERENCES `employees` (`id`)
);

CREATE TABLE products_stores(
product_id INT NOT NULL,
store_id INT NOT NULL,
CONSTRAINT `pk_products_stores`
PRIMARY KEY (product_id, store_id)
);

CREATE TABLE `pictures`(
id INT Primary Key AUTO_INCREMENT,
url VARCHAR (100) NOT NULL,
added_on DATETIME NOT NULL);

CREATE TABLE `categories`(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (40) NOT NULL UNIQUE);

CREATE TABLE `products`(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (40) NOT NULL UNIQUE,
best_before DATE,
price DECIMAL (10,2) NOT NULL ,
description TEXT,
category_id INT NOT NULL,
picture_id INT NOT NULL,
constraint `fk_products_categories`
foreign key (category_id)
references categories(id),
CONSTRAINT `fk_products_pictures`
FOREIGN KEY (`picture_id`)
REFERENCES `pictures`(`id`)
);

ALTER TABLE products_stores
ADD constraint `fk_products_stores_products`
foreign key (product_id)
references products (id);

ALTER TABLE products_stores
ADD constraint `fk_products_stores_stores`
foreign key (store_id)
references stores(id);

# 02
INSERT INTO products_stores(product_id, store_id)
(SELECT p.id, 1 FROM products AS p
WHERE p.id NOT IN 
(SELECT product_id FROM products_stores AS ps)
 );
 
 # 03
UPDATE `employees` AS e
SET e.manager_id = 3, e.salary = (salary - 500)
WHERE YEAR(hire_date) > 2003 AND store_id NOT IN (5 , 14);

# 04
DELETE FROM employees AS e
WHERE e.manager_id IS NOT NULL AND e.salary >= 6000;

# 05
SELECT first_name, middle_name,last_name, salary, hire_date
FROM employees
ORDER BY hire_date DESC;

#06
SELECT p.`name`, p.price, best_before, concat(SUBSTRING(p.`description`, 1, 10), '...')  AS short_description, pictures.url 
FROM products AS p
JOIN pictures ON p.picture_id = pictures.id
WHERE char_length(p.`description`) > 100 AND YEAR(added_on) < 2019
AND p.price > 20
ORDER BY p.price DESC;

#07
SELECT s.`name`, COUNT(p.id) AS product_count, ROUND(avg(p.price), 2) AS `avg`
FROM products AS p
JOIN products_stores AS ps
ON p.id = ps.product_id
RIGHT JOIN stores AS s
ON s.id = ps.store_id
group by s.id
ORDER BY product_count DESC, `avg` DESC, s.id;

# 08
SELECT CONCAT_WS(' ', first_name, last_name) AS `full name`, s.`name`, a.`name`,  e.salary
FROM employees AS e
JOIN stores AS s
ON s.id = e.store_id
JOIN addresses AS a
ON a.id = s.address_id
WHERE  e.salary < 4000 AND a.`name` LIKE '%5%'
AND CHAR_LENGTH(s.`name`) > 8
AND e.`last_name` LIKE '%n';

# 09
SELECT REVERSE(s.`name`) AS reversed_name, CONCAT_WS('-', UPPER(t.`name`), a.`name`) AS full_address,
COUNT(e.id) AS employees_count
FROM employees AS e
JOIN stores AS s
ON s.id = e.store_id
JOIN addresses AS a
ON a.id = s.address_id
JOIN towns AS t
ON t.id = a.town_id
group by s.`name`
HAVING employees_count >= 1
ORDER BY full_address;

# 10
DELIMITER $$
CREATE FUNCTION `udf_top_paid_employee_by_store`(store_name VARCHAR(50)) RETURNS varchar(100) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
RETURN(SELECT CONCAT(first_name, ' ', middle_name, '.', ' ', last_name, ' works in store for ', 2020 - YEAR(hire_date), ' years') AS 'full_info' 
FROM employees AS e
JOIN stores AS s
ON s.id = e.store_id
WHERE  s.`name` = store_name
ORDER BY e.salary DESC LIMIT 1);
END$$
DELIMITER ;

# 11
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `udp_update_product_price`(address_name VARCHAR (50))
    DETERMINISTIC
BEGIN
DECLARE increase_price INT;
IF address_name LIKE '0%' THEN SET increase_price = 100;
ELSE SET increase_price = 200;
END IF;

UPDATE products AS p
SET p.price = p.price + increase_price
WHERE p.id IN(
SELECT ps.product_id FROM addresses AS a
JOIN stores AS s
ON a.id = s.address_id
JOIN products_stores AS ps
ON s.id = ps.store_id
WHERE a.`name` = address_name);
END$$
DELIMITER ;


# EXAM 31 March 2020
CREATE DATABASE instd;
USE instd;

# 01
CREATE TABLE users (
id INT Primary Key ,
username VARCHAR (30) NOT NULL UNIQUE,
password VARCHAR (30) NOT NULL,
email VARCHAR (50) NOT NULL,
gender CHAR(1) NOT NULL,
age INT NOT NULL,
job_title VARCHAR (40) NOT NULL,
ip VARCHAR (30) NOT NULL
);

CREATE TABLE addresses(
id INT Primary Key AUTO_INCREMENT,
address VARCHAR (30) NOT NULL,
town VARCHAR (30) NOT NULL,
country VARCHAR (30) NOT NULL,
user_id INT NOT NULL,
constraint `fk_addresses_users`
foreign key (user_id)
references users(id)
);

CREATE TABLE photos(
id INT Primary Key AUTO_INCREMENT,
`description` TEXT NOT NULL,
`date` DATETIME NOT NULL,
views INT NOT NULL DEFAULT 0);

CREATE TABLE comments(
id INT Primary Key AUTO_INCREMENT,
`comment` VARCHAR (255) NOT NULL,
`date` DATETIME NOT NULL,
photo_id INT NOT NULL,
constraint `fk_comments_photos`
foreign key (photo_id)
references photos(id)
);

CREATE TABLE likes(
id INT Primary Key AUTO_INCREMENT,
photo_id INT,
user_id INT,
constraint `fk_likes_photos`
foreign key (photo_id)
references photos(id),
constraint `fk_likes_users`
foreign key (user_id)
references users(id)
);

CREATE TABLE users_photos(
user_id INT NOT NULL,
photo_id INT NOT NULL,
constraint `fk_users_photos_users`
foreign key (user_id)
references users(id),
constraint `fk_users_photos_photos`
foreign key (photo_id)
references photos(id));

# 02
INSERT INTO addresses (address, town, country, user_id)
SELECT u.username, u.`password`, u.ip , u.age
FROM users AS u
WHERE u.gender = 'M';

# 03
UPDATE addresses AS a
SET `country` = (
CASE
WHEN `country`LIKE 'B%' THEN 'Blocked'
WHEN `country`LIKE 'T%' THEN 'Test'
WHEN `country`LIKE 'P%' THEN 'In Progress'
ELSE `country`
END);

# 04
DELETE FROM addresses
WHERE id % 3 = 0;

# 05
SELECT username, gender,age
FROM users
ORDER BY age DESC, username;

# 06
SELECT p.id, p.`date` AS date_and_time, p.`description`,COUNT(c.id) AS commentsCount
FROM photos AS p
JOIN comments AS c ON p.id = photo_id
GROUP BY p.id
ORDER BY commentsCount DESC, id
LIMIT 5;

# 07
SELECT concat( id, ' ' , username) AS id_username, email
FROM users AS u
JOIN users_photos AS up
ON  u.id = up.user_id
AND u.id = up.photo_id
ORDER BY u.id;

# 08
SELECT p.id AS photo_id, COUNT(DISTINCT l.id) AS likes_count, COUNT(DISTINCT c.id) AS comments_count
FROM photos AS p
LEFT JOIN likes AS l ON l.photo_id = p.id
LEFT JOIN comments AS c ON c.photo_id = p.id
GROUP BY photo_id
ORDER BY likes_count DESC, comments_count DESC, photo_id;

# 09
SELECT concat(SUBSTRING(`description`, 1, 30), '...') AS summary, `date`
FROM photos
WHERE DATE(`date`) LIKE '%10' 
ORDER BY `date` DESC;

# 10
DELIMITER $$
CREATE FUNCTION `udf_users_photos_count`(username VARCHAR(30)) RETURNS int
    DETERMINISTIC
BEGIN
RETURN (SELECT count(up.user_id) AS photosCount
FROM users_photos AS up
JOIN users AS u ON up.user_id = u.id
WHERE u.username = username);
 
END$$
DELIMITER ;

# 11
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `udp_modify_user`(address VARCHAR(30), town VARCHAR(30))
    DETERMINISTIC
BEGIN
UPDATE users AS u
RIGHT JOIN addresses AS a
ON u.id = a.user_id 
SET `age` = `age` + 10
WHERE a.address = address
AND a.town = town;
END$$
DELIMITER ;

# EXAM 9 Jun 2019
CREATE DATABASE ruk_database;
USE ruk_database;

CREATE TABLE `branches`(
id INT Primary Key AUTO_INCREMENT,
name VARCHAR (30) NOT NULL UNIQUE );

CREATE TABLE `employees`(
id INT Primary Key AUTO_INCREMENT,
first_name VARCHAR (20) NOT NULL,
last_name VARCHAR (20) NOT NULL,
salary DECIMAL (10,2) NOT NULL ,
started_on DATE NOT NULL,
branch_id INT NOT NULL,
constraint `fk_employees_branches`
foreign key (branch_id)
references branches(id)
);

CREATE TABLE `clients`(
id INT Primary Key AUTO_INCREMENT,
full_name VARCHAR (50) NOT NULL,
age INT NOT NULL
);

CREATE TABLE `bank_accounts`(
id INT Primary Key AUTO_INCREMENT,
account_number VARCHAR (10) NOT NULL,
balance DECIMAL (10,2) NOT NULL ,
client_id INT NOT NULL unique,
constraint `fk_bank_accounts_clients`
foreign key (client_id)
references clients(id)
);

CREATE TABLE `cards`(
id INT Primary Key AUTO_INCREMENT,
card_number VARCHAR (19) NOT NULL,
card_status VARCHAR (7) NOT NULL,
bank_account_id INT NOT NULL,
constraint `fk_cards_bank_accounts`
foreign key (bank_account_id)
references bank_accounts(id)
);

CREATE TABLE `employees_clients`(
employee_id INT,
client_id INT,
constraint `fk_employees_clients_employees`
foreign key (employee_id)
references employees(id),
constraint `fk_employees_clients_clients`
foreign key (client_id)
references clients(id));

# 02 
INSERT INTO cards (card_number , card_status , bank_account_id )
SELECT REVERSE(c.full_name), 'Active', c.id
FROM clients AS c
WHERE c.id between 191 and 200;

# 03

UPDATE employees_clients AS ec
SET ec.employee_id = (
SELECT ec1.employee_id FROM (SELECT * FROM  employees_clients) AS ec1
GROUP BY ec1.employee_id
ORDER BY  COUNT(ec1.client_id), ec1.employee_id LIMIT 1)
WHERE ec.employee_id  = ec.client_id;

#04
DELETE e FROM employees AS e
LEFT JOIN employees_clients AS ec
ON e.id = ec.employee_id
WHERE client_id IS NULL;

# 05
SELECT id , full_name
FROM clients
ORDER BY id;

# 06
SELECT id, CONCAT_WS(' ', first_name, last_name) AS `full name`, CONCAT('$',salary) AS salary, started_on
FROM employees 
WHERE salary >= 100000 AND started_on >= '2018-01-01'
ORDER BY salary DESC, id;

# 07
SELECT ca.id,  CONCAT_WS(' : ', ca.card_number, cl.full_name) AS card_token
FROM cards AS ca
JOIN bank_accounts AS ba ON ca.bank_account_id = ba.id
JOIN clients AS cl ON ba.client_id = cl.id
ORDER BY ca.id DESC;

# 08 
SELECT CONCAT_WS(' ', first_name, last_name) AS `name`, started_on, COUNT(ec.client_id) AS count_of_clients
FROM employees AS e
JOIN employees_clients AS ec ON e.id = ec.employee_id
GROUP BY e.id
ORDER BY count_of_clients DESC, e.id LIMIT 5;

# 09
SELECT br.`name`, COUNT(ca.id) AS count_of_cards
FROM cards AS ca
JOIN bank_accounts AS ba ON ca.bank_account_id = ba.id
JOIN clients AS cl ON ba.client_id = cl.id
JOIN employees_clients AS ec ON cl.id = ec.client_id
JOIN employees AS e ON e.id = ec.employee_id
RIGHT JOIN branches AS br ON br.id = e.branch_id
GROUP BY br.`name`
ORDER BY count_of_cards DESC,  br.`name`;

# 10
DELIMITER $$
CREATE FUNCTION `udf_client_cards_count`(name VARCHAR(30)) 
RETURNS int
    DETERMINISTIC
BEGIN
RETURN (SELECT count(ca.id) AS cards
FROM cards AS ca
JOIN bank_accounts AS ba ON ca.bank_account_id = ba.id
JOIN clients AS cl ON ba.client_id = cl.id
WHERE cl.`full_name` = name);
END$$
DELIMITER ;

# 11
DELIMITER $$
CREATE PROCEDURE `udp_clientinfo`(full_name VARCHAR(50))
    DETERMINISTIC
BEGIN
SELECT  cl.full_name, cl.age, ba.account_number , CONCAT('$', ba.balance) AS balance
FROM clients AS cl
JOIN bank_accounts AS ba ON cl.id = ba.client_id
WHERE cl.`full_name` = full_name;
END$$
DELIMITER ;

# EXAM 2018
CREATE DATABASE `colonial_journey_management_system_db`;
USE `colonial_journey_management_system_db`;

CREATE TABLE `planets`(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (30) NOT NULL );

CREATE TABLE `spaceports`(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (50) NOT NULL,
planet_id INT,
constraint `fk_spaceports_planets`
foreign key (planet_id)
references planets(id)
);

CREATE TABLE `spaceships`(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (50) NOT NULL,
manufacturer VARCHAR (30) NOT NULL,
light_speed_rate INT DEFAULT 0);

CREATE TABLE `journeys`(
id INT Primary Key AUTO_INCREMENT,
journey_start  DATETIME  NOT NULL,
journey_end DATETIME  NOT NULL,
purpose ENUM('Medical', 'Technical', 'Educational', 'Military') NOT NULL,
destination_spaceport_id INT ,
spaceship_id INT,
constraint `fk_journeys_spaceports`
foreign key (destination_spaceport_id)
references spaceports(id),
constraint `fk_journeys_spaceships`
foreign key (spaceship_id)
references spaceships(id));

CREATE TABLE `colonists`(
id INT Primary Key AUTO_INCREMENT,
`first_name` VARCHAR (20) NOT NULL,
`last_name` VARCHAR (20) NOT NULL,
`ucn` CHAR(10) NOT NULL,
`birth_date` DATE NOT NULL);

CREATE TABLE `travel_cards`(
id INT Primary Key AUTO_INCREMENT,
`card_number` CHAR(10) NOT NULL,
`job_during_journey` ENUM('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook') NOT NULL,
colonist_id INT ,
journey_id INT,
constraint `fk_travel_cards_colonists`
foreign key (colonist_id)
references colonists(id),
constraint `fk_travel_cards_journeys`
foreign key (journey_id)
references journeys(id));

# 02
INSERT INTO travel_cards(card_number, job_during_journey, colonist_id, journey_id)
SELECT (SELECT CASE
WHEN birth_date > '1980-01-01' THEN CONCAT(YEAR(birth_date), DAY(birth_date), SUBSTRING(ucn, 1, 4))
ELSE CONCAT(YEAR(birth_date), MONTH(birth_date), RIGHT(ucn, 4))
END) AS card_number,
(SELECT CASE
WHEN id % 2 = 0 THEN 'Pilot'
WHEN id % 3 = 0 THEN 'Cook'
ELSE 'Engineer'
END) AS job_during_journey,
id AS colonist_id, SUBSTRING(ucn, 1, 1) AS journey_id
FROM colonists
WHERE colonists.id between 96 and 100;

# 03
UPDATE journeys AS j
SET `purpose` = (
 CASE
WHEN j.id % 2 = 0 THEN 'Medical'
WHEN j.id % 3 = 0 THEN 'Technical'
WHEN j.id % 5 = 0 THEN 'Educational'
WHEN j.id % 7 = 0 THEN 'Military'
ELSE `purpose`
END);

# 04
DELETE c FROM colonists AS c
LEFT JOIN travel_cards AS tc
ON c.id = tc.colonist_id
WHERE tc.journey_id IS NULL;

# 05
SELECT card_number, job_during_journey
FROM travel_cards
ORDER BY card_number;

# 06
SELECT id, CONCAT(first_name, ' ', last_name) AS full_name, ucn
FROM colonists
ORDER BY first_name, last_name, id;

# 07
SELECT id, journey_start, journey_end
FROM journeys
WHERE purpose = 'Military'
ORDER BY journey_start;

# 08
SELECT c.id, CONCAT(c.first_name, ' ', c.last_name) AS full_name
FROM colonists AS c
JOIN travel_cards AS tc
ON tc.colonist_id = c.id
WHERE tc.job_during_journey = 'Pilot'
ORDER BY c.id;

# 09
SELECT COUNT(c.id) AS count
FROM colonists AS c
JOIN travel_cards AS tc
ON tc.colonist_id = c.id
JOIN journeys AS j
ON tc.journey_id = j.id
WHERE j.purpose ='Technical';

# 10
SELECT ss.`name` AS spaceship_name, sp.`name` AS spaceport_name
FROM spaceships AS ss
JOIN journeys AS j
ON j.spaceship_id = ss.id
JOIN spaceports AS sp
ON j.destination_spaceport_id = sp.id
ORDER BY ss.light_speed_rate DESC LIMIT 1;

# 11
SELECT ss.`name`,  ss.manufacturer
FROM colonists AS c
JOIN travel_cards AS tc
ON tc.colonist_id = c.id
JOIN journeys AS j
ON tc.journey_id = j.id
JOIN spaceships AS ss
ON j.spaceship_id = ss.id
WHERE tc.job_during_journey = 'Pilot' AND c.birth_date > DATE('1989-01-01')
ORDER BY ss.`name`;


#12
SELECT p.`name` AS planet_name,  sp.`name` AS spaceport_name
FROM planets AS p
JOIN spaceports AS sp
ON sp.planet_id = p.id
JOIN journeys AS j
ON j.destination_spaceport_id = sp.id
WHERE j.purpose ='Educational'
ORDER BY spaceport_name DESC;

#13
SELECT p.`name` AS planet_name, COUNT(j.id) AS journeys_count
FROM planets AS p
JOIN spaceports AS sp
ON sp.planet_id = p.id
JOIN journeys AS j
ON j.destination_spaceport_id = sp.id
GROUP BY planet_name
ORDER BY journeys_count DESC, planet_name;

# 14
SELECT j.id, p.`name` AS  planet_name, sp.`name` AS spaceport_name, j.purpose AS journey_purpose
FROM planets AS p
JOIN spaceports AS sp
ON sp.planet_id = p.id
JOIN journeys AS j
ON j.destination_spaceport_id = sp.id
ORDER BY (journey_end - journey_start) LIMIT 1;

# 15
SELECT tc.job_during_journey AS job_name
FROM planets AS p
JOIN spaceports AS sp
ON sp.planet_id = p.id
JOIN journeys AS j
ON j.destination_spaceport_id = sp.id
JOIN travel_cards AS tc
ON tc.journey_id = j.id
ORDER BY (journey_end - journey_start) DESC LIMIT 1;

# 16
DELIMITER $$
CREATE FUNCTION `udf_count_colonists_by_destination_planet`(planet_name VARCHAR (30)) RETURNS int
    DETERMINISTIC
BEGIN
RETURN ( SELECT count(c.id) AS count
FROM planets AS p
JOIN spaceports AS sp
ON sp.planet_id = p.id
JOIN journeys AS j
ON j.destination_spaceport_id = sp.id
JOIN travel_cards AS tc
ON tc.journey_id = j.id
JOIN colonists AS c
ON tc.colonist_id = c.id
WHERE p.name = planet_name);
END$$
DELIMITER ;

# 17
DELIMITER $$
CREATE PROCEDURE `udp_modify_spaceship_light_speed_rate`(spaceship_name VARCHAR(50),
 light_speed_rate_increse INT(11))
    DETERMINISTIC
BEGIN

IF((SELECT ss.`name` FROM spaceships AS ss WHERE ss.`name` = spaceship_name) IS NULL)
THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Spaceship you are trying to modify does not exists.';
ELSE
UPDATE spaceships AS ss SET light_speed_rate = light_speed_rate + light_speed_rate_increse
WHERE ss.`name` = spaceship_name;

IF((SELECT ss.`name` FROM spaceships AS ss WHERE ss.`name` = spaceship_name) IS NULL)
THEN ROLLBACK;
ELSE COMMIT;
END IF;

END IF;

END$$
DELIMITER ;

# EXAM_06August2021

CREATE DATABASE	sgd;
USE	sgd;

CREATE TABLE addresses(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (50) NOT NULL
);

CREATE TABLE offices(
id INT Primary Key AUTO_INCREMENT,
workspace_capacity INT NOT NULL,
website VARCHAR (50),
address_id INT NOT NULL,
constraint `fk_offices_addresses`
foreign key (address_id)
references addresses(id)
);

CREATE TABLE `employees`(
id INT Primary Key AUTO_INCREMENT,
first_name VARCHAR (30) NOT NULL,
last_name VARCHAR (30) NOT NULL,
age INT NOT NULL,
salary DECIMAL (10,2) NOT NULL,
job_title VARCHAR (20) NOT NULL,
happiness_level CHAR (1) NOT NULL
);

CREATE TABLE `teams`(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (40) NOT NULL,
office_id INT NOT NULL,
leader_id INT NOT NULL unique,
constraint `fk__teams_employees`
foreign key (leader_id)
references employees(id),
CONSTRAINT `fk_teams_offices`
FOREIGN KEY (office_id)
REFERENCES `offices` (`id`)
);

CREATE TABLE `games`(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (50) NOT NULL,
`description` TEXT ,
rating FLOAT NOT NULL default 5.5,
budget DECIMAL (10,2) NOT NULL default 0,
release_date DATE,
team_id INT NOT NULL,
CONSTRAINT `fk_games_teams`
FOREIGN KEY (team_id)
REFERENCES `teams` (`id`)
);

CREATE TABLE categories(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (10) NOT NULL
);

CREATE TABLE games_categories(
game_id INT NOT NULL,
category_id INT NOT NULL,
CONSTRAINT `pk_games_categories`
PRIMARY KEY (game_id, category_id),
constraint `fk_games_categories_categories`
foreign key (category_id)
references categories(id),
constraint `fk_games_categories_games`
foreign key (game_id)
references  games(id));

# 02
INSERT INTO games(`name`, rating, budget, team_id)
SELECT REVERSE(SUBSTRING(LOWER(t.`name`), 2)), t.id, leader_id * 1000 , t.id
FROM teams AS t
WHERE t.id between 1 and 9;

# 03
UPDATE employees AS e
JOIN teams AS t
ON t.leader_id = e.id
SET e.`salary` = (e.`salary` + 1000.00)
WHERE t.leader_id = e.id AND e.age < 40 AND e.salary < 5000;

# 04
DELETE g FROM games AS g
LEFT JOIN games_categories AS gc 
ON gc.game_id = g.id
WHERE gc.category_id IS NULL AND g.release_date IS NULL;

# 05
SELECT first_name, last_name,age, salary, happiness_level
FROM employees
ORDER BY salary, id;

# 06
SELECT	t.`name` AS team_name, a.`name` AS address_name, CHAR_LENGTH(a.`name`) AS count_of_characters
FROM addresses AS a
JOIN offices AS o
ON o.address_id = a.id
JOIN teams AS t
ON t.office_id = o.id
WHERE o.website IS NOT NULL
ORDER BY team_name, address_name;

# 07
SELECT	c.`name`, COUNT(g.id) AS games_count, ROUND(AVG(g.`budget`),2) AS avg_budget, MAX(g.rating) AS max_rating
FROM games AS g
JOIN `games_categories` AS gc
ON gc.game_id = g.id
JOIN categories AS c
ON gc.category_id = c.id
GROUP BY c.id
HAVING MAX(g.rating) >= 9.5
ORDER BY games_count DESC, c.`name`;

# 08

SELECT g.`name`, g.release_date, CONCAT(SUBSTRING(g.`description`, 1, 10),  '...')	AS summary, 
(CASE
WHEN MONTH(release_date) BETWEEN 01 AND 03 THEN 'Q1'
WHEN MONTH(release_date) BETWEEN 04 AND 06 THEN 'Q2'
WHEN MONTH(release_date) BETWEEN 07 AND 09 THEN 'Q3'
WHEN MONTH(release_date) BETWEEN 10 AND 12 THEN 'Q4'
END)
AS `quarter`, t.`name` AS team_name
FROM games AS g
JOIN teams AS t
ON g.team_id = t.id
WHERE RIGHT(g.`name`, 1) = 2 AND MONTH(g.release_date) % 2 = 0
AND YEAR(g.release_date) = 2022
ORDER BY `quarter`;

# 09
SELECT g.`name`, 
(CASE
WHEN budget < 50000 THEN 'Normal budget'
ELSE 'Insufficient budget'
END)
AS budget_level, t.`name` AS team_name, a.`name` AS address_name
FROM games_categories AS gc 
RIGHT JOIN games AS g  ON gc.game_id = g.id
JOIN teams AS t
ON g.team_id = t.id
JOIN offices AS o
ON t.office_id = o.id
JOIN addresses AS a
ON o.address_id = a.id
WHERE g.release_date IS NULL AND gc.category_id IS NULL 
ORDER BY g.`name`;

# 10
DELIMITER $$
CREATE FUNCTION `udf_game_info_by_name` (game_name VARCHAR (20)) 
RETURNS TEXT
  DETERMINISTIC
BEGIN
RETURN (SELECT CONCAT('The ', g.`name`, ' is developed by a ',t.`name`, ' in an office with an address ', a.`name`)
FROM games AS g
JOIN teams AS t
ON g.team_id = t.id
JOIN offices AS o
ON t.office_id = o.id
JOIN addresses AS a
ON o.address_id = a.id
WHERE g.name = game_name);
END $$
DELIMITER ;

# 11
DELIMITER $$
CREATE PROCEDURE `udp_update_budget`(min_game_rating FLOAT)
DETERMINISTIC
BEGIN
CREATE DEFINER=`root`@`localhost` PROCEDURE `udp_update_budget`(min_game_rating FLOAT)
    DETERMINISTIC
BEGIN
UPDATE games AS g
LEFT JOIN `games_categories` AS gc
ON gc.game_id = g.id
SET g.budget =  g.budget + 100000, release_date = release_date + 1
WHERE gc.category_id IS NULL AND g.release_date IS NOT NULL 
AND g.rating > min_game_rating;
END
DELIMITER ;


# Exam - 20 June 2021
CREATE DATABASE stc;
USE stc;

CREATE TABLE addresses(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (100) NOT NULL);

CREATE TABLE clients(
id INT Primary Key AUTO_INCREMENT,
`full_name` VARCHAR (50) NOT NULL,
`phone_number` VARCHAR (20) NOT NULL);

CREATE TABLE categories(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (10) NOT NULL);

CREATE TABLE `cars`(
id INT Primary Key AUTO_INCREMENT,
make VARCHAR (20) NOT NULL,
model VARCHAR (20),
`year` INT NOT NULL default 0,
`mileage` INT default 0,
`condition` CHAR(1) NOT NULL,
category_id INT NOT NULL,
CONSTRAINT `fk_cars_categories`
FOREIGN KEY (`category_id`)
REFERENCES `categories`(`id`)
);

CREATE TABLE `courses`(
id INT Primary Key AUTO_INCREMENT,
from_address_id INT NOT NULL,
`start` DATETIME NOT NULL,
`bill` DECIMAL(10, 2) default 10,
car_id INT NOT NULL,
client_id INT NOT NULL,
CONSTRAINT `fk_courses_cars`
FOREIGN KEY (`car_id`)
REFERENCES `cars`(`id`),
CONSTRAINT `fk_courses_clients`
FOREIGN KEY (`client_id`)
REFERENCES `clients`(`id`),
CONSTRAINT `fk_courses_addresses`
FOREIGN KEY (`from_address_id`)
REFERENCES `addresses`(`id`)
);

CREATE TABLE `drivers`(
id INT Primary Key AUTO_INCREMENT,
first_name VARCHAR (30) NOT NULL,
last_name VARCHAR (30) NOT NULL,
age INT NOT NULL,
rating FLOAT DEFAULT(5.5)
);


CREATE TABLE cars_drivers(
car_id INT NOT NULL,
driver_id INT NOT NULL,
CONSTRAINT `pk_cars_drivers`
PRIMARY KEY (car_id, driver_id),
constraint `fk_cars_drivers_cars`
foreign key (car_id)
references cars(id),
constraint `fk_cars_drivers_drivers`
foreign key (driver_id)
references  drivers(id));


# 02
INSERT INTO clients(full_name, phone_number )
SELECT CONCAT_WS(' ', d.first_name, d.last_name), CONCAT('(088) 9999', d.id * 2) 
FROM drivers AS d
WHERE d.id between 10 and 20;

# 03
UPDATE cars AS c
SET `condition` = 'C'
WHERE c.`year` <= 2010 AND c.make!= 'Mercedes-Benz' AND (c.mileage >= 800000
OR c.mileage IS NULL);

# 04
DELETE c FROM clients AS c
LEFT JOIN courses AS cr ON cr.client_id = c.id
WHERE CHAR_LENGTH(c.full_name) > 3 AND cr.id IS NULL;
#that do not have any courses and the count of the characters in the full_name is more than 3 characters. 

# 05
SELECT make	, model, `condition`
FROM cars
ORDER BY id;

# 06
SELECT d.first_name, d.last_name, c.make,	c.model, c.mileage
FROM cars AS c
JOIN cars_drivers AS cd ON cd.car_id = c.id
JOIN drivers AS d ON cd.driver_id = d.id
WHERE c.mileage IS NOT NULL
ORDER BY c.mileage DESC, d.first_name;

# 07
SELECT c.id AS car_id, c.make, c.mileage, COUNT(cr.id) AS count_of_courses, ROUND(AVG(bill), 2) AS avg_bill
FROM cars AS c
LEFT JOIN courses AS cr ON cr.car_id = c.id
GROUP BY c.id
HAVING COUNT(cr.id) != 2
ORDER BY count_of_courses DESC, c.id;

# 08
SELECT cl.full_name, COUNT(cr.car_id) AS count_of_cars, ROUND(SUM(cr.bill), 2) AS total_sum
FROM courses AS cr
JOIN clients AS cl ON cr.client_id = cl.id
GROUP BY cl.full_name
HAVING SUBSTRING(cl.full_name, 2, 1) = 'a' AND COUNT(cr.id)  > 1
ORDER BY cl.full_name;

# 09
SELECT  a.`name`, cr.`start` AS day_time, cr.bill, cl.full_name, c.make, c.model, cg.`name` AS category_name
FROM courses AS cr
RIGHT JOIN clients AS cl ON cr.client_id = cl.id
RIGHT JOIN addresses AS a ON cr.from_address_id = a.id
LEFT JOIN cars AS c ON cr.car_id = c.id
LEFT JOIN categories AS cg ON c.category_id = cr.id
GROUP BY cl.full_name
ORDER BY cr.id;

# 10
DELIMITER $$
CREATE FUNCTION `udf_courses_by_client` (phone_num VARCHAR (20)) 
RETURNS INT 
    DETERMINISTIC
BEGIN
RETURN (SELECT count(cr.id)
FROM courses AS cr
RIGHT JOIN clients AS cl ON cr.client_id = cl.id
WHERE cl.phone_number = phone_num);
END$$
DELIMITER ;

#11
DELIMITER $$
CREATE PROCEDURE `udp_courses_by_address`(address_name VARCHAR(100))
DETERMINISTIC
BEGIN
SELECT a.`name`, cl.full_name, 	
(SELECT CASE
WHEN cr.bill <= 20 THEN 'Low'
WHEN cr.bill <= 30 THEN 'Medium'
ELSE 'High'
END) AS level_of_bill, c.make, c.`condition`, cg.`name` AS cat_name 
	FROM courses AS cr
	RIGHT JOIN clients AS cl ON cr.client_id = cl.id
	RIGHT JOIN addresses AS a ON cr.from_address_id = a.id
	LEFT JOIN cars AS c ON cr.car_id = c.id
	LEFT JOIN categories AS cg ON c.category_id = cr.id
	WHERE  a.`name` = address_name
	ORDER BY c.make, cl.full_name;
END$$
DELIMITER ;

	
# THE EXAM!!!

CREATE DATABASE online_store;
USE online_store;


CREATE TABLE customers(
id INT Primary Key AUTO_INCREMENT,
first_name VARCHAR (20) NOT NULL,
last_name VARCHAR (20) NOT NULL,
phone VARCHAR (30) NOT NULL UNIQUE,
address VARCHAR (60) NOT NULL,
discount_card BIT(1) NOT NULL DEFAULT FALSE
);

CREATE TABLE orders(
id INT Primary Key AUTO_INCREMENT,
order_datetime DATETIME NOT NULL,
customer_id INT NOT NULL,
constraint `fk_orders_customers`
foreign key (customer_id)
references customers(id)
);

CREATE TABLE `reviews`(
id INT Primary Key AUTO_INCREMENT,
content TEXT,
rating DECIMAL (10,2) NOT NULL,
picture_url VARCHAR (80) NOT NULL,
published_at DATETIME NOT NULL
);

CREATE TABLE brands(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (40) NOT NULL UNIQUE);

CREATE TABLE categories(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (40) NOT NULL UNIQUE);

CREATE TABLE `products`(
id INT Primary Key AUTO_INCREMENT,
`name` VARCHAR (40) NOT NULL ,
price DECIMAL (19,2) NOT NULL,
 quantity_in_stock INT,
`description` TEXT,
 brand_id INT NOT NULL,
 category_id INT NOT NULL,
 review_id INT,
 constraint `fk_products_brands`
 foreign key (brand_id)
 references brands(id),
 constraint `fk_products_reviews`
 foreign key (review_id)
 references reviews(id), 
 constraint `fk_products_categories`
 foreign key (category_id)
 references categories(id)
);

CREATE TABLE orders_products(
order_id INT,
product_id INT,
constraint `fk_orders_products_orders`
foreign key (order_id)
references orders(id),
constraint `fk_orders_products_products`
foreign key (product_id)
references  products(id));


-- 02
INSERT INTO reviews(content, picture_url, published_at, rating)
SELECT SUBSTRING(p.`description`, 1, 15) ,REVERSE(p.`name`), '2010-10-10',  p.price/8
FROM products AS p
WHERE p.id >=5;

-- 3
UPDATE products AS p
SET quantity_in_stock = quantity_in_stock - 5
WHERE quantity_in_stock BETWEEN 60 AND 70;


-- 4
DELETE c FROM customers AS c
JOIN orders AS o ON c.id = o.customer_id
WHERE o.customer_id IS NULL;

#4.2
DELETE c FROM customers AS c
LEFT JOIN orders AS o ON c.id = o.customer_id
WHERE o.id IS NULL;

#Delete all customers, who didn't order anything.

-- 5
SELECT id, `name`
FROM categories
ORDER BY `name` DESC;

-- 6
SELECT p.id, p.brand_id, p.`name`, p.quantity_in_stock
FROM products AS p
WHERE p.quantity_in_stock < 30 AND p.price > 1000
ORDER BY p.quantity_in_stock, p.id;
#price is higher than 1000 and their quantity is lower than 30.

-- 7 
SELECT id, content, rating, picture_url, published_at
FROM reviews 
WHERE SUBSTRING(content, 1, 2) = 'My' AND CHAR_LENGTH(content) > 61
ORDER BY rating DESC;
 #which content starts with ‘My’ and the characters of the content are more than 61 symbols.

-- 8
SELECT  CONCAT(c.first_name, ' ' , c.last_name) AS full_name, c.address, o.order_datetime
FROM customers AS c
JOIN orders AS o ON c.id = o.customer_id
WHERE YEAR(o.order_datetime) <=2018
ORDER BY full_name DESC;

-- 9
SELECT COUNT(c.id) AS items_count, c.`name`, SUM(p.quantity_in_stock) AS total_quantity
FROM categories AS c
JOIN products AS p ON c.id = p.category_id
GROUP BY  c.`name`
ORDER BY `items_count` DESC, total_quantity LIMIT 5;

-- 10
DELIMITER $$
CREATE FUNCTION `udf_customer_products_count`(`name` VARCHAR(30)) RETURNS int
    DETERMINISTIC
BEGIN
RETURN (SELECT count(op.product_id) AS total_products
FROM customers AS c
JOIN orders AS o ON c.id = o.customer_id
JOIN orders_products AS op ON o.id = op.order_id
JOIN products AS p ON p.id = op.product_id
WHERE c.first_name = `name`);
END$$
DELIMITER ;


-- 11
DELIMITER $$
CREATE PROCEDURE `udp_reduce_price` (category_name VARCHAR(50))
DETERMINISTIC
BEGIN
	UPDATE products AS p
JOIN categories AS c ON c.id = p.category_id 
JOIN reviews AS r ON r.id = p.review_id 
SET p.price = 0.7 * p.price
WHERE r.rating < 4 AND c.`name` = category_name;
END$$
DELIMITER ;


SELECT EXTRACT(DAY FROM'2000-02-03');
SELECT DAY('2000-02-03');


