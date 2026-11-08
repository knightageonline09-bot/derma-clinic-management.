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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES (1,'APT-B486B2740E',1,4,'2026-09-28 19:30:00','2026-09-28 20:00:00','COMPLETED','2026-09-28 11:27:28','2026-09-28 11:38:06'),(2,'APT-5B0F506249',2,4,'2026-09-29 10:29:00','2026-09-29 10:59:00','COMPLETED','2026-09-29 02:28:14','2026-10-07 05:59:40');
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
INSERT INTO `audit_logs` VALUES (1,1,'Appointments','APPOINTMENT_CREATED','1','APT-B486B2740E','{\"staffId\": \"4\", \"startsAt\": \"2026-09-28T19:30\"}','2026-09-28 11:27:28'),(2,1,'Consultations','CONSULTATION_CREATED','1','CON-F8CAEA7F80',NULL,'2026-09-28 11:28:34'),(3,1,'Treatment','DOCKET_CREATED','1','TD-D312206C0C','{\"patientId\": \"1\", \"serviceId\": \"1\"}','2026-09-28 11:28:50'),(4,1,'Inventory','PRODUCT_CREATED','005','005',NULL,'2026-09-28 11:31:06'),(5,1,'Billing','INVOICE_CREATED','1','INV-BEA01D31DB','{\"paid\": \"50\", \"total\": \"500.00\", \"status\": \"PARTIAL\", \"discount\": \"2\"}','2026-09-28 11:31:25'),(6,1,'Billing','PAYMENT_RECORDED','1','PAY-DAA0D106A3','{\"amount\": \"250\", \"status\": \"PARTIAL\"}','2026-09-28 11:31:38'),(7,1,'Billing','PAYMENT_RECORDED','1','PAY-64567ECFAF','{\"amount\": \"100\", \"status\": \"PARTIAL\"}','2026-09-28 11:32:04'),(8,1,'Billing','PAYMENT_RECORDED','1','PAY-061A1CFB12','{\"amount\": \"50\", \"status\": \"PARTIAL\"}','2026-09-28 11:32:58'),(9,1,'Billing','PAYMENT_RECORDED','1','PAY-40D3428766','{\"amount\": \"45\", \"status\": \"PARTIAL\"}','2026-09-28 11:33:13'),(10,1,'Billing','PAYMENT_RECORDED','1','PAY-8D2B0C5BDF','{\"amount\": \"4\", \"status\": \"PARTIAL\"}','2026-09-28 11:33:33'),(11,4,'Appointments','APPOINTMENT_STATUS_CHANGED','1','COMPLETED','{\"status\": \"COMPLETED\"}','2026-09-28 11:38:06'),(12,5,'Billing','PAYMENT_RECORDED','1','PAY-2F077C536A','{\"amount\": \"1\", \"status\": \"PAID\"}','2026-09-28 11:38:44'),(13,2,'Appointments','APPOINTMENT_STATUS_CHANGED','1','COMPLETED','{\"status\": \"COMPLETED\"}','2026-09-28 11:40:09'),(14,1,'Consultations','CONSULTATION_CREATED','1','CON-D1D486BCD3',NULL,'2026-09-28 12:05:37'),(15,2,'Treatment','DOCKET_CREATED','2','TD-9FE9612977','{\"patientId\": \"1\", \"serviceId\": \"20\"}','2026-09-29 01:58:00'),(16,5,'Billing','INVOICE_CREATED','2','INV-1D689A4131','{\"paid\": \"50\", \"total\": \"50.00\", \"status\": \"PAID\", \"discount\": \"0\"}','2026-09-29 01:58:49'),(17,2,'Appointments','APPOINTMENT_CREATED','2','APT-5B0F506249','{\"staffId\": \"4\", \"startsAt\": \"2026-09-29T10:29\"}','2026-09-29 02:28:14'),(18,3,'Consultations','CONSULTATION_CREATED','3','CON-20AFA36772',NULL,'2026-09-29 02:33:54'),(19,2,'Treatment','DOCKET_CREATED','3','TD-D4DFD659A6','{\"patientId\": \"3\", \"serviceId\": \"1\"}','2026-09-29 02:38:54'),(20,1,'Consultations','CONSULTATION_CREATED','3','CON-9FDC4B253C',NULL,'2026-10-02 07:03:10'),(21,2,'Treatment','DOCKET_CREATED','4','TD-356F6CDFDF','{\"patientId\": \"1\", \"serviceId\": \"20\"}','2026-10-02 07:05:46'),(22,2,'Treatment','DOCKET_CREATED','5','TD-28C3AEB090','{\"patientId\": \"3\", \"serviceId\": \"22\"}','2026-10-02 07:14:28'),(23,5,'Billing','INVOICE_CREATED','3','INV-B4ABB245A6','{\"paid\": \"6666\", \"total\": \"6666.00\", \"status\": \"PAID\", \"discount\": \"0\"}','2026-10-02 07:15:26'),(24,4,'Appointments','APPOINTMENT_STATUS_CHANGED','2','COMPLETED','{\"status\": \"COMPLETED\"}','2026-10-07 05:59:40'),(25,4,'Appointments','APPOINTMENT_STATUS_CHANGED','2','COMPLETED','{\"status\": \"COMPLETED\"}','2026-10-07 05:59:42'),(26,4,'Appointments','APPOINTMENT_STATUS_CHANGED','1','COMPLETED','{\"status\": \"COMPLETED\"}','2026-10-07 05:59:45'),(27,1,'Appointments','APPOINTMENT_STATUS_CHANGED','1','COMPLETED','{\"status\": \"COMPLETED\"}','2026-10-12 05:21:10'),(33,5,'Billing','INVOICE_CREATED','3','INV-46FF7ACEB7','{\"paid\": \"502.00\", \"total\": \"502.00\", \"status\": \"PAID\", \"discount\": \"0.00\"}','2026-10-12 07:59:04'),(34,5,'Billing','INVOICE_CREATED','4','INV-421EF5D66E','{\"paid\": \"50.00\", \"total\": \"50.00\", \"status\": \"PAID\", \"discount\": \"0.00\"}','2026-10-12 07:59:04'),(35,5,'Billing','INVOICE_CREATED','5','INV-8465F76FD3','{\"paid\": \"6666.00\", \"total\": \"6666.00\", \"status\": \"PAID\", \"discount\": \"0.00\"}','2026-10-12 07:59:04');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consultations`
--

LOCK TABLES `consultations` WRITE;
/*!40000 ALTER TABLE `consultations` DISABLE KEYS */;
INSERT INTO `consultations` VALUES (1,'CON-F8CAEA7F80',1,NULL,1,'covid','batman','laging gumsing sa gabi','1 weeks','2026-10-04','2026-09-28 11:28:34'),(2,'CON-D1D486BCD3',1,NULL,1,'sfa','sfdvs','fvs','1','2026-09-28','2026-09-28 12:05:37'),(3,'CON-20AFA36772',3,NULL,3,'acne ','depende','a','1','2026-10-05','2026-09-29 02:33:54'),(4,'CON-9FDC4B253C',3,NULL,1,'GFYGF','HGVHG','YGYFG','2','2026-10-16','2026-10-02 07:03:10');
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
INSERT INTO `flyway_schema_history` VALUES (1,'1','<< Flyway Baseline >>','BASELINE','<< Flyway Baseline >>',NULL,'root','2026-09-16 13:11:00',0,1),(2,'2','seed roles','SQL','V2__seed_roles.sql',-1369780179,'root','2026-09-16 13:14:55',106,1),(3,'3','fix development password hashes','SQL','V3__fix_development_password_hashes.sql',511361378,'root','2026-09-17 14:33:04',63,1),(4,'4','set staff development password hashes','SQL','V4__set_staff_development_password_hashes.sql',-19219740,'root','2026-09-17 16:04:52',19,1),(5,'5','remove non admin development accounts','SQL','V5__remove_non_admin_development_accounts.sql',-1064234823,'root','2026-09-24 06:07:57',28,1),(6,'6','restore development staff accounts','SQL','V6__restore_development_staff_accounts.sql',199569236,'root','2026-09-24 08:38:43',37,1),(7,'7','seed requested inventory','SQL','V7__seed_requested_inventory.sql',2086536922,'root','2026-09-25 07:41:27',320,1),(8,'8','link services to required products','SQL','V8__link_services_to_required_products.sql',694103836,'root','2026-09-28 07:50:04',24,1),(9,'9','add consultation follow up date','SQL','V9__add_consultation_follow_up_date.sql',-397423900,'root','2026-09-28 08:31:32',363,1),(10,'10','add patient skin type and allergies','SQL','V10__add_patient_skin_type_and_allergies.sql',-110423083,'root','2026-09-28 09:42:25',187,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_batches`
--

