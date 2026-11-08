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
  `therapist_id` bigint unsigned DEFAULT NULL,
  `starts_at` datetime NOT NULL,
  `ends_at` datetime NOT NULL,
  `status` enum('PENDING','CONFIRMED','COMPLETED','CANCELLED') NOT NULL DEFAULT 'PENDING',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `appointment_number` (`appointment_number`),
  UNIQUE KEY `uq_assigned_start` (`assigned_user_id`,`starts_at`),
  UNIQUE KEY `uq_therapist_start` (`therapist_id`,`starts_at`),
  KEY `idx_appointments_patient_date` (`patient_id`,`starts_at`),
  KEY `idx_appointments_status_date` (`status`,`starts_at`),
  CONSTRAINT `fk_appointments_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`),
  CONSTRAINT `fk_appointments_therapist` FOREIGN KEY (`therapist_id`) REFERENCES `therapists` (`id`),
  CONSTRAINT `fk_appointments_user` FOREIGN KEY (`assigned_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `chk_appointment_range` CHECK ((`ends_at` > `starts_at`))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES (6,'APT-5561857370',19,3,NULL,'2026-10-18 10:30:00','2026-10-18 11:00:00','PENDING','2026-10-17 01:30:42','2026-10-17 01:30:42'),(7,'APT-93CD2D2D03',19,NULL,1,'2026-10-30 10:51:00','2026-10-30 11:21:00','COMPLETED','2026-10-17 02:51:55','2026-10-20 19:14:59'),(8,'APT-3BF434C06C',21,NULL,2,'2026-10-17 13:00:00','2026-10-17 13:30:00','PENDING','2026-10-17 04:43:00','2026-10-20 19:14:59');
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
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (36,1,'Inventory','PRODUCT_CREATED','ABC001','ABC001','{\"supplierId\": \"5\"}','2026-10-15 00:55:30'),(37,1,'Inventory','PRODUCT_CREATED','ABC002','ABC002','{\"supplierId\": \"5\"}','2026-10-15 00:56:12'),(38,1,'Inventory','PRODUCT_CREATED','ABC003','ABC003','{\"supplierId\": \"5\"}','2026-10-15 00:56:39'),(39,1,'Inventory','MOVEMENT_RECORDED','37','UNILAB','{\"type\": \"STOCK_IN\", \"quantity\": \"5\", \"newQuantity\": \"5\"}','2026-10-15 00:57:43'),(40,1,'Inventory','MOVEMENT_RECORDED','38','UNILAB','{\"type\": \"STOCK_IN\", \"quantity\": \"5\", \"newQuantity\": \"5\"}','2026-10-15 00:58:13'),(41,1,'Inventory','MOVEMENT_RECORDED','39','UNILAB','{\"type\": \"STOCK_IN\", \"quantity\": \"5\", \"newQuantity\": \"5\"}','2026-10-15 00:58:47'),(42,1,'Inventory','PRODUCT_CREATED','ABC004','ABC004','{\"supplierId\": \"5\"}','2026-10-15 00:59:29'),(43,1,'Services','SERVICE_CREATED','14','SSX001',NULL,'2026-10-15 01:01:47'),(44,1,'Services','SERVICE_PRODUCT_LINK','14',NULL,'{\"productId\": \"37\"}','2026-10-15 01:01:47'),(45,1,'Treatment','DOCKET_CREATED','9','TD-89944DF921','{\"patientId\": \"19\", \"serviceId\": \"14\"}','2026-10-15 01:57:06'),(46,1,'Treatment','DOCKET_CREATED','10','TD-FCD228CAE7','{\"patientId\": \"19\", \"serviceId\": \"14\"}','2026-10-15 02:27:24'),(47,NULL,'Billing','INVOICE_CREATED','1','INV-440B68357A','{\"paid\": \"1500\", \"total\": \"1500.00\", \"status\": \"PAID\", \"discount\": \"0\"}','2026-10-15 02:29:43'),(48,1,'Patients','QR_GENERATE','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"generated\": true}','2026-10-16 03:06:58'),(49,1,'Patients','QR_GENERATE','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"generated\": false}','2026-10-16 03:07:33'),(50,1,'Services','SERVICE_ARCHIVED','14','ARCHIVED','{\"status\": \"ARCHIVED\"}','2026-10-16 03:10:03'),(51,1,'Services','SERVICE_RESTORED','14','ACTIVE','{\"status\": \"ACTIVE\"}','2026-10-16 03:10:08'),(52,1,'Patients','QR_GENERATE','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"generated\": false}','2026-10-16 04:12:26'),(53,1,'Patients','QR_GENERATE','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"generated\": false}','2026-10-16 04:12:48'),(54,NULL,'Patients','QR_ACCESS','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"scanner\": \"therapist@dermaclinic.test\"}','2026-10-16 04:12:52'),(55,1,'Patients','QR_ACCESS','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"scanner\": \"admin@dermaclinic.test\"}','2026-10-16 04:13:04'),(56,1,'Patients','QR_ACCESS','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"scanner\": \"admin@dermaclinic.test\"}','2026-10-16 04:13:10'),(57,1,'Patients','QR_GENERATE','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"generated\": false}','2026-10-16 04:13:47'),(58,1,'Patients','QR_ACCESS','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"scanner\": \"admin@dermaclinic.test\"}','2026-10-16 04:13:57'),(59,1,'Patients','QR_GENERATE','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"generated\": false}','2026-10-16 15:33:55'),(60,1,'Patients','QR_GENERATE','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"generated\": false}','2026-10-16 15:34:20'),(61,1,'Patients','QR_ACCESS','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"scanner\": \"admin@dermaclinic.test\"}','2026-10-16 15:37:17'),(62,1,'Patients','QR_GENERATE','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"generated\": false}','2026-10-16 15:39:41'),(63,1,'Patients','QR_ACCESS','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"scanner\": \"admin@dermaclinic.test\"}','2026-10-16 15:40:04'),(64,1,'Patients','QR_GENERATE','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"generated\": false}','2026-10-16 15:40:47'),(65,1,'Appointments','APPOINTMENT_CREATED','19','APT-5561857370','{\"staffId\": \"3\", \"startsAt\": \"2026-10-18T10:30\"}','2026-10-17 01:30:42'),(66,1,'Treatment','DOCKET_CREATED','11','TD-DB7442B11D','{\"patientId\": \"20\", \"serviceId\": \"14\"}','2026-10-17 02:49:35'),(67,NULL,'Billing','INVOICE_CREATED','2','INV-69F390F1ED','{\"paid\": \"1500\", \"total\": \"1500.00\", \"status\": \"PAID\", \"discount\": \"0\"}','2026-10-17 02:50:16'),(68,1,'Consultations','CONSULTATION_CREATED','19','CON-1564773AA8',NULL,'2026-10-17 02:51:20'),(69,1,'Appointments','APPOINTMENT_CREATED','19','APT-93CD2D2D03','{\"staffId\": \"4\", \"startsAt\": \"2026-10-30T10:51\"}','2026-10-17 02:51:55'),(70,1,'Appointments','APPOINTMENT_STATUS_CHANGED','7','COMPLETED','{\"status\": \"COMPLETED\"}','2026-10-17 02:52:11'),(71,1,'Patients','QR_GENERATE','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"generated\": false}','2026-10-17 02:53:48'),(72,1,'Patients','QR_GENERATE','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"generated\": false}','2026-10-17 02:53:56'),(73,1,'Patients','QR_GENERATE','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"generated\": false}','2026-10-17 02:54:25'),(74,1,'Patients','QR_GENERATE','19','5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e','{\"generated\": false}','2026-10-17 02:54:40'),(75,2,'Appointments','APPOINTMENT_CREATED','21','APT-3BF434C06C','{\"staffId\": \"3\", \"startsAt\": \"2026-10-17T13:42\"}','2026-10-17 04:43:00'),(76,2,'Appointments','APPOINTMENT_UPDATED','21','APT-3BF434C06C','{\"staffId\": \"19\", \"startsAt\": \"2026-10-17T13:00\"}','2026-10-17 04:43:42'),(77,2,'Treatment','DOCKET_CREATED','12','TD-139838B66F','{\"patientId\": \"21\", \"serviceId\": \"14\"}','2026-10-17 04:45:12'),(78,1,'Services','SERVICE_UPDATED','14','SSX001',NULL,'2026-10-17 04:48:04'),(79,1,'Services','SERVICE_PRODUCT_LINK','14',NULL,'{\"productIds\": \"[37, 38]\"}','2026-10-17 04:48:04'),(80,1,'Services','SERVICE_UPDATED','14','SSX001',NULL,'2026-10-17 04:48:35'),(81,1,'Services','SERVICE_PRODUCT_LINK','14',NULL,'{\"productIds\": \"[37, 38]\"}','2026-10-17 04:48:35'),(82,1,'Services','SERVICE_CREATED','15','005',NULL,'2026-10-17 04:52:26'),(83,1,'Services','SERVICE_PRODUCT_LINK','15',NULL,'{\"productIds\": \"[38, 39]\"}','2026-10-17 04:52:26'),(84,1,'Treatment','DOCKET_CREATED','14','TD-3466FCED99','{\"patientId\": \"21\", \"serviceId\": \"15\"}','2026-10-17 04:53:32'),(85,NULL,'Billing','INVOICE_CREATED','3','INV-9BA56EB400','{\"paid\": \"800\", \"total\": \"800.00\", \"status\": \"PAID\", \"discount\": \"0\"}','2026-10-17 04:55:29');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consultations`
--

LOCK TABLES `consultations` WRITE;
/*!40000 ALTER TABLE `consultations` DISABLE KEYS */;
INSERT INTO `consultations` VALUES (3,'CON-1564773AA8',19,NULL,1,'acne','facial','N/A','4 weeks','2026-10-30','2026-10-17 02:51:20');
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
INSERT INTO `flyway_schema_history` VALUES (1,'1','<< Flyway Baseline >>','BASELINE','<< Flyway Baseline >>',NULL,'root','2026-09-16 13:11:00',0,1),(2,'2','seed roles','SQL','V2__seed_roles.sql',-1369780179,'root','2026-09-16 13:14:55',106,1),(3,'3','fix development password hashes','SQL','V3__fix_development_password_hashes.sql',511361378,'root','2026-09-17 14:33:04',63,1),(4,'4','set staff development password hashes','SQL','V4__set_staff_development_password_hashes.sql',-19219740,'root','2026-09-17 16:04:52',19,1),(5,'5','remove non admin development accounts','SQL','V5__remove_non_admin_development_accounts.sql',-1064234823,'root','2026-09-24 06:07:57',28,1),(6,'6','restore development staff accounts','SQL','V6__restore_development_staff_accounts.sql',199569236,'root','2026-09-24 08:38:43',37,1),(7,'7','seed requested inventory','SQL','V7__seed_requested_inventory.sql',2086536922,'root','2026-09-25 07:41:27',320,1),(8,'8','link services to required products','SQL','V8__link_services_to_required_products.sql',694103836,'root','2026-09-28 07:50:04',24,1),(9,'9','add consultation follow up date','SQL','V9__add_consultation_follow_up_date.sql',-397423900,'root','2026-09-28 08:31:32',363,1),(10,'10','add patient skin type and allergies','SQL','V10__add_patient_skin_type_and_allergies.sql',-110423083,'root','2026-09-28 09:42:25',187,1),(11,'11','canonicalise role names','SQL','V11__canonicalise_role_names.sql',191968059,'derma_flyway','2026-10-13 10:25:42',50,1),(12,'12','e164 patient phone','SQL','V12__e164_patient_phone.sql',-1875702718,'derma_flyway','2026-10-14 03:00:34',23,1),(13,'13','international patient phone','SQL','V13__international_patient_phone.sql',-1585466261,'derma_flyway','2026-10-14 03:45:04',159,1),(14,'14','remove billing and cashier','SQL','V14__remove_billing_and_cashier.sql',700624880,'derma_flyway','2026-10-20 18:54:19',405,1),(15,'15','therapist personnel','SQL','V15__therapist_personnel.sql',-129471237,'derma_flyway','2026-10-20 19:14:59',674,1);
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
INSERT INTO `inventory_balances` VALUES (37,1.000,'2026-10-17 04:45:12'),(38,4.000,'2026-10-20 19:16:27'),(39,4.000,'2026-10-20 19:16:27');
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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_batches`
--

LOCK TABLES `inventory_batches` WRITE;
/*!40000 ALTER TABLE `inventory_batches` DISABLE KEYS */;
INSERT INTO `inventory_batches` VALUES (21,37,'B001','2030-10-10','2026-10-15 00:57:43'),(22,38,'B001','2027-01-01','2026-10-15 00:58:13'),(23,39,'B001','2026-10-10','2026-10-15 00:58:47');
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
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_movements`
--

LOCK TABLES `inventory_movements` WRITE;
/*!40000 ALTER TABLE `inventory_movements` DISABLE KEYS */;
INSERT INTO `inventory_movements` VALUES (9,37,21,NULL,'STOCK_IN',0.000,0.000,5.000,'UNILAB',1,'2026-10-15 00:57:43'),(10,38,22,NULL,'STOCK_IN',0.000,0.000,5.000,'UNILAB',1,'2026-10-15 00:58:13'),(11,39,23,NULL,'STOCK_IN',0.000,0.000,5.000,'UNILAB',1,'2026-10-15 00:58:47'),(12,37,21,9,'STOCK_OUT',5.000,1.000,4.000,'TD-89944DF921',1,'2026-10-15 01:57:06'),(13,37,21,10,'STOCK_OUT',4.000,1.000,3.000,'TD-FCD228CAE7',1,'2026-10-15 02:27:24'),(14,37,21,11,'STOCK_OUT',3.000,1.000,2.000,'TD-DB7442B11D',1,'2026-10-17 02:49:35'),(15,37,21,12,'STOCK_OUT',2.000,1.000,1.000,'TD-139838B66F',2,'2026-10-17 04:45:12'),(16,38,22,14,'STOCK_OUT',5.000,1.000,4.000,'TD-3466FCED99',1,'2026-10-17 04:53:32'),(17,39,23,14,'STOCK_OUT',5.000,1.000,4.000,'TD-3466FCED99',1,'2026-10-17 04:53:32');
/*!40000 ALTER TABLE `inventory_movements` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (19,'PT-858DE125','jamer fundano','Jamer@gmail.com','+639243078998','2026-10-15','NORMAL','N/A','ACTIVE','2026-10-15 01:56:43','2026-10-15 01:56:43'),(20,'PT-BF7A4CDE','Mondejar, Washington B.','Mondejarwashington@gmail.com','+639243078998','2026-10-17','OILY','N/A','ACTIVE','2026-10-17 02:49:04','2026-10-17 02:49:04'),(21,'PT-EAEF13CC','bryan H calata','brianhingcalata80@gmail.com','+639243078998','1981-07-21','DRY','pain reliver','ACTIVE','2026-10-17 04:42:12','2026-10-17 04:42:12');
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (37,5,'ABC001','CLEANSER','1 ML',0.000,'ACTIVE','2026-10-15 00:55:30','2026-10-15 00:55:30'),(38,5,'ABC002','REJUV CREAM','1',0.000,'ACTIVE','2026-10-15 00:56:12','2026-10-15 00:56:12'),(39,5,'ABC003','TONER','1 ML',0.000,'ACTIVE','2026-10-15 00:56:39','2026-10-15 00:56:39'),(40,5,'ABC004','COTTON','2',0.000,'ACTIVE','2026-10-15 00:59:29','2026-10-15 00:59:29');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
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
INSERT INTO `roles` VALUES (1,'Administrator','2026-09-13 17:38:27','Full clinic administration and system oversight'),(2,'Receptionist','2026-09-13 17:38:27','Patient registration and schedule administration'),(3,'Dermatologist','2026-09-13 17:38:27','Clinical review and consultation records'),(6,'Inventory Staff','2026-09-13 17:38:27','Inventory and stock movement management');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `secure_qr_references`
--

LOCK TABLES `secure_qr_references` WRITE;
/*!40000 ALTER TABLE `secure_qr_references` DISABLE KEYS */;
INSERT INTO `secure_qr_references` VALUES (5,'5748d2dcb6037f4f546884742fc26eaeffd641e4a444b6fb5c0e0f031144061e',19,NULL,NULL,NULL,1,'2026-10-16 03:06:58');
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
INSERT INTO `service_required_products` VALUES (14,37,5.000),(14,38,1.000),(15,38,1.000),(15,39,1.000);
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (14,'SSX001','ACNE TREATMENT','ACNE FACIAL','ACNE TREATMENT',1500.00,60,'ACTIVE','2026-10-15 01:01:47','2026-10-16 03:10:08'),(15,'005','dry','diamond facial','for dry cleaning',800.00,30,'ACTIVE','2026-10-17 04:52:26','2026-10-17 04:52:26');
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
) ENGINE=InnoDB AUTO_INCREMENT=510 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_refresh_tokens`
--

LOCK TABLES `session_refresh_tokens` WRITE;
/*!40000 ALTER TABLE `session_refresh_tokens` DISABLE KEYS */;
INSERT INTO `session_refresh_tokens` VALUES (189,1,'71a972fd2116e6622c84ba7216a1550e8a2a0b0e958dbc21d1346d587b041a2d','2026-11-13 14:52:58','2026-10-14 14:57:59','2026-10-14 06:52:58'),(190,1,'c5547f9789a46ca7555283a81e1bb56404c8abfe57b6b8ac4a4eb23cf8ae07b1','2026-11-13 14:57:59','2026-10-14 15:03:00','2026-10-14 06:57:59'),(191,1,'321226293c0c4381ab494fd74ee4a538f5a2905c5783ed0067926fc936ff1303','2026-11-13 15:03:00','2026-10-14 15:08:01','2026-10-14 07:03:00'),(192,1,'87e899009aa553f10ae93c70a780b0c21963dcb44e81acc58c82fbe91a2211b2','2026-11-13 15:08:01','2026-10-14 15:13:02','2026-10-14 07:08:01'),(193,1,'878bde29f3a1cdbf457fa4d65c9466d8501e3f6f29a866275966e7ca18a3bb04','2026-11-13 15:13:02','2026-10-14 15:18:03','2026-10-14 07:13:02'),(194,1,'562fe3cdd571032278f57ccae0b81e5d4f51e34a941240063bae852627875690','2026-11-13 15:18:03','2026-10-14 15:23:04','2026-10-14 07:18:03'),(195,1,'4d7b3ab7e88fa14c593eec4e88aaafdf376c386c13f0e7fe3bc49a08306f584a','2026-11-13 15:23:04','2026-10-14 15:28:05','2026-10-14 07:23:04'),(196,1,'23f7791c5609b4a1a79174933e6c6cb0106147b52cd813750cb48141a70ae03e','2026-11-13 15:28:05','2026-10-14 15:33:06','2026-10-14 07:28:05'),(197,1,'2961693726b3334fe7d38bc53394f1d7c852b43535b5e7672fc864c0923e794f','2026-11-13 15:33:06','2026-10-14 15:38:07','2026-10-14 07:33:06'),(198,1,'2c38003310c0d564ce774ed80d8a47c16f8f65f020e6cc97a16b6f60d36f41e9','2026-11-13 15:38:07','2026-10-14 15:43:08','2026-10-14 07:38:07'),(199,1,'31ca03ad88218683bd088e44b6585e108689ce12c8645144d91d1cc2013cc4d9','2026-11-13 15:43:08','2026-10-14 15:48:09','2026-10-14 07:43:08'),(200,1,'28254724d525e7532cdc8abc50cbc1a5b0c20fdbdb569f19004d6971f8204008','2026-11-13 15:48:09',NULL,'2026-10-14 07:48:09'),(201,1,'6832d4f22a4841e2b3d6b32ac1c12325c720add91edfc8318bdc71110d855e50','2026-11-14 00:53:12','2026-10-15 00:58:12','2026-10-14 16:53:12'),(202,1,'965fa007b0ceb35790e375f3b95f63519a97c922ac14e1a8324221434bddb1ef','2026-11-14 00:58:12','2026-10-15 01:03:12','2026-10-14 16:58:12'),(203,1,'1f59467cde1c8276d858eb3739d11c726f776d5fa3dcd5cd68eef34b450fe60a','2026-11-14 01:03:12','2026-10-15 01:08:13','2026-10-14 17:03:12'),(204,1,'f183e84bac28f407e569744e6db15198d5bf4c8aee50403211c593f495a31f60','2026-11-14 01:08:13','2026-10-15 01:13:14','2026-10-14 17:08:13'),(205,1,'68a737f904bd34dd395bdf76a6a8b6f992ae769b557396dac8365d1ee2406f35','2026-11-14 01:13:14','2026-10-15 01:18:15','2026-10-14 17:13:14'),(206,1,'a574ffe18f392a3fba0c99021b5b58923c67602c8fb10fbc11f8056749bbdc9e','2026-11-14 01:18:15','2026-10-15 01:23:16','2026-10-14 17:18:15'),(207,1,'900ef4c74b5131f32cd3f012b1c947fd94e6cfafa4f97d94d81d8a02fa35bdcb','2026-11-14 01:23:16','2026-10-15 01:28:16','2026-10-14 17:23:16'),(208,1,'98404469550bfce22a3f652653bb9e0ca3506eccc036ef96ffb38a27c5a7539c','2026-11-14 01:28:16','2026-10-15 01:33:17','2026-10-14 17:28:16'),(209,1,'13097f60c89e824e7a8dbad5d7c2ef46cb6d43009242b97b73f05480d378151f','2026-11-14 01:33:17','2026-10-15 01:38:18','2026-10-14 17:33:17'),(210,1,'0c97fdb802716b58bac10ea83ac7bffcb378c95ffb064acb4646ff12f4ffc580','2026-11-14 01:38:18','2026-10-15 01:43:20','2026-10-14 17:38:18'),(211,1,'a1a43943b2b0467e22b6f08e8b148b06fefe364ba6ae6c1d02f27c200f7a77da','2026-11-14 01:43:20','2026-10-15 01:48:21','2026-10-14 17:43:20'),(212,1,'940c068c093b2925972bab64b0f5791c3fffb2f63b4433a12c37f3ed8a607654','2026-11-14 01:48:21','2026-10-15 01:53:22','2026-10-14 17:48:21'),(213,1,'2e1540f8df5f4ba800627715b3fef6506ff42bb58f2cf18f85addf06ff019a47','2026-11-14 01:53:22','2026-10-15 01:59:09','2026-10-14 17:53:22'),(214,2,'97d799aca967c9f4a50e55e7b2465ecb6c16dfbcd7bbe33c91d3b2bb3ea1bd2a','2026-11-14 01:55:53','2026-10-15 02:10:54','2026-10-14 17:55:53'),(215,3,'c1a25013a8926e4466d2afce132d630e31e47839f86b33ddd3777b84c4bc7aa0','2026-11-14 01:57:25','2026-10-15 02:12:26','2026-10-14 17:57:25'),(217,6,'b397ff53f205584b18729ae40bb116c41d3e556de9c596cf50d722d33509060b','2026-11-14 01:57:49','2026-10-15 02:12:49','2026-10-14 17:57:49'),(219,1,'dbe68a91b4cc95236f9086b8e54e2b2a2eaa1bd3184bd95f083dbcacf78cfc32','2026-11-14 01:59:09','2026-10-15 02:04:10','2026-10-14 17:59:09'),(220,1,'58d81532ade4ea493e9bfce3bf9f265685df954a537d0553ed0af0351b1a51fa','2026-11-14 02:04:10','2026-10-15 02:09:11','2026-10-14 18:04:10'),(221,1,'cbc88c27d613ee9411cbfb9225279e8e59bc1968653535b313b728d2d1198ac5','2026-11-14 02:09:11','2026-10-15 02:14:12','2026-10-14 18:09:11'),(222,2,'d6d2493975ae91b8ddedd8bd48c950c297e959247721fe5cf898335a07c70507','2026-11-14 02:10:54','2026-10-15 02:25:55','2026-10-14 18:10:54'),(223,3,'5d1d2e9e702f2f8602ddc991265ef87915336c5de4c26f02193d8697f0444403','2026-11-14 02:12:26','2026-10-15 02:27:27','2026-10-14 18:12:26'),(225,6,'6b0c12f277d7cc25cbd8a2aca24daf23ead3e32aad12a1c08e6442cd500be81d','2026-11-14 02:12:49','2026-10-15 02:27:50','2026-10-14 18:12:49'),(227,1,'03334c0731216cbe4e7ce71c088c1767dc3ab0d5a0df5eebcf7630055fd20571','2026-11-14 02:14:12','2026-10-15 02:19:13','2026-10-14 18:14:12'),(228,1,'9962fa8940ddc1fd3e2605073b98ebc51b248f050003216add3c2882d198f103','2026-11-14 02:19:13','2026-10-15 02:24:14','2026-10-14 18:19:13'),(229,1,'42a9d2611075e5f6cb42f6584acfbb63be9a4378f4e7eb3f00b0ef0ff6d81295','2026-11-14 02:24:14','2026-10-15 02:29:15','2026-10-14 18:24:14'),(230,2,'122b34cf7793c8f197127f6130c810713538f12953c20ff1d18a01b03e513573','2026-11-14 02:25:55','2026-10-15 02:40:55','2026-10-14 18:25:55'),(231,3,'87395353fd095925e45dc15bb0cae53f467ad0cfa74a444a0242bc43b06002e0','2026-11-14 02:27:27','2026-10-15 02:42:28','2026-10-14 18:27:27'),(233,6,'7d849a39c29861b40755291c7b94c226695edc6e492038502a55ac5e4014570d','2026-11-14 02:27:50','2026-10-15 02:42:51','2026-10-14 18:27:50'),(235,1,'24f9b5973a62ff828a2b23be3dd7feceb4e47d42dd77b69542a934a3a6de057a','2026-11-14 02:29:15','2026-10-15 02:34:16','2026-10-14 18:29:15'),(236,1,'1a84c0cf102c322bf80f700aa64fc45148f46f2d3465353f32e4dd3fd8ea5879','2026-11-14 02:34:16','2026-10-15 02:39:17','2026-10-14 18:34:16'),(237,1,'5a05be3f9d744ac122a246cbcbb62d91a0f6a5839eded5a36a0d3e59e2a67b05','2026-11-14 02:39:17','2026-10-15 02:44:18','2026-10-14 18:39:17'),(238,2,'09ff0e89e98ff6ff1caedabb107892e8a19592f563bf7a950b4219c2af35392c','2026-11-14 02:40:55',NULL,'2026-10-14 18:40:55'),(239,3,'a004bc1d1d0be4d4f001e489bb29df8824d6d30d25e48f7098f2b5704ac0002c','2026-11-14 02:42:28',NULL,'2026-10-14 18:42:28'),(241,6,'1a4753545b776bcc952e4dec5f48c8e364a8fbb293439f04e59b14aa21e86e64','2026-11-14 02:42:51',NULL,'2026-10-14 18:42:51'),(243,1,'7096b3b2fac07e45bc585f34d5304e2083073523d862601bb1f7a0117053e998','2026-11-14 02:44:18',NULL,'2026-10-14 18:44:18'),(244,1,'93cb5f9676b9c1ed2810735649545ec0dd9c44fe3578618522381bf6b9cc68df','2026-11-15 02:59:28','2026-10-16 03:04:29','2026-10-15 18:59:28'),(245,1,'ef57025af07df1a7113903ac9039d2c58f7c33f5f99f8911c3a247fcf52f49e1','2026-11-15 03:04:29','2026-10-16 03:09:29','2026-10-15 19:04:29'),(246,1,'1858720fa266c4cb025bcfb506fe4208f811c34115526cd81773bb8ecb43884c','2026-11-15 03:09:29','2026-10-16 03:14:29','2026-10-15 19:09:29'),(247,2,'3d7974663e8cc99daa1df0e243a544495bcd34cf891315d39f249d4dd2c0afa6','2026-11-15 03:13:33','2026-10-16 03:28:33','2026-10-15 19:13:33'),(248,1,'b2b176215f2ad08e658d6c3e881c1c5ce47967541a923d32ebf51ff2871ca339','2026-11-15 03:14:04',NULL,'2026-10-15 19:14:04'),(249,1,'03c5fb6bc40b45fb357ab4e8e053a20639d6e864c4cfc6624e27741186121e6b','2026-11-15 03:14:29','2026-10-16 03:19:29','2026-10-15 19:14:29'),(250,3,'0fe64aeba1f2cbe5c6fa05788800b9239be185fdad3daecddd9c199298bcdbca','2026-11-15 03:14:58','2026-10-16 03:29:59','2026-10-15 19:14:58'),(253,1,'8d666e72ec118eae32083beb8835cec5bea2e8b0395810b55d642f50ecb396bd','2026-11-15 03:19:29','2026-10-16 03:24:30','2026-10-15 19:19:29'),(254,1,'e179fd105caa6f270137280462056903574c5456515e5fb004ac6533321ac655','2026-11-15 03:24:30','2026-10-16 03:29:30','2026-10-15 19:24:30'),(255,2,'20294bfda52a612d36e8f6738a05767f8f5005f96c44258432d95fcc05ac0c41','2026-11-15 03:28:33','2026-10-16 03:43:33','2026-10-15 19:28:33'),(256,1,'5ee1a8224d712249d4b3c1c195d75ed5c3c76483e057e080141b7221e534ee97','2026-11-15 03:29:30','2026-10-16 03:34:30','2026-10-15 19:29:30'),(257,3,'11dbdc64490b83ac834b180d402c7d7401fba408630195ecdb65c075d7ca4734','2026-11-15 03:29:59','2026-10-16 03:44:59','2026-10-15 19:29:59'),(260,1,'d50228f776941abb6d804cc29af295182d59cdf8a00981ecf65d832716e64e96','2026-11-15 03:34:30','2026-10-16 03:39:30','2026-10-15 19:34:30'),(261,1,'fbbf7e21de61fe15303acb3126ddd0b536914092117e392d295040f855466ace','2026-11-15 03:39:30','2026-10-16 03:44:30','2026-10-15 19:39:30'),(262,2,'a71921178a2d0c233fc96b0a8eeaf7019c669fb1fb451332cc0ce3daf95c7519','2026-11-15 03:43:33','2026-10-16 03:58:33','2026-10-15 19:43:33'),(263,1,'90483f1438b48d003bc4f79eab78cc9d78ca199eb410356d87e2927ed9aab4fd','2026-11-15 03:44:30','2026-10-16 03:49:30','2026-10-15 19:44:30'),(264,3,'c0c0121fb35739ff7af1287333117f000b5fa95d5b20620c1951827a21c6dc35','2026-11-15 03:44:59','2026-10-16 03:59:59','2026-10-15 19:44:59'),(267,1,'626757956b8498cea62b20b3992b15e8aba04cd2d2b357dbe77374905b220c4a','2026-11-15 03:49:30','2026-10-16 03:54:30','2026-10-15 19:49:30'),(268,1,'a74c0ed0195370a12b09bb6098af29a34e58aae3bf18280c47a53bdea70dd182','2026-11-15 03:54:30','2026-10-16 03:59:30','2026-10-15 19:54:30'),(269,2,'c5e0785c868ab6a0813f2d56afaa581812c85a9ef620e25be8738774202ba0d9','2026-11-15 03:58:33','2026-10-16 04:13:33','2026-10-15 19:58:33'),(270,1,'ed674950b1ed12143e86be551e6903a270fe2ab8d9adee9fbec7a9d933087709','2026-11-15 03:59:30','2026-10-16 04:04:31','2026-10-15 19:59:30'),(271,3,'4806d9cd14fcb8285a16e37bd9d0c7cc2cf7d64fb63e4014d6ff0ecca89494ff','2026-11-15 03:59:59','2026-10-16 04:14:59','2026-10-15 19:59:59'),(274,1,'4fbde5c6c851cd128f141cdcf41aca01760ad9bde7a0a9cd9a9c2fe7081fa17c','2026-11-15 04:04:31','2026-10-16 04:09:31','2026-10-15 20:04:31'),(275,1,'3bb26c6d0d2f0391fd66a9962739f3f07a8af43914758eaf7dba8c1f1fe5a8ec','2026-11-15 04:09:31','2026-10-16 04:14:31','2026-10-15 20:09:31'),(277,2,'b3d8faccd81e9fff687c691d454ff67ac116ed3fad45c181a78a685f47a25d48','2026-11-15 04:13:33','2026-10-16 04:28:33','2026-10-15 20:13:33'),(278,1,'83a9abd2f7dc042bb645a958b0a35c299f54d6734011659c90245787bfe30f2a','2026-11-15 04:14:31','2026-10-16 04:19:31','2026-10-15 20:14:31'),(279,6,'c1f349f64157910285a54c800d9f52e7a27423a7bb62625bb0aaba1be8cf0c06','2026-11-15 04:14:50',NULL,'2026-10-15 20:14:50'),(280,3,'966952d54142cc2f8b9b79c4505425b65df6d24ed9103d2d979515f7c745f3bf','2026-11-15 04:14:59','2026-10-16 04:29:59','2026-10-15 20:14:59'),(283,6,'7a891e204bae1c884def07200298550402f78915308632a634c058157a8559f5','2026-11-15 04:17:46','2026-10-16 04:32:46','2026-10-15 20:17:46'),(284,1,'5d4b4a389b008dd03ef95a96206f4237732ec97b25896b928ae0ddf3a90dafeb','2026-11-15 04:19:31','2026-10-16 04:24:31','2026-10-15 20:19:31'),(285,1,'22a5b740e3af96d6c92987cfd75873f6c283b12e86dcb2c1f5af4dc295b3586e','2026-11-15 04:24:31','2026-10-16 04:29:31','2026-10-15 20:24:31'),(286,2,'138bafd0140f2c93378908e63ba055f94a407aa40fe6e88b743224cb49a3d910','2026-11-15 04:28:33',NULL,'2026-10-15 20:28:33'),(287,1,'394221db19f71329a5565951d0c3621829e3496a52ebf62b86d7b8270f23dc4d','2026-11-15 04:29:31','2026-10-16 04:34:32','2026-10-15 20:29:31'),(288,3,'2864c1310608a9226bd858d6bdc4b12e07ca5ae0173bbe9906ddb42359e38d67','2026-11-15 04:29:59',NULL,'2026-10-15 20:29:59'),(291,6,'78c7c68669b1346bfccca8acf0f39368dc3b479b6b7335b0f95cb5684421a785','2026-11-15 04:32:46',NULL,'2026-10-15 20:32:46'),(292,1,'746e05121ea37a18f02dddac13141304ec96afdc404774649bf67c37195a3db8','2026-11-15 04:34:32',NULL,'2026-10-15 20:34:32'),(295,1,'f10c72be1cc1b89ebd33d7615cca254d5acd2a0671eac262a682edd4fb1feadd','2026-11-15 15:24:18','2026-10-16 15:29:18','2026-10-16 07:24:18'),(296,2,'7dc17db32cb8ddb0080e96d2fe37a091996b320b678922866d3ae31b5411edb3','2026-11-15 15:24:30','2026-10-16 15:39:36','2026-10-16 07:24:30'),(297,3,'3a317391e6d1db1e7c09cb931ba3d44a4db9c92c5f49bb33094f4b8fc161276d','2026-11-15 15:26:55','2026-10-16 15:42:36','2026-10-16 07:26:55'),(299,6,'44a4e32bfe72dda44898db6bc8ef2fcc48b7807181473682026ba371b776baec','2026-11-15 15:27:11','2026-10-16 15:42:12','2026-10-16 07:27:11'),(300,1,'8393bc665541b197857f74f0d430fea760532e00b38c2b962b0fed3bbe29ac47','2026-11-15 15:29:18','2026-10-16 15:34:18','2026-10-16 07:29:18'),(302,1,'01af8bc0728d7dccd79fb128ad63335a354a3436752b00632d6bc6850d581b32','2026-11-15 15:34:18','2026-10-16 15:39:19','2026-10-16 07:34:18'),(303,1,'28262f1e640d2bc07969c105c8f3c88891285a4ce4c49538e876cba9fcb5fc76','2026-11-15 15:39:19','2026-10-16 15:44:20','2026-10-16 07:39:19'),(304,2,'d6e2c80a2bd0b003adde201e8301bfbb9d4596e62376958b978bdf15715bd7cd','2026-11-15 15:39:36','2026-10-16 15:54:37','2026-10-16 07:39:36'),(305,6,'616ad4d009bd8a3b73a727b778914a7c064ea38ce18641b16f646a4c8147996b','2026-11-15 15:42:12','2026-10-16 15:57:50','2026-10-16 07:42:12'),(307,3,'b48c5d88f4a10ec2171d3610abf44b6c06bdb881c614b544ef2c4faf653d51fb','2026-11-15 15:42:36','2026-10-16 15:57:37','2026-10-16 07:42:36'),(308,1,'54389d436359a9c4becf356a1e0d0e0f0f5e5f59ac17485862f2f04c8e429d52','2026-11-15 15:44:20','2026-10-16 15:49:20','2026-10-16 07:44:20'),(310,1,'691b328e2cef8fd0ddec0908938ca5bc8508a4730144637a6442241d1dd77e25','2026-11-15 15:49:20','2026-10-16 15:54:21','2026-10-16 07:49:20'),(311,1,'a6f24753eda0d5e0b12bb79c05de495a9ee04e1b461da1a39a4c837d085fa697','2026-11-15 15:54:21','2026-10-16 15:59:21','2026-10-16 07:54:21'),(312,2,'fcc534cb7119f7a001db3be6a082a285613f364801b114c21197a31c9482cb79','2026-11-15 15:54:37','2026-10-16 16:09:38','2026-10-16 07:54:37'),(314,3,'e6a740e858e3727805123f2b226adc30d269520398f73f214fbeda8b5a5bfda2','2026-11-15 15:57:37','2026-10-16 16:12:39','2026-10-16 07:57:37'),(315,6,'4cf50841ee07e95316ddce01bc78778cc6c47a6b794e22442e79e1e82dde4993','2026-11-15 15:57:50','2026-10-16 16:12:52','2026-10-16 07:57:50'),(316,1,'430a19d1b895b54248e810d60f150a4de2798315966e947c496797df31521d7a','2026-11-15 15:59:21','2026-10-16 16:04:23','2026-10-16 07:59:21'),(318,1,'fa36cd02f42c2762a8f8fbaa3cb0eda20b367265c35238a042d91db00e8401ec','2026-11-15 16:04:23','2026-10-16 16:09:24','2026-10-16 08:04:23'),(319,1,'748b8e9727bed4259329ba6ba197ec001afa3f61ff268dba9bbea8ce0e7f764f','2026-11-15 16:09:24','2026-10-16 16:14:25','2026-10-16 08:09:24'),(320,2,'58965427f92eb7fba086f2ec1d49ac1fd4b59114f6da0d751f06c344992a0c57','2026-11-15 16:09:38','2026-10-16 16:24:39','2026-10-16 08:09:38'),(322,3,'63c4045e054357ff87dff8c611f143680bf30ac4bdac5cbf05b32dadfa91da31','2026-11-15 16:12:39','2026-10-16 16:27:40','2026-10-16 08:12:39'),(323,6,'aaccecbb7e3b9d9c43417fcf4a1cf4be63e298a3fa08ead0d882ff0e3bfbb662','2026-11-15 16:12:52','2026-10-16 16:27:53','2026-10-16 08:12:52'),(324,1,'a0af041a11288898e111e1f6d4ccd0b33e56bffccfb14de444c615699a1e767b','2026-11-15 16:14:25','2026-10-16 16:19:26','2026-10-16 08:14:25'),(326,1,'6c5c017af04c76c35a687966fe323d860fdcfc89843c28db7e75db68af55195d','2026-11-15 16:19:26','2026-10-16 16:24:46','2026-10-16 08:19:26'),(327,2,'e6bf5c02c71bda60f5dddb08af7a4696dc008b8f52d5acda978490baade36535','2026-11-15 16:24:39','2026-10-16 16:39:40','2026-10-16 08:24:39'),(328,1,'9c0f450550c80cfcc55d25850a9eb455a362797fdbd408446b4f1671b15aff3e','2026-11-15 16:24:46','2026-10-16 16:29:47','2026-10-16 08:24:46'),(330,3,'a9507afd453309ce35aa340d4415825ede52339243da8da5124fa9bce9ed74ed','2026-11-15 16:27:40','2026-10-16 16:42:41','2026-10-16 08:27:40'),(331,6,'7b080942edbf06d063701953d070236e627751f92a9998d2aaa6f0fc50b3a82c','2026-11-15 16:27:53','2026-10-16 16:42:54','2026-10-16 08:27:53'),(332,1,'53954c27bef75307c115d89637c3be29b0ef9126f724219aecacea923f3808e5','2026-11-15 16:29:47','2026-10-16 16:34:48','2026-10-16 08:29:47'),(334,1,'ae8ee73e6249fe7daa2ff5a774b1b98abd4a6535a6d8bec8aa26badb6f98573c','2026-11-15 16:34:48','2026-10-16 16:39:49','2026-10-16 08:34:48'),(335,2,'f95fdab7aa051b07ba18c82b197defaea06c7314a0d102d465ee84a90ce4ad98','2026-11-15 16:39:40','2026-10-16 16:54:41','2026-10-16 08:39:40'),(336,1,'11df508ca7bce562f1722e8003fb46e47b0733edbcee1e79b0daa7a08973d46f','2026-11-15 16:39:49','2026-10-16 16:44:50','2026-10-16 08:39:49'),(338,3,'980c670fee8274d44511805d8c70ae36d0b8048bdc32f03cae57fb9fe81214d9','2026-11-15 16:42:41','2026-10-16 16:58:37','2026-10-16 08:42:41'),(339,6,'0217aaf0688abf8f3e8ac76c7ad2b8f2a39c152f3f303f8adc9ea7b23f572978','2026-11-15 16:42:54','2026-10-16 16:57:55','2026-10-16 08:42:54'),(340,1,'6907c77adb9df5eaf5fe6e8363408fe274322e3d61d7d15e4d28bf3226d1ffc5','2026-11-15 16:44:50','2026-10-16 16:50:46','2026-10-16 08:44:50'),(342,1,'f0f5bb3d65f7f8b73668de63f9a032414148b97bfe6c021a0e425c9014f6a209','2026-11-15 16:50:46','2026-10-16 16:55:47','2026-10-16 08:50:46'),(343,2,'f771e53cd7aa29b1718625f96787d925cc335f0b786f71eafe486baed66bd54d','2026-11-15 16:54:41',NULL,'2026-10-16 08:54:41'),(344,1,'8e0843a594f079480b883e0654a87ab73308cb9d1db79b51cc6dff2460e29d22','2026-11-15 16:55:47','2026-10-16 17:00:48','2026-10-16 08:55:47'),(345,6,'b92cd4792b58c8456b48f305f49b5ff2ddfe03316ee397512326b0c3b8be33f6','2026-11-15 16:57:55',NULL,'2026-10-16 08:57:55'),(347,3,'ad6039c5430217c48f2d94ec13c11e54bcb8f8c5efed755999ba26bc56668b00','2026-11-15 16:58:37',NULL,'2026-10-16 08:58:37'),(348,1,'4e776ac96a878eefb27e6dc8f89a4496f76af393e9c7e0f632bde21225ccc2a1','2026-11-15 17:00:48',NULL,'2026-10-16 09:00:48'),(350,1,'93c40638efcce93dfd9fc18e941749b73ba735d7c65fcacd12ca82ee1c0e4492','2026-11-16 01:21:40','2026-10-17 01:26:41','2026-10-16 17:21:40'),(351,1,'142e1a79f80decf5b54034c48a1746ecfea687aa6efe5756d8347e01d1066293','2026-11-16 01:26:41','2026-10-17 01:31:42','2026-10-16 17:26:41'),(352,3,'53a6cefbfbc2188a639bae8daa711467fea6537f3e80a7543824565626467498','2026-11-16 01:27:47','2026-10-17 01:42:47','2026-10-16 17:27:47'),(354,1,'58a65cf943771f0d424e671f99e00ed9e4d8f459f425cf329ba1ef908f759190','2026-11-16 01:31:42','2026-10-17 01:36:42','2026-10-16 17:31:42'),(355,6,'04a5fe15b04c742c444075db13fc0154d7ca713ee68423a4a5c867ab43b11a6e','2026-11-16 01:32:52','2026-10-17 01:47:53','2026-10-16 17:32:52'),(356,1,'dda259b44c1958dc3f282ccf33d21db369e32ae5b1229ad17e7071681b21005b','2026-11-16 01:36:42','2026-10-17 01:41:43','2026-10-16 17:36:42'),(357,1,'9e68838f3405fae20082e7d897e857d4cbcf0926e1c155f2569fee0b7646a260','2026-11-16 01:41:43','2026-10-17 01:46:44','2026-10-16 17:41:43'),(358,3,'0066ea6d862ac20cc3856fd85e593b7c86a3396d0b8c4aa74d848f76254b8121','2026-11-16 01:42:47','2026-10-17 01:57:48','2026-10-16 17:42:47'),(360,1,'0d00d253c04c1f458260e543749e55c49d49c1ceaf91542935e3876b50a0c4c9','2026-11-16 01:46:44','2026-10-17 01:51:45','2026-10-16 17:46:44'),(361,6,'8c8148befe2e4423951faedb494c00042b72525457edf3b835f9eb9e6aa151fc','2026-11-16 01:47:53','2026-10-17 02:02:54','2026-10-16 17:47:53'),(362,1,'7a7fca270cff201785a7f3bccb3e06385ab217954ffb0a0c1dfb9a360fa5586e','2026-11-16 01:51:45','2026-10-17 01:56:46','2026-10-16 17:51:45'),(363,1,'bddc88ec39c643d8fd8216e0297b970c396b95bbcc46a0fed6713e7521c8c340','2026-11-16 01:56:46','2026-10-17 02:01:47','2026-10-16 17:56:46'),(364,3,'4dd7315517e32849d7905401d62325dd941fa6a2da755e3375d4f0a6dc36c90f','2026-11-16 01:57:48','2026-10-17 02:12:49','2026-10-16 17:57:48'),(366,1,'615c2829fbc5ec3e5f8699cfb504dd3d36b0dd0ccf17d400095f5b3f405975f1','2026-11-16 02:01:47','2026-10-17 02:06:48','2026-10-16 18:01:47'),(367,6,'248b2aa45b1a54e73fede8d890e0e0c4398ceda5e1824a6715dbbd58cb57b8b3','2026-11-16 02:02:54','2026-10-17 02:17:55','2026-10-16 18:02:54'),(368,1,'d863a83808d864221bbe580d3694fcfdcd038f3b6e5fa964099a8883790eb921','2026-11-16 02:06:48','2026-10-17 02:11:49','2026-10-16 18:06:48'),(369,1,'52723be6e188ef1a8f75b6b710580743576e36c15a62bab97e7b29378cb7ff3d','2026-11-16 02:11:49','2026-10-17 02:16:50','2026-10-16 18:11:49'),(370,3,'152c5444088388c77c95eabf439de0d5a0defac50a0ab407d839825d69ec7f1d','2026-11-16 02:12:49','2026-10-17 02:27:50','2026-10-16 18:12:49'),(372,1,'85b78a4d596d04e37a656d02e6cb07cbf5676321d1c7ca7b452156c3633abd66','2026-11-16 02:16:50','2026-10-17 02:21:51','2026-10-16 18:16:50'),(373,6,'3eb0a85408e7407e1539471b63ac75c4815418d3a779c52a83739adbf05ca618','2026-11-16 02:17:55','2026-10-17 02:32:56','2026-10-16 18:17:55'),(374,1,'8d8fecd455ba59633ed964e913224c6aaba24277b9368c8ba21e98efb8d6b910','2026-11-16 02:21:51','2026-10-17 02:26:52','2026-10-16 18:21:51'),(375,1,'2fe5f67b4a28c1ded6aad3d07170e31fb9782d2aaef34fff717e55c480dc996c','2026-11-16 02:26:52','2026-10-17 02:31:53','2026-10-16 18:26:52'),(376,3,'32e4ae23be018df2ba330682336d7237afa8d6bb11264d4b5046d52410d50519','2026-11-16 02:27:50','2026-10-17 02:42:51','2026-10-16 18:27:50'),(378,1,'3fe8bc814a499407138cdd2849b90241a0d767bfc2916097fae9995d70b0dbc8','2026-11-16 02:31:53','2026-10-17 02:36:54','2026-10-16 18:31:53'),(379,6,'f778abc34bb082042ad9c0741e2ef689fc2807b1e038a398ce9bb82df8b8e859','2026-11-16 02:32:56','2026-10-17 02:47:57','2026-10-16 18:32:56'),(380,1,'30432c67674e6feb5e858dae797bfd72c47fb8b15699001da932f5b7b7d1e086','2026-11-16 02:36:54','2026-10-17 02:41:55','2026-10-16 18:36:54'),(381,1,'f944fac8fe524a3b6974ce90f78936c0a9113628f1473f5e3e007d7a1572d7cf','2026-11-16 02:41:55','2026-10-17 02:46:58','2026-10-16 18:41:55'),(382,2,'2069ebb144e70f68ed80146b2081199def67549f8366fbeddecc31575e3f84a5','2026-11-16 02:42:14','2026-10-17 02:57:45','2026-10-16 18:42:14'),(384,3,'28976c803e1579db4515748eb7e45b106be9800004bbfc5c048fa423ebc9f5e9','2026-11-16 02:42:51','2026-10-17 02:57:52','2026-10-16 18:42:51'),(386,1,'6722ec9c38903c57dca3c2fda75e87f728e8f594632045026eff778661d29a0c','2026-11-16 02:46:58','2026-10-17 02:51:58','2026-10-16 18:46:58'),(387,6,'79ecc17f5f35ac3f478833fb70e0ad502c07e1212cdf685c581196fb15229fef','2026-11-16 02:47:57','2026-10-17 03:02:58','2026-10-16 18:47:57'),(388,1,'efcf82a385b0827ef736596a40fbc2bfee2d4bfc384a7a48a997a1b430b6fcd4','2026-11-16 02:51:58','2026-10-17 02:56:59','2026-10-16 18:51:58'),(389,1,'1077f2f46d5c1becf1c3be30fa5b0c7baeb722609acd7539639ede78c20c978c','2026-11-16 02:56:59','2026-10-17 03:01:59','2026-10-16 18:56:59'),(391,2,'f872fb6be47702fa8de51835ae14ef5b457931f58dce04cb18daeba5b36ef528','2026-11-16 02:57:45','2026-10-17 03:12:46','2026-10-16 18:57:45'),(392,3,'9b29928bd18e62d6ba7566a07304a7f43fc1da631a1593c0acc2622ac4829853','2026-11-16 02:57:52','2026-10-17 03:12:53','2026-10-16 18:57:52'),(394,1,'e5afaae5e39bdcf0a5f9ad3b0239e122d0d3ab9d1ded86b27e825a2f7e94d0bb','2026-11-16 03:01:59','2026-10-17 03:07:00','2026-10-16 19:01:59'),(395,6,'50286bec40c563ca98891554e52a498707468e767c605039b5d24fce84866ada','2026-11-16 03:02:58','2026-10-17 03:17:59','2026-10-16 19:02:58'),(396,1,'05a9c97c8edc68f29c35d624ea2c9c9398c330a0a36633740907e919d58b4092','2026-11-16 03:07:00','2026-10-17 03:12:01','2026-10-16 19:07:00'),(397,1,'b100dd0f1b33fc1045542a4e2242302cadd32422c21a29314fb9607ec60890a2','2026-11-16 03:12:01','2026-10-17 03:17:01','2026-10-16 19:12:01'),(399,2,'3ebc046bb1c572f391d62d025ee4087cb8c7d2150f5b3713b517ce5667a4e717','2026-11-16 03:12:46','2026-10-17 03:27:47','2026-10-16 19:12:46'),(400,3,'e6cd059bd779bf9285c5e9e7d8b7fb5871c80b6bbc496da2fa1baf95c9849033','2026-11-16 03:12:53','2026-10-17 03:27:54','2026-10-16 19:12:53'),(402,1,'290516ad7b72c691084d192c9b589a1b39569bbe98851a1b9153ad55448941fd','2026-11-16 03:17:01','2026-10-17 03:22:02','2026-10-16 19:17:01'),(403,6,'c9dcf67cb30d57540174efec440179fde32241c209d904dbab199200f02e780e','2026-11-16 03:17:59','2026-10-17 03:33:01','2026-10-16 19:17:59'),(404,1,'7dc5352d9bc5687e3a8d3fff382cd52624a6bd669908f240d98e633024457851','2026-11-16 03:22:02','2026-10-17 03:27:02','2026-10-16 19:22:02'),(405,1,'9475b830d783d2a9aed7312c2a78fd8d63337b4a89ef873e5edc5b386ae875c0','2026-11-16 03:27:02','2026-10-17 03:32:04','2026-10-16 19:27:02'),(407,2,'c8c6a6d5998941b7642fb8782b6d734607b6c4b27c80d082ecad7d9ae62d40b7','2026-11-16 03:27:47','2026-10-17 03:42:49','2026-10-16 19:27:47'),(408,3,'a2105bad0c094e31c09e2c0f964ec81f391d1558a10b7be42cdbb4ce6005c061','2026-11-16 03:27:54','2026-10-17 03:42:56','2026-10-16 19:27:54'),(410,1,'2f6b196c4ab37b409ff45ec52129d4e0f3c17a2137c8230bbd5b46e5cd662b2f','2026-11-16 03:32:04','2026-10-17 03:37:05','2026-10-16 19:32:04'),(411,6,'de741d3655adff386a7509b1f2b1f1ad44c47f7327a242f5e448c1982060aac6','2026-11-16 03:33:01','2026-10-17 03:48:02','2026-10-16 19:33:01'),(412,1,'a1d10a5cd0959831c34ca2d10b456b7e362695bec1d2be207e17fda5fd143f77','2026-11-16 03:37:05','2026-10-17 03:42:06','2026-10-16 19:37:05'),(413,1,'e2e47ee6b916c7eb8b95fe7c20fc9fd53dbbaf7a28be7129f03ab3f361e1f791','2026-11-16 03:42:06','2026-10-17 03:47:07','2026-10-16 19:42:06'),(415,2,'c0d132673b6acd795d6be270e2a89d8c483ff4c9b5ecdd19f4fa4e2921e941a9','2026-11-16 03:42:49','2026-10-17 03:57:50','2026-10-16 19:42:49'),(416,3,'491b1418e775b30358a1ea08ef70d5241aa2958e47a75b3b38caeca8c5408c5e','2026-11-16 03:42:56','2026-10-17 03:57:57','2026-10-16 19:42:56'),(418,1,'48b08136b521b95fb3230cf818ae0c924a4c94716bec578c0abde418000c184c','2026-11-16 03:47:07','2026-10-17 03:52:08','2026-10-16 19:47:07'),(419,6,'ada7e1faf37f6cfa16c215dc45233a8a68cc17f6f17438a4610386c2e062ea79','2026-11-16 03:48:02','2026-10-17 04:03:03','2026-10-16 19:48:02'),(420,1,'d6b8bb74bf2cbf11fbac96d5fff70c3439e4a7fefc96d04db41c16d76c072c10','2026-11-16 03:52:08','2026-10-17 03:57:09','2026-10-16 19:52:08'),(421,1,'701b76352d3927fdb6dc20c125ad1e8777b02d358b6ccabfcdc8a442d842c9e0','2026-11-16 03:57:09','2026-10-17 04:02:10','2026-10-16 19:57:09'),(423,2,'e80c088bf6e9559630e23b7648beff2fb602a5edf6188c4626383cabec2b4cac','2026-11-16 03:57:50','2026-10-17 04:12:51','2026-10-16 19:57:50'),(424,3,'24d0aebd1b691cf0424707d09cc04421d89cfe1042cc293eb63d2f069ab48751','2026-11-16 03:57:57','2026-10-17 04:12:58','2026-10-16 19:57:57'),(426,1,'585184fc064bcebca793fab8fb66279b44803fa060761a84917b69a789725451','2026-11-16 04:02:10','2026-10-17 04:07:11','2026-10-16 20:02:10'),(427,6,'a3837cfc3c7441560e6d7663d8a09442694779b0a2b04f30ec4e0d9d373362bb','2026-11-16 04:03:03','2026-10-17 04:18:04','2026-10-16 20:03:03'),(428,1,'058cbb2cdd4361d4bb95536331c2b5ee3ed6859ab1d25eb8a3a80e416f7d9676','2026-11-16 04:07:11','2026-10-17 04:12:12','2026-10-16 20:07:11'),(429,1,'f5c9949860caf6b923211a50bbd6e1a4121f922f2074a11f871c57ac84ecd006','2026-11-16 04:12:12','2026-10-17 04:17:13','2026-10-16 20:12:12'),(431,2,'79235a33270055fee1d0effa9263e2e4864de9f6042846cb0aacc40e54a44d03','2026-11-16 04:12:51','2026-10-17 04:27:52','2026-10-16 20:12:51'),(432,3,'1b12f524eb6aaedaf69f7af7c7215f7cf450ae5a3554a249fbecbcb9a37faa29','2026-11-16 04:12:58','2026-10-17 04:27:59','2026-10-16 20:12:58'),(434,1,'45796c08b46b991c21f0b1264b6e9406426eae33b56038bad3faa58946fa0b5d','2026-11-16 04:17:13','2026-10-17 04:22:14','2026-10-16 20:17:13'),(435,6,'2baabae1811f5e9940282d19f5ad09f047aac453280a135fc59067f351fd8ec0','2026-11-16 04:18:04','2026-10-17 04:33:05','2026-10-16 20:18:04'),(436,1,'1fe8a3878be91613a5f49ddb39477fe14c710aa6c5d31f22ced559ef0a8cbb17','2026-11-16 04:22:14','2026-10-17 04:27:15','2026-10-16 20:22:14'),(437,1,'dadae8090952586869aea67557e5f2d16dc89ed379682951cb946fdd5ef6c781','2026-11-16 04:27:15','2026-10-17 04:32:16','2026-10-16 20:27:15'),(439,2,'7c863493e2c4b141efdf6c00ad42b69a9a86c997f866335ca2e1c977e2ba1aa8','2026-11-16 04:27:52','2026-10-17 04:42:52','2026-10-16 20:27:52'),(440,3,'b5c8eb216c49e856d3220863fee08317d753cffccf65b2a97eec74bdd8d1aba7','2026-11-16 04:27:59','2026-10-17 04:43:00','2026-10-16 20:27:59'),(442,1,'fafc327489105ffe84547cc3ba96e768c1d9ca7ade4782748f8541c207f095c3','2026-11-16 04:32:16',NULL,'2026-10-16 20:32:16'),(443,6,'53e96be8b18911a78c5c57351749c6fd168023e0ab906301a65e3076adba53bd','2026-11-16 04:33:05','2026-10-17 04:48:06','2026-10-16 20:33:05'),(444,1,'54dd4105bf8abb58456c1409997f846f734ed2625079feef40c5d54f1a2cfcc4','2026-11-16 04:35:08','2026-10-17 04:40:09','2026-10-16 20:35:08'),(445,1,'440affdc6a74cd638f97cb666116cb52edf0f19906b60f24f07feca1b0c47e9b','2026-11-16 04:40:09','2026-10-17 04:45:10','2026-10-16 20:40:09'),(447,2,'8b22b726861b2a93f9988487abcfec5694643d9ab30fa252f372afa5affea9cc','2026-11-16 04:42:52','2026-10-17 04:57:53','2026-10-16 20:42:52'),(448,3,'f38e413ab878e272984ba638c542ff6336a2c8a442a6898e8f9e06204348de6f','2026-11-16 04:43:00','2026-10-17 04:58:01','2026-10-16 20:43:00'),(450,1,'da15e73ec83dfb35be575cc54a200869565ddfe4ea28ba973e93ac6fb1b3539d','2026-11-16 04:45:10','2026-10-17 04:50:11','2026-10-16 20:45:10'),(451,6,'9fc01ec7fad8051f7c74487aaf1a9b320fa285e140b988f949fdbd98ef7f2566','2026-11-16 04:48:06','2026-10-17 05:03:07','2026-10-16 20:48:06'),(452,1,'3c8134ff729a93e03c0ad07758ebc41323150c0ed13c926f0b690e6646b35778','2026-11-16 04:50:11','2026-10-17 04:55:12','2026-10-16 20:50:11'),(453,1,'27cdbea4e062f5033c2926b8f9875fc2bec8c6745738562c513d6e70a6232eca','2026-11-16 04:55:12','2026-10-17 05:00:12','2026-10-16 20:55:12'),(455,2,'4b6a67e2c63a80673402f8eb974cab5cacea9ea0c9c8e2cb8baaca14d358ecf4','2026-11-16 04:57:53','2026-10-17 06:02:55','2026-10-16 20:57:53'),(456,3,'0a2bd507d6ca2aaec07d1f8b5d551e0cad77d89f18d32921b5b03a9d4dd52095','2026-11-16 04:58:01','2026-10-17 06:02:55','2026-10-16 20:58:01'),(458,1,'54ad004ab424053d8888fcbcc5e08703d340be17516714ad683c2011367d2b17','2026-11-16 05:00:12','2026-10-17 05:12:04','2026-10-16 21:00:12'),(459,6,'40e8c4b129d0fa40b8a6e82cfda99b02011e66242080c79f41546dbe82ef68c6','2026-11-16 05:03:07','2026-10-17 06:02:55','2026-10-16 21:03:07'),(460,1,'276518273224383e466938078bd92e3a247abcf115f78bf918e35a4c6978abbf','2026-11-16 05:12:04','2026-10-17 06:02:55','2026-10-16 21:12:04'),(461,1,'4d0952f9c47450a421e242a0d0026c01569828516891e3bfd649d0c2419a2ad8','2026-11-16 06:02:55','2026-10-17 06:59:21','2026-10-16 22:02:55'),(462,6,'b1ad1dbb720c97f2e71e6ad95d3957c3386aa46313a783102947a853345ba624','2026-11-16 06:02:55','2026-10-17 06:59:21','2026-10-16 22:02:55'),(465,2,'f1e8d49420bb8aa6b6319514cc57c0b53d6e6c7499a15bcb2b7f99d8023caa90','2026-11-16 06:02:55','2026-10-17 06:59:21','2026-10-16 22:02:55'),(466,3,'0cf5e08696e4cd0d645a6146cdcd2d47d5a4cfec94123e2ff4d6dd0124d3a870','2026-11-16 06:02:55','2026-10-17 06:59:21','2026-10-16 22:02:55'),(468,2,'152c99a43310aaea493a706d54cff9703f6c1c5cc9f8a1a34d75fd770b16c2f6','2026-11-16 06:59:21',NULL,'2026-10-16 22:59:21'),(470,6,'5ae129878e247af9b51c7e0b39657caddd6d4d5d0de7e5ef3cdd08eacfe1f359','2026-11-16 06:59:21',NULL,'2026-10-16 22:59:21'),(471,1,'07e866ff0dbb6397cfaf9907a037459e4260b5ad8a6ceab604731ac1211df9c3','2026-11-16 06:59:21',NULL,'2026-10-16 22:59:21'),(472,3,'8a9444d521940689f87c3f18f26eec57427602d8f2a8920b56a10d1326e17c2a','2026-11-16 06:59:21',NULL,'2026-10-16 22:59:21'),(473,1,'87c60cc211b4e7f4488a6bf0819f9021cbe5ea49fe21ae6e1a2d3f630b0e3c03','2026-11-18 04:20:08','2026-10-19 04:25:09','2026-10-18 20:20:08'),(474,1,'389d58692140223682c19fb94b3def0a6321dc9a1c34fa69fdabf7c81a6721c0','2026-11-18 04:25:09','2026-10-19 04:30:09','2026-10-18 20:25:09'),(475,1,'cf116f57254ffc5a0fed8126b4624cc458d62534cd4e8f26085b3e19fd4d2a25','2026-11-18 04:30:09','2026-10-19 04:35:09','2026-10-18 20:30:09'),(476,1,'bc0921c505de7ef5d5b4421783cdcb858c7d051422b29a17acd80aa4472a7826','2026-11-18 04:35:09','2026-10-19 04:40:09','2026-10-18 20:35:09'),(477,1,'83f621cfb7febbd969b23a33c036532d3e1d40d427dfcfeb7e449c24e8ed0b24','2026-11-18 04:40:09','2026-10-19 04:45:09','2026-10-18 20:40:09'),(478,1,'d9a64dc9bb97dbb7885c8fbf4f7b15848b29c59470773f81867c8a2953f9ba0a','2026-11-18 04:45:09','2026-10-19 04:50:09','2026-10-18 20:45:09'),(479,1,'b70619f9b1a09b14d8b7ca505519677c5572b13a852b5ad30b1c3d1476d8b7fd','2026-11-18 04:50:09','2026-10-19 04:55:09','2026-10-18 20:50:09'),(480,1,'f71eae803ce01281be95d6c0c29fa99bd71a39cfeb68728023b1cd6cc905bf77','2026-11-18 04:55:09','2026-10-19 05:00:09','2026-10-18 20:55:09'),(481,1,'1da82e54a194666c5da0f76993e5b6cf6f23d938ccd3928e7d8ee26f2365806d','2026-11-18 05:00:09','2026-10-19 05:05:09','2026-10-18 21:00:09'),(482,1,'1ddbcbf56d3809842d525a84ddaeaef4728499977c15cbe9152a28ab1fae91d0','2026-11-18 05:05:09','2026-10-19 05:10:10','2026-10-18 21:05:09'),(483,1,'c10b01bc4e0ed0c9389a1d0d5b35261cc05bf155cb2e443d769be2cba04f93bb','2026-11-18 05:10:10','2026-10-19 05:15:10','2026-10-18 21:10:10'),(484,1,'a0cda7d22b356e911185fb0cdbe419baaad9b052c420d36fba70fe97b04a9efd','2026-11-18 05:15:10','2026-10-19 05:20:10','2026-10-18 21:15:10'),(485,1,'46baa4ad52cccb575cd9bd4bbfa4cfaaf8e54568165398bb87a6fb6960a2f319','2026-11-18 05:20:10','2026-10-19 05:25:10','2026-10-18 21:20:10'),(486,1,'46b975b74524c9c8c37634158a52ad3ca8113ad2fcb46a566f0062b0e0e5e3b1','2026-11-18 05:25:10','2026-10-19 05:30:10','2026-10-18 21:25:10'),(487,1,'83513cda7ff101eb0c1beb523a4ce3d42c2ab38efc5d9e563d35b863ad902c38','2026-11-18 05:30:10',NULL,'2026-10-18 21:30:10'),(488,1,'a11e301ef259f70ca44ed3c8d6671fdaae78a8379622c15317c2b37f2fd48e27','2026-11-18 06:21:30','2026-10-19 06:26:31','2026-10-18 22:21:30'),(490,3,'369c2a06eed569c94acb495eddedc0bc493b94dcfff372086a05884bc32df211','2026-11-18 06:21:42',NULL,'2026-10-18 22:21:42'),(491,2,'d7f43ba0108eb0afb82088301c146fd8cd3bb1a3aa5c0afe2f8742f0591f496f','2026-11-18 06:21:48',NULL,'2026-10-18 22:21:48'),(493,6,'67eb018f50c56c61a4a340066578f581767981688987401b756c5021daaf107e','2026-11-18 06:22:32',NULL,'2026-10-18 22:22:32'),(494,1,'aae605b0439f5ee544ba3c41e9eaf70bde4249611480fb6f46c3694561cc4431','2026-11-18 06:26:31','2026-10-19 06:31:31','2026-10-18 22:26:31'),(495,1,'4db1dd8e1ffc089a96e7d3132a923b0347bdbddc764e6a7697221249bf746b59','2026-11-18 06:31:31','2026-10-19 06:36:32','2026-10-18 22:31:31'),(496,1,'e262dc82e856dbd4e9d9575435f8a5310e815383d0922575af12dc6420af7322','2026-11-18 06:36:32',NULL,'2026-10-18 22:36:32'),(497,1,'6e6ce0a4edddfa29d3159cd28696382593f832cdb5cd4a28d31befd0c3e154de','2026-11-19 18:54:32',NULL,'2026-10-20 10:54:32'),(498,1,'b1bb82fd8187e1bfd2df87886558ed28690105db282f16f13ea0c09c394f3a71','2026-11-19 18:57:14',NULL,'2026-10-20 10:57:14'),(499,1,'b0af5122cc111135ee0faf36c3f3048ad85402c1a514025bf6ced6d265f9b767','2026-11-19 18:57:17',NULL,'2026-10-20 10:57:17'),(500,6,'85b172332ba7eea03d747bbad9341e018ccc7d50f6fc4dbe1d27e524738918c0','2026-11-19 19:00:05',NULL,'2026-10-20 11:00:05'),(501,1,'b4e14e5498adc097b03cc90cf23ccfaf6b4ce0ab86a5f06a99e2516e11793fb4','2026-11-19 19:00:14','2026-10-20 19:05:15','2026-10-20 11:00:14'),(502,1,'70b511a12436fec3ffadfda42985fc6f32a08674ffa94d4470419732c3dae05f','2026-11-19 19:03:57',NULL,'2026-10-20 11:03:57'),(503,1,'70b22b52ea3f3ae36409cbbbcceffa9aec0817fd499f74812aca5729c54cb8dc','2026-11-19 19:04:14',NULL,'2026-10-20 11:04:14'),(504,1,'34b66ff5334492ebf5e86a3992aaca90e2e3c8b524e253c1b1be76abe317618d','2026-11-19 19:04:17',NULL,'2026-10-20 11:04:17'),(505,1,'040d5f416ea4d108b9cab386514050d79f33d143d503a2f9de0e788e9574a99e','2026-11-19 19:05:13',NULL,'2026-10-20 11:05:13'),(506,1,'cf4978517071c48ed9c4bb836496151c51603f629ef9bdcbe9c0dd4d8ce1dae1','2026-11-19 19:05:15','2026-10-20 19:10:16','2026-10-20 11:05:15'),(507,1,'33fe0d90aa233853b5e699c801614e3b82505646aeb692c2238061ba8f64ef49','2026-11-19 19:10:16','2026-10-20 19:15:17','2026-10-20 11:10:16'),(508,1,'61a2ee62a877bd97b7785b703f6f70b3fc6c05fd3cb6d11d16ba106181354399','2026-11-19 19:15:17',NULL,'2026-10-20 11:15:17'),(509,1,'e0035915605bb428c80289aa6b0e10df0508a94e51e240db186f74426aaaa7bb','2026-11-19 19:16:05',NULL,'2026-10-20 11:16:05');
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
-- Table structure for table `therapists`
--

DROP TABLE IF EXISTS `therapists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `therapists` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `full_name` varchar(160) NOT NULL,
  `email` varchar(190) DEFAULT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `age` int DEFAULT NULL,
  `id_number` varchar(80) DEFAULT NULL,
  `status` enum('ACTIVE','ARCHIVED') NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `id_number` (`id_number`),
  KEY `idx_therapists_name` (`full_name`),
  KEY `idx_therapists_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `therapists`
--

LOCK TABLES `therapists` WRITE;
/*!40000 ALTER TABLE `therapists` DISABLE KEYS */;
INSERT INTO `therapists` VALUES (1,'Queencel','therapist@dermaclinic.test',NULL,NULL,NULL,'ACTIVE','2026-10-20 19:14:59','2026-10-20 19:14:59'),(2,'princess','princess@gmail.com',NULL,NULL,NULL,'ACTIVE','2026-10-20 19:14:59','2026-10-20 19:14:59');
/*!40000 ALTER TABLE `therapists` ENABLE KEYS */;
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
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `docket_number` (`docket_number`),
  KEY `fk_dockets_appointment` (`appointment_id`),
  KEY `fk_dockets_dermatologist` (`dermatologist_id`),
  KEY `fk_dockets_service` (`service_id`),
  KEY `idx_dockets_patient` (`patient_id`),
  KEY `idx_dockets_status` (`status`),
  KEY `fk_dockets_therapist` (`therapist_id`),
  CONSTRAINT `fk_dockets_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`),
  CONSTRAINT `fk_dockets_dermatologist` FOREIGN KEY (`dermatologist_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_dockets_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`),
  CONSTRAINT `fk_dockets_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`),
  CONSTRAINT `fk_dockets_therapist` FOREIGN KEY (`therapist_id`) REFERENCES `therapists` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treatment_dockets`
