USE library_5;
-- MySQL dump 10.13  Distrib 8.0.40, for macos14 (x86_64)
--
-- Host: localhost    Database: library_4
-- ------------------------------------------------------
-- Server version	9.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `inventory_loan`
--

DROP TABLE IF EXISTS `inventory_loan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_loan` (
  `LoanID` int NOT NULL AUTO_INCREMENT,
  `MemberID` int NOT NULL,
  `InventoryID` int NOT NULL,
  `checkout_date` date NOT NULL,
  `due_date` date NOT NULL,
  `return_date` date DEFAULT NULL,
  `days_overdue` int DEFAULT '0',
  PRIMARY KEY (`LoanID`),
  KEY `MemberID` (`MemberID`),
  KEY `InventoryID` (`InventoryID`),
  CONSTRAINT `inventory_loan_ibfk_1` FOREIGN KEY (`MemberID`) REFERENCES `member` (`MemberID`),
  CONSTRAINT `inventory_loan_ibfk_2` FOREIGN KEY (`InventoryID`) REFERENCES `inventory` (`InventoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_loan`
--

LOCK TABLES `inventory_loan` WRITE;
/*!40000 ALTER TABLE `inventory_loan` DISABLE KEYS */;
INSERT INTO `inventory_loan` VALUES (1,1,5,'2025-02-14','2025-02-28',NULL,18),(2,4,15,'2025-02-21','2025-03-07',NULL,11),(3,5,23,'2025-02-15','2025-03-01',NULL,17),(4,2,29,'2025-02-09','2025-03-11',NULL,7);
/*!40000 ALTER TABLE `inventory_loan` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-18  1:37:14