LOCK TABLES `inventory_batches` WRITE;
/*!40000 ALTER TABLE `inventory_batches` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_movements`
--

LOCK TABLES `inventory_movements` WRITE;
/*!40000 ALTER TABLE `inventory_movements` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
INSERT INTO `invoices` VALUES (3,'INV-46FF7ACEB7',1,502.00,0.00,502.00,'PAID','2026-10-12 07:59:04'),(4,'INV-421EF5D66E',2,50.00,0.00,50.00,'PAID','2026-10-12 07:59:04'),(5,'INV-8465F76FD3',5,6666.00,0.00,6666.00,'PAID','2026-10-12 07:59:04');
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (1,'PT-EAD5BC53','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2004-11-03','OILY','Seafood','ARCHIVED','2026-09-28 11:09:53','2026-10-02 07:18:03'),(2,'PT-080700AD','Mondejar, Washington B.','Mondejar@gmail.om','+63 9243078998','2026-09-29','OILY','Seafood','ARCHIVED','2026-09-29 02:24:07','2026-10-12 05:38:08'),(3,'PT-DADE4546','jamer fundano','Jamer@gmail.com','+63 9243078998','2026-09-29','NORMAL','Seafood','ARCHIVED','2026-09-29 02:31:50','2026-10-12 05:38:12'),(4,'PT-BE38CDAE','Mondejar, Washington B.','Mondejarwashington@gmail.com','+63 9243078998','2026-10-07',NULL,NULL,'ARCHIVED','2026-10-07 05:40:16','2026-10-12 05:38:17'),(5,'PT-5AD2DC09','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2026-10-12',NULL,NULL,'ARCHIVED','2026-10-12 03:29:00','2026-10-12 05:38:36'),(6,'PT-2890BEAC','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2026-10-12',NULL,NULL,'ARCHIVED','2026-10-12 03:40:12','2026-10-12 05:38:40'),(8,'PT-02170154','Mondejar, Washington B.','Mondejar@gmail.com','+63 9243078998','2005-04-19',NULL,NULL,'ACTIVE','2026-10-13 02:33:49','2026-10-13 02:33:49'),(9,'PT-3A19AF4C','Mondejar, Washington B.','Mondejar@gmail.com','+63 9243078998','2005-04-19',NULL,NULL,'ACTIVE','2026-10-13 02:33:49','2026-10-13 02:33:49');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (4,3,'PAY-56C10C963E',502.00,'CASH',5,'2026-10-12 07:59:04'),(5,4,'PAY-48AE48F19F',50.00,'CASH',5,'2026-10-12 07:59:04'),(6,5,'PAY-9EA32D9E0A',6666.00,'CASH',5,'2026-10-12 07:59:04');
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
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipts`
--

LOCK TABLES `receipts` WRITE;
/*!40000 ALTER TABLE `receipts` DISABLE KEYS */;
INSERT INTO `receipts` VALUES (3,'RCT-F04308BA8C',4,'2026-10-12 07:59:04'),(4,'RCT-974CBCCFC2',5,'2026-10-12 07:59:04'),(5,'RCT-569B7BD1B8',6,'2026-10-12 07:59:04');
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Administrator','2026-09-13 17:38:27',NULL),(2,'Receptionist','2026-09-13 17:38:27',NULL),(3,'Dermatologist','2026-09-13 17:38:27',NULL),(4,'Therapist','2026-09-13 17:38:27',NULL),(5,'Cashier','2026-09-13 17:38:27',NULL),(6,'Inventory Staff','2026-09-13 17:38:27',NULL),(26,'INVENTORY_STAFF','2026-09-16 13:14:55','Inventory and stock movement management');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `secure_qr_references`
--