--

LOCK TABLES `treatment_dockets` WRITE;
/*!40000 ALTER TABLE `treatment_dockets` DISABLE KEYS */;
INSERT INTO `treatment_dockets` VALUES (9,'TD-89944DF921',19,NULL,NULL,NULL,14,'READY','2026-10-15 01:57:06','2026-10-15 01:57:06'),(10,'TD-FCD228CAE7',19,NULL,NULL,NULL,14,'READY','2026-10-15 02:27:24','2026-10-15 02:29:43'),(11,'TD-DB7442B11D',20,NULL,NULL,NULL,14,'READY','2026-10-17 02:49:34','2026-10-17 02:50:16'),(12,'TD-139838B66F',21,NULL,NULL,NULL,14,'READY','2026-10-17 04:45:12','2026-10-17 04:45:12'),(14,'TD-3466FCED99',21,NULL,NULL,NULL,15,'READY','2026-10-17 04:53:32','2026-10-17 04:55:29');
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,'Mondejar, Shin','admin@dermaclinic.test','$2a$10$NUkndv2.L7xZ8KaKlBULzeG9F/CPQ4P2K1q7TlEO4TAYX5fgWNOra','ACTIVE','2026-09-16 13:14:55','2026-09-25 16:59:31',0),(2,2,'Jamer','reception@dermaclinic.test','$2a$10$uSe7q35Dp37segXWOL6IKOO60/7WiSkv1h2wwDXxKGficGeGav1U.','ACTIVE','2026-09-16 13:14:55','2026-09-28 11:34:23',0),(3,3,'Dr. Jem','dermatologist@dermaclinic.test','$2a$10$kCdOjQ9I.In27bu4p/HTEudo4KN3S2IK0KG7J0EzH6UcxCp5AUvpG','ACTIVE','2026-09-16 13:14:55','2026-10-12 06:53:34',0),(6,6,'Ralph','inventory@dermaclinic.test','$2a$10$vzm4mWFVDTpaC8rK2mwiCOxFrKGXQ6Pn.uC1wzq4Z1F4I6zx8YDsq','ACTIVE','2026-09-16 13:14:55','2026-10-12 06:53:12',0),(7,2,'Database Test User','created-b1b73013@example.test','$2a$10$rhKgwSD8r8jqvlRBV2nBveFNMLnvrFUwxj9R4Pnuf1KnXCRd72yn2','INACTIVE','2026-09-24 06:10:41','2026-09-24 06:10:41',1),(8,1,'mondejar','mondejar@gmail.com','$2a$10$oZRjt8iX5HxhjWLKHGbA9O8Zsgvblvm7sydm5RVpwpDpQGnzvlH12','INACTIVE','2026-09-24 06:41:18','2026-10-12 06:52:55',1),(9,1,'Mondejarwashington','mondejar041921@gmail.com','$2a$10$yeMvu52XWIoH/86KRXlPM.zAkAmJne8Wqlkfc86xcbTfT2hH7TSG2','INACTIVE','2026-09-24 07:16:44','2026-10-12 06:52:52',1),(10,2,'Mondejar, Washington B.','Mondejarshin@dermaclinic.test','$2a$10$N5J46Y5RJQdhLmMDho6Ggu7F6CJgvP8I5O.Dwmo5F4qNrYVkHzGSW','INACTIVE','2026-09-24 07:20:45','2026-10-12 06:52:47',1),(12,6,'fujimiyakun','fujimiyakun0441921@dermaclinic.test','$2a$10$IFSs6SZ9/deDu17nNpVUYu88s2Fq.B.MVCmIbtHuL3uPrgDXLnZXu','INACTIVE','2026-09-24 07:29:25','2026-10-12 06:44:21',1),(13,1,'Mondejar, Washington B.','Mondejarwashington041921@gmail.com','$2a$10$b1bP9C.ESdgQcVJBu5T0PeuxxrAv0PGKUJXIAdFDtFadk/g0k9lVK','INACTIVE','2026-09-24 09:50:10','2026-10-12 06:44:18',1),(14,1,'kenshin','kenshin041921@gmail.com','$2a$10$acgE6Kd1qbkcMow5nOsnqOsJyZFzQX1CATQl0I4GOmq3Zk83ROSHS','INACTIVE','2026-09-25 08:41:04','2026-10-12 06:44:14',1);
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

-- Dump completed on 2026-10-21  3:40:19
