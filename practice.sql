 create database storesale;
 use storesale;
 
 create table product(
 product_id int primary key,
 product_name varchar(20),
 unit_price int
 
 );
 
create table sales(
seller_id int,
product_id int  references product(product_id),
buyer_id int,
sale_date date,
quantity int,
price int

); 

insert into product values
(1,'S8',1000),
(2,'G4',800),
(3,'iphone',1400);
insert into sales values 
( 1,1,1,'2019-01-27',2,2000),
( 1,2,2,'2019-02-17',1,800),
( 2,2,3,'2019-06-02',1,800),
( 3,3,4,'2019-05-1',2,2800);
SELECT p.product_id, p.product_name
FROM product p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
HAVING MIN(s.sale_date) >= '2019-01-01' AND MAX(s.sale_date) <= '2019-03-31';

-----------------------------------------------
drop database books ;

# Q.18


create database article;
use article;
 
create table article (
article_id int,
author_id int,
viewer_id int,
view_date date
); 
 
insert into article values 
(1,2,5,'2019-08-01'),
(1,3,6,'2019-08-02'),
(2,7,7,'2019-08-01'),
(2,7,6,'2019-08-02'),
(4,7,1,'2019-07-22'),
(3,4,4,'2019-07-21'),
(3,4,4,'2019-07-21');

select distinct author_id   from article where author_id=viewer_id order by author_id ASC;


# 	Q 19


create database delivery;
use delivery;

create table deliveery(
delivery_id int primary key,
customer_id int,
order_date date,
customer_pref_delivery_date date

);

insert into deliveery values
(1,1,'2019-08-01','2019-08-02'),
(2,5,'2019-08-02','2019-08-02'),
(3,1,'2019-08-11','2019-08-11'),
(4,3,'2019-08-24','2019-08-26'),
(5,4,'2019-08-21','2019-08-22'),
(6,2,'2019-08-11','2019-08-13');


#select (count(select delivery_id from deliveery where order_date=customer_pref_delivery_date) / count(select delivery_id from deliveery where order_date!=customer_pref_delivery_date))*100 from deliveery ;

SELECT 
    (SELECT COUNT(*) FROM deliveery WHERE order_date = customer_pref_delivery_date) * 100.0 /
    (SELECT COUNT(*) ) AS percentage
FROM deliveery
LIMIT 1;
SELECT ROUND((COUNT(CASE WHEN order_date = customer_pref_delivery_date THEN 1 END) * 100.0 / COUNT(*)), 2) AS immediate_percentage
FROM deliveery;

#-------------------------------------------------------------------------

# Q 20

create database ads;
use ads;

create table ads(
ad_id int,
user_id int,
action enum('clicked','viewed','ignored'),
primary key (ad_id,user_id) 

);

insert into ads values
(1,1,'clicked'),
(2,2,'clicked'),
(3,3,'viewed'),
(5,5,'ignored'),
(1,7,'ignored'),
(2,7,'viewed'),
(3,5,'clicked'),
(1,4,'viewed'),
(2,11,'viewed'),
(1,2,'clicked');

#self
select distinct ad_id ,round( case  when count(case when action='clicked' then 1 end)+count(case when action='viewed' then 1 end)=0 then
0
else 
count(case when action='clicked' then 1 end)*100 / (count(case when action='clicked' or action='viewed' then 1 end))end ,2) as ctr
from ads
group by ad_id
order by ctr desc;

#ai generated

SELECT 
    ad_id,
    ROUND(
        CASE 
            WHEN clicks + views = 0 THEN 0
            ELSE clicks * 100.0 / (clicks + views)
        END,
        2
    ) AS ctr
FROM (
    SELECT 
        ad_id,
        SUM(CASE WHEN action = 'Clicked' THEN 1 ELSE 0 END) AS clicks,
        SUM(CASE WHEN action = 'Viewed' THEN 1 ELSE 0 END) AS views
    FROM Ads
    WHERE action IN ('Clicked', 'Viewed') -- Exclude 'Ignored' actions
    GROUP BY ad_id
) AS ad_actions
ORDER BY ctr DESC, ad_id ASC;

----------------------------------------------

#  21

create database employee;
use employee;

create table employe(
employee_id int primary key,
team_id int
);

insert into employe values
(1,8),
(2,8),
(3,8),
(4,7),
(5,9),
(6,9);

select employee_id, team_size 
from employe
 where team_size= (select count(distinct(team_id)) from employe group by team_id) ;



SELECT e.employee_id,t.team_size
FROM employe e
JOIN (SELECT team_id,COUNT(*) AS team_size FROM  employe GROUP BY team_id) t 
where e.team_id = t.team_id;

select team_id,count(team_id) from employe group by team_id;


---------------------------------------------------------------
# Q 22

create database country_weather;
use country_weather;

create table countries(
country_id int primary key,
country_name varchar(20)
);

