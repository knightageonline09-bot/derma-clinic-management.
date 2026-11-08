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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (59,1,'Patients','QR_GENERATE','7','454f6759c26ef2514d58e87a329ddb7dbf925c1942454dee6042bc9c87415cfc','{\"generated\": true}','2026-10-13 09:56:20'),(60,1,'Patients','QR_ACCESS','7','454f6759c26ef2514d58e87a329ddb7dbf925c1942454dee6042bc9c87415cfc','{\"scanner\": \"admin@dermaclinic.test\"}','2026-10-13 09:56:47'),(61,1,'Patients','QR_ACCESS','7','454f6759c26ef2514d58e87a329ddb7dbf925c1942454dee6042bc9c87415cfc','{\"scanner\": \"admin@dermaclinic.test\"}','2026-10-13 09:56:59'),(62,1,'Patients','QR_GENERATE','7','454f6759c26ef2514d58e87a329ddb7dbf925c1942454dee6042bc9c87415cfc','{\"generated\": false}','2026-10-13 09:57:02'),(63,1,'Patients','QR_ACCESS','7','454f6759c26ef2514d58e87a329ddb7dbf925c1942454dee6042bc9c87415cfc','{\"scanner\": \"admin@dermaclinic.test\"}','2026-10-13 09:57:08'),(64,1,'Patients','QR_GENERATE','8','b506c5bde20f750054a1f56a8c94da0824fd0ea9bbfa323b6fea215b3fff138e','{\"generated\": true}','2026-10-13 14:01:08'),(65,1,'Patients','QR_ACCESS','8','b506c5bde20f750054a1f56a8c94da0824fd0ea9bbfa323b6fea215b3fff138e','{\"scanner\": \"admin@dermaclinic.test\"}','2026-10-13 14:01:36'),(66,1,'Patients','QR_ACCESS','8','b506c5bde20f750054a1f56a8c94da0824fd0ea9bbfa323b6fea215b3fff138e','{\"scanner\": \"admin@dermaclinic.test\"}','2026-10-13 14:02:25'),(67,1,'Patients','QR_ACCESS','8','b506c5bde20f750054a1f56a8c94da0824fd0ea9bbfa323b6fea215b3fff138e','{\"scanner\": \"admin@dermaclinic.test\"}','2026-10-13 14:02:30'),(68,1,'Patients','QR_GENERATE','8','b506c5bde20f750054a1f56a8c94da0824fd0ea9bbfa323b6fea215b3fff138e','{\"generated\": false}','2026-10-13 14:02:44'),(69,1,'Patients','QR_GENERATE','8','b506c5bde20f750054a1f56a8c94da0824fd0ea9bbfa323b6fea215b3fff138e','{\"generated\": false}','2026-10-13 14:03:30'),(70,1,'Patients','QR_GENERATE','8','b506c5bde20f750054a1f56a8c94da0824fd0ea9bbfa323b6fea215b3fff138e','{\"generated\": false}','2026-10-13 14:03:57'),(71,1,'Patients','QR_GENERATE','8','b506c5bde20f750054a1f56a8c94da0824fd0ea9bbfa323b6fea215b3fff138e','{\"generated\": false}','2026-10-13 14:04:16'),(72,1,'Patients','QR_GENERATE','8','b506c5bde20f750054a1f56a8c94da0824fd0ea9bbfa323b6fea215b3fff138e','{\"generated\": false}','2026-10-13 14:05:03'),(73,1,'Inventory','SUPPLIER_CREATED','5','SUP-7F933D44FA','{\"name\": \"UNILAB\"}','2026-10-13 14:13:14'),(74,1,'Inventory','PRODUCT_CREATED','9865432169','9865432169','{\"supplierId\": \"5\"}','2026-10-13 14:15:02'),(75,1,'Inventory','MOVEMENT_RECORDED','34','UNILAB','{\"type\": \"STOCK_IN\", \"quantity\": \"20\", \"newQuantity\": \"20\"}','2026-10-13 14:16:39'),(76,1,'Inventory','MOVEMENT_RECORDED','34','UNILAB','{\"type\": \"STOCK_IN\", \"quantity\": \"19\", \"newQuantity\": \"39.000\"}','2026-10-13 14:17:12'),(77,1,'Inventory','MOVEMENT_RECORDED','34','UNILAB','{\"type\": \"STOCK_IN\", \"quantity\": \"5\", \"newQuantity\": \"44.000\"}','2026-10-13 14:17:47'),(78,1,'Inventory','MOVEMENT_RECORDED','34','UNILAB','{\"type\": \"STOCK_IN\", \"quantity\": \"1\", \"newQuantity\": \"45.000\"}','2026-10-13 14:18:03'),(79,2,'Patients','QR_ACCESS','8','b506c5bde20f750054a1f56a8c94da0824fd0ea9bbfa323b6fea215b3fff138e','{\"scanner\": \"reception@dermaclinic.test\"}','2026-10-13 14:32:24'),(80,3,'Consultations','CONSULTATION_CREATED','9','CON-7BBBA726F4',NULL,'2026-10-13 14:42:58'),(81,1,'Consultations','CONSULTATION_CREATED','9','CON-C1A753CED5',NULL,'2026-10-13 14:43:23'),(82,1,'Inventory','PRODUCT_ARCHIVED','34','ARCHIVED','{\"status\": \"ARCHIVED\"}','2026-10-13 14:49:27'),(83,1,'Inventory','PRODUCT_RESTORED','34','ACTIVE','{\"status\": \"ACTIVE\"}','2026-10-13 14:55:54'),(84,1,'Inventory','MOVEMENT_RECORDED','34','UNILAB','{\"type\": \"STOCK_IN\", \"quantity\": \"1\", \"newQuantity\": \"46.000\"}','2026-10-13 15:05:47'),(85,1,'Patients','QR_GENERATE','9','dda723f85b4448e44e08aa5c49f74a7935e048d95e481c9b6f3215ae30bd01e1','{\"generated\": true}','2026-10-13 15:11:11'),(86,1,'Patients','QR_ACCESS','9','dda723f85b4448e44e08aa5c49f74a7935e048d95e481c9b6f3215ae30bd01e1','{\"scanner\": \"admin@dermaclinic.test\"}','2026-10-13 15:11:19');
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
INSERT INTO `consultations` VALUES (1,'CON-7BBBA726F4',9,NULL,3,'skin cancer','skin detox','Check-up 2/Month','Every 2weeks','2026-10-20','2026-10-13 14:42:58'),(2,'CON-C1A753CED5',9,NULL,1,'skin cancer','skin detox','Check-up 2/Month','Every 2weeks','2026-10-27','2026-10-13 14:43:23');
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
INSERT INTO `flyway_schema_history` VALUES (1,'1','<< Flyway Baseline >>','BASELINE','<< Flyway Baseline >>',NULL,'root','2026-09-16 13:11:00',0,1),(2,'2','seed roles','SQL','V2__seed_roles.sql',-1369780179,'root','2026-09-16 13:14:55',106,1),(3,'3','fix development password hashes','SQL','V3__fix_development_password_hashes.sql',511361378,'root','2026-09-17 14:33:04',63,1),(4,'4','set staff development password hashes','SQL','V4__set_staff_development_password_hashes.sql',-19219740,'root','2026-09-17 16:04:52',19,1),(5,'5','remove non admin development accounts','SQL','V5__remove_non_admin_development_accounts.sql',-1064234823,'root','2026-09-24 06:07:57',28,1),(6,'6','restore development staff accounts','SQL','V6__restore_development_staff_accounts.sql',199569236,'root','2026-09-24 08:38:43',37,1),(7,'7','seed requested inventory','SQL','V7__seed_requested_inventory.sql',2086536922,'root','2026-09-25 07:41:27',320,1),(8,'8','link services to required products','SQL','V8__link_services_to_required_products.sql',694103836,'root','2026-09-28 07:50:04',24,1),(9,'9','add consultation follow up date','SQL','V9__add_consultation_follow_up_date.sql',-397423900,'root','2026-09-28 08:31:32',363,1),(10,'10','add patient skin type and allergies','SQL','V10__add_patient_skin_type_and_allergies.sql',-110423083,'root','2026-09-28 09:42:25',187,1),(11,'11','canonicalise role names','SQL','V11__canonicalise_role_names.sql',191968059,'derma_flyway','2026-10-13 10:25:42',50,1);
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
INSERT INTO `inventory_balances` VALUES (34,46.000,'2026-10-13 15:05:47');
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_batches`
--

LOCK TABLES `inventory_batches` WRITE;
/*!40000 ALTER TABLE `inventory_batches` DISABLE KEYS */;
INSERT INTO `inventory_batches` VALUES (18,34,'B-1-101326','2027-10-13','2026-10-13 14:16:39'),(19,34,'B-2-101326','2027-10-13','2026-10-13 15:05:47');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_movements`
--

