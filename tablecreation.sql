/*if it already exists*/
drop database ULA;
create database ULA;
use ULA;

CREATE TABLE `USER` (
  `userID` integer,
  `name` varchar (50) not null,
  `phoneNo` char (10) not null,
  `age` int,
  `gender` varchar(1),
  `password` varchar(25),
  primary key(userID),
  check(age>0)
);

CREATE TABLE `CAB_TYPE` (
  `typeName` varchar(20),
  `cost` int default 50 not null,
  `numberOfSeats` int not null ,
  Primary key(typeName),
  check(numberOfSeats>0)
);

CREATE TABLE `VEHICLE` (
  `vehicleID` int,
  `model` varchar(20) ,
  `fuelType` varchar(20) ,
  `color` varchar(20),
  `typeName` varchar(20) not null,
  Primary Key(vehicleId),
  Foreign Key(typeName) references CAB_TYPE(typeName) 		
);


CREATE TABLE `DRIVER` (
  `driverID` integer,
  `name` varchar(50) not null,
  `age` integer,
  `gender` varchar(1),
  `phoneNo` char(10) not null,
  `totalAmountEarned` integer default 0,
  `ratings` float,
  `vehicleID` int not null,
  `password` varchar(25),
  `licenseNo` varchar(10),
  check(age>0 and totalAmountEarned>0),
  check(ratings<=5 and ratings>=1),
  primary key(driverID),
  foreign key(vehicleID) references Vehicle(vehicleID)
);

CREATE TABLE `LOCATION` (
  `locationID` integer,
  `houseNo` varchar(5) not null,
  `streetName` varchar(20) not null,
  `pincode` char(6) not null,
  `city` varchar(50) not null,
  `landmark` varchar(50),
   primary key(locationID)
);

CREATE TABLE `TRIP` (
  `tripID` integer,
  `startTime` datetime not null,
  `endTime` datetime not null,
  `distanceCovered` int not null,
  `status` varchar(10) not null default "waiting",
   `share` bool default false,
  `sharingID` int,
  `price` int default 0 not null,
  `typeName` varchar(20) not null,
  `pickupID` int not null,
  `dropID` int not null,
  foreign key(pickupID) references location(locationID),
  foreign key(dropID) references location(locationID),
  foreign key(typeName) references CAB_TYPE(typeName),
  `userID` int not null,
  foreign key(userID) references user(userID),  
  check(price>=0 and distanceCovered>=0),
  check(endTime>startTime),
  Primary key(tripID)  
);

CREATE TABLE `PAYMENT` (
  `tripID` int, 	
  `mode` varchar(20) not null,
  `discountCoupons` char(10),
  `baseAmount` int ,
  `finalAmount` int not null,
  `tipAmount` int default 0,
  `statusOfPayment` boolean not null default false,
  `cancellationCharges` int default 0,
   foreign key(tripID) references Trip(tripID),
   primary key(tripID),
   check(baseAmount<finalAmount and tipAmount<finalAmount)
);

CREATE TABLE `MATCHED` (
  `ratings` int,
  `description` varchar(200),
  `waitingTime` time not null,
  `otp` char(4) not null,
  `tripID` int not null,
  `driverID` int not null,
  foreign key(tripID) references trip(tripID),
  foreign key(driverID) references driver(driverID),
  check(ratings>=1 and ratings<=5),
  primary key(tripID)
);

ALTER TABLE USER RENAME COLUMN password TO pwd;
ALTER TABLE DRIVER RENAME COLUMN password TO pwd;





