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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES (1,'APT-7A435A80B7',15,4,'2026-09-24 09:09:00','2026-09-24 09:39:00','CONFIRMED','2026-09-24 09:08:14','2026-09-24 09:08:14'),(3,'APT-F2A04126E2',15,3,'2026-09-24 01:09:00','2026-09-24 01:39:00','CONFIRMED','2026-09-24 09:24:34','2026-09-24 09:24:34'),(4,'APT-A24FBC6903',15,3,'2026-09-24 10:28:00','2026-09-24 10:58:00','CONFIRMED','2026-09-24 09:27:06','2026-09-24 09:27:06'),(5,'APT-D5B7A5E69A',15,4,'2026-09-24 10:28:00','2026-09-24 10:58:00','CONFIRMED','2026-09-24 09:27:15','2026-09-24 09:27:15'),(6,'APT-E583DFEEA3',15,3,'2026-09-24 10:19:00','2026-09-24 10:49:00','CONFIRMED','2026-09-24 10:18:05','2026-09-24 10:18:05'),(7,'APT-64001FA8B4',15,4,'2026-09-24 10:19:00','2026-09-24 10:49:00','CONFIRMED','2026-09-24 10:18:13','2026-09-24 10:18:13'),(21,'APT-910290211B',5,3,'2026-09-25 10:19:00','2026-09-25 10:49:00','COMPLETED','2026-09-24 10:18:47','2026-09-28 08:23:49'),(28,'APT-B099830F33',1,3,'2026-09-24 10:20:00','2026-09-24 10:50:00','CONFIRMED','2026-09-24 10:19:05','2026-09-24 10:19:05'),(31,'APT-0474FC34AA',3,4,'2026-09-25 06:20:00','2026-09-25 06:50:00','CONFIRMED','2026-09-25 06:19:07','2026-09-25 06:19:07'),(32,'APT-68E3BD8B66',20,4,'2026-09-25 08:26:00','2026-09-25 08:56:00','CONFIRMED','2026-09-25 08:23:25','2026-09-25 08:23:25'),(33,'APT-6155B12EB5',19,4,'2026-09-30 08:40:00','2026-09-30 09:10:00','COMPLETED','2026-09-25 08:37:20','2026-09-28 08:13:35'),(34,'APT-0463CEA8D9',21,4,'2026-09-25 08:50:00','2026-09-25 09:20:00','CONFIRMED','2026-09-25 08:44:34','2026-09-25 08:44:34'),(35,'APT-B18E9A6DBB',24,3,'2026-09-25 09:29:00','2026-09-25 09:59:00','COMPLETED','2026-09-25 09:29:45','2026-09-28 09:43:01'),(36,'APT-F907AE632A',27,3,'2026-09-25 13:50:00','2026-09-25 14:20:00','COMPLETED','2026-09-25 13:48:56','2026-09-28 08:20:29'),(37,'APT-F3B1276DE8',30,3,'2026-09-26 15:55:00','2026-09-26 16:25:00','COMPLETED','2026-09-25 15:54:58','2026-09-28 08:20:27'),(38,'APT-2ACF00230F',32,3,'2026-09-30 04:04:00','2026-09-30 04:34:00','COMPLETED','2026-09-25 16:11:15','2026-09-28 08:20:23');
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
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,2,'Treatment','DOCKET_CREATED','14','TD-EBE854B3CC','{\"patientId\": \"3\", \"serviceId\": \"20\"}','2026-09-28 07:51:15'),(2,1,'Services','SERVICE_PRODUCT_LINK','6',NULL,'{\"productId\": \"2\"}','2026-09-28 07:51:23'),(3,1,'Services','SERVICE_PRODUCT_LINK','6',NULL,'{\"productId\": \"null\"}','2026-09-28 07:51:28'),(4,1,'Billing','INVOICE_CREATED','12','INV-FBA35856DF','{\"paid\": \"20\", \"total\": \"50.00\", \"status\": \"PARTIAL\", \"discount\": \"0\"}','2026-09-28 07:51:34'),(5,5,'Billing','PAYMENT_RECORDED','12','PAY-63C0661DE6','{\"amount\": \"30\", \"status\": \"PAID\"}','2026-09-28 07:51:40'),(6,1,'Treatment','DOCKET_CREATED','16','TD-8B1098342D','{\"patientId\": \"3\", \"serviceId\": \"20\"}','2026-09-28 07:55:03'),(7,1,'Appointments','APPOINTMENT_STATUS_CHANGED','33','COMPLETED','{\"status\": \"COMPLETED\"}','2026-09-28 08:13:35'),(8,4,'Appointments','APPOINTMENT_STATUS_CHANGED','38','CANCELLED','{\"status\": \"CANCELLED\"}','2026-09-28 08:13:47'),(9,1,'Appointments','APPOINTMENT_STATUS_CHANGED','38','CONFIRMED','{\"status\": \"CONFIRMED\"}','2026-09-28 08:13:47'),(10,1,'Appointments','APPOINTMENT_STATUS_CHANGED','38','COMPLETED','{\"status\": \"COMPLETED\"}','2026-09-28 08:20:23'),(11,1,'Appointments','APPOINTMENT_STATUS_CHANGED','37','COMPLETED','{\"status\": \"COMPLETED\"}','2026-09-28 08:20:27'),(12,1,'Appointments','APPOINTMENT_STATUS_CHANGED','36','COMPLETED','{\"status\": \"COMPLETED\"}','2026-09-28 08:20:29'),(13,1,'Appointments','APPOINTMENT_STATUS_CHANGED','21','COMPLETED','{\"status\": \"COMPLETED\"}','2026-09-28 08:23:49'),(14,1,'Appointments','APPOINTMENT_STATUS_CHANGED','21','COMPLETED','{\"status\": \"COMPLETED\"}','2026-09-28 08:23:52'),(15,1,'Appointments','APPOINTMENT_STATUS_CHANGED','21','COMPLETED','{\"status\": \"COMPLETED\"}','2026-09-28 08:23:54'),(16,1,'Appointments','APPOINTMENT_STATUS_CHANGED','21','COMPLETED','{\"status\": \"COMPLETED\"}','2026-09-28 08:24:20'),(17,1,'Appointments','APPOINTMENT_CREATED','19','APT-388D271FBF','{\"staffId\": \"2\", \"startsAt\": \"2026-10-01T11:15\"}','2026-09-28 08:27:00'),(18,1,'Appointments','APPOINTMENT_CREATED','19','APT-E35D8F6E0D','{\"staffId\": \"2\", \"startsAt\": \"2026-11-02T14:45\"}','2026-09-28 08:31:56'),(19,1,'Consultations','CONSULTATION_CREATED','19','CON-3022EA788E',NULL,'2026-09-28 08:31:56'),(20,1,'Consultations','CONSULTATION_CREATED','19','CON-61098E497D',NULL,'2026-09-28 08:32:02'),(21,1,'Inventory','MOVEMENT_RECORDED','1','TZCHECK','{\"type\": \"STOCK_IN\", \"quantity\": \"5\", \"newQuantity\": \"5\"}','2026-09-28 08:32:15'),(22,1,'Consultations','CONSULTATION_CREATED','17','CON-C9BEF55585',NULL,'2026-09-28 08:34:48'),(23,1,'Appointments','APPOINTMENT_STATUS_CHANGED','33','COMPLETED','{\"status\": \"COMPLETED\"}','2026-09-28 09:42:54'),(24,1,'Appointments','APPOINTMENT_STATUS_CHANGED','33','COMPLETED','{\"status\": \"COMPLETED\"}','2026-09-28 09:42:56'),(25,1,'Appointments','APPOINTMENT_STATUS_CHANGED','35','COMPLETED','{\"status\": \"COMPLETED\"}','2026-09-28 09:43:01'),(26,1,'Consultations','CONSULTATION_CREATED','22','CON-746449E3D2',NULL,'2026-09-28 09:43:35'),(27,1,'Inventory','MOVEMENT_RECORDED','5','Isaac','{\"type\": \"STOCK_OUT\", \"quantity\": \"10\", \"newQuantity\": \"13605.000\"}','2026-09-28 09:56:07'),(28,5,'Billing','INVOICE_CREATED','13','INV-DFCE5D14AA','{\"paid\": \"499.5\", \"total\": \"499.50\", \"status\": \"PAID\", \"discount\": \"0.5\"}','2026-09-28 10:15:05'),(29,5,'Billing','INVOICE_CREATED','14','INV-2E6102906A','{\"paid\": \"25\", \"total\": \"50.00\", \"status\": \"PARTIAL\", \"discount\": \"0\"}','2026-09-28 10:19:04'),(30,5,'Billing','PAYMENT_RECORDED','14','PAY-5A79890166','{\"amount\": \"25\", \"status\": \"PAID\"}','2026-09-28 10:19:14'),(31,5,'Billing','INVOICE_CREATED','15','INV-51CE8C76C4','{\"paid\": \"0\", \"total\": \"50.00\", \"status\": \"PENDING\", \"discount\": \"0\"}','2026-09-28 10:19:17'),(32,5,'Billing','PAYMENT_RECORDED','15','PAY-ABCDECA675','{\"amount\": \"25\", \"status\": \"PARTIAL\"}','2026-09-28 10:19:23'),(33,5,'Billing','PAYMENT_RECORDED','15','PAY-AFFEDB4568','{\"amount\": \"25\", \"status\": \"PAID\"}','2026-09-28 10:19:27');
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consultations`
--

LOCK TABLES `consultations` WRITE;
/*!40000 ALTER TABLE `consultations` DISABLE KEYS */;
INSERT INTO `consultations` VALUES (1,'CON-70DF68518D',1,NULL,1,'covid','19','batman','2',NULL,'2026-09-24 09:10:08'),(2,'CON-5EC057BCAA',3,NULL,13,'covid','19','batman','4 weeks',NULL,'2026-09-24 10:20:05'),(3,'CON-BE607223ED',15,NULL,1,'covid','batman','19','10',NULL,'2026-09-25 06:19:35'),(4,'CON-1649CD4402',17,NULL,1,'covid','batman','19','10',NULL,'2026-09-25 06:37:48'),(5,'CON-104A17165E',19,NULL,1,'fdsg','dgsdg','dgsdg','4 weeks',NULL,'2026-09-25 08:23:04'),(6,'CON-1FC7BAF4EF',20,NULL,1,'fdsg','dgsdg','dgsdg','4 weeks',NULL,'2026-09-25 08:37:25'),(7,'CON-91B176052E',24,NULL,14,'C','CC','C','2',NULL,'2026-09-25 09:29:24'),(8,'CON-E388FD9836',27,NULL,1,'batman','covid','119','1',NULL,'2026-09-25 13:49:40'),(9,'CON-1AB6A4E714',23,NULL,3,'batman','covid','119','1',NULL,'2026-09-25 14:11:17'),(10,'CON-6317AA20BC',20,NULL,1,'batma','covid','ako','2',NULL,'2026-09-25 15:55:20'),(11,'CON-7B1CF39FB6',3,NULL,3,'batman','covid','ako','2',NULL,'2026-09-25 16:00:55'),(14,'CON-C9BEF55585',17,NULL,1,'ADASD','ADSASDAS','ASFDASFAS','ASFADFAS','2026-11-03','2026-09-28 08:34:48'),(15,'CON-746449E3D2',22,NULL,1,'Baog','Papwet','Sabi ni doc isaac','later','2026-11-03','2026-09-28 09:43:35');
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
INSERT INTO `inventory_balances` VALUES (2,349.000,'2026-09-28 07:55:03'),(5,13605.000,'2026-09-28 09:56:07'),(9,160.000,'2026-09-25 13:00:24'),(10,365.000,'2026-09-25 07:41:27'),(11,365.000,'2026-09-25 07:41:27'),(12,176.000,'2026-09-25 07:41:27'),(13,257.000,'2026-09-25 07:41:27');
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
INSERT INTO `inventory_batches` VALUES (1,5,'OPENING-20260925','2027-12-31','2026-09-25 07:41:27'),(2,9,'OPENING-20260925','2027-12-31','2026-09-25 07:41:27'),(3,12,'OPENING-20260925','2027-12-31','2026-09-25 07:41:27'),(4,2,'OPENING-20260925','2027-12-31','2026-09-25 07:41:27'),(5,10,'OPENING-20260925','2027-12-31','2026-09-25 07:41:27'),(6,11,'OPENING-20260925','2027-12-31','2026-09-25 07:41:27'),(7,13,'OPENING-20260925','2027-12-31','2026-09-25 07:41:27'),(8,5,'2026-09','2026-09-26','2026-09-25 08:25:11'),(9,2,'2026-10','2026-09-30','2026-09-25 08:38:08'),(10,5,'2026-10','2026-09-30','2026-09-25 09:01:18'),(11,9,'A-2026-09','2026-10-31','2026-09-25 13:00:24'),(12,5,'A-2026-19','2026-12-04','2026-09-25 13:50:29'),(13,5,'A-2026-11','2026-11-26','2026-09-25 14:31:29'),(14,5,'A-2026-12','2026-10-15','2026-09-25 15:56:52'),(16,5,'Batch 1','2026-09-28','2026-09-28 09:56:07');
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_movements`
--

