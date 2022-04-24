use ula;

#1 Update the total amount earned records of drivers who completed the latest trip as per trip records
select * from trip;
SELECT price INTO 
    @p FROM trip WHERE tripid=(SELECT max(tripID) FROM Trip where status="Completed");
select @p;
UPDATE driver
SET totalAmountEarned = totalAmountEarned + @p
WHERE driverID=(SELECT driverID FROM matched WHERE tripid=(SELECT max(tripID) FROM Trip where status="Completed"));

select totalAmountEarned from driver
WHERE driverID=(SELECT driverID FROM matched WHERE tripid=(SELECT max(tripID) FROM Trip where status="Completed"));


#2 Display the most fav and least fav payment mode among users for trips ids in range 700-750
select P.mode as "paymentPayment Option", count(*) as "Number of users" from payment P
where tripID between 700 and 900
 group by mode 
having count(*)>=all(select count(*) as "no of users" from payment where tripID between 700 and 900 group by mode) 
union
select Q.mode , count(*) as C2 from payment Q where tripID between 700 and 900
group by mode having count(*)<=all(select count(*) as "no of users" 
from payment where tripID between 700 and 900 group by mode) ;

#3 display a discount coupon message if applicable along with trip details, print a sorry note if not !

SELECT tripID, mode,
CASE WHEN discountCoupons is not null THEN 
"Congrats You won a discount Coupon !!" 
ELSE 'Sorry! there is no discount coupon available :( '
END AS Payment_Message
FROM payment ;


#4 Ula company wants to will gift its elderly users discount coupons based on their participation on the app
# So find the list of all users who have taken more than 2 rides with our app and are in age group (50-75)
select User.userID,name as " Name", User.age as "Age", P1.Q as " No of trips taken " 
from User inner join (select userID,count(userID) as Q from trip 
group by userID 
having count(userID)>2 )as p1 
on p1.userID=User.userID 
and User.age between 50 and 75;


#5 Find a pair of 2 waiting users who have the same pickup location and and sharing is chosen by both of them 
select distinct A.userID as USER1, B.userID as USER2 , 
A.status from Trip A, trip B where A.userID!=B.userID and A.pickupID=B.pickupID 
and A.share=true and  A.status="Waiting" and B.share=true 
group by A.userID
order by A.userID  ;


#6 find the no of trips and driver details where driver had to make customer wait for more than 2 hours.
select count(driverID) as " no of trips with waiting time > 2 hrs " , driverID as " DriverID", driver.name as "Driver Name" from matched A 
 inner join (select tripID from trip where status="Waiting" and endTime-startTime >2) as B on A.tripID=B.tripID 
natural join driver 
 group by A.driverID order by count(driverID) desc; 

#7 Due to some issues with Phone Pe payment could not be made initially 
# now the payment is made,
#Update the status of payment for the most recent trip which has 0 status and where mode of payment is PhonePe and 

SELECT max(tripID) into @t FROM payment where statusOfPayment=0 and mode="PhonePe";
UPDATE payment
SET statusOfPayment=1
WHERE tripID=@t;

select * from payment;

#8 Find the names of top 5 highest rated drivers based on the ratings received by the users
select driverID, driver.name ,avg(ratings)  from matched 
natural join driver group by driverID 
order by avg(ratings) desc
 LIMIT 5;

#9 Order users by their activity on the website, ie no of total trips booked and print all the details of users
Select UserID, User.name, User.phoneNo,
 User.age, User.gender
,count(tripID) from Trip natural join
 User group by UserID order by count(tripID) desc
;

#10 Find the rankings of all drivers based on their ratings(used rank over function)
SELECT name, age, gender, ratings, 
DENSE_RANK() OVER (ORDER BY ratings desc) my_rank  
FROM driver;  
