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
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `StaffID` int NOT NULL AUTO_INCREMENT,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `email` varchar(200) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `RoleID` int DEFAULT NULL,
  `ShiftID` int DEFAULT NULL,
  PRIMARY KEY (`StaffID`),
  KEY `RoleID` (`RoleID`),
  KEY `ShiftID` (`ShiftID`),
  CONSTRAINT `staff_ibfk_1` FOREIGN KEY (`RoleID`) REFERENCES `staff_role` (`RoleID`),
  CONSTRAINT `staff_ibfk_2` FOREIGN KEY (`ShiftID`) REFERENCES `Staff_working_hours` (`ShiftID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (1,'Miranda','Purple','fantaandmiranda@gmail.com','1424214124','2020-02-01',NULL,1,1),(2,'Titi','Green','glassoftitea@gmail.com','9986273928','1999-10-09',NULL,1,1),(3,'Nadine','Red','nadinesardine@gmail.com','2673528288','2021-11-13',NULL,1,1),(4,'Daliya','Yellow','daliyatheflower@gmail.com','6732946863','2019-09-16',NULL,1,1),(5,'Reanna','Blue','therealrehanna@gmail.com','3584154421','2019-01-10',NULL,1,1),(6,'Victoria','Smith','queenv@gmail.com','4287948267','2021-10-10',NULL,6,1),(7,'Roahl','Dahl','readmybooks@gmail.com','5621854475','2017-04-02',NULL,2,2),(8,'Julia','Donaldson','juliefromtheblock@gmail.com','4367944164','2017-09-04',NULL,3,3),(9,'Phil','Mitchell','phillycheesesteak@gmail.com','4125332323','2017-10-04',NULL,5,4),(10,'Grant','Mitchell','govgrant@gmail.com','4367828141','2017-10-04',NULL,4,5);
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
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
