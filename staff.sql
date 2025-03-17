use library_3;

use staff;

select *
from staff_working_hours;

select *
from staff_role;

select *
from staff;

create table staff_working_hours
(
ShiftID int primary key auto_increment,
start_time TIME, 
end_time TIME
);

insert into staff_working_hours(start_time, end_time)
values ('09:00:00', '17:00:00'),
('08:00:00', '18:00:00'),
('11:00:00', '14:00:00'),
('17:00:00', '19:00:00'),
('10:00:00', '16:00:00')
;


create table staff_role
(
RoleID int primary key auto_increment,
role_name TEXT,
role_description TEXT
);

insert into staff_role(role_name, role_description)
values ('Librarian', 'Organising the library''s catalog (books, journals, and other resources). Helping members locate resources and recommend books. Maintaining the library''s resources and condition of books. Managing the loan and return of books by library members.'),
('Admin', 'Handling systems and operations within the library. Scheduling staff shifts, ensuring all staff members are fulfilling their role. Keeping track of library statistics, such as book circulation, member registration, and membership activity. Overseeing library policy and ensuring compliance to guidelines.'),
('Accountant', 'Managing the library''s finances (income, expenses, fines etc.). Ensuring staff salaries, taxes and benefits are processed and distributed on time. Keeping track of member accounts and allocating fines for damaged, lost or overdue books.'),
('Junior Librarian', 'Assist Librarians in their duties.'),
('Cleaner', 'Cleaning communal areas, dusting shelves, and disposing waste.'),
('Receptionist', 'Greet visitors, provide them with necessary information, and direct them to the appropriate sections of the library. Managing front desk, phone calls, emails, and enquiries.'
);



create table staff
(
StaffID int primary key auto_increment,
firstname varchar(50) not null,
lastname varchar(50) not null,
email varchar(200)  not null,
phone_number varchar(15) not null,
start_date DATE not null,
end_date DATE null,
RoleID int,
ShiftID int,
foreign key (RoleID) references staff_role(RoleID),
foreign key (ShiftID) references Staff_working_hours(ShiftID) 
);

insert into staff(firstname, lastname, email, phone_number, start_date)
values ('Miranda', 'Purple', 'fantaandmiranda@gmail.com', '1424214124', "2020-02-01", 1, 1),
('Titi', 'Green', 'glassoftitea@gmail.com', '9986273928', "1999-10-09", 1, 1),
('Nadine', 'Red', 'nadinesardine@gmail.com', '2673528288', "2021-11-13", 1, 1),
('Daliya', 'Yellow', 'daliyatheflower@gmail.com', '6732946863', "2019-09-16", 1, 1),
('Reanna', 'Blue', 'therealrehanna@gmail.com', '3584154421', "2019-01-10", 1, 1),
('Victoria', 'Smith', 'queenv@gmail.com', '4287948267', "2021-10-10", 6, 1),
('Roahl', 'Dahl', 'readmybooks@gmail.com', '5621854475', "2017-04-02", 2, 2),
('Julia', 'Donaldson', 'juliefromtheblock@gmail.com', '4367944164', "2017-09-04", 3, 3),
('Phil', 'Mitchell', 'phillycheesesteak@gmail.com', '4125332323', "2017-10-04",5, 4),
('Grant', 'Mitchell', 'govgrant@gmail.com', '4367828141', "2017-10-04", 4, 5)
;