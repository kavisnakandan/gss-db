-- CREATE DATABASE
DROP DATABASE IF EXISTS GSS_DB;
CREATE DATABASE GSS_DB;
USE GSS_DB;


-- CREATE TABLES
CREATE TABLE Department (
	Dept_id INT PRIMARY KEY,
    Dept_name VARCHAR(100) NOT NULL,
    Location VARCHAR(100),
    Budget DECIMAL(12,2),
    Mgr_id INT
);

CREATE TABLE Employee (
	Employee_id INT PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    Phone_number VARCHAR(20),
    Hire_date DATE,
    Salary DECIMAL(10,2)
);

CREATE TABLE Employee_Department (
	Employee_id INT,
    Dept_id INT,
    PRIMARY KEY (Employee_id, Dept_id),
    FOREIGN KEY (Employee_id) REFERENCES Employee(Employee_id) ON DELETE CASCADE,
    FOREIGN KEY (Dept_id) REFERENCES Department(Dept_id) ON DELETE CASCADE
);

ALTER TABLE Department
ADD CONSTRAINT fk_manager
FOREIGN KEY (Mgr_id) REFERENCES Employee(Employee_id)
ON DELETE SET NULL;

CREATE TABLE Employee_Role (
	Employee_id INT,
    Employee_role VARCHAR(50),
    PRIMARY KEY (Employee_id, Employee_role),
    FOREIGN KEY (Employee_id) REFERENCES Employee(Employee_id) ON DELETE CASCADE
);

CREATE TABLE Project (
    Proj_id INT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Proj_desc VARCHAR(250),
    Proj_status VARCHAR(50) CHECK (Proj_status IN ('Ongoing' , 'Terminated', 'Completed', 'Closed')),
    Start_date DATE,
    Deadline DATE,
    Monetary_value DECIMAL(12 , 2),
    Mgr_id INT,
    FOREIGN KEY (Mgr_id)
        REFERENCES Employee (Employee_id)
        ON DELETE SET NULL
);

CREATE TABLE Project_Department (
	Proj_id INT,
    Dept_id INT,
    PRIMARY KEY (Proj_id, Dept_id),
    FOREIGN KEY (Proj_id) REFERENCES Project(Proj_id) ON DELETE CASCADE,
    FOREIGN KEY (Dept_id) REFERENCES Department(Dept_id) ON DELETE CASCADE
);

CREATE TABLE Project_Team (
	Team_id INT PRIMARY KEY,
    Proj_id INT,
    FOREIGN KEY (Proj_id) REFERENCES Project(Proj_id) ON DELETE CASCADE
);

CREATE TABLE Project_Team_Employee (
	Team_id INT,
    Employee_id INT,
    PRIMARY KEY (Team_id, Employee_id),
    FOREIGN KEY (Team_id) REFERENCES Project_Team(Team_id) ON DELETE CASCADE,
    FOREIGN KEY (Employee_id) REFERENCES Employee(Employee_id) ON DELETE CASCADE
);

CREATE TABLE Deliverable (
	Del_id INT PRIMARY KEY,
    Del_title VARCHAR(100) NOT NULL,
    Del_type VARCHAR(30),
    Del_description VARCHAR(300),
    Del_start_date DATE,
    Del_due_date DATE,
    Del_status VARCHAR(20) NOT NULL CHECK (Del_status IN ('Not Started', 'In Progress', 'Completed', 
    'In Review', 'Changes Required', 'Approved', 'Rejected')),
    Proj_id INT,
    FOREIGN KEY (Proj_id) REFERENCES Project(Proj_id) ON DELETE CASCADE
);

CREATE TABLE Task (
	Task_id INT PRIMARY KEY,
    Proj_id INT,
    Del_id INT,
    Title VARCHAR(100) NOT NULL,
    Task_desc VARCHAR(250),
    Start_date DATE,
    Due_date DATE,
    Task_status VARCHAR(50) CHECK (Task_status IN ('Not Started', 'In Progress', 'Completed')),
    FOREIGN KEY (Proj_id) REFERENCES Project(Proj_id) ON DELETE CASCADE,
	FOREIGN KEY (Del_id) REFERENCES Deliverable(Del_id) ON DELETE SET NULL
);

CREATE TABLE Employee_Task (
	Employee_id INT, 
    Task_id INT,
    PRIMARY KEY (Employee_id, Task_id),
    FOREIGN KEY (Employee_id) REFERENCES Employee(Employee_id) ON DELETE CASCADE,
    FOREIGN KEY (Task_id) REFERENCES Task(Task_id) ON DELETE CASCADE
);

