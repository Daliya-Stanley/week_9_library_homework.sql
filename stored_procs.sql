use library_3;

-- STORED PROCEDURE 1.1: ADD A NEW LIBRARY MEMBER
-- Function: AddNewMember()

-- INTUITION BEHIND THIS PROCEDURE:
-- When a new member joins the Library, their personal details must be recorded in the Library Database 
-- (new MemberID, firstname, lastname, email address etc.)
-- Whe the user (Librarian) calls this procedure, a new row of data is inserted in 'member' table.
-- However, the Librarian must also assign a membership type for this new member.
-- The membership type is assigned to a member based on their age. 
-- In 'member' table, we have the 'birth_date' column but not a column for their age.
-- Therefore, we must create variables in this procedure to calculate the member's age and automatically insert the correct 
-- MembershipTypeID in 'member' table.

-- We first redefine the Delimiter for this procedure as '//' to overwrite the default delimiter ';'
-- Essentially, we are telling mySQL to run all the statements within this procedure as ONE BLOCK OF CODE, rather than individual statements.
DELIMITER //

-- Create proc using syntax: CREATE PROCEDURE procedure_name(parameters) --
-- We establish 'IN' parameters to allow the Librarian to input values INTO the procedure.
-- When we add a new member, we want to add to the database their: firstname, lastname, email address and date of birth.
-- For other columns: registration_date, MembershipStatusID, MembershipTypeID, we want the procedure to automate this process for us,
-- and therefore, is not included as parameters.
-- Parameter names are prefixed with 'p' like pFirstname to indicate that it is a parameter for firstname column values.
CREATE PROCEDURE AddNewMember(
IN pFirstname varchar(50),
IN pLastname varchar(100),
IN pEmail varchar(300),
IN pBirthdate date
)


BEGIN -- begin the procedure.
-- 1. Create variables for Age and Membership type using the DECLARE statement -- 

-- Why are Age and Membershiptype variables?
-- REASON: We want to determine the member's membership type based on their age.
-- 		   Since we don't have an Age column, we have to calculate their age by subtracting their date of birth from the current day their membership is created.
-- 		   Membership type as a variable because we want to be able to fetch the correct MembershipTypeID based on the age we calculated.
	DECLARE vAge INT; 		
    DECLARE vMembershiptype INT;    
    
-- 2. Calculate the member's age using DATEDIFF(), and store this value in vAge --
-- The DATEDIFF(date 1, date 2) function calculates the difference between date 1 and date 2 and returns an integer day.
-- Example: if DATEDIFF('2000-01-10', '2000-01-20'), then the difference would be 10 (days).
-- CURRENT_DATE() is a function that retrieves the current date (today is 16th March 2025: '2025-03-16').
-- This calculates the member's age based on the number of days between their birth date, and today's date, divided by 365 days (to find the age is years).
    SET vAge = DATEDIFF(CURRENT_DATE(), pBirthdate)/365;
    
-- SELECT INTO statement retrieves the MembershipTypeID from the 'member_membership_type' table and stores it into variable 'vMembershiptype'.
    SELECT MembershipTypeID INTO vMembershiptype
	FROM member_membership_type
    WHERE vAge BETWEEN age_range_min AND IFNULL(age_range_max, vAge);
-- WHERE condition clarifies that the MembershipTypeID we want to retrieve is one where the vAge is between the minimum and maximum age range
-- indicated in the age_range_min and age_range_max column.

--                                       --------------------------------------------------------------------------------------
-- Example: 		 if vAge = 15,       | MembershipTypeID | membership_type | age_range_min | age_range_max | loan_duration |   
-- 		then   age_range_min = 14,       --------------------------------------------------------------------------------------
-- 			   age_range_max = 17,       |        1         |      Adult      |      18       |      null     |      14       |
--                                       --------------------------------------------------------------------------------------
--                                       |        2         |      Child      |       0       |       13      |      30       |
--                                       --------------------------------------------------------------------------------------
--                                       |        3         |   Young Adult   |      14       |       17      |      14       |
--                                       --------------------------------------------------------------------------------------

-- then this person is a 'Young 'Adult' and their MembershipTypeID = 3.
    
	-- 3. INSERT values into the 'member' table --
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
    pFirstname,  -- The parameter values are the ones which the Librarian inputted when the called the procedure.
    pLastname,
    pEmail,
    pBirthdate,
    CURRENT_DATE(), -- registration_date is set as today's date.
    1,				-- MembershipStatusID is set as 1 (Active) by default.
    vMembershiptype
    );
    
-- SELECT statement selects the columns and values we want to see when this procedure is called --
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



