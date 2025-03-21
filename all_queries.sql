USE library_5;

-- Display all of the Members' information and their membership type and status --
SELECT m.MemberID as 'Member ID', m.firstname as 'Name', m.lastname as 'Surname', m.email 'Email Address', DATE_FORMAT(m.birth_date, '%d %M %Y') as 'Date of Birth', 
DATE_FORMAT(m.registration_date, '%d %M %Y') as 'Registration Date', mts.membership_status AS 'Membership Status', mtt.membership_type AS 'Membership Type'
FROM member m
INNER JOIN member_membership_type mtt ON m.MembershipTypeID = mtt.MembershipTypeID
INNER JOIN member_membership_status mts ON m.MembershipStatusID = mts.MembershipStatusID
group by m.MemberID
order by m.MemberID;


-- Display Membership Status Count --
SELECT mts.membership_status, COUNT(m.MemberID) AS 'Member Count'
FROM member m
RIGHT OUTER JOIN member_membership_status mts ON m.MembershipStatusID = mts.MembershipStatusID
GROUP BY mts.membership_status;


-- Display all the Authors and the books they have written --
SELECT ba.firstname, ba.lastname, GROUP_CONCAT(b.book_name) AS 'Books Written'
FROM book_author ba
INNER JOIN book_author_classification bac ON ba.AuthorID = bac.AuthorID
INNER JOIN book b ON bac.BookID = b.BookID
GROUP BY ba.AuthorID;

-- call AddNewBook('9781503292734', 'Sense and Sensibility', '1811-01-01');
-- call AddGenre(16, 'Classic')
-- call AddGenre(16, 'Romance')


-- Counts How Many Books We Have in Each Genre --
SELECT bg.name AS 'Genre', COUNT(b.BookID) AS 'Book Count'
FROM book_genre bg
JOIN book_genre_classification bgc ON bg.GenreID = bgc.GenreID
JOIN book b ON bgc.BookID = b.BookID
GROUP BY bg.GenreID;


-- Display full inventory items with book title, status and condition --
SELECT i.InventoryID as 'Inventory ID', b.book_name as 'Book Title', s.status AS `Inventory Status`, c.status AS `Condition`
FROM inventory i
JOIN book b ON i.BookID = b.BookID
JOIN inventory_status s ON i.InventoryStatusID = s.InventoryStatusID
JOIN inventory_condition c ON i.ConditionID = c.ConditionID
order by inventoryid;


-- Display inventory items that are missing --
SELECT i.InventoryID, b.book_name, s.status AS 'Inventory Status', c.status AS `Condition`
FROM inventory i
JOIN book b ON i.BookID = b.BookID
JOIN inventory_status s ON i.InventoryStatusID = s.InventoryStatusID
JOIN inventory_condition c ON i.ConditionID = c.ConditionID
WHERE s.status = 'Missing';


-- Display all staff information with their job title and working hours --
SELECT s.StaffID as 'Staff ID',
       s.firstname as 'Name', 
       s.lastname as 'Surname', 
       s.email as 'Email Address', 
       s.phone_number as 'Phone Number', 
       DATE_FORMAT(s.start_date, '%d %M %Y') as 'Start Date', 
       r.role_name AS 'Job Title', 
       r.role_description AS 'Job Description', 
       TIME_FORMAT(wh.start_time, '%H:%i') AS 'Shift Start', 
       TIME_FORMAT(wh.end_time, '%H:%i') AS 'Shift End'
FROM staff s
JOIN staff_role r ON s.RoleID = r.RoleID
JOIN staff_working_hours wh ON s.ShiftID = wh.ShiftID;


-- Group by staff type and their assigned shift hours and head count --
SELECT r.role_name AS Role, 
       COUNT(s.StaffID) AS 'Number of Staff', 
       TIME_FORMAT(wh.start_time, '%H:%i') AS 'Shift Start', 
       TIME_FORMAT(wh.end_time, '%H:%i') AS 'Shift End'
FROM staff s
JOIN staff_role r ON s.RoleID = r.RoleID
JOIN staff_working_hours wh ON s.ShiftID = wh.ShiftID
GROUP BY r.role_name, wh.start_time, wh.end_time;



-- Other Queries --

-- Get inventory items by status (in stock)
-- SELECT i.InventoryID, b.book_name, s.status AS 'Inventory Status', c.status AS `Condition`
-- FROM inventory i
-- JOIN book b ON i.BookID = b.BookID
-- JOIN inventory_status s ON i.InventoryStatusID = s.InventoryStatusID
-- JOIN inventory_condition c ON i.ConditionID = c.ConditionID
-- WHERE s.status = 'In stock';


-- Find members with a specific membership type (this example is adult)
-- SELECT m.firstname, m.lastname, m.email, m.birth_date, m.registration_date
-- FROM member m
-- JOIN member_membership_type mmt ON m.MembershipTypeID = mmt.MembershipTypeID
-- WHERE mmt.membership_type = 'Adult';

-- Get all the books with their Authors
-- SELECT 
-- 	b.book_name AS 'Book Name', 
-- 	CONCAT(ba.firstname, ' ', ba.lastname) AS 'Author Name'
-- FROM book as b
-- INNER JOIN book_author_classification as bac ON b.BookID = bac.BookID
-- INNER JOIN book_author as ba ON bac.AuthorID = ba.AuthorID;


-- Get all books and their Genres
-- SELECT b.book_name, GROUP_CONCAT(bg.name) AS 'Genres'
-- FROM book b
-- INNER JOIN book_genre_classification bgc ON b.BookID = bgc.BookID
-- INNER JOIN book_genre bg ON bgc.GenreID = bg.GenreID
-- GROUP BY b.BookID;


-- Find books based on genre (eg Fiction)
-- SELECT b.book_name, b.ISBN, b.publishing_date
-- FROM book b
-- INNER JOIN book_genre_classification bgc ON b.BookID = bgc.BookID
-- INNER JOIN book_genre bg ON bgc.GenreID = bg.GenreID
-- WHERE bg.name = 'Fiction';