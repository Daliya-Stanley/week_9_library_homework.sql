use library_3;

-- get all memebers and their memeberhsip type and status
SELECT m.MemberID, m.firstname, m.lastname, m.email, m.birth_date, m.registration_date,
       mts.membership_status AS MembershipStatus, mtt.membership_type AS MembershipType
FROM member m
INNER JOIN member_membership_status mts ON m.MembershipStatusID = mts.MembershipStatusID
INNER JOIN member_membership_type mtt ON m.MembershipTypeID = mtt.MembershipTypeID;

-- Counts the number of members in each memebership status
SELECT mts.membership_status, COUNT(m.MemberID) AS MemberCount
FROM member m
JOIN member_membership_status mts ON m.MembershipStatusID = mts.MembershipStatusID
GROUP BY mts.membership_status;

-- Find memebers with a specific memebership type (this example is adult)
SELECT m.firstname, m.lastname, m.email, m.birth_date, m.registration_date
FROM member m
JOIN member_membership_type mmt ON m.MembershipTypeID = mmt.MembershipTypeID
WHERE mmt.membership_type = 'Adult';


