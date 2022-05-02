use ula;
drop TABLE if exists USER_OLD_DATA ;
 CREATE TABLE `USER_OLD_DATA` (
  `userID` integer,
  `name` varchar (20) not null,
  `phoneNo` char (10) not null,
  `age` int,
  `gender` varchar(1),
  primary key(userID),
  check(age>0)
);

drop TABLE if exists USER_NEW_DATA ;
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

drop table if exists payments_info;
create table payments_info
 (payment_id INT NOT NULL AUTO_INCREMENT, 
 last_name VARCHAR (30) NOT NULL, 
 first_name VARCHAR (25),
 created_date DATE, 
 created_by VARCHAR(30),
 primary key(payment_id)); 
                            
                            
drop table if exists payments_audit;                           
create table payments_audit (contact_id integer, 
                             created_date date, 
                             created_by varchar (30));
                             
                             
drop table if exists vehile_discarded;
CREATE TABLE `VEHILE_DISCARDED`( vehicleID int ,
model varchar(20) ,
fuelType varchar(20) ,
color varchar(20) ,
typeName varchar(20))  ;              




DROP TRIGGER if exists user_BEFORE_UPDATE
delimiter //
CREATE TRIGGER user_BEFORE_UPDATE BEFORE UPDATE ON user FOR EACH ROW 
BEGIN
insert into USER_OLD_DATA values (old.UserID, old.name, old.phoneNo, old.age, old.gender);
END; //
DELIMITER ;

DROP TRIGGER if exists user_AFTER_UPDATE
delimiter //
CREATE TRIGGER user_AFTER_UPDATE AFTER UPDATE ON user FOR EACH ROW 
BEGIN
insert into USER_NEW_DATA values (old.UserID, old.name, old.phoneNo, old.age, old.gender,"Your details have been updated !" );
END; //
DELIMITER ;


DROP TRIGGER if exists payment_AFTER_INSERT
delimiter //
CREATE TRIGGER payment_AFTER_INSERT AFTER INSERT ON payment FOR EACH ROW BEGIN
DECLARE vUser varchar(50);
             SELECT USER() into vUser;
            
             INSERT into contacts_audit
             ( contact_id,
             created_date,
               created_by)
            VALUES
             ( NEW.tripID,
             SYSDATE(),
           vUser );
END; //
DELIMITER ;

DROP TRIGGER if exists vehicle_BEFORE_DELETE
delimiter //
CREATE TRIGGER vehicle_BEFORE_DELETE BEFORE DELETE ON vehicle FOR EACH ROW BEGIN
insert into VEHILE_DISCARDED values (old.vehicleID, old.model, old.fuelType, old.color, old.typeName);
END; //
DELIMITER ;

delimiter //
CREATE TRIGGER vehicle_BEFORE_DELETE BEFORE DELETE ON vehicle FOR EACH ROW BEGIN
insert into VEHILE_DISCARDED values (old.vehicleID, old.model, old.fuelType, old.color, old.typeName);
END; //
DELIMITER ;







