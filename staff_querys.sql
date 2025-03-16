use library_3;

-- list all staff with their role and working hours
SELECT s.StaffID, 
       s.firstname, 
       s.lastname, 
       s.email, 
       s.phone_number, 
       s.start_date, 
       r.role_name AS Role, 
       r.role_description AS Role_Description, 
       wh.start_time AS Shift_Start, 
       wh.end_time AS Shift_End
FROM staff s
JOIN staff_role r ON s.RoleID = r.RoleID
JOIN staff_working_hours wh ON s.ShiftID = wh.ShiftID;

-- groups types of staff and the shift hours
SELECT r.role_name AS Role, 
       COUNT(s.StaffID) AS Number_Of_Staff, 
       wh.start_time AS Shift_Start, 
       wh.end_time AS Shift_End
FROM staff s
JOIN staff_role r ON s.RoleID = r.RoleID
JOIN staff_working_hours wh ON s.ShiftID = wh.ShiftID
GROUP BY r.role_name, wh.start_time, wh.end_time;