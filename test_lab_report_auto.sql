-- ================================================================================
-- Lab Results Report Query - AUTO-DETECT TEST VERSION
-- ================================================================================
-- This version automatically finds the correct IDs from your database
--
-- HOW TO RUN:
--   mysql -u root -p'4#edRmgaF+k?' openmrs < test_lab_report_auto.sql
--
-- OR manually:
--   mysql -u root -p'4#edRmgaF+k?'
--   USE openmrs;
--   source test_lab_report_auto.sql;
-- ================================================================================

-- Use the database (adjust if your database name is different)
USE openmrs;

-- Auto-detect order type ID for lab orders
SET @orderTypeId = (
    SELECT order_type_id
    FROM order_type
    WHERE name LIKE '%Lab%' OR name LIKE '%Test%'
    ORDER BY order_type_id ASC
    LIMIT 1
);

-- Auto-detect health facility attribute type ID
SET @healthFacilityTypeId = (
    SELECT person_attribute_type_id
    FROM person_attribute_type
    WHERE name LIKE '%Health%Facility%'
       OR name LIKE '%healthcenter%'
       OR name LIKE '%Location%'
    ORDER BY person_attribute_type_id ASC
    LIMIT 1
);

-- Set date range (last 12 months)
SET @startDate = DATE_SUB(CURDATE(), INTERVAL 12 MONTH);
SET @endDate = CURDATE();

-- No filters
SET @location = NULL;
SET @concept = NULL;

-- Show detected values
SELECT
    @orderTypeId AS 'Order Type ID',
    @healthFacilityTypeId AS 'Health Facility Type ID',
    @startDate AS 'Start Date',
    @endDate AS 'End Date';

-- ================================================================================
-- Main Query
-- ================================================================================

SELECT
    pi.identifier AS 'Identifier',
    pn.family_name AS 'Family name',
    pn.given_name AS 'Given name',
    TIMESTAMPDIFF(YEAR, p.birthdate, ods.date_activated) AS 'Age',
    p.gender AS 'Gender',
    l.name AS 'Patient Location',
    rl.name AS 'Result done at',
    DATE_FORMAT(ods.date_activated, '%Y-%m-%d') AS 'Sample date',
    ods.accession_number AS 'Sample Code',
    DATE_FORMAT(o.obs_datetime, '%Y-%m-%d %H:%i') AS 'Date of result',
    cn_exam.name AS 'Name',
    CONCAT_WS(',', cn_result.name, o.value_numeric, o.value_text) AS 'Result',
    -- *** NEW COLUMNS - THESE ARE WHAT WE ADDED ***
    COALESCE(CONCAT(prov_name.given_name, ' ', prov_name.family_name), '(No Provider)') AS 'Ordered By',
    COALESCE(CONCAT(result_user_name.given_name, ' ', result_user_name.family_name), '(Unknown User)') AS 'Result Entered By'
FROM orders ods
INNER JOIN obs o ON ods.order_id = o.order_id AND o.voided = 0
LEFT JOIN patient_identifier pi ON pi.patient_id = o.person_id
    AND pi.voided = 0
    AND pi.patient_identifier_id = (
        SELECT MIN(pi2.patient_identifier_id)
        FROM patient_identifier pi2
        WHERE pi2.patient_id = o.person_id AND pi2.voided = 0
    )
LEFT JOIN person_name pn ON pn.person_id = o.person_id
    AND pn.voided = 0
    AND pn.person_name_id = (
        SELECT MIN(pn2.person_name_id)
        FROM person_name pn2
        WHERE pn2.person_id = o.person_id AND pn2.voided = 0
    )
LEFT JOIN person p ON p.person_id = o.person_id AND p.voided = 0
LEFT JOIN person_attribute pa ON pa.person_id = o.person_id
    AND pa.person_attribute_type_id = @healthFacilityTypeId
    AND pa.voided = 0
LEFT JOIN location l ON l.location_id = pa.value
LEFT JOIN location rl ON rl.location_id = o.location_id
LEFT JOIN concept_name cn_exam ON cn_exam.concept_id = ods.concept_id
    AND cn_exam.voided = 0
    AND cn_exam.concept_name_id = (
        SELECT MIN(cn2.concept_name_id)
        FROM concept_name cn2
        WHERE cn2.concept_id = ods.concept_id AND cn2.voided = 0
    )
LEFT JOIN concept_name cn_result ON cn_result.concept_id = o.value_coded
    AND cn_result.voided = 0
    AND cn_result.concept_name_id = (
        SELECT MIN(cn2.concept_name_id)
        FROM concept_name cn2
        WHERE cn2.concept_id = o.value_coded AND cn2.voided = 0
    )
-- *** NEW: Provider who ordered ***
LEFT JOIN provider prov ON prov.provider_id = ods.orderer AND prov.retired = 0
LEFT JOIN person_name prov_name ON prov_name.person_id = prov.person_id
    AND prov_name.voided = 0
    AND prov_name.person_name_id = (
        SELECT MIN(pn3.person_name_id)
        FROM person_name pn3
        WHERE pn3.person_id = prov.person_id AND pn3.voided = 0
    )
-- *** NEW: User who entered result ***
LEFT JOIN users result_user ON result_user.user_id = o.creator
LEFT JOIN person_name result_user_name ON result_user_name.person_id = result_user.person_id
    AND result_user_name.voided = 0
    AND result_user_name.person_name_id = (
        SELECT MIN(run2.person_name_id)
        FROM person_name run2
        WHERE run2.person_id = result_user.person_id AND run2.voided = 0
    )
WHERE ods.order_type_id = @orderTypeId
  AND o.obs_datetime >= @startDate
  AND o.obs_datetime <= @endDate
  AND (@location IS NULL OR o.location_id = @location)
  AND (@concept IS NULL OR ods.concept_id = @concept)
  AND ods.voided = 0
  AND ods.concept_id NOT IN (SELECT concept_set FROM concept_set)
ORDER BY ods.date_activated DESC, o.obs_datetime DESC
LIMIT 20;

-- ================================================================================
-- Summary Stats
-- ================================================================================

SELECT
    COUNT(*) AS 'Total Lab Results',
    COUNT(DISTINCT ods.orderer) AS 'Unique Providers',
    COUNT(DISTINCT o.creator) AS 'Unique Result Enterers',
    SUM(CASE WHEN ods.orderer IS NULL THEN 1 ELSE 0 END) AS 'Orders without Provider',
    SUM(CASE WHEN o.creator IS NULL THEN 1 ELSE 0 END) AS 'Results without Creator'
FROM orders ods
INNER JOIN obs o ON ods.order_id = o.order_id AND o.voided = 0
WHERE ods.order_type_id = @orderTypeId
  AND o.obs_datetime >= @startDate
  AND o.obs_datetime <= @endDate
  AND ods.voided = 0;