CREATE TABLE Resource (
  Resource_id INT PRIMARY KEY,
  Res_name VARCHAR(100),
  Res_type VARCHAR(50),
  Quantity INT,
  AvailabilityStatus VARCHAR(20) CHECK (AvailabilityStatus IN ('Available', 'Unavailable')),
  Proj_id INT,
  FOREIGN KEY (Proj_id) REFERENCES Project(Proj_id) ON DELETE CASCADE
);

CREATE TABLE Expense (
  Exp_id INT PRIMARY KEY,
  Exp_desc VARCHAR(300),
  Amount DECIMAL(10,2),
  Exp_date date,
  Proj_id INT,
  FOREIGN KEY (Proj_id) REFERENCES Project(Proj_id) ON DELETE CASCADE
);

CREATE TABLE Customer (
	Cust_id CHAR(5) PRIMARY KEY,
    Cust_fname VARCHAR(15) NOT NULL,
    Cust_lname VARCHAR(15) NOT NULL,
    Cust_phone_num VARCHAR(20) NOT NULL,
    Cust_email VARCHAR(254),
    Cust_address VARCHAR(50),
    Cust_industry VARCHAR(30)
);

CREATE TABLE Project_Request (
	Cust_id CHAR(5),
    Proj_id INT,
    CONSTRAINT pk_project_request PRIMARY KEY (Cust_id, Proj_id),
    FOREIGN KEY (Cust_id) REFERENCES Customer(Cust_id) ON DELETE CASCADE,
    FOREIGN KEY (Proj_id) REFERENCES Project(Proj_id) ON DELETE CASCADE
);

CREATE TABLE Customer_Feedback (
	Cust_id CHAR(5),
    Proj_id INT,
    Feedback_rating INT NOT NULL CHECK (Feedback_rating >= 1 AND Feedback_rating <= 5),
    Feedback_comment VARCHAR(300),
    Feedback_date DATE,
	CONSTRAINT pk_customer_feedback PRIMARY KEY (Cust_id, Proj_id),
    FOREIGN KEY (Cust_id) REFERENCES Customer(Cust_id) ON DELETE CASCADE,
    FOREIGN KEY (Proj_id) REFERENCES Project(Proj_id) ON DELETE CASCADE
);


-- INSERTING RECORDS INTO THE TABLES
INSERT INTO Department (Dept_id, Dept_name, Location, Budget, Mgr_id) 
VALUES
(1, 'Software Development', 'New York', 500000.00, NULL),
(2, 'IT Support', 'California', 300000.00, NULL),
(3, 'HR', 'Texas', 150000.00, NULL),
(4, 'Finance', 'Florida', 200000.00, NULL),
(5, 'Marketing', 'Boston', 250000.00, NULL);

INSERT INTO Employee (Employee_id, Fname, Lname, Email, Phone_number, Hire_date, Salary) 
VALUES
(1, 'Alice','Johnson', 'alice@gss.com', '1234567890', '2022-01-15', 80000.00),
(2, 'Bob', 'Smith', 'bob@gss.com', '1234567891', '2021-09-10', 78000.00),
(3, 'Carol', 'Williams', 'carol@gss.com', '1234567892', '2020-06-20', 85000.00),
(4, 'Jack', 'Martin', 'jack@gss.com', '1234567893', '2023-01-20', 77000.00),
(5, 'Natalie', 'Adams', 'natalie@gss.com', '1234567894', '2021-04-15', 72000.00),
(6, 'David', 'Brown', 'david@gss.com', '1234567895', '2023-03-05', 60000.00),
(7, 'Eve', 'Davis', 'eve@gss.com', '1234567896', '2022-11-30', 58000.00),
(8, 'Owen', 'Harris', 'owen@gss.com', '1234567897', '2020-10-22', 70000.00),
(9, 'Mia', 'Turner', 'mia@gss.com', '1234567898', '2019-07-14', 55000.00),
(10, 'Frank', 'Miller', 'frank@gss.com', '1234567899', '2019-05-12', 70000.00),
(11, 'Grace', 'Wilson', 'grace@gss.com', '1234567800', '2023-02-01', 48000.00),
(12, 'Liam', 'Scott', 'liam@gss.com', '1234567801', '2022-06-18', 65000.00),
(13, 'Henry', 'Clark', 'henry@gss.com', '1234567802', '2021-07-22',72000.00),
(14, 'Noah', 'Lewis', 'noah@gss.com', '1234567803', '2020-08-05', 68000.00),
(15, 'Irene', 'Moore', 'irene@gss.com', '1234567804', '2022-08-18',65000.00),
(16, 'Olivia', 'King', 'olivia@gss.com', '1234567805', '2023-04-22', 72000.00),
(17, 'Emma', 'Baker', 'emma@gss.com', '1234567806', '2021-12-12', 62000.00);

