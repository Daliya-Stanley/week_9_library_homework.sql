use library_5;

-- Member section

select * from member_membership_type;
select * from member_membership_status;
select * from member;

select * from member_genre_preference;

create table member_membership_status
(
MembershipStatusID int not null primary key auto_increment,
membership_status varchar(50) not null
);
-- used the  row 10-13 table on the google sheet. made the column "age_range_max" null
create table member_membership_type
(
MembershipTypeID int not null primary key auto_increment,
membership_type varchar(50) not null,
age_range_min int not null,
age_range_max int null,
loan_duration int not null
);


create table member
(
MemberID int not null primary key auto_increment,
firstname varchar(50) not null,
lastname varchar(100) not null,
email varchar(100) not null,
birth_date date not null,
registration_date date not null,
MembershipStatusID int,
MembershipTypeID int,
foreign key (MembershipStatusID) references member_membership_status(MembershipStatusID),
foreign key (MembershipTypeID) references member_membership_type(MembershipTypeID)
);

-- can't excute it yet cus Daliya is creating the book_genre table
create table member_genre_preference
(
MemberID int not null,
GenreID int not null,
foreign key (MemberID) references member(MemberID),
foreign key (GenreID) references book_genre (GenreID)
);


create table member_cancelled
(
MemberID int,
firstname varchar(50) not null,
lastname varchar(100) not null,
email varchar(100) not null,
birth_date date not null,
registration_date date not null,
cancellation_date date,
MembershipStatusID int,
MembershipTypeID int,
foreign key (MembershipStatusID) references member_membership_status(MembershipStatusID),
foreign key (MembershipTypeID) references member_membership_type(MembershipTypeID)
);



-- adding rows to the table

insert into member_membership_Status (membership_status)
values ('Active'),
('Cancelled'),('Suspended');

insert into member_membership_type (Membership_type, age_range_min, age_range_max, loan_duration)
values ('Adult', 18, null, 14),
('Child', 0, 13, 30), ('Young adult', 14, 17, 14);

insert into member (firstname, lastname, email, birth_date, registration_date, membershipStatusID, MembershipTypeID)
values ('Miranda', 'Childs', 'Miranda@gmail.com', '1992-05-17', '2020-06-11', 1, 1),
('Titi', 'Ejembi','titi@gmail.com', '2017-12-25', '2017-12-03', 1, 2),
('Daliya','Stanley','Daliya@gmail.com', '1967-08-21', '2018-08-10', 1, 1),
('Reanna', 'Gibson', 'Reanna@gmail.com', '1996-07-19', '2022-09-19', 1, 1),
('Nadine', 'Latifah','Nadine@gmail.com', '2001-06-04', '2014-07-30', 1, 1),
('Michael', 'Apple', 'Michael@gmail.com', '1970-08-18', '2011-01-01', 3, 1),
('David', 'Pear', 'David@gmail.com', '2009-02-14', '2015-11-02', 1, 3),
('Allan', 'Orange', 'Allan@gmail.com', '2019-02-27', '2019-03-28', 1, 2),
('Edgar', 'Peach', 'Edgar@gmail.com', '2010-12-05', '2003-06-15', 3, 3),
('Ronald', 'Banana', 'Ronald@gmail.com', '1995-12-25', '2016-02-08', 1, 1)
;

insert into member_genre_preference (MemberID, GenreID)
values (1,3),(2,1),(2,8),(3,1),(4,2),(5,4),(5,6),(6,5),(7,2),(8,1),(8,8),(9,7),(9,4),(10,5),(10,7);