-- PROCEDURE 1.2: CANCEL MEMBERSHIP

DELIMITER //
CREATE PROCEDURE pCancelMember(IN pMemberID INT)
BEGIN
    UPDATE member
    SET MembershipStatusID = 2
    WHERE MemberID = pMemberID;
    
END //

DELIMITER ;

call pCancelMember(2);
select * from member;

-- EVENT: REMOVE ROW OF CANCELLED MEMBERSHIP
select * from member;

DELIMITER //
CREATE EVENT eRemoveCancelledMembers 
ON SCHEDULE EVERY 1 SECOND
STARTS CURRENT_TIMESTAMP() + INTERVAL 10 SECOND
	DO
		DELETE FROM member WHERE MembershipStatusID = 2;
END //

DELIMITER ;

call eRemoveCancelledMembers;

update member
set MembershipStatusID = 1 where memberid = 1;
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- STORED PROCEDURE 2: ADD A NEW LOANID WHEN A LIBRARY MEMBER CHECKS OUT (LOANS) A BOOK
-- Function: AddNewLoan()

-- INTUITION BEHIND THIS PROCEDURE:
-- The AddNewLoan() procedure inserts a new row on the inventory_loan table with a new LoanID, checkout date, due date etc.

DELIMITER //

CREATE PROCEDURE AddNewLoan(
    IN pMemberID INT,     -- MemberID and InventoryID are parameters
    IN pInventoryID INT   -- when a book is checked out we want the member's ID and Inventory's ID.
)
BEGIN
    DECLARE vMembershipType INT;     -- variable to store the member's MembershipTypeID
    DECLARE vLoanDuration INT;       -- variable to store the loan_duration
    DECLARE vDueDate DATE;           -- variable to store the due date after calculation

    SELECT MembershipTypeID INTO vMembershipType  -- fetch the MembershipTypeID
    FROM member
    WHERE MemberID = pMemberID;  -- based on the MemberID inputted in the parameter pMemberID

    SELECT loan_duration INTO vLoanDuration -- fetch the loan duration from loan_duration column
    FROM member_membership_type
    WHERE MembershipTypeID = vMembershipType; -- based on the member's membership type
	
    -- calculate the due date by adding an interval of vLoanDuration days to the checkout date (today's date). 
    -- example: if the member is a child, this would be DATE_ADD(current_date(), interval 30 day)
    SET vDueDate = DATE_ADD(CURRENT_DATE(), INTERVAL vLoanDuration DAY);

	-- insert values into the inventory_loan table --
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


SELECT * from inventory_loan;
SELECT * from inventory;

-- TRIGGER: AUTOMATICALLY UPDATE THE INVENTORYSTATUSID COLUMN IN INVENTORY TABLE TO 2 = LOANED

-- INTUITION BEHIND THE TRIGGER: 
-- When a Library member checks out a book to loan (borrow), a Librarian may want to record this new loan on the database. 
-- They record this by calling the AddNewLoan() procedure.

-- Recall the inventory_status and inventory table:

--     -----------------------------------------         ----------------------------------------------------------
--     | InventoryStatusID |       status      |         | InventoryID | BookID | InventoryStatusID | ConditionID |
-- 	   -----------------------------------------         ----------------------------------------------------------
-- 	   |         1         |      In Stock     |         |  --> 1      |    1   |     --> 1         |      1      |
--     -----------------------------------------         ----------------------------------------------------------
--     |         2         |      Loaned       |         |      2      |    1   |         1         |      3      |
--     -----------------------------------------         ----------------------------------------------------------
--     |         3         |      Missing      |         if InventoryID = 1 is checked out, then InventoryStatusID = 2 (loaned).
--     -----------------------------------------         however, InventoryStatusID is stil 1 (in stock).
--     |         4         |Replacement needed |
--     -----------------------------------------

-- Although AddNewLoan() records a new row in 'inventory_loan' table, the InventoryStatusID in 'inventory' table
-- has not reflected this change. It remains '1' (In stock).
-- Therefore, this trigger is implemented to automatically set the InventoryStatus to '2' (for 'Loaned') when AddNewLoan() is called.

-- This is what we want:
--                           ----------------------------------------------------------
--                           | InventoryID | BookID | InventoryStatusID | ConditionID |
--                           ----------------------------------------------------------
--                           |      1      |    1   |     --> 2         |      1      |
--                           ----------------------------------------------------------
--                           |      2      |    1   |         1         |      3      |
--                           ----------------------------------------------------------


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
-- Function: CheckOverdueBooks()
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
-- Function: GetMemberInfo()

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
-- Function: SearchBookByGenre()

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



