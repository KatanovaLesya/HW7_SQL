CREATE SCHEMA `MyFunkDB` ;

-- В данной базе данных создать 3 таблиц, 
-- В  1-й содержатся имена и номера телефонов сотрудников некой компании 
-- Во 2-й Ведомости об их зарплате, и должностях: главный директор, менеджер, рабочий. 
-- В  3-й семейном положении, дате рождения, где они проживают. 

CREATE TABLE Employees
(EmployeesID INT auto_increment,
NameEmployee VARCHAR(20),
PhoneEmployee VARCHAR(15),
PRIMARY KEY(EmployeesID)
)
;

INSERT Employees (NameEmployee, PhoneEmployee) 
VALUES 
('Lesia Katanova', '+380664380410'),
('Stas Skalozub', '+380662226070'),
('Petro Varenyk', '+380662224080');


CREATE TABLE Positions
(PositionID INT auto_increment,
EmployeesID INT,
PositionEmployee VARCHAR(30),
SalaryEmployee INT,
PRIMARY KEY(PositionID)
);

ALTER TABLE Positions ADD CONSTRAINT FK_Emp_Pos FOREIGN KEY (EmployeesID) REFERENCES `MyJoinsDB`.`Employees` (EmployeesID);

INSERT Positions (PositionEmployee, SalaryEmployee) 
VALUES 
('General Director', 200000),
('Manager', 50000),
('Worker', 35000);

UPDATE Positions SET EmployeesID = '1' WHERE (PositionID = '1');
UPDATE Positions SET EmployeesID = '2' WHERE (PositionID = '2');
UPDATE Positions SET EmployeesID = '3' WHERE (PositionID = '3');

ALTER TABLE `MyFunkDB`.`Positions` ADD COLUMN `PersonalID` INT NULL AFTER `EmployeesID`;

ALTER TABLE Positions ADD CONSTRAINT FR_Pers FOREIGN KEY (PersonalID) REFERENCES Personal (PersonalID);

CREATE TABLE Personal
(PersonalID INT auto_increment,
EmployeesID INT,
MaritalStatus VARCHAR(20),
BirthDay date NOT NULL,
Adress VARCHAR(30),
PRIMARY KEY (PersonalID)
)
;
ALTER TABLE Personal ADD CONSTRAINT `FK_Employees` FOREIGN KEY (`EmployeesID`) REFERENCES `Employees` (`EmployeesID`);
  
INSERT Personal (MaritalStatus, BirthDay, Adress) 
VALUES 
('married', '1982-09-24', 'KYIV'),
('married', '1981-11-30', 'TERNOPIL'),
('unmarried', '2000-01-13', 'TERNOPIL');

UPDATE `Personal` SET `EmployeesID` = '1' WHERE (`PersonalID` = '1');
UPDATE `Personal` SET `EmployeesID` = '2' WHERE (`PersonalID` = '2');
UPDATE `Personal` SET `EmployeesID` = '3' WHERE (`PersonalID` = '3');

ALTER TABLE Personal ADD CONSTRAINT `FK_Pos`FOREIGN KEY (`PositionsID`) REFERENCES `MyJoinsDB`.`Positions` (`PositionID`);
UPDATE `Personal` SET `PositionsID` = '1' WHERE (`PersonalID` = '1');
UPDATE `Personal` SET `PositionsID` = '2' WHERE (`PersonalID` = '2');
UPDATE `Personal` SET `PositionsID` = '3' WHERE (`PersonalID` = '3');

-- Создайте функции / процедуры для таких заданий: 
-- 1) Требуется узнать контактные данные сотрудников (номера телефонов, место жительства). 
-- 2) Требуется узнать информацию о дате рождения всех не женатых сотрудников и номера телефонов этих сотрудников. 
-- 3) Требуется узнать информацию о дате рождения всех сотрудников с должностью менеджер и номера телефонов 
-- этих сотрудников.

DELIMITER |
CREATE PROCEDURE proc_phone_adress()
BEGIN

SELECT Employees.NameEmployee, Employees.PhoneEmployee, Adress 
		FROM Employees JOIN Personal ON Employees.EmployeesID = Personal.EmployeesID; 
END
|

DELIMITER |
CALL proc_phone_adress();|


DELIMITER |
DROP procedure proc_status_birth;
CREATE PROCEDURE proc_status_birth()
BEGIN
SELECT Employees.NameEmployee, Employees.PhoneEmployee, Personal.MaritalStatus, Personal.BirthDay FROM Employees
INNER JOIN Personal ON Employees.EmployeesID = Personal.EmployeesID
WHERE Personal.MaritalStatus = 'married'; 
END
|
DELIMITER |
CALL proc_status_birth();|

DELIMITER |
DROP procedure proc_manager;
CREATE PROCEDURE proc_manager()
BEGIN
SELECT Employees.NameEmployee, Employees.PhoneEmployee, Personal.BirthDay, Positions.PositionEmployee FROM Employees
JOIN Personal ON Employees.EmployeesID = Personal.EmployeesID
JOIN Positions ON Employees.EmployeesID = Positions.EmployeesID
WHERE Positions.PositionEmployee = 'manager';
END
|
DELIMITER |
CALL proc_manager();|


