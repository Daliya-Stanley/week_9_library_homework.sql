use library_3;

select * from book_genre;
select * from book;
select * from book_author;
select * from book_author_classification;
select * from book_genre_classification;

create table book_genre (
GenreID int not null primary key auto_increment, 
name varchar(100)
);


create table book_author(
AuthorID int not null primary key auto_increment,
first_name varchar(100),
last_name varchar(150)
);


create table Book (
BookID int not null primary key auto_increment,
ISBN varchar(50) not null,
book_name varchar(300) not null,
publishing_date date not null);

create table book_author_classification(
BookID int,
AuthorID int,
primary key(BookID, AuthorID)
);

create table book_genre_classification(
BookID int,
GenreID int,
primary key(BookID, GenreID)
);


insert into book_genre(name)
values("Fiction"),
("Non-Fiction"),
("Romance"),
("Dystopian"),
("Classic"),
("Politics"),
("Thriller"),
("Children's Literature");

select *
from book_genre;

insert into book_author(first_name, last_name)
values ("Jane" , "Austen"),
("Ray","Bradybury"),
("Dan","Brown"),
("Francis","Fitzgerald"),
("Anthony","Bourdain"),
("Leonie","Mack"),
("Stephen","King"),
("Naomi","Klein"),
("Niccolò","Machiavelli"),
("George","Martin"),
("George","Orwell"),
("Joanne","Rowling"),
("Jerome","Sallinger"),
("John","Tolkien"),
("Alice","Walker");


select *
from book_author;
insert into Book (ISBN, book_name, publishing_date)
values("9780451524935","1984", "1949-06-08"),
("9780743273565", "The Great Gatsby", "1925-04-10"),
("9780141439518", "Pride and Prejudice", "1813-01-28"),
("9780316769488","The Catcher in the Rye","1951-07-16"),
("9780743247221","Fahrenheit 451","1953-10-19"),
("9780307743657","The Shining","1977-01-28"),
("9780747532699","Harry Potter and the Philosopher's Stone","1997-06-26"),
("‎9780544003415","The Lord of the Rings","1954-07-29"),
("9780553593716","A Game of Thrones","1996-08-01"),
("9780140441079","The Prince","1532-01-01"),
("9780141024530","The Shock Doctrine","2007-09-04"),
("9780307474278","The Da Vinci Code","2003-04-01"),
("‎9781836033462","In Italy For Love","2024-10-22"),
("9780739304808","A Chef's Christmas","2002-11-12"),
("‎9781780228716","The Colour Purple","1982-06-01");

select *
from Book;

insert book_author_classification(BookID, AuthorID)
values(1, 11),
(2,4),
(3,1),
(4,13),
(5,2),
(6,10),
(7,12),
(8,14),
(9,10),
(10,9),
(11,8),
(12,3),
(13,6),
(14,5),
(15,15);

select *
from book_author_classification;

insert book_genre_classification(BookID, GenreID)
values(1, 1),
(1,4),
(2,3),
(2,4),
(3,3),
(3,5),
(4,1),
(4,5),
(5,1),
(5,4),
(6,1),
(6,7),
(7,1),
(7,8),
(8,1),
(8,8),
(9,1),
(10,2),
(10,6),
(11,2),
(11,6),
(12,1),
(12,7),
(13,1),
(13,3),
(14,2),
(15,1),
(15,5);