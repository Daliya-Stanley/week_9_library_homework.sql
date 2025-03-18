-- IF YOU WOULD LIKE TO RUN ANY PROCEDURE PLEASE USE LIBRARY_3 DATABASE --
USE library_3;


-- STORED PROCEDURE 1: ADD A NEW LIBRARY MEMBER
-- Procedure: AddNewMember()

DELIMITER //
CREATE PROCEDURE AddNewMember(
IN pFirstname varchar(50),
IN pLastname varchar(100),
IN pEmail varchar(300),
IN pBirthdate date
)
BEGIN
	DECLARE vAge INT; 		
    DECLARE vMembershiptype INT;
    
    -- calculate the member's age by calculating the number of days between today's date and their date of birth --
    SET vAge = DATEDIFF(CURRENT_DATE(), pBirthdate)/365;
    
	-- SELECT INTO statement retrieves the MembershipTypeID from the 'member_membership_type' table and stores it into variable 'vMembershiptype'--
    SELECT MembershipTypeID INTO vMembershiptype
	FROM member_membership_type
    WHERE vAge BETWEEN age_range_min AND IFNULL(age_range_max, vAge);
    
    -- DML insert values into the table row --
	INSERT INTO member(
    firstname,
    lastname,
    email,
    birth_date,
    registration_date,
    MembershipStatusID,
    MembershipTypeID
    )
    VALUES(
    pFirstname,
    pLastname,
    pEmail,
    pBirthdate,
    CURRENT_DATE(), -- registration_date is set as today's date.
    1, -- MembershipStatusID = 1 (Active) by default.
    vMembershiptype -- int value stored in variable.
    );
    
	-- SELECT statement selects the columns and values the librarian wants displayed when this procedure is called --
    SELECT
		CONCAT(m.firstname, ' ', m.lastname) as 'Member Name',
        m.email as 'Email Address',
        DATE_FORMAT(m.birth_date, '%d %M %Y') as 'Date of Birth',
        DATE_FORMAT(m.registration_date, '%d %M %Y') as 'Registration Date',
        s.membership_status as 'Membership Status',
        t.membership_type as 'Membership Type'
    FROM member as m 
    INNER JOIN member_membership_status as s ON m.MembershipStatusID = s.MembershipStatusID -- multi-table join 
    INNER JOIN member_membership_type as t ON m.MembershipTypeID = t.MembershipTypeID -- instead of displaying ID numbers, display the actual membership status and type names.
    order by m.registration_date -- order by the registration date
    ;

END // -- End the procedure.

DELIMITER ;

-- CALLING THE PROCEDURE --
call AddNewMember('Brandy', 'Harrington', 'isadog@gmail.com', '2001-04-30');
call AddNewMember('Mister', 'Whiskers', 'isacat@gmail.com', '2021-03-19');
call AddNewMember('Peppa', 'Pig', 'missbacon@gmail.com', '2018-11-28');
call AddNewMember('Spongebob', 'SquarePants', 'ss@gkrustykrab.com', '1992-10-17');
call AddNewMember('Patrick', 'Star', 'starfishin@bikinibottom.com', '1992-06-21');


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- PROCEDURE 2: CANCEL MEMBERSHIP
-- Procedure: CancelMember()

DELIMITER //
CREATE PROCEDURE CancelMember(IN pMemberID INT)
BEGIN
    UPDATE member
    SET MembershipStatusID = 2
    WHERE MemberID = pMemberID;
    
    SELECT
		m.memberid as 'Member ID',
        CONCAT(m.firstname, ' ', m.lastname) as 'Member Name',
        m.email as 'Email Address',
        DATE_FORMAT(m.birth_date, '%d %M %Y') as 'Date of Birth',
        DATE_FORMAT(m.registration_date, '%d %M %Y') as 'Registration Date',
        s.membership_status as 'Membership Status',
        t.membership_type as 'Membership Type'
	FROM member as m INNER JOIN member_membership_status as s ON s.membershipstatusid = m.membershipstatusid
    INNER JOIN member_membership_type as t ON m.membershiptypeid = t.membershiptypeid
    order by m.registration_date;
    