INSERT INTO Employee_Department (Employee_id, Dept_id) 
VALUES
(1,1), (2,1), (3,2), (4,3), (5,4),
(6,1), (7,2), (8,2), (9,3), (10,5),
(11,5), (12,1), (13,3), (14,2), (15,5),
(16,1), (17,2);

INSERT INTO Employee_Role (Employee_id, Employee_role) 
VALUES
(1, 'Frontend Developer'),
(2, 'Backend Developer'),
(3, 'Full Stack Developer'),
(4, 'Mobile Developer'),
(5, 'QA Tester'),
(6, 'AI Engineer'),
(7, 'Technical Support'),
(8, 'System Administrator'),
(9, 'Help Desk Technician'),
(10, 'HR Manager'),
(11, 'HR Assistant'),
(12, 'Recruitment Specialist'),
(13, 'Financial Analyst'),
(14, 'Cybersecurity Specialist'),
(15, 'Marketing Specialist'),
(16, 'Marketing Manager'),
(17, 'Social Media Manager');

UPDATE Department SET Mgr_id = 1 WHERE Dept_id = 1;

UPDATE Department SET Mgr_id = 6 WHERE Dept_id = 2;

UPDATE Department SET Mgr_id = 10 WHERE Dept_id = 3;

UPDATE Department SET Mgr_id = 13 WHERE Dept_id = 4;

UPDATE Department SET Mgr_id = 16 WHERE Dept_id = 5;

INSERT INTO Project (Proj_id, Title, Proj_desc, Proj_status, Start_date, Deadline, Monetary_value, Mgr_id) 
VALUES
(1, 'Project Alpha', 'Software development project', 'Ongoing', '2023-01-01', '2023-12-31', 500000.00, 1),
(2, 'Project Beta', 'Infrastructure upgrade', 'Ongoing', '2023-03-01', '2023-09-30', 300000.00, 3),
(3, 'Project Gamma', 'HR system automation', 'Completed', '2022-05-01', '2023-02-28', 200000.00, 15),
(4, 'Project Delta', 'Marketing campaign', 'Terminated', '2022-11-01', '2023-04-30', 150000.00, 17),
(5, 'Project Epsilon', 'Finance management system', 'Completed', '2022-12-01', '2023-02-28', 400000.00, 5),
(6, 'Project Zeta', 'Cybersecurity enhancement', 'Completed', '2021-12-01', '2022-01-28', 350000.00, 14),
(7, 'Project Eta', 'AI research assistant robot', 'Completed', '2021-10-01', '2021-12-28', 450000.00, 7);

INSERT INTO Project_Department (Proj_id, Dept_id)
VALUES
(1,1), 
(2,2), 
(3,3), 
(4,5),
(5,1),
(5,4),
(6,1),
(7,3);

INSERT INTO Project_Team (Team_id, Proj_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7);

INSERT INTO Project_Team_Employee (Team_id, Employee_id) 
VALUES
(1,1), (1,2), (1,3),
(2,2), (2,3), (2,5),
(3,15), (3,11),
(4,17), (4,15), (4,12),
(5,5), (5,6),
(6,3), (6,5), (6,14),
(7,5), (7,6), (7,7);

INSERT INTO Deliverable (Del_id, Del_title, Del_type, Del_description, Del_start_date, Del_due_date, Del_status, Proj_id) VALUES
(1, 'Web Application Development', 'Software', 'Frontend and backend design of Project Alpha using HTML, CSS, JavaScript, Flask.', '2023-01-01', '2023-03-31', 'Changes Required', 1),
(2, 'Server Upgrade Report', 'Incident Report', 'Describes the tasks carried out to upgrade the server of Project Beta.', '2023-03-01', '2023-04-30', 'In Progress', 2),
(3, 'System Integration Report', 'Status Report', 'Describes the current status of system integration in Project Gamma.', '2022-09-30', '2022-10-14', 'Completed', 3),
(4, 'Ad Campaign Strategy Report', 'Strategy Report', 'Describes the marketing strategy for Project Delta.', '2022-12-01', '2023-02-28', 'Rejected', 4),
(5, 'AI Model Performance Report', 'Status Report', 'Describes the performance of AI models used in Project Epsilon.', '2022-12-01', '2023-02-28', 'Approved', 5),
(6, 'Cybersecurity Enhancement Report', 'Progress Report', 'Describes the steps taken to enhance the security of Project Zeta.', '2021-12-01', '2022-01-28', 'Approved', 6),
(7, 'AI Research Assistant Robot', 'Hardware', 'AI Robot for Project Eta, to assist in research work.', '2021-10-01', '2021-12-28', 'Approved', 7);

