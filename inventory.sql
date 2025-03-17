use library_5;

											-- Inventory Section --

select * from inventory_status;
select * from inventory_condition;
select * from inventory;
select * from inventory_loan;
select * from inventory_overdue_notification;

create table inventory_status
(
InventoryStatusID int not null primary key auto_increment,
status varchar(100) not null
);


create table inventory_condition
(
ConditionID int not null primary key auto_increment,
status varchar(100) not null
);


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



create table inventory_overdue_notification(
NotificationID int not null primary key auto_increment,
LoanID int not null,
notification_date date,
foreign key (LoanID) references inventory_loan(LoanID)
);


insert into inventory_status(status)
values ('In stock'),
('Loaned'),
('Missing'),
('Reserved');


insert into inventory_condition(status)
values ('Excellent'),
('Good'),
('Damaged'),
('Replacement needed');


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


insert into inventory_loan(MemberID, InventoryID, checkout_date, due_date, return_date, days_overdue)
values (1, 5, '2025-02-14', date_add('2025-02-14', interval 14 day), null, datediff(current_date(), date_add('2025-02-14', interval 14 day))),
(4, 15, '2025-02-21', date_add('2025-02-21', interval 14 day), null, datediff(current_date(), date_add('2025-02-21', interval 14 day))),
(5, 23, '2025-02-15', date_add('2025-02-15', interval 14 day), null, datediff(current_date(), date_add('2025-02-15', interval 14 day))),
(2, 29, '2025-02-09', date_add('2025-02-09', interval 30 day), null, datediff(current_date(), date_add('2025-02-09', interval 30 day))
);


insert into inventory_overdue_notification(LoanID, notification_date)
values (1, date_add('2025-02-14', interval 1 day)),
(2, date_add('2025-02-21', interval 1 day)),
(3, date_add('2025-02-15', interval 1 day)),
(4, date_add('2025-02-09', interval 1 day)),
(1, date_add('2025-02-14', interval 8 day)),
(3, date_add('2025-02-15', interval 8 day)
);

