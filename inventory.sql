use library;

											-- Inventory Section --

select * from inventory_status;

create table inventory_status
(
InventoryStatusID int not null primary key auto_increment,
status varchar(100) not null
);


select * from inventory_condition;

create table inventory_condition
(
ConditionID int not null primary key auto_increment,
status varchar(100) not null
);


select * from inventory;

create table inventory
(
InventoryID int not null primary key auto_increment,
BookID int not null,
InventoryStatusID int not null,
ConditionID int not null,
foreign key (BookID) references book(BookID),
foreign key (InventoryStatusID) references inventory_status(InventoryStatusID),
foreign key (ConditionID) references inventory_condition(ConditionID)
);


select * from inventory_loan;

create table inventory_loan
(
LoanID int not null primary key auto_increment,
MemberID int not null, 
InventoryID int not null, 
checkout_date date not null, 
due_date date not null,
return_date date null,
days_overdue int default 0,
foreign key (MemberID) references member(MemberID),
foreign key (InventoryID) references inventory(InventoryID)
);


use practice;


select * from inventory_status;

insert into inventory_status(status)
values ('In stock'),
('Loaned'),
('Missing'),
('Reserved');


select * from inventory_condition;

insert into inventory_condition(status)
values ('Excellent'),
('Good'),
('Damaged'),
('Replacement needed');


select * from inventory;

insert into inventory(BookID, InventoryStatusID, ConditionID)
values (1, 1, 1),
(1, 1, 1),
(2, 1, 2),
(2, 1, 2),
(3, 2, 1), 
(3, 1, 2), 
(4, 4, 1),
(4, 1, 3),
(5, 1, 3),
(5, 1, 1),
(6, 1, 2),
(6, 1, 4),
(7, 1, 3),
(7, 1, 2),
(8, 2, 1),
(8, 1, 1),
(9, 1, 1),
(9, 4, 3),
(10, 4, 2),
(10, 3, 2),
(11, 1, 4),
(11, 3, 3),
(12, 2, 2),
(12, 1, 2),
(13, 1, 1),
(13, 1, 1),
(14, 1, 2),
(14, 3, 2),
(15, 2, 2),
(15, 1, 2);