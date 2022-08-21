-- Lab0
CREATE DATABASE `gamebar`;
USE `gamebar`;

-- Lab1
CREATE TABLE `employees` (
`id` INT primary key AUTO_INCREMENT,
`first_name` VARCHAR(30) NOT NULL,
`last_name` VARCHAR(30) NOT NULL
);
CREATE TABLE `categories` (
`id` INT primary key AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL
);

CREATE TABLE `products` (
`id` INT primary key AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL,
`category_id` INT NOT NULL 
);

-- Lab2
INSERT INTO `employees` VALUES
(1, 'Pesho', 'Peshev'),
(2,'Gosho', 'Goshev'),
(3, 'Ivan', 'Ivanov');

SELECT * FROM `employees`;

-- Lab3
ALTER TABLE `employees` 
ADD COLUMN `middle_name` VARCHAR(30);

-- Lab4
 ALTER TABLE `products` 
ADD CONSTRAINT fk_products_categories
FOREIGN KEY (`category_id`)
REFERENCES `categories`(`id`);

-- Lab5
ALTER TABLE `employees` 
MODIFY COLUMN `middle_name` VARCHAR(100);

-- Ex0
CREATE DATABASE `minions`;
USE `minions`;

-- Ex1
 CREATE TABLE `minions` (
`id` INT primary key AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL,
`age` INT NOT NULL
);

CREATE TABLE `towns` (
`town_id` INT primary key AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL
);

 -- Ex2.0
ALTER TABLE `towns` 
CHANGE COLUMN `town_id` `id` INT NOT NULL AUTO_INCREMENT;

-- Ex2
ALTER TABLE `minions`
ADD COLUMN `town_id` INT,
ADD CONSTRAINT fk_minions_towns
FOREIGN KEY (`town_id`)
REFERENCES `towns`(`id`);

-- Ex3
INSERT INTO `towns` VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna');

INSERT INTO `minions` VALUES
(1, 'Kevin',	22,	1),
(2, 'Bob',	15,	3),
(3, 'Steward', NULL, 2);

-- Ex4
TRUNCATE `minions`;

-- Ex5
DROP TABLE `minions`;
DROP TABLE `towns`;

-- Ex6
 CREATE TABLE `people` (
`id` INT primary key AUTO_INCREMENT,
`name` VARCHAR(200) NOT NULL,
`picture` BLOB,
 `height` FLOAT(5, 2),
 `weight` FLOAT(5, 2),
 `gender` CHAR(1) NOT NULL,
 `birthdate` DATE NOT NULL,
 `biography` TEXT );
 

 INSERT INTO `people` VALUES
 (1, 'Pesho', NULL, 187.25,	87.25,	'M',	'1983-03-17',	'fuyfuyfy'),
(2,	'Gosho', NULL, 177.25,	77.25,	'M',	'1984-03-17',	'fuyfuyfy'),
(3,	'Eva',NULL, 167.25,	67.25,	'F',	'1985-03-17',	'fuyfuyfy'),
(4,	'Iva',NULL, 157.25,	57.25,	'F',	'1986-03-17',	'fuyfuyfy'),
(5,	'Gosho', NULL, 197.25,	97.25,	'M',	'1982-03-17',	'fuyfuyfy');

-- Ex7
 CREATE TABLE `users` (
`id` INT primary key AUTO_INCREMENT,
`username` VARCHAR(30) NOT NULL,
`password` VARCHAR(26) NOT NULL,
`profile_picture` BLOB,
 `last_login_time` time NOT NULL,
 `is_deleted` BOOLEAN );
 
INSERT INTO `users` VALUES
(1, 'Pesho', 123, NULL, '08:14:21',	true),
(2,	'Gosho',123, NULL, '08:14:21',	false),
(3,	'Eva',123,NULL, '08:14:21',	true),
(4,	'Iva',123,NULL, '08:14:21',	false),
(5,	'Gosho',123, NULL, '08:14:21',	true);
 
 -- Ex8
ALTER TABLE `users`
DROP primary key,
ADD CONSTRAINT pk_users
PRIMARY KEY (`id`, `username`);

 -- Ex9
ALTER TABLE `users` 
CHANGE COLUMN `last_login_time` `last_login_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;

  -- Ex10
ALTER TABLE `users` 
DROP PRIMARY KEY,
ADD PRIMARY KEY (`id`);

 ALTER TABLE `users`
 CHANGE COLUMN `username` `username` VARCHAR(30) NOT NULL UNIQUE;
 
   -- Ex11 90/100
CREATE DATABASE `movies`;
USE `movies`;

CREATE TABLE `directors` (
`id` INT primary key AUTO_INCREMENT,
`director_name` VARCHAR(30) NOT NULL,
`notes` TEXT );

CREATE TABLE `genres` (
`id` INT primary key AUTO_INCREMENT,
` genre_name` VARCHAR(30) NOT NULL,
`notes` TEXT );

CREATE TABLE `categories` (
`id` INT primary key AUTO_INCREMENT,
`category_name` VARCHAR(30) NOT NULL,
`notes` TEXT );

CREATE TABLE `movies` (
`id` INT primary key AUTO_INCREMENT,
`title` VARCHAR(30) NOT NULL,
`director_id` INT NOT NULL,
/*CONSTRAINT fk_movies_directors
FOREIGN KEY (`director_id`) REFERENCES `directors`(`id`),*/
`copyright_year` VARCHAR(30) NOT NULL,
 `length` INT NOT NULL,
 `genre_id` INT NOT NULL,
/*CONSTRAINT fk_movies_genres
FOREIGN KEY (`genre_id`) REFERENCES `genres`(`id`),*/
`category_id` INT NOT NULL,
/*CONSTRAINT fk_movies_categories
FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`),*/
`rating` FLOAT  (3, 2) NOT NULL,
`notes` TEXT );


