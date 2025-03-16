use library;

-- Stored procedure: Add a new library member to the member table.
-- Function: AddNewMember()
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


call AddNewMember('Brandy', 'Harrington', 'isadog@gmail.com', '2011-03-16');
call AddNewMember('Mister', 'Whiskers', 'isacat@gmail.com', '2001-03-16');


-- Stored procedure: Add a new LoanID for when a library member checks out and borrows a book.
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







