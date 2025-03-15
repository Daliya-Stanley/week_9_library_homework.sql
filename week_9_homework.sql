create database library_group_1b;

create table Colours
(
ColourID int not null primary key auto_increment,
Name varchar(50)
);

insert into colour(name)
values ('Green'),
('Grey'),
('Red');

select *
from colour;
