use library_group_1b;

create table Membershipstatus(
memberstatusID int not null primary key auto_increment,
membershipstatus varchar(50)
);

insert into Membershipstatus(membershipstatus)
values("Active"),
("Cancelled"),
("Suspended");

select *
from Membershipstatus;