-- MySQL dump 10.13  Distrib 8.4.9, for Win64 (x86_64)
--
-- Host: localhost    Database: derma_clinic
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `derma_clinic`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `derma_clinic` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `derma_clinic`;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `appointment_number` varchar(40) NOT NULL,
  `patient_id` bigint unsigned NOT NULL,
  `assigned_user_id` bigint unsigned DEFAULT NULL,
  `starts_at` datetime NOT NULL,
  `ends_at` datetime NOT NULL,
  `status` enum('PENDING','CONFIRMED','COMPLETED','CANCELLED') NOT NULL DEFAULT 'PENDING',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `appointment_number` (`appointment_number`),
  UNIQUE KEY `uq_assigned_start` (`assigned_user_id`,`starts_at`),
  KEY `idx_appointments_patient_date` (`patient_id`,`starts_at`),
  KEY `idx_appointments_status_date` (`status`,`starts_at`),
  CONSTRAINT `fk_appointments_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`),
  CONSTRAINT `fk_appointments_user` FOREIGN KEY (`assigned_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `chk_appointment_range` CHECK ((`ends_at` > `starts_at`))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES (3,'APT-DC52D28A2C',17,3,'2026-10-15 14:20:00','2026-10-15 14:50:00','COMPLETED','2026-10-14 06:17:50','2026-10-14 06:39:19'),(4,'APT-B11D9AE82C',17,3,'2026-10-14 14:40:00','2026-10-14 15:10:00','PENDING','2026-10-14 06:34:05','2026-10-14 06:34:05'),(5,'APT-1D8B7CD8F4',18,3,'2026-10-22 08:20:00','2026-10-22 08:50:00','COMPLETED','2026-10-14 12:15:40','2026-10-14 12:16:40');
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `module` varchar(60) NOT NULL,
  `action` varchar(60) NOT NULL,
  `record_identifier` varchar(80) DEFAULT NULL,
  `reference_number` varchar(80) DEFAULT NULL,
  `metadata_json` json DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_audit_user` (`user_id`),
  KEY `idx_audit_module_action_date` (`module`,`action`,`created_at`),
  KEY `idx_audit_record` (`record_identifier`),
  CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (3,1,'Patients','QR_GENERATE','10','42db65121c85c544fb968ceeb9020d91b00180610a2b75a0cd2959a4f9b85238','{\"generated\": true}','2026-10-14 04:49:32'),(4,1,'Patients','QR_ACCESS','10','42db65121c85c544fb968ceeb9020d91b00180610a2b75a0cd2959a4f9b85238','{\"scanner\": \"admin@dermaclinic.test\"}','2026-10-14 04:49:33'),(5,1,'Patients','QR_GENERATE','10','42db65121c85c544fb968ceeb9020d91b00180610a2b75a0cd2959a4f9b85238','{\"generated\": false}','2026-10-14 04:49:36'),(6,1,'Patients','QR_ACCESS','10','42db65121c85c544fb968ceeb9020d91b00180610a2b75a0cd2959a4f9b85238','{\"scanner\": \"admin@dermaclinic.test\"}','2026-10-14 04:49:36'),(7,1,'Inventory','MOVEMENT_RECORDED','34','MERCURY','{\"type\": \"STOCK_IN\", \"quantity\": \"20\", \"newQuantity\": \"66.000\"}','2026-10-14 05:38:40'),(8,1,'Patients','QR_GENERATE','17','3b409a7d56b16e8e47f9fe348c6963454e861db5942bb7dba560e39f016f3524','{\"generated\": true}','2026-10-14 06:05:22'),(9,1,'Patients','QR_ACCESS','17','3b409a7d56b16e8e47f9fe348c6963454e861db5942bb7dba560e39f016f3524','{\"scanner\": \"admin@dermaclinic.test\"}','2026-10-14 06:05:28'),(10,1,'Patients','QR_ACCESS','17','3b409a7d56b16e8e47f9fe348c6963454e861db5942bb7dba560e39f016f3524','{\"scanner\": \"admin@dermaclinic.test\"}','2026-10-14 06:05:37'),(11,2,'Appointments','APPOINTMENT_CREATED','17','APT-9DBB4335F6','{\"staffId\": \"3\", \"startsAt\": \"2026-10-20T10:15\"}','2026-10-14 06:12:02'),(12,2,'Appointments','APPOINTMENT_CREATED','17','APT-190F4469C9','{\"staffId\": \"3\", \"startsAt\": \"2026-10-21T14:00\"}','2026-10-14 06:13:41'),(13,2,'Appointments','APPOINTMENT_UPDATED','17','APT-190F4469C9','{\"staffId\": \"4\", \"startsAt\": \"2026-10-22T15:00\"}','2026-10-14 06:13:48'),(14,2,'Appointments','APPOINTMENT_CREATED','17','APT-DC52D28A2C','{\"staffId\": \"3\", \"startsAt\": \"2026-10-15T14:20\"}','2026-10-14 06:17:50'),(15,3,'Consultations','CONSULTATION_CREATED','17','CON-A264CF2BFA',NULL,'2026-10-14 06:21:14'),(16,1,'Services','SERVICE_CREATED','9','DCMS-10',NULL,'2026-10-14 06:30:50'),(17,1,'Services','SERVICE_PRODUCT_LINK','9',NULL,'{\"productId\": \"34\"}','2026-10-14 06:30:50'),(21,2,'Appointments','APPOINTMENT_CREATED','17','APT-B11D9AE82C','{\"staffId\": \"3\", \"startsAt\": \"2026-10-14T14:40\"}','2026-10-14 06:34:05'),(22,3,'Appointments','APPOINTMENT_STATUS_CHANGED','3','COMPLETED','{\"status\": \"COMPLETED\"}','2026-10-14 06:39:19'),(23,6,'Inventory','SUPPLIER_CREATED','6','SUP-CE8F826D77','{\"name\": \"UNILAB\"}','2026-10-14 06:40:14'),(24,6,'Inventory','PRODUCT_CREATED','001','001','{\"supplierId\": \"5\"}','2026-10-14 06:41:01'),(25,1,'Services','SERVICE_CREATED','13','DCMS-1',NULL,'2026-10-14 11:06:15'),(26,1,'Services','SERVICE_PRODUCT_LINK','13',NULL,'{\"productId\": \"35\"}','2026-10-14 11:06:15'),(27,1,'Patients','QR_GENERATE','18','989897b53d9930c20ed231770205615d9176215d0b00c50a648547982cf63cd0','{\"generated\": true}','2026-10-14 12:12:26'),(28,1,'Patients','QR_ACCESS','18','989897b53d9930c20ed231770205615d9176215d0b00c50a648547982cf63cd0','{\"scanner\": \"admin@dermaclinic.test\"}','2026-10-14 12:12:43'),(29,2,'Patients','QR_GENERATE','17','3b409a7d56b16e8e47f9fe348c6963454e861db5942bb7dba560e39f016f3524','{\"generated\": false}','2026-10-14 12:13:51'),(30,1,'Appointments','APPOINTMENT_CREATED','18','APT-1D8B7CD8F4','{\"staffId\": \"3\", \"startsAt\": \"2026-10-21T08:20\"}','2026-10-14 12:15:40'),(31,1,'Appointments','APPOINTMENT_UPDATED','18','APT-1D8B7CD8F4','{\"staffId\": \"3\", \"startsAt\": \"2026-10-22T08:20\"}','2026-10-14 12:16:16'),(32,1,'Appointments','APPOINTMENT_STATUS_CHANGED','5','COMPLETED','{\"status\": \"COMPLETED\"}','2026-10-14 12:16:40'),(33,1,'Consultations','CONSULTATION_CREATED','18','CON-6743E15451',NULL,'2026-10-14 12:20:13'),(34,1,'Inventory','PRODUCT_CREATED','005','005','{\"supplierId\": \"5\"}','2026-10-14 12:27:33'),(35,1,'Patients','QR_GENERATE','17','3b409a7d56b16e8e47f9fe348c6963454e861db5942bb7dba560e39f016f3524','{\"generated\": false}','2026-10-14 14:20:10');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `consultations`
--

DROP TABLE IF EXISTS `consultations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consultations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `consultation_number` varchar(40) NOT NULL,
  `patient_id` bigint unsigned NOT NULL,
  `appointment_id` bigint unsigned DEFAULT NULL,
  `clinician_id` bigint unsigned NOT NULL,
  `diagnosis` text NOT NULL,
  `treatment_recommendation` text NOT NULL,
  `clinical_notes` text NOT NULL,
  `follow_up_information` text NOT NULL,
  `follow_up_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `consultation_number` (`consultation_number`),
  KEY `fk_consultations_appointment` (`appointment_id`),
  KEY `fk_consultations_clinician` (`clinician_id`),
  KEY `idx_consultations_patient_date` (`patient_id`,`created_at`),
  CONSTRAINT `fk_consultations_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`),
  CONSTRAINT `fk_consultations_clinician` FOREIGN KEY (`clinician_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_consultations_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consultations`
--

LOCK TABLES `consultations` WRITE;
/*!40000 ALTER TABLE `consultations` DISABLE KEYS */;
INSERT INTO `consultations` VALUES (1,'CON-A264CF2BFA',17,NULL,3,'INFECTION','ANTIBIOTICS','DON\'T GO OUTSIDE.','EVERY 1 WEEK','2026-10-21','2026-10-14 06:21:14'),(2,'CON-6743E15451',18,NULL,1,'severe','facial','N/A','N/A','2026-10-21','2026-10-14 12:20:13');
/*!40000 ALTER TABLE `consultations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flyway_schema_history`
--

DROP TABLE IF EXISTS `flyway_schema_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flyway_schema_history` (
  `installed_rank` int NOT NULL,
  `version` varchar(50) DEFAULT NULL,
  `description` varchar(200) NOT NULL,
  `type` varchar(20) NOT NULL,
  `script` varchar(1000) NOT NULL,
  `checksum` int DEFAULT NULL,
  `installed_by` varchar(100) NOT NULL,
  `installed_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `execution_time` int NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`installed_rank`),
  KEY `flyway_schema_history_s_idx` (`success`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flyway_schema_history`
--

LOCK TABLES `flyway_schema_history` WRITE;
/*!40000 ALTER TABLE `flyway_schema_history` DISABLE KEYS */;
INSERT INTO `flyway_schema_history` VALUES (1,'1','<< Flyway Baseline >>','BASELINE','<< Flyway Baseline >>',NULL,'root','2026-09-16 13:11:00',0,1),(2,'2','seed roles','SQL','V2__seed_roles.sql',-1369780179,'root','2026-09-16 13:14:55',106,1),(3,'3','fix development password hashes','SQL','V3__fix_development_password_hashes.sql',511361378,'root','2026-09-17 14:33:04',63,1),(4,'4','set staff development password hashes','SQL','V4__set_staff_development_password_hashes.sql',-19219740,'root','2026-09-17 16:04:52',19,1),(5,'5','remove non admin development accounts','SQL','V5__remove_non_admin_development_accounts.sql',-1064234823,'root','2026-09-24 06:07:57',28,1),(6,'6','restore development staff accounts','SQL','V6__restore_development_staff_accounts.sql',199569236,'root','2026-09-24 08:38:43',37,1),(7,'7','seed requested inventory','SQL','V7__seed_requested_inventory.sql',2086536922,'root','2026-09-25 07:41:27',320,1),(8,'8','link services to required products','SQL','V8__link_services_to_required_products.sql',694103836,'root','2026-09-28 07:50:04',24,1),(9,'9','add consultation follow up date','SQL','V9__add_consultation_follow_up_date.sql',-397423900,'root','2026-09-28 08:31:32',363,1),(10,'10','add patient skin type and allergies','SQL','V10__add_patient_skin_type_and_allergies.sql',-110423083,'root','2026-09-28 09:42:25',187,1),(11,'11','canonicalise role names','SQL','V11__canonicalise_role_names.sql',191968059,'derma_flyway','2026-10-13 10:25:42',50,1),(12,'12','e164 patient phone','SQL','V12__e164_patient_phone.sql',-1875702718,'derma_flyway','2026-10-14 03:00:34',23,1),(13,'13','international patient phone','SQL','V13__international_patient_phone.sql',-1585466261,'derma_flyway','2026-10-14 03:45:04',159,1);
/*!40000 ALTER TABLE `flyway_schema_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_balances`
--

DROP TABLE IF EXISTS `inventory_balances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_balances` (
  `product_id` bigint unsigned NOT NULL,
  `quantity` decimal(12,3) NOT NULL DEFAULT '0.000',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  CONSTRAINT `fk_balances_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `chk_inventory_nonnegative` CHECK ((`quantity` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_balances`
--

LOCK TABLES `inventory_balances` WRITE;
/*!40000 ALTER TABLE `inventory_balances` DISABLE KEYS */;
INSERT INTO `inventory_balances` VALUES (34,66.000,'2026-10-14 05:38:40');
/*!40000 ALTER TABLE `inventory_balances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_batches`
--

DROP TABLE IF EXISTS `inventory_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_batches` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint unsigned NOT NULL,
  `batch_number` varchar(80) NOT NULL,
  `expiry_date` date NOT NULL,
  `received_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_product_batch` (`product_id`,`batch_number`),
  KEY `idx_batches_expiry` (`expiry_date`),
  CONSTRAINT `fk_batches_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_batches`
--

LOCK TABLES `inventory_batches` WRITE;
/*!40000 ALTER TABLE `inventory_batches` DISABLE KEYS */;
INSERT INTO `inventory_batches` VALUES (18,34,'B-1-101326','2027-10-13','2026-10-13 14:16:39'),(19,34,'B-2-101326','2027-10-13','2026-10-13 15:05:47'),(20,34,'B-3-10142021','2026-10-21','2026-10-14 05:38:40');
/*!40000 ALTER TABLE `inventory_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_movements`
--

DROP TABLE IF EXISTS `inventory_movements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_movements` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint unsigned NOT NULL,
  `batch_id` bigint unsigned DEFAULT NULL,
  `docket_id` bigint unsigned DEFAULT NULL,
  `movement_type` enum('STOCK_IN','STOCK_OUT','ADJUSTMENT') NOT NULL,
  `previous_quantity` decimal(12,3) NOT NULL,
  `deducted_quantity` decimal(12,3) NOT NULL DEFAULT '0.000',
  `new_quantity` decimal(12,3) NOT NULL,
  `reference_number` varchar(60) NOT NULL,
  `performed_by` bigint unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_movements_batch` (`batch_id`),
  KEY `fk_movements_docket` (`docket_id`),
  KEY `fk_movements_user` (`performed_by`),
  KEY `idx_movements_product_date` (`product_id`,`created_at`),
  KEY `idx_movements_reference` (`reference_number`),
  CONSTRAINT `fk_movements_batch` FOREIGN KEY (`batch_id`) REFERENCES `inventory_batches` (`id`),
  CONSTRAINT `fk_movements_docket` FOREIGN KEY (`docket_id`) REFERENCES `treatment_dockets` (`id`),
  CONSTRAINT `fk_movements_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `fk_movements_user` FOREIGN KEY (`performed_by`) REFERENCES `users` (`id`),
  CONSTRAINT `chk_movement_quantities` CHECK (((`previous_quantity` >= 0) and (`new_quantity` >= 0) and (`deducted_quantity` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_movements`
--

LOCK TABLES `inventory_movements` WRITE;
/*!40000 ALTER TABLE `inventory_movements` DISABLE KEYS */;
INSERT INTO `inventory_movements` VALUES (7,34,18,NULL,'STOCK_IN',0.000,0.000,46.000,'OPENING-STOCK',1,'2026-10-14 02:17:37'),(8,34,20,NULL,'STOCK_IN',46.000,0.000,66.000,'MERCURY',1,'2026-10-14 05:38:40');
/*!40000 ALTER TABLE `inventory_movements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoices` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `invoice_number` varchar(40) NOT NULL,
  `docket_id` bigint unsigned NOT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  `discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_amount` decimal(12,2) NOT NULL,
  `status` enum('PENDING','PARTIAL','PAID','VOID') NOT NULL DEFAULT 'PENDING',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoice_number` (`invoice_number`),
  UNIQUE KEY `docket_id` (`docket_id`),
  KEY `idx_invoices_date_status` (`created_at`,`status`),
  CONSTRAINT `fk_invoices_docket` FOREIGN KEY (`docket_id`) REFERENCES `treatment_dockets` (`id`),
  CONSTRAINT `chk_invoice_math` CHECK (((`subtotal` >= 0) and (`discount` >= 0) and (`discount` <= `subtotal`) and (`total_amount` = (`subtotal` - `discount`))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `patient_number` varchar(40) NOT NULL,
  `full_name` varchar(160) NOT NULL,
  `email` varchar(190) DEFAULT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `skin_type` enum('NORMAL','DRY','OILY','COMBINATION','SENSITIVE') DEFAULT NULL,
  `allergies` varchar(500) DEFAULT NULL,
  `status` enum('ACTIVE','ARCHIVED') NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `patient_number` (`patient_number`),
  KEY `idx_patients_name` (`full_name`),
  KEY `idx_patients_status` (`status`),
  CONSTRAINT `chk_patients_phone_e164` CHECK (((`phone` is null) or regexp_like(`phone`,_utf8mb4'^[+][1-9][0-9]{6,14}$')))
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (15,'PT-5843CE5F','Mondejar, Washington B.','Mondejarwashington@gmail.com','+639243078998','2005-04-19','SENSITIVE','Seafood','ARCHIVED','2026-10-14 05:21:17','2026-10-14 05:21:29'),(16,'PT-F907E888','jem','fujimiyakun04419@gmail.com','+639243078998','2006-09-08','NORMAL','Seafood','ARCHIVED','2026-10-14 05:22:39','2026-10-14 05:22:48'),(17,'PT-C98514D6','Mondejar, Washington B.','Mondejarwashington@gmail.com','+639243078998','2026-10-14','DRY','Seafood','ACTIVE','2026-10-14 06:04:58','2026-10-14 06:05:17'),(18,'PT-7F37CD25','jamer fundano','Jamer@gmail.com','+639243078998','2026-10-14','OILY','Seafood','ACTIVE','2026-10-14 12:11:58','2026-10-14 12:11:58');
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `invoice_id` bigint unsigned NOT NULL,
  `payment_reference` varchar(60) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `method` varchar(40) NOT NULL,
  `created_by` bigint unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payment_reference` (`payment_reference`),
  KEY `fk_payments_invoice` (`invoice_id`),
  KEY `fk_payments_user` (`created_by`),
  KEY `idx_payments_date` (`created_at`),
  CONSTRAINT `fk_payments_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`),
  CONSTRAINT `fk_payments_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `chk_payment_amount` CHECK ((`amount` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `supplier_id` bigint unsigned DEFAULT NULL,
  `sku` varchar(80) NOT NULL,
  `name` varchar(160) NOT NULL,
  `unit` varchar(30) NOT NULL,
  `reorder_threshold` decimal(12,3) NOT NULL DEFAULT '0.000',
  `status` enum('ACTIVE','ARCHIVED') NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sku` (`sku`),
  KEY `fk_products_supplier` (`supplier_id`),
  KEY `idx_products_name` (`name`),
  KEY `idx_products_status` (`status`),
  CONSTRAINT `fk_products_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  CONSTRAINT `chk_reorder_threshold` CHECK ((`reorder_threshold` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (34,5,'9865432169','Hydrochloric Acid','12',3.000,'ACTIVE','2026-10-13 14:15:02','2026-10-13 14:55:54'),(35,5,'001','hydra','20',30.000,'ACTIVE','2026-10-14 06:41:01','2026-10-14 06:41:01'),(36,5,'005','paracetamol','3',5.000,'ACTIVE','2026-10-14 12:27:33','2026-10-14 12:27:33');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `receipts`
--

DROP TABLE IF EXISTS `receipts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receipts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `receipt_number` varchar(60) NOT NULL,
  `payment_id` bigint unsigned NOT NULL,
  `issued_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `receipt_number` (`receipt_number`),
  UNIQUE KEY `payment_id` (`payment_id`),
  CONSTRAINT `fk_receipts_payment` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipts`
--

LOCK TABLES `receipts` WRITE;
/*!40000 ALTER TABLE `receipts` DISABLE KEYS */;
/*!40000 ALTER TABLE `receipts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Administrator','2026-09-13 17:38:27','Full clinic administration and system oversight'),(2,'Receptionist','2026-09-13 17:38:27','Patient registration and schedule administration'),(3,'Dermatologist','2026-09-13 17:38:27','Clinical review and consultation records'),(4,'Therapist','2026-09-13 17:38:27','Treatment execution and assigned docket work'),(5,'Cashier','2026-09-13 17:38:27','Billing and payment workflows'),(6,'Inventory Staff','2026-09-13 17:38:27','Inventory and stock movement management');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_transactions`
--

DROP TABLE IF EXISTS `sales_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sale_reference` varchar(60) NOT NULL,
  `invoice_id` bigint unsigned NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sale_reference` (`sale_reference`),
  UNIQUE KEY `invoice_id` (`invoice_id`),
  KEY `idx_sales_date` (`created_at`),
  CONSTRAINT `fk_sales_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_transactions`
--

LOCK TABLES `sales_transactions` WRITE;
/*!40000 ALTER TABLE `sales_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `secure_qr_references`
--

DROP TABLE IF EXISTS `secure_qr_references`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `secure_qr_references` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `opaque_reference` char(64) NOT NULL,
  `patient_id` bigint unsigned DEFAULT NULL,
  `docket_id` bigint unsigned DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `revoked_at` datetime DEFAULT NULL,
  `created_by` bigint unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `opaque_reference` (`opaque_reference`),
  KEY `fk_qr_patient` (`patient_id`),
  KEY `fk_qr_docket` (`docket_id`),
  KEY `fk_qr_user` (`created_by`),
  KEY `idx_qr_expiry` (`expires_at`),
  CONSTRAINT `fk_qr_docket` FOREIGN KEY (`docket_id`) REFERENCES `treatment_dockets` (`id`),
  CONSTRAINT `fk_qr_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`),
  CONSTRAINT `fk_qr_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `secure_qr_references`
--

LOCK TABLES `secure_qr_references` WRITE;
/*!40000 ALTER TABLE `secure_qr_references` DISABLE KEYS */;
INSERT INTO `secure_qr_references` VALUES (3,'3b409a7d56b16e8e47f9fe348c6963454e861db5942bb7dba560e39f016f3524',17,NULL,NULL,NULL,1,'2026-10-14 06:05:22'),(4,'989897b53d9930c20ed231770205615d9176215d0b00c50a648547982cf63cd0',18,NULL,NULL,NULL,1,'2026-10-14 12:12:26');
/*!40000 ALTER TABLE `secure_qr_references` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_required_products`
--

DROP TABLE IF EXISTS `service_required_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_required_products` (
  `service_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned NOT NULL,
  `required_quantity` decimal(12,3) NOT NULL,
  PRIMARY KEY (`service_id`,`product_id`),
  KEY `fk_service_products_product` (`product_id`),
  CONSTRAINT `fk_service_products_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `fk_service_products_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`),
  CONSTRAINT `chk_required_quantity` CHECK ((`required_quantity` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_required_products`
--

LOCK TABLES `service_required_products` WRITE;
/*!40000 ALTER TABLE `service_required_products` DISABLE KEYS */;
INSERT INTO `service_required_products` VALUES (9,34,100.000),(13,35,100.000);
/*!40000 ALTER TABLE `service_required_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `service_code` varchar(50) NOT NULL,
  `category` varchar(100) NOT NULL,
  `name` varchar(160) NOT NULL,
  `description` text NOT NULL,
  `price` decimal(12,2) NOT NULL,
  `duration_minutes` int unsigned NOT NULL,
  `status` enum('ACTIVE','ARCHIVED') NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `service_code` (`service_code`),
  KEY `idx_services_category` (`category`),
  KEY `idx_services_status` (`status`),
  CONSTRAINT `chk_service_duration` CHECK ((`duration_minutes` > 0)),
  CONSTRAINT `chk_service_price` CHECK ((`price` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (9,'DCMS-10','Skin treatments','cleaning & Maintenance','A foundational maintenance treatment designed to cleanse, refresh, and maintain skin health. This service includes standard procedural care tailored to support optimal skin upkeep within a 30-minute session.',1999.00,30,'ACTIVE','2026-10-14 06:30:50','2026-10-14 06:32:57'),(13,'DCMS-1','Injectables','cleaning & Maintenance','A foundational maintenance treatment designed to deeply cleanse, gently exfoliate, and refresh skin health.',1699.00,20,'ACTIVE','2026-10-14 11:06:14','2026-10-14 11:06:14');
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session_refresh_tokens`
--

DROP TABLE IF EXISTS `session_refresh_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session_refresh_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `revoked_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_hash` (`token_hash`),
  KEY `idx_refresh_user_expiry` (`user_id`,`expires_at`),
  CONSTRAINT `fk_refresh_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_refresh_tokens`
--

LOCK TABLES `session_refresh_tokens` WRITE;
/*!40000 ALTER TABLE `session_refresh_tokens` DISABLE KEYS */;
INSERT INTO `session_refresh_tokens` VALUES (1,1,'b016f0bdd1771175822b187c616c86a88ca58ea666ab9a8a8ee213196efc3598','2026-11-13 02:21:03',NULL,'2026-10-13 18:21:03'),(2,2,'ed40d328b59ad29b4a5b72ed6e5687a6c40f3417b48c6395a19043809ad21c55','2026-11-13 02:21:55',NULL,'2026-10-13 18:21:55'),(3,3,'b3ca466626873a93fcbd3587b0580658613391cb94d749a4ccbe4ab19148fcbc','2026-11-13 02:30:14',NULL,'2026-10-13 18:30:14'),(4,4,'820613414c83628219354bad863d3fd14347041166b80ae1a4a726e107ece173','2026-11-13 02:31:44',NULL,'2026-10-13 18:31:44'),(5,6,'9a401dc8d96b3fd5350195990564c7b3a95520d981aad8623fab451f473c39e8','2026-11-13 02:32:52',NULL,'2026-10-13 18:32:52'),(6,5,'e020ccd068e30ef0818d3fdd56ac67aed1fc6d91f3904f23e6e8b1bcf6a11670','2026-11-13 02:35:54',NULL,'2026-10-13 18:35:54'),(7,1,'1587cc9c6a84c3f74432c865023380b6f0bc54d22bbfb81591acaead64f37f61','2026-11-13 02:39:45','2026-10-14 02:44:46','2026-10-13 18:39:45'),(8,1,'40d1f1573c48d031f51b57b6132106aa68c6257d690b65ebb9db5896f7866d45','2026-11-13 02:44:46','2026-10-14 02:49:47','2026-10-13 18:44:46'),(9,1,'98456193834392228693dd28c6b1137e3078473d695d3498c5d5ca4cc9272bd8','2026-11-13 02:49:47','2026-10-14 02:54:48','2026-10-13 18:49:47'),(10,1,'cabe12241258127df0d52f1133aad419aeddad79bb1bd247e41792dda5584daf','2026-11-13 02:54:48','2026-10-14 02:59:49','2026-10-13 18:54:48'),(11,1,'1de27b47569c291c4e01c3619899420095ab5b5499269278d69f141a4fb864d0','2026-11-13 02:59:49','2026-10-14 03:04:50','2026-10-13 18:59:49'),(12,1,'9abda400b501e5439b3ea74be625369ee7b582364e8c64f0f64c5a1df43e6fef','2026-11-13 03:01:25',NULL,'2026-10-13 19:01:25'),(13,1,'6d2e48856da1111604710aab63eaa0de4f62ef0c055f33ca20d73266068ea845','2026-11-13 03:04:50',NULL,'2026-10-13 19:04:50'),(14,1,'811885d44d4c1473b2f55f544e192879b416c8a061f9b90f7cbd93949b3b33a8','2026-11-13 03:19:18','2026-10-14 03:24:19','2026-10-13 19:19:18'),(15,1,'82cac6483a7d80a34c347a2beb7d588859f7ca76f4875a3ad4920a24e218a84a','2026-11-13 03:24:19','2026-10-14 03:29:20','2026-10-13 19:24:19'),(16,1,'c4a45f84005e94a5701567682e3200ae7f58358df203401c646b9afc895d1cee','2026-11-13 03:29:20','2026-10-14 03:34:21','2026-10-13 19:29:20'),(17,1,'ff72f96357440c252315c3fddcb39f6584bfa6d6b42ba6c0692f03f03a9d4ea7','2026-11-13 03:34:21','2026-10-14 03:39:22','2026-10-13 19:34:21'),(18,1,'68a6b04791c2e07f525c89cd590bcdeb5a4c2118751056b6b34e91f8cd65a65d','2026-11-13 03:39:22','2026-10-14 03:44:23','2026-10-13 19:39:22'),(19,1,'340bd48c00c94d7f8e6f142a59db83cec0d4ff7d0f332d247cb744c0d61ed90a','2026-11-13 03:44:23',NULL,'2026-10-13 19:44:23'),(20,1,'ab55ece4178675e063bc9f170f967f73d20fc8406eba9a64ef38395a06f2189c','2026-11-13 04:09:58','2026-10-14 04:15:00','2026-10-13 20:09:58'),(21,1,'c3b03a8576c2ca02910539d45999e1f72a52707078893636d3fddefb5406676a','2026-11-13 04:15:00','2026-10-14 04:41:15','2026-10-13 20:15:00'),(22,1,'2277c27ceb2de94841f1e047c504b3e4c891ca7f7b2a1bf0466fc76ad439b47c','2026-11-13 04:41:15','2026-10-14 04:46:16','2026-10-13 20:41:15'),(23,1,'b5e34ab0221d105b6b7289a186dab93fcd3bd25d8451b784fcea8007303a0bac','2026-11-13 04:46:16','2026-10-14 04:51:17','2026-10-13 20:46:16'),(24,1,'59d304242233dbf7f853db27d81e22d7971a02d799a5f4d2a4653651fd8385e9','2026-11-13 04:51:17','2026-10-14 04:56:18','2026-10-13 20:51:17'),(25,1,'b40801020a3be60166befab09beffd424c42c46a802ead5d6e3e467be5bcd1ca','2026-11-13 04:56:18','2026-10-14 05:01:18','2026-10-13 20:56:18'),(26,1,'4426d7e967ce2aa38a12f13cc1b275cc0994138289e0c87b9b4a61019789152e','2026-11-13 05:01:18',NULL,'2026-10-13 21:01:18'),(27,6,'7dcfaf261baccd06598208f6b6d45e4c6db5c20194dcdeae284a06d4b98e0451','2026-11-13 05:01:33','2026-10-14 05:16:34','2026-10-13 21:01:33'),(28,6,'411a114a38e2d64b6c48e20e426b1aa679ad07007bc7bf5505d14431e126c534','2026-11-13 05:16:34',NULL,'2026-10-13 21:16:34'),(29,6,'2f58b9c24afaa1f6fc3810aca727a16dc44580015520abcec6d2cef77deffb12','2026-11-13 05:18:35',NULL,'2026-10-13 21:18:35'),(30,1,'307a1b11ec5065de4ae34bc6f8705abc52c392eed7534ca49753b2ff27b3d7a7','2026-11-13 05:18:44','2026-10-14 05:23:44','2026-10-13 21:18:44'),(31,1,'d0eed5d64d18a7b9ce483374298cb48b7712c5af4af4b19cc1e539582faf13cd','2026-11-13 05:23:44','2026-10-14 05:28:45','2026-10-13 21:23:44'),(32,1,'b38454de22cab7a04c3aaea3237c25731a3768fdc0ed0516473eae4ac6aecf55','2026-11-13 05:28:45','2026-10-14 05:33:46','2026-10-13 21:28:45'),(33,1,'e7266f3f837861cbc0abe5b82eda0eccdfe8d7a9300d7d9250258cebc04dd462','2026-11-13 05:33:46','2026-10-14 05:38:46','2026-10-13 21:33:46'),(34,1,'c1c3a869660e8455a6b4df77a50fa443b08bedf4cdbbd01a7f6d9767795534ba','2026-11-13 05:38:46',NULL,'2026-10-13 21:38:46'),(35,3,'348ef808078556810e6e0b0ec7b55522136d620615e4d00696ba5ca53795bde6','2026-11-13 05:40:51',NULL,'2026-10-13 21:40:51'),(36,4,'c1a97d3cf5d659bba950a2ba495a0b9f626a8a8ce070d2245c01eabfd19076d6','2026-11-13 05:41:09',NULL,'2026-10-13 21:41:09'),(37,1,'bb7900b68afd062ef2fcb3f44bc3541d70b626b3a8969086d970341abb6ab9b3','2026-11-13 05:55:51','2026-10-14 06:00:51','2026-10-13 21:55:51'),(38,1,'2e24d3d27312c4f0f06e560f46e20a8f01b6a57fd15f7c53d768093f5b219169','2026-11-13 06:00:51','2026-10-14 06:05:51','2026-10-13 22:00:51'),(39,1,'42bdb93a609149d26cf820bfdd796f883ee364e3611aa939906fe7008400705b','2026-11-13 06:05:28',NULL,'2026-10-13 22:05:28'),(40,1,'9714e98f7ca956176a229118f99c3330aba7ea09a7c74a1d85bd1cf469aca4eb','2026-11-13 06:05:51','2026-10-14 06:10:52','2026-10-13 22:05:51'),(41,2,'8753d3d22c0618ea4a7560ba5640ba6118f10b2711303760ae91c664b4673a94','2026-11-13 06:07:28','2026-10-14 06:22:29','2026-10-13 22:07:28'),(42,3,'654f7c92dcd06f1c24ccde6834c1e3406f8ee9eb7f260eb0b352477b4f4ac6d2','2026-11-13 06:07:33','2026-10-14 06:22:34','2026-10-13 22:07:33'),(43,4,'bd70f06ebc3aa261e325684507d61487644be5bb53082507e6daed47502e5ac8','2026-11-13 06:07:39','2026-10-14 06:22:40','2026-10-13 22:07:39'),(44,6,'dac8093c85756145cd415d69f5567a896e06add918edc4b0290fc8d233adff82','2026-11-13 06:07:48','2026-10-14 06:22:49','2026-10-13 22:07:48'),(45,5,'0309b80f3201deee02947a65d9ad036785f0387b046a9311eaac8c6fd1c33e5f','2026-11-13 06:07:58','2026-10-14 06:23:01','2026-10-13 22:07:58'),(46,1,'cde13fc6a60a968d9264da24f9c83d0b3423e9f73aeced5c13d7ed35ecaf692f','2026-11-13 06:10:52','2026-10-14 06:15:53','2026-10-13 22:10:52'),(47,1,'ef570fff01596acc1ff82ac6e859120eb1ea7c115f4c85837afca00798bf9460','2026-11-13 06:15:53','2026-10-14 06:20:54','2026-10-13 22:15:53'),(48,1,'31c3f608f8f28e8fadd4e07b35bf8918f0bc9f4b960d0a5a55edd117283f8508','2026-11-13 06:20:54','2026-10-14 06:26:33','2026-10-13 22:20:54'),(49,2,'9a137284fc6c3454de1f32b33fbb1bca559fe7941eb35933851ba2b1bce2c804','2026-11-13 06:22:29','2026-10-14 06:37:30','2026-10-13 22:22:29'),(50,3,'d5256f1aefe4479dcc88c8bb920beb275f0a5232e32cad7da962e7135e8939ab','2026-11-13 06:22:34','2026-10-14 06:37:35','2026-10-13 22:22:34'),(51,4,'21c4ee8aa55fd426eb4a9945c06993cbcf25ad6262bac065492bacf28f4c218b','2026-11-13 06:22:40','2026-10-14 06:37:41','2026-10-13 22:22:40'),(52,6,'7b6995a739c518434bb92b7e86f6d48d8f35b63c2d3435d6791176361f3f82fe','2026-11-13 06:22:49','2026-10-14 06:37:50','2026-10-13 22:22:49'),(53,5,'e3060bdcf526b64bc82d2855a668883548ffc34834ad6b06e669958e388fb836','2026-11-13 06:23:01','2026-10-14 06:38:01','2026-10-13 22:23:01'),(54,1,'80c580e87f8a1d955e75035f37f2b1f9ac7030b9bd34646b909727630e8b2831','2026-11-13 06:26:33','2026-10-14 06:31:33','2026-10-13 22:26:33'),(55,1,'7f18c15a7e56510aeace7c531096ffa78fa7f4b465c251ebddcb3c1367a80c5e','2026-11-13 06:31:33','2026-10-14 06:36:34','2026-10-13 22:31:33'),(56,1,'631bf3d686ef5fec65487f08768ad22ed3cb879afcb24041e18ff32ab8aadba4','2026-11-13 06:36:34','2026-10-14 06:41:35','2026-10-13 22:36:34'),(57,2,'bece0b32607ff72a1b50ca29ce01a822d92c5f02e7184c31ad32ef128c37b56d','2026-11-13 06:37:30',NULL,'2026-10-13 22:37:30'),(58,3,'56fa7e190241e8a67103a111bd91250434c55847d8e0765694a172f7a01103b6','2026-11-13 06:37:35',NULL,'2026-10-13 22:37:35'),(59,4,'73a689bb6c3e642c079ca87248cf010490cac715d000eff6b69a8a07a8c8b0c7','2026-11-13 06:37:41',NULL,'2026-10-13 22:37:41'),(60,6,'0528e12d97817724e9b57188bd97fd9a2f1d4ab66085b167486a9a35e1f66bbe','2026-11-13 06:37:50',NULL,'2026-10-13 22:37:50'),(61,5,'a9e617c528d11a8e78b9b2da5c3131d637cb7c83e763ce3939014c296272d8f0','2026-11-13 06:38:01',NULL,'2026-10-13 22:38:01'),(62,1,'090f16e847ca4ec9991f94aed93fb3c0bf1aad09b0f66c881d396a1cc1696cfa','2026-11-13 06:41:35','2026-10-14 06:46:36','2026-10-13 22:41:35'),(63,1,'e4ab72432cd31910920c4a44ad67553ac22d4288f361e64e0f91cdb70b9a0a99','2026-11-13 06:46:36',NULL,'2026-10-13 22:46:36'),(64,1,'a9aa5c8fdbf5169a18aa3120fee50acf1114f7e1138a85afc51f2796a708103c','2026-11-13 08:47:41','2026-10-14 08:52:43','2026-10-14 00:47:41'),(65,2,'d28dd4dbf6e8501abac6a075409f3bd68a9960f4f18bd92b832f519128357835','2026-11-13 08:48:13','2026-10-14 09:03:14','2026-10-14 00:48:13'),(66,3,'720360fef39a94ab987c36015c63dba69cc6c997b8e3489368663973abdcac2e','2026-11-13 08:48:24','2026-10-14 09:03:25','2026-10-14 00:48:24'),(67,4,'3a1b26253d2f6af4c34e99fea5f4ac4ebcb25aafd43089280d7a882007d45d17','2026-11-13 08:48:32','2026-10-14 09:03:33','2026-10-14 00:48:32'),(68,6,'dac5790d5becd0082ea3a85563cf10144a0bbab2355d702cfa1fbb0f2eec2c00','2026-11-13 08:48:39','2026-10-14 09:03:40','2026-10-14 00:48:39'),(69,5,'5123609992dae10fe7bdf8421102e054ee61e596ae8a52b1063f308962acfd6a','2026-11-13 08:48:46','2026-10-14 09:03:46','2026-10-14 00:48:46'),(70,1,'86461f7bd7855644842427c512d8bdcc8b82213c7ff32014f72816ab84844682','2026-11-13 08:52:43','2026-10-14 08:57:44','2026-10-14 00:52:43'),(71,1,'72be5cc5f9be41f9a96c0c6ae8cc626f2e088d4bd6cb7c0af79697694127a9f7','2026-11-13 08:57:44','2026-10-14 09:02:45','2026-10-14 00:57:44'),(72,1,'47aa3dd5c47c825616b2efbb622c62159de17c6b282b8d1f252ce7955b0ab2cb','2026-11-13 09:02:45','2026-10-14 09:08:00','2026-10-14 01:02:45'),(73,2,'b4b8114f860a62db77a35c5605606850112c085356d33c54a796f17aa19a0641','2026-11-13 09:03:14','2026-10-14 10:00:22','2026-10-14 01:03:14'),(74,3,'2687ab6da2c578b72368b5f1a3abf157fd00e7a2b9099a693f25a8791f14044b','2026-11-13 09:03:25','2026-10-14 10:00:22','2026-10-14 01:03:25'),(75,4,'2cffe5e65c5ca525aee81cfb83cea6ea689fe14f572d3c3334564ad7e8fe50ec','2026-11-13 09:03:33','2026-10-14 10:00:22','2026-10-14 01:03:33'),(76,6,'a6afde5024906db07da8ca5580c4e49d952ced5bc8cbd7da047dec3941fedd71','2026-11-13 09:03:40','2026-10-14 10:00:22','2026-10-14 01:03:40'),(77,5,'5698b48d87944d4d99068cafb978c03aa4a19e22c4afad7a13fa78fe4050b811','2026-11-13 09:03:46','2026-10-14 10:00:22','2026-10-14 01:03:46'),(78,1,'5e11685afefb368f9af5a83e4cc9c2a5f96bc4fdd9e387c0302d8535430ba5e2','2026-11-13 09:08:00','2026-10-14 10:00:22','2026-10-14 01:08:00'),(79,3,'2f346f9516305e69c8d5636322044c8d668741cdeda79874df9167157971bdbf','2026-11-13 10:00:22','2026-10-14 10:56:25','2026-10-14 02:00:22'),(80,4,'77a761cacfe9d4a14066d6afb1ac29248971cc03fd9e5efc76c129c1ed53131c','2026-11-13 10:00:22','2026-10-14 10:56:25','2026-10-14 02:00:22'),(81,1,'6d23d67e9e1d8b699e02f5b86ca143500d92a103b9f984473e36bb364b4a4ba1','2026-11-13 10:00:22','2026-10-14 10:56:25','2026-10-14 02:00:22'),(82,5,'b2de356af2e704efc080c01888e2aea9b0ae4d542ca5cc98b487b29ccca89564','2026-11-13 10:00:22','2026-10-14 10:56:25','2026-10-14 02:00:22'),(83,2,'11e2a3aab6418f8f5300daaa5b906bdfcd3b85b58ac440c795068d1f7083a8a2','2026-11-13 10:00:22','2026-10-14 10:56:25','2026-10-14 02:00:22'),(84,6,'f347953bda2d2ab7dd0f06137dd8083ca5764bc75e28172e12a370cdeb74ac8c','2026-11-13 10:00:22','2026-10-14 10:56:25','2026-10-14 02:00:22'),(85,5,'daecb792d98bc9f1c6b16eb3076ebaaa8f2511ce7cdfa8fc96b72587b6c1f633','2026-11-13 10:56:25','2026-10-14 11:11:28','2026-10-14 02:56:25'),(86,1,'239996e4c3f1452ac8bcd5a1971cebcc5ca3da60974a03e4fc22d3fbdf673cf2','2026-11-13 10:56:25','2026-10-14 11:01:27','2026-10-14 02:56:25'),(87,2,'6136cd0a02a5b94efd773c2168f133a0f6444b3dfcad7e2190f5c97be2ff9139','2026-11-13 10:56:25','2026-10-14 11:11:26','2026-10-14 02:56:25'),(88,3,'76fe15ae5f1fd05d07b9a637834830880231e528b2863f2293cbc8cb58e5a88d','2026-11-13 10:56:25','2026-10-14 11:11:34','2026-10-14 02:56:25'),(89,6,'e737afff85f75cd41a82b1ef7c898344910866b5948a6547e8f0f55e5ec65eb1','2026-11-13 10:56:25','2026-10-14 11:11:26','2026-10-14 02:56:25'),(90,4,'766ed9bf8cff762e2a64c51154da258eba1f97fb0a517232eedce12dede510ca','2026-11-13 10:56:25','2026-10-14 11:12:03','2026-10-14 02:56:25'),(91,1,'650ea10ff1cbce9cf3947f1de72cd6bedf434c660246bf7f4490d3afc1033a78','2026-11-13 11:01:27','2026-10-14 11:06:28','2026-10-14 03:01:27'),(92,1,'3c06a63e70655c564526285e6e33d129bbeb38beee3f457a4634404bdfad9146','2026-11-13 11:06:28','2026-10-14 11:11:29','2026-10-14 03:06:28'),(93,2,'92685d2afa17d47b8d95bbe5e92f7c3560d45dfa29e26842d273314391f32143','2026-11-13 11:11:26','2026-10-14 11:27:09','2026-10-14 03:11:26'),(94,6,'0f75dcb12bf1aa207fd0ac7aa0afe8f668b973b67f83cffcbd13cdab1402521b','2026-11-13 11:11:26','2026-10-14 11:27:09','2026-10-14 03:11:26'),(95,5,'492e34cfc00e4ab1c8a725d1cde28aa39c83e5ff45bc34d428ac3ee6a163eff9','2026-11-13 11:11:28','2026-10-14 11:26:46','2026-10-14 03:11:28'),(96,1,'8aea93d2fcee2680f1c6704563fe0a2ab5cc8076876235dcba31435d12fa3ff6','2026-11-13 11:11:29','2026-10-14 11:16:30','2026-10-14 03:11:29'),(97,3,'42ed4ec3c8f2f4d21d19875e5b5bfc2324787f05d84115e3947819752d44084c','2026-11-13 11:11:34','2026-10-14 12:13:32','2026-10-14 03:11:34'),(98,4,'7eb10965cd71c3ba57c446b21cf14f70a69f44d0ffe342f906db293e2775a6d1','2026-11-13 11:12:03','2026-10-14 11:27:04','2026-10-14 03:12:03'),(99,1,'0915f18b7af9a58a9138fd666127b3835b7d64e55d4b1e6568bb815c2fcb015f','2026-11-13 11:16:30','2026-10-14 11:21:31','2026-10-14 03:16:30'),(100,1,'ac48cb7f345053fa545258778bc1fa35b3d9d985bcd1fc09355dfe51daf103aa','2026-11-13 11:21:31','2026-10-14 11:26:32','2026-10-14 03:21:31'),(101,1,'843126b509a6b772302507d6d165c8deda499c7675143b4fe5ca2821481e63f6','2026-11-13 11:26:32','2026-10-14 11:31:33','2026-10-14 03:26:32'),(102,5,'bb940c79b8fd39dad90d1e1c1e69a40cb18c746aebc2064b40935906e31f35a6','2026-11-13 11:26:46','2026-10-14 11:41:47','2026-10-14 03:26:46'),(103,4,'91f3b03a34334e3fc88459f91baf9ea802a624e39b9be51f23a718a261abb68e','2026-11-13 11:27:04','2026-10-14 11:42:05','2026-10-14 03:27:04'),(104,6,'55a4a2cc4d924a7d561ca8a097f6648f56c179ce62be6f514964470719b9fc7d','2026-11-13 11:27:09','2026-10-14 11:42:10','2026-10-14 03:27:09'),(105,2,'fca24c74dd3c8f50a376dc6cea93bd0d51c2d5ec6da4eedfc4cceb7c91162fe7','2026-11-13 11:27:09','2026-10-14 11:42:21','2026-10-14 03:27:09'),(106,1,'c037bce521e76aa354c715ed860817f22d4ad8dbc3e5ba3946e3c46e20e553ce','2026-11-13 11:31:33','2026-10-14 11:36:34','2026-10-14 03:31:33'),(107,1,'19973f40eae155b18d224e014fd1ad363fd080624b4e9176d083d29b55c43cb6','2026-11-13 11:36:34','2026-10-14 11:41:35','2026-10-14 03:36:34'),(108,1,'88c7b6b61260c52d6a435e5ce010eb0e5fa18fa4d9bf23c921c0a3d76ca843ad','2026-11-13 11:41:35','2026-10-14 11:47:10','2026-10-14 03:41:35'),(109,5,'d50f5b3414d63d519fe23694a70c7ddff07faa41ae2bfcc0f18f3c012710759a','2026-11-13 11:41:47','2026-10-14 11:56:48','2026-10-14 03:41:47'),(110,4,'7d353e254276460901bf9b7b02fed6600075d6ab80ecf86f24afa0ef5f5b4330','2026-11-13 11:42:05','2026-10-14 12:17:07','2026-10-14 03:42:05'),(111,6,'820d497dcf177b7b9198bcbfdb9de58b0d8f025436b8f46ceaacdf05b8feffaa','2026-11-13 11:42:10','2026-10-14 11:57:14','2026-10-14 03:42:10'),(112,2,'4c50b7fc64f62e5c5c22369cffca40cc3c99638bde1b3ec89cb44040f3e62376','2026-11-13 11:42:21','2026-10-14 11:57:22','2026-10-14 03:42:21'),(113,1,'8965473b6c970abe729e3150b99cfe654347af127335822061bf825abf35e51e','2026-11-13 11:47:10','2026-10-14 11:52:11','2026-10-14 03:47:10'),(114,1,'6db70018092c54a2e5cca197908f4c9a84e05ff487b1b1115387f4b37b3e51e3','2026-11-13 11:52:11','2026-10-14 11:57:12','2026-10-14 03:52:11'),(115,5,'d61ed7f7c01ecba54a3e50ebbd9c651d27a2e68d5a12dc82d7d22c10f705d6e1','2026-11-13 11:56:48','2026-10-14 12:11:49','2026-10-14 03:56:48'),(116,1,'3658308fb7d058784fa67d8a82f0489662de0e9b8fec0f0cdd4e270e697a597f','2026-11-13 11:57:12','2026-10-14 12:02:13','2026-10-14 03:57:12'),(117,6,'4614d843f83865d4f2dcd99af263b4ce3a2c5cdf131aa3d81e12c79e9f300be8','2026-11-13 11:57:14','2026-10-14 12:12:15','2026-10-14 03:57:14'),(118,2,'cdf2cde77e892cbc4a9862404afc9f389e42557ff796ef6dc08a6fdfd479f05f','2026-11-13 11:57:22','2026-10-14 12:12:29','2026-10-14 03:57:22'),(119,1,'276dd80eb2d3f663079bc4facec5fa653d53bb1c4aac65e36ef98bb89d5ea3a8','2026-11-13 12:02:13','2026-10-14 12:07:14','2026-10-14 04:02:13'),(120,1,'9d684aa658541f67833f5dd67d2e59ba4caebe69685d2e91829beee9bd73fda9','2026-11-13 12:07:14','2026-10-14 12:12:14','2026-10-14 04:07:14'),(121,5,'68a236aad45a5bc52b2a5df456e0a2a6d7333cb506442c2aa52f11ff6d712149','2026-11-13 12:11:49','2026-10-14 12:26:50','2026-10-14 04:11:49'),(122,1,'477ce564293e6b63529e0a159004e548e8b9682bc9e95c67dce8ed64aad8c553','2026-11-13 12:12:14','2026-10-14 12:17:15','2026-10-14 04:12:14'),(123,6,'991b829ca85068e3d8390ef1943ed01e8154aaa8da3187d4e7e9c36972401457','2026-11-13 12:12:15','2026-10-14 12:27:16','2026-10-14 04:12:15'),(124,2,'3e3100c82c4c4c67c38eb1d22a780f80f1a425d48006e294d347af4758a5d3f6','2026-11-13 12:12:29','2026-10-14 12:27:30','2026-10-14 04:12:29'),(125,5,'fa8e671e58bfb63966fd9499dd60ae25ab655421eff2e07a658cf3781d254ea8','2026-11-13 12:12:37',NULL,'2026-10-14 04:12:37'),(126,1,'bf89414812ed179bad0eef7c7a9e3cb26393157e28302e2edc2c7b2ecead1c7b','2026-11-13 12:12:43','2026-10-14 12:12:51','2026-10-14 04:12:43'),(127,3,'28416706ae8f18ef2c81e10e06586eeb2540b350a219277f215423df83db2152','2026-11-13 12:13:32','2026-10-14 12:28:33','2026-10-14 04:13:32'),(128,4,'841794b352a303c9c8986b93472161281db540e9b9d7ad65593d53c4b8e4efec','2026-11-13 12:17:07','2026-10-14 12:32:20','2026-10-14 04:17:07'),(129,1,'c76dfbdbdec3693a51ab9b71c732b96c0f91bf67cf34c09be5e392a4ad28fe50','2026-11-13 12:17:15','2026-10-14 12:22:16','2026-10-14 04:17:15'),(130,1,'157ae68544b2656d1e05ec2ff5ca4592054da4d263506b889735bb04f1e2de1c','2026-11-13 12:22:16','2026-10-14 12:27:16','2026-10-14 04:22:16'),(131,5,'d287f5d40f1f660328d7a7a2ae4f2d1e190d92a4924124ccabec83d8ba7fc895','2026-11-13 12:26:50','2026-10-14 12:41:51','2026-10-14 04:26:50'),(132,6,'ca872c6759d3f1ab210bc7b2973ae792b2865f4388934048019e3bdc2471a1f1','2026-11-13 12:27:16','2026-10-14 12:43:11','2026-10-14 04:27:16'),(133,1,'9c0679160cdc503ede24ef5587c2c6b4563e8835b891fadce2d134010458862b','2026-11-13 12:27:16','2026-10-14 12:32:16','2026-10-14 04:27:16'),(134,2,'140566372fd7263b2d36d68c3e3d11689825406a05bdad7e7c38a39e739f588b','2026-11-13 12:27:30','2026-10-14 12:42:31','2026-10-14 04:27:30'),(135,3,'b1389351c38e7f66708659fedca4e7253e15a54d8753e34cd8fe8cbe910a6089','2026-11-13 12:28:33','2026-10-14 12:43:49','2026-10-14 04:28:33'),(136,1,'19dd0bac63150efc9bf7748a0daaa6ffa03032487ac378625607cb31b35e696a','2026-11-13 12:32:16','2026-10-14 12:37:16','2026-10-14 04:32:16'),(137,4,'823f9c0328dc03f9b86a04e6f811a1f4029b653bc95308000cad9f6f83723f96','2026-11-13 12:32:20','2026-10-14 12:47:21','2026-10-14 04:32:20'),(138,1,'bbb25f3ab5f458148cf89b304f49b264647f563241faa69420c3992f0ed6f627','2026-11-13 12:37:16','2026-10-14 12:42:17','2026-10-14 04:37:16'),(139,5,'9d4c73845934a31ce400d8ee504c62a9f7ad6758326a739767e72f7c6c5e4ed2','2026-11-13 12:41:51','2026-10-14 12:57:09','2026-10-14 04:41:51'),(140,1,'8288e43ade988b9e2948b9842bc7de986a0197a44ac7ab71637cdfd09b62052f','2026-11-13 12:42:17','2026-10-14 12:47:17','2026-10-14 04:42:17'),(141,2,'b76b7e6bceaafa207aa034a7ade8e3954653f5e040a008d6cd410dbed8b9525f','2026-11-13 12:42:31','2026-10-14 12:57:32','2026-10-14 04:42:31'),(142,6,'5ee50262278fbe016ecd6302afe88bfbadd2b3438654b671734dfaeb838f03f2','2026-11-13 12:43:11','2026-10-14 12:58:12','2026-10-14 04:43:11'),(143,3,'a8203c093ad1d199d0767295d1e7985700a77c75e36eb20f0fa8e4f423d19858','2026-11-13 12:43:49','2026-10-14 12:58:50','2026-10-14 04:43:49'),(144,1,'cc277af68c49dfe76739e4bad581b2a492ede394b16327f0dbb85ac6b9f6af70','2026-11-13 12:47:17','2026-10-14 12:52:18','2026-10-14 04:47:17'),(145,4,'10225dc8e4882670690ea0f1a4ccfb39d7c6de1840769c04cf787d7b9ed7895a','2026-11-13 12:47:21','2026-10-14 13:02:22','2026-10-14 04:47:21'),(146,1,'ef0a1c2595e7c912edc6953bc8c90685008435f41fca88a33baa542021384316','2026-11-13 12:52:18','2026-10-14 12:57:19','2026-10-14 04:52:18'),(147,5,'11200181a706f8f65a0fa5aac69698dd64fc6a6bbc0f02f75064e5995c95d4bd','2026-11-13 12:57:09','2026-10-14 13:12:10','2026-10-14 04:57:09'),(148,1,'250e3b63540544f4b395699fafa2491f2e0d5850ba1c2706a9add7c0e5da0ed2','2026-11-13 12:57:19','2026-10-14 13:02:20','2026-10-14 04:57:19'),(149,2,'12ad38d11d0781be7e84767d4d0692e31a8ff621a93eee80c385c979978f8982','2026-11-13 12:57:32','2026-10-14 13:12:33','2026-10-14 04:57:32'),(150,6,'c9ebbfceb9784d1becb1f1e4e83f1f0692408b7a94e70ece920d8cf5c969b462','2026-11-13 12:58:12','2026-10-14 13:13:13','2026-10-14 04:58:12'),(151,3,'d5a68df77b59c54cf2d094844a9da88fd4cb086fc42337678706bce02ccb27a1','2026-11-13 12:58:50','2026-10-14 13:13:51','2026-10-14 04:58:50'),(152,1,'d9f16f50e20eff384ba45b4a1f7e14cbd252578f1d777df2215fe4f2f7896c0a','2026-11-13 13:02:20','2026-10-14 13:07:21','2026-10-14 05:02:20'),(153,4,'1e5e970cdd09ab4354b1e0c5bef583043283980e7e95f6ddf8d10d2df9fe0052','2026-11-13 13:02:22','2026-10-14 13:17:23','2026-10-14 05:02:22'),(154,1,'d41fbd77e3ca220a86b5e40fe6298560bf8b0d8de7bbbb4e64620e6bf721ba5a','2026-11-13 13:07:21','2026-10-14 13:13:10','2026-10-14 05:07:21'),(155,5,'f29841673e70c691136ce0364d3c8d6760a57712dc21abff482c2122c815a6f3','2026-11-13 13:12:10','2026-10-14 13:27:11','2026-10-14 05:12:10'),(156,2,'5ca61711a9e10632c21dabddd7e028fde428cafc0547d2e2875a90a2ed783ae1','2026-11-13 13:12:33','2026-10-14 13:28:29','2026-10-14 05:12:33'),(157,1,'ed927c0945f8b350b2e164bf394b300aaff178cf835872185ce1661f556f33e3','2026-11-13 13:13:10','2026-10-14 13:18:11','2026-10-14 05:13:10'),(158,6,'4e67bc896a73111620fd7c5b1f99601009f2e7de0f7c561d8edf586eb010eee3','2026-11-13 13:13:13','2026-10-14 13:28:14','2026-10-14 05:13:13'),(159,3,'0a812277f1568f08b7e4399d7aaf71cecf84eab77c58cfc879e0b10a1cd79e22','2026-11-13 13:13:51','2026-10-14 13:28:52','2026-10-14 05:13:51'),(160,4,'aa61560a811263d4785ea6ab24a572c530dca02620758fc651fdb5b14ba4c1ed','2026-11-13 13:17:23','2026-10-14 13:32:24','2026-10-14 05:17:23'),(161,1,'9efe85022c469f55746719629e66da266d5e2c4cbdbe837a18a7fdb7e5e7a56a','2026-11-13 13:18:11','2026-10-14 13:23:12','2026-10-14 05:18:11'),(162,1,'b656622174cc1fdc73cd10f97ba99e2836762dc229c10401392ec7391c3bc002','2026-11-13 13:23:12','2026-10-14 13:28:12','2026-10-14 05:23:12'),(163,5,'1fbf47a64648e20a106affccbbfe65de4102c05df93e7f6aecccfdb5f84f6a16','2026-11-13 13:27:11','2026-10-14 14:24:45','2026-10-14 05:27:11'),(164,1,'c9443d92e5373383647e1d206edca9bf79dcdbf227f6617490612a209a3d2050','2026-11-13 13:28:12','2026-10-14 13:33:13','2026-10-14 05:28:12'),(165,6,'67f415d4cc7e31629b2e21aca1ff7460ade1acfaf1335f350c106a6511871f5d','2026-11-13 13:28:14','2026-10-14 14:27:42','2026-10-14 05:28:14'),(166,2,'6454e2995a86344edee3dba8c357741e71c3e3b60541506324ce9aa3c2ddc5f9','2026-11-13 13:28:29','2026-10-14 14:22:29','2026-10-14 05:28:29'),(167,3,'071064cd32776278d394e0231b95f2072abaced3af99124b7a5374da595e1fe8','2026-11-13 13:28:52','2026-10-14 14:27:53','2026-10-14 05:28:52'),(168,4,'e5c7e4074ec1e7c7b3f7260d3660cce3794947537b932a8fa0ef24478929499a','2026-11-13 13:32:24','2026-10-14 14:27:47','2026-10-14 05:32:24'),(169,1,'ddf2035f20efaa1c94ec9ec9312f767f0042c7d899b0ac1623c42e3e225b7a25','2026-11-13 13:33:13','2026-10-14 13:38:14','2026-10-14 05:33:13'),(170,1,'27c93ace3253f1fb58b436e06e3467a5676a455e3c1b07c337d8481bc2cf8e27','2026-11-13 13:38:14','2026-10-14 14:17:30','2026-10-14 05:38:14'),(171,1,'027399fa3d70ff30c4ba3dce82733a349f83c567c07c77dcb3f8d5e9ed5842b2','2026-11-13 14:17:30','2026-10-14 14:22:32','2026-10-14 06:17:30'),(172,2,'eda2a349d72bb1bfe5420a7b06c1215881c3cb513ebc8a0ba02c779929338de3','2026-11-13 14:22:29','2026-10-14 14:38:19','2026-10-14 06:22:29'),(173,1,'2a76a0e921e04de1b95fa43e67ceb7c537fd9d28e5eb351d207424c89c9f4709','2026-11-13 14:22:32','2026-10-14 14:27:33','2026-10-14 06:22:32'),(174,5,'6025a39d08c420eb6487a33c56352b55f1b3f177e54a8ca79d7467b97106bd6a','2026-11-13 14:24:45','2026-10-14 14:39:46','2026-10-14 06:24:45'),(175,1,'a8b148b7c923adf2e620e83ca578621d70a791899b264ab63204a603b10e6cd1','2026-11-13 14:27:33','2026-10-14 14:32:33','2026-10-14 06:27:33'),(176,6,'652bd7702fadafbb4e8c202aa44f1edb5b6bbe4041026c3842f829b9a6c83221','2026-11-13 14:27:42','2026-10-14 14:42:54','2026-10-14 06:27:42'),(177,4,'90a4dbe19e078ca9a15ceb5d1ddc2bc672e1c174232ba6670635f396deb51162','2026-11-13 14:27:47','2026-10-14 14:43:09','2026-10-14 06:27:47'),(178,3,'ecfaab01302d23818971b0c093647351f495bf51aa64043d53d202ec5585d673','2026-11-13 14:27:53','2026-10-14 14:43:15','2026-10-14 06:27:53'),(179,1,'ccf3067ab078ffbe3736d090a62c27938810a62bccda2027a6806b9503eef667','2026-11-13 14:32:33','2026-10-14 14:37:34','2026-10-14 06:32:33'),(180,1,'de85cdcf35221100b831a0aad2ea1f7a2f30dd32ab1d74e86ca11aaeb557fe27','2026-11-13 14:37:34','2026-10-14 14:42:35','2026-10-14 06:37:34'),(181,2,'352c8fefba4b0e229bc3dd95d31cc3122c4bca5304d7c196a4ef0edd9bbcdac7','2026-11-13 14:38:19',NULL,'2026-10-14 06:38:19'),(182,5,'276644dd61ad498af64edc1ce3549f20516bce5a0ed4432cc6c7a1e56afd2f91','2026-11-13 14:39:46',NULL,'2026-10-14 06:39:46'),(183,1,'40c8caffe11e76781ab4583daa5478f4bea9d9282a9fddc5dd1b087a463245b5','2026-11-13 14:42:35',NULL,'2026-10-14 06:42:35'),(184,6,'f79f442d49e3bb7c38312dfa898bc88a7ef7e5d71db01f0cbc756d13bc8e760b','2026-11-13 14:42:54',NULL,'2026-10-14 06:42:54'),(185,4,'dbd0e3f0eb926f0035092acaa02c50924fc4cfa37bf136bf2cb83f1129c6e37b','2026-11-13 14:43:09',NULL,'2026-10-14 06:43:09'),(186,3,'8fa8a6dc3088078e9f6c2c31ecd08d05b2ad9ced0627bec140e65edf3da21027','2026-11-13 14:43:15',NULL,'2026-10-14 06:43:15');
/*!40000 ALTER TABLE `session_refresh_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suppliers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `supplier_code` varchar(40) NOT NULL,
  `name` varchar(160) NOT NULL,
  `email` varchar(190) DEFAULT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `status` enum('ACTIVE','ARCHIVED') NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `supplier_code` (`supplier_code`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (5,'SUP-7F933D44FA','UNILAB','support@unilab.ph','','ACTIVE','2026-10-13 14:13:14','2026-10-13 14:13:14'),(6,'SUP-CE8F826D77','UNILAB','UNILAB@GMAIL.COM','','ACTIVE','2026-10-14 06:40:14','2026-10-14 06:40:14');
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `treatment_dockets`
--

DROP TABLE IF EXISTS `treatment_dockets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `treatment_dockets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `docket_number` varchar(40) NOT NULL,
  `patient_id` bigint unsigned NOT NULL,
  `appointment_id` bigint unsigned DEFAULT NULL,
  `dermatologist_id` bigint unsigned DEFAULT NULL,
  `therapist_id` bigint unsigned DEFAULT NULL,
  `service_id` bigint unsigned NOT NULL,
  `status` enum('DRAFT','READY','IN_PROGRESS','COMPLETED','CANCELLED') NOT NULL DEFAULT 'DRAFT',
  `payment_status` enum('PENDING','PARTIAL','PAID') NOT NULL DEFAULT 'PENDING',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `docket_number` (`docket_number`),
  KEY `fk_dockets_appointment` (`appointment_id`),
  KEY `fk_dockets_dermatologist` (`dermatologist_id`),
  KEY `fk_dockets_therapist` (`therapist_id`),
  KEY `fk_dockets_service` (`service_id`),
  KEY `idx_dockets_patient` (`patient_id`),
  KEY `idx_dockets_status` (`status`),
  CONSTRAINT `fk_dockets_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`),
  CONSTRAINT `fk_dockets_dermatologist` FOREIGN KEY (`dermatologist_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_dockets_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`),
  CONSTRAINT `fk_dockets_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`),
  CONSTRAINT `fk_dockets_therapist` FOREIGN KEY (`therapist_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treatment_dockets`
--

LOCK TABLES `treatment_dockets` WRITE;
/*!40000 ALTER TABLE `treatment_dockets` DISABLE KEYS */;
/*!40000 ALTER TABLE `treatment_dockets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `role_id` bigint unsigned NOT NULL,
  `full_name` varchar(160) NOT NULL,
  `email` varchar(190) NOT NULL,
  `password_hash` varchar(100) NOT NULL,
  `status` enum('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_users_role` (`role_id`),
  KEY `idx_users_status` (`status`),
  KEY `idx_users_name` (`full_name`),
  CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,'Mondejar, Shin','admin@dermaclinic.test','$2a$10$NUkndv2.L7xZ8KaKlBULzeG9F/CPQ4P2K1q7TlEO4TAYX5fgWNOra','ACTIVE','2026-09-16 13:14:55','2026-09-25 16:59:31',0),(2,2,'Jamer','reception@dermaclinic.test','$2a$10$uSe7q35Dp37segXWOL6IKOO60/7WiSkv1h2wwDXxKGficGeGav1U.','ACTIVE','2026-09-16 13:14:55','2026-09-28 11:34:23',0),(3,3,'Dr. Jem','dermatologist@dermaclinic.test','$2a$10$kCdOjQ9I.In27bu4p/HTEudo4KN3S2IK0KG7J0EzH6UcxCp5AUvpG','ACTIVE','2026-09-16 13:14:55','2026-10-12 06:53:34',0),(4,4,'Queencel','therapist@dermaclinic.test','$2a$10$THVDnp1YZNY5ZwiPB.0cF.28JEorHH1CGAZrJt3.usEfkXh0mci4u','ACTIVE','2026-09-16 13:14:55','2026-09-28 11:34:56',0),(5,5,'Justine','cashier@dermaclinic.test','$2a$10$Q9TZofgOqkwE0rjRZuHf5OEgZ/e6GfBlqpFvl6Q6zwdKLXwf5vrGq','ACTIVE','2026-09-16 13:14:55','2026-10-12 06:53:19',0),(6,6,'Ralph','inventory@dermaclinic.test','$2a$10$vzm4mWFVDTpaC8rK2mwiCOxFrKGXQ6Pn.uC1wzq4Z1F4I6zx8YDsq','ACTIVE','2026-09-16 13:14:55','2026-10-12 06:53:12',0),(7,2,'Database Test User','created-b1b73013@example.test','$2a$10$rhKgwSD8r8jqvlRBV2nBveFNMLnvrFUwxj9R4Pnuf1KnXCRd72yn2','INACTIVE','2026-09-24 06:10:41','2026-09-24 06:10:41',1),(8,1,'mondejar','mondejar@gmail.com','$2a$10$oZRjt8iX5HxhjWLKHGbA9O8Zsgvblvm7sydm5RVpwpDpQGnzvlH12','INACTIVE','2026-09-24 06:41:18','2026-10-12 06:52:55',1),(9,1,'Mondejarwashington','mondejar041921@gmail.com','$2a$10$yeMvu52XWIoH/86KRXlPM.zAkAmJne8Wqlkfc86xcbTfT2hH7TSG2','INACTIVE','2026-09-24 07:16:44','2026-10-12 06:52:52',1),(10,2,'Mondejar, Washington B.','Mondejarshin@dermaclinic.test','$2a$10$N5J46Y5RJQdhLmMDho6Ggu7F6CJgvP8I5O.Dwmo5F4qNrYVkHzGSW','INACTIVE','2026-09-24 07:20:45','2026-10-12 06:52:47',1),(11,5,'shinmondejar','shin@dermaclinic.test','$2a$10$RNJsz5coHOzqSgZTuuBNOOcp7VBjjdUTKtFFK4bN5d0YP.J64CujC','INACTIVE','2026-09-24 07:26:26','2026-10-12 06:52:43',1),(12,6,'fujimiyakun','fujimiyakun0441921@dermaclinic.test','$2a$10$IFSs6SZ9/deDu17nNpVUYu88s2Fq.B.MVCmIbtHuL3uPrgDXLnZXu','INACTIVE','2026-09-24 07:29:25','2026-10-12 06:44:21',1),(13,1,'Mondejar, Washington B.','Mondejarwashington041921@gmail.com','$2a$10$b1bP9C.ESdgQcVJBu5T0PeuxxrAv0PGKUJXIAdFDtFadk/g0k9lVK','INACTIVE','2026-09-24 09:50:10','2026-10-12 06:44:18',1),(14,1,'kenshin','kenshin041921@gmail.com','$2a$10$acgE6Kd1qbkcMow5nOsnqOsJyZFzQX1CATQl0I4GOmq3Zk83ROSHS','INACTIVE','2026-09-25 08:41:04','2026-10-12 06:44:14',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-14 22:45:48
