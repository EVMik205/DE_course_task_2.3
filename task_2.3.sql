-- Глобальная задача – создать БД сотрудников компании.

/*
  1. Создать таблицу с основной информацией о сотрудниках:
  ФИО, дата рождения, дата начала работы, должность, уровень сотрудника
  (junior, middle, senior, lead), уровень зарплаты, идентификатор отдела,
  наличие/отсутствие прав (True/False).
  При этом в таблице обязательно должен быть уникальный номер для каждого сотрудника.
*/

CREATE TYPE GradeType AS ENUM ('junior', 'middle', 'senior', 'lead');

CREATE TABLE IF NOT EXISTS Employees (
	Id SERIAL PRIMARY KEY,
	Name CHARACTER VARYING(30) NOT NULL,
	Birthday DATE NOT NULL,
	StartDate DATE NOT NULL,
	Grade GradeType NOT NULL,
	Salary INTEGER,
	DepartmentId INTEGER,
	Driver BOOL DEFAULT False,
	CONSTRAINT DepartmentFk
		FOREIGN KEY (DepartmentId)
		REFERENCES Departments(Id)
		ON DELETE CASCADE
);

/*
  2. Для будущих отчётов аналитики попросили вас создать ещё одну таблицу
  с информацией по отделам – в таблице должен быть идентификатор для каждого
  отдела, название отдела (например. Бухгалтерский или IT отдел), ФИО
  руководителя и количество сотрудников.
*/

CREATE TABLE IF NOT EXISTS Departments (
	Id SERIAL PRIMARY KEY,
	Name CHARACTER VARYING(30) NOT NULL,
	HeadName CHARACTER VARYING(30) NOT NULL,
	EmployeeCount SMALLINT
);

/*
  3. На кону конец года и необходимо выплачивать сотрудникам премию.
  Премия будет выплачиваться по совокупным оценкам, которые сотрудники
  получают в каждом квартале года. Создайте таблицу, в которой для каждого
  сотрудника будут его оценки за каждый квартал. Диапазон оценок от
  A – самая высокая, до E – самая низкая.
*/

CREATE TYPE MarkType AS ENUM ('A', 'B', 'C', 'D', 'E');

CREATE TABLE IF NOT EXISTS Marks (
	Id SERIAL PRIMARY KEY,
	EmployeeId INTEGER,
	Q1Mark MarkType,
	Q2Mark MarkType,
	Q3Mark MarkType,
	Q4Mark MarkType,
	CONSTRAINT EmployeeFk
		FOREIGN KEY (EmployeeId)
		REFERENCES Employees(Id)
		ON DELETE CASCADE
);

/*
  4. Несколько уточнений по предыдущим заданиям – в первой таблице
  должны быть записи как минимум о 5 сотрудниках, которые работают
  как минимум в 2-х разных отделах. Содержимое соответствующих
  атрибутов остается на совесть вашей фантазии, но, желательно соблюдать
  осмысленность и правильно выбирать типы данных (для зарплаты – числовой
  тип, для ФИО – строковый и т.д.)
*/

INSERT INTO Departments (
    Name,
    HeadName,
    EmployeeCount
)
VALUES
    ('Developers', 'Fedorov', 4),
    ('Data Engineers', 'Smirnov', 2);

INSERT INTO Employees (
	Name,
	Birthday,
	StartDate,
	Grade,
	Salary,
	DepartmentId,
	Driver
)
VALUES
	('Ivanov', '1995-03-21', '2020-06-20', 'junior', 80000, 1, False),
	('Petrov', '1993-07-11', '2016-01-30', 'middle', 150000, 1, True),
	('Sidorov', '1990-12-03', '2012-11-17', 'senior', 250000, 1, True),
	('Smirnov', '1994-06-15', '2017-08-02', 'middle', 130000, 2, True),
	('Kuznetsov', '1996-02-11', '2022-05-20', 'junior', 70000, 2, False),
	('Fedorov', '1988-02-13', '2010-03-04', 'lead', 300000, 1, True);

/*
  5. Ваша команда расширяется и руководство запланировало открыть новый
  отдел – отдел Интеллектуального анализа данных. На начальном этапе в
  команду наняли одного руководителя отдела и двух сотрудников. Добавьте
  необходимую информацию в соответствующие таблицы.
*/
INSERT INTO Departments (
    Name,
    HeadName,
    EmployeeCount
)
VALUES
    ('Data Analytics', 'Kiselev', 3);

INSERT INTO Employees (
	Name,
	Birthday,
	StartDate,
	Grade,
	Salary,
	DepartmentId,
	Driver
)
VALUES
	('Sharapov', '1995-06-08', '2022-09-15', 'junior', 90000, 3, True),
	('Kiselev', '1992-09-19', '2022-09-05', 'middle', 170000, 3, True),
	('Alexandrov', '1996-12-25', '2022-09-23', 'junior', 80000, 3, False);