END //

DELIMITER ;

call CancelMember(1);


-- TRIGGER: TRANSFER ROW DATA TO member_cancelled TABLE -- run this first!
DELIMITER //
CREATE TRIGGER TransferCancelledMembers
AFTER UPDATE ON member
FOR EACH ROW
BEGIN
    IF NEW.membershipstatusid = 2 THEN
        INSERT INTO member_cancelled (memberid, firstname, lastname, email, birth_date, registration_date, cancellation_date, membershipstatusid, membershiptypeid)
        VALUES (NEW.memberid, NEW.firstname, NEW.lastname, NEW.email, NEW.birth_date, NEW.registration_date, current_date(), NEW.membershipstatusid, NEW.membershiptypeid);
    END IF;
END //
DELIMITER ;


-- VIEW: MEMBER_CANCELLATION TABLE --
CREATE VIEW ViewCancelledMembers AS
SELECT
	mc.memberid as 'Member ID',
	mc.firstname as 'First Name', 
    mc.lastname as 'Surname',
	mc.email as 'Email Address',
	DATE_FORMAT(mc.birth_date, '%d %M %Y') as 'Date of Birth',
	DATE_FORMAT(mc.registration_date, '%d %M %Y') as 'Registration Date',
	DATE_FORMAT(mc.cancellation_date, '%d %M %Y') as 'Cancellation Date',
	s.membership_status as 'Membership Status',
	t.membership_type as 'Membership Type'
FROM member_cancelled as mc INNER JOIN member_membership_status as s ON s.membershipstatusid = mc.membershipstatusid
INNER JOIN member_membership_type as t ON mc.membershiptypeid = t.membershiptypeid
order by mc.registration_date;

select * from viewcancelledmembers;


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- STORED PROCEDURE 2: ADD A NEW LOAN ID WHEN A LIBRARY MEMBER CHECKS OUT (LOANS) A BOOK
-- Procedure: AddNewLoan()

DELIMITER //

CREATE PROCEDURE AddNewLoan(
    IN pMemberID INT,     -- MemberID and InventoryID are parameters
    IN pInventoryID INT   -- when a book is checked out we want the member's ID and Inventory's ID.
)
BEGIN
    DECLARE vMembershipType INT;     -- variable to store the member's MembershipTypeID
    DECLARE vLoanDuration INT;       -- variable to store the loan_duration
    DECLARE vDueDate DATE;           -- variable to store the due date after calculation

    SELECT MembershipTypeID INTO vMembershipType  
    FROM member
    WHERE MemberID = pMemberID; 

    SELECT loan_duration INTO vLoanDuration
    FROM member_membership_type
    WHERE MembershipTypeID = vMembershipType; 

    SET vDueDate = DATE_ADD(CURRENT_DATE(), INTERVAL vLoanDuration DAY);

    INSERT INTO inventory_loan(
        MemberID,
        InventoryID,
        checkout_date,
        due_date,
        return_date,
        days_overdue
    )
    VALUES (
        pMemberID,
        pInventoryID,
        CURRENT_DATE(), -- set the checkout_date to today's date
        vDueDate, -- calculated due date
        NULL, -- return_date set to 'null' (they have not returned the book)
        0     -- days overdue set to 0.
    );
    
END //

-- CALLING THE PROCEDURE --
call AddNewLoan(2, 14); -- child
call AddNewLoan(5, 10) -- adult


-- TRIGGER: UPDATE INVENTORYSTATUSID = 2 (LOANED) FOR INVENTORY TABLE --
DELIMITER //
CREATE TRIGGER UpdateInventoryStatus
AFTER INSERT ON inventory_loan
FOR EACH ROW
BEGIN
	UPDATE inventory
    SET InventoryStatusID = 2
    WHERE InventoryID = NEW.InventoryID;

