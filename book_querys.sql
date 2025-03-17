use library_3;

-- Get all the books with their Authors
SELECT b.book_name, CONCAT(ba.first_name, ' ', ba.last_name) AS AuthorName
FROM book b
JOIN book_author_classification bac ON b.BookID = bac.BookID
JOIN book_author ba ON bac.AuthorID = ba.AuthorID;

-- Get all books and their Genres
SELECT b.book_name, GROUP_CONCAT(bg.name) AS Genres
FROM book b
JOIN book_genre_classification bgc ON b.BookID = bgc.BookID
JOIN book_genre bg ON bgc.GenreID = bg.GenreID
GROUP BY b.BookID;

-- All Authors and the books they have written
SELECT ba.first_name, ba.last_name, GROUP_CONCAT(b.book_name) AS BooksWritten
FROM book_author ba
JOIN book_author_classification bac ON ba.AuthorID = bac.AuthorID
JOIN book b ON bac.BookID = b.BookID
GROUP BY ba.AuthorID;

-- Find books based on genre (eg Fiction)
SELECT b.book_name, b.ISBN, b.publishing_date
FROM book b
JOIN book_genre_classification bgc ON b.BookID = bgc.BookID
JOIN book_genre bg ON bgc.GenreID = bg.GenreID
WHERE bg.name = 'Fiction';

-- How many books we have in each genre
SELECT bg.name AS Genre, COUNT(b.BookID) AS BookCount
FROM book_genre bg
JOIN book_genre_classification bgc ON bg.GenreID = bgc.GenreID
JOIN book b ON bgc.BookID = b.BookID
GROUP BY bg.GenreID;