INSERT INTO `directors`(`director_name`) VALUES
('Gibson'),
('Eastwood'),
('Pesho'),
('Gosho'),
('Rasho');

INSERT INTO `genres`(` genre_name`) VALUES
('Thriller'),
('Action'),
('Comedy'),
('Drama'),
('Fantasy');

INSERT INTO `categories`(`category_name`) VALUES
('Family'),
('Animation'),
('Serial'),
('Comedy'),
('Drama');

INSERT INTO `movies`(`id`, `title`, `director_id`, `copyright_year`, `length`, `genre_id`,
 `category_id`, `rating`, `notes`) VALUES

(1, 'Test1', 1, '2001',	120, 4, 1, 6.78, NULL),
(2, 'Test2', 2, '2002',	90, 1, 2, 5.02, NULL),
(3, 'Test3', 3, '2003',	100, 5, 3, 4.25, NULL),
(4, 'Test4', 4, '2004',	140, 2, 4, 7.53, NULL),
(5, 'Test5', 5, '2005',	110, 3, 5, 8.88, NULL);

 -- Ex11 100/100
 CREATE DATABASE `movies`;
USE `movies`;

CREATE TABLE `directors`(
`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
`director_name` VARCHAR(50) NOT NULL,
`notes` TEXT
);
INSERT INTO `directors`(`id`,`director_name`, `notes`)
VALUES
('1','Pesho',NULL), 
('2','Ivan',NULL), 
('3','Gosho',NULL), 
('4','Tapata',NULL), 
('5','Ali',NULL) 
;
 
CREATE TABLE `genres`(
`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
`genre_name` VARCHAR(50) NOT NULL,
`notes` TEXT
);
 
INSERT INTO `genres` (`id`, `genre_name`, `notes`)
VALUES
('1','Parody',NULL),
('2','Comedy',NULL),
('3','Drama',NULL),
('4','Action',NULL),
('5','Animation',NULL)
;
 
CREATE TABLE `categories`(
`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
`category_name` VARCHAR(50) NOT NULL,
`notes` TEXT
);
 
INSERT INTO `categories` (`id`, `category_name`, `notes`)
VALUES
('1', '+0', NULL),
('2', '+6', NULL),
('3', '+12', NULL),
('4', '+16', NULL),
('5', '+18', NULL)
;
 
CREATE TABLE `movies`(
`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
`title` VARCHAR(50) NOT NULL,
`director_id` INT,
`copyright_year` YEAR,
`LENGTH` TIME,
`genre_id` INT,
`category_id` INT,
`rating` DECIMAL(2,1),
`notes` TEXT
);
 
INSERT INTO `movies`(`id`, `title`, `director_id`, `copyright_year`,`LENGTH`, `genre_id`,`category_id`, `rating`, `notes`)
VALUES
('1', 'No comment', '1', '1991', '00:05:00', '1','1', NULL, NULL),
('2', 'No comment', '2', '1992', '00:04:00', '2','5', NULL, NULL),
('3', 'No comment', '3', '1993', '00:03:00', '5','4', NULL, NULL),
('4', 'No comment', '4', '1994', '00:02:00', '4', '3', NULL, NULL),
('5', 'No comment', '4', '1995', '00:01:00', '3','2', NULL, NULL)
;

-- Ex12
CREATE DATABASE `car_rental`;
USE `car_rental`;

CREATE TABLE `categories` (
`id` INT primary key AUTO_INCREMENT,
`category` VARCHAR(30) NOT NULL,
`daily_rate`  FLOAT  (4, 2) NOT NULL,
`weekly_rate` FLOAT  (5, 2) NOT NULL,
`monthly_rate`FLOAT  (5, 2) NOT NULL,
`weekend_rate`FLOAT  (5, 2) NOT NULL);

-- Ex12.1 100/100
create table categories
(
	id INT(11) AUTO_INCREMENT primary key,
	category varchar(50) not null,
	daily_rate int(3),
	weekly_rate int(3),
	monthly_rate int(3),
	weekend_rate int(3)
);
create table cars
(
	id INT AUTO_INCREMENT primary key,
	plate_number varchar(50) not null,
	make varchar(50),
    model varchar(50),
	car_year int(4),
	category_id INT(11),
	doors INT(2),
	picture blob,
	car_condition varchar(50),
	available bool
);
create table employees
(
	id INT AUTO_INCREMENT primary key,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	title varchar(50),
	notes text
);
create table customers
(
	id INT AUTO_INCREMENT primary key,
	driver_licence_number int(11) not null,
	full_name varchar(50),
	address varchar(50),
	city varchar(50),
	zip_code int(5),
	notes text
);
 