END //
DELIMITER ;

-- EVENT: UPDATE DAYS_OVERDUE BY + 1 EVERY DAY FOR ALL THE UNRETURNED BOOKS --
DELIMITER //
CREATE EVENT UpdateDaysOverdue
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    UPDATE inventory_loan
    SET days_overdue = days_overdue + 1  -- increment days overdue by 1 each day
    WHERE return_date IS NULL AND due_date < CURRENT_DATE();
END //
DELIMITER ;

SELECT * FROM viewborrowedbooks;
SELECT * FROM ViewOverdueBooks;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- VIEW: OVERDUE BOOKS ONLY
-- VIEW: ViewOverdueBooks

CREATE VIEW ViewOverdueBooks AS
SELECT
	i.inventoryid as 'Inventory ID',
	b.book_name as 'Book Title',
	CONCAT(m.firstname, ' ', m.lastname) as 'Borrower Name',
	l.memberid as 'Borrower ID',
	DATE_FORMAT(l.checkout_date, '%d %M %Y') as 'Checkout Date',
	DATE_FORMAT(l.due_date, '%d %M %Y') as 'Due Date',
	l.days_overdue as 'Days Overdue'
FROM inventory_loan as l
INNER JOIN inventory as i ON i.inventoryid = l.inventoryid
INNER JOIN book as b ON i.bookid = b.bookid
INNER JOIN member as m ON m.memberid = l.memberid
where l.days_overdue > 0; -- only display overdue books.


-- SELECT VIEW --
SELECT * FROM ViewOverdueBooks;



-- VIEW: FULL LIST OF BORROWED BOOKS
-- view: ViewBorrowedBooks()
CREATE VIEW ViewBorrowedBooks AS
SELECT
	i.inventoryid as 'Inventory ID',
	b.book_name as 'Book Title',
	CONCAT(m.firstname, ' ', m.lastname) as 'Borrower Name',
	l.memberid as 'Borrower ID',
	DATE_FORMAT(l.checkout_date, '%d %M %Y') as 'Checkout Date',
	DATE_FORMAT(l.due_date, '%d %M %Y') as 'Due Date',
	l.days_overdue as 'Days Overdue'
FROM inventory_loan as l
INNER JOIN inventory as i ON i.inventoryid = l.inventoryid
INNER JOIN book as b ON i.bookid = b.bookid
INNER JOIN member as m ON m.memberid = l.memberid;


-- SELECT VIEW --
SELECT * FROM viewborrowedbooks;


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- STORED PROCEDURE 3: Get Member Information
-- Procedure: GetMemberInfo()

DELIMITER //
CREATE PROCEDURE GetMemberInfo(IN pMemberID INT)
BEGIN
	SELECT
		m.firstname as 'Name',
        m.lastname as 'Surname',
        m.email as 'Email Address',
        DATE_FORMAT(m.birth_date, '%d %M %Y') as 'Date of Birth',
        DATE_FORMAT(m.registration_date, '%d %M %Y') as 'Registration Date',
        s.membership_status as 'Membership Status',
        t.membership_type as 'Membership Type',
        GROUP_CONCAT(g.name) as 'Favourite Genres'
    FROM member as m 
    INNER JOIN member_membership_status as s ON m.MembershipStatusID = s.MembershipStatusID
    INNER JOIN member_membership_type as t ON m.MembershipTypeID = t.MembershipTypeID
    INNER JOIN member_genre_preference as mg ON m.MemberID = mg.MemberID
    INNER JOIN book_genre as g ON mg.genreid = g.genreid
    where m.MemberID = pMemberID
    group by m.MemberID;

END//
DELIMITER ;

-- CALLING THE PROCEDURE --
call GetMemberInfo(1);


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- STORED PROCEDURE 4: Search Book by inputting Genre Name.
-- Procedure: SearchBookByGenre()