/*
  6. Теперь пришла пора анализировать наши данные – напишите запросы для
  получения следующей информации:
*/

/*
  6.1 Уникальный номер сотрудника, его ФИО и стаж работы – для всех
  сотрудников компании
*/
SELECT Id, Name, AGE(DATE(NOW()), StartDate) AS Experience FROM Employees;

/*
  6.2 Уникальный номер сотрудника, его ФИО и стаж работы – только
  первых 3-х сотрудников
*/
SELECT Id, Name, AGE(DATE(NOW()), StartDate) AS Experience FROM Employees LIMIT 3;

/*
  6.3 Уникальный номер сотрудников - водителей
*/
SELECT Id FROM Employees WHERE Driver=True;

/*
  6.4 Выведите номера сотрудников, которые хотя бы за 1 квартал получили
  оценку D или E
*/
INSERT INTO Marks (
	EmployeeId,
	Q1Mark,
	Q2Mark,
	Q3Mark,
	Q4Mark
)
VALUES
    (1, 'B', 'C', 'D', 'A'),
    (2, 'C', 'C', 'C', 'C'),
    (3, 'E', 'C', 'B', 'C'),
    (4, 'C', 'A', 'C', 'C'),
    (5, 'C', 'C', 'C', 'D'),
    (6, 'C', 'B', 'C', 'C'),
    (7, 'A', 'B', 'C', 'C'),
    (8, 'D', 'C', 'E', 'A'),
    (9, 'A', 'C', 'B', 'C');

SELECT Id From Marks WHERE 
	(Q1Mark = 'D' OR Q1Mark = 'E') OR
	(Q2Mark = 'D' OR Q2Mark = 'E') OR
	(Q3Mark = 'D' OR Q3Mark = 'E') OR
	(Q4Mark = 'D' OR Q4Mark = 'E');

/*
  6.5 Выведите самую высокую зарплату в компании.
*/
SELECT MAX(Salary) FROM Employees;

/*
  6.6* Выведите название самого крупного отдела
*/
SELECT Name FROM Departments WHERE EmployeeCount = (SELECT MAX(EmployeeCount) FROM Departments);

/*
  6.7* Выведите номера сотрудников от самых опытных до вновь прибывших
*/
SELECT Id FROM Employees ORDER BY StartDate 

/*
  6.8* Рассчитайте среднюю зарплату для каждого уровня сотрудников
*/
SELECT Grade, AVG(Salary) FROM Employees GROUP BY Grade ORDER BY Grade

/*
  6.9* Добавьте столбец с информацией о коэффициенте годовой премии
  к основной таблице. Коэффициент рассчитывается по такой схеме:
  базовое значение коэффициента – 1, каждая оценка действует на коэффициент так:
  Е – минус 20%
  D – минус 10%
  С – без изменений
  B – плюс 10%
  A – плюс 20%

  Соответственно, сотрудник с оценками А, В, С, D – должен
  получить коэффициент 1.2.
*/
ALTER TABLE Employees ADD COLUMN Bonus FLOAT;

UPDATE Employees e SET Bonus = (
(
	CASE
		WHEN Q1Mark = 'A' THEN 1.2
		WHEN Q1Mark = 'B' THEN 1.1
		WHEN Q1Mark = 'C' THEN 1
		WHEN Q1Mark = 'D' THEN 0.9
		WHEN Q1Mark = 'E' THEN 0.8
		ELSE 1 END
) * (
	CASE
		WHEN Q2Mark = 'A' THEN 1.2
		WHEN Q2Mark = 'B' THEN 1.1
		WHEN Q2Mark = 'C' THEN 1
		WHEN Q2Mark = 'D' THEN 0.9
		WHEN Q2Mark = 'E' THEN 0.8
		ELSE 1 END
) * (
	CASE
		WHEN Q3Mark = 'A' THEN 1.2
		WHEN Q3Mark = 'B' THEN 1.1
		WHEN Q3Mark = 'C' THEN 1
		WHEN Q3Mark = 'D' THEN 0.9
		WHEN Q3Mark = 'E' THEN 0.8
		ELSE 1 END
) * (
	CASE
		WHEN Q4Mark = 'A' THEN 1.2
		WHEN Q4Mark = 'B' THEN 1.1
		WHEN Q4Mark = 'C' THEN 1
		WHEN Q4Mark = 'D' THEN 0.9
		WHEN Q4Mark = 'E' THEN 0.8
		ELSE 1 END
))
FROM Marks m WHERE e.Id = m.EmployeeId