LOCK TABLES `inventory_movements` WRITE;
/*!40000 ALTER TABLE `inventory_movements` DISABLE KEYS */;
INSERT INTO `inventory_movements` VALUES (1,2,4,NULL,'STOCK_IN',0.000,0.000,365.000,'OPENING-STOCK',1,'2026-09-25 07:41:27'),(2,5,1,NULL,'STOCK_IN',0.000,0.000,176.000,'OPENING-STOCK',1,'2026-09-25 07:41:27'),(3,9,2,NULL,'STOCK_IN',0.000,0.000,176.000,'OPENING-STOCK',1,'2026-09-25 07:41:27'),(4,10,5,NULL,'STOCK_IN',0.000,0.000,365.000,'OPENING-STOCK',1,'2026-09-25 07:41:27'),(5,11,6,NULL,'STOCK_IN',0.000,0.000,365.000,'OPENING-STOCK',1,'2026-09-25 07:41:27'),(6,12,3,NULL,'STOCK_IN',0.000,0.000,176.000,'OPENING-STOCK',1,'2026-09-25 07:41:27'),(7,13,7,NULL,'STOCK_IN',0.000,0.000,257.000,'OPENING-STOCK',1,'2026-09-25 07:41:27'),(8,5,8,NULL,'STOCK_IN',176.000,0.000,182.000,'DN-2026-09841',1,'2026-09-25 08:25:11'),(9,2,9,NULL,'STOCK_OUT',365.000,6.000,359.000,'DN-2026-09842',1,'2026-09-25 08:38:08'),(10,5,10,NULL,'STOCK_IN',182.000,0.000,192.000,'DN-2026-09845',6,'2026-09-25 09:01:18'),(11,5,10,NULL,'ADJUSTMENT',192.000,5.000,187.000,'DN-2026-09844',14,'2026-09-25 09:30:46'),(12,9,11,NULL,'STOCK_OUT',176.000,16.000,160.000,'DN-2026-09819',1,'2026-09-25 13:00:24'),(13,5,12,NULL,'STOCK_OUT',187.000,100.000,87.000,'DN-2026-09842',1,'2026-09-25 13:50:29'),(14,5,13,NULL,'STOCK_IN',87.000,0.000,283.000,'DN-2026-09849',6,'2026-09-25 14:31:29'),(15,5,14,NULL,'STOCK_IN',283.000,0.000,6949.000,'DN-2026-09848',1,'2026-09-25 15:56:52'),(16,5,14,NULL,'STOCK_IN',6949.000,0.000,13615.000,'DN-2026-09848',6,'2026-09-25 16:04:17'),(17,2,9,14,'STOCK_OUT',359.000,5.000,354.000,'TD-EBE854B3CC',2,'2026-09-28 07:51:15'),(18,2,9,16,'STOCK_OUT',354.000,5.000,349.000,'TD-8B1098342D',1,'2026-09-28 07:55:03'),(20,5,16,NULL,'STOCK_OUT',13615.000,10.000,13605.000,'Isaac',1,'2026-09-28 09:56:07');
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
INSERT INTO `invoices` VALUES (1,'INV-876A5C27A9',1,502.00,50.00,452.00,'PAID','2026-09-24 09:34:05'),(2,'INV-D92DC6EB95',2,150.00,50.00,100.00,'PAID','2026-09-24 12:41:45'),(3,'INV-567266E264',3,150.00,0.00,150.00,'PAID','2026-09-25 06:21:06'),(4,'INV-002B7D499E',4,500.00,0.00,500.00,'PAID','2026-09-25 06:39:46'),(5,'INV-702291A3B5',6,500.00,5.00,495.00,'PAID','2026-09-25 08:40:27'),(6,'INV-3DCE676832',5,150.00,50.00,100.00,'PAID','2026-09-25 09:31:04'),(7,'INV-E14EBE9A10',7,150.00,50.00,100.00,'PAID','2026-09-25 13:00:58'),(8,'INV-16DB6C789A',9,502.00,52.00,450.00,'PAID','2026-09-25 13:50:59'),(9,'INV-DA9544692F',10,50.00,5.00,45.00,'PAID','2026-09-25 15:57:11'),(10,'INV-5F5219407A',11,502.00,2.00,500.00,'PAID','2026-09-25 16:03:28'),(11,'INV-0405A5A587',13,1234.00,50.00,1184.00,'PAID','2026-09-28 02:36:11'),(12,'INV-FBA35856DF',14,50.00,0.00,50.00,'PAID','2026-09-28 07:51:34'),(13,'INV-DFCE5D14AA',8,500.00,0.50,499.50,'PAID','2026-09-28 10:15:05'),(14,'INV-2E6102906A',16,50.00,0.00,50.00,'PAID','2026-09-28 10:19:04'),(15,'INV-51CE8C76C4',12,50.00,0.00,50.00,'PAID','2026-09-28 10:19:17');
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
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (1,'PT-0001','John Smith','john@example.com','07123456789','1990-05-20',NULL,NULL,'ARCHIVED','2026-09-15 16:52:17','2026-09-24 12:37:38'),(3,'PT-0002','New Patient','newpatient@example.com','07123456789','2001-04-19',NULL,NULL,'ARCHIVED','2026-09-15 16:56:41','2026-09-28 08:41:14'),(4,'PT-1055','mondejar','mondejar@gmail.com','09243078998','2001-04-19',NULL,NULL,'ARCHIVED','2026-09-15 16:58:58','2026-09-28 08:41:25'),(5,'PT-1001','Mondejar Washington','mondejarwashington@gmail.com','+63 924 307 8998','2001-04-19',NULL,NULL,'ARCHIVED','2026-09-16 12:59:58','2026-09-28 08:43:25'),(10,'PT-0491AA35','MondejarwashingtonB','MondejarwashingtonB@gmail.com','+63 9243078998','2026-09-17',NULL,NULL,'ARCHIVED','2026-09-17 14:51:07','2026-09-28 08:43:27'),(11,'PT-1CFB48B1','MondejarwashingtonB','MondejarwashingtonB@gmail.com','+63 9243078998','2026-09-17',NULL,NULL,'ARCHIVED','2026-09-17 14:51:47','2026-09-28 08:43:29'),(12,'PT-8EBB2637','mondejarshin','mondejarshin@gmail.com','+63 9243078998','2001-04-19',NULL,NULL,'ARCHIVED','2026-09-22 10:24:52','2026-09-28 09:42:46'),(13,'PT-FB5800CA','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2026-09-24',NULL,NULL,'ACTIVE','2026-09-24 02:50:34','2026-09-24 02:50:34'),(14,'PT-904DC4DB','Lethe','nanikore@gmail.com','+639123456789','2005-08-24',NULL,NULL,'ACTIVE','2026-09-24 03:03:09','2026-09-24 03:03:09'),(15,'PT-312D9F50','mondejar','mondejar@gmail.com','+63 9243078998','2026-09-24',NULL,NULL,'ACTIVE','2026-09-24 09:07:54','2026-09-24 09:07:54'),(16,'PT-325E7073','MondejarwashingtonB','MondejarwashingtonB@gmail.com','+63 9243078998','2026-09-25',NULL,NULL,'ACTIVE','2026-09-25 06:18:46','2026-09-25 06:18:46'),(17,'PT-17D4F886','MondejarwashingtonB','MondejarwashingtonB@gmail.com','+63 9243078998','2026-09-25',NULL,NULL,'ACTIVE','2026-09-25 06:36:35','2026-09-25 06:36:35'),(18,'PT-D3194AB7','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2026-09-25',NULL,NULL,'ACTIVE','2026-09-25 07:50:28','2026-09-25 07:50:28'),(19,'PT-8BFFB695','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2026-09-25',NULL,NULL,'ACTIVE','2026-09-25 08:21:26','2026-09-25 08:21:26'),(20,'PT-A67927E3','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2026-09-25',NULL,NULL,'ACTIVE','2026-09-25 08:21:42','2026-09-25 08:21:42'),(21,'PT-148B619C','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2026-09-30',NULL,NULL,'ACTIVE','2026-09-25 08:43:44','2026-09-25 08:43:44'),(22,'PT-20758D7D','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2026-09-30',NULL,NULL,'ACTIVE','2026-09-25 08:43:57','2026-09-25 08:43:57'),(23,'PT-A0D01747','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2026-09-25',NULL,NULL,'ACTIVE','2026-09-25 09:28:48','2026-09-25 09:28:48'),(24,'PT-EAC65C0C','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2026-09-30',NULL,NULL,'ACTIVE','2026-09-25 09:28:58','2026-09-25 09:28:58'),(25,'PT-BE1DE13F','kenshin','kenshin@gmail.com','+639243078998','2026-09-25',NULL,NULL,'ACTIVE','2026-09-25 12:33:48','2026-09-25 12:33:48'),(26,'PT-9984A143','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2026-09-25',NULL,NULL,'ACTIVE','2026-09-25 13:48:17','2026-09-25 13:48:17'),(27,'PT-B3E82E9D','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2026-09-26',NULL,NULL,'ACTIVE','2026-09-25 13:48:31','2026-09-25 13:48:31'),(28,'PT-0A526C61','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2026-09-25',NULL,NULL,'ACTIVE','2026-09-25 14:04:05','2026-09-25 14:04:05'),(29,'PT-06CE2ABB','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2026-09-26',NULL,NULL,'ACTIVE','2026-09-25 14:04:27','2026-09-25 14:04:27'),(30,'PT-71A83840','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2026-09-26',NULL,NULL,'ACTIVE','2026-09-25 15:54:36','2026-09-25 15:54:36'),(31,'PT-267A6FAD','Shin Ken','fujimiyakun04419@gmail.com','+63 9243078998','2026-09-25',NULL,NULL,'ACTIVE','2026-09-25 15:54:46','2026-09-25 15:54:46'),(32,'PT-5392F293','Shinken','fujimiyakun0441921@gmail.com','+63 924 307 8990','2026-09-30',NULL,NULL,'ACTIVE','2026-09-25 16:10:48','2026-09-25 16:10:48'),(33,'PT-E2FD1A45','Shinken','preview.local@example.com','+63 924 307 8990','2026-09-30',NULL,NULL,'ACTIVE','2026-09-25 16:13:01','2026-09-25 16:13:01'),(34,'PT-C7AA97D8','jamer fundano','jamerfundano@gmail.com','+639243078998','2001-01-25',NULL,NULL,'ACTIVE','2026-09-28 02:27:57','2026-09-28 08:38:29');
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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,1,'PAY-151F17E4E4',452.00,'CASH',1,'2026-09-24 09:34:05'),(2,2,'PAY-D8061853C2',100.00,'CASH',13,'2026-09-24 12:41:45'),(3,3,'PAY-753F584FB3',150.00,'CASH',1,'2026-09-25 06:21:06'),(4,4,'PAY-934DEEBCF4',500.00,'CASH',1,'2026-09-25 06:39:46'),(5,5,'PAY-64718625A6',495.00,'CASH',1,'2026-09-25 08:40:27'),(6,6,'PAY-EFE114D1C7',100.00,'CASH',14,'2026-09-25 09:31:04'),(7,7,'PAY-AE185FE2B4',100.00,'CASH',1,'2026-09-25 13:00:58'),(8,8,'PAY-2B5DC1E1C1',450.00,'CASH',1,'2026-09-25 13:50:59'),(9,9,'PAY-E87C4B4305',45.00,'CASH',1,'2026-09-25 15:57:11'),(10,10,'PAY-9E9F9A9EB9',500.00,'CASH',5,'2026-09-25 16:03:28'),(11,11,'PAY-FF50D798E7',1184.00,'CASH',5,'2026-09-28 02:36:11'),(12,12,'PAY-0F75B0E44F',20.00,'CASH',1,'2026-09-28 07:51:34'),(13,12,'PAY-63C0661DE6',30.00,'CASH',5,'2026-09-28 07:51:40'),(14,13,'PAY-2BE4650470',499.50,'CASH',5,'2026-09-28 10:15:05'),(15,14,'PAY-B7D2413EEB',25.00,'CASH',5,'2026-09-28 10:19:04'),(16,14,'PAY-5A79890166',25.00,'CASH',5,'2026-09-28 10:19:14'),(17,15,'PAY-ABCDECA675',25.00,'CASH',5,'2026-09-28 10:19:23'),(18,15,'PAY-AFFEDB4568',25.00,'CASH',5,'2026-09-28 10:19:27');
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,NULL,'001','covid-antidote','4001',50.000,'ACTIVE','2026-09-24 09:48:50','2026-09-24 09:48:50'),(2,NULL,'PROD-050','abietic-acid','100',300.000,'ACTIVE','2026-09-25 05:49:25','2026-09-25 05:49:25'),(5,NULL,'PROD-035','abacavir-sulfate','300',500.000,'ACTIVE','2026-09-25 06:08:21','2026-09-25 06:08:21'),(9,NULL,'PROD-031','abacavir-sulfate','300',500.000,'ACTIVE','2026-09-25 06:20:19','2026-09-25 06:20:19'),(10,NULL,'PROD-055','abietic-acid','300',50.000,'ACTIVE','2026-09-25 06:38:21','2026-09-25 06:38:21'),(11,NULL,'PROD-ABIETIC-ACID','abietic-acid','units',10.000,'ACTIVE','2026-09-25 07:41:27','2026-09-25 07:41:27'),(12,NULL,'PROD-ABACAVIR-SULFATE','abacavir-sulfate','units',10.000,'ACTIVE','2026-09-25 07:41:27','2026-09-25 07:41:27'),(13,NULL,'PROD-ACEDOBEN','Acedoben','units',10.000,'ACTIVE','2026-09-25 07:41:27','2026-09-25 07:41:27'),(14,NULL,'PROD-02','sulfate','45',50.000,'ACTIVE','2026-09-25 08:39:27','2026-09-25 08:39:27'),(15,NULL,'PROD-03','sulfate','46',0.003,'ACTIVE','2026-09-25 08:59:20','2026-09-25 08:59:20'),(16,NULL,'PROD-04','sulfate','47',30.000,'ACTIVE','2026-09-25 09:04:02','2026-09-25 09:04:02'),(23,NULL,'PROD-10','balmond','49',1.000,'ACTIVE','2026-09-25 12:15:49','2026-09-25 12:15:49'),(24,NULL,'PROD-06','serum','50',10.000,'ACTIVE','2026-09-25 12:59:32','2026-09-25 12:59:32'),(25,NULL,'003','acntrex','1',0.000,'ACTIVE','2026-09-28 03:22:25','2026-09-28 03:22:25'),(26,NULL,'004','acntrex','50',11.000,'ACTIVE','2026-09-28 03:25:17','2026-09-28 03:25:17');
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipts`
--

LOCK TABLES `receipts` WRITE;
/*!40000 ALTER TABLE `receipts` DISABLE KEYS */;
INSERT INTO `receipts` VALUES (1,'RCT-16F3A908EC',1,'2026-09-24 09:34:05'),(2,'RCT-A42BCE368E',2,'2026-09-24 12:41:45'),(3,'RCT-E2433902BB',3,'2026-09-25 06:21:06'),(4,'RCT-7EFF7663B6',4,'2026-09-25 06:39:46'),(5,'RCT-785FB99BF9',5,'2026-09-25 08:40:27'),(6,'RCT-E284622318',6,'2026-09-25 09:31:04'),(7,'RCT-A25D2A2001',7,'2026-09-25 13:00:58'),(8,'RCT-2161BF4A49',8,'2026-09-25 13:50:59'),(9,'RCT-266EE1B452',9,'2026-09-25 15:57:11'),(10,'RCT-3F3DA37621',10,'2026-09-25 16:03:28'),(11,'RCT-1963561034',11,'2026-09-28 02:36:11'),(12,'RCT-E3EE6C2BD3',13,'2026-09-28 07:51:40'),(13,'RCT-EC680B1E47',14,'2026-09-28 10:15:05'),(14,'RCT-48AF6CB4DF',16,'2026-09-28 10:19:14'),(15,'RCT-D43D2865C6',18,'2026-09-28 10:19:27');
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
INSERT INTO `service_required_products` VALUES (2,5,10.000),(20,2,5.000);
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
) ENGINE=InnoDB AUTO_INCREMENT=302 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_refresh_tokens`
--

