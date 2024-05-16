CREATE DATABASE IF NOT EXISTS college;
use college;
drop table student;
create table student(
rollno int primary key,
name varchar(20),
marks int not null,
grade varchar(5),
city varchar(20));

insert into student values (101,"a",78,"c","pune"), (102,"b",72,"a","delhi"), (103,"c",75,"b","kop");

set sql_safe_updates=0;
update student
set grade="a"
where grade='y';

 