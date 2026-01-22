-- $BEGIN

-- =============================================================================
-- Validation Queries for mamba_dim_billing_report_columns
-- Purpose: Verify data integrity and correctness after insert operations
-- Usage: Run after executing sp_mamba_dim_billing_report_columns_insert.sql
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Verify Row Counts per Report Type
-- Expected Results:
--   CASHIER: 19 rows
--   INSURANCE: 18 rows
--   THIRDPARTY: 23 rows
-- -----------------------------------------------------------------------------
SELECT 'Row Counts per Report Type' AS validation_check;
SELECT
    report_type,
    COUNT(*) AS total_columns,
    SUM(CASE WHEN group_column_name IN ('IMAGING', 'PROCED.') THEN 1 ELSE 0 END) AS aggregated_services,
    SUM(CASE WHEN group_column_name NOT IN ('IMAGING', 'PROCED.') THEN 1 ELSE 0 END) AS individual_services
FROM mamba_dim_billing_report_columns
GROUP BY report_type
ORDER BY report_type;

-- -----------------------------------------------------------------------------
-- 2. Verify Grouping Distribution per Report Type
-- Shows how services are categorized within each report
-- -----------------------------------------------------------------------------
SELECT '' AS separator;
SELECT 'Grouping Distribution per Report Type' AS validation_check;
SELECT
    report_type,
    group_column_name,
    COUNT(*) AS service_count,
    GROUP_CONCAT(hop_service_id ORDER BY id SEPARATOR ',') AS service_ids
FROM mamba_dim_billing_report_columns
GROUP BY report_type, group_column_name
ORDER BY report_type,
    FIELD(group_column_name, 'INSURANCE', 'CASHIER', 'THIRDPARTY', 'IMAGING', 'PROCED.');

-- -----------------------------------------------------------------------------
-- 3. Verify Service Name Resolution
-- Check that all hop_service_id values have corresponding names
-- -----------------------------------------------------------------------------
SELECT '' AS separator;
SELECT 'Service Name Resolution Check' AS validation_check;
SELECT
    report_type,
    hop_service_id,
    column_name,
    group_column_name,
    CASE
        WHEN column_name IS NULL OR column_name = '' THEN 'MISSING NAME'
        ELSE 'OK'
    END AS name_status
FROM mamba_dim_billing_report_columns
ORDER BY report_type, id;

-- -----------------------------------------------------------------------------
-- 4. Check for Duplicate (report_type, hop_service_id) Combinations
-- Should return 0 rows if unique constraint is working
-- -----------------------------------------------------------------------------
SELECT '' AS separator;
SELECT 'Duplicate Report-Service Combinations Check' AS validation_check;
SELECT
    report_type,
    hop_service_id,
    COUNT(*) AS occurrence_count
FROM mamba_dim_billing_report_columns
GROUP BY report_type, hop_service_id
HAVING COUNT(*) > 1;

-- -----------------------------------------------------------------------------
-- 5. Verify Property Value Alignment
-- Compare inserted data with property values in global_property table
-- -----------------------------------------------------------------------------
SELECT '' AS separator;
SELECT 'Property Value Alignment Check' AS validation_check;

SET @insurance_columns = (SELECT property_value FROM mamba_source_db.global_property WHERE property = 'mohbilling.insuranceReportColumns');
SET @cashier_columns = (SELECT property_value FROM mamba_source_db.global_property WHERE property = 'mohbilling.cashierReportColumns');
SET @thirdparty_columns = (SELECT property_value FROM mamba_source_db.global_property WHERE property = 'mohbilling.thirdPartyReportColumns');

SELECT
    'INSURANCE' AS report_type,
    (SELECT COUNT(*) FROM mamba_dim_billing_report_columns WHERE report_type = 'INSURANCE') AS inserted_count,
    (LENGTH(@insurance_columns) - LENGTH(REPLACE(@insurance_columns, ',', '')) + 1) AS property_count,
    CASE
        WHEN (SELECT COUNT(*) FROM mamba_dim_billing_report_columns WHERE report_type = 'INSURANCE') =
             (LENGTH(@insurance_columns) - LENGTH(REPLACE(@insurance_columns, ',', '')) + 1)
        THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS status

UNION ALL

SELECT
    'CASHIER' AS report_type,
    (SELECT COUNT(*) FROM mamba_dim_billing_report_columns WHERE report_type = 'CASHIER') AS inserted_count,
    (LENGTH(@cashier_columns) - LENGTH(REPLACE(@cashier_columns, ',', '')) + 1) AS property_count,
    CASE
        WHEN (SELECT COUNT(*) FROM mamba_dim_billing_report_columns WHERE report_type = 'CASHIER') =
             (LENGTH(@cashier_columns) - LENGTH(REPLACE(@cashier_columns, ',', '')) + 1)
        THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS status

UNION ALL

SELECT
    'THIRDPARTY' AS report_type,
    (SELECT COUNT(*) FROM mamba_dim_billing_report_columns WHERE report_type = 'THIRDPARTY') AS inserted_count,
    (LENGTH(@thirdparty_columns) - LENGTH(REPLACE(@thirdparty_columns, ',', '')) + 1) AS property_count,
    CASE
        WHEN (SELECT COUNT(*) FROM mamba_dim_billing_report_columns WHERE report_type = 'THIRDPARTY') =
             (LENGTH(@thirdparty_columns) - LENGTH(REPLACE(@thirdparty_columns, ',', '')) + 1)
        THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS status;

-- -----------------------------------------------------------------------------
-- 6. Check for Orphaned Service References
-- Verify all hop_service_id values exist in mamba_dim_hop_service
-- -----------------------------------------------------------------------------
SELECT '' AS separator;
SELECT 'Orphaned Service References Check' AS validation_check;
SELECT
    rc.report_type,
    rc.hop_service_id,
    rc.column_name,
    'ORPHANED - Service not found in mamba_dim_hop_service' AS issue
FROM mamba_dim_billing_report_columns rc
LEFT JOIN mamba_dim_hop_service h ON rc.hop_service_id = h.service_id
WHERE h.service_id IS NULL;

-- -----------------------------------------------------------------------------
-- 7. Verify Index Existence
-- Check that performance indexes are created
-- -----------------------------------------------------------------------------
SELECT '' AS separator;
SELECT 'Index Existence Check' AS validation_check;
SELECT
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX,
    NON_UNIQUE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'mamba_dim_billing_report_columns'
ORDER BY INDEX_NAME, SEQ_IN_INDEX;

-- -----------------------------------------------------------------------------
-- 8. Sample Data Preview
-- Show first 5 rows per report type for visual verification
-- -----------------------------------------------------------------------------
SELECT '' AS separator;
SELECT 'Sample Data Preview (first 5 rows per report type)' AS validation_check;

(SELECT * FROM mamba_dim_billing_report_columns WHERE report_type = 'INSURANCE' ORDER BY id LIMIT 5)
UNION ALL
(SELECT * FROM mamba_dim_billing_report_columns WHERE report_type = 'CASHIER' ORDER BY id LIMIT 5)
UNION ALL
(SELECT * FROM mamba_dim_billing_report_columns WHERE report_type = 'THIRDPARTY' ORDER BY id LIMIT 5);

-- $END
