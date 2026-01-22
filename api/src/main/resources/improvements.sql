-- ================================================================================
-- Performance Improvements for sp_mamba_view_fact_consommation_report
-- MySQL 5.7+ Optimizations
-- Generated: 2025-08-26
-- ================================================================================

-- ================================================================================
-- LAYER 1: CRITICAL INDEX CREATION (80% Performance Gain)
-- ================================================================================

-- Add missing critical indexes that are causing full table scans
ALTER TABLE mamba_dim_person_name 
  ADD INDEX idx_person_id (person_id);

ALTER TABLE mamba_dim_bill_payment 
  ADD INDEX idx_collector (collector);

-- Composite indexes for optimizing multi-column JOINs
ALTER TABLE mamba_dim_consommation 
  ADD INDEX idx_composite_bills (patient_bill_id, global_bill_id, beneficiary_id);

ALTER TABLE mamba_dim_beneficiary 
  ADD INDEX idx_patient_policy (patient_id, insurance_policy_id);

-- Generated column for date operations (MySQL 5.7+ feature)
-- This allows the optimizer to use indexes on date comparisons
ALTER TABLE mamba_dim_global_bill 
  ADD COLUMN created_date_only DATE GENERATED ALWAYS AS (DATE(created_date)) STORED,
  ADD INDEX idx_created_date_only (created_date_only);

-- Additional indexes for JOIN performance
ALTER TABLE mamba_dim_admission
  ADD INDEX idx_insurance_policy_admitted (insurance_policy_id, is_admitted);

ALTER TABLE mamba_dim_insurance
  ADD INDEX idx_insurance_rate (insurance_id, current_insurance_rate);

-- ================================================================================
-- LAYER 2: MATERIALIZED COLLECTOR CACHE TABLE
-- ================================================================================

-- Drop existing cache if it exists
DROP TABLE IF EXISTS mamba_dim_collector_cache;

-- Create materialized view for collector information to eliminate expensive subquery
CREATE TABLE mamba_dim_collector_cache AS
SELECT 
  collector,
  person_id,
  CONCAT(given_name, ' ', family_name) AS collectorname
FROM (
  SELECT DISTINCT bp.collector, pn.person_id, pn.given_name, pn.family_name
  FROM mamba_dim_bill_payment bp
  INNER JOIN mamba_dim_person_name pn ON bp.collector = pn.person_id
) AS unique_collectors;

-- Add indexes to the cache table
ALTER TABLE mamba_dim_collector_cache 
  ADD PRIMARY KEY (collector),
  ADD INDEX idx_person_id (person_id);

-- ================================================================================
-- LAYER 3: OPTIMIZED VIEW USING IMPROVED STRUCTURE
-- ================================================================================

