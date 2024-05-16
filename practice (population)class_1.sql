Create database cities;
use cities;

create table city(
id int primary key,
name varchar(17),
code varchar(3),
district varchar(20),
population_in_millions int

);

insert into city values
(1,'New York','USA','New York',180),
(2,'New Jersy','USA','New Jersy',120),
(3,'New Delhi','Ind','New Delhi',100),
(4,'Wuhan','chn','Wuhan',50),
(5,'Mumbai','Ind','Mumbai',130),
(6,'Ichalkaranji','Ind','Kohlapur',30),
(7,'Malegaon','Ind','Nashik',50),
(8,'California','USA','California',90)
;

select name,population_in_millions from city where code='USA' && population_in_millions>100;

select * from city where code='USA' && population_in_millions>150;

select * from city;

select * from city where id=1;




