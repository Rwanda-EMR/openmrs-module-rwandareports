-- $BEGIN

-- =============================================================================
-- Comprehensive Insert for All Report Types
-- Populates: mamba_dim_billing_report_columns
-- Strategy: Service categorization with order preservation
-- Supports: INSURANCE, CASHIER, THIRDPARTY, SERVICE REVENUE report types
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Fetch Global Properties
-- -----------------------------------------------------------------------------
SET @insurance_columns = (
    SELECT property_value
    FROM mamba_source_db.global_property
    WHERE property = 'mohbilling.insuranceReportColumns'
);

SET @cashier_columns = (
    SELECT property_value
    FROM mamba_source_db.global_property
    WHERE property = 'mohbilling.cashierReportColumns'
);

SET @thirdparty_columns = (
    SELECT property_value
    FROM mamba_source_db.global_property
    WHERE property = 'mohbilling.thirdPartyReportColumns'
);

SET @servicerevenue_columns = (
    SELECT property_value
    FROM mamba_source_db.global_property
    WHERE property = 'mohbilling.servicesReportColumns'
);

SET @imaging_services = (
    SELECT property_value
    FROM mamba_source_db.global_property
    WHERE property = 'mohbilling.IMAGING'
);

SET @procedure_services = (
    SELECT property_value
    FROM mamba_source_db.global_property
    WHERE property = 'mohbilling.PROCEDURES'
);

-- -----------------------------------------------------------------------------
-- 2. Create Service Categorization Lookup (Reusable across all report types)
-- -----------------------------------------------------------------------------
DROP TEMPORARY TABLE IF EXISTS temp_service_categories;
CREATE TEMPORARY TABLE temp_service_categories AS
SELECT
    service_id,
    CASE
        WHEN FIND_IN_SET(service_id, @imaging_services) THEN 'IMAGING'
        WHEN FIND_IN_SET(service_id, @procedure_services) THEN 'PROCED.'
        ELSE NULL  -- Will be set to report_type during insert
    END AS service_category
FROM mamba_dim_hop_service
WHERE FIND_IN_SET(service_id, @imaging_services)
   OR FIND_IN_SET(service_id, @procedure_services);

-- -----------------------------------------------------------------------------
-- 3. Insert INSURANCE Report Columns
-- Expected: 18 rows (mohbilling.insuranceReportColumns)
-- Grouping: INSURANCE (individual), IMAGING (aggregate), PROCED. (aggregate)
-- -----------------------------------------------------------------------------
INSERT INTO mamba_dim_billing_report_columns
    (report_type, hop_service_id, column_name, group_column_name)
SELECT
    'INSURANCE' AS report_type,
    h.service_id AS hop_service_id,
    COALESCE(NULLIF(TRIM(h.name), ''), CONCAT('SERVICE_', h.service_id)) AS column_name,
    COALESCE(tsc.service_category, 'INSURANCE') AS group_column_name
FROM mamba_dim_hop_service h
LEFT JOIN temp_service_categories tsc ON h.service_id = tsc.service_id
WHERE FIND_IN_SET(h.service_id, @insurance_columns)
ORDER BY FIND_IN_SET(h.service_id, @insurance_columns);

-- -----------------------------------------------------------------------------
-- 4. Insert CASHIER Report Columns
-- Expected: 19 rows (mohbilling.cashierReportColumns)
-- Grouping: CASHIER (individual), IMAGING (aggregate), PROCED. (aggregate)
-- -----------------------------------------------------------------------------
INSERT INTO mamba_dim_billing_report_columns
    (report_type, hop_service_id, column_name, group_column_name)
SELECT
    'CASHIER' AS report_type,
    h.service_id AS hop_service_id,
    COALESCE(NULLIF(TRIM(h.name), ''), CONCAT('SERVICE_', h.service_id)) AS column_name,
    COALESCE(tsc.service_category, 'CASHIER') AS group_column_name
FROM mamba_dim_hop_service h
LEFT JOIN temp_service_categories tsc ON h.service_id = tsc.service_id
WHERE FIND_IN_SET(h.service_id, @cashier_columns)
ORDER BY FIND_IN_SET(h.service_id, @cashier_columns);

-- -----------------------------------------------------------------------------
-- 5. Insert THIRDPARTY Report Columns
-- Expected: 23 rows (mohbilling.thirdPartyReportColumns)
-- Grouping: THIRDPARTY (individual), IMAGING (aggregate), PROCED. (aggregate)
-- -----------------------------------------------------------------------------
INSERT INTO mamba_dim_billing_report_columns
    (report_type, hop_service_id, column_name, group_column_name)
SELECT
    'THIRDPARTY' AS report_type,
    h.service_id AS hop_service_id,
    COALESCE(NULLIF(TRIM(h.name), ''), CONCAT('SERVICE_', h.service_id)) AS column_name,
    COALESCE(tsc.service_category, 'THIRDPARTY') AS group_column_name
FROM mamba_dim_hop_service h
LEFT JOIN temp_service_categories tsc ON h.service_id = tsc.service_id
WHERE FIND_IN_SET(h.service_id, @thirdparty_columns)
ORDER BY FIND_IN_SET(h.service_id, @thirdparty_columns);

-- -----------------------------------------------------------------------------
-- 6. Insert SERVICE_REVENUE Report Columns
-- Expected: 18 rows (mohbilling.servicesReportColumns)
-- Grouping: SERVICE_REVENUE (individual), IMAGING (aggregate), PROCED. (aggregate)
-- -----------------------------------------------------------------------------
INSERT INTO mamba_dim_billing_report_columns
(report_type, hop_service_id, column_name, group_column_name)
SELECT
    'SERVICE_REVENUE' AS report_type,
    h.service_id AS hop_service_id,
    COALESCE(NULLIF(TRIM(h.name), ''), CONCAT('SERVICE_', h.service_id)) AS column_name,
    COALESCE(tsc.service_category, 'SERVICE_REVENUE') AS group_column_name
FROM mamba_dim_hop_service h
         LEFT JOIN temp_service_categories tsc ON h.service_id = tsc.service_id
WHERE FIND_IN_SET(h.service_id, @servicerevenue_columns)
ORDER BY FIND_IN_SET(h.service_id, @servicerevenue_columns);

-- -----------------------------------------------------------------------------
-- 7. Cleanup Temporary Objects
-- -----------------------------------------------------------------------------
DROP TEMPORARY TABLE IF EXISTS temp_service_categories;

-- $END