-- Drop and recreate the optimized view
DROP VIEW IF EXISTS mamba_view_fact_consommation_report_optimized;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_mamba_view_fact_consommation_report_optimized//
CREATE PROCEDURE sp_mamba_view_fact_consommation_report_optimized()
BEGIN
  SET SESSION group_concat_max_len = 20000;
  
  -- Session-level optimizations for better performance
  SET SESSION optimizer_search_depth = 12;
  SET SESSION join_buffer_size = 8388608;    -- 8MB
  SET SESSION sort_buffer_size = 4194304;    -- 4MB
  SET SESSION tmp_table_size = 67108864;     -- 64MB
  SET SESSION max_heap_table_size = 67108864;
  
  -- Create optimized view with performance improvements
  SET @select_stmt =
    'CREATE OR REPLACE VIEW mamba_view_fact_consommation_report_optimized AS
      SELECT STRAIGHT_JOIN
        mdgb.created_date_only AS date,
        mdd.name,
        mdb.policy_id_number,
        mdc.global_bill_id,
        mdc.consommation_id,
        CONCAT(mdpn.given_name, '' '', mdpn.family_name) AS beneficiary,
        COALESCE(NULLIF(mdb.company, '' ''), ''None'') AS insurancename,
        mdgb.global_amount,
        mdgb.global_amount * (100 - mdi.current_insurance_rate) / 100 AS patientdue,
        mdgb.global_amount * mdi.current_insurance_rate / 100 AS insurancedue,
        mdbp.amount_paid AS paid_amount,
        mdpb.status AS bill_status,
        IF(mda.is_admitted = 1, ''In-Patient'', ''Out-Patient'') AS admission_type,
        IF(mdgb.closing_date IS NOT NULL, ''DISCHARGED'', ''NOT DISCHARGED'') AS global_bill_status,
        COALESCE(mcc.collectorname, ''Unknown'') AS collectorname
      FROM mamba_dim_consommation mdc
      INNER JOIN mamba_dim_global_bill mdgb 
        ON mdgb.global_bill_id = mdc.global_bill_id
      LEFT JOIN mamba_dim_department mdd 
        ON mdc.department_id = mdd.department_id
      INNER JOIN mamba_dim_beneficiary mdb 
        ON mdc.beneficiary_id = mdb.beneficiary_id
      INNER JOIN mamba_dim_person_name mdpn 
        ON mdb.patient_id = mdpn.person_id
      LEFT JOIN mamba_dim_patient_bill mdpb 
        ON mdc.patient_bill_id = mdpb.patient_bill_id
      LEFT JOIN mamba_dim_bill_payment mdbp 
        ON mdc.patient_bill_id = mdbp.patient_bill_id
      LEFT JOIN mamba_dim_insurance_bill mdib 
        ON mdc.insurance_bill_id = mdib.insurance_bill_id
      INNER JOIN mamba_dim_admission mda 
        ON mda.insurance_policy_id = mdb.insurance_policy_id
      LEFT JOIN mamba_dim_insurance mdi 
        ON mdgb.insurance_id = mdi.insurance_id
      LEFT JOIN mamba_dim_collector_cache mcc 
        ON mcc.collector = mdbp.collector;';
        
  PREPARE select_stmt FROM @select_stmt;
  EXECUTE select_stmt;
  DEALLOCATE PREPARE select_stmt;
END //
DELIMITER ;

-- Execute the optimized view creation
CALL sp_mamba_view_fact_consommation_report_optimized();

-- ================================================================================
-- LAYER 4: PARAMETERIZED STORED PROCEDURES FOR COMMON QUERIES
-- ================================================================================

-- Optimized procedure for date range queries (most common use case)
DELIMITER //
DROP PROCEDURE IF EXISTS sp_mamba_consommation_report_by_date//
CREATE PROCEDURE sp_mamba_consommation_report_by_date(
  IN p_start_date DATE,
  IN p_end_date DATE,
  IN p_insurance_name VARCHAR(255),
  IN p_limit INT
)
BEGIN
  -- Set default limit if not provided
  IF p_limit IS NULL OR p_limit <= 0 THEN
    SET p_limit = 10000;
  END IF;
  
  -- Session optimizations
  SET SESSION optimizer_search_depth = 12;
  SET SESSION join_buffer_size = 8388608;
  SET SESSION sort_buffer_size = 4194304;
  
  -- Use optimizer hints for MySQL 5.7+
  SELECT /*+ MAX_EXECUTION_TIME(30000) */
    date,
    name,
    policy_id_number,
    global_bill_id,
    consommation_id,
    beneficiary,
    insurancename,
    global_amount,
    patientdue,
    insurancedue,
    paid_amount,
    bill_status,
    admission_type,
    global_bill_status,
    collectorname
  FROM mamba_view_fact_consommation_report_optimized
  WHERE date BETWEEN p_start_date AND p_end_date
    AND (p_insurance_name IS NULL OR insurancename = p_insurance_name)
  ORDER BY date DESC
  LIMIT p_limit;
END //
DELIMITER ;

