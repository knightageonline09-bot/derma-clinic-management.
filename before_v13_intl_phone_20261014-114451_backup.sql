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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consultations`
--

LOCK TABLES `consultations` WRITE;
/*!40000 ALTER TABLE `consultations` DISABLE KEYS */;
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
INSERT INTO `flyway_schema_history` VALUES (1,'1','<< Flyway Baseline >>','BASELINE','<< Flyway Baseline >>',NULL,'root','2026-09-16 13:11:00',0,1),(2,'2','seed roles','SQL','V2__seed_roles.sql',-1369780179,'root','2026-09-16 13:14:55',106,1),(3,'3','fix development password hashes','SQL','V3__fix_development_password_hashes.sql',511361378,'root','2026-09-17 14:33:04',63,1),(4,'4','set staff development password hashes','SQL','V4__set_staff_development_password_hashes.sql',-19219740,'root','2026-09-17 16:04:52',19,1),(5,'5','remove non admin development accounts','SQL','V5__remove_non_admin_development_accounts.sql',-1064234823,'root','2026-09-24 06:07:57',28,1),(6,'6','restore development staff accounts','SQL','V6__restore_development_staff_accounts.sql',199569236,'root','2026-09-24 08:38:43',37,1),(7,'7','seed requested inventory','SQL','V7__seed_requested_inventory.sql',2086536922,'root','2026-09-25 07:41:27',320,1),(8,'8','link services to required products','SQL','V8__link_services_to_required_products.sql',694103836,'root','2026-09-28 07:50:04',24,1),(9,'9','add consultation follow up date','SQL','V9__add_consultation_follow_up_date.sql',-397423900,'root','2026-09-28 08:31:32',363,1),(10,'10','add patient skin type and allergies','SQL','V10__add_patient_skin_type_and_allergies.sql',-110423083,'root','2026-09-28 09:42:25',187,1),(11,'11','canonicalise role names','SQL','V11__canonicalise_role_names.sql',191968059,'derma_flyway','2026-10-13 10:25:42',50,1),(12,'12','e164 patient phone','SQL','V12__e164_patient_phone.sql',-1875702718,'derma_flyway','2026-10-14 03:00:34',23,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_movements`
--

LOCK TABLES `inventory_movements` WRITE;
/*!40000 ALTER TABLE `inventory_movements` DISABLE KEYS */;
INSERT INTO `inventory_movements` VALUES (7,34,18,NULL,'STOCK_IN',0.000,0.000,46.000,'OPENING-STOCK',1,'2026-10-14 02:17:37');
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
  CONSTRAINT `chk_patients_phone_e164` CHECK (((`phone` is null) or regexp_like(`phone`,_utf8mb4'^[+]63([89][0-9]{9}|[2-8][0-9]{8})$')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_refresh_tokens`
--

LOCK TABLES `session_refresh_tokens` WRITE;
/*!40000 ALTER TABLE `session_refresh_tokens` DISABLE KEYS */;
INSERT INTO `session_refresh_tokens` VALUES (1,1,'b016f0bdd1771175822b187c616c86a88ca58ea666ab9a8a8ee213196efc3598','2026-11-13 02:21:03',NULL,'2026-10-13 18:21:03'),(2,2,'ed40d328b59ad29b4a5b72ed6e5687a6c40f3417b48c6395a19043809ad21c55','2026-11-13 02:21:55',NULL,'2026-10-13 18:21:55'),(3,3,'b3ca466626873a93fcbd3587b0580658613391cb94d749a4ccbe4ab19148fcbc','2026-11-13 02:30:14',NULL,'2026-10-13 18:30:14'),(4,4,'820613414c83628219354bad863d3fd14347041166b80ae1a4a726e107ece173','2026-11-13 02:31:44',NULL,'2026-10-13 18:31:44'),(5,6,'9a401dc8d96b3fd5350195990564c7b3a95520d981aad8623fab451f473c39e8','2026-11-13 02:32:52',NULL,'2026-10-13 18:32:52'),(6,5,'e020ccd068e30ef0818d3fdd56ac67aed1fc6d91f3904f23e6e8b1bcf6a11670','2026-11-13 02:35:54',NULL,'2026-10-13 18:35:54'),(7,1,'1587cc9c6a84c3f74432c865023380b6f0bc54d22bbfb81591acaead64f37f61','2026-11-13 02:39:45','2026-10-14 02:44:46','2026-10-13 18:39:45'),(8,1,'40d1f1573c48d031f51b57b6132106aa68c6257d690b65ebb9db5896f7866d45','2026-11-13 02:44:46','2026-10-14 02:49:47','2026-10-13 18:44:46'),(9,1,'98456193834392228693dd28c6b1137e3078473d695d3498c5d5ca4cc9272bd8','2026-11-13 02:49:47','2026-10-14 02:54:48','2026-10-13 18:49:47'),(10,1,'cabe12241258127df0d52f1133aad419aeddad79bb1bd247e41792dda5584daf','2026-11-13 02:54:48','2026-10-14 02:59:49','2026-10-13 18:54:48'),(11,1,'1de27b47569c291c4e01c3619899420095ab5b5499269278d69f141a4fb864d0','2026-11-13 02:59:49','2026-10-14 03:04:50','2026-10-13 18:59:49'),(12,1,'9abda400b501e5439b3ea74be625369ee7b582364e8c64f0f64c5a1df43e6fef','2026-11-13 03:01:25',NULL,'2026-10-13 19:01:25'),(13,1,'6d2e48856da1111604710aab63eaa0de4f62ef0c055f33ca20d73266068ea845','2026-11-13 03:04:50',NULL,'2026-10-13 19:04:50'),(14,1,'811885d44d4c1473b2f55f544e192879b416c8a061f9b90f7cbd93949b3b33a8','2026-11-13 03:19:18','2026-10-14 03:24:19','2026-10-13 19:19:18'),(15,1,'82cac6483a7d80a34c347a2beb7d588859f7ca76f4875a3ad4920a24e218a84a','2026-11-13 03:24:19','2026-10-14 03:29:20','2026-10-13 19:24:19'),(16,1,'c4a45f84005e94a5701567682e3200ae7f58358df203401c646b9afc895d1cee','2026-11-13 03:29:20','2026-10-14 03:34:21','2026-10-13 19:29:20'),(17,1,'ff72f96357440c252315c3fddcb39f6584bfa6d6b42ba6c0692f03f03a9d4ea7','2026-11-13 03:34:21','2026-10-14 03:39:22','2026-10-13 19:34:21'),(18,1,'68a6b04791c2e07f525c89cd590bcdeb5a4c2118751056b6b34e91f8cd65a65d','2026-11-13 03:39:22','2026-10-14 03:44:23','2026-10-13 19:39:22'),(19,1,'340bd48c00c94d7f8e6f142a59db83cec0d4ff7d0f332d247cb744c0d61ed90a','2026-11-13 03:44:23',NULL,'2026-10-13 19:44:23');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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

-- Dump completed on 2026-10-14 11:44:52