LOCK TABLES `secure_qr_references` WRITE;
/*!40000 ALTER TABLE `secure_qr_references` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (1,'4003','Skin treatments','cleaning & Maintenance','batmna',502.00,20,'ACTIVE','2026-09-24 09:11:56','2026-09-24 09:11:56'),(2,'4001','Skin treatments','derma','need',150.00,50,'ACTIVE','2026-09-24 09:40:04','2026-09-24 09:40:04'),(5,'2001','Injectables','ldc','covid',500.00,30,'ACTIVE','2026-09-25 06:11:17','2026-09-25 06:11:17'),(6,'FAC-100','Injectables','simson','bahalana',500.00,10,'ACTIVE','2026-09-25 06:21:57','2026-09-25 06:21:57'),(20,'4005','Skin treatments','cleaning','SFAFA',50.00,10,'ACTIVE','2026-09-25 09:00:57','2026-09-25 09:00:57'),(21,'FAC-104','Skin treatments','Maintenance','batman',1234.00,15,'ACTIVE','2026-09-25 13:02:05','2026-09-25 13:02:05'),(22,'FAC-106','Injectables','Maintenance','no',6666.00,50,'ACTIVE','2026-09-25 16:05:16','2026-09-25 16:05:16');
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
) ENGINE=InnoDB AUTO_INCREMENT=280 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_refresh_tokens`
--

LOCK TABLES `session_refresh_tokens` WRITE;
/*!40000 ALTER TABLE `session_refresh_tokens` DISABLE KEYS */;
INSERT INTO `session_refresh_tokens` VALUES (1,1,'b7c1136e579e4e09946e7c2d424c1cdaca7e445dddb4867929572ea4e12a462b','2026-10-28 10:48:41','2026-09-28 10:52:49','2026-09-28 02:48:41'),(2,1,'8f4b7894c91c212c49f73833996ea1be1384280f23aac26e2d20f3b8d71f7e7c','2026-10-28 10:52:49',NULL,'2026-09-28 02:52:49'),(3,1,'bd271236e9a685488201522cbf685c1737f1a22a045c3170cd4df6a76f60b57f','2026-10-28 10:52:51','2026-09-28 10:57:29','2026-09-28 02:52:51'),(4,1,'35cc61a0ff3c1066259ab7e37170f04d4a86d2837b8d2c1c08047c04417964a5','2026-10-28 10:57:29','2026-09-28 11:01:30','2026-09-28 02:57:29'),(5,1,'17963c5dc5c0b0e2dd0c713f303d1e0c6e08a4582d4fe78ba1c98206b9b86443','2026-10-28 11:01:30','2026-09-28 11:07:11','2026-09-28 03:01:30'),(6,1,'17a43e31d91fbd002c767cd2f519f4f556bf9c817df04cdb0d50d2ec41ab32be','2026-10-28 11:07:11','2026-09-28 11:26:39','2026-09-28 03:07:11'),(7,1,'fd5f6902105adefbc2bfe7c59ce77d6b7b4e3ed27c9a03e4fb5dd74c111920f4','2026-10-28 11:26:47','2026-09-28 11:30:48','2026-09-28 03:26:47'),(8,1,'3726e928fb7cda6ea43ba9e8323a24785af9ffae7f4c363510d913a4bbfa6afc','2026-10-28 11:30:48','2026-09-28 11:34:48','2026-09-28 03:30:48'),(9,1,'4fb4ea23766ee526350ea42e073c319c06b365144e6fdc5a082dc33fffcb9cf1','2026-10-28 11:34:48','2026-09-28 11:36:20','2026-09-28 03:34:48'),(10,6,'61274bc3bc6d2994436a002052eb01a2d6bc022593721f1e938e5fc0c36eebc1','2026-10-28 11:36:29',NULL,'2026-09-28 03:36:29'),(11,4,'0c20b2b7193f1615c6054c5bb5ff51dc06579770dd481ad8035cf02aaf5582eb','2026-10-28 11:37:16','2026-09-28 11:37:26','2026-09-28 03:37:16'),(12,4,'ee700ddae13bd197bd1f9a006b0d250d57c242a0959a30d6e342eedfd18552af','2026-10-28 11:37:32','2026-09-28 11:37:39','2026-09-28 03:37:32'),(13,4,'32ae7427356c3625eff9bf8aa1962fe501f3cf914925c6ae6807affecaf57378','2026-10-28 11:37:41','2026-09-28 11:38:23','2026-09-28 03:37:41'),(14,5,'c6be8ebe7c4d21073215be35392ee011db3937c34d0893165efa09a8fa39d090','2026-10-28 11:38:27','2026-09-28 11:39:00','2026-09-28 03:38:27'),(15,6,'393f6ae1848d08bcd6acbab07d51bf5285d6e1ccf727a05e0f3c264e5b672bd5','2026-10-28 11:39:05',NULL,'2026-09-28 03:39:05'),(16,6,'ee2e394513b3157a7442f23413f0d00cbbf4b4025b882017c5420184f67c1736','2026-10-28 11:39:43',NULL,'2026-09-28 03:39:43'),(17,2,'31f062f20cbaf101dc8069477bb5a263de34df613e113ce3d9831421157ee2e7','2026-10-28 11:39:53','2026-09-28 11:40:25','2026-09-28 03:39:53'),(18,4,'7356ab442701edfa21e089473a31b2a1de999d07cfa875cc87a7b03c56a5ccf2','2026-10-28 11:40:30','2026-09-28 11:40:47','2026-09-28 03:40:30'),(19,4,'bac91e00233e4efefff3194fac37ac6fff4b3550c967fa735c5385dccbf10d37','2026-10-28 11:41:05','2026-09-28 11:41:07','2026-09-28 03:41:05'),(20,6,'db423196c25a21122c1a8e448c497e68803235b4dc4ad5c85d17247ceea62757','2026-10-28 11:43:57',NULL,'2026-09-28 03:43:57'),(21,6,'fc6a43bd9a49206baf98a4398377dcc615bd9f8eebdc0c67388e316a458788d5','2026-10-28 11:59:10',NULL,'2026-09-28 03:59:10'),(22,1,'c5e7f965e598a4a285b03408ec8bcd631f171c918fed8cd2e3dc65fdece9e47f','2026-10-28 11:59:11',NULL,'2026-09-28 03:59:11'),(23,6,'07505db165f56b61ba436eef612579fa7df1df490ff2a190a8654fc5f30c9119','2026-10-28 11:59:18',NULL,'2026-09-28 03:59:18'),(24,1,'7c6c6d633189780b01472bcc22bfb133d81159c3638e31e3f44fad69fbd3e57e','2026-10-28 11:59:36',NULL,'2026-09-28 03:59:36'),(25,1,'57372d15fe3454532cd49f5a53e309f3f5d461214244cc3add6c1b8696ca27a9','2026-10-28 11:59:50',NULL,'2026-09-28 03:59:50'),(26,2,'3063d51431a950984324d2e1ca6598034106bc2aacba71a168d1ade059184245','2026-10-28 11:59:50',NULL,'2026-09-28 03:59:50'),(27,3,'81530640db93f5b07d38fa332e28807c19a09a07cea69459fb15d79d92ab0fd1','2026-10-28 11:59:50',NULL,'2026-09-28 03:59:50'),(28,4,'c606fd4cadfc43850feccd0ca7dbbc8f5bde9678ea3097971508788e943d1fe3','2026-10-28 11:59:51',NULL,'2026-09-28 03:59:51'),(29,5,'d0f0c545937ee3aeaad083a299e3cc9a51fad8e2dd715b58413feb84095bdc1c','2026-10-28 11:59:51',NULL,'2026-09-28 03:59:51'),(30,6,'288a6e5dcdd04e9ebe6b84f47637f32e33d01f12c28a19d4c1a084979708201c','2026-10-28 11:59:51',NULL,'2026-09-28 03:59:51'),(31,6,'e6d534131e5e80adcd77e864a2c583f668cfa1b0f6c9cf4991a3b0e2186dc0ff','2026-10-28 12:03:21','2026-09-28 12:04:09','2026-09-28 04:03:21'),(32,1,'dbdd05956c1076cf5b83b1fd3221d8e847330cf901563b599cd59acd17955127','2026-10-28 12:04:14','2026-09-28 12:08:56','2026-09-28 04:04:14'),(33,1,'95015e6644bdc48311bc311feadb85ae52f0b242e644cc12e599b63bceb1bf8f','2026-10-28 12:08:56','2026-09-28 12:23:56','2026-09-28 04:08:56'),(34,1,'e0a3064064fb366601aa4f4708ce5bafc6f262c8bfda64bf665c8dc7670cb61d','2026-10-28 12:29:27','2026-09-28 15:50:22','2026-09-28 04:29:27'),(35,1,'57241d0f4a0248059a70e151c34e40b022eb2995ddecbe6445f4f1bba0aae0d5','2026-10-28 15:50:26','2026-09-28 15:53:12','2026-09-28 07:50:26'),(36,1,'0f6418c23d1574ba27cd88fd487b63fd42c3dbfabfe6d513b558b3d62b6dfcc3','2026-10-28 16:22:14','2026-09-28 16:24:10','2026-09-28 08:22:14'),(37,1,'b7eae491dfe391cdc9c5e2712509c10ba3418a5d1bea1b4211ba556fc4f80aea','2026-10-29 01:23:41','2026-09-29 01:27:46','2026-09-28 17:23:41'),(38,1,'9f7065095547391645ebf01a6b0ab1a47fe5e40174513493e94e3b853896270e','2026-10-29 01:27:46','2026-09-29 01:28:21','2026-09-28 17:27:46'),(39,1,'447ea6912e99438b809fc27fbf2b723c3757772cc0028e150fa8bf9ac17bb88a','2026-10-29 01:30:34','2026-09-29 01:36:46','2026-09-28 17:30:34'),(40,5,'ee2a26c62e5437f52365942c2bb103bce10f8eef03cc0a9e520ed9fd651aa7e8','2026-10-29 01:30:50','2026-09-29 01:47:33','2026-09-28 17:30:50'),(41,3,'811a0fe77e10b37060280e18ab1d709f3b9f9e7be96f51a5198d9efa39e6d198','2026-10-29 01:31:49','2026-09-29 01:46:28','2026-09-28 17:31:49'),(42,6,'6cb606431277c29f81869ce4622f26cbbb1e743ef4ff73b456b302ea2d711ebb','2026-10-29 01:31:58','2026-09-29 01:47:49','2026-09-28 17:31:58'),(43,2,'3cc7ced37d2ef59e38836645e2a72976da3b43f8f2b30b9ec2d62fdf109dd4ce','2026-10-29 01:32:08','2026-09-29 01:47:46','2026-09-28 17:32:08'),(44,4,'175dc00f5bec9168e890021e00b1c62b81912311a0e289e7a7148362f5bad52b','2026-10-29 01:32:24','2026-09-29 01:46:32','2026-09-28 17:32:24'),(45,4,'b273dd8f20c77ac5e40c6718a57c6dbc97844e185caaba63db1577d983955041','2026-10-29 01:46:32','2026-09-29 01:57:47','2026-09-28 17:46:32'),(46,5,'c01d11321cf5b2f96c1e25cb8d5032058e81c01f4a6ee2e26174136b72a03e95','2026-10-29 01:51:51','2026-09-29 01:54:34','2026-09-28 17:51:51'),(47,5,'912d82add365a55b037c24d3ece8b928ca7868e69afecbe885b32e3827c48e7a','2026-10-29 01:54:43','2026-09-29 01:55:43','2026-09-28 17:54:43'),(48,2,'96e1a3bb06f62697ce0c1f41cd8bdee628693c304eaa9ac3d4a68419b6cad95c','2026-10-29 01:55:50','2026-09-29 02:13:19','2026-09-28 17:55:50'),(49,3,'12294aa6ed2f485d51d931ce37388f7be586e3ec2357a8dc8d8fc679a3fa011a','2026-10-29 01:56:24','2026-09-29 01:56:38','2026-09-28 17:56:24'),(50,1,'702f6804df36b1434f4f00568fc7175a05b543ef9bdb8aade26280c291736d25','2026-10-29 01:56:43','2026-09-29 02:13:19','2026-09-28 17:56:43'),(51,2,'31b099a9cd35dda63cfbe99b9ad370e351919214f93403933c84874d0558fbc9','2026-10-29 01:57:56','2026-09-29 02:13:19','2026-09-28 17:57:56'),(52,5,'7c1e6b332a95a85a5601acaaad22baa8c91f7f613db01cf05b21ba89062408ad','2026-10-29 01:58:17','2026-09-29 02:14:14','2026-09-28 17:58:17'),(53,5,'e9f714991dc002acd46d8be8a08ab4a0d98f52b0dbbeff00446d053991e35348','2026-10-29 02:14:14','2026-09-29 02:14:17','2026-09-28 18:14:14'),(54,1,'0defdd78feb2e36019727d5e7b30116b6174459686ae6e432f1fad0cda6e3c65','2026-10-29 02:14:28','2026-09-29 02:18:39','2026-09-28 18:14:28'),(55,1,'2172f1fd3b09a1013a6e4f88bab812d64785c5503f7a2bea0e105dbbc98f590c','2026-10-29 02:18:39','2026-09-29 02:23:21','2026-09-28 18:18:39'),(56,1,'7834353e1e9d1c95d9a9893eb5d64b33a9809cc2f6c9d3d9c58a399052e65018','2026-10-29 02:23:21','2026-09-29 02:27:22','2026-09-28 18:23:21'),(57,1,'1b036dc9fccd30a95940b46acb511391ea5cfc8b0ab578c513a9acf492c65f49','2026-10-29 02:24:45','2026-09-29 02:28:50','2026-09-28 18:24:45'),(58,5,'5bf381d982b83ac3a310236ddc5c9b4c78e3ecde9076028ee450fc864fda53e7','2026-10-29 02:26:09','2026-09-29 02:35:11','2026-09-28 18:26:09'),(59,1,'b63aee362985dedddf7688c1e20a5b306cabd7c53492eb2ad85b7e8651ed1548','2026-10-29 02:27:22','2026-09-29 02:32:15','2026-09-28 18:27:22'),(60,2,'cac2536abbe615fc7227dc797f8800d30086ac66a9973ac2e552046c4ae935a0','2026-10-29 02:27:39','2026-09-29 02:43:00','2026-09-28 18:27:39'),(61,3,'350696605046c2f69fc2797d8ffde3eb5602636556e1de460b8b4ee947773361','2026-10-29 02:28:49','2026-09-29 02:38:33','2026-09-28 18:28:49'),(62,1,'e5c99ed49968371cacddea637ee10e2e24d853af3f5f102394564f953051f0a7','2026-10-29 02:28:50','2026-09-29 02:32:09','2026-09-28 18:28:50'),(63,4,'972895c8b47b0978edec322a7e3b1dd3de47ec2573e3d1be9f574eeb5b72447c','2026-10-29 02:29:17','2026-09-29 02:36:28','2026-09-28 18:29:17'),(64,3,'ecc0f3febd45bad59f5851272a6c2058d12982b48e8f53177f36252b20143741','2026-10-29 02:32:15',NULL,'2026-09-28 18:32:15'),(65,1,'f3089e574bb44eee12cae7bea169925ce6300d38f666653290d05339d4251aa1','2026-10-29 02:32:15','2026-09-29 02:37:11','2026-09-28 18:32:15'),(66,4,'a76ede0033e5472a5908ad100f87b698b8b2d7977de8f150d787b568a0cabd87','2026-10-29 02:35:17','2026-09-29 02:35:30','2026-09-28 18:35:17'),(67,4,'50d2bc920601fe7344b7af89fe615595e0bf63ae9d93f2b35af27a2798d1e1b9','2026-10-29 02:35:34',NULL,'2026-09-28 18:35:34'),(68,5,'e55d9c6ce145ab79382f85d63e77b88242fa3fe89773d5768be8b17112482222','2026-10-29 02:37:10',NULL,'2026-09-28 18:37:10'),(69,1,'5b08d4e6941f2ae8f6a9e155a3ad721f7d2b775073268dbe2e8c317251fcfb52','2026-10-29 02:37:11','2026-09-29 02:42:00','2026-09-28 18:37:11'),(70,2,'41621db51cfaea654d2bdcee67dec2d04e1b6dd6527bf1d810b9294a227e0c8d','2026-10-29 02:38:40','2026-09-29 02:43:15','2026-09-28 18:38:40'),(71,1,'bb8a7074e416cda3cd2340c35e6fcbbd31f698f39b205943663aac4f2f98cfea','2026-10-29 02:42:00',NULL,'2026-09-28 18:42:00'),(72,2,'64a520b0c9c2c44e35b1165f8efd4a5918610c1af466c4afa19b34009dd7315c','2026-10-29 02:43:00',NULL,'2026-09-28 18:43:00'),(73,6,'9aea22625487c8f355e61590b40fee5ff522f8b4b306e1852aa1e3d7997d1b6f','2026-10-29 02:43:21','2026-10-01 04:45:37','2026-09-28 18:43:21'),(74,1,'3e8c284bbc63e9688185acfed7cb440bb65cadcdf93b40a5d76967b38377c6e9','2026-10-31 04:19:43','2026-10-01 04:33:31','2026-09-30 20:19:43'),(75,1,'16633b85b68a8cca1c9ba9f614b9196bf39051ad6ffcad6fb6ad9be17e7944e8','2026-10-31 04:33:31','2026-10-01 04:43:55','2026-09-30 20:33:31'),(76,1,'3bdbdbecea6292e1849a0a2c0d0148c9d080f94e97244124d7fb6d317ef08cda','2026-10-31 04:43:55','2026-10-01 04:48:56','2026-09-30 20:43:55'),(77,1,'6437aeec424bfb1689514cd27cbcff87cb0880748268d83737a6180442096193','2026-10-31 04:45:45','2026-10-01 05:09:06','2026-09-30 20:45:45'),(78,1,'7c67914cf373d23c45a80be1792be94dc02cd86b245aeecce658d4d961959b0c','2026-10-31 04:48:56','2026-10-01 05:09:05','2026-09-30 20:48:56'),(79,1,'33c2fd2a76ef9d90dc0446f2a8876cac0024fd132c8dc146da29ca8bad4e54b7','2026-11-01 06:47:04','2026-10-02 06:51:04','2026-10-01 22:47:04'),(80,1,'3eda71f902ecb54571b7c3b1975d7b7a8a23d13765f1110ee10508800682910d','2026-11-01 06:51:04','2026-10-02 06:55:05','2026-10-01 22:51:04'),(81,1,'8cedc5291be937cbf9f33f4349451803dfd67c1d812589405eec264d0121b0db','2026-11-01 06:55:05','2026-10-02 07:00:20','2026-10-01 22:55:05'),(82,1,'24bb973c8998cd625ef3ba26b55b05ad71d7ec1b9c4f42cb3615d4b2df234a91','2026-11-01 07:00:20','2026-10-02 07:03:44','2026-10-01 23:00:20'),(83,5,'8a1ac3e7fbee6cf80792674fdd5f8f1ae3eaac414cc7692dba0acf791deb79bf','2026-11-01 07:03:49','2026-10-02 07:04:02','2026-10-01 23:03:49'),(84,2,'cbeae91a91bbf434a92401ce233f6a614df711fc83e4c7743fc05a2c0f515d83','2026-11-01 07:04:10','2026-10-02 07:05:50','2026-10-01 23:04:10'),(85,2,'71dfebd31408397a3cd68c6dbc310c3450bc99baee8fd349a4b7e84f1c1b338e','2026-11-01 07:05:57','2026-10-02 07:06:15','2026-10-01 23:05:57'),(86,5,'2f8304015db83a7e91a07a30f5d2873df5768a9a30745ec36ca1cfb963375758','2026-11-01 07:06:21','2026-10-02 07:06:46','2026-10-01 23:06:21'),(87,3,'87b8d81dec907f0b66952f27450e808c892b6622d7fb19d41dc067ffad8cd7ea','2026-11-01 07:06:50','2026-10-02 07:09:59','2026-10-01 23:06:50'),(88,3,'5aa3c46ba3d789c76aae6c4cfd3380835c88bcccc6dffea3269d85f87c0ad3b5','2026-11-01 07:10:02','2026-10-02 07:11:06','2026-10-01 23:10:02'),(89,2,'cee8973e5a76e60b2204fc03f2a9a04e0f7b72424e00e4920e2b3c3a1df676f3','2026-11-01 07:11:11','2026-10-02 07:11:20','2026-10-01 23:11:11'),(90,4,'1fd34a89fac4649a8dd94d659009bc1444e1428a3ee574a9f2631e034b506428','2026-11-01 07:11:26','2026-10-02 07:12:45','2026-10-01 23:11:26'),(91,4,'88f1f0531b0436eb05689d0d2592ebd9ce6c92ca946e5781ce3141321ab2e0de','2026-11-01 07:12:48','2026-10-02 07:13:28','2026-10-01 23:12:48'),(92,2,'8dc2e1fd76b1cb1a99daf9c0c5f9e979e4c4f451eaddff530dd84be8710bd50c','2026-11-01 07:13:38','2026-10-02 07:14:56','2026-10-01 23:13:38'),(93,5,'8e56f04a6629a953d3a81fa91e6ebde31d0a062b1706a961c0132ea27b58d2c4','2026-11-01 07:15:04','2026-10-02 07:15:57','2026-10-01 23:15:04'),(94,1,'965e06ae0e4132c1d954e4d0e0f2d86590415a73df0c57a4d44d5f66346c39be','2026-11-01 07:16:05','2026-10-02 07:20:05','2026-10-01 23:16:05'),(95,1,'b951b025bd9671e07eacf76db450a290f8b9500c379a672e2652116f2634f738','2026-11-01 07:20:05','2026-10-02 07:24:05','2026-10-01 23:20:05'),(96,1,'5e73e9572d3fe36ca6f6c5968a0b6ad1784d86f35beded4262c279a99231866b','2026-11-01 07:24:05','2026-10-07 03:27:01','2026-10-01 23:24:05'),(97,1,'5b1eea1f2adc7bf63182a69ec0e3a879cc8fa438d6267d14c3e422e6654aa88f','2026-11-06 03:27:22','2026-10-07 03:36:28','2026-10-06 19:27:22'),(98,1,'972c937e67052db159fdb4ae55145071b92e996a5af09d0148465d7436387500','2026-11-06 03:36:28','2026-10-07 03:46:22','2026-10-06 19:36:28'),(99,1,'70e333a60932d1d096b30274cb68a0c7047d00923322834844e93f7b6cf49973','2026-11-06 03:46:22','2026-10-07 04:01:23','2026-10-06 19:46:22'),(100,1,'545598944c0323bd949fd70a4b0a47b33fa5a3401458b7985ce724ed2382462c','2026-11-06 04:05:30','2026-10-07 04:05:37','2026-10-06 20:05:30'),(101,5,'2897ec35ca83cb8994658b57aed119e5b9004823ff796fac8024f29d16fc59d9','2026-11-06 04:06:28',NULL,'2026-10-06 20:06:28'),(102,5,'6c3a5b5d7b15068b51daf7ff53b5abae00a3ca471364ca1a8bd5f17be3957250','2026-11-06 04:19:17',NULL,'2026-10-06 20:19:17'),(103,1,'305abd4e52a901c5bb9c59e9177b5a34d790ba646509a0848f5fd1c821707484','2026-11-06 04:19:29',NULL,'2026-10-06 20:19:29'),(104,1,'01f8bb7dd3144b742e26429f78db2c36c4701de0c17d90f4c5b594a32ba73faa','2026-11-06 04:19:56',NULL,'2026-10-06 20:19:56'),(105,5,'33ef76c2a6a2c5575dc16dda5d916198d32693af525e96abe32e4453094f7aff','2026-11-06 04:21:33',NULL,'2026-10-06 20:21:33'),(106,1,'8de93b2e5f905b3af1f428c054e2e9c01626cd13f005583d389354caff4661b3','2026-11-06 04:21:42',NULL,'2026-10-06 20:21:42'),(107,3,'e84322c54f73e4d674409d59a141f43a256c844e16fc4b1f67e8d1aea5d08cfd','2026-11-06 04:22:11',NULL,'2026-10-06 20:22:11'),(108,3,'bc55ec07e8638f55a81fd614f5feb5ea8aa902bafd23450a91cc666eebca276b','2026-11-06 04:22:19',NULL,'2026-10-06 20:22:19'),(109,1,'1dedc8a02b27e53a63001b6ab50efabd200ffe5c0316b0cede20187fd1cb68e4','2026-11-06 04:22:25',NULL,'2026-10-06 20:22:25'),(110,1,'2073fbc0f1f6a1e99088216ca271658c83f4df9e7102d86789215f29bcdddf94','2026-11-06 04:22:32',NULL,'2026-10-06 20:22:32'),(111,1,'c0d0aedb33dc924c6f6ad4c1d33ec92b8fdd0296d06c4446fd4f7ed8a7b669c7','2026-11-06 04:22:39',NULL,'2026-10-06 20:22:39'),(112,1,'bc70af663ea548c53b552e9893a00433690d055cbab5f9939f0a9597b8f2450a','2026-11-06 04:23:03',NULL,'2026-10-06 20:23:03'),(113,1,'32d6f39ca7792592ed234befc5fb43c2121af81fd3411bc6b265ffa896a042cf','2026-11-06 04:25:28','2026-10-07 04:27:04','2026-10-06 20:25:28'),(114,1,'43699a0c807d079d652441a5d0205370938f3c9a9885108437adf13878d2832e','2026-11-06 04:25:42',NULL,'2026-10-06 20:25:42'),(115,1,'58c05f85a78ee172ab7b86b3c13aea04a4fb23200e3b84e1d6bdc2f2a966ee80','2026-11-06 04:26:51',NULL,'2026-10-06 20:26:51'),(116,1,'30d6a241b817a1a65791132fac31779d4bbf2247a7cd18c46536edef4c8f1d37','2026-11-06 04:40:50',NULL,'2026-10-06 20:40:50'),(117,4,'cd71efa8a7a357baba963861223bc008922619837e0fe34e6635518ffcd6a404','2026-11-06 05:24:05','2026-10-07 05:30:57','2026-10-06 21:24:05'),(118,5,'df1fb2cc6a8ffd31ad686d5b7afa170f1d238aa935781a3f29e6746eb20b88ad','2026-11-06 05:24:30',NULL,'2026-10-06 21:24:30'),(119,1,'57f3c7831b97c51c3123235481dfae170449931d011146fadf0dfa0360642eb7','2026-11-06 05:24:46',NULL,'2026-10-06 21:24:46'),(120,5,'c5a1fe854de26b2df12c19c1b5fb17df90e6b0e9ddd571852479e0284e36953f','2026-11-06 05:24:56',NULL,'2026-10-06 21:24:56'),(121,3,'a44821b59f79a219b1e8eed9cc8bdaadac306b43db651672cd1ae9f61e2bf226','2026-11-06 05:25:03',NULL,'2026-10-06 21:25:03'),(122,6,'671dc856679660cc29cc7b8e4cbeaa6e7fb5f7efd17ce4e5af137dd423d38d91','2026-11-06 05:25:20',NULL,'2026-10-06 21:25:20'),(123,6,'dec97b47e744d758b594549036d23d8760aeca5cd484b6bad22934912844a381','2026-11-06 05:25:22',NULL,'2026-10-06 21:25:22'),(124,6,'587fad0dee4029d819bf7ec0df8af59268e504329ced853a2e3a693b73a6f294','2026-11-06 05:25:27',NULL,'2026-10-06 21:25:27'),(125,4,'3c9da6b0ebbf95c74eb76576fff3d1616bbaf79880c1fb2cc8c5467371112869','2026-11-06 05:25:33',NULL,'2026-10-06 21:25:33'),(126,4,'9dfd85f87aef1556ac0760bcfddc36742bd4d1d958848e9e6f02195891776dea','2026-11-06 05:25:34',NULL,'2026-10-06 21:25:34'),(127,2,'29b2573bb2f4395516995c69d9fc3cb2a782d0b3076acc8b50168c811159af2f','2026-11-06 05:26:52',NULL,'2026-10-06 21:26:52'),(128,4,'a94641d6813c24ecf039748c4ca298cd255dec12630509a25d06358a8a0a9c28','2026-11-06 05:31:19','2026-10-07 05:32:38','2026-10-06 21:31:19'),(129,4,'1ba83ca5ddb1899aad1b5d86356143f691fb5db17c06b828187273c409e0f517','2026-11-06 05:33:43',NULL,'2026-10-06 21:33:43'),(130,5,'4a4a2bf2798b2ea1fb4baeba643f52411ffe3f9e90ca5a8369ea46d025cad3d9','2026-11-06 05:34:04',NULL,'2026-10-06 21:34:04'),(131,3,'9bd2f4efc11b34960cb6a505781c3b14f2332c6e29086adbf6ae3d2481a84fdd','2026-11-06 05:34:25',NULL,'2026-10-06 21:34:25'),(132,6,'ca90074093a0e5b6c585227e39f14f1db4b434cfa786f80ba03a82d1893cbea3','2026-11-06 05:34:54',NULL,'2026-10-06 21:34:54'),(133,2,'5de504d2a52ab8b59172de0e7632d0db204e8fd5b7f7671ef701d5e904720b8e','2026-11-06 05:35:16','2026-10-12 03:28:17','2026-10-06 21:35:16'),(134,4,'c37db3fca8693c5992415912d0582767ee02ddc873363cd2de2c25ca46b898f1','2026-11-06 05:39:28',NULL,'2026-10-06 21:39:28'),(135,1,'6df7e1933560233a383bd42b8793c667ee7062ecada5e76f5e73fa0fe8e332bd','2026-11-06 05:39:42',NULL,'2026-10-06 21:39:42'),(136,1,'27dc6ca8d3768fd15d87f0c0a00bb3195da4fea70f3008e43435166bcfa7e98e','2026-11-06 05:57:31','2026-10-07 05:58:00','2026-10-06 21:57:31'),(137,4,'c80acef14ff3f748f7fe62c11f2549eace15af8bb85529312845763ab9fee1a1','2026-11-06 05:58:25','2026-10-07 06:15:34','2026-10-06 21:58:25'),(138,1,'a823a5e3d733136a37febefad80642e3171396d17ea6396b5184d4083fd51ab6','2026-11-06 06:58:37',NULL,'2026-10-06 22:58:37'),(139,1,'401255ba6ea0ed316f4ffb70c383df1c53f90984e10e320613e4656b1fdd4a38','2026-11-06 07:05:58',NULL,'2026-10-06 23:05:58'),(140,1,'d3694dd1ef081bf5878bb2e4baec49e9863b77497758ba3e166acad3988564af','2026-11-11 03:23:21',NULL,'2026-10-11 19:23:21'),(141,1,'bf35482ca121eafee29291cfb3302431db30304a3c2dabf7c32648496f79f7e8','2026-11-11 03:28:35',NULL,'2026-10-11 19:28:35'),(142,1,'a687420e4eedcf0a0711fe75207ab19ce453eb7154216755cfe81cc6d07c5e47','2026-11-11 03:39:51',NULL,'2026-10-11 19:39:51'),(143,1,'c1e2d9634fa29e2394ea58976d6a4979061e1f54d30e87db260af1ed582c0b6d','2026-11-11 03:40:59','2026-10-12 03:45:01','2026-10-11 19:40:59'),(144,1,'daafead094999abcbd590af22197f8c50e5ed6ed10f13f4c8c0a8e0479a9cdba','2026-11-11 03:44:40',NULL,'2026-10-11 19:44:40'),(145,1,'6cf88dc7e54714219338f50439635f737036d1763eb2e5682fd52f764665e5ef','2026-11-11 03:45:01','2026-10-12 03:45:56','2026-10-11 19:45:01'),(146,1,'b31b91b069ded6a7458de49d96592e8ba324d2e3e5f3b16dc8b124be6786e6eb','2026-11-11 03:49:54','2026-10-12 03:56:31','2026-10-11 19:49:54'),(147,1,'e5fef518100ced631dfdc95e1d21d336c0af7620ee5264a10b4071ff49b0e715','2026-11-11 03:56:31','2026-10-12 04:06:44','2026-10-11 19:56:31'),(148,1,'2daa077875debe03036085f8486d56abb108efa3295fcfbdf28340beec35d782','2026-11-11 04:06:44','2026-10-12 04:13:34','2026-10-11 20:06:44'),(149,1,'cd1034be1296e9b1428d0a7a9e2ead40158cce445f95e8b4d8cc5a03433a48f0','2026-11-11 04:13:34','2026-10-12 04:18:06','2026-10-11 20:13:34'),(150,1,'f2e554ee2789d08e59f8a245873a9af9bcde7351a6d13113e4cca7996a333179','2026-11-11 04:18:06','2026-10-12 04:22:06','2026-10-11 20:18:06'),(151,1,'fa9e7e7cffde1b00cdbaea4bd9727fdc179039476a51741aee74f833e3ef9795','2026-11-11 04:22:06','2026-10-12 04:27:28','2026-10-11 20:22:06'),(152,1,'d11f364a1e16ae31e7e7f46b3f8e230bf1495e156ab6d95e7ecf524ab16a32b0','2026-11-11 04:27:25',NULL,'2026-10-11 20:27:25'),(153,1,'e4b673a7e16765def159f124b92bc4d766fbd1fd51d50ca9f69c92abf09af0c4','2026-11-11 04:27:28','2026-10-12 04:32:12','2026-10-11 20:27:28'),(154,1,'42344b9a3e096fe6d6f6a63bd19be21530dbcda590c250f529c1c54fd642d3fd','2026-11-11 04:32:12','2026-10-12 04:36:18','2026-10-11 20:32:12'),(155,1,'a5b5a2adfee28204f9aac5e1ffd543c283e085240339ed209381113a7e14271c','2026-11-11 04:36:18','2026-10-12 04:53:48','2026-10-11 20:36:18'),(156,1,'e6037d09827f349fc6955fabf3e819cb36c87f4521c0f4db271826c0ec26851a','2026-11-11 04:36:48',NULL,'2026-10-11 20:36:48'),(157,1,'2a42f6099337598783b776b3a59994195c3c5b0d7e2a6e29d97aa5cc612db8a6','2026-11-11 04:41:29','2026-10-12 04:49:06','2026-10-11 20:41:29'),(158,1,'93c44f1be6b10e497237cccac3c11850e88826f65079c02282eafc834613a457','2026-11-11 04:44:09',NULL,'2026-10-11 20:44:09'),(159,1,'750e8c4abc0baa1878b43a3560100cda297f240cd92165fd14f37721ac370dd7','2026-11-11 04:45:46',NULL,'2026-10-11 20:45:46'),(160,1,'1e0b0549d2647f71c13e59c62eb5f0c0ac342b274a4110f81ddda0b2c1193858','2026-11-11 04:46:36',NULL,'2026-10-11 20:46:36'),(161,1,'b0b77650e1975f5bf4353eeb76c25663139f734f4c2ee170868357d0d36ebe3f','2026-11-11 04:46:44',NULL,'2026-10-11 20:46:44'),(162,1,'e3bcda29659213996c489e38eaa2846f6c58f672bd18433679eb21e6b2f26707','2026-11-11 04:48:32',NULL,'2026-10-11 20:48:32'),(163,1,'6eac6b29fdf93472335e06d2841207b52d5d10b2821a35dc2199281dfe397770','2026-11-11 04:49:06','2026-10-12 04:53:34','2026-10-11 20:49:06'),(164,1,'9c1d46141d4f2d159d157188797f7b03bed35569671b2b9fe7406ee615f1863e','2026-11-11 04:52:37',NULL,'2026-10-11 20:52:37'),(165,1,'c98791588c15fc1d3181509a4328b0d903b182e7901f51ebf3a06963904a4bc2','2026-11-11 04:53:34','2026-10-12 04:57:55','2026-10-11 20:53:34'),(166,1,'70528e82ab08a8583ee263fdb7df560cc88068636daef3e6f9c94e827d932fdb','2026-11-11 04:57:55','2026-10-12 04:59:20','2026-10-11 20:57:55'),(167,1,'4787b51954fb047f115a26b7bafd7454e9e5900fcd206ef7bd36267d87d6769e','2026-11-11 04:59:14',NULL,'2026-10-11 20:59:14'),(168,1,'ec947dd5465f35fcf4110a90a89525bf7adea0220790ffbea04cc4c0d2c0bba2','2026-11-11 04:59:28',NULL,'2026-10-11 20:59:28'),(169,1,'0ef65c076a51477bff3227c9ff34e6c6d25aca3ed659b032f3db24a32cf0c74f','2026-11-11 05:01:17','2026-10-12 05:05:20','2026-10-11 21:01:17'),(170,1,'ab8df9186baba73d77ab6fbb52d8a5b720915cff16ec61df601e0b2012f1053c','2026-11-11 05:04:15',NULL,'2026-10-11 21:04:15'),(171,1,'93051601a486ad65f739aa2076f8354b2d88a83b28c7d933ccbb5238fc287758','2026-11-11 05:05:20','2026-10-12 05:09:22','2026-10-11 21:05:20'),(172,1,'9f87c366b9a396dc4df31340078d601c66e9c3dd2c7fd7bd39bda80841f318bb','2026-11-11 05:09:22','2026-10-12 05:24:30','2026-10-11 21:09:22'),(173,1,'9fe919ba8d6ebfb647dfff5d1baf1194afc540ee157662469a611f844125ef23','2026-11-11 05:10:39',NULL,'2026-10-11 21:10:39'),(174,1,'ea0afa909e4b1b104797310a4cf4783d4d984979957e25a1f401b8b0be93b4e9','2026-11-11 05:11:25','2026-10-12 05:15:25','2026-10-11 21:11:25'),(175,1,'c83d17067851ea254f474b7d4fbd59b2fdc610725e97bf6a2ee5cc969e7488b6','2026-11-11 05:15:25','2026-10-12 05:19:26','2026-10-11 21:15:25'),(176,1,'db0d16aa472696199bbde0e6a148c260e55f4d30205245a335828fa9b4e8a81b','2026-11-11 05:19:26','2026-10-12 05:23:54','2026-10-11 21:19:26'),(177,1,'b7900588cddf8de3fab859eec324f6cf46b6684106c98532a1652ed259c3c12e','2026-11-11 05:23:54','2026-10-12 05:27:54','2026-10-11 21:23:54'),(178,1,'b5f046b9a4b85702f1f39fe25e61207b18f3035c2bc0e4dea38e7a42b88cedb3','2026-11-11 05:27:54','2026-10-12 05:32:02','2026-10-11 21:27:54'),(179,1,'56982b5bd659c62b60250d8b1de2819905551ac84975b420fb88d5a6df9f7512','2026-11-11 05:32:02','2026-10-12 05:36:03','2026-10-11 21:32:02'),(180,1,'d12f3ca632fbeedf7bd778385bb96b605bff45f8589b0cd3511eeb06fe2eac3c','2026-11-11 05:36:03','2026-10-12 05:41:27','2026-10-11 21:36:03'),(181,1,'4d7da0579467e6e1ae54e76bfe027e72b0ade4a0b9da36ea23d448c27314d50b','2026-11-11 05:41:04',NULL,'2026-10-11 21:41:04'),(182,1,'a965ef7720773ce68a453e9ee499a2852e4642a384735d44d236666e858f3812','2026-11-11 05:41:27','2026-10-12 05:59:00','2026-10-11 21:41:27'),(183,1,'81311582118abe6fe1f3c7783b0e363ab835a0ae252aaaf886317b98c264e1b7','2026-11-11 05:46:00','2026-10-12 05:53:40','2026-10-11 21:46:00'),(184,1,'374d6b4828138d823a10884d15e8a45ba21f3d1c7a280aa846e831f3b276588c','2026-11-11 05:53:40','2026-10-12 05:57:52','2026-10-11 21:53:40'),(185,1,'62e83299f32bd747dc83f698df36d7022244dfc100df1d15b18a7402cee73432','2026-11-11 05:57:52','2026-10-12 06:01:56','2026-10-11 21:57:52'),(186,1,'512bdb3034f4153c4a9f8b3c12ab995fde4eab97eaf5ce6f943b0036cfc9a448','2026-11-11 06:01:56','2026-10-12 06:07:17','2026-10-11 22:01:56'),(187,1,'7118d8e9da38f6b120067079717b34d48f5ffa04686024139f559655383b2c18','2026-11-11 06:07:17','2026-10-12 06:18:27','2026-10-11 22:07:17'),(188,5,'edfd1ce3aa3c518dfde6d03eeccb1a44a45ec064ae852b6f15e07efb28ef8f52','2026-11-11 06:08:53','2026-10-12 06:09:27','2026-10-11 22:08:53'),(189,5,'9df0acd771cf207d6d5b5c4fca5c78e78361ba48f5956f44144b9d002307e6d0','2026-11-11 06:09:30','2026-10-12 06:24:57','2026-10-11 22:09:30'),(190,3,'d6fa4d7720b4031edf3d9cbabd89c5659176e391df0d75bc61f2744aa82c7e1b','2026-11-11 06:10:11','2026-10-12 06:25:14','2026-10-11 22:10:11'),(191,6,'5b053ca03e203acf556d9d701d6efe111b62f31b06f22bc192d882de9ad6f701','2026-11-11 06:10:32','2026-10-12 06:25:36','2026-10-11 22:10:32'),(192,4,'58bfbbbe1ddeed0267fd93222c7b2edab6f574d5a30feb219f410fde2751a22c','2026-11-11 06:11:23','2026-10-12 06:33:25','2026-10-11 22:11:23'),(193,1,'9e15c652c4360bda376e6c975640a04efb2d7e90983bcaa75c71b3f130a80dcb','2026-11-11 06:18:27','2026-10-12 06:22:46','2026-10-11 22:18:27'),(194,1,'3967ca9540b128aad5fc4a3003841452710ced4bdd12327cea81729c44b98b79','2026-11-11 06:22:46','2026-10-12 06:28:23','2026-10-11 22:22:46'),(195,1,'d99408eaed70ceac173f6e227f81f4f556b17e96104e0d846310a9ef75c4cb49','2026-11-11 06:27:13',NULL,'2026-10-11 22:27:13'),(196,1,'87fbefa932647d362840911b437182d3e52284b6dbed600ac23732ebc3d6b744','2026-11-11 06:27:50',NULL,'2026-10-11 22:27:50'),(197,1,'d5e2eec8f7f3ba619b6e3183fce77baa75919b714da18c60ef1d7e549d220a83','2026-11-11 06:28:23','2026-10-12 06:33:48','2026-10-11 22:28:23'),(198,1,'b19454de9698d7670eb0f5819d9141e3966079b817f377aef0812da43099ca3c','2026-11-11 06:30:12',NULL,'2026-10-11 22:30:12'),(199,1,'258d8709184d5ee7fab22d085f63e2cc33f670f0191286f6c4a839821c731aea','2026-11-11 06:33:05',NULL,'2026-10-11 22:33:05'),(200,1,'017331600846d4440836101d75de5b052bc544bdee90cbc5bde62cb9c91b47af','2026-11-11 06:33:34','2026-10-12 06:33:35','2026-10-11 22:33:34'),(201,1,'1a416905a1ffc04ccd9a09c6a75c15fff0364fb2957e9abb6550303e155b318f','2026-11-11 06:33:35',NULL,'2026-10-11 22:33:35'),(202,1,'d1de048e3e968cf4035846a92b661a2c1ddb05d687d7a517368478ba782433e4','2026-11-11 06:33:48','2026-10-12 06:39:13','2026-10-11 22:33:48'),(203,1,'49e7fa8816902cc2af048db697bb2744dd5216b999569952a47d9e821b0372d6','2026-11-11 06:37:34',NULL,'2026-10-11 22:37:34'),(204,1,'3c1964420d4fd3b83eae44577e2515cc46fd3883cea8f13181dc0649732fcaec','2026-11-11 06:37:41',NULL,'2026-10-11 22:37:41'),(205,1,'40836946bb860d80ae730d4923bb1eebbb501fa7ed14c502b1d429e2328a7914','2026-11-11 06:39:13','2026-10-12 06:57:53','2026-10-11 22:39:13'),(206,1,'6cdc24ccec1a4714905b32c393910c20d2bb06776b0256777dfdc469c0d9e5ab','2026-11-11 06:40:44',NULL,'2026-10-11 22:40:44'),(207,1,'cf224ca3e98acb5389f91e630964ef7102764a13fc1ae48040cd42128df5f2fa','2026-11-11 06:41:21',NULL,'2026-10-11 22:41:21'),(208,1,'b498f29cd72d39dcfc3c9a1c2fceb37975273041e36294bd49b9b778a8ba14b3','2026-11-11 06:43:41','2026-10-12 06:48:41','2026-10-11 22:43:41'),(209,1,'d1ffff8f2c113f0ad703dcb44f3a5cb99d3078314b064a30c3e9f4c822e08ad5','2026-11-11 06:48:41','2026-10-12 06:53:41','2026-10-11 22:48:41'),(210,1,'77192cd69542f3d39ca056e07d3d89ba6dbdc349528541ae35eebd01f67a3915','2026-11-11 06:53:41','2026-10-12 06:58:42','2026-10-11 22:53:41'),(211,1,'f51acf26c04b5422352aaeb14244e9a1ca264300eeeecebbe355635463b51bf9','2026-11-11 06:58:42','2026-10-12 07:03:43','2026-10-11 22:58:42'),(212,1,'c93c7864fd208016374bd734c4b644104e7f994a9222f2abd6d9b108f4c63256','2026-11-11 07:01:04',NULL,'2026-10-11 23:01:04'),(213,1,'e8729286eb12c50cf58ea623ab15dc5e14e17415a83df4636d02d8c9f54f7e99','2026-11-11 07:03:43',NULL,'2026-10-11 23:03:43'),(214,1,'a03ecb2e1aefc06f2afbeb338251b968be8a5a6f353578e320c8aef692ad63ff','2026-11-11 07:05:18',NULL,'2026-10-11 23:05:18'),(215,1,'0c28d21681e194540b36d0fdd2456b73d8070e492539126d60bd443835c8a8ca','2026-11-11 07:05:22',NULL,'2026-10-11 23:05:22'),(216,1,'f9e94e7eca0fbdf09c2e989e01b0a326b53bdad2fe20fda7b4efc2a81cc409a9','2026-11-11 07:05:25',NULL,'2026-10-11 23:05:25'),(217,1,'e736ad7029bb6ce76d5d584caa859cfdec7030927689ccbfebea19e9dad4bea6','2026-11-11 07:05:27',NULL,'2026-10-11 23:05:27'),(218,1,'0de890abaf6178aa4620c44c9a929b55dac07d2231edaf1b47a5e61e71a09b7a','2026-11-11 07:07:50','2026-10-12 07:12:52','2026-10-11 23:07:50'),(219,1,'db266ab64db1c44db4c872d6c1f342792d86c5dd7cc792def1725a1513c2ae02','2026-11-11 07:12:52',NULL,'2026-10-11 23:12:52'),(220,1,'21dcecd9431fd82d0c9328659c8c1efa18a3bfc099bf8fbd8f66d8bca4e3cd0b','2026-11-11 07:14:13',NULL,'2026-10-11 23:14:13'),(221,5,'484a7947673b33c5a3fb28958620883a34b4fbf5cfe5c8851a82e0a307d2bdf0','2026-11-11 07:14:42',NULL,'2026-10-11 23:14:42'),(222,3,'f8862c85f88a83c5232a17c6bcd97b6c3e3281dfa95463c38db1c2a7c924c771','2026-11-11 07:14:55',NULL,'2026-10-11 23:14:55'),(223,3,'e0fce55ef5fe96b63e6f37ed23aa8c89c76fb6f8d3dcbc34bf301384805253ad','2026-11-11 07:15:08',NULL,'2026-10-11 23:15:08'),(224,6,'e87dfcd99d9ccb6e59daed363b65529e6fcf598052d251aa5fa7eb5c66885560','2026-11-11 07:15:23',NULL,'2026-10-11 23:15:23'),(225,6,'f675e2ca11e3caaead63fcc195683adfca4db60cb0e48e06fb08c6a114d08f7b','2026-11-11 07:15:30',NULL,'2026-10-11 23:15:30'),(226,2,'500aaf5b3dfbc91bdcc4cb273985fd4f6e0ad1ba3f78af2b01dd645ed6b4d007','2026-11-11 07:15:34',NULL,'2026-10-11 23:15:34'),(227,4,'776f2a32e0f935e159846450a569bea429f7b7c40f034c8291837b4d5b68f5b8','2026-11-11 07:15:43',NULL,'2026-10-11 23:15:43'),(228,1,'a99c37db774c375a5e7765aa929c89733cd889f57fd269efab4bfb99362b86e6','2026-11-11 07:15:58',NULL,'2026-10-11 23:15:58'),(229,1,'9f15cba7856def2e0ab9aee9d70d37da570d8a4375423a37b9cb4acf9c7d5e46','2026-11-11 07:16:52','2026-10-12 07:21:53','2026-10-11 23:16:52'),(230,1,'d504c4181baf4d1a780228da68ce112bf073177d13f024fc89241f767a78f2fd','2026-11-11 07:16:55','2026-10-12 07:21:56','2026-10-11 23:16:55'),(231,5,'c893015fff2b7d5f74ef8c469ad6846b589b10847f569a205d186950867e69fe','2026-11-11 07:20:22','2026-10-12 07:34:27','2026-10-11 23:20:22'),(232,3,'54183af8768f71b65800e2eab78473ff648a39b8b4596a29251d47bc531db15a','2026-11-11 07:20:31','2026-10-12 07:36:31','2026-10-11 23:20:31'),(233,6,'97be2266dcbe38413acd69116269ac9683be28b9b8b1da0cba747eb9d6318a96','2026-11-11 07:20:36','2026-10-12 07:36:33','2026-10-11 23:20:36'),(234,2,'f5aade08db2f1fb4ec120d4c0c63b69222cfc5f97aa79c767f5377460caeee86','2026-11-11 07:21:35','2026-10-12 07:36:38','2026-10-11 23:21:35'),(235,4,'fd8da145ae530db05a79da599e8824548657784679c0860f6d72dd28225b5dfa','2026-11-11 07:21:43','2026-10-12 07:49:02','2026-10-11 23:21:43'),(236,1,'0efef329e75e5ad400db979463e6a0c25f04901ecfc1d9d18eac84d3bb7c4d20','2026-11-11 07:21:53','2026-10-12 07:26:54','2026-10-11 23:21:53'),(237,1,'e1c365a0e807eeaef76960f3955f6197aedd10461fe7db47b7c1e3b2252fb1c0','2026-11-11 07:21:56','2026-10-12 07:26:57','2026-10-11 23:21:56'),(238,1,'58661b673ee22922ec987a47429a16d9d0192fe49b697952f47c075ca65e9dbd','2026-11-11 07:23:47',NULL,'2026-10-11 23:23:47'),(239,1,'a1d3326023e86ece2361be185e8872437a5158443f08236c670cfa16519b21c4','2026-11-11 07:26:54','2026-10-12 07:32:12','2026-10-11 23:26:54'),(240,1,'f924ccd58b24ac6515c3b3de4fcc7e284f20a8cf5e2059ed9805df010bd1ea71','2026-11-11 07:26:57','2026-10-12 07:31:58','2026-10-11 23:26:57'),(241,1,'b3cfac11d9c2de1bcace4115c4488f091bb2d0f2664a8a5580de1fff3853f638','2026-11-11 07:31:58','2026-10-12 07:36:58','2026-10-11 23:31:58'),(242,1,'87614cbc2c74518c7dd0cb60d499d046173e574e1c6cf2be8f984a6553baf936','2026-11-11 07:32:12','2026-10-12 07:37:13','2026-10-11 23:32:12'),(243,5,'ff09e5c7c88890a9f4f7e43edbc52f2dd5264c717d3e6aaaa73248d6782e0b37','2026-11-11 07:34:27','2026-10-12 07:48:48','2026-10-11 23:34:27'),(244,1,'e5262cabb6bd7421413a8c48b7d8280ba387137de4c9fa2d7c12ba79d266d68c','2026-11-11 07:34:36',NULL,'2026-10-11 23:34:36'),(245,1,'6c14f0726b58efc9a4d457fefa633ed4bf0d6e9aefb32187828e1998d53e2d6f','2026-11-11 07:34:55',NULL,'2026-10-11 23:34:55'),(246,1,'0fe38e8e952f70fd74892c3b9a13a26b2f3799ae1876f8804930ef00a1612277','2026-11-11 07:35:02',NULL,'2026-10-11 23:35:02'),(247,1,'89e57a4ec0ddcc95da18a4e587b94a1d3b1bc5a65d8adb2e297a08d65dc0d28d','2026-11-11 07:36:58','2026-10-12 07:41:59','2026-10-11 23:36:58'),(248,1,'8964afae5862e307495ac926476bfbaee11d9b7e84d136d3e33f9311c8244df5','2026-11-11 07:37:13','2026-10-12 07:42:14','2026-10-11 23:37:13'),(249,1,'ae19188ebbe9095cd8b5d32846903504fe1db3e6c4323ec1ab1f2ee34ac16b12','2026-11-11 07:41:59','2026-10-12 07:47:10','2026-10-11 23:41:59'),(250,1,'e2a022e797bfa4c513272ff83567cd08554d3e186aab749b9e1841b6fb59ba32','2026-11-11 07:42:14','2026-10-12 07:47:15','2026-10-11 23:42:14'),(251,1,'0da99cf760d65a65c7e7db2e808a0afbfbef1d821f3b668c4a7b07301e27ee1e','2026-11-11 07:47:10','2026-10-12 07:52:11','2026-10-11 23:47:10'),(252,1,'11a60af0c3c9c1b27bf53256b050bebc9f7994517541ebe158bdf5ea5af39a05','2026-11-11 07:47:15','2026-10-12 07:52:16','2026-10-11 23:47:15'),(253,5,'0316547c8cff14421d85d67d81abdfcb352dbcf58bcf6b82c2125eee609c6f60','2026-11-11 07:48:48','2026-10-12 08:06:08','2026-10-11 23:48:48'),(256,1,'f95fcba2f3c43aab16def224b7793ced893c6e3756212959697cdd9813065aeb','2026-11-11 07:52:11','2026-10-12 07:57:12','2026-10-11 23:52:11'),(257,1,'6e48b9f3dd3f225b96bb2ce53f2aba7605ced763aa0c9741524b8ce138cf283b','2026-11-11 07:52:16','2026-10-12 07:57:17','2026-10-11 23:52:16'),(258,5,'1a6a7bafecc214338cf88924c7886b2f6e18baf8672fcd7bc723a6867fd9b237','2026-11-11 07:53:30',NULL,'2026-10-11 23:53:30'),(259,5,'c34a1203ccd2a2d6943c4f9d7ce34ba6100472ccf053644a123a63fef94eed31','2026-11-11 07:53:35',NULL,'2026-10-11 23:53:35'),(260,5,'90c250a651fc213a37408d5981a6119b6674f927b043622b04faf6a0e1157f3b','2026-11-11 07:54:47',NULL,'2026-10-11 23:54:47'),(261,1,'2e5bffd6fd8691aebb7174347e5f5bc2c19ac6b7c9dd604ef9003ec5ada5d350','2026-11-11 07:57:12','2026-10-12 08:02:13','2026-10-11 23:57:12'),(262,1,'efdcc06d61ddfffb2f31cf518a26b0c4dcbb5e005ee4b651885a571a2a5602c7','2026-11-11 07:57:17','2026-10-12 08:02:18','2026-10-11 23:57:17'),(263,1,'e4916b9d8e53d0f8e7558170ee138f6925a1bbe3f01790c5dc31735826793acb','2026-11-11 08:02:13','2026-10-12 08:07:14','2026-10-12 00:02:13'),(264,1,'b5f35403f2e42a475974aec7683d1e9973855a84e6dfd2f86a1bd3262570e5c6','2026-11-11 08:02:18','2026-10-12 08:07:19','2026-10-12 00:02:18'),(265,5,'dfac0e671a379f27992eb32394ec936f58d5818ca0d3ca299c108261b65f1df5','2026-11-11 08:06:08',NULL,'2026-10-12 00:06:08'),(266,1,'93fa2df704a119087b2cf257528b87b944a94519d542114256c75e9c8bb20f85','2026-11-11 08:07:14','2026-10-13 02:43:45','2026-10-12 00:07:14'),(267,1,'a64d987d1ff0a66be0cd62acc92fb4fa986cff3a216fe1cee96ee7a458c202fb','2026-11-11 08:07:19','2026-10-13 02:30:36','2026-10-12 00:07:19'),(268,1,'aa32502c32ab822734c9d144618efc5060515b9da8deedef6ca34e9621e6559f','2026-11-12 02:30:36','2026-10-13 02:35:38','2026-10-12 18:30:36'),(269,1,'f44ac8b6b56db5da08abe2beed25b42d4434f71b2e6c8972fd124a31c10dcd6f','2026-11-12 02:35:38','2026-10-13 02:40:39','2026-10-12 18:35:38'),(270,1,'6dd47c691d84349046c381e1d15be128a2e22cc9e5cfd49e81f829f8ade25e0d','2026-11-12 02:36:28',NULL,'2026-10-12 18:36:28'),(271,1,'d812a04ff69ea8a2859fe5c100b23b336dca5d947003eb4a482e1028e4146984','2026-11-12 02:37:57',NULL,'2026-10-12 18:37:57'),(272,1,'38a133a5fe69324dd93aaff82e7553dffcf56035ea7ef1f18a0d7782f99b720a','2026-11-12 02:38:37',NULL,'2026-10-12 18:38:37'),(273,1,'d5256594b4290b129d12055bfe6be951a87059f39e8f1733a4230d4eb1f6d8ad','2026-11-12 02:38:38',NULL,'2026-10-12 18:38:38'),(274,1,'fbbc792980f17c3c96e072b4e6c79c17d9fb93683d8a3c545aee72ea53b2fd6c','2026-11-12 02:40:39',NULL,'2026-10-12 18:40:39'),(275,1,'a594738e4a8b1576857893271ff260c96d9a919f6959d70b0796c2cfd6b2b565','2026-11-12 02:43:45','2026-10-13 02:48:46','2026-10-12 18:43:45'),(276,1,'e194ed1550717c2fb0429f34ceab7cdb21fb8a0fb4d2dd4833a3360b9b7703fd','2026-11-12 02:43:56','2026-10-13 02:48:56','2026-10-12 18:43:56'),(277,1,'e46df1fc23ce423321178542bff735fcd517585c53a8f315771b5ab0782124ce','2026-11-12 02:44:45',NULL,'2026-10-12 18:44:45'),(278,1,'9420f8bdc324ef89bec352a4b7556515c14eec52a12b898a24db94542e07a02e','2026-11-12 02:48:46',NULL,'2026-10-12 18:48:46'),(279,1,'0336c7d1a757c76abf67a887b2620726a20385af0e0a42301fa417559b40bcb0','2026-11-12 02:48:56',NULL,'2026-10-12 18:48:56');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treatment_dockets`
--

LOCK TABLES `treatment_dockets` WRITE;
/*!40000 ALTER TABLE `treatment_dockets` DISABLE KEYS */;
INSERT INTO `treatment_dockets` VALUES (1,'TD-D312206C0C',1,1,3,4,1,'READY','PAID','2026-09-28 11:28:50','2026-09-28 11:38:44'),(2,'TD-9FE9612977',1,NULL,3,4,20,'READY','PAID','2026-09-29 01:58:00','2026-09-29 01:58:49'),(3,'TD-D4DFD659A6',3,2,3,4,1,'READY','PENDING','2026-09-29 02:38:54','2026-10-12 07:58:57'),(4,'TD-356F6CDFDF',1,2,3,4,20,'READY','PENDING','2026-10-02 07:05:46','2026-10-12 07:58:57'),(5,'TD-28C3AEB090',3,2,3,4,22,'READY','PAID','2026-10-02 07:14:28','2026-10-02 07:15:26');
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,'Mondejar, Shin','admin@dermaclinic.test','$2a$10$NUkndv2.L7xZ8KaKlBULzeG9F/CPQ4P2K1q7TlEO4TAYX5fgWNOra','ACTIVE','2026-09-16 13:14:55','2026-09-25 16:59:31',0),(2,2,'Jamer','reception@dermaclinic.test','$2a$10$uSe7q35Dp37segXWOL6IKOO60/7WiSkv1h2wwDXxKGficGeGav1U.','ACTIVE','2026-09-16 13:14:55','2026-09-28 11:34:23',0),(3,3,'Dr. Jem','dermatologist@dermaclinic.test','$2a$10$kCdOjQ9I.In27bu4p/HTEudo4KN3S2IK0KG7J0EzH6UcxCp5AUvpG','ACTIVE','2026-09-16 13:14:55','2026-10-12 06:53:34',0),(4,4,'Queencel','therapist@dermaclinic.test','$2a$10$THVDnp1YZNY5ZwiPB.0cF.28JEorHH1CGAZrJt3.usEfkXh0mci4u','ACTIVE','2026-09-16 13:14:55','2026-09-28 11:34:56',0),(5,5,'Justine','cashier@dermaclinic.test','$2a$10$Q9TZofgOqkwE0rjRZuHf5OEgZ/e6GfBlqpFvl6Q6zwdKLXwf5vrGq','ACTIVE','2026-09-16 13:14:55','2026-10-12 06:53:19',0),(6,6,'Ralph','inventory@dermaclinic.test','$2a$10$vzm4mWFVDTpaC8rK2mwiCOxFrKGXQ6Pn.uC1wzq4Z1F4I6zx8YDsq','ACTIVE','2026-09-16 13:14:55','2026-10-12 06:53:12',0),(7,2,'Database Test User','created-b1b73013@example.test','$2a$10$rhKgwSD8r8jqvlRBV2nBveFNMLnvrFUwxj9R4Pnuf1KnXCRd72yn2','INACTIVE','2026-09-24 06:10:41','2026-09-24 06:10:41',1),(8,1,'mondejar','mondejar@gmail.com','$2a$10$oZRjt8iX5HxhjWLKHGbA9O8Zsgvblvm7sydm5RVpwpDpQGnzvlH12','INACTIVE','2026-09-24 06:41:18','2026-10-12 06:52:55',1),(9,1,'Mondejarwashington','mondejar041921@gmail.com','$2a$10$yeMvu52XWIoH/86KRXlPM.zAkAmJne8Wqlkfc86xcbTfT2hH7TSG2','INACTIVE','2026-09-24 07:16:44','2026-10-12 06:52:52',1),(10,2,'Mondejar, Washington B.','Mondejarshin@dermaclinic.test','$2a$10$N5J46Y5RJQdhLmMDho6Ggu7F6CJgvP8I5O.Dwmo5F4qNrYVkHzGSW','INACTIVE','2026-09-24 07:20:45','2026-10-12 06:52:47',1),(11,5,'shinmondejar','shin@dermaclinic.test','$2a$10$RNJsz5coHOzqSgZTuuBNOOcp7VBjjdUTKtFFK4bN5d0YP.J64CujC','INACTIVE','2026-09-24 07:26:26','2026-10-12 06:52:43',1),(12,6,'fujimiyakun','fujimiyakun0441921@dermaclinic.test','$2a$10$IFSs6SZ9/deDu17nNpVUYu88s2Fq.B.MVCmIbtHuL3uPrgDXLnZXu','INACTIVE','2026-09-24 07:29:25','2026-10-12 06:44:21',1),(13,1,'Mondejar, Washington B.','Mondejarwashington041921@gmail.com','$2a$10$b1bP9C.ESdgQcVJBu5T0PeuxxrAv0PGKUJXIAdFDtFadk/g0k9lVK','INACTIVE','2026-09-24 09:50:10','2026-10-12 06:44:18',1),(14,1,'kenshin','kenshin041921@gmail.com','$2a$10$acgE6Kd1qbkcMow5nOsnqOsJyZFzQX1CATQl0I4GOmq3Zk83ROSHS','INACTIVE','2026-09-25 08:41:04','2026-10-12 06:44:14',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'derma_clinic'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-13 10:50:35