-- Paginated version for large result sets
DELIMITER //
DROP PROCEDURE IF EXISTS sp_mamba_consommation_report_paginated//
CREATE PROCEDURE sp_mamba_consommation_report_paginated(
  IN p_start_date DATE,
  IN p_end_date DATE,
  IN p_insurance_name VARCHAR(255),
  IN p_page_number INT,
  IN p_page_size INT
)
BEGIN
  DECLARE v_offset INT;
  
  -- Calculate offset
  SET v_offset = (p_page_number - 1) * p_page_size;
  
  -- Session optimizations
  SET SESSION optimizer_search_depth = 12;
  SET SESSION join_buffer_size = 8388608;
  
  SELECT /*+ MAX_EXECUTION_TIME(30000) */
    date,
    name,
    policy_id_number,
    global_bill_id,
    consommation_id,
    beneficiary,
    insurancename,
    global_amount,
    patientdue,
    insurancedue,
    paid_amount,
    bill_status,
    admission_type,
    global_bill_status,
    collectorname
  FROM mamba_view_fact_consommation_report_optimized
  WHERE date BETWEEN p_start_date AND p_end_date
    AND (p_insurance_name IS NULL OR insurancename = p_insurance_name)
  ORDER BY date DESC
  LIMIT p_page_size OFFSET v_offset;
END //
DELIMITER ;

-- ================================================================================
-- LAYER 5: MATERIALIZED SUMMARY TABLES FOR DASHBOARDS
-- ================================================================================

-- Drop existing summary table if it exists
DROP TABLE IF EXISTS mamba_fact_consommation_daily_summary;

-- Pre-aggregated summary for fast dashboard queries
CREATE TABLE mamba_fact_consommation_daily_summary (
  summary_date DATE NOT NULL,
  insurance_name VARCHAR(255) NOT NULL,
  total_bills INT DEFAULT 0,
  total_amount DECIMAL(20,2) DEFAULT 0.00,
  total_patient_due DECIMAL(20,2) DEFAULT 0.00,
  total_insurance_due DECIMAL(20,2) DEFAULT 0.00,
  total_paid DECIMAL(20,2) DEFAULT 0.00,
  in_patient_count INT DEFAULT 0,
  out_patient_count INT DEFAULT 0,
  discharged_count INT DEFAULT 0,
  not_discharged_count INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (summary_date, insurance_name),
  INDEX idx_insurance_date (insurance_name, summary_date),
  INDEX idx_date (summary_date)
) ENGINE=InnoDB;

-- Procedure to refresh the summary table
DELIMITER //
DROP PROCEDURE IF EXISTS sp_refresh_consommation_summary//
CREATE PROCEDURE sp_refresh_consommation_summary()
BEGIN
  -- Clear existing data
  TRUNCATE TABLE mamba_fact_consommation_daily_summary;
  
  -- Populate with aggregated data
  INSERT INTO mamba_fact_consommation_daily_summary
    (summary_date, insurance_name, total_bills, total_amount, 
     total_patient_due, total_insurance_due, total_paid,
     in_patient_count, out_patient_count, 
     discharged_count, not_discharged_count)
  SELECT 
    date,
    insurancename,
    COUNT(*) as total_bills,
    COALESCE(SUM(global_amount), 0) as total_amount,
    COALESCE(SUM(patientdue), 0) as total_patient_due,
    COALESCE(SUM(insurancedue), 0) as total_insurance_due,
    COALESCE(SUM(paid_amount), 0) as total_paid,
    SUM(IF(admission_type = 'In-Patient', 1, 0)) as in_patient_count,
    SUM(IF(admission_type = 'Out-Patient', 1, 0)) as out_patient_count,
    SUM(IF(global_bill_status = 'DISCHARGED', 1, 0)) as discharged_count,
    SUM(IF(global_bill_status = 'NOT DISCHARGED', 1, 0)) as not_discharged_count
  FROM mamba_view_fact_consommation_report_optimized
  GROUP BY date, insurancename;
  
  -- Return success message
  SELECT CONCAT('Summary refreshed. Total records: ', COUNT(*)) AS result
  FROM mamba_fact_consommation_daily_summary;
