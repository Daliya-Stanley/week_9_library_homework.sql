use library_3;

-- get inventory items with book title, status and condition
SELECT i.InventoryID, b.book_name, s.status AS `InventoryStatus`, c.status AS `Condition`
FROM inventory i
JOIN book b ON i.BookID = b.BookID
JOIN inventory_status s ON i.InventoryStatusID = s.InventoryStatusID
JOIN inventory_condition c ON i.ConditionID = c.ConditionID;

-- Get inventory items that are missing
SELECT i.InventoryID, b.book_name, s.status AS InventoryStatus, c.status AS `Condition`
FROM inventory i
JOIN book b ON i.BookID = b.BookID
JOIN inventory_status s ON i.InventoryStatusID = s.InventoryStatusID
JOIN inventory_condition c ON i.ConditionID = c.ConditionID
WHERE s.status = 'Missing';

-- Get inventory items by status (in stock)
SELECT i.InventoryID, b.book_name, s.status AS InventoryStatus, c.status AS `Condition`
FROM inventory i
JOIN book b ON i.BookID = b.BookID
JOIN inventory_status s ON i.InventoryStatusID = s.InventoryStatusID
JOIN inventory_condition c ON i.ConditionID = c.ConditionID
WHERE s.status = 'In stock';