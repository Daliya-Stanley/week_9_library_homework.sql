use library;

-- Stored procedure: Add a new library member to the member table.
DELIMITER //

create procedure AddNewMember(
in pFirstname varchar(50),
in pLastname varchar(100),
in pEmail varchar(300),
in pBirthdate date
)

BEGIN
	DECLARE vAge INT;
    DECLARE vMembershiptype INT;
    SET vAge = datediff(current_date(), pBirthdate)/365;
    SELECT MembershipTypeID into vMembershiptype
	FROM member_membership_type
    WHERE vAge BETWEEN age_range_min AND IFNULL(age_range_max, vAge);
    
	insert into member(
    firstname,
    lastname,
    email,
    birth_date,
    registration_date,
    MembershipStatusID,
    MembershipTypeID
    )
    values(
    pFirstname,
    pLastname,
    pEmail,
    pBirthdate,
    current_date(),
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