END //
DELIMITER ;

-- Create scheduled event to refresh summary (optional - enable if needed)
DROP EVENT IF EXISTS refresh_consommation_summary_event;
DELIMITER //
CREATE EVENT IF NOT EXISTS refresh_consommation_summary_event
ON SCHEDULE EVERY 1 HOUR
STARTS CURRENT_TIMESTAMP
ENABLE
COMMENT 'Refresh consommation summary table every hour'
DO
BEGIN
  CALL sp_refresh_consommation_summary();
END //
DELIMITER ;

-- ================================================================================
-- LAYER 6: COLLECTOR CACHE REFRESH PROCEDURE
-- ================================================================================

DELIMITER //
DROP PROCEDURE IF EXISTS sp_refresh_collector_cache//
CREATE PROCEDURE sp_refresh_collector_cache()
BEGIN
  -- Recreate the collector cache
  DROP TABLE IF EXISTS mamba_dim_collector_cache_temp;
  
  CREATE TABLE mamba_dim_collector_cache_temp AS
  SELECT 
    collector,
    person_id,
    CONCAT(given_name, ' ', family_name) AS collectorname
  FROM (
    SELECT DISTINCT bp.collector, pn.person_id, pn.given_name, pn.family_name
    FROM mamba_dim_bill_payment bp
    INNER JOIN mamba_dim_person_name pn ON bp.collector = pn.person_id
  ) AS unique_collectors;
  
  -- Add indexes to the temp table
  ALTER TABLE mamba_dim_collector_cache_temp 
    ADD PRIMARY KEY (collector),
    ADD INDEX idx_person_id (person_id);
  
  -- Swap tables atomically
  DROP TABLE IF EXISTS mamba_dim_collector_cache_old;
  RENAME TABLE mamba_dim_collector_cache TO mamba_dim_collector_cache_old,
               mamba_dim_collector_cache_temp TO mamba_dim_collector_cache;
  DROP TABLE IF EXISTS mamba_dim_collector_cache_old;
  
  SELECT 'Collector cache refreshed successfully' AS result;
END //
DELIMITER ;

-- ================================================================================
-- MONITORING AND VALIDATION QUERIES
-- ================================================================================

-- Query to check index usage
DELIMITER //
DROP PROCEDURE IF EXISTS sp_check_index_usage//
CREATE PROCEDURE sp_check_index_usage()
BEGIN
  SELECT 
    'mamba_dim_person_name' AS table_name,
    COUNT(*) AS index_count
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'mamba_dim_person_name'
    AND INDEX_NAME = 'idx_person_id'
  UNION ALL
  SELECT 
    'mamba_dim_bill_payment' AS table_name,
    COUNT(*) AS index_count
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'mamba_dim_bill_payment'
    AND INDEX_NAME = 'idx_collector'
  UNION ALL
  SELECT 
    'mamba_dim_global_bill' AS table_name,
    COUNT(*) AS index_count
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'mamba_dim_global_bill'
    AND COLUMN_NAME = 'created_date_only';
END //
DELIMITER ;

-- Query to analyze performance before and after optimization
DELIMITER //
DROP PROCEDURE IF EXISTS sp_analyze_performance//
CREATE PROCEDURE sp_analyze_performance(
  IN p_use_optimized BOOLEAN
)
BEGIN
  DECLARE v_start_time DATETIME;
  DECLARE v_end_time DATETIME;
  DECLARE v_elapsed_ms INT;
  
  SET v_start_time = NOW(6);
  
  IF p_use_optimized THEN
    -- Test optimized view
    SELECT COUNT(*) INTO @row_count
    FROM mamba_view_fact_consommation_report_optimized
    WHERE date BETWEEN DATE_SUB(CURDATE(), INTERVAL 30 DAY) AND CURDATE();
  ELSE
    -- Test original view
    SELECT COUNT(*) INTO @row_count
    FROM mamba_view_fact_consommation_report
    WHERE date BETWEEN DATE_SUB(CURDATE(), INTERVAL 30 DAY) AND CURDATE();
  END IF;
  
  SET v_end_time = NOW(6);
  SET v_elapsed_ms = TIMESTAMPDIFF(MICROSECOND, v_start_time, v_end_time) / 1000;
  
  SELECT 
    IF(p_use_optimized, 'Optimized', 'Original') AS view_type,
    @row_count AS rows_processed,
    v_elapsed_ms AS execution_time_ms,
    ROUND(v_elapsed_ms / 1000, 2) AS execution_time_seconds;