LOCK TABLES `session_refresh_tokens` WRITE;
/*!40000 ALTER TABLE `session_refresh_tokens` DISABLE KEYS */;
INSERT INTO `session_refresh_tokens` VALUES (1,1,'69118e7f43409f51a557a655683d38bd2b97e4edcefa4065fe3203e154b583b1','2026-10-17 14:47:45',NULL,'2026-09-17 06:47:45'),(2,1,'ed1de73ab360668fff4a51f015c31ccf90c5da3f4b87fbd159a9bfa5d1165171','2026-10-17 14:49:39',NULL,'2026-09-17 06:49:39'),(3,1,'4f128714e33c9be4ac39bce2be39d6a2bff92758ff6fb7264bf0e9158ba44321','2026-10-17 15:04:48',NULL,'2026-09-17 07:04:48'),(4,1,'402a51c23d4d95e321527d5ea0129607d86f8f8d48531fa7118fbebcfcdbaa76','2026-10-17 15:38:52',NULL,'2026-09-17 07:38:52'),(5,1,'82d2b9af38a38670037a893696cc9b581dd0d2fa3bb98a4a8b399d339dfb8bd8','2026-10-17 15:39:11',NULL,'2026-09-17 07:39:11'),(6,1,'f334b1183c35b48107b29670646743db7cee90f720d42d12723d8fa21456025e','2026-10-17 15:48:15',NULL,'2026-09-17 07:48:15'),(7,1,'edaf526189f7c94cf3236826c16bdf6ca887055d79ed80cf25b089ca9c0f948c','2026-10-17 16:01:05',NULL,'2026-09-17 08:01:05'),(8,2,'3e84e909101a1ebe57ad1f789b1094343d6b1ba6c9d38d211cdacb4aa0e28dae','2026-10-17 16:05:10',NULL,'2026-09-17 08:05:10'),(9,3,'e76f470dfe4265662b3f32f8d4d1b60ca47d032fc2c127a8370c6dff2ae60c50','2026-10-17 16:05:10',NULL,'2026-09-17 08:05:10'),(10,4,'d9c244d28f300b9a66c4947c364b3533ee3644a3cf3bdfedbcbc4076c6c75e4a','2026-10-17 16:05:11',NULL,'2026-09-17 08:05:11'),(11,5,'ab5277fb0fd17e309614c5b9f59d9dc9cde2390b272e194347f102083b1d5b11','2026-10-17 16:05:11',NULL,'2026-09-17 08:05:11'),(12,6,'788da21e71bfd868b00742c6121444a75435d107a54a70a0406f4baee7ed3469','2026-10-17 16:05:11',NULL,'2026-09-17 08:05:11'),(13,1,'4d5d90fce479da5de3fe562451597832e820129f85f3e08a2402fbe385f601e8','2026-10-17 16:08:19',NULL,'2026-09-17 08:08:19'),(14,2,'0f7e5b43922ea7cda264d39a906f023abc6e8f74f18d8b62b567cf5a157ec3ab','2026-10-17 16:08:26',NULL,'2026-09-17 08:08:26'),(15,3,'4a90c5cc4c6f56fb1cac3db44269993f3faeb486ddcfcd85bd8b601eb5f2d479','2026-10-17 16:08:38',NULL,'2026-09-17 08:08:38'),(16,5,'3495f232c3c1cc6533b81057daafe89853cd35a9a8abe7392e657dc60a218ccc','2026-10-17 16:09:56',NULL,'2026-09-17 08:09:56'),(17,1,'0a3370008468c1ea1bf008d24de64e1166c3b82e6f2b1e742c357f57af107c06','2026-10-21 14:07:54',NULL,'2026-09-21 06:07:54'),(18,2,'3fa26a2016cbb4436df3f8f16f11ee2fa442728a618b0476131b2c73973cc613','2026-10-21 14:28:15',NULL,'2026-09-21 06:28:15'),(19,1,'7f2cb660ffb850a1bdd397c0701faaf278bf9790c0e16a59a30c2fbc72fc48b4','2026-10-22 10:15:34',NULL,'2026-09-22 02:15:34'),(20,2,'7e123616d0d6276e52415dcaddf84b48bfe56abf732438f7aa8c49c179b08258','2026-10-22 10:15:35',NULL,'2026-09-22 02:15:35'),(21,3,'202691e6483e91068166c1f958eb15e698467bd4fc6741038fad9c84c6cecf43','2026-10-22 10:15:35',NULL,'2026-09-22 02:15:35'),(22,4,'1dd3e4c1a3aac5521fe72d4d71f0a2701b1d34d2bc65108be62f7d9ce3912069','2026-10-22 10:15:35',NULL,'2026-09-22 02:15:35'),(23,5,'02bba2305acceae76781054d4e14a184358bac251cf0da6af564fa1c1d0fa656','2026-10-22 10:15:35',NULL,'2026-09-22 02:15:35'),(24,6,'3d5c7968ac494017c0714a4eae9d9c31a376c4a21d3451cb605c9872a13bbf68','2026-10-22 10:15:35',NULL,'2026-09-22 02:15:35'),(25,1,'e4857037d57524fe5e55bbc3ed403f45d7d08f86f0d19820a772e7c9d531520c','2026-10-22 10:15:45',NULL,'2026-09-22 02:15:45'),(26,1,'f14c25b5c6c2dd23a471d3b3c711c0d46523b6d475d3ce83303ba86d6b7c7356','2026-10-22 10:19:21',NULL,'2026-09-22 02:19:21'),(27,1,'5f701e4aaa5a1181419588535fe4cff98270f1e8d8cd45b6ec9d670b66674e75','2026-10-22 10:19:57',NULL,'2026-09-22 02:19:57'),(28,2,'0b7f75aa4ea96840142ef827f322508206892db66205c4868d7917950d1f9fb1','2026-10-22 10:20:26',NULL,'2026-09-22 02:20:26'),(29,3,'be866975a7c34f99aa3d319fa4897c6006991c13be88bf2a609b95c4aa56be46','2026-10-22 10:20:37',NULL,'2026-09-22 02:20:37'),(30,4,'3b21522336b1b7a8db1fb8dc9dae678e6206ff0a0b150170a1dd4ee5bf148f2d','2026-10-22 10:20:44',NULL,'2026-09-22 02:20:44'),(31,5,'360557cc028781a6d42e0aa18b4ed8409a9cefd2d4aeee3a8b207da7ee3a0ca8','2026-10-22 10:20:51',NULL,'2026-09-22 02:20:51'),(32,6,'204b0b91c2396acedbadad1ae155790b21ceb77b4f40df12bcf7dd0bedef6595','2026-10-22 10:20:56',NULL,'2026-09-22 02:20:56'),(33,1,'09571f4b48e7cce62d113cfc290e9f82ae65092e31f5ed19c9ff98324b5338b4','2026-10-22 10:53:42',NULL,'2026-09-22 02:53:42'),(34,1,'d8ff9cebf380566e42566c095d1bcfb68598012958621a98697bc50246ffd76d','2026-10-22 10:57:35',NULL,'2026-09-22 02:57:35'),(35,2,'9f9646e482b96caf18129fac2ae93ea76f2d8fa8df732096cfac3619492dadbd','2026-10-22 11:04:57',NULL,'2026-09-22 03:04:57'),(36,1,'c442af625a3f44777c148db2dfeb2d0726ffa760e04d9ebbf8dc97f8961c0650','2026-10-22 11:12:07',NULL,'2026-09-22 03:12:07'),(37,1,'6ed1f128d41589bf3566ec972cff774b61bf82ba7384e06d9f64816544ceb77e','2026-10-24 02:49:48',NULL,'2026-09-23 18:49:48'),(38,1,'b0569111dde6b47bf21b0ff7282255d61e10f4f77761684429f7d77291723134','2026-10-24 02:50:16',NULL,'2026-09-23 18:50:16'),(39,1,'2264a9333c51b8725ce2f5417020667174d0c14af4926add037d33e7e6f7248b','2026-10-24 03:05:18',NULL,'2026-09-23 19:05:18'),(40,1,'ac31903c76557546355fa609a879f966f9015b9743d802ec74245f8f02cc0b4e','2026-10-24 03:06:04',NULL,'2026-09-23 19:06:04'),(41,1,'df8048476d29b7f87dbdbeb4f17d4f892143451d455ddd5cac3d09b65cdc6bfb','2026-10-24 03:21:13',NULL,'2026-09-23 19:21:13'),(42,1,'51167966940c47a8e81955e3135e5fb0fbf32225a9d84d8543cd678d84b067d8','2026-10-24 04:03:31',NULL,'2026-09-23 20:03:31'),(43,1,'50c562c1834330db2cc887a8bd497354e4f1d4cae78605d0ba71404977784a2e','2026-10-24 04:05:12',NULL,'2026-09-23 20:05:12'),(44,1,'71b017645bda8ea43551e3b6b41f1bdbcbff82f5996df22aa1b4cc55c96f4080','2026-10-24 04:06:31',NULL,'2026-09-23 20:06:31'),(45,1,'b9727543c2f80e8967f31cc74887fcf88994f1973baca5fb1c7920169a402853','2026-10-24 04:09:31',NULL,'2026-09-23 20:09:31'),(46,1,'07550cc458b55686d51abc8307a3460432a04f00cd37f3fbc0fafd75be66fb8e','2026-10-24 04:14:18',NULL,'2026-09-23 20:14:18'),(47,1,'890da4d9d7602017403b53e23d73f3399d2df0c18363e2b8a9c718c7931bfb12','2026-10-24 04:29:26',NULL,'2026-09-23 20:29:26'),(48,1,'e64aa47f3a23d856d7a0116fa8bbb427582c3958ea78470d2df76788157ce80e','2026-10-24 04:34:58',NULL,'2026-09-23 20:34:58'),(49,1,'9961941e71ec31bf7230e31d04b0062fd1e666f1e4df9181664846d95d8be899','2026-10-24 04:37:01',NULL,'2026-09-23 20:37:01'),(50,1,'0f99422033e0c2a3362841fd6b2729c29934c75ff927fbd56ee3b1749c60b77b','2026-10-24 04:38:25',NULL,'2026-09-23 20:38:25'),(51,2,'13cb647c2097acda0a126b8acc0e7b7c07dc59b74b0b3591cf2f4848867649c7','2026-10-24 04:39:37',NULL,'2026-09-23 20:39:37'),(52,6,'16c0018d7332a0d57fcd11f1745069e1efc334575429873e96575cb972b03dd9','2026-10-24 04:39:49',NULL,'2026-09-23 20:39:49'),(53,1,'490ce81c2153291dcc7389e77a660f7095de51c11a853b1c8104546996c11d99','2026-10-24 04:39:59',NULL,'2026-09-23 20:39:59'),(54,1,'f5fc1682fc9f0fd3b21914c43b96ccfffbca4574420f72dc560cc12e29c70601','2026-10-24 04:48:22',NULL,'2026-09-23 20:48:22'),(55,1,'17945e7f01cb3c677122ddafeabdf3187713836f16ede0d9f7d4dd35fbd43fdc','2026-10-24 04:49:29',NULL,'2026-09-23 20:49:29'),(56,1,'dbf6ea9f1c2a2de360e4bc9c056a038d4daf208623fcec39421ae0c1be135692','2026-10-24 04:50:44',NULL,'2026-09-23 20:50:44'),(57,1,'c45605c7e086ae52911e060a81845554ef990154d4f16172f13cddb27601da5e','2026-10-24 05:01:45',NULL,'2026-09-23 21:01:45'),(58,1,'e4b649f6d48291fb228566f416c4e1d88733c2709893fa88baff07f4956821ef','2026-10-24 05:02:27',NULL,'2026-09-23 21:02:27'),(59,1,'8f49b572a866feea1486d4efa9e00dee44f566ad0da988524153d5a1ee791208','2026-10-24 05:07:57',NULL,'2026-09-23 21:07:57'),(60,1,'6c48a743fec06b625fe20558c878f6d8a8aa1d55eb49c1d75ec45eeef07f9c63','2026-10-24 05:20:52',NULL,'2026-09-23 21:20:52'),(61,1,'5e26e771ae8323dbf1b5ccdc675b5312a375f2e180a9be93238499fa61edae8e','2026-10-24 05:43:25',NULL,'2026-09-23 21:43:25'),(62,1,'2fb2234dc7fd788bf13cb0f6973196c2cb162065e63be82b0a385d9b993a33cf','2026-10-24 05:47:34',NULL,'2026-09-23 21:47:34'),(63,1,'645b3618c0d9b9df6c7fca57384fce3c845693ade6a9f961140f075240954297','2026-10-24 05:58:53',NULL,'2026-09-23 21:58:53'),(64,1,'d37a5d180edf0997f716f5f176ba4d36e434eb2311a38ff0b8ea1ed8898720b3','2026-10-24 05:59:44',NULL,'2026-09-23 21:59:44'),(65,1,'494a080964a87b47d10d93b4e1a953c7d3876d5676924491617fe2f5efc90c86','2026-10-24 06:10:41',NULL,'2026-09-23 22:10:41'),(66,1,'b6dd27ec3d7622e69055e4f98a9999c6baca41e0427e8b4ee6e786e884579336','2026-10-24 06:14:10',NULL,'2026-09-23 22:14:10'),(67,1,'099e7ae6a96166193ddfc7beb7205d671e84dd6e85a5117672e54462aeb0ce76','2026-10-24 06:15:46',NULL,'2026-09-23 22:15:46'),(68,1,'c059c4c0ee9b5c699ad1fa0ffb68607fe6b28bb445423930b38dab01af53e60c','2026-10-24 06:24:38',NULL,'2026-09-23 22:24:38'),(69,1,'bde8b402e43f3ff751ef105eb76572a2c7627fe8d567647537b93eeb96cb5cfe','2026-10-24 06:32:08',NULL,'2026-09-23 22:32:08'),(70,1,'b05e31278ff72610cdc1afbde7940301ce8aa37424f0008c47c76f7a1453cc77','2026-10-24 06:32:33',NULL,'2026-09-23 22:32:33'),(71,1,'243868216c8b16a821fc90bdd159e1a73f687faf667f3ec53a9a4584faf6c239','2026-10-24 06:37:44',NULL,'2026-09-23 22:37:44'),(72,1,'6a22729e6ede4aa8f7ce22bfa3ee55ccd863870b8423c2d567f81490225a4d57','2026-10-24 06:39:24',NULL,'2026-09-23 22:39:24'),(73,1,'305fba50e8fa033fff818a0c9676434a475a3ca19786cab3dd6de29ab64d217a','2026-10-24 06:43:22',NULL,'2026-09-23 22:43:22'),(74,1,'8241a484fe655864ea75c770b9460f8e30262be8c1aaaffba1455b910a6ee7d7','2026-10-24 06:44:23',NULL,'2026-09-23 22:44:23'),(75,1,'8f88fff21fd215bf2befea4c21c780d819504e43db4ea4a17ddeaff4c5ce41b1','2026-10-24 06:48:11',NULL,'2026-09-23 22:48:11'),(76,1,'85921b2ef7946f907e892f28daea2138d2946e5ef26126c3fae24eed261b36f8','2026-10-24 06:48:43',NULL,'2026-09-23 22:48:43'),(77,1,'e31fed1e6dfc35989a63eebb6049801c90503bb011d0d5d1f2f669aa7e7a75bb','2026-10-24 07:16:03',NULL,'2026-09-23 23:16:03'),(78,1,'4341fe4f57ec2e3f26caf2cf3ab96555a3f193f5667f38eabb5ec63e85bc02e6','2026-10-24 07:19:24',NULL,'2026-09-23 23:19:24'),(79,10,'baf558647c9cb5ec4bbe637932e4db21c21e9b15497d1fdd916c97fad6e254a4','2026-10-24 07:23:14',NULL,'2026-09-23 23:23:14'),(80,10,'a35392fdf226066d6d259cfdacbc5cf4fe62220704ec9106dc9d9feb6046d4e6','2026-10-24 07:23:35',NULL,'2026-09-23 23:23:35'),(81,1,'6e17d41d8396eb05a671d46cea2b8f57b9bda50ad99ef2f4ccb63f063e314351','2026-10-24 07:24:55',NULL,'2026-09-23 23:24:55'),(82,1,'cfbb4b67c712fd1e3acee2604c7a3ee49a91ec7b8ccb3e0947351edb42e913e6','2026-10-24 07:28:34',NULL,'2026-09-23 23:28:34'),(83,1,'679190fb2af9d051af1ddc4a676422d0ee6562e6310319c98722dfc8c3d0d110','2026-10-24 08:12:23',NULL,'2026-09-24 00:12:23'),(84,3,'0cd1104b86cbe8b69342ce1f50639e0e65a0be701c951771cc8001a0dd9b3196','2026-10-24 08:39:21',NULL,'2026-09-24 00:39:21'),(85,3,'7d255499ec60b33b18f79e8ef51a525699fe9c07c0bb498725876cacc19e2027','2026-10-24 08:43:54',NULL,'2026-09-24 00:43:54'),(86,3,'19ee2a42189c4373d022bd141c816b44a5de7179471778528d54621e1d2e9cd0','2026-10-24 08:50:31',NULL,'2026-09-24 00:50:31'),(87,3,'8416a0d1f0a022514ab752e4cd01c5b6112c5620b307d69ae8bc4a0647374620','2026-10-24 08:59:26',NULL,'2026-09-24 00:59:26'),(88,1,'cd71b599fc5a92b21b65c49d532caaafb7702e6f206dbcef3e969235eee69811','2026-10-24 09:00:38',NULL,'2026-09-24 01:00:38'),(89,1,'4e873a69b1b077986999114f9650c6ad0f3014de3a7ce2bb452c8dfe8e24fb69','2026-10-24 09:09:50',NULL,'2026-09-24 01:09:50'),(90,1,'249a30f3706b204ab76ed1cf1dca5c0998bece7a609072e667c8d7a7350a8d22','2026-10-24 09:17:03',NULL,'2026-09-24 01:17:03'),(91,1,'3b25e06ecf1e02a5f3493b3552bd389ae3daf218c37b47ed74b072b1f30a5616','2026-10-24 09:25:38',NULL,'2026-09-24 01:25:38'),(92,1,'d7ed2787ccda8ed8c659618787eb9690ff6548295dbfc417de83836a468f36e6','2026-10-24 09:37:35',NULL,'2026-09-24 01:37:35'),(93,6,'575b842a2476525239c212ba4154963fa0289dfd0bb767bee4921241288bfd22','2026-10-24 09:38:07',NULL,'2026-09-24 01:38:07'),(94,1,'bac87c662ba27af05bbae117ada065e22c39893db574367b74f0725bdb60014f','2026-10-24 09:40:37',NULL,'2026-09-24 01:40:37'),(95,1,'7ac6c2606b45a2972830672b1dcbb2a0cbc20fc47fb4c8e174ae2315161d49d2','2026-10-24 09:43:51',NULL,'2026-09-24 01:43:51'),(96,13,'5e6ce431e8e73d5eabc9aa4c022b552d1e8d6f0973b9c6a99798309671fcac4d','2026-10-24 09:50:23',NULL,'2026-09-24 01:50:23'),(97,13,'4f3761fbc82ec75c934ad83cfccc400d24087cfe114120815448bace49f68e18','2026-10-24 10:14:31',NULL,'2026-09-24 02:14:31'),(98,1,'e2a0f2eaf60b8cc7168eae27b40798d135a7458c26dd272f3a4c443a1666837f','2026-10-24 10:24:16',NULL,'2026-09-24 02:24:16'),(99,1,'ac3211cd9a50a9a5bd17b478436e9d4d0b76eb3d5a187dd5fb868670dbcc9369','2026-10-24 10:24:59',NULL,'2026-09-24 02:24:59'),(100,1,'e466914775e05fff3144d9e483d428e620ebceccef76d1db875f02fbee845514','2026-10-24 10:25:13',NULL,'2026-09-24 02:25:13'),(101,1,'1191223563ed16039aad414d3ad246e84615df8914c2f59beea556a0fa4c45ec','2026-10-24 10:25:47',NULL,'2026-09-24 02:25:47'),(102,1,'e4a0887a36ae8f08f9df266f95caa4de6996356f1d315e843710d722e263e913','2026-10-24 10:29:09',NULL,'2026-09-24 02:29:09'),(103,13,'3577ddc0b72d602a0eb217101baf6cb5be2012e790be30608f2a3e0a74343183','2026-10-24 10:43:48',NULL,'2026-09-24 02:43:48'),(104,13,'d5542b9b5bd4b806f1bcd273463fd0b4158b968e32212c5623883fbe13f87623','2026-10-24 11:00:01',NULL,'2026-09-24 03:00:01'),(105,13,'8bafa9eb232898f6451b8eafa98fabedc09d213c74cbc4af4d1a8cb32aadfbc8','2026-10-24 11:11:24',NULL,'2026-09-24 03:11:24'),(106,13,'493fc141812b2ddd8bfea913c727e8f2afa2a1bce6108eed494a7d6da09ce7ca','2026-10-24 11:19:49',NULL,'2026-09-24 03:19:49'),(107,13,'9287e4fe681d467ce600428191004e9abe7e227a17e082c2a14780e1a5ee8722','2026-10-24 11:28:34',NULL,'2026-09-24 03:28:34'),(108,13,'71b8499e16177c3b0e397d4fe871cff2c180434e282f993ebec2f2c811517785','2026-10-24 11:33:39',NULL,'2026-09-24 03:33:39'),(109,13,'c74d4f84b1c067286e1c61fcd13930afa69463960e94d4d2401d510b324f492f','2026-10-24 12:14:28',NULL,'2026-09-24 04:14:28'),(110,13,'aca8930841dc14de55db815173048b754decd5c3dc1ab904c79a2459a167d039','2026-10-24 12:19:40',NULL,'2026-09-24 04:19:40'),(111,13,'ee5089e972ee208e1c612865dd771db92492b9496e8dff6cc0537e07514be8a7','2026-10-24 12:37:11',NULL,'2026-09-24 04:37:11'),(112,13,'c96bad2780308179a8ded3e47fb0e4a9127ed5a40a2b3d7bb35ff938b00650af','2026-10-24 12:42:15',NULL,'2026-09-24 04:42:15'),(113,3,'8f23a463a4ba42754e4711da07276573a3341b968427d28f6a7ea984b889a712','2026-10-25 05:33:48',NULL,'2026-09-24 21:33:48'),(114,1,'6fb905188ede21f3d384a82e3d01e57c4b93f95d63b69b46f7755b9f7f3c9e1a','2026-10-25 05:40:17',NULL,'2026-09-24 21:40:17'),(115,3,'a4d061012c0528bb90c33f0888e8289ee0a55d2ea29859afcde184609c5c28fc','2026-10-25 05:40:44',NULL,'2026-09-24 21:40:44'),(116,2,'0a57059ea573c4b6cd304ef861417db8a1cd49c48102692607c01ebb2d22ef9b','2026-10-25 05:42:03',NULL,'2026-09-24 21:42:03'),(117,6,'57441f533d52ae0e9120c74af6ef8bb8e28ab358024d350f16c96a520440e8a6','2026-10-25 05:43:00',NULL,'2026-09-24 21:43:00'),(118,6,'6d1f84bc200aa937137d4550f4c9822f6b6c1d88bba51c7f39bb9ed183592fdb','2026-10-25 05:48:10',NULL,'2026-09-24 21:48:10'),(119,6,'03e602b1562d344916f9369a4816c0dbe60de3a371641f14f0854cd70a5cc702','2026-10-25 05:58:59',NULL,'2026-09-24 21:58:59'),(120,6,'d8e16f9503ba37636a80dae903b2e3b094e4a2fdc7adca16dc27972b14ab72a7','2026-10-25 06:06:45',NULL,'2026-09-24 22:06:45'),(121,5,'e01e395b91dbdd8f8ed02e0baed3117319881b113e5c89cffb75303a88fc7146','2026-10-25 06:12:23',NULL,'2026-09-24 22:12:23'),(122,3,'74577b07430777f4e7f48f154acf50a58e44ccab9539b9d66b4b4983e4216d12','2026-10-25 06:16:53',NULL,'2026-09-24 22:16:53'),(123,1,'942711c5eb7b1637bd7a72d428d08a37e0aed82b4281f2daefcceb696d203cc9','2026-10-25 06:18:28',NULL,'2026-09-24 22:18:28'),(124,1,'2d4112c5501a1ec9c8170cee75bd9c8662763ebd773572b53fc601bc5cbc1207','2026-10-25 06:27:39',NULL,'2026-09-24 22:27:39'),(125,1,'3b33f35fce41990590a294967747d22b229758c4b9309be7c2595934aa8084c8','2026-10-25 06:27:44',NULL,'2026-09-24 22:27:44'),(126,1,'68ef6bdc1e43939eb6e914047ba361acb295a7999ab874235a8e635bb5a6bfec','2026-10-25 06:29:59',NULL,'2026-09-24 22:29:59'),(127,1,'1c27d0b2b6b66835b5d51e61452e52ee89ccc16b7bf1af374b0f8897e91a6fa5','2026-10-25 06:34:29',NULL,'2026-09-24 22:34:29'),(128,1,'b4584f5304f7cc3cec2b9a3733aa4dd05f9d92bde4a33a02f9933efbfa477988','2026-10-25 06:35:41',NULL,'2026-09-24 22:35:41'),(129,1,'2ab1f4292118fe200727f9fa6a33dbae1b04bc7b2004e93cfaeb03ec5f2c0dd4','2026-10-25 06:35:53',NULL,'2026-09-24 22:35:53'),(130,1,'974b4fddb14b1b926e346fa8aa3f5eadf8be08e39d0c55f4fd0a8903af5734fb','2026-10-25 06:42:55',NULL,'2026-09-24 22:42:55'),(131,13,'9b8dc1eaee87fd345cedbe645e9ba026b677a48f23da070cbb556779c241f99c','2026-10-25 06:43:35',NULL,'2026-09-24 22:43:35'),(132,13,'e5d05827f2b3aa0c5bba5085e7071706d7ec4209193b8580350f0a56b9818090','2026-10-25 06:46:27',NULL,'2026-09-24 22:46:27'),(133,1,'2436e45570b6764d5096cafb6144ae1674d707a0e4c28215a1e5238eada3e0a4','2026-10-25 06:46:53',NULL,'2026-09-24 22:46:53'),(134,5,'15dd1490fcacfec70bba6bb1de3818907eecca4e9b615e1ed12a13aa61007e80','2026-10-25 06:47:22',NULL,'2026-09-24 22:47:22'),(135,1,'44cbbb14925563ce0b0a9866293beb7451e62259ee27467d37a2c35a0e5623f9','2026-10-25 07:42:29',NULL,'2026-09-24 23:42:29'),(136,5,'0c740f9dea6272d22f0c7a11d629356581a85b92c05ea437928350630a9178e5','2026-10-25 07:48:26',NULL,'2026-09-24 23:48:26'),(137,6,'91d74406b95d3fb38c8a8073747b1ff5c587481c9eaf17bd6ae1865d4a83912c','2026-10-25 07:48:57',NULL,'2026-09-24 23:48:57'),(138,1,'2ff47fe8f693ebde18297d86534bb79f868b31b1cec35168d42a329862d8ad52','2026-10-25 07:50:10',NULL,'2026-09-24 23:50:10'),(139,1,'909aed09202e49b2a684c3c9a02ed3d487d8beaa954d70be31065ea253d11d1b','2026-10-25 07:51:58',NULL,'2026-09-24 23:51:58'),(140,1,'fabe0727fb05710c7b6a9de5c2196fb5baff733b18011bf995be571bac5e973a','2026-10-25 08:14:04',NULL,'2026-09-25 00:14:04'),(141,1,'8728781350988e723f7ab7e49d68e5c23a7323abd7b3f47ba1a0e2c517285ce2','2026-10-25 08:14:05',NULL,'2026-09-25 00:14:05'),(142,1,'5589d9a44c8cd9a7b3771b783a1e21383dd2784c2050b7935778b8f91229402d','2026-10-25 08:16:46',NULL,'2026-09-25 00:16:46'),(143,1,'39268afe574c15fa1e4d916656997fefe01738ca82120999d7540504af4a45c5','2026-10-25 08:16:55',NULL,'2026-09-25 00:16:55'),(144,13,'428f5ab4485a56f7036a2c8907d7e5f31aad4e4825225fa1b956a25f247f703d','2026-10-25 08:20:08',NULL,'2026-09-25 00:20:08'),(145,13,'753e82941cdb8efd17991fe05c20fd4455728277cd9484c614d9db5e6949d5b6','2026-10-25 08:20:53',NULL,'2026-09-25 00:20:53'),(146,1,'1c9aff18cf43c9a885ce1b5f5634150574f19d024f3ecfd6c2dc676103c6afbd','2026-10-25 08:21:05',NULL,'2026-09-25 00:21:05'),(147,1,'7393d564d0b92cd2e0b5b81d3cc399e35f81a25b56418f2d40549cacfcb06b2d','2026-10-25 08:36:32',NULL,'2026-09-25 00:36:32'),(148,14,'e55415712a1508e2cdebb2cba8f5471ce8aaaf2d4d69f926bea5ddbc6d0fb76e','2026-10-25 08:41:16',NULL,'2026-09-25 00:41:16'),(149,2,'12352b99ed565128899d3840e8cbe9b50bbee8efae69efdb29de84ee69333c0b','2026-10-25 08:41:57',NULL,'2026-09-25 00:41:57'),(150,3,'fc1c5f570f9aecef0ffa8f0b72c9958088602ab2ae1487dcd475f52dd0d5ef20','2026-10-25 08:42:50',NULL,'2026-09-25 00:42:50'),(151,2,'a94563889210341d62895f5c7b699a5b728090cb2b32f738234414cad2ec07de','2026-10-25 08:43:32',NULL,'2026-09-25 00:43:32'),(152,3,'e35071539068d5cb4f3356e2d499a15950aeef84066362971a640c883a46a841','2026-10-25 08:48:16',NULL,'2026-09-25 00:48:16'),(153,14,'4703702537d7add4ef118c6e58ee57b2c5261fa41cff0d55c8125a1316cd6077','2026-10-25 08:48:47',NULL,'2026-09-25 00:48:47'),(154,3,'ab36ae5aa8cea1f192942729fcaedf1a09b35f7e0cf1d80fd05aba14f35b3639','2026-10-25 08:49:18',NULL,'2026-09-25 00:49:18'),(155,4,'fcda7c8618e35131a8cb12d00257edc1616b027a49385fc0a32e609601b19af1','2026-10-25 08:54:01',NULL,'2026-09-25 00:54:01'),(156,5,'22580aeab6289334a64edd04a88229be88879ee715700c19f82602491b15a54e','2026-10-25 08:55:27',NULL,'2026-09-25 00:55:27'),(157,5,'fe28c6b1e3dd9fb462b374d229e0d8f698fdb93ad90a782459efdc6076b02c8b','2026-10-25 08:56:27',NULL,'2026-09-25 00:56:27'),(158,6,'ba68c1e298f268a5f829b095b2ddd82e8fe16b3ccc288487c732d79163b5e11c','2026-10-25 08:57:50',NULL,'2026-09-25 00:57:50'),(159,6,'5f1ca187f92295bd46be3fe77dee415a66ee8e4e5a995b3e55b9a284e2ae55f2','2026-10-25 08:58:24',NULL,'2026-09-25 00:58:24'),(160,6,'346a7a8b2ad630edfefa1736b18c3c30484ea76b34cae02696b57f950d96af0f','2026-10-25 09:03:28',NULL,'2026-09-25 01:03:28'),(161,2,'8e96afe800cf076fa532dc1876ff1396ae49ca5c138655fe4e64527904f24a2f','2026-10-25 09:04:12',NULL,'2026-09-25 01:04:12'),(162,3,'c3eb60137c61665789981a5ab4ae7899510705bb96e7badd59c9160859810394','2026-10-25 09:04:13',NULL,'2026-09-25 01:04:13'),(163,4,'1d0e68976ab26fb9c127c4f5e5bcfe53c241b1831762af24c56f24160169ff87','2026-10-25 09:04:13',NULL,'2026-09-25 01:04:13'),(164,5,'e63bfa44107f4b4cb650ec0d8cdb0917fac58c549e4c9692015651d40737f426','2026-10-25 09:04:14',NULL,'2026-09-25 01:04:14'),(165,2,'fabc287e1748176042bfcd877caafa4e9e4d04727d2f75ae2b726e744c62f2fb','2026-10-25 09:09:14',NULL,'2026-09-25 01:09:14'),(166,6,'14a64446cd63859d160d13f159ecbffaf39af06b961a5c4d3845140c635cf035','2026-10-25 09:27:54',NULL,'2026-09-25 01:27:54'),(167,1,'78fc456a1b518bdd11db2b2cad96f899bde32a2c230d41436716cba0b30e699a','2026-10-25 09:28:07',NULL,'2026-09-25 01:28:07'),(168,14,'352dc092c445dbc89ba8c99cc8ee6a8a5ea399c401716480597cc80c44474d7b','2026-10-25 09:28:29',NULL,'2026-09-25 01:28:29'),(169,1,'1aa163bfda54a03b4879f18f3d48cfe7e4ab653126dce99f1e7012dc66efcbf3','2026-10-25 12:14:30',NULL,'2026-09-25 04:14:30'),(170,1,'017f639580d4a2e9cf5952f9010f6fed3d4570f16b56798c3f4706092c7cef52','2026-10-25 12:32:13',NULL,'2026-09-25 04:32:13'),(171,1,'7ba0b39aa3deb41dab33867ef46b9875383c808c29347fa51b0b6cf2ca2cf382','2026-10-25 12:36:24',NULL,'2026-09-25 04:36:24'),(172,1,'56ca0035b36b8f3252b0e4d6b8216322eb3d0ae305e6c46668ca8bae978745b9','2026-10-25 12:36:30',NULL,'2026-09-25 04:36:30'),(173,1,'3d2f5e0e1f8e8fde63a040c022a710c2ca1e3cb2b90cdaf736196f204e5e4021','2026-10-25 12:47:41',NULL,'2026-09-25 04:47:41'),(174,1,'effeabd81e5517b63b1454656f2f2a9ba6f62943ad6c1333dda9de45a3af8d39','2026-10-25 12:49:49',NULL,'2026-09-25 04:49:49'),(175,1,'32dcc8565eaaaa929f5467be49d62a4cca3327604a954b92672c1e024df65ff5','2026-10-25 12:58:39',NULL,'2026-09-25 04:58:39'),(176,1,'8b2ee29d3dc186085385741751ba653a150fc127373aefac5e295f646365f094','2026-10-25 13:07:21','2026-09-25 13:07:21','2026-09-25 05:07:21'),(177,1,'55b7f853741095d42e988c3f5a94c0389413ac0ca125a54882a75e19d12fdf50','2026-10-25 13:07:21',NULL,'2026-09-25 05:07:21'),(178,1,'436ecf7cd9f369b23857afd9ffe0e5f9b71a7a0de5a8974d144c500729c9d1b8','2026-10-25 13:46:30',NULL,'2026-09-25 05:46:30'),(179,1,'d00ea3acfd6e3aa6de0120cf23f4dea10f656bd3074e83c351a85a56d6a51208','2026-10-25 13:53:08',NULL,'2026-09-25 05:53:08'),(180,2,'3d76f77d951fd09d7252d2b1d47036b9a6605c0f1eaa6b5e1cf8cab2c2ce495d','2026-10-25 14:03:14',NULL,'2026-09-25 06:03:14'),(181,3,'1d3455a077c2920ca14c0f12254983c3d78484625895b5068a01e6e9c043f8af','2026-10-25 14:10:38',NULL,'2026-09-25 06:10:38'),(182,4,'3e0ec4556ef8d44781f5941d6d9f1b3d03c69337d0cf8741704eac27900301a0','2026-10-25 14:14:36',NULL,'2026-09-25 06:14:36'),(183,5,'705f6324d2928e6d5e45c2c724216c2fd76fc5090d6e92222dcd200ad5f55f26','2026-10-25 14:22:24',NULL,'2026-09-25 06:22:24'),(184,5,'5e008d1bb3344cb114601a0bf74be911f8a15aae617784e1e45f0f77dd8aa9b7','2026-10-25 14:27:42',NULL,'2026-09-25 06:27:42'),(185,6,'9fe1efa6edff567ca4976799edaab9d981708e70698ee6ed6a5246e76b3249b3','2026-10-25 14:30:15',NULL,'2026-09-25 06:30:15'),(186,3,'0ae4cc06a75259fac1914af3126e9d5b3e2716a1447218050d3688ee95f78d21','2026-10-25 14:38:41',NULL,'2026-09-25 06:38:41'),(187,4,'8cd2b691071654b199679c71c8f792cc5baa8be5125fb54c4b4654dcc68bf445','2026-10-25 14:38:51',NULL,'2026-09-25 06:38:51'),(188,2,'b3c9ca83fec442a4afa3fd8d8c7e8503cc92198099c14380b7c9f9517fb43a52','2026-10-25 14:40:02',NULL,'2026-09-25 06:40:02'),(189,3,'c5bf6356567c9eca11a438ea751e8e66f6e1808a445c1a2895a8f4031d1b4a93','2026-10-25 14:40:02',NULL,'2026-09-25 06:40:02'),(190,5,'3994d0e6316f89146ec128283754ad6946997a6600d40ee266d14b350ab68fcc','2026-10-25 14:40:03',NULL,'2026-09-25 06:40:03'),(191,1,'1f1a8b252dcd6a09821c3210576a4ba4dae79b114a26d7b924088ee8a1f785d5','2026-10-25 14:40:14',NULL,'2026-09-25 06:40:14'),(192,2,'ac2e63339f098cfde0f737dce87735b84e57b5c7810ce3c8dde3360df0cb64c7','2026-10-25 14:42:51',NULL,'2026-09-25 06:42:51'),(193,3,'bfb6b0780d40803edb3232cfae66ebdbf576fe65a803abcb8547d4ab4db51860','2026-10-25 14:42:52',NULL,'2026-09-25 06:42:52'),(194,5,'73472160f0f40323d477c3c468d8fce88c091c4d1dfc266779585babdae5a0f9','2026-10-25 14:42:52',NULL,'2026-09-25 06:42:52'),(195,5,'3882fd66b2e06a1d39352b50dc1824b821d48c3d82da9b127fdfd916841d1236','2026-10-25 14:43:02',NULL,'2026-09-25 06:43:02'),(196,4,'1d6dd2b1226acddd585d68a9e6b3b9a7fcf5cd28c22bd20c993c63cb6b8efcd6','2026-10-25 15:54:02',NULL,'2026-09-25 07:54:02'),(197,1,'7d1d851f778d12a39329acedaa1c1dda2266b59011945d44cdc4ec7ce9e927bf','2026-10-25 15:54:26',NULL,'2026-09-25 07:54:26'),(198,3,'9a445dc31df0c8c4dda44a633b975f26c283d8e2bcd2a31d2e8d8a9dc3d59ab5','2026-10-25 15:57:53',NULL,'2026-09-25 07:57:53'),(199,4,'2e0f44f90d73baa742963d3ae77f7a0da74cc9647b82e7592cffe59685138d73','2026-10-25 16:01:32',NULL,'2026-09-25 08:01:32'),(200,4,'089d4f5e44517a3fee7a10f943e841ae951c133fb91535ae4b1fa74fe23a517c','2026-10-25 16:02:39',NULL,'2026-09-25 08:02:39'),(201,3,'94635ba13eea171f64ed0084e5fd8ca9cd161ac466f7e1f2dbc2261a357e790f','2026-10-25 16:02:56',NULL,'2026-09-25 08:02:56'),(202,5,'a56650bf8586cd95ba0159851b306c646ad7d8805e4bb281acb526a257f7f06c','2026-10-25 16:03:09',NULL,'2026-09-25 08:03:09'),(203,6,'a9100a38c5ccb2771c147f0702483f25e21d40bada0f87e5cfb9b251695b71f9','2026-10-25 16:03:42',NULL,'2026-09-25 08:03:42'),(204,1,'ed23d4cd178e88eb14e38ab81177798969a46d4f60c0f865e7b62f4bed9c0b31','2026-10-25 16:10:39',NULL,'2026-09-25 08:10:39'),(205,1,'dd3b556f57f89200f5a405576f088ede9c6ae261b0198d1a2452c3d5b2891dd2','2026-10-25 16:13:00',NULL,'2026-09-25 08:13:00'),(206,1,'b4407cdfb521fe0c420aa689b2ae3959c5247697572bf72459d3d5c81e2cf411','2026-10-25 16:46:08',NULL,'2026-09-25 08:46:08'),(207,1,'67483b0b94c4566179f3c5950f617edfdb4bc06fe3c276ee95620f8076e423c4','2026-10-25 16:47:19',NULL,'2026-09-25 08:47:19'),(208,1,'9571b0f840f3b7a0ea26a7bc8ff18eb39080002bbeae97358a842cf8af70dede','2026-10-25 16:49:06',NULL,'2026-09-25 08:49:06'),(209,1,'fc076273c365adb9d6647fbc7171cee470daec5fa34fc34b19057db857f68b45','2026-10-25 16:50:08',NULL,'2026-09-25 08:50:08'),(210,1,'9637e010e6dc3b6e2424661a1bfd212a18608901cd17d19cbe4f517630f45806','2026-10-25 16:59:15',NULL,'2026-09-25 08:59:15'),(211,1,'b97baa99acfefef169c84f5202b7f49e1661d0db43f270afce551b97ee9d8f74','2026-10-25 16:59:57',NULL,'2026-09-25 08:59:57'),(212,1,'a2c5e19e8fa2b4c0a7de2105cd929a8f07a1d63f95a5de285bc3599b9181266b','2026-10-25 17:00:10',NULL,'2026-09-25 09:00:10'),(213,1,'4183f73e148c00ecd10b990c3e8c641b76a28823ab9c54cc2405c14775e406c2','2026-10-25 17:00:47',NULL,'2026-09-25 09:00:47'),(214,1,'7678dd6e8b616a45d58058c7d1afca4e84ffbfb25c32190a850a2485db040991','2026-10-28 02:23:20',NULL,'2026-09-27 18:23:20'),(215,3,'f7667c9157620ad24e0a54acec353caf7e143fdac64c763ff22fa65e1715e65b','2026-10-28 02:28:47',NULL,'2026-09-27 18:28:47'),(216,4,'687ea7a4bf7431775dacde4111d7200a27e3e6c1cde6a484e4233374fadb24d2','2026-10-28 02:29:34',NULL,'2026-09-27 18:29:34'),(217,1,'8bc9970bb06ccc170a0b1ccaabb0b3919a7f2870ace0a873e3738d3cf99592a7','2026-10-28 02:30:47',NULL,'2026-09-27 18:30:47'),(218,6,'262bcec6e8131c4914e3d3ece8bd0ed1336d8443b87036e9594e836a623366a6','2026-10-28 02:31:08',NULL,'2026-09-27 18:31:08'),(219,2,'a335709d1847ee712b59dfa735daef93bc2c2abe7e95961b590160111043867e','2026-10-28 02:31:40',NULL,'2026-09-27 18:31:40'),(220,5,'6aea7b3b013752108facb5c30b4c952fd61c7582584fcbde30729d737cbf8b08','2026-10-28 02:34:28',NULL,'2026-09-27 18:34:28'),(221,3,'2bf50e47aa98df4c0d9f6c28b2e19a1b17f8fe786cb18abdc8845d9a797a37d2','2026-10-28 02:46:16',NULL,'2026-09-27 18:46:16'),(222,3,'3fce8870831296d132d6f898dccf5ee5e2972416cd1b8bc44f3154dad7798c08','2026-10-28 03:01:19',NULL,'2026-09-27 19:01:19'),(223,3,'7a05a6f256f3a9bfe56b95cb25a33963966d5ccef63105b816404074465c7553','2026-10-28 03:16:26',NULL,'2026-09-27 19:16:26'),(224,6,'91c1c34fef34db3f277c003d3e4c24b5007c07e0073dacffd22d8f95a7cf6694','2026-10-28 03:21:31',NULL,'2026-09-27 19:21:31'),(225,2,'2d6f297446cdb1f72cce3e7d967e80eb17c31de7890f29abc658e6016c7395ae','2026-10-28 03:34:30',NULL,'2026-09-27 19:34:30'),(226,2,'cb3240c69d19a44c00947cf0478b3e89a497d0d780e6f6d5f0bcdf0070182ac5','2026-10-28 03:39:22',NULL,'2026-09-27 19:39:22'),(227,1,'9630c5858911804dc6368f6009f0a3a64bd0f0bc4cda5ec72775031683a8ad69','2026-10-28 03:41:43',NULL,'2026-09-27 19:41:43'),(228,1,'7762bfd9b2f47b0cacad77ff54e5e71eabe66ce9c308df71fd11c5e7054d82a9','2026-10-28 05:56:20',NULL,'2026-09-27 21:56:20'),(229,1,'a0d5adceaae30aa9f9c9a1b1cc900faa10564296fa2f798b80183c274f82950f','2026-10-28 06:41:28',NULL,'2026-09-27 22:41:28'),(230,1,'e5227e2ab8541960abd2c7aa508bf8985b4abc93ebbeda82411262cedc835fa1','2026-10-28 07:15:25',NULL,'2026-09-27 23:15:25'),(231,1,'12db70d499097baceda8dcbff6514e8019ee4bea8a0d3228afe9225bdc0e071d','2026-10-28 07:28:32',NULL,'2026-09-27 23:28:32'),(232,1,'4f5579bbb35747931cdff522295eed95c2e38c9a8a70ad6a2a1c6ef58e75ef20','2026-10-28 07:36:25',NULL,'2026-09-27 23:36:25'),(233,1,'d2de02968a136f009eab2dcca7cd8e2528eb5ed6bca3449eadadc10e38187799','2026-10-28 07:36:28',NULL,'2026-09-27 23:36:28'),(234,1,'7840befeba161a668a0fdb19748831df76db372ed129d50e5bf399777e8d74df','2026-10-28 07:36:33',NULL,'2026-09-27 23:36:33'),(235,1,'4682c41a30505f3ef00a60986cec797603057067cb41a781737b77a5df017220','2026-10-28 07:38:30',NULL,'2026-09-27 23:38:30'),(236,1,'d0f48ae858d92e560703720687ab086e3e2fbb29aca6037e59a407c5f915b0bf','2026-10-28 07:40:23',NULL,'2026-09-27 23:40:23'),(237,1,'5ea11f6ca553db1f2fab33f9b59d53199b4841437d0a394ddbdc9be98b48a845','2026-10-28 07:51:00',NULL,'2026-09-27 23:51:00'),(238,1,'e1f75892c373476a2e23ee5dbee07abd8c8b9d100b1ecaf535bd1d6a738f182e','2026-10-28 07:51:06',NULL,'2026-09-27 23:51:06'),(239,2,'69d22c328aee821dfb67bf6918ffab1d9f184d062268f8c24f9c953663959c8a','2026-10-28 07:51:15',NULL,'2026-09-27 23:51:15'),(240,1,'b6bcebcbc0c9a7ac5b184792dcd2ee7d67f94c7919af8d0929ca4fdfdeb95b42','2026-10-28 07:51:23',NULL,'2026-09-27 23:51:23'),(241,2,'395d558174590775fa8a63c3d09f5a7f45bf03da791b37e5b0dd0802a30f8b11','2026-10-28 07:51:23',NULL,'2026-09-27 23:51:23'),(242,1,'cb00b63c511e01d10ff930cbbad3aa5e8b3f1f341ef9ca840f6b76ef99f6a380','2026-10-28 07:51:28',NULL,'2026-09-27 23:51:28'),(243,1,'376ca02dcc3e10261896a979736f27ada12bc53b107197023984df9f3a40541e','2026-10-28 07:51:34',NULL,'2026-09-27 23:51:34'),(244,5,'cd76ab6b71392e354014a32f6745d76e8de8f47cef9997fbb7fb1f22e612aa6b','2026-10-28 07:51:41',NULL,'2026-09-27 23:51:41'),(245,1,'ec3022fbb0f26146b6ca5ced0ed5c4ad67b7f51c16f479c5f3cf3076fc671842','2026-10-28 07:51:41',NULL,'2026-09-27 23:51:41'),(246,1,'f1e003b67d57885e341ef57dca932bc0ef9aa45687500c0903992bfc38ae24c2','2026-10-28 07:55:02',NULL,'2026-09-27 23:55:02'),(247,2,'d78e49222ca10c59967ac354b9825b7d0407ffc3785923992cae4f1f11081d6f','2026-10-28 07:55:03',NULL,'2026-09-27 23:55:03'),(248,4,'b7979429fe20d16cab34744506c46833b3fe972cb0ea9be24172febe631f2522','2026-10-28 07:55:04',NULL,'2026-09-27 23:55:04'),(249,4,'e67fe349cb824f4b4dd355888829c2ad81a5b71fc7ea47d829253512eae52234','2026-10-28 07:56:32',NULL,'2026-09-27 23:56:32'),(250,1,'c4e30fab1a8ff8a84eca261f556abb4140a894d4452290f42f69c01c9c83863e','2026-10-28 07:58:05','2026-09-28 08:05:13','2026-09-27 23:58:05'),(251,1,'9f0633f09b1350c11a576f10d715c235f53e85b4b3ed16ff56fe349fb26af413','2026-10-28 08:02:03',NULL,'2026-09-28 00:02:03'),(252,1,'5205b0dc39934d47ced6020aaeb9d2b0585418b49a7756c08465055189798bb0','2026-10-28 08:02:09',NULL,'2026-09-28 00:02:09'),(253,1,'555c356e5ef1a913a7ca6ecdcceec0dff1527510cfb22b9168a97dd94500c227','2026-10-28 08:02:13',NULL,'2026-09-28 00:02:13'),(254,1,'57303974872328c31a58d5c1e9465c903fb8abd949873f6d990a229611098b1f','2026-10-28 08:05:13',NULL,'2026-09-28 00:05:13'),(255,1,'599a448161567aea1ab6ce236b9381f91a482c9a550feb7a3d57f9fcb6d1c9b0','2026-10-28 08:08:48',NULL,'2026-09-28 00:08:48'),(256,1,'b51fdbd4f78f8084c618bad0ec7a2f3635a42af4d51c13adac0197a9bb269f8f','2026-10-28 08:08:56',NULL,'2026-09-28 00:08:56'),(257,1,'25e0ffd7456a35be99598bc288ea7b6185a74908ebb5dbc47230fdcac30b6e9a','2026-10-28 08:13:35',NULL,'2026-09-28 00:13:35'),(258,5,'8b262351a38bac3608075047708743c296fcfd2d73b7359f7d82ad572370ea92','2026-10-28 08:13:47',NULL,'2026-09-28 00:13:47'),(259,4,'9fa5fbe2ecdacaacdf775e1de855f023a163916d18d75fbf59161befb1c4d1a1','2026-10-28 08:13:47',NULL,'2026-09-28 00:13:47'),(260,1,'1ff24f89a840e17933f3588648d27a2e7d929bf0e5ca45c14af3f52e5de7e52e','2026-10-28 08:13:47',NULL,'2026-09-28 00:13:47'),(261,1,'8918cea43302a28fa989c9fd89f16f4d4f47db7a963f22191209c09cfdadf513','2026-10-28 08:14:52','2026-09-28 08:19:51','2026-09-28 00:14:52'),(262,1,'2ee20ca17c9014a98caea843a39fa84eac6417bc30cb411d78d8b49ca663ba2d','2026-10-28 08:18:11',NULL,'2026-09-28 00:18:11'),(263,1,'dd65991b4fc0fe0d8d5499727857797a8ff56b279c64f1fc49ace5314f705848','2026-10-28 08:19:51','2026-09-28 08:23:53','2026-09-28 00:19:51'),(264,1,'6e0dd9dad215e559793f7df2833d26badf17ee4e32ff8cc5e8743aed78bd96df','2026-10-28 08:23:53','2026-09-28 08:28:52','2026-09-28 00:23:53'),(265,1,'5a6b3c36ed5c49125c9116fbe7505a1055f961b7b019583f24b7d7adf1d7419c','2026-10-28 08:27:00',NULL,'2026-09-28 00:27:00'),(266,1,'a3553231108b1779fa3e782b60638418867b8f5ab00692a74e21b459a2a145c1','2026-10-28 08:27:18',NULL,'2026-09-28 00:27:18'),(267,1,'e308b98f10156a03b3e686b89917069ac8daa1b740d1e330a433cc8a869fe823','2026-10-28 08:28:52','2026-09-28 08:33:27','2026-09-28 00:28:52'),(268,1,'497ecf7ac5d75f7cf56587d56cd686ae5a7760c982ad76e096b9b20140820771','2026-10-28 08:31:55',NULL,'2026-09-28 00:31:55'),(269,1,'ba5c94e31837d42e61a03ed7220cf8ca2568c680a664cb8b6d4d2b501f54efd5','2026-10-28 08:32:02',NULL,'2026-09-28 00:32:02'),(270,1,'e73d0cffb6f789270d84aabe1466f8d6dce667cbb571fcf206803783737d7a53','2026-10-28 08:32:15',NULL,'2026-09-28 00:32:15'),(271,1,'5c89fdc32e63dc8f10c47060aeeea677eb0929a030b7404b6f64eea2b82f6679','2026-10-28 08:33:26',NULL,'2026-09-28 00:33:26'),(272,1,'dfcded051159b5ca4ac6721d10f1ee08b2da84b7072b685b6ddbb999c74a2b7e','2026-10-28 08:33:29','2026-09-28 08:38:58','2026-09-28 00:33:29'),(273,1,'d9e5f838217a17fb88967be6e2aba3001dba1117d34b503f9ba04f28d1096060','2026-10-28 08:36:10',NULL,'2026-09-28 00:36:10'),(274,1,'051be06c5c68c92a76af9a8a60af3b5ab54bd7596166af4c1ae1c94e64702fe9','2026-10-28 08:37:02',NULL,'2026-09-28 00:37:02'),(275,1,'9ec8dd2cf614b7bd17fdc1418c58a81086afbc8d6fa44ea23ff31d547afca799','2026-10-28 08:38:27',NULL,'2026-09-28 00:38:27'),(276,1,'134c503a15c8d3d3e6a49cd65f6f941ed53b9f76a1e6ff6fc93d46fb4e51c8c0','2026-10-28 08:38:58','2026-09-28 08:39:01','2026-09-28 00:38:58'),(277,1,'6eaed25cf02118ee25ee39a0e2b2bbcddc1b4fc3643bbb931f781f3e450ed29a','2026-10-28 08:39:14','2026-09-28 08:39:17','2026-09-28 00:39:14'),(278,5,'28a8053b312b1b301309f05083faf7bca148218ac8170986ec138f227ea6e69f','2026-10-28 08:39:21','2026-09-28 08:41:00','2026-09-28 00:39:21'),(279,1,'76067b126476cec8a062b69176d750387606f277a7057d346711673b94f37297','2026-10-28 08:41:04','2026-09-28 08:45:58','2026-09-28 00:41:04'),(280,1,'1d62f0a79d66a2456741890bff404c1ea17a12522965e2741212eaf29cc9504a','2026-10-28 08:45:58','2026-09-28 08:51:34','2026-09-28 00:45:58'),(281,1,'7a94ae7423709ecba85b80f9e2233eb30f28bd3ece6b54d93a898c4fcca7438b','2026-10-28 08:51:17',NULL,'2026-09-28 00:51:17'),(282,1,'936dc0f079af4cad59133517cc9de5de48ff341dad560eb36df3f121ff75d6c9','2026-10-28 08:51:34','2026-09-28 08:57:17','2026-09-28 00:51:34'),(283,1,'f3bd856743f542a7826f14ad2a8d3be42a57dfeb7cb109efc42145a4c739fd68','2026-10-28 08:55:58',NULL,'2026-09-28 00:55:58'),(284,1,'5313dd8eb5cd3870d06e9d44f9907d0509a8bd5032e325d48420be31ae05ecfe','2026-10-28 08:56:13',NULL,'2026-09-28 00:56:13'),(285,1,'c3a1c67a62639cde3a58e1b34aa63005185a1d1195061a92c2dc5fa58577f8dc','2026-10-28 08:57:17','2026-09-28 09:13:57','2026-09-28 00:57:17'),(286,1,'df1245cdff0351e1b840664571f352a38b94929013019e5b2cd2093b6e384732','2026-10-28 09:25:42','2026-09-28 09:42:34','2026-09-28 01:25:42'),(287,1,'dfe923d772376c5e7c25d1adfd955e3788d2c6a6ccf4b65f5561c9ef852dcec1','2026-10-28 09:42:34','2026-09-28 09:47:34','2026-09-28 01:42:34'),(288,1,'fd1dad6c0004e0a75b5afe6afe69676dad1f31f61505cf2e80e841dcce61be09','2026-10-28 09:47:34','2026-09-28 09:51:59','2026-09-28 01:47:34'),(289,1,'61d69c9c9afb706de8c1c599e7348ff4b7fcc4765781d2f313479b5c6a78b7cd','2026-10-28 09:51:59','2026-09-28 09:56:00','2026-09-28 01:51:59'),(290,1,'16536684c1238e0cc195ce8a2532c51bf9d7a69a0c907057edadd0bdd8b1ee55','2026-10-28 09:56:00','2026-09-28 10:00:37','2026-09-28 01:56:00'),(291,1,'95efd2a81ffb9331bfeb1d209145d0e84b7254ea5b1023643b3456f697c33dd1','2026-10-28 10:00:37','2026-09-28 10:01:03','2026-09-28 02:00:37'),(292,3,'bb83ab75856cc131de8ca4492dbcdc494a880f35c503d1e732add2ec9a1ea3f4','2026-10-28 10:01:08','2026-09-28 10:02:15','2026-09-28 02:01:08'),(293,4,'227b87ca17187b25cc4e4b2b713c0d6645c51978644b78317f4207e970bb21a3','2026-10-28 10:02:45','2026-09-28 10:02:59','2026-09-28 02:02:45'),(294,5,'479faf4ba38a6fee80a3f6cd45cd37c83d27b81eb447d2b348d98f0e7d911c2a','2026-10-28 10:03:41','2026-09-28 10:05:30','2026-09-28 02:03:41'),(295,6,'c45210c5c714bdcb724a8e6792188324bbc1e51ef93b02171fff291e2e53b64a','2026-10-28 10:05:58','2026-09-28 10:06:48','2026-09-28 02:05:58'),(296,2,'48a7d501e9477c6fc4e07def6f8212bd17e165cfc6f402dd2bf6b49c9446c707','2026-10-28 10:06:52','2026-09-28 10:07:19','2026-09-28 02:06:52'),(297,5,'233d22b4858f17797e4ca4bd2c8a7db36590107aed61b98bdb0c5d9b28e58070','2026-10-28 10:13:54','2026-09-28 10:20:25','2026-09-28 02:13:54'),(298,2,'9d9b97ce05a333fa8a7ce8f3b984f2992090c0d2435d22a8b2ca7333733333ca','2026-10-28 10:20:38','2026-09-28 10:20:47','2026-09-28 02:20:38'),(299,4,'48fb3638275605554bbb2b7cce8becae2d7303d3cebd261eaeb341641a7e13f3','2026-10-28 10:20:53',NULL,'2026-09-28 02:20:53'),(300,1,'c2e32d485c31317a4bb323294ec26831ae1a605ef83ace3e74d75b49e4c377cd','2026-10-28 10:40:56','2026-09-28 10:45:09','2026-09-28 02:40:56'),(301,1,'ca440371994eb3c313b1f380614a72843aabd3bcf44fb48c1f7c8b9119db09df','2026-10-28 10:45:09','2026-09-28 10:45:45','2026-09-28 02:45:09');
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treatment_dockets`
--

LOCK TABLES `treatment_dockets` WRITE;
/*!40000 ALTER TABLE `treatment_dockets` DISABLE KEYS */;
INSERT INTO `treatment_dockets` VALUES (1,'TD-111FABCFAB',1,1,3,4,1,'READY','PENDING','2026-09-24 09:22:33','2026-09-24 09:22:33'),(2,'TD-14B6AC0599',13,1,3,4,2,'READY','PENDING','2026-09-24 10:20:55','2026-09-24 10:20:55'),(3,'TD-76EDB14863',5,6,3,4,2,'READY','PENDING','2026-09-25 06:19:49','2026-09-25 06:19:49'),(4,'TD-EA73616DDF',12,1,3,4,5,'READY','PENDING','2026-09-25 06:30:54','2026-09-25 06:30:54'),(5,'TD-196EB13B18',17,28,3,4,2,'READY','PENDING','2026-09-25 06:38:03','2026-09-25 06:38:03'),(6,'TD-DB5C318AF5',19,31,3,4,6,'READY','PENDING','2026-09-25 08:23:43','2026-09-25 08:23:43'),(7,'TD-9F9062D393',19,3,3,4,2,'READY','PENDING','2026-09-25 08:37:39','2026-09-25 08:37:39'),(8,'TD-5DE965688A',23,28,3,4,5,'READY','PAID','2026-09-25 09:30:15','2026-09-28 10:15:05'),(9,'TD-F706FAAD30',25,1,3,4,1,'READY','PENDING','2026-09-25 13:47:22','2026-09-25 13:47:22'),(10,'TD-8CCCE4C4F0',27,33,3,4,20,'READY','PENDING','2026-09-25 13:49:54','2026-09-25 13:49:54'),(11,'TD-AAFFDFD033',29,37,3,4,1,'READY','PENDING','2026-09-25 15:55:45','2026-09-25 15:55:45'),(12,'TD-E7E36D9569',23,4,3,4,20,'READY','PAID','2026-09-25 16:01:13','2026-09-28 10:19:27'),(13,'TD-847E9200E1',34,33,3,4,21,'READY','PENDING','2026-09-28 02:33:51','2026-09-28 02:33:51'),(14,'TD-EBE854B3CC',3,NULL,NULL,NULL,20,'READY','PAID','2026-09-28 07:51:15','2026-09-28 07:51:40'),(16,'TD-8B1098342D',3,NULL,NULL,NULL,20,'READY','PAID','2026-09-28 07:55:03','2026-09-28 10:19:14');
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,'Mondejar, Shin','admin@dermaclinic.test','$2a$10$NUkndv2.L7xZ8KaKlBULzeG9F/CPQ4P2K1q7TlEO4TAYX5fgWNOra','ACTIVE','2026-09-16 13:14:55','2026-09-25 16:59:31',0),(2,2,'Maya Johnson','reception@dermaclinic.test','$2a$10$uSe7q35Dp37segXWOL6IKOO60/7WiSkv1h2wwDXxKGficGeGav1U.','ACTIVE','2026-09-16 13:14:55','2026-09-24 08:38:43',0),(3,3,'Dr. Lina Chen','dermatologist@dermaclinic.test','$2a$10$kCdOjQ9I.In27bu4p/HTEudo4KN3S2IK0KG7J0EzH6UcxCp5AUvpG','ACTIVE','2026-09-16 13:14:55','2026-09-24 08:38:43',0),(4,4,'Maya Rose','therapist@dermaclinic.test','$2a$10$THVDnp1YZNY5ZwiPB.0cF.28JEorHH1CGAZrJt3.usEfkXh0mci4u','ACTIVE','2026-09-16 13:14:55','2026-09-24 08:38:43',0),(5,5,'Noah Williams','cashier@dermaclinic.test','$2a$10$Q9TZofgOqkwE0rjRZuHf5OEgZ/e6GfBlqpFvl6Q6zwdKLXwf5vrGq','ACTIVE','2026-09-16 13:14:55','2026-09-24 08:38:43',0),(6,26,'Ava Patel','inventory@dermaclinic.test','$2a$10$vzm4mWFVDTpaC8rK2mwiCOxFrKGXQ6Pn.uC1wzq4Z1F4I6zx8YDsq','ACTIVE','2026-09-16 13:14:55','2026-09-24 08:38:43',0),(7,2,'Database Test User','created-b1b73013@example.test','$2a$10$rhKgwSD8r8jqvlRBV2nBveFNMLnvrFUwxj9R4Pnuf1KnXCRd72yn2','INACTIVE','2026-09-24 06:10:41','2026-09-24 06:10:41',1),(8,1,'mondejar','mondejar@gmail.com','$2a$10$oZRjt8iX5HxhjWLKHGbA9O8Zsgvblvm7sydm5RVpwpDpQGnzvlH12','ACTIVE','2026-09-24 06:41:18','2026-09-24 06:41:18',0),(9,1,'Mondejarwashington','mondejar041921@gmail.com','$2a$10$yeMvu52XWIoH/86KRXlPM.zAkAmJne8Wqlkfc86xcbTfT2hH7TSG2','ACTIVE','2026-09-24 07:16:44','2026-09-24 07:16:44',0),(10,2,'Mondejar, Washington B.','Mondejarshin@dermaclinic.test','$2a$10$N5J46Y5RJQdhLmMDho6Ggu7F6CJgvP8I5O.Dwmo5F4qNrYVkHzGSW','ACTIVE','2026-09-24 07:20:45','2026-09-24 07:20:45',0),(11,5,'shinmondejar','shin@dermaclinic.test','$2a$10$RNJsz5coHOzqSgZTuuBNOOcp7VBjjdUTKtFFK4bN5d0YP.J64CujC','ACTIVE','2026-09-24 07:26:26','2026-09-24 07:26:26',0),(12,6,'fujimiyakun','fujimiyakun0441921@dermaclinic.test','$2a$10$IFSs6SZ9/deDu17nNpVUYu88s2Fq.B.MVCmIbtHuL3uPrgDXLnZXu','ACTIVE','2026-09-24 07:29:25','2026-09-24 07:29:25',0),(13,1,'mondejarwashington','mondejar41921@gmail.com','$2a$10$b1bP9C.ESdgQcVJBu5T0PeuxxrAv0PGKUJXIAdFDtFadk/g0k9lVK','ACTIVE','2026-09-24 09:50:10','2026-09-24 09:50:10',0),(14,1,'kenshin','kenshin041921@gmail.com','$2a$10$acgE6Kd1qbkcMow5nOsnqOsJyZFzQX1CATQl0I4GOmq3Zk83ROSHS','ACTIVE','2026-09-25 08:41:04','2026-09-25 08:41:04',0);
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

-- Dump completed on 2026-09-28 18:48:05