DELIMITER //
CREATE PROCEDURE SearchBookByGenre(IN pName varchar(300))
BEGIN
	SELECT
		g.name as 'Genre',
		b.book_name as 'Book Title',
        concat(ba.firstname, ' ', ba.lastname) as 'Author Name'
    FROM book_genre_classification AS bg
    INNER JOIN book_genre AS g ON bg.GenreID = g.GenreID
    INNER JOIN book AS b ON bg.BookID = b.BookID
    INNER JOIN book_author_classification AS bac ON bac.BookID = b.BookID
    INNER JOIN book_author AS ba ON ba.AuthorID = bac.AuthorID
    WHERE pName = g.name;
    
END //
DELIMITER ;

-- CALLING THE PROCEDURE --
call SearchBookByGenre('fiction');
call SearchBookByGenre('Romance');


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- STORED PROCEDURE 5: ADD A NEW BOOK TO THE DATABASE
DELIMITER //
CREATE PROCEDURE AddNewBook(
IN pbook_isbn VARCHAR(50),
IN pbook_name VARCHAR(300),
IN ppublishing_date DATE,
IN pauthor_firstname varchar(50),
IN pauthor_lastname varchar(100)
)
BEGIN
	DECLARE vbookid INT; 
    DECLARE vauthorid INT; 
    
    -- add new book by inserting a new row in book table --
    INSERT INTO book(ISBN, book_name, publishing_date)
    VALUES (pbook_isbn, pbook_name, ppublishing_date);
    
    -- set the BookID variable as the ID which was last inserted --
    SET vbookid = LAST_INSERT_ID();
    
    -- check if the author exists by selecting 1 record from the table with the condition --
	IF EXISTS (SELECT 1 FROM book_author 
		WHERE firstname = pauthor_firstname AND lastname = pauthor_lastname)
        
        -- if it exists, then store the AuthorID into vauthorid variable --
        THEN SELECT authorid INTO vauthorid 
        FROM book_author 
        WHERE firstname = pauthor_firstname AND lastname = pauthor_lastname;
	ELSE
		-- if it does not exist, add new row in book_author table and insert the inputted values --
		INSERT INTO book_author(firstname, lastname)
		VALUES(pauthor_firstname, pauthor_lastname);
        -- then set the vauthorid as the last ID insert --
        SET vauthorid = LAST_INSERT_ID();
    
    END IF;
    -- insert into book author classification bridge table the values for BookID and AuthorID.
    INSERT INTO book_author_classification(bookid, authorid)
    VALUES(vbookid, vauthorid);
    
END //
DELIMITER ;

call AddNewBook('‎9780060935467', 'To Kill a Mockingbird', '1960-07-11', 'Harper', 'Lee');

select * from book;
select * from book_author;
select * from book_author_classification;
select * from book_genre_classification;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- STORED PROCEDURE 6: ADD GENRE 
DELIMITER //
CREATE PROCEDURE AddGenre(IN pBookID int, IN pGenreName varchar(100))
BEGIN
	DECLARE vgenreid int;
    
    SELECT GenreID INTO vgenreid FROM book_genre 
    WHERE name = pGenreName;
    
	INSERT INTO book_genre_classification(bookid, genreid)
    VALUES (pBookID, vgenreid);
END//
DELIMITER ;

call AddGenre(1, 'Politics'); -- 1984
call AddGenre(17, 'Classic'); -- to kill a mockingbird
call AddGenre(17, 'Fiction');

select * from ViewBookGenres;

CREATE VIEW ViewBookGenres AS
SELECT b.book_name, GROUP_CONCAT(bg.name) AS 'Genres'
FROM book b
INNER JOIN book_genre_classification bgc ON b.BookID = bgc.BookID
INNER JOIN book_genre bg ON bgc.GenreID = bg.GenreID
GROUP BY b.BookID;