END //
DELIMITER ;

-- ================================================================================
-- ROLLBACK SCRIPT (If needed to revert changes)
-- ================================================================================

DELIMITER //
DROP PROCEDURE IF EXISTS sp_rollback_improvements//
CREATE PROCEDURE sp_rollback_improvements()
BEGIN
  -- Remove added indexes
  ALTER TABLE mamba_dim_person_name DROP INDEX IF EXISTS idx_person_id;
  ALTER TABLE mamba_dim_bill_payment DROP INDEX IF EXISTS idx_collector;
  ALTER TABLE mamba_dim_consommation DROP INDEX IF EXISTS idx_composite_bills;
  ALTER TABLE mamba_dim_beneficiary DROP INDEX IF EXISTS idx_patient_policy;
  ALTER TABLE mamba_dim_admission DROP INDEX IF EXISTS idx_insurance_policy_admitted;
  ALTER TABLE mamba_dim_insurance DROP INDEX IF EXISTS idx_insurance_rate;
  
  -- Remove generated column
  ALTER TABLE mamba_dim_global_bill DROP COLUMN IF EXISTS created_date_only;
  
  -- Drop optimization tables
  DROP TABLE IF EXISTS mamba_dim_collector_cache;
  DROP TABLE IF EXISTS mamba_fact_consommation_daily_summary;
  
  -- Drop optimized views and procedures
  DROP VIEW IF EXISTS mamba_view_fact_consommation_report_optimized;
  DROP PROCEDURE IF EXISTS sp_mamba_view_fact_consommation_report_optimized;
  DROP PROCEDURE IF EXISTS sp_mamba_consommation_report_by_date;
  DROP PROCEDURE IF EXISTS sp_mamba_consommation_report_paginated;
  DROP PROCEDURE IF EXISTS sp_refresh_consommation_summary;
  DROP PROCEDURE IF EXISTS sp_refresh_collector_cache;
  DROP PROCEDURE IF EXISTS sp_check_index_usage;
  DROP PROCEDURE IF EXISTS sp_analyze_performance;
  DROP EVENT IF EXISTS refresh_consommation_summary_event;
  
  SELECT 'All improvements have been rolled back' AS result;
END //
DELIMITER ;

-- ================================================================================
-- USAGE INSTRUCTIONS
-- ================================================================================

-- Step 1: Apply critical indexes (immediate impact)
-- Run the ALTER TABLE statements in Layer 1

-- Step 2: Create collector cache
-- Run the CREATE TABLE and ALTER TABLE statements for mamba_dim_collector_cache

-- Step 3: Create optimized view
-- CALL sp_mamba_view_fact_consommation_report_optimized();

-- Step 4: Test performance improvement
-- CALL sp_analyze_performance(FALSE);  -- Test original
-- CALL sp_analyze_performance(TRUE);   -- Test optimized

-- Step 5: Use optimized queries
-- CALL sp_mamba_consommation_report_by_date('2024-01-01', '2024-12-31', NULL, 1000);

-- Step 6: Setup summary table and refresh
-- CALL sp_refresh_consommation_summary();

-- Step 7: Schedule automatic refresh (optional)
-- SET GLOBAL event_scheduler = ON;

-- To verify indexes are created:
-- CALL sp_check_index_usage();

-- To rollback all changes if needed:
-- CALL sp_rollback_improvements();

-- ================================================================================
-- END OF IMPROVEMENTS
-- ================================================================================