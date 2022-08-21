-- Lab 01
CREATE TABLE `mountains`(
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name` VARCHAR (45)
);

CREATE TABLE `peaks`(
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name` VARCHAR (45),
`mountain_id` INT
);

ALTER TABLE `peaks`
ADD CONSTRAINT `fk_peaks_mountains`
FOREIGN KEY (`mountain_id`)
REFERENCES  `mountains` (`id`);


-- Lab 02
SELECT `driver_id`, `vehicle_type`, CONCAT (`first_name`, ' ', `last_name`) AS 'driver_name'
FROM `vehicles` AS v
JOIN `campers` AS c
ON v.driver_id = c.id;

-- Lab 03
SELECT `starting_point` AS `route_starting_point`,	`end_point` AS `route_ending_point`, `leader_id`, CONCAT (`first_name`, ' ', `last_name`) AS `leader_name`
FROM `routes` AS r
JOIN `campers` AS c
ON r.leader_id = c.id;

-- Lab 04
CREATE TABLE `mountains`(
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name` VARCHAR (45)
);

CREATE TABLE `peaks`(
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name` VARCHAR (45),
`mountain_id` INT
);

ALTER TABLE `peaks`
ADD CONSTRAINT `fk_peaks_mountains`
FOREIGN KEY (`mountain_id`)
REFERENCES  `mountains` (`id`)
ON DELETE CASCADE;

-- Lab 05 
CREATE TABLE `clients`(
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`client_name` VARCHAR (100)
);

CREATE TABLE `projects`(
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`client_id` INT,
`project_lead_id` INT,
CONSTRAINT `fk_projects_clients`
FOREIGN KEY (`client_id`)
REFERENCES `clients` (`id`)
);

CREATE TABLE `employees`(
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`first_name` VARCHAR (30),
`last_name` VARCHAR (30),
`project_id` INT,
CONSTRAINT `fk_employees_projects`
FOREIGN KEY (`project_id`)
REFERENCES `projects` (`id`)
);

ALTER TABLE `projects`
ADD CONSTRAINT `fk_projects_employees`
FOREIGN KEY (`project_lead_id`)
REFERENCES  `employees` (`id`);

-- Ex 01
CREATE TABLE `passports`(
`passport_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`passport_number` VARCHAR (30) UNIQUE
);

ALTER TABLE `passports`  AUTO_INCREMENT = 101;
INSERT INTO  `passports` (`passport_number`) 
VALUES
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2');

CREATE TABLE `people`(
`person_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`first_name` VARCHAR (30),
`salary` DECIMAL (10, 2),
`passport_id` INT UNIQUE,
CONSTRAINT `fk_people_passports`
FOREIGN KEY (`passport_id`)
REFERENCES `passports` (`passport_id`)
);

INSERT INTO  `people` (`first_name`, `salary`, `passport_id`) 
VALUES
('Roberto',  43300.00, 102),
('Tom', 56100.00,	103),
('Yana', 60200.00,	101);

-- Ex02
CREATE TABLE `manufacturers`(
`manufacturer_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name` VARCHAR (30) NOT NULL,
`established_on` DATE
);

INSERT INTO  `manufacturers` (`name`, `established_on`) 
VALUES
('BMW', '1916-03-01'),
('Tesla', '2003-01-01'),
('Lada', '1966-05-01');


CREATE TABLE `models`(
`model_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name` VARCHAR (30) NOT NULL,
`manufacturer_id` INT,
CONSTRAINT `fk_models_manufacturers`
FOREIGN KEY (`manufacturer_id`)
REFERENCES `manufacturers` (`manufacturer_id`)
);

INSERT INTO  `models` (`model_id`, `name`, `manufacturer_id`) 
VALUES
(101, 'X1',	1),
(102, 'i6',	1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3);


-- Ex 03
CREATE TABLE `students`(
`student_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name` VARCHAR (30)
);

INSERT INTO  `students` (`name`) 
VALUES	
('Mila'),                                      
('Toni'),
('Ron');

CREATE TABLE `exams`(
`exam_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name` VARCHAR (30)
) AUTO_INCREMENT = 101;

INSERT INTO  `exams` (`name`) 
VALUES	
('Spring MVC'),                                      
('Neo4j'),
('Oracle 11g');