create table weather(
country_id int references countries.country_id,
weather_state int,
day date,
primary key (country_id,day) 
);

insert into countries values
(2,'usa'),
(3,'aus'),
(7,'peru'),
(5,'china'),
(8,'morocco'),
(9,'spain');

insert into weather values
(2,15,'2019-11-01'),
(2,12,'2019-10-28'),
(2,12,'2019-10-27'),
(3,-2,'2019-11-10'),
(3,0,'2019-11-11'),
(3,3,'2019-11-12'),
(5,16,'2019-11-07'),
(5,18,'2019-11-09'),
(5,21,'2019-11-23'),
(7,25,'2019-11-28'),
(7,22,'2019-12-01'),
(7,20,'2019-12-02'),
(8,25,'2019-11-05'),
(8,27,'2019-11-25'),
(8,31,'2019-11-23'),
(9,7,'2019-10-23'),
(9,3,'2019-12-23');


select country_id,country_name,case
when w.weather_state<=15 then 'cold'
else
	case when w.weather_state>=25 then 'Hot'
    else 'warm'
    end
end as temp_condition
from countries c 
join weather w on c.country_id=w.country_id
group by c.country_id;


#perplexity

SELECT  c.country_name,
       CASE
           WHEN avg_weather <= 15 THEN 'Cold'
           WHEN avg_weather >= 25 THEN 'Hot'
           ELSE 'Warm'
       END AS temp_condition
FROM countries c
JOIN (
    SELECT country_id, AVG(weather_state) AS avg_weather
    FROM weather
    WHERE day BETWEEN '2019-11-01' AND '2019-11-30'
    GROUP BY country_id
) w where c.country_id = w.country_id;


-------------------------------------------------------------------
# Q 23

 create database sales;
 use sales;
 
 create table prices(
 product_id int,
 start_date date,
 end_date date,
 price int,
 primary key (product_id,start_date,end_date)
 
 );
 
 create table unitsold(
 product_id int references prices(product_id),
 purchase_date date,
 units int
 );
 
INSERT INTO Prices (product_id, start_date, end_date, price)
VALUES
    (1, '2019-02-17', '2019-02-28', 5),
    (1, '2019-03-01', '2019-03-22', 20),
    (2, '2019-02-01', '2019-02-20', 15),
    (2, '2019-02-21', '2019-03-31', 30);


INSERT INTO unitsold VALUES
    (1, '2019-02-25', 100),
    (1, '2019-03-01', 15),
    (2, '2019-02-10', 200),
    (2, '2019-03-22', 30);



# Ai generated
 SELECT 
    us.product_id,
    ROUND(SUM(p.price * us.units) / SUM(us.units), 2) AS average_price
FROM 
    unitsold us
JOIN 
    Prices p 
ON us.product_id = p.product_id 
        AND us.purchase_date >= p.start_date 
        AND us.purchase_date <= p.end_date
GROUP BY 
    us.product_id;
	
---------------------------------------------------------   
    
    
# Q 24

create database activity;
use activity;

create table activity(
player_id int,
device_id int,
event_date date,
games_played int,
primary key (player_id,event_date)
);

insert into activity values
(1, 2, '2016-03-01', 5),
(1, 2, '2016-05-02', 6),
(2, 3, '2017-06-25', 1),
(3, 1, '2016-03-02', 0),
(3, 4, '2018-07-03', 5);

select player_id,(select min(event_date) ) as First_login
from activity group by player_id;
    

# Q25

SELECT player_id, device_id
FROM Activity
WHERE (player_id, event_date) IN (
  SELECT player_id, MIN(event_date)
  FROM Activity
  GROUP BY player_id
);

--------------------------------
#  26

 create database productorders;
 use productorders;

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    product_category VARCHAR(255)
);

CREATE TABLE Orders (
    product_id INT,
    order_date DATE,
    unit INT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
); 
 
 INSERT INTO Products (product_id, product_name, product_category)
VALUES
(1, 'Leetcode Solutions ', 'Book'),
(2, 'Jewels of Stringology ', 'Book'),
(3, 'HP ', 'Laptop'),
(4, 'Lenovo ', 'Laptop'),
(5, 'Leetcode Kit ', 'T-shirt');
 
 INSERT INTO Orders (product_id, order_date, unit)
VALUES
(1, '2020-02-05', 60),
(1, '2020-02-10', 70),
(2, '2020-01-18', 30),
(2, '2020-02-11', 80),
(3, '2020-02-17', 2),
(3, '2020-02-24', 3),
(4, '2020-03-01', 20),
(4, '2020-03-04', 30),
(4, '2020-03-04', 60),
(5, '2020-02-25', 50),
(5, '2020-02-27', 50),
(5, '2020-03-01', 50);





SELECT p.product_name, SUM(o.unit) AS units
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
WHERE o.order_date BETWEEN '2020-01-31' AND '2020-02-29' 

GROUP BY p.product_name
having units>=100;


















