CREATE DATABASE college;
USE college;
CREATE TABLE student(
	id 	INT PRIMARY KEY,
    name VARCHAR(50),
    age INT NOT NULL
);
INSERT INTO student values(1, "Yash",20);
INSERT INTO student values(2, "YR" ,26);
 SELECT * FROM student;