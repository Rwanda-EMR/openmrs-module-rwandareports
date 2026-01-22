-- ================================================================================
-- Lab Results Report Query
-- ================================================================================
-- Description: Retrieves lab test results with patient demographics and location
-- Performance: Optimized with JOINs instead of correlated subqueries
-- MySQL Compatibility: Works with MySQL 5.x and above
-- Parameters:
--   :startDate  - Filter results from this date (inclusive)
--   :endDate    - Filter results to this date (inclusive)
--   :location   - Optional location filter (NULL = all locations)
--   :concept    - Optional exam type filter (NULL = all exam types)
--   Placeholders (replaced before execution):
--   {orderTypeId}            - Laboratory order type ID
--   {healthFacilityTypeId}   - Person attribute type ID for health facility
-- ================================================================================

SELECT
    pi.identifier AS 'Identifier',
    pn.family_name AS 'Family name',
    pn.given_name AS 'Given name',
    TIMESTAMPDIFF(
        YEAR,
        p.birthdate,
        ods.date_activated
    ) AS 'Age',
    p.gender AS 'Gender',
    l.name AS 'Patient Location',
    rl.name AS 'Result done at',
    ods.date_activated AS 'Sample date',
    ods.accession_number AS 'Sample Code',
    o.obs_datetime AS 'Date of result',
    cn_exam.name AS 'Name',
    CONCAT_WS(
        ',',
        cn_result.name,
        o.value_numeric,
        o.value_text
    ) AS 'Result',
    COALESCE(CONCAT(prov_name.given_name, ' ', prov_name.family_name), '') AS 'Ordered By',
    COALESCE(CONCAT(result_user_name.given_name, ' ', result_user_name.family_name), '') AS 'Result Entered By'
FROM orders ods

-- Join with observations (results)
INNER JOIN obs o ON ods.order_id = o.order_id AND o.voided = 0

-- Patient identification (deterministic: smallest patient_identifier_id)
LEFT JOIN patient_identifier pi ON pi.patient_id = o.person_id
AND pi.voided = 0
AND pi.patient_identifier_id = (
    SELECT MIN(pi2.patient_identifier_id)
    FROM patient_identifier pi2
    WHERE
        pi2.patient_id = o.person_id
        AND pi2.voided = 0
)

-- Patient demographics (deterministic: smallest person_name_id)
LEFT JOIN person_name pn ON pn.person_id = o.person_id
AND pn.voided = 0
AND pn.person_name_id = (
    SELECT MIN(pn2.person_name_id)
    FROM person_name pn2
    WHERE
        pn2.person_id = o.person_id
        AND pn2.voided = 0
)

-- Person details
LEFT JOIN person p ON p.person_id = o.person_id AND p.voided = 0

-- Patient location (health facility from person attributes)
LEFT JOIN person_attribute pa
  ON pa.person_id = o.person_id
  AND pa.person_attribute_type_id = {healthFacilityTypeId}
  AND pa.voided = 0
  AND pa.person_attribute_id = (
    SELECT MIN(pa2.person_attribute_id)
    FROM person_attribute pa2
    WHERE pa2.person_id = o.person_id
      AND pa2.person_attribute_type_id = {healthFacilityTypeId}
      AND pa2.voided = 0
  )

-- Location name for patient
LEFT JOIN location l ON l.location_id = pa.value

-- Result location
LEFT JOIN location rl ON rl.location_id = o.location_id

-- Concept name for exam (deterministic: smallest concept_name_id)
LEFT JOIN concept_name cn_exam ON cn_exam.concept_id = ods.concept_id
AND cn_exam.voided = 0
AND cn_exam.concept_name_id = (
    SELECT MIN(cn2.concept_name_id)
    FROM concept_name cn2
    WHERE
        cn2.concept_id = ods.concept_id
        AND cn2.voided = 0
)

-- Concept name for coded results (deterministic: smallest concept_name_id)
LEFT JOIN concept_name cn_result ON cn_result.concept_id = o.value_coded
AND cn_result.voided = 0
AND cn_result.concept_name_id = (
    SELECT MIN(cn2.concept_name_id)
    FROM concept_name cn2
    WHERE
        cn2.concept_id = o.value_coded
        AND cn2.voided = 0
)

-- Provider who ordered the test
LEFT JOIN provider prov
  ON prov.provider_id = ods.orderer
  AND prov.retired = 0

-- Provider's name (deterministic: smallest person_name_id)
LEFT JOIN person_name prov_name
  ON prov_name.person_id = prov.person_id
  AND prov_name.voided = 0
  AND prov_name.person_name_id = (
    SELECT MIN(pn3.person_name_id)
    FROM person_name pn3
    WHERE pn3.person_id = prov.person_id
      AND pn3.voided = 0
  )

-- User who entered the result
LEFT JOIN users result_user
  ON result_user.user_id = o.creator

-- Result enterer's name (deterministic: smallest person_name_id)
LEFT JOIN person_name result_user_name
  ON result_user_name.person_id = result_user.person_id
  AND result_user_name.voided = 0
  AND result_user_name.person_name_id = (
    SELECT MIN(run2.person_name_id)
    FROM person_name run2
    WHERE run2.person_id = result_user.person_id
      AND run2.voided = 0
  )

-- Filters

WHERE ods.order_type_id = {orderTypeId}
  AND o.obs_datetime >= :startDate
  AND o.obs_datetime <= :endDate
  AND (:location IS NULL OR o.location_id = :location)
  AND (:concept IS NULL OR ods.concept_id = :concept)
  AND ods.concept_id NOT IN (SELECT concept_set FROM concept_set)

ORDER BY ods.date_activated DESC, o.obs_datetime DESC