create table rental_orders 
(
	id INT AUTO_INCREMENT primary key,
	employee_id int(11) not null,
	customer_id int(11),
	car_id int(11) not null,
	car_condition varchar(50),
	tank_level INT(11),
	kilometrage_start int(11),
	kilometrage_end int(11),
	total_kilometrage int(11),
	start_date date,
	end_date date,
	total_days INT(11),
	rate_applied INT(3),
	tax_rate INT(11),
	order_status varchar(50),
	notes text
);
insert into cars(plate_number)
values ('123'),('1234'),('12345');
insert into categories(category)
values ('Classic'),('Limuzine'),('Sport');
insert into customers(driver_licence_number)
values ('2232'),('232323'),('111');
insert into employees(first_name,last_name)
values ('Ivan', 'Ivanov'),('Ivan1', 'Ivanov1'), ('Ivan2', 'Ivanov2');
insert into rental_orders(employee_id,car_id)
values (1, 1),(1, 2), (2, 3);

/*car_rental database with the following entities:
•	categories (id, category, daily_rate, weekly_rate, monthly_rate, weekend_rate)
•	cars (id, plate_number, make, model, car_year, category_id, doors, picture, car_condition, available)
•	employees (id, first_name, last_name, title, notes)
•	customers (id, driver_licence_number, full_name, address, city, zip_code, notes)
•	rental_orders (id, employee_id, customer_id, car_id, car_condition, tank_level, kilometrage_start, kilometrage_end, total_kilometrage, start_date, end_date, total_days, rate_applied, tax_rate, order_status, notes)
*/

  -- Ex13
CREATE DATABASE `soft_uni`;
USE `soft_uni`;

CREATE TABLE `towns`
(`id` INT primary key AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL);

CREATE TABLE `addresses`
(`id` INT primary key AUTO_INCREMENT,
`address_text` VARCHAR(100) NOT NULL,
`town_id` INT NOT NULL,
CONSTRAINT fk_addresses_towns
FOREIGN KEY (`town_id`) REFERENCES `towns`(`id`)
);

CREATE TABLE `departments`
(`id` INT primary key AUTO_INCREMENT,
`name` VARCHAR(20) NOT NULL);

CREATE TABLE `employees`
(`id` INT primary key AUTO_INCREMENT,
`first_name` VARCHAR(30) NOT NULL,
`middle_name` VARCHAR(30) NOT NULL,
`last_name` VARCHAR(30) NOT NULL,
`job_title` VARCHAR(20),
`salary` DECIMAL (10, 2),
`department_id` INT,
`hire_date` DATE,
`address_id` INT,
CONSTRAINT fk_employees_department
FOREIGN KEY (`department_id`) REFERENCES `departments`(`id`),
CONSTRAINT fk_employees_addresses
FOREIGN KEY (`address_id`) REFERENCES `addresses`(`id`)
);

INSERT INTO `towns`(`name`) VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

INSERT INTO `departments`(`name`) VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

INSERT INTO `employees`(`id`, `first_name`, `middle_name`, `last_name`, `job_title`, `department_id`,
 `hire_date`, `salary`, `address_id`) VALUES

(1, 'Ivan', 'Ivanov', 'Ivanov',	'.NET Developer', 4, '2013-02-01', 3500.00, NULL),
(2, 'Petar', 'Petrov', 'Petrov',	'Senior Engineer', 1, '2004-03-02', 4000.00, NULL),
(3, 'Maria', 'Petrova', 'Ivanova',	'Intern', 5, '2016-08-28', 525.25, NULL),
(4, 'Georgi', 'Terziev', 'Ivanov',	'CEO', 2, '2007-12-09', 3000.00, NULL),
(5, 'Peter', 'Pan', 'Pan',	'Intern', 3, '2016-08-28', 599.88, NULL);

-- Ex14
USE `soft_uni`;
SELECT * FROM `towns`;
SELECT * FROM `departments`;
SELECT * FROM `employees`;

-- Ex15
SELECT * FROM `towns`
ORDER BY `name`;

SELECT * FROM `departments`
ORDER BY `name`;

SELECT * FROM `employees`
ORDER BY `salary` DESC;

-- Ex16
SELECT `name` FROM `towns`
ORDER BY `name`;

SELECT `name` FROM `departments`
ORDER BY `name`;

SELECT `first_name`,`last_name`, `job_title`, `salary` FROM `employees`
ORDER BY `salary` DESC;

-- Ex17
UPDATE `employees`
SET `salary` = `salary`* 1.1;

SELECT `salary` FROM `employees`;

-- Ex18
DROP TABLE `employees`;