INSERT INTO Task (Task_id, Proj_id, Title, Task_desc, Start_date, Due_date, Task_status, Del_id) 
VALUES
(1, 1, 'Task 1', 'Frontend development', '2023-01-01', '2023-03-31', 'In Progress', 1),
(2, 1, 'Task 2', 'Backend development', '2023-01-01', '2023-03-31', 'Not Started', 1),
(3, 2, 'Task 3', 'Server upgrades', '2023-03-01', '2023-04-30', 'In Progress', 2),
(4, 3, 'Task 4', 'System integration', '2022-06-01', '2022-09-30', 'Completed', 3),
(5, 4, 'Task 5', 'Ad campaign strategy', '2022-12-01', '2023-02-28', 'Completed', 4),
(6, 5, 'Task 6', 'Web Application Development', '2022-12-01', '2023-02-28', 'Completed', NULL),
(7, 6, 'Task 7', 'Ethical Hacking of System For Bug Identification', '2021-12-01', '2022-01-28', 'Completed', 6),
(8, 7, 'Task 8', 'AI Model Development', '2021-10-01', '2021-11-28', 'Completed', 7),
(9, 7, 'Task 9', 'Robot Development', '2021-11-28', '2021-12-28', 'Completed', 7);

INSERT INTO Employee_Task (Employee_id, Task_id)
VALUES
(1,1), (3,1), (2,2), (3,2),
(2,3), (3,3), (5,3),
(15,4), (11,4),
(17,5), (15,5), (12,5),
(5,6), (6,6),
(3,7), (5,7), (14,7),
(5,8), (6,8),
(5,9), (7,8);

INSERT INTO Resource (Resource_id, Res_name, Res_type, Quantity, AvailabilityStatus, Proj_id)
VALUES
(1, 'Raspberry Pi', 'Hardware', 10, 'Available', 2),
(2, 'AWS EC2', 'Software', 5, 'Available', 1),
(3, 'UI Kit', 'Software', 1, 'Unavailable', 3),
(4, 'CRM Server', 'Hardware', 2, 'Unavailable', 5),
(5, 'Training Modules', 'Software', 3, 'Available', 4),
(6, 'Microsoft supscription', 'Software', 3, 'Available', 4);

INSERT INTO Expense (Exp_id, Exp_desc, Amount, Exp_date, Proj_id)
VALUES
(11, 'Sensor Purchase', 1200.00, '2024-01-15', 2),
(12, 'AWS Subscription', 850.00, '2023-11-10', 1),
(13, 'UI Tools', 500.00, '2024-03-01', 3),
(14, 'CRM Licensing', 3000.00, '2023-08-15', 4),
(15, 'Training Materials', 750.00, '2024-04-05', 5),
(16, 'Server', 150.00, '2025-04-01', 7),
(17, 'Deparment chairs', 550.00, '2024-04-03', 6);

INSERT INTO Customer (Cust_id, Cust_fname, Cust_lname, Cust_phone_num, Cust_email, Cust_address, Cust_industry) VALUES
('12345', 'Thomas', 'Mathew', '+971 506789275', 'thomas.mathew@gmail.com', 'Sharjah, UAE', 'Business'),
('12346', 'Awin', 'Mohamed', '+60 506299577', 'awin.mohamed@gmail.com', 'Kuala Lumpur, Malaysia', 'Marketing'),
('12347', 'Hailey', 'Dominic', '+971 503769294', 'hailey.dominic@gmail.com', 'Dubai, UAE', 'Education'),
('12348', 'Peter', 'Quint', '+65 563788375', 'peter.quint@gmail.com', 'Marina Bay, Singapore', 'Business'),
('12349', 'Shruti', 'Uma', '+971 568558927', 'shruti.uma@gmail.com', 'Sharjah, UAE', 'Medical');

