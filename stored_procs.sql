use library_3;

-- STORED PROCEDURES --


-- STORED PROCEDURE 1: Add a new library member to the member table.
-- Function: AddNewMember()

DELIMITER //

CREATE PROCEDURE AddNewMember(
IN pFirstname varchar(50),
IN pLastname varchar(100),
IN pEmail varchar(300),
IN pBirthdate date
)

BEGIN
-- declare a variable will create a variable -- 
	DECLARE vAge INT;
    DECLARE vMembershiptype INT;
    
-- calculate the age of the member --
    SET vAge = DATEDIFF(CURRENT_DATE(), pBirthdate)/365;
    
    SELECT MembershipTypeID INTO vMembershiptype
	FROM member_membership_type
    WHERE vAge BETWEEN age_range_min AND IFNULL(age_range_max, vAge);
    
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
    CURRENT_DATE(),
    1,
    vMembershiptype
    );
    
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
    order by m.MemberID
    ;

END //

DELIMITER ;

-- CALLING THE FUNCTION
call AddNewMember('Brandy', 'Harrington', 'isadog@gmail.com', '2011-03-16');
call AddNewMember('Mister', 'Whiskers', 'isacat@gmail.com', '2001-03-16');




-- STORED PROCEDURE 2: Add a new LoanID for when a library member checks out and borrows a book.
-- Function: AddNewLoan()

DELIMITER //

CREATE PROCEDURE AddNewLoan(
    IN pMemberID INT,
    IN pInventoryID INT
)
BEGIN
    DECLARE vMembershipType INT;
    DECLARE vLoanDuration INT;
    DECLARE vDueDate DATE;

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
        CURRENT_DATE(),
        vDueDate,
        NULL,
        0
    );
    
END //

call AddNewLoan(2, 14); -- child
call AddNewLoan(5, 10) -- adult



-- STORED PROCEDURE 3: View overdue books
DELIMITER //

CREATE PROCEDURE CheckOverdueBooks()

BEGIN

	SELECT
		


END //

DELIMITER ;





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

-- CALLING THE FUNCTION
call GetMemberInfo(4);



-- STORED PROCEDURE 5: Search book name by genre name.
-- Function: SearchBookByGenre()

DELIMITER //
CREATE PROCEDURE SearchBookByGenre(IN pname varchar(300))
BEGIN
	SELECT
		g.name as 'Genre',
		b.name as 'Name of Book'
	FROM book_genre_classification as bg
    INNER JOIN book_genre as g ON bg.GenreID = g.GenreID
    INNER JOIN book as b ON bg.BookID = b.BookID
    where pname = g.name;
    
END //

DELIMITER ;

call SearchBookByGenre('fiction');
call SearchBookByGenre('Romance');