LOCK TABLES `inventory_movements` WRITE;
/*!40000 ALTER TABLE `inventory_movements` DISABLE KEYS */;
INSERT INTO `inventory_movements` VALUES (2,34,18,NULL,'STOCK_IN',0.000,0.000,20.000,'UNILAB',1,'2026-10-13 14:16:39'),(3,34,18,NULL,'STOCK_IN',20.000,0.000,39.000,'UNILAB',1,'2026-10-13 14:17:12'),(4,34,18,NULL,'STOCK_IN',39.000,0.000,44.000,'UNILAB',1,'2026-10-13 14:17:47'),(5,34,18,NULL,'STOCK_IN',44.000,0.000,45.000,'UNILAB',1,'2026-10-13 14:18:03'),(6,34,19,NULL,'STOCK_IN',45.000,0.000,46.000,'UNILAB',1,'2026-10-13 15:05:47');
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  KEY `idx_patients_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (7,'PT-5BFB7ACB','Mondejar, Washington B.','Mondejarwashington@gmail.com','+63 9243078998','2005-04-19',NULL,NULL,'ARCHIVED','2026-10-13 09:56:00','2026-10-13 11:20:08'),(8,'PT-76DD4E5B','Washington B. Mondejar','fujimiyakun04419@gmail.com','+639123456789','2000-04-19',NULL,NULL,'ARCHIVED','2026-10-13 13:54:01','2026-10-13 14:05:39'),(9,'PT-594682B1','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2026-10-13',NULL,NULL,'ACTIVE','2026-10-13 14:31:06','2026-10-13 14:31:06'),(10,'PT-BEBE79C1','Washington B. Mondejar','Mondejarwashington@gmail.com','+639123456789','2026-10-14',NULL,NULL,'ACTIVE','2026-10-13 14:44:53','2026-10-13 14:44:53');
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (34,5,'9865432169','Hydrochloric Acid','12',3.000,'ACTIVE','2026-10-13 14:15:02','2026-10-13 14:55:54');
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
INSERT INTO `secure_qr_references` VALUES (2,'454f6759c26ef2514d58e87a329ddb7dbf925c1942454dee6042bc9c87415cfc',7,NULL,NULL,NULL,1,'2026-10-13 09:56:20'),(3,'b506c5bde20f750054a1f56a8c94da0824fd0ea9bbfa323b6fea215b3fff138e',8,NULL,NULL,NULL,1,'2026-10-13 14:01:08'),(4,'dda723f85b4448e44e08aa5c49f74a7935e048d95e481c9b6f3215ae30bd01e1',9,NULL,NULL,NULL,1,'2026-10-13 15:11:11');
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=318 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_refresh_tokens`
--