CREATE TABLE `students_exams`(
`student_id` INT ,
`exam_id` INT ,
CONSTRAINT `pk_students_exams`
PRIMARY KEY (`student_id`, `exam_id`),
CONSTRAINT `fk_students_exams_students`
FOREIGN KEY (`student_id`)
REFERENCES `students` (`student_id`),
CONSTRAINT `fk_students_exams_exams`
FOREIGN KEY (`exam_id`)
REFERENCES `exams` (`exam_id`)
);
	
INSERT INTO  `students_exams`
VALUES	
    
(1,	101),
(1,	102),
(2,	101),
(3,	103),
(2,	102),
(2, 103);


-- Ex04
CREATE TABLE `teachers`(
`teacher_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name` VARCHAR (30) NOT NULL,
`manager_id` INT
);

ALTER TABLE `teachers` AUTO_INCREMENT = 101;
INSERT INTO `teachers` (`name`,	`manager_id`) VALUES
('John', NULL),	
('Maya',	106),
('Silvia', 106),
('Ted',	105),
('Mark',	101),
('Greta',	101);

ALTER TABLE `teachers`
ADD CONSTRAINT `fk_teachers_managers`
FOREIGN KEY (`manager_id`)
REFERENCES `teachers` (`teacher_id`);

-- Ex 05
CREATE TABLE `cities`(
`city_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name` VARCHAR (50) 
);

CREATE TABLE `customers`(
`customer_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name` VARCHAR (50),
`birthday` DATE,
`city_id` INT,
CONSTRAINT `fk_customers_cities`
FOREIGN KEY (`city_id`)
REFERENCES `cities` (`city_id`)
);

CREATE TABLE `orders`(
`order_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`customer_id` INT,
CONSTRAINT `fk_orders_customers`
FOREIGN KEY (`customer_id`)
REFERENCES `customers` (`customer_id`)
);

CREATE TABLE `item_types`(
`item_type_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name` VARCHAR (50) 
);

CREATE TABLE `items`(
`item_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name` VARCHAR (50) ,
`item_type_id` INT,
CONSTRAINT `fk_items_item_types`
FOREIGN KEY (`item_type_id`)
REFERENCES `item_types` (`item_type_id`)
);

CREATE TABLE `order_items`(
`order_id` INT ,
`item_id` INT ,
CONSTRAINT `pk_order_items`
PRIMARY KEY (`order_id`, `item_id`),
CONSTRAINT `fk_order_items_orders`
FOREIGN KEY (`order_id`)
REFERENCES `orders` (`order_id`),
CONSTRAINT `fk_order_items_items`
FOREIGN KEY (`item_id`)
REFERENCES `items` (`item_id`)
);

-- Ex 06
CREATE TABLE `majors` (
    `major_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50)
);

CREATE TABLE `students`(
`student_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`student_number` VARCHAR (12),
`student_name` VARCHAR (50),
`major_id` INT,
CONSTRAINT `fk_students_majors`
FOREIGN KEY (`major_id`)
REFERENCES `majors` (`major_id`)
);

CREATE TABLE `payments`(
`payment_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`payment_date` DATE,
`payment_amount` DECIMAL (8,2),
`student_id` INT,
CONSTRAINT `fk_payments_students`
FOREIGN KEY (`student_id`)
REFERENCES `students` (`student_id`)
);

CREATE TABLE `subjects`(
`subject_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`subject_name` VARCHAR (50)
);

CREATE TABLE `agenda`(
`student_id` INT ,
`subject_id` INT,
CONSTRAINT `pk_students_subjects`
PRIMARY KEY (`student_id`, `subject_id`),
CONSTRAINT `fk_students_subjects_students`
FOREIGN KEY (`student_id`)
REFERENCES `students` (`student_id`),
CONSTRAINT `fk_students_subjects_subjects`
FOREIGN KEY (`subject_id`)
REFERENCES `subjects` (`subject_id`)
);

-- Ex 09
SELECT	m.mountain_range, p.peak_name, p.elevation
FROM `mountains` AS m
JOIN `peaks` AS p
ON m.id = p.mountain_id
WHERE mountain_range = 'Rila'
ORDER BY p.elevation DESC;







	
			