INSERT INTO Project_Request (Cust_id, Proj_id) VALUES
('12345', 1),
('12346', 4),
('12347', 5),
('12347', 6),
('12347', 7),
('12348', 2),
('12348', 5),
('12349', 3);

INSERT INTO Customer_Feedback (Cust_id, Proj_id, Feedback_rating, Feedback_comment, Feedback_date) VALUES
('12349', 3, 5, 'Excellent job!', '2023-03-01'),
('12346', 4, 1, 'The marketing strategies do not suit our business needs. We are not happy with the work.', '2023-05-01'),
('12347', 5, 4, 'Great work, however a higher AI model performance would have been better.', '2023-03-05'),
('12347', 6, 5, 'Amazing security enhancement work by the team!', '2022-01-28'),
('12347', 7, 3, 'Nice job, however the movement of the robot is a bit inaccurate.', '2021-12-30');


-- SHOW ALL TABLES AND RECORDS
DESC Department;
SELECT * FROM Department;

DESC Employee;
SELECT * FROM Employee;

DESC Employee_Department;
SELECT * FROM Employee_Department;

DESC Employee_Role;
SELECT * FROM Employee_Role;

DESC Project;
SELECT * FROM Project;

DESC Project_Department;
SELECT * FROM Project_Department;

DESC Project_Team;
SELECT * FROM Project_Team;

DESC Project_Team_Employee;
SELECT * FROM Project_Team_Employee;

DESC Deliverable;
SELECT * FROM Deliverable;

DESC Task;
SELECT * FROM Task;

DESC Employee_Task;
SELECT * FROM Employee_Task;

DESC Resource;
SELECT * FROM Resource;

DESC Expense;
SELECT * FROM Expense;

DESC Customer;
SELECT * FROM Customer;

DESC Project_Request;
SELECT * FROM Project_Request;

DESC Customer_Feedback;
SELECT * FROM Customer_Feedback;


-- SQL REPORTS
-- QUERY A: Provide a List the names and roles of employees who are Project Managers
SELECT E.Fname, E.Lname, R.Employee_role
FROM Employee E, Employee_Role R
WHERE E.Employee_id = R.Employee_id
  AND E.Employee_id IN (
    SELECT DISTINCT P.Mgr_id
    FROM Project P
    WHERE P.Mgr_id IS NOT NULL
);

-- QUERY B: Retrieve the titles and deadlines of all ongoing projects
SELECT Title, Deadline
FROM Project
WHERE Proj_status = 'Ongoing';

-- QUERY C: List all employees who are part of the "Software Development" project
SELECT e.Employee_id, e.Fname, e.Lname
FROM Employee e, Project_Team_Employee pte, Project_Team pt, Project p
WHERE e.Employee_id = pte.Employee_id AND 
	pte.Team_id = pt.Team_id AND 
    pt.Proj_id = p.Proj_id AND 
    p.Proj_desc = 'Software development project';

-- QUERY D: Find the total number of employees in each department
SELECT Dept_id, COUNT(*) AS Total_Employees
FROM Employee_Department
GROUP BY Dept_id;

-- Query E: Retrieve the names of employees who are working on more than one project.
SELECT E.Fname, E.Lname
FROM Employee as E
WHERE E.Employee_id in (
	SELECT PTE.Employee_id
	FROM Project_Team_Employee AS PTE, Project_Team AS PT
	WHERE PTE.Team_id=PT.Team_id
	GROUP BY PTE.Employee_id
	HAVING COUNT(*) > 1);

-- Query F: Retrieve the names of employees who are working on projects with a status of "Completed" and 
-- have provided feedback with a rating of 5.
SELECT E.Fname, E.Lname
FROM Employee as E, Project_Team_Employee AS PTE, 
	Project_Team as PT, Project as P, Customer_Feedback as CF
WHERE E.Employee_id=PTE.Employee_id AND 
	PTE.Team_id=PT.Team_id AND 
	PT.Proj_id=P.Proj_id AND 
    PT.Proj_id=CF.Proj_id AND 
    P.Proj_status='Completed' AND 
    CF.Feedback_rating=5;

-- QUERY G: List all projects along with their total expenses, sorted by expense in descending order
SELECT p.Proj_id, p.Title, SUM(E.Amount) AS Total_Expense
FROM Project p, Expense E
WHERE p.Proj_id = E.Proj_id
GROUP BY p.Proj_id, p.Title
ORDER BY Total_Expense DESC;