LOCK TABLES `session_refresh_tokens` WRITE;
/*!40000 ALTER TABLE `session_refresh_tokens` DISABLE KEYS */;
INSERT INTO `session_refresh_tokens` VALUES (80,1,'9d50f14b0077433016d84ed90b97c64be0aa19b6f305e1680607f269b20db8c2','2026-11-12 09:52:59',NULL,'2026-10-13 01:52:59'),(81,1,'902f96e3c795023f697e809df9e9c300712df3f45bcd027ead648f0f645bce2e','2026-11-12 09:53:19','2026-10-13 09:58:19','2026-10-13 01:53:19'),(82,1,'bed8184926efade4ca4b0eff11e642af7cbd5f4bb636af38026e97c4735e895e','2026-11-12 09:55:15','2026-10-13 10:00:16','2026-10-13 01:55:15'),(83,1,'ba38fbd7e400cc77767ad22b4ffccaeb21fc6b057d3372d766b17f1a65beb18b','2026-11-12 09:56:47','2026-10-13 09:57:15','2026-10-13 01:56:47'),(84,1,'c1aea8364f92b9102cad82b6c031223e26f4cfc393a1537a1cf6297d2e3b846c','2026-11-12 09:57:08','2026-10-13 09:57:12','2026-10-13 01:57:08'),(85,1,'2e05c1733d12861bb3b61dfbb2ff1ca21b0297ce902dec8f8eaa1615e286f20e','2026-11-12 09:58:19','2026-10-13 10:03:19','2026-10-13 01:58:19'),(86,1,'4a98b12676e07ad479405c1c176480aa5831c734eb8343be086b28b693c51115','2026-11-12 09:58:19','2026-10-13 10:03:19','2026-10-13 01:58:19'),(87,1,'aa6b6e05b2e4b7b5d231768fa04ee208b751dec5484b2d12e5a7b7a3dbfee78b','2026-11-12 10:00:16','2026-10-13 10:05:16','2026-10-13 02:00:16'),(88,1,'8f42f0efeefdeac7c3be520e4878ed0b4b94d0d3329cc571187bc690fbf90b6a','2026-11-12 10:03:19','2026-10-13 10:08:19','2026-10-13 02:03:19'),(89,1,'594097ef92bf1bf029ec1fa128d91be52501801ff5eaa043c291118d133d0e01','2026-11-12 10:03:19',NULL,'2026-10-13 02:03:19'),(90,1,'0a5f64e35eeb5ac56a2f286bd3e7d975da6f2fb77769a5896fb07a96c241ff12','2026-11-12 10:05:16',NULL,'2026-10-13 02:05:16'),(91,1,'ff67499c6d6277158f65a41db555f3c7d3bbd9762f2a11bbaa34e8f2dd043132','2026-11-12 10:08:19','2026-10-13 10:13:19','2026-10-13 02:08:19'),(92,1,'829623aaceda62e73e0c99b69a9a6272089f1595cca4bb6b97477e1614c52fa8','2026-11-12 10:08:19',NULL,'2026-10-13 02:08:19'),(93,1,'0868d0a9d6915e2e865150b7ba89be752dd03728dc2b7668d9e7b939edd656e0','2026-11-12 10:08:44','2026-10-13 10:14:00','2026-10-13 02:08:44'),(94,1,'684ee95d32044294326f235ce618252eda2cd585551ccb9115f00356be573c67','2026-11-12 10:09:28','2026-10-13 10:14:44','2026-10-13 02:09:28'),(95,2,'05cf9df70a2b31ea2cef501df2b01e01e641148926e407e9b90b8c5580f9084e','2026-11-12 10:12:24','2026-10-13 10:28:05','2026-10-13 02:12:24'),(96,2,'b2a2aa4c7a172933c1b2670723caf907aa2777ea7d6e1742be238935bb2c3352','2026-11-12 10:12:45',NULL,'2026-10-13 02:12:45'),(97,3,'40a536455133e078662d72aec2d33b98089b415920e93cd5da456944bae167b4','2026-11-12 10:13:13','2026-10-13 10:28:26','2026-10-13 02:13:13'),(98,1,'7ab86b8ab893b5503a11caf0528875d97e7ca14f3ec401034c3d8aabd91294ec','2026-11-12 10:13:19','2026-10-13 10:18:19','2026-10-13 02:13:19'),(99,4,'850e9d2847cfa4bd9886e39945b24d220eb360d820369b7b9deaa16402ed6e92','2026-11-12 10:13:48','2026-10-13 10:28:48','2026-10-13 02:13:48'),(100,1,'26e3868cd4cafdea6610f6ca851bf2f5732ed8e02f6a2d5b1bce25a96e17edd9','2026-11-12 10:14:00',NULL,'2026-10-13 02:14:00'),(101,1,'9efc8fbcc8da3564978b236572c1cafae66cdbeb01b216d86e8865626b898ab1','2026-11-12 10:14:44','2026-10-13 10:19:46','2026-10-13 02:14:44'),(102,5,'b24e392b70756bf2e4218b37e2ea18dfb68891b0a1a485b379736a7a2a78c466','2026-11-12 10:15:05','2026-10-13 10:30:05','2026-10-13 02:15:05'),(103,6,'b833e53d4c894b556d649811af143f8fb1471e5f0ddfb2f6ebc7573ba8761d22','2026-11-12 10:15:53',NULL,'2026-10-13 02:15:53'),(104,6,'3e053f093cf051c2c56daeec7fbe4c6483b89441dd8abc3ccfea5709b9f438b2','2026-11-12 10:16:31',NULL,'2026-10-13 02:16:31'),(105,6,'569433191618790cf528570cb9d3c1b4ff8a4584bfca1060648cb866c06917da','2026-11-12 10:16:36',NULL,'2026-10-13 02:16:36'),(106,6,'2d0d401f9da79e2e2c24450c124fe536d16f5dcf286f6eecba1d950ce1cf3b7f','2026-11-12 10:16:57',NULL,'2026-10-13 02:16:57'),(107,6,'50ab193206579f85a373e5edf6bed00809eb4a422811ccd1db587df983ea5335','2026-11-12 10:16:58',NULL,'2026-10-13 02:16:58'),(108,6,'9ea33031ee9106e77e2e23692549a78545b4662b762af648a8ae222ae091864b','2026-11-12 10:16:58',NULL,'2026-10-13 02:16:58'),(109,6,'273b56df4e96a7dc59dffd8cb77609ba83b754705670b3f6626fc1190cfcc21d','2026-11-12 10:16:59',NULL,'2026-10-13 02:16:59'),(110,6,'ec79e293486a5eab5c92381f48b3fbb9d631302ecda1777db9be420c89f10ef8','2026-11-12 10:16:59',NULL,'2026-10-13 02:16:59'),(111,6,'14cb79a7bd8d2acd3d3b8fad0389234b69f32a35a9d5ecfc68bf8d0dfd7b0085','2026-11-12 10:16:59',NULL,'2026-10-13 02:16:59'),(112,6,'73f4d6648db497905ccf414dd17b6bc83152089be65c30102d648df26cc5acbb','2026-11-12 10:16:59',NULL,'2026-10-13 02:16:59'),(113,6,'c91f3affed73ab6e62a8653745a384f24cf1bc8a8dfb409d0adc691e92e74e24','2026-11-12 10:16:59',NULL,'2026-10-13 02:16:59'),(114,6,'692db03de4cc869ba66491ccb3bcdc7d9a46b5626ffc423d010924e1768b5721','2026-11-12 10:17:00',NULL,'2026-10-13 02:17:00'),(115,6,'078ac3ed8ca8a06d2cdafa7c2792c58869ca928f4d14945ff35f989b27f89cab','2026-11-12 10:17:00',NULL,'2026-10-13 02:17:00'),(116,6,'f4f228038dbbd3b48f718e93bb38b55a2785f3c461edb101ec49ee7224bd52d0','2026-11-12 10:17:00',NULL,'2026-10-13 02:17:00'),(117,6,'5ac56a0b18639d620f9e77122c02e1eb3d1253740fa518d7ff9c107d39c2462e','2026-11-12 10:17:01',NULL,'2026-10-13 02:17:01'),(118,6,'b420ed9dfc1684de05da03cb1d3bdfa2f5ca670154b10edc8204a8ed2975643d','2026-11-12 10:17:01',NULL,'2026-10-13 02:17:01'),(119,6,'3f9b20daf1fa69c1812bc839b1efc9fec0f2032058654de8bb72a0f8de3ae723','2026-11-12 10:17:01',NULL,'2026-10-13 02:17:01'),(120,6,'1c15804729afe23372c86373a82141b939a4c218ca911784b71752643fb9e0a1','2026-11-12 10:17:01',NULL,'2026-10-13 02:17:01'),(121,6,'3b2a9cca46420f5b76de1dc85c4d415c768bc7f2718587623827400987af522a','2026-11-12 10:17:02',NULL,'2026-10-13 02:17:02'),(122,6,'68c6448f51146860f6a43bad3b56078e88e76ec25db32efd0049360304ef6bda','2026-11-12 10:17:02',NULL,'2026-10-13 02:17:02'),(123,6,'2efd01702cba58db64ece6bfd179acff9933e5ab01ca56d4e1886467309a5fc6','2026-11-12 10:17:02',NULL,'2026-10-13 02:17:02'),(124,6,'a2de54e8f179a485d1612cd92074abae91d9af89d0b8c9f5ea9f4aa6b8ed9f2c','2026-11-12 10:17:02',NULL,'2026-10-13 02:17:02'),(125,6,'99f755073b1b866c783714deeb2c82fc2ac93f83d15591f394b64dcd877beece','2026-11-12 10:17:03',NULL,'2026-10-13 02:17:03'),(126,6,'c54cbeff04223932b0a302b1218137824e781f9e1b80c83c6b6df2125ffcabd6','2026-11-12 10:17:03',NULL,'2026-10-13 02:17:03'),(127,1,'d4db8679ec3b11339107ec337dfa68c134ebfc49b9f5c196b417be162515e509','2026-11-12 10:18:19','2026-10-13 10:23:20','2026-10-13 02:18:19'),(128,1,'d7f43f0f57550137aa851930964ad36f0123fc63d10eb038443407736c4d7003','2026-11-12 10:18:54',NULL,'2026-10-13 02:18:54'),(129,6,'d379708dc437bc7dc7884349dfc0ecbed6599183e4940ef05469f063a37b700a','2026-11-12 10:18:54',NULL,'2026-10-13 02:18:54'),(130,6,'7b89c68153122c7cdfb04b4900a92a47ecb6985266faa7ae95a42e5191253e4d','2026-11-12 10:19:14',NULL,'2026-10-13 02:19:14'),(131,1,'74aebeed86f72090ac1a29eb9e4c080f0af6cb191ed06d039f4acb952d43a0cb','2026-11-12 10:19:46','2026-10-13 10:24:46','2026-10-13 02:19:46'),(132,6,'ebfe0e10afea1319dd5ca017b162c52d6a302b8c186644ff2b482ad426c6b635','2026-11-12 10:20:35',NULL,'2026-10-13 02:20:35'),(133,1,'89d09258e1b668fed22983c0daa8e8cb66bb19d6b63f8862f6604214dbf86059','2026-11-12 10:23:20','2026-10-13 10:28:20','2026-10-13 02:23:20'),(134,1,'3b3a062ca641e93b86306858ecab2679b69f1691e63399660e53b7a5e1455034','2026-11-12 10:24:46','2026-10-13 10:29:47','2026-10-13 02:24:46'),(135,6,'ada5dfcbdef20cbb63317ddf88d7ba72127a8fbb3cea3941c73efbca8faa2513','2026-11-12 10:25:15',NULL,'2026-10-13 02:25:15'),(136,6,'b6e05b9c1deecd35ee5329165c2070a0f41bec9f6e931d59a8244c028c08d5a4','2026-11-12 10:26:29',NULL,'2026-10-13 02:26:29'),(137,1,'ea7f6d4397e3836ac6da214d64d0cabd001ffa35968ad91dc177c8672e13f73f','2026-11-12 10:26:30',NULL,'2026-10-13 02:26:30'),(138,2,'fd08bccf1008a52565f0f7823da30a838ddc97a7798bdb307522ae2973e1fffc','2026-11-12 10:28:05','2026-10-13 10:43:06','2026-10-13 02:28:05'),(139,1,'76c530df7326b44bc2befd171f3354dff82fc48d5e93191368a96da621d3b355','2026-11-12 10:28:20','2026-10-13 10:33:20','2026-10-13 02:28:20'),(140,3,'5628cc805c3c62951b54c4b0aa39d806de883dff0b0d77102d09ee86c2841336','2026-11-12 10:28:26','2026-10-13 10:43:26','2026-10-13 02:28:26'),(141,4,'090e7092e4aeaf8e765c93c7375d6a110387f450fa1a4086ea2c98f4b83d07df','2026-11-12 10:28:48','2026-10-13 10:44:23','2026-10-13 02:28:48'),(142,6,'c656568d2f070f46941e209feafeb87ec623dfd2e4aafae11c7bb28ae129aad8','2026-11-12 10:29:14','2026-10-13 10:44:14','2026-10-13 02:29:14'),(143,1,'12910cd3c2dae65eb32356d62169901d67b397fb90374746906a733d29c5f974','2026-11-12 10:29:47','2026-10-13 10:34:47','2026-10-13 02:29:47'),(144,5,'bf260dda20d2461d3344cbe41e2c9c354fb74365a5b6c86eb6e6421c654b9977','2026-11-12 10:30:05','2026-10-13 10:46:00','2026-10-13 02:30:05'),(145,1,'8877497831e0947c2a77962b1cf58d4b7ef4da0b323e1f8112c00fc92a89022e','2026-11-12 10:33:20','2026-10-13 10:38:20','2026-10-13 02:33:20'),(146,1,'825b9de4d280444b977756b20b3b86110d5e0f25987990faa518a5b9f169786b','2026-11-12 10:34:47','2026-10-13 10:39:48','2026-10-13 02:34:47'),(147,1,'cc47eede74a1d4e5121799db6a3e0a8962ef7ba161604ef13731b1b20afb0ac8','2026-11-12 10:38:20','2026-10-13 10:43:20','2026-10-13 02:38:20'),(148,1,'7ffe631b20687ed073dbbcbb839866737557174e99db870018f172b9560e49e4','2026-11-12 10:39:48','2026-10-13 10:44:49','2026-10-13 02:39:48'),(149,2,'f75aca7512fc1b01bd91318b74e0321fd2f5ad01d8910da8b41f0c3c299fc100','2026-11-12 10:43:06','2026-10-13 10:58:07','2026-10-13 02:43:06'),(150,1,'d2cd79a9ec20793136662fd20f6381cb0064d3a3b1f740d16d61cbfc31df1824','2026-11-12 10:43:20','2026-10-13 10:48:20','2026-10-13 02:43:20'),(151,3,'dbc043c897b3fb7b81756520a7b003fd0015183cfd7f09327dbff1f0181a2d54','2026-11-12 10:43:26','2026-10-13 10:58:45','2026-10-13 02:43:26'),(152,6,'ad15d6cdffe66da70d12eb69245e81623bb3c0cd3a8a5ac76d509e84c30adf2a','2026-11-12 10:44:14','2026-10-13 10:59:15','2026-10-13 02:44:14'),(153,4,'bb40afe87be724b8921694a1b8297e476afd68e404597ac2128f13159515cf32','2026-11-12 10:44:23','2026-10-13 10:59:24','2026-10-13 02:44:23'),(154,1,'354e1fcc8054ed0ec6ea03b425f9093a7ead40f4c27ad9976fae0c5695311f62','2026-11-12 10:44:49','2026-10-13 10:49:50','2026-10-13 02:44:49'),(155,5,'38b92df7dabc825f260f21b876097e11faf1b8d945fe981edbfaed366b8d2a46','2026-11-12 10:46:00','2026-10-13 11:01:01','2026-10-13 02:46:00'),(156,2,'dda59fb04a1f1941163c98c2efa7f682147a46a871137a01b7a963d596b16611','2026-11-12 10:46:38',NULL,'2026-10-13 02:46:38'),(157,2,'e928813d0167be6ceb5b004c3c3c09339d25be018ec8e95b69ba88c440f80d51','2026-11-12 10:47:10',NULL,'2026-10-13 02:47:10'),(158,1,'cbe5d2c2f757510ad2c274849393630dc30dbee5528365a37330c0c21740fd69','2026-11-12 10:47:42',NULL,'2026-10-13 02:47:42'),(159,2,'fc71865a66ec228240c86aac3657f08cb2ba7ad655e370f3fc4a83fb7374c200','2026-11-12 10:47:42',NULL,'2026-10-13 02:47:42'),(160,3,'bb21786f44f8a9474d16c155ee1c71398d206f14939e7831a0020721f1614ca1','2026-11-12 10:47:42',NULL,'2026-10-13 02:47:42'),(161,4,'5c2178276389147b63632ce4d447db155befad2e031e14ee5abe429373f933c1','2026-11-12 10:47:42',NULL,'2026-10-13 02:47:42'),(162,5,'063dfd7d0661752ce32607d9bddde41ba2d2d41fc893d0f48b7ce2a253ee29ad','2026-11-12 10:47:43',NULL,'2026-10-13 02:47:43'),(163,6,'5a50dd1ae5a4ae5c191cab28079f28d408f65d08f4e931848ea6f69588ae2c43','2026-11-12 10:47:43',NULL,'2026-10-13 02:47:43'),(164,1,'12d9fd6cc7053eaa23e394f8748d9708cc7547e5fe0425e1355fefeeb1c1130b','2026-11-12 10:48:20','2026-10-13 10:53:20','2026-10-13 02:48:20'),(165,1,'b645532ca02b06494f3f25714782fe337ef04dbb05d8cc1a8032b29cc6d89fe2','2026-11-12 10:49:50','2026-10-13 10:54:50','2026-10-13 02:49:50'),(166,1,'ebe35783da307745e01a76b48a60470e4f5a9fa848d5707691efb17fb46ab48c','2026-11-12 10:53:20','2026-10-13 10:58:20','2026-10-13 02:53:20'),(167,1,'3e33d42754cad4c6dbc2a3b52bdaadeed97c95f608e00fd9a6e11a03702d2a61','2026-11-12 10:54:50','2026-10-13 10:59:50','2026-10-13 02:54:50'),(168,2,'2243e7ce5117a3f7d2f531563f6b3f3fdbbeeb6973919fc0a2724b1c748e28b4','2026-11-12 10:58:07',NULL,'2026-10-13 02:58:07'),(169,1,'a9365118b9adb6f00d15318a24b2263990d2c35845beaafc48241cfe1cdd61ab','2026-11-12 10:58:20','2026-10-13 11:03:20','2026-10-13 02:58:20'),(170,3,'41f372bfc80dcd2717530972900127a330152b7f625d633536145b9cd79fc009','2026-11-12 10:58:45',NULL,'2026-10-13 02:58:45'),(171,6,'25b2523568fb2902ab54de1acbd91aa201399c3274959c5167b6b82717fb1a53','2026-11-12 10:59:15',NULL,'2026-10-13 02:59:15'),(172,4,'febed34d195df61317a6ea377da619cfc3b0e2274ed755181bc522138bb94ae2','2026-11-12 10:59:24',NULL,'2026-10-13 02:59:24'),(173,1,'4a4a11972d0e2c7767d29e730f4f5c3e41db8650655f2bf04b854f16ebe636f2','2026-11-12 10:59:50',NULL,'2026-10-13 02:59:50'),(174,5,'e48d4a90b3e42fbdf420102a0a7d7f52e1c2df3bc5d75199af54fd478f8aa00c','2026-11-12 11:01:01',NULL,'2026-10-13 03:01:01'),(175,1,'d08ed587d11e78f960feb0f77dc03a68d411ff702e6be76047aa0f7ade736066','2026-11-12 11:03:20','2026-10-13 11:08:20','2026-10-13 03:03:20'),(176,1,'e4689ca577291d1708e0988b273fe2fa8da29ee16d4fe3e5242a22547b2c7134','2026-11-12 11:08:20','2026-10-13 11:13:20','2026-10-13 03:08:20'),(177,6,'87658e16e546907a651d27e27eaa6a24969b850edceb1687a4c2eccb60bb829a','2026-11-12 11:11:01',NULL,'2026-10-13 03:11:01'),(178,1,'64654fbd73f743f68170172bff317b1b115564b3a80c33e40a1fa67d24a56329','2026-11-12 11:11:09',NULL,'2026-10-13 03:11:09'),(179,3,'c053d8d454faa7c1d0d30965fdfac783f3cfdc1a51f07e4e59032129171ed7b6','2026-11-12 11:11:34',NULL,'2026-10-13 03:11:34'),(180,1,'9271734e32f7c8bc170a6b71c5ccded9e69f8ae0c90f831b8d492fd1472eec65','2026-11-12 11:13:20','2026-10-13 11:18:20','2026-10-13 03:13:20'),(181,1,'32ec4e935ea2fe4cdb4025d8450d8c8adc1f0615c1f4bee86f5a52e62d588803','2026-11-12 11:18:20','2026-10-13 11:23:21','2026-10-13 03:18:20'),(182,2,'3d785f1180ddc68cbc107752a1283970d923fce9c72e35de8c1ce8afa1fc7b64','2026-11-12 11:22:14',NULL,'2026-10-13 03:22:14'),(183,1,'1b5281c02f70827fecc776ad87af05e5d5cff331b6c8f9f2c5458465b4205808','2026-11-12 11:22:29','2026-10-13 11:27:30','2026-10-13 03:22:29'),(184,1,'958b6d6ecb491fc1a6dc5ac186017d0d37cf1a589a196248a19f5df677624671','2026-11-12 11:23:21','2026-10-13 11:28:21','2026-10-13 03:23:21'),(185,1,'4833ea32e6fe5f88fb2261c2762cd2b46eeeb1607ad8cc0594940ec1aefd66bb','2026-11-12 11:23:29','2026-10-13 11:28:29','2026-10-13 03:23:29'),(186,6,'12129e846d99a3812466961ad318a4792a1fc22bc1318cb7a381754df1553f7d','2026-11-12 11:26:02',NULL,'2026-10-13 03:26:02'),(187,1,'a6fb58d7b28d7d0ee611b10e46aabaad53f69e4eadfcf241b9409085d6fe7a5e','2026-11-12 11:27:30',NULL,'2026-10-13 03:27:30'),(188,1,'22227837bd846a198684876ce3ad4938e15f56a2ba56079ec4769d033e1a5368','2026-11-12 11:28:21',NULL,'2026-10-13 03:28:21'),(189,1,'356d788227c049f498f139c1d79833776720fc002b81dccce762f25429745149','2026-11-12 11:28:29',NULL,'2026-10-13 03:28:29'),(190,1,'b51d3a1accad223cca5d9f0257ffd6413449cd229666caac7e5b8886e4e437c2','2026-11-12 13:36:45','2026-10-13 13:41:45','2026-10-13 05:36:45'),(191,1,'b7d03abb1f857eff06dec7915a3cf37368d23d8eb7815742263592ae93a7284d','2026-11-12 13:41:45','2026-10-13 13:46:47','2026-10-13 05:41:45'),(192,1,'8f52d3d6ce664ae60e98ab49dcf3b36799820c8e92f72aa0d1c94d90f8c91d1e','2026-11-12 13:46:47','2026-10-13 13:51:48','2026-10-13 05:46:47'),(193,1,'3f54be5141e1a77a1766bd8d429277ee861c8a4089003a90dc74f156ad19262f','2026-11-12 13:51:48','2026-10-13 13:56:48','2026-10-13 05:51:48'),(194,1,'2ad93f330ad71b759908350ec547a8e0226ea5b4160d10e0a5a4e11e5cf9b0a3','2026-11-12 13:55:40','2026-10-13 14:00:40','2026-10-13 05:55:40'),(195,1,'1d2c01cfe804b2f9884307a659d6676af41b884b422575b1dd74bb08f719be60','2026-11-12 13:56:48','2026-10-13 14:01:48','2026-10-13 05:56:48'),(196,1,'76a3b070e58805e951f0abbba4e2206d181cf9b48b334b357068cb446161daf7','2026-11-12 14:00:40','2026-10-13 14:05:40','2026-10-13 06:00:40'),(197,1,'51337082fdb7c57c2a7b1eec848ebfaa4a5e6e8f2fd52d40502c1ac644bcf1b1','2026-11-12 14:01:36',NULL,'2026-10-13 06:01:36'),(198,1,'f2d4c8d0334a9149be15dff8b30ad38a8762960a01b63033c690f37999b581f8','2026-11-12 14:01:48','2026-10-13 14:06:48','2026-10-13 06:01:48'),(199,1,'a532a3bc5c2482f4337087dc23bf10e7171e255c86ed838833b0bcc10854c463','2026-11-12 14:05:40','2026-10-13 14:10:40','2026-10-13 06:05:40'),(200,1,'1e518314c22daf08e730798e08048b65b8a2960f6ef3313fbfd2da37f03c2ac6','2026-11-12 14:06:48','2026-10-13 14:11:49','2026-10-13 06:06:48'),(201,1,'ef82fb2953541be6a645e61ecdf044ff07ad983ab69c899df4211057ec203584','2026-11-12 14:10:40','2026-10-13 14:15:41','2026-10-13 06:10:40'),(202,1,'fbd04ef2c515eb00f1c3d1ee9d3835dad6918df54e8285c14bb817ebb5a5734d','2026-11-12 14:11:49','2026-10-13 14:16:49','2026-10-13 06:11:49'),(203,1,'a5f4a57609688644fbff95ebdccb62a96bddb085b937da27fb0818661ad39daa','2026-11-12 14:15:41','2026-10-13 14:20:41','2026-10-13 06:15:41'),(204,1,'be398cc0b2f58dc509202925bfbff6ef328cd99b899a917c11167705bdb6197d','2026-11-12 14:16:49','2026-10-13 14:21:49','2026-10-13 06:16:49'),(205,1,'10242e7a499032b3d6f89c29a556e004444f5163c0b798d8a31bc7bff2bf6cbb','2026-11-12 14:20:41','2026-10-13 14:25:41','2026-10-13 06:20:41'),(206,1,'874440b7295ce47f6607043e8b2e6e89617d7e07c41f5e6a409eef46911e8b49','2026-11-12 14:21:49','2026-10-13 14:26:50','2026-10-13 06:21:49'),(207,1,'785c282b486022d7f2f8cb8532fc287733d5bf646c9216787ba8d98b624952ab','2026-11-12 14:25:41','2026-10-13 14:30:41','2026-10-13 06:25:41'),(208,1,'0fa5a04d7453ef7ecee68c692c9d0e8a4f45a124aa1285a61759c778938ae82c','2026-11-12 14:26:50','2026-10-13 14:31:50','2026-10-13 06:26:50'),(209,1,'f004f244d434567bdb94d1fe0c5166e447b426ed79a6444829de4920770d8af0','2026-11-12 14:30:41','2026-10-13 14:35:41','2026-10-13 06:30:41'),(210,1,'e44f32f137ebde49fb73d2024904d5883153dc70109ec1cd1da5656f6d38e1c3','2026-11-12 14:31:50',NULL,'2026-10-13 06:31:50'),(211,2,'04f5b91a95fb17d4154c60d6347baa87e0324b25a809f0e1572d74edf546c026','2026-11-12 14:32:24',NULL,'2026-10-13 06:32:24'),(212,2,'1cbe1df050a244540b5dc6240736f684156b65e72ca409424a8d5609745aa6bd','2026-11-12 14:32:53',NULL,'2026-10-13 06:32:53'),(213,3,'4f5c6f054bf3b2695ab761f0851d37e5f808984bafa25f7418c945e1f8af353b','2026-11-12 14:35:06',NULL,'2026-10-13 06:35:06'),(214,1,'67947c66e774fe178013c12b4c18efc352a8071f2fa655c203bdf30ee7e17d78','2026-11-12 14:35:41','2026-10-13 14:40:41','2026-10-13 06:35:41'),(215,1,'434a05ba065ebd8a1614968b17d39091db40285f0e0fd5d9b81113bfdd1ddcb8','2026-11-12 14:36:33',NULL,'2026-10-13 06:36:33'),(216,4,'b7a11e70e1857f0097a2778aec10b9cb5840dbd59aa737e685c4e071ba181790','2026-11-12 14:39:13',NULL,'2026-10-13 06:39:13'),(217,3,'de9fa13ed035d6a284aadc3c3602e49d7cf6e010ba07cad834e3d1833b54473e','2026-11-12 14:39:27',NULL,'2026-10-13 06:39:27'),(218,1,'0009f000538d4da55a08b41ed5140a837d48af9a9bc764b93d4fa573c814123e','2026-11-12 14:40:41','2026-10-13 14:45:41','2026-10-13 06:40:41'),(219,1,'47edd742df853c14fb03d8b989fe9ae546f630f95b1aa193d27921c30a7d3ba2','2026-11-12 14:43:12','2026-10-13 14:48:12','2026-10-13 06:43:12'),(220,1,'45330415aa621aff361a32cc6be911200cd8b1cecd4f37ae61e8371383441f68','2026-11-12 14:45:41','2026-10-13 14:50:41','2026-10-13 06:45:41'),(221,1,'37c72dff6a3cd42e2c6488adf43cd2f213e451088df55f4ee722d6d56fe8e08a','2026-11-12 14:48:12','2026-10-13 14:53:12','2026-10-13 06:48:12'),(222,1,'c006e0b788078b00da13f27376270098b83954ff26775dfc94f5b80dbeb6b35b','2026-11-12 14:50:41','2026-10-13 14:55:41','2026-10-13 06:50:41'),(223,1,'38bc91eb2cb5d54ae3909ba6ed8d86807022e8ca380a64f4a385d15f71591994','2026-11-12 14:53:12','2026-10-13 14:58:12','2026-10-13 06:53:12'),(224,1,'5494f79028607c6ad77ad0271fe77a3f86200133feaea36c47c13ead205efd4a','2026-11-12 14:55:41','2026-10-13 15:00:41','2026-10-13 06:55:41'),(225,1,'2e9f5db346cae80b24be26a3002ee0bcd4d7ae9362cbf63b8c1df184ec25faa8','2026-11-12 14:58:12','2026-10-13 15:03:14','2026-10-13 06:58:12'),(226,1,'b10079ff59730e2a60969652b4ddae907092d9768bc5833140ef34c96f7ab08f','2026-11-12 15:00:41','2026-10-13 15:05:42','2026-10-13 07:00:41'),(227,1,'a405faf11cc4e1dd52834fb081f0087197f5eaf21681d34c797cb4aebde3345b','2026-11-12 15:03:14',NULL,'2026-10-13 07:03:14'),(228,1,'3e1f72c5dc0da65f203d99401ef3d76b1681c15b4df43f08b6ce8f54cda146ac','2026-11-12 15:05:42','2026-10-13 15:10:42','2026-10-13 07:05:42'),(229,5,'b975c84cf561d0049fa51181e9aadb88bfb5994002f7875833ffa6c1cc9527af','2026-11-12 15:06:05',NULL,'2026-10-13 07:06:05'),(230,1,'3b7f32b971153330aab83b1a84fe194bacc36f99778d86c817541930e7ed71f3','2026-11-12 15:06:27','2026-10-13 15:11:27','2026-10-13 07:06:27'),(231,1,'297c27a2f2b14ba7304098bf75e2a194a31eb9ddbadbf764f451dee5b1da643d','2026-11-12 15:10:42','2026-10-13 15:15:42','2026-10-13 07:10:42'),(232,1,'fec1af456b555359af6e1e6edd5c7fe74e0444d19f43fd970c759e04b4e2d04d','2026-11-12 15:11:19',NULL,'2026-10-13 07:11:19'),(233,1,'919abed82a918c0907b56be89b767aba44972f5a45b1887bb7a99045779e513f','2026-11-12 15:11:27','2026-10-13 15:16:28','2026-10-13 07:11:27'),(234,1,'a7924babdee03fb964049ca9b8fbb024f97284d994d530676f538599c1b98ab9','2026-11-12 15:15:42','2026-10-13 15:20:42','2026-10-13 07:15:42'),(235,1,'e903b0198ec6ad9b7439f550f085cd8bb8b245bcf9c53e62576d87cf93acedd6','2026-11-12 15:16:28','2026-10-13 15:21:29','2026-10-13 07:16:28'),(236,1,'7eca18a5f8eaead4ed6535b835af4c57be0fcfa3d3d8dace643922c9e5b0c6fa','2026-11-12 15:20:42','2026-10-13 15:25:42','2026-10-13 07:20:42'),(237,1,'f3e50b5eb5757c0c278b61f8f2b831e4b49396bfe46b7eb5921b12305798940d','2026-11-12 15:21:29','2026-10-13 15:26:30','2026-10-13 07:21:29'),(238,1,'2b1613789a319b5415432b874f7fe201e3180b84518447fe9e556211b50df8e6','2026-11-12 15:25:42','2026-10-13 15:34:45','2026-10-13 07:25:42'),(239,1,'a81365ecf44512bd00a7d0e8448a1eed1621a2b421f625e0fb19dd694dd023bf','2026-11-12 15:26:30','2026-10-13 15:34:45','2026-10-13 07:26:30'),(240,1,'e72c127c06f5ebfe94b82f47a005427da30f7edfbafc6757e2482f14c110e348','2026-11-12 15:34:45','2026-10-13 15:39:45','2026-10-13 07:34:45'),(241,1,'909a2438a7075a2303ce4abf0f79a7ded6624183b9d22c33b76b6b28f32cbee9','2026-11-12 15:34:45','2026-10-13 15:39:45','2026-10-13 07:34:45'),(242,1,'ee6029d166f5fed304cb8b2908de57fdf11f22f9c800f065274ef07f9e407d69','2026-11-12 15:39:45','2026-10-13 15:44:45','2026-10-13 07:39:45'),(243,1,'c3e947ba044cfdca68dbff054fd7859de5b3365989acf0df05c4e9d75aec8ada','2026-11-12 15:39:45','2026-10-13 15:44:45','2026-10-13 07:39:45'),(244,1,'e54d2b8e8abbbcbb12ed5d5aba38aa6e0aac8a3a71ba45e48f448e356f49e425','2026-11-12 15:44:45','2026-10-13 15:49:45','2026-10-13 07:44:45'),(245,1,'544764b06a42910a6546d2487083b838a26d76bea2bb7e020660e33066ae0d59','2026-11-12 15:44:45','2026-10-13 15:49:45','2026-10-13 07:44:45'),(246,1,'54f35f14d0d905fa6b0bc86b260907a6ab18b20362748241ee4609e37637e16c','2026-11-12 15:49:45','2026-10-13 15:54:45','2026-10-13 07:49:45'),(247,1,'76a56c3cf63bab1e8a8c871d37f2d8cf7ed91d6fde38f329198d76ffe69f041b','2026-11-12 15:49:45','2026-10-13 15:54:45','2026-10-13 07:49:45'),(248,1,'bfc5e131766f3b18f7a7c276c17e41c553486c73e254d218d7737199a6398279','2026-11-12 15:54:45','2026-10-13 15:59:45','2026-10-13 07:54:45'),(249,1,'a4e09678ab56a26859dd9e6c9354908ca3502dee5d447621bd9f76e5aab0332a','2026-11-12 15:54:45','2026-10-13 15:59:46','2026-10-13 07:54:45'),(250,1,'6f4575ba9c6b7530ce6e097a11601434198806af3638f4a9c9a915244ec8d2f6','2026-11-12 15:59:45','2026-10-13 16:04:46','2026-10-13 07:59:45'),(251,1,'d02d5a8c52ea1a43819cc5a789a116aad07f7a64165f4e3b5bc576479eac0d0e','2026-11-12 15:59:46','2026-10-13 16:04:46','2026-10-13 07:59:46'),(252,5,'886badf6de35b695c67b95b62563b182ecfe1fe32ebc210a2164c91f029a5789','2026-11-12 15:59:48','2026-10-13 16:14:48','2026-10-13 07:59:48'),(253,3,'08198d0e4078cf93c7fdb95cc06e7c98a88e3aa297995c57696c14271511ff73','2026-11-12 15:59:53','2026-10-13 16:14:54','2026-10-13 07:59:53'),(254,6,'713688f0c6ae46e04ce8d04599196073d8e9125fcf9f3de7345cb7c6a270a174','2026-11-12 16:00:01','2026-10-13 16:15:01','2026-10-13 08:00:01'),(255,2,'b0ca1d82fd05247f69a31ac9b2c231ad12ed13202282873ea085f8e75e48fe8a','2026-11-12 16:00:09','2026-10-13 16:15:09','2026-10-13 08:00:09'),(256,4,'26624740e42fe37d5155c004c4ffab12c6c84389a1bd3df444a344d4264deb5b','2026-11-12 16:00:20','2026-10-13 16:15:20','2026-10-13 08:00:20'),(257,1,'0b958bc2092d4da2584b9e76f6f20fd752c7af25c33b9eb28f23df33ac7544e6','2026-11-12 16:04:46','2026-10-13 16:09:46','2026-10-13 08:04:46'),(258,1,'8ce95840061ec96d1cc8edf4be32f2934479947092ef2d67f646202c56c8d58b','2026-11-12 16:04:46','2026-10-13 16:09:46','2026-10-13 08:04:46'),(259,1,'f6b36e7ae928bc320ac9155bf713d587e8ddafb19bd9060948fe17007ec19f3b','2026-11-12 16:09:46','2026-10-13 16:14:46','2026-10-13 08:09:46'),(260,1,'ac574d7c2132eaf1838d8dea3c5d1a04cfd692b6560e377c34c12f8e10a3ffd0','2026-11-12 16:09:46','2026-10-13 16:14:47','2026-10-13 08:09:46'),(261,1,'155cf1593fc015af916b683b2e145ecbcc948359ada10ce0559e07f5e88c3601','2026-11-12 16:14:46','2026-10-13 16:19:46','2026-10-13 08:14:46'),(262,1,'3840975e0115abd8f55fadca1e165f1c7ab100e8bb668b3a036c9ec058c9891d','2026-11-12 16:14:47','2026-10-13 16:19:47','2026-10-13 08:14:47'),(263,5,'e3d1efe5b6f5f48853830c5026d55f9c305a316c0a932380f5d62accc53a997b','2026-11-12 16:14:48','2026-10-13 16:29:49','2026-10-13 08:14:48'),(264,3,'f572aedc7437e700bc3a8859692393382a8ae1e83b16e8713b1639e882718da9','2026-11-12 16:14:54','2026-10-13 16:30:26','2026-10-13 08:14:54'),(265,6,'3cde985af5ad50468a58ec521d0e334a572ee742977a6b01df7586fe25e31184','2026-11-12 16:15:01','2026-10-13 16:30:10','2026-10-13 08:15:01'),(266,2,'a997f9f8752430c1489716df88042aca023f4051d943dde9e370cba63f2a93ba','2026-11-12 16:15:09','2026-10-13 16:30:30','2026-10-13 08:15:09'),(267,4,'e9616f99e76c699c091753c14e0acc6bc065bfc2e8a54b727061431eed94d24d','2026-11-12 16:15:20','2026-10-13 16:30:21','2026-10-13 08:15:20'),(268,1,'6b877976b3e2fcaf027a0012f4d0b2648edce608503e1b321b5d56f0834434c6','2026-11-12 16:19:46','2026-10-13 16:24:46','2026-10-13 08:19:46'),(269,1,'6cef3bd083918d38276dfaf7e0dd7414f3b1ce58d6fec773aaae95d376a80cee','2026-11-12 16:19:47','2026-10-13 16:24:48','2026-10-13 08:19:47'),(270,1,'25af0862fd61ba2c67c3981178efe75da84dd3601b4447cfdae5bf27d143b981','2026-11-12 16:24:46','2026-10-13 16:29:46','2026-10-13 08:24:46'),(271,1,'2525a8feb27bb093f2717a51c905ed881946ebb3c7a6ddda39e3c990bb45e3d8','2026-11-12 16:24:48','2026-10-13 16:29:49','2026-10-13 08:24:48'),(272,1,'9dc7c76f4c3c4360f48b185719333629ef5db1a8a8aa86e8fc78222b4c376f48','2026-11-12 16:29:46','2026-10-13 16:34:48','2026-10-13 08:29:46'),(273,1,'92011b633eb16ac5b791a94ce6b7826cfffd02357fd65c3981f8038dba6c81df','2026-11-12 16:29:49','2026-10-13 16:34:52','2026-10-13 08:29:49'),(274,5,'4852717416bc1cb9e7d1b951dc3d223d1686e97af63fc298afe010d5ae8c97e3','2026-11-12 16:29:49','2026-10-13 16:45:14','2026-10-13 08:29:49'),(275,6,'8907299df98c33017609f78b5f333e8cd9b4b107d5a76d2dddab90e77adb5d38','2026-11-12 16:30:10','2026-10-13 16:45:13','2026-10-13 08:30:10'),(276,4,'45f45f99b722c68a415f4778caf06844db9f1b12343c8f86aef6aee98c6c5de9','2026-11-12 16:30:21','2026-10-13 16:45:36','2026-10-13 08:30:21'),(277,3,'5c9758921e3bbb5076f55fe34adb095da1577ce8b2ae35bfda5a4bb8cf529970','2026-11-12 16:30:26','2026-10-13 16:45:29','2026-10-13 08:30:26'),(278,2,'c467b298b48592959ca3eed8f14054aee28e3295dcb4697424b56aa40afc25a6','2026-11-12 16:30:30','2026-10-13 16:45:33','2026-10-13 08:30:30'),(279,1,'d38a890e5cf46e3fec2c38b12aed8f130124d8b02a7f8fd65a2a69ea78418a07','2026-11-12 16:34:48','2026-10-13 16:39:48','2026-10-13 08:34:48'),(280,1,'615f71f1eecf50b152926bdca58a56cb4584677f66fd9e0017ca3adf7a842278','2026-11-12 16:34:52','2026-10-13 16:39:53','2026-10-13 08:34:52'),(281,1,'8eeab048cf483b677839acd91f9e0f7b55351abe232d92912ba554c2734b332c','2026-11-12 16:39:48','2026-10-13 16:44:49','2026-10-13 08:39:48'),(282,1,'8f6b20dc7fbdb5c83f122be932a19201753e1fabea6947919b91c8309a719170','2026-11-12 16:39:53','2026-10-13 16:44:54','2026-10-13 08:39:53'),(283,1,'44f5a308e3cc4435fd105b7c8f983254953aa712598c00fa93dd5d8f6f28561a','2026-11-12 16:44:49','2026-10-13 16:49:49','2026-10-13 08:44:49'),(284,1,'9922095322beffdd3dbdd8e0629321649201bc658718648da4bb0d73b2dcb2c1','2026-11-12 16:44:54','2026-10-13 16:49:55','2026-10-13 08:44:54'),(285,6,'b0dcaf9ff735278c20d96574a20d1aa0023c826dddf69f696f3e9b135b860ab8','2026-11-12 16:45:13','2026-10-13 17:00:14','2026-10-13 08:45:13'),(286,5,'a0a5588cc17350256d8b91355fc317440dd49583ab7cf4e47bf8bc720539dfdc','2026-11-12 16:45:14','2026-10-13 17:00:15','2026-10-13 08:45:14'),(287,3,'b3abd4cd8f99650f45e929e92b6358a082f112aaf41e5911920fca605ab2a22c','2026-11-12 16:45:29','2026-10-13 17:00:30','2026-10-13 08:45:29'),(288,2,'7a2dc430c3d9f14c674419b8df7bf8d14227150c6ff07909b2de9ebea1f6be63','2026-11-12 16:45:33','2026-10-13 17:00:34','2026-10-13 08:45:33'),(289,4,'1e44381dd171befa0b2b6984b0cb7b965207f15f3de766c67c64cec51fdda4ce','2026-11-12 16:45:36','2026-10-13 17:00:37','2026-10-13 08:45:36'),(290,1,'2401e211027c4037023cd328e81425f6031429044af4d228a748430b5682b885','2026-11-12 16:49:49','2026-10-13 16:54:49','2026-10-13 08:49:49'),(291,1,'f7594e417d1085349ddc58d45e455ab1a6d297113c6996000c88b34a5430e669','2026-11-12 16:49:55','2026-10-13 16:54:56','2026-10-13 08:49:55'),(292,1,'152a113676e457c8a3a6bc79c1caa5afc9fa403f0571df20b608425af8e3974d','2026-11-12 16:54:49','2026-10-13 16:59:49','2026-10-13 08:54:49'),(293,1,'ddb6e800da31b0bb2bc15e6186a511e06c8af749e5fbb327f8d0ca0ab195c6d1','2026-11-12 16:54:56','2026-10-13 16:59:57','2026-10-13 08:54:56'),(294,1,'81be34f34f24dbd8893712a800ab5a802d72d39360934ef0ad84263c0f5b4886','2026-11-12 16:59:49','2026-10-13 17:04:49','2026-10-13 08:59:49'),(295,1,'dc76b2c7fbbf74fbc3f057352d0844dcb0898727590c6fc8f2221b79a820ffd7','2026-11-12 16:59:57','2026-10-13 17:05:30','2026-10-13 08:59:57'),(296,6,'4b403685388a7e116c8d3091a385f9b88e2d4e3c03b952295868ea5f80e17e21','2026-11-12 17:00:14','2026-10-13 17:15:15','2026-10-13 09:00:14'),(297,5,'f95f769a0e838f546c98b6c169167dfdab85e8b7027cb8b95ac0a2a9df12c9ff','2026-11-12 17:00:15','2026-10-13 17:15:16','2026-10-13 09:00:15'),(298,3,'5db05a3385a827d3e54913417ab5d0c6cd50bc34e8a5debfa783e25b916881a3','2026-11-12 17:00:30','2026-10-13 17:15:31','2026-10-13 09:00:30'),(299,2,'f451838211184c78d1148a0cadeb00614733d87189ad3d9717814ef5039f2e13','2026-11-12 17:00:34','2026-10-13 17:15:35','2026-10-13 09:00:34'),(300,4,'88cbb5463ad9f40925b717ea2d1b75ce3721c7d1cddafe51440357c5e5dcedf9','2026-11-12 17:00:37','2026-10-13 17:15:38','2026-10-13 09:00:37'),(301,1,'b4a4226062700634e6b2dc8aba3b2d3e7e48c42f2cd467329ecf4ae6df0170d1','2026-11-12 17:04:49','2026-10-13 17:09:50','2026-10-13 09:04:49'),(302,1,'d0544ec1401f3afc60d77af2e72dd8b2ed6bc56dd2bdf2a9346af49845b68681','2026-11-12 17:05:30','2026-10-13 17:10:31','2026-10-13 09:05:30'),(303,1,'39c368ee9bb02a60a901b6b2127365bbf2c9b311257c4f907084057b0d6d3134','2026-11-12 17:09:50','2026-10-13 17:14:50','2026-10-13 09:09:50'),(304,1,'86095ed17bbd030d2e70223d73b3ec9887411e09d21fd129dabf4043fea44637','2026-11-12 17:10:31','2026-10-13 17:15:44','2026-10-13 09:10:31'),(305,1,'47363e869d33394047127c06b7cf82e331483a0f13448485bf0bc7f2b490f256','2026-11-12 17:14:50','2026-10-13 17:19:50','2026-10-13 09:14:50'),(306,6,'14731d76b905bab6b1423e2055b1568fb3df3d61034a89f0c1824814c3c97d74','2026-11-12 17:15:15',NULL,'2026-10-13 09:15:15'),(307,5,'c2944cc45cecef9f4032195f5fbce98fe8023b363e029e20fb3855ab2de2741e','2026-11-12 17:15:16',NULL,'2026-10-13 09:15:16'),(308,3,'d0d0b5c60442b1f17caba682cbe9966172831eb422c267ea57cce11cd67d8332','2026-11-12 17:15:31',NULL,'2026-10-13 09:15:31'),(309,2,'fb10c599f54d1f18f98d1595eac58a1ffd32ff5bf614393f1a49ec76f36a40ac','2026-11-12 17:15:35',NULL,'2026-10-13 09:15:35'),(310,4,'4376daa6cc440af5f364bc93e15c244432a54a259ba745f457bf93b099fbbe2d','2026-11-12 17:15:38',NULL,'2026-10-13 09:15:38'),(311,1,'c441109ce1f5aee469d3b902866c121f7def2f0e472e3003304249d3ee6b505a','2026-11-12 17:15:44','2026-10-13 17:20:45','2026-10-13 09:15:44'),(312,1,'e658dfb6f82a547ddf92e5dadd154b3868802b5b486bb02424cf5efc2b05060a','2026-11-12 17:19:50','2026-10-13 17:24:51','2026-10-13 09:19:50'),(313,1,'04a2348e37d97a5759ece4814823e55b9aaad2d3cece1c8e5d39271b11dfd169','2026-11-12 17:20:45',NULL,'2026-10-13 09:20:45'),(314,1,'14fe34841f75b84e28781f55395703349c5da1a326418a6108f38aaa4829cc58','2026-11-12 17:24:51',NULL,'2026-10-13 09:24:51'),(315,1,'c6a798ae600c4e7ae7559b694205c9eea14080c4008080b72ec24a8b4bf6dac6','2026-11-13 02:13:05',NULL,'2026-10-13 18:13:05'),(316,1,'37dbe8ee61b0508d77c4a3d729bed9c85c51401bba71a587b306ee95d161fef1','2026-11-13 02:13:06',NULL,'2026-10-13 18:13:06'),(317,1,'54fdc0b0c5ab7c40a908bc38af442a728fd47d6d01a6ee74b8498ba2ddc528d3','2026-11-13 02:15:15',NULL,'2026-10-13 18:15:15');
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (5,'SUP-7F933D44FA','UNILAB','support@unilab.ph','','ACTIVE','2026-10-13 14:13:14','2026-10-13 14:13:14');
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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

-- Dump completed on 2026-10-14 10:17:33
