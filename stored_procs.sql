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
		m.firstname as 'Name',
        m.lastname as 'Surname',
        m.email as 'Email Address',
        m.birth_date as 'Date of Birth',
        m.registration_date as 'Registration Date',
        s.membership_status as 'Membership Status',
        t.membership_type as 'Membership Type'
    FROM member as m 
    INNER JOIN member_membership_status as s ON m.MembershipStatusID = s.MembershipStatusID -- multi-table join 
    INNER JOIN member_membership_type as t ON m.MembershipTypeID = t.MembershipTypeID -- instead of displaying ID numbers, display the actual membership status and type names.
    order by m.MemberID -- order by the MemberID
    ;

END // -- End the procedure.

DELIMITER ;

-- CALLING THE PROCEDURE --
call AddNewMember('Brandy', 'Harrington', 'isadog@gmail.com', '2011-03-16');
call AddNewMember('Mister', 'Whiskers', 'isacat@gmail.com', '2001-03-16');


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- PROCEDURE 1.2: CANCEL MEMBERSHIP
-- Procedure: CancelMember()

DELIMITER //
CREATE PROCEDURE CancelMember(IN pMemberID INT)
BEGIN
    UPDATE member
    SET MembershipStatusID = 2
    WHERE MemberID = pMemberID;
    
END //

DELIMITER ;

call CancelMember(21);

-- TRIGGER: TRANSFER ROW DATA TO member_cancelled TABLE
DELIMITER //
CREATE TRIGGER TransferCancelledMembers
AFTER UPDATE ON member
FOR EACH ROW
BEGIN
    IF NEW.membershipstatusid = 2 THEN
        INSERT INTO member_cancelled (memberid, firstname, lastname, email, birth_date, registration_date, membershipstatusid, membershiptypeid)
        VALUES (NEW.memberid, NEW.firstname, NEW.lastname, NEW.email, NEW.birth_date, NEW.registration_date, NEW.membershipstatusid, NEW.membershiptypeid);
    END IF;
END //
DELIMITER ;


-- display results --
SELECT m.MemberID as 'Member ID', 
       CONCAT(m.firstname, ' ', m.lastname) as 'Full Name', 
       s.membership_status AS 'Membership Status', 
       m.membershipstatusid as 'Membership Status ID'
FROM member AS m
INNER JOIN member_membership_status AS s ON m.MembershipStatusID = s.MembershipStatusID
WHERE m.membershipstatusid = 2
GROUP BY m.memberid;

SELECT * FROM member_cancelled;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- STORED PROCEDURE 2: ADD A NEW LOANID WHEN A LIBRARY MEMBER CHECKS OUT (LOANS) A BOOK
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


-- TRIGGER: 
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


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- STORED PROCEDURE 3.1: CHECK OVERDUE BOOKS ONLY
-- Procedure: CheckOverdueBooks()

DELIMITER //
CREATE PROCEDURE CheckOverdueBooks()
BEGIN
	SELECT
		l.loanid as 'Loan Number',
		i.inventoryid as 'Inventory Number',
		b.book_name as 'Book Name',
        l.memberid as 'Member Number',
        CONCAT(m.firstname, ' ', m.lastname) as 'Member Name',
        l.checkout_date as 'Checkout Date',
        l.days_overdue as 'Days Overdue'
	FROM inventory_loan as l
    INNER JOIN inventory as i ON i.inventoryid = l.inventoryid
    INNER JOIN book as b ON i.bookid = b.bookid
    INNER JOIN member as m ON m.memberid = l.memberid
    where l.days_overdue > 0; -- only display overdue books.

END //

DELIMITER ;

-- CALLING THE PROCEDURE --
call CheckOverdueBooks();


-- STORED PROCEDURE 3.2: CHECK FULL LIST OF BORROWED BOOKS
-- Function: CheckBorrowedBooks()
DELIMITER //
CREATE PROCEDURE CheckBorrowedBooks()
BEGIN
	SELECT
		l.loanid as 'Loan Number',
		i.inventoryid as 'Inventory Number',
		b.book_name as 'Book Name',
        l.memberid as 'Member Number',
        CONCAT(m.firstname, ' ', m.lastname) as 'Member Name',
        l.checkout_date as 'Checkout Date',
        l.days_overdue as 'Days Overdue'
	FROM inventory_loan as l
    INNER JOIN inventory as i ON i.inventoryid = l.inventoryid
    INNER JOIN book as b ON i.bookid = b.bookid
    INNER JOIN member as m ON m.memberid = l.memberid;

END //
DELIMITER ;

-- CALLING THE PROCEDURE --
call CheckBorrowedBooks()


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- STORED PROCEDURE 4: Get Member Information
-- Procedure: GetMemberInfo()

DELIMITER //
CREATE PROCEDURE GetMemberInfo(IN pMemberID INT)
BEGIN
	SELECT
		m.firstname as 'Name',
        m.lastname as 'Surname',
        m.email as 'Email Address',
        m.birth_date as 'Date of Birth',
        m.registration_date as 'Registration Date',
        s.membership_status as 'Membership Status',
        t.membership_type as 'Membership Type'
    FROM member as m 
    INNER JOIN member_membership_status as s ON m.MembershipStatusID = s.MembershipStatusID
    INNER JOIN member_membership_type as t ON m.MembershipTypeID = t.MembershipTypeID
    where MemberID = pMemberID;

END//

DELIMITER ;

-- CALLING THE PROCEDURE --
call GetMemberInfo(2);


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- STORED PROCEDURE 5: Search book name by genre name.
-- Procedure: SearchBookByGenre()

DELIMITER //
CREATE PROCEDURE SearchBookByGenre2(IN pname varchar(300))
BEGIN
	SELECT
		g.name as 'Genre',
		b.book_name as 'Name of Book'
	FROM book_genre_classification as bg
    INNER JOIN book_genre as g ON bg.GenreID = g.GenreID
    INNER JOIN book as b ON bg.BookID = b.BookID
    where pname = g.name;
    
END //

DELIMITER ;

-- CALLING THE PROCEDURE --
call SearchBookByGenre2('fiction');
call SearchBookByGenre2('Romance');




