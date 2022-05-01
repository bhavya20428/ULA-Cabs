use ula;

#added index for driver id on matched
#removed nested select clause and used join
select matched.driverID,count(matched.driverID) as "no of trips"
from matched inner join (select driver.driverID from driver where driver.driverID between 100 and 108 ) as Q on Q.driverID 
where matched.driverID between 100 and 108
group by matched.driverID ;

#1 Display the total amount earned by the driver who did latest trip
# Added index on driver id fror matched table
# Removed nested querries and added inner join 
select totalAmountEarned from driver
inner join (SELECT driverID FROM matched inner join(SELECT max(tripID) FROM Trip where status="Completed")) on tripID;


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
#use nested case conditions

SELECT tripID, mode,
CASE WHEN discountCoupons is not null THEN 
"Congrats You won a discount Coupon !!" 
ELSE 'Sorry! there is no discount coupon available :( '
END AS Payment_Message
FROM payment ;


#4 Ula company wants to will gift its elderly users discount coupons based on their participation on the app
# So find the list of all users who have taken more than 2 rides with our app and are in age group (50-75)

#created aliases for tables 
# print columns instead of *
#use joins
#created index on user's phoneno
select User.phoneNo, name as " Name", User.age as "Age", P1.Q as " No of trips taken " 
from User inner join (select userID,count(userID) as Q from trip 

having count(userID)>2  )as p1 
on p1.userID=User.userID 
where User.age between 50 and 75;


#5 Find a pair of 2 waiting users who have the same pickup location and and sharing is chosen by both of them 
#use of where instead of having
#create aliases for tables
# created index for pickupid on 
# removed distinct to save time 

select A.userID as USER1, B.userID as USER2 , 
A.status from Trip A, trip B where A.userID!=B.userID and A.pickupID=B.pickupID 
and A.share=true and  A.status="Waiting" and B.share=true 
group by A.userID
order by A.userID  ;


#6 find the no of trips and driver details where driver had to make customer wait for more than 2 hours.
#used join
# created table alias
#created an index for driver id on matched

select count(driverID) as " no of trips with waiting time > 2 hrs " , driverID 
as " DriverID", driver.name as "Driver Name" from matched A 
 inner join (select tripID from trip where status="Waiting" and endTime-startTime >2) as B on A.tripID=B.tripID 
natural join driver 
 group by A.driverID order by count(driverID) desc; 

#7 Due to some issues with Phone Pe payment could not be made initially 
# now the payment is made,
#Update the status of payment for the most recent trip which has 0 status and where mode of payment is PhonePe and 
#created temporary variable to save fetching time
SELECT max(tripID) into @t FROM payment where statusOfPayment=0 and mode="PhonePe";
UPDATE payment
SET statusOfPayment=1
WHERE tripID=@t;


#8 Find the names of top 5 highest rated drivers based on the ratings received by the users
#created index for driver on attribute phoneno
#used natural join instead of where
#use of limit keyword

select phoneNo, driver.name ,avg(ratings)  from matched 
natural join driver group by driverID 
order by avg(ratings) desc
 LIMIT 5;

#9 Order users by their activity on the website, ie no of total trips booked and print all the details of users
#use of natural join instead of where
#index created for phone no attribute of user

Select UserID, User.name, User.phoneNo,
 User.age, User.gender
,count(tripID) from Trip natural join
 User group by UserID order by count(tripID) desc
;

#10 Find the rankings of all drivers based on their ratings(used rank over function)

SELECT name, age, gender, ratings, 
DENSE_RANK() OVER (ORDER BY ratings desc) my_rank  
FROM driver;  

