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

/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,NULL,'001','covid-antidote','4001',50.000,'ACTIVE','2026-09-24 09:48:50','2026-09-24 09:48:50'),(2,NULL,'PROD-050','abietic-acid','100',300.000,'ACTIVE','2026-09-25 05:49:25','2026-09-25 05:49:25'),(5,NULL,'PROD-035','abacavir-sulfate','300',500.000,'ACTIVE','2026-09-25 06:08:21','2026-09-25 06:08:21'),(9,NULL,'PROD-031','abacavir-sulfate','300',500.000,'ACTIVE','2026-09-25 06:20:19','2026-09-25 06:20:19'),(10,NULL,'PROD-055','abietic-acid','300',50.000,'ACTIVE','2026-09-25 06:38:21','2026-09-25 06:38:21'),(11,NULL,'PROD-ABIETIC-ACID','abietic-acid','units',10.000,'ACTIVE','2026-09-25 07:41:27','2026-09-25 07:41:27'),(12,NULL,'PROD-ABACAVIR-SULFATE','abacavir-sulfate','units',10.000,'ACTIVE','2026-09-25 07:41:27','2026-09-25 07:41:27'),(13,NULL,'PROD-ACEDOBEN','Acedoben','units',10.000,'ACTIVE','2026-09-25 07:41:27','2026-09-25 07:41:27'),(14,NULL,'PROD-02','sulfate','45',50.000,'ACTIVE','2026-09-25 08:39:27','2026-09-25 08:39:27'),(15,NULL,'PROD-03','sulfate','46',0.003,'ACTIVE','2026-09-25 08:59:20','2026-09-25 08:59:20'),(16,NULL,'PROD-04','sulfate','47',30.000,'ACTIVE','2026-09-25 09:04:02','2026-09-25 09:04:02'),(23,NULL,'PROD-10','balmond','49',1.000,'ACTIVE','2026-09-25 12:15:49','2026-09-25 12:15:49'),(24,NULL,'PROD-06','serum','50',10.000,'ACTIVE','2026-09-25 12:59:32','2026-09-25 12:59:32'),(25,NULL,'003','acntrex','1',0.000,'ACTIVE','2026-09-28 03:22:25','2026-09-28 03:22:25'),(26,NULL,'004','acntrex','50',11.000,'ACTIVE','2026-09-28 03:25:17','2026-09-28 03:25:17'),(31,NULL,'005','injection','53',55.000,'ACTIVE','2026-09-28 11:31:06','2026-09-28 11:31:06');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;

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

/*!40000 ALTER TABLE `inventory_batches` DISABLE KEYS */;
INSERT INTO `inventory_batches` VALUES (1,5,'OPENING-20260925','2027-12-31','2026-09-25 07:41:27'),(2,9,'OPENING-20260925','2027-12-31','2026-09-25 07:41:27'),(3,12,'OPENING-20260925','2027-12-31','2026-09-25 07:41:27'),(4,2,'OPENING-20260925','2027-12-31','2026-09-25 07:41:27'),(5,10,'OPENING-20260925','2027-12-31','2026-09-25 07:41:27'),(6,11,'OPENING-20260925','2027-12-31','2026-09-25 07:41:27'),(7,13,'OPENING-20260925','2027-12-31','2026-09-25 07:41:27'),(8,5,'2026-09','2026-09-26','2026-09-25 08:25:11'),(9,2,'2026-10','2026-09-30','2026-09-25 08:38:08'),(10,5,'2026-10','2026-09-30','2026-09-25 09:01:18'),(11,9,'A-2026-09','2026-10-31','2026-09-25 13:00:24'),(12,5,'A-2026-19','2026-12-04','2026-09-25 13:50:29'),(13,5,'A-2026-11','2026-11-26','2026-09-25 14:31:29'),(14,5,'A-2026-12','2026-10-15','2026-09-25 15:56:52'),(16,5,'Batch 1','2026-09-28','2026-09-28 09:56:07');
/*!40000 ALTER TABLE `inventory_batches` ENABLE KEYS */;

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

/*!40000 ALTER TABLE `inventory_balances` DISABLE KEYS */;
INSERT INTO `inventory_balances` VALUES (2,339.000,'2026-10-02 07:05:46'),(5,13605.000,'2026-09-28 09:56:07'),(9,160.000,'2026-09-25 13:00:24'),(10,365.000,'2026-09-25 07:41:27'),(11,365.000,'2026-09-25 07:41:27'),(12,176.000,'2026-09-25 07:41:27'),(13,257.000,'2026-09-25 07:41:27');
/*!40000 ALTER TABLE `inventory_balances` ENABLE KEYS */;

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

/*!40000 ALTER TABLE `inventory_movements` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_movements` ENABLE KEYS */;

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

/*!40000 ALTER TABLE `service_required_products` DISABLE KEYS */;
INSERT INTO `service_required_products` VALUES (2,5,10.000),(20,2,5.000);
/*!40000 ALTER TABLE `service_required_products` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-12 15:23:27
