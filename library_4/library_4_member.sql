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
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `MemberID` int NOT NULL AUTO_INCREMENT,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `birth_date` date NOT NULL,
  `registration_date` date NOT NULL,
  `MembershipStatusID` int DEFAULT NULL,
  `MembershipTypeID` int DEFAULT NULL,
  PRIMARY KEY (`MemberID`),
  KEY `MembershipStatusID` (`MembershipStatusID`),
  KEY `MembershipTypeID` (`MembershipTypeID`),
  CONSTRAINT `member_ibfk_1` FOREIGN KEY (`MembershipStatusID`) REFERENCES `member_membership_status` (`MembershipStatusID`),
  CONSTRAINT `member_ibfk_2` FOREIGN KEY (`MembershipTypeID`) REFERENCES `member_membership_type` (`MembershipTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES (1,'Miranda','Childs','Miranda@gmail.com','1992-05-17','2020-06-11',1,1),(2,'Titi','Ejembi','titi@gmail.com','2017-12-25','2017-12-03',1,2),(3,'Daliya','Stanley','Daliya@gmail.com','1967-08-21','2018-08-10',1,1),(4,'Reanna','Gibson','Reanna@gmail.com','1996-07-19','2022-09-19',1,1),(5,'Nadine','Latifah','Nadine@gmail.com','2001-06-04','2014-07-30',1,1),(6,'Michael','Apple','Michael@gmail.com','1970-08-18','2011-01-01',3,1),(7,'David','Pear','David@gmail.com','2009-02-14','2015-11-02',1,3),(8,'Allan','Orange','Allan@gmail.com','2019-02-27','2019-03-28',1,2),(9,'Edgar','Peach','Edgar@gmail.com','2010-12-05','2003-06-15',3,3),(10,'Ronald','Banana','Ronald@gmail.com','1995-12-25','2016-02-08',1,1);
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-18  1:37:12
