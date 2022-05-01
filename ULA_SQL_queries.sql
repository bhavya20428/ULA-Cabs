use ula;

#Find the pickup location id from locations where houseNo="1Q/58",streetName="Moulton",pincode=110052 and city="Troitskiy"
select locationID as pickupID from location where houseNo="1Q/58" and streetName="Moulton" 
and pincode=110052 and city="Troitskiy";

# find the avg slary/amt earned by male drivers vs female drivers
select avg(totalAmountEarned) as AVERAGE_SALARY, gender A from driver group by gender;


#find the list of users who have not booked any trips on the app yet
select * from User where userID not in (Select UserID from Trip where TripID is not null);

#Display all the distinct payment options/modes and the total number of times each option was availed/chosen.
select mode as "mode of payment", count(*) as "no of users" from payment group by mode;

#Display the most popular and least popular payment options among users
select P.mode as "Payment Option", count(*) as "Number of users" from payment P group by mode 
having count(*)>=all(select count(*) as "no of users" from payment group by mode) 
union
select Q.mode , count(*) as C2 from payment Q group by mode having count(*)<=all(select count(*) as "no of users" 
from payment group by mode) ;

#Find the trip ids which had prices<avg price of all trips with distance covered <20;
select tripID , price as Cost from trip where price<(select avg(price) as P1 from trip where distanceCovered< 20) ;

# Ula company wants to will gift some users discount coupons based on their participation on the app
# So find the list of all users who have taken more than 5 rides with our app
select User.userID,name as " Name", P1.Q as " No of trips taken " from User 
inner join (select userID,count(userID) as Q from trip group by userID 
having count(userID)>4 )as p1 on p1.userID=User.userID;

#Select all the drivers who are above 18 and less than 25 years old 
select driverID, name,  age from driver where age between 18 and 25; 

# Find the collection of ids of all the waiting users who have the same drop location and and sharing is chosen by both of them 
select distinct A.userID as USER1, B.userID as USER2 , 
A.status from Trip A, trip B where A.userID!=B.userID and A.dropID=B.dropID 
and A.share=true and  A.status="Waiting" and B.share=true 
order by A.userID ;

# find no of trips available for a driver whose id is in range (100,108)
select driverID,count(driverID) as "no of trips"
from matched where driverID in (select driverID from driver where driverID between 100 and 108) 
group by driverID ;

# find no of trips completed by drivers in decreasing order of completion record 
select count(driverID) as " completed trips" , driverID from matched A 
 inner join (select tripID from trip where status="Completed") as B on A.tripID=B.tripID 
 group by A.driverID order by count(driverID) desc; 
 
#Find all the driver ids whose avg rating <2 
select avg(ratings), driverID from matched group by driverID having avg(ratings)<2;

#Find top 5 highest rated drivers based on the ratings received by the users
select avg(ratings), driverID from matched group by driverID order by avg(ratings) desc LIMIT 5;

# Ula company wants to Find the most frequent pickup location among its users
select count(*) as " No of trips from this location" ,pickupID as PickupLocationID from trip T1 group by pickupID order by count(*) desc;

# find total number of female users registered on the booking service
select count(*) as "NUMBER_OF_USERS", gender as GENDER from User where gender="F";

#create a user view page which can be viewed on user's homepage for user no 531

create view userpage as
(select user.name as username,t.tripID,driver.driverID, driver.name as driver,driver.phoneNo as "driver phone no",m.ratings,startTime,endTime,distanceCovered,sharingID,price,typeName,waitingTime,otp
from user 
INNER JOIN trip t
    on user.userID=t.userID
INNER JOIN matched m
    on t.tripID=m.tripID
INNER JOIN driver
on driver.driverID=m.driverID
);
select * from userpage;





#driverpg view
create view driverpage as
(select d.driverID, d.name as Drivername, d.age, d.gender, d.phoneNo, totalAmountEarned, 
d.ratings, vehicleID,t.userID, t.pickupID, t.dropID,u.name as user_name, u.phoneNo as user_phone_no,
t.share, t.sharingID, t.price
from driver d
INNER JOIN matched m
    on d.driverID=m.tripID
INNER JOIN trip t
    on m.tripID=t.tripID
INNER JOIN User u
on t.userID=u.userID
);



# Update the phone number of a user whose id is 12
use ula;
Select * from User where UserID=12;
UPDATE User
SET phoneNo="9312247324"
WHERE UserID = 12;

show tables;

#select count(*),userID from trip group by userID order by count(*) desc ;
Select * from User where UserID=12;

select * from user;
 CREATE TABLE `USER_OLD_DATA` (
  `userID` integer,
  `name` varchar (20) not null,
  `phoneNo` char (10) not null,
  `age` int,
  `gender` varchar(1),
  primary key(userID),
  check(age>0)
);

CREATE TABLE `USER_NEW_DATA` (
  `userID` integer,
  `name` varchar (20) not null,
  `phoneNo` char (10) not null,
  `age` int,
  `gender` varchar(1),
  `msg` varchar(100),
  primary key(userID),
  check(age>0)
);
select * from payment;
drop table payments_info;

create table payments_info (payment_id INT (11) NOT NULL AUTO_INCREMENT, 
                              last_name VARCHAR (30) NOT NULL, first_name VARCHAR (25),
            created_date DATE, 
                            created_by VARCHAR(30),
                            primary key(payment_id)); 
create table payments_audit (contact_id integer, 
                             created_date date, 
                             created_by varchar (30));
                             
                           