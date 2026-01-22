-- ================================================================================
-- Pathology Request Report Query
-- ================================================================================
-- Description: Retrieves pathology request encounters with patient demographics,
--              sample status, referral status, and associated results
-- Performance: Optimized with JOINs instead of correlated subqueries
-- MySQL Compatibility: Works with MySQL 5.x and above
-- Parameters:
--   :location   - Optional location filter (NULL = all locations)
-- Placeholders (replaced before execution):
--   {telephoneNumberConceptId}     - Telephone number concept ID
--   {sampleStatusConceptId}        - Sample status concept ID
--   {referralStatusConceptId}      - Referral status concept ID
--   {sampleDropOffConceptId}       - Sample drop-off concept ID
--   {pathologyRequestEncounterUuidConceptId} - Pathology request encounter UUID concept ID
--   {pathologyResultsApprovedConceptId}     - Pathology results approved concept ID
--   {pathologicDiagnosisConceptId} - Pathologic diagnosis concept ID
--   {healthCenterAttributeTypeId}  - Person attribute type ID for health center
--   {pathologyRequestFormId}       - Pathology request form ID
-- ================================================================================

SELECT
    p.person_id AS personId,
    p.uuid AS patientUuid,
    p.birthdate AS personBirthdate,
    p.gender AS personGender,

    -- Patient name (deterministic: smallest person_name_id with preferred=1)
    pn.family_name AS family_name,
    pn.family_name2 AS family_name2,
    pn.middle_name AS middle_name,
    pn.given_name AS given_name,

    -- Patient identifier (IMB Primary Care)
    pi.identifier AS IMBPrimaryCare,

    -- Patient phone number (latest observation)
    phone_obs.value_text AS patientPhoneNumber,

    -- Patient health center
    healthcenter.name AS patientHealthCenter,

    -- Encounter details
    enc.encounter_id AS encounterId,
    enc.uuid AS encounterUuid,
    DATE_FORMAT(enc.encounter_datetime, '%Y/%m/%d') AS encounterDatetime,

    -- Sample status observation
    sample_status_cn.name AS sampleStatusObs,
    sample_status_obs.uuid AS sampleStatusObsUuid,

    -- Referral status observation
    referral_status_cn.name AS referralStatusObs,
    referral_status_obs.uuid AS referralStatusObsUuid,

    -- Sample drop-off observation
    sample_dropoff_cn.name AS sampleDropoffObs,
    sample_dropoff_obs.uuid AS sampleDropoffObsUuid,

    -- Results encounter details
    results_link_obs.encounter_id AS resultsEncounterId,
    results_enc.uuid AS resultsEncounterUuid,

    -- Approval details
    CONCAT(
        approval_user_name.given_name, '  ',
        approval_user_name.family_name, ' On: ',
        DATE_FORMAT(approval_obs.date_created, '%d/%m/%Y')
    ) AS approvedBy,
    approval_obs.uuid AS approvalObsUuid,
    DATE_FORMAT(approval_obs.date_created, '%Y/%m/%d') AS approvedDate,

    -- Pathologic diagnosis (grouped)
    pathologic_diagnosis_names AS pathologicDiagnosisObs

FROM encounter enc

-- Person details
LEFT JOIN person p ON enc.patient_id = p.person_id
    AND p.voided = 0
    AND p.dead = 0

-- Patient name (deterministic: preferred=1, smallest person_name_id)
LEFT JOIN person_name pn ON pn.person_id = enc.patient_id
    AND pn.voided = 0
    AND pn.preferred = 1
    AND pn.person_name_id = (
        SELECT MIN(pn2.person_name_id)
        FROM person_name pn2
        WHERE pn2.person_id = enc.patient_id
            AND pn2.voided = 0
            AND pn2.preferred = 1
    )

-- Patient identifier (IMB Primary Care Registration ID)
LEFT JOIN patient_identifier pi ON pi.patient_id = enc.patient_id
    AND pi.voided = 0
    AND pi.identifier_type = (
        SELECT patient_identifier_type_id
        FROM patient_identifier_type
        WHERE name = 'IMB Primary Care Registration ID'
        LIMIT 1
    )
    AND pi.patient_identifier_id = (
        SELECT MIN(pi2.patient_identifier_id)
        FROM patient_identifier pi2
        JOIN patient_identifier_type pit ON pi2.identifier_type = pit.patient_identifier_type_id
        WHERE pi2.patient_id = enc.patient_id
            AND pi2.voided = 0
            AND pit.name = 'IMB Primary Care Registration ID'
    )

-- Patient phone number (latest observation)
LEFT JOIN obs phone_obs ON phone_obs.person_id = enc.patient_id
    AND phone_obs.concept_id = {telephoneNumberConceptId}
    AND phone_obs.voided = 0
    AND phone_obs.obs_id = (
        SELECT MAX(phone2.obs_id)
        FROM obs phone2
        WHERE phone2.person_id = enc.patient_id
            AND phone2.concept_id = {telephoneNumberConceptId}
            AND phone2.voided = 0
    )

-- Patient health center location
LEFT JOIN (
    SELECT
        pa.person_id,
        l.name,
        l.location_id
    FROM person_attribute pa
    LEFT JOIN location l ON pa.value = l.location_id
    WHERE pa.person_attribute_type_id = {healthCenterAttributeTypeId}
        AND pa.voided = 0
    GROUP BY pa.person_id
) healthcenter ON enc.patient_id = healthcenter.person_id

-- Sample status observation (latest for this encounter)
LEFT JOIN obs sample_status_obs ON sample_status_obs.encounter_id = enc.encounter_id
    AND sample_status_obs.concept_id = {sampleStatusConceptId}
    AND sample_status_obs.voided = 0
    AND sample_status_obs.obs_id = (
        SELECT MAX(ss2.obs_id)
        FROM obs ss2
        WHERE ss2.encounter_id = enc.encounter_id
            AND ss2.concept_id = {sampleStatusConceptId}
            AND ss2.voided = 0
    )

LEFT JOIN concept_name sample_status_cn ON sample_status_cn.concept_id = sample_status_obs.value_coded
    AND sample_status_cn.voided = 0
    AND sample_status_cn.locale = 'en'
    AND sample_status_cn.concept_name_type = 'FULLY_SPECIFIED'

-- Referral status observation (latest for this encounter)
LEFT JOIN obs referral_status_obs ON referral_status_obs.encounter_id = enc.encounter_id
    AND referral_status_obs.concept_id = {referralStatusConceptId}
    AND referral_status_obs.voided = 0
    AND referral_status_obs.obs_id = (
        SELECT MAX(rs2.obs_id)
        FROM obs rs2
        WHERE rs2.encounter_id = enc.encounter_id
            AND rs2.concept_id = {referralStatusConceptId}
            AND rs2.voided = 0
    )

LEFT JOIN concept_name referral_status_cn ON referral_status_cn.concept_id = referral_status_obs.value_coded
    AND referral_status_cn.voided = 0
    AND referral_status_cn.locale = 'en'
    AND referral_status_cn.concept_name_type = 'FULLY_SPECIFIED'

-- Sample drop-off observation (latest for this encounter)
LEFT JOIN obs sample_dropoff_obs ON sample_dropoff_obs.encounter_id = enc.encounter_id
    AND sample_dropoff_obs.concept_id = {sampleDropOffConceptId}
    AND sample_dropoff_obs.voided = 0
    AND sample_dropoff_obs.obs_id = (
        SELECT MAX(sd2.obs_id)
        FROM obs sd2
        WHERE sd2.encounter_id = enc.encounter_id
            AND sd2.concept_id = {sampleDropOffConceptId}
            AND sd2.voided = 0
    )

LEFT JOIN concept_name sample_dropoff_cn ON sample_dropoff_cn.concept_id = sample_dropoff_obs.value_coded
    AND sample_dropoff_cn.voided = 0
    AND sample_dropoff_cn.locale = 'en'
    AND sample_dropoff_cn.concept_name_type = 'FULLY_SPECIFIED'

-- Results encounter link (observation pointing to results encounter)
LEFT JOIN obs results_link_obs ON results_link_obs.concept_id = {pathologyRequestEncounterUuidConceptId}
    AND results_link_obs.value_text = enc.uuid
    AND results_link_obs.voided = 0
    AND results_link_obs.obs_id = (
        SELECT MAX(rl2.obs_id)
        FROM obs rl2
        WHERE rl2.concept_id = {pathologyRequestEncounterUuidConceptId}
            AND rl2.value_text = enc.uuid
            AND rl2.voided = 0
    )

LEFT JOIN encounter results_enc ON results_enc.encounter_id = results_link_obs.encounter_id

-- Approval observation (from results encounter)
LEFT JOIN obs approval_obs ON approval_obs.encounter_id = results_link_obs.encounter_id
    AND approval_obs.concept_id = {pathologyResultsApprovedConceptId}
    AND approval_obs.voided = 0
    AND approval_obs.obs_id = (
        SELECT MAX(app2.obs_id)
        FROM obs app2
        WHERE app2.encounter_id = results_link_obs.encounter_id
            AND app2.concept_id = {pathologyResultsApprovedConceptId}
            AND app2.voided = 0
    )

-- Approval user details
LEFT JOIN users approval_user ON approval_user.user_id = approval_obs.creator
LEFT JOIN person_name approval_user_name ON approval_user_name.person_id = approval_user.person_id
    AND approval_user_name.voided = 0
    AND approval_user_name.person_name_id = (
        SELECT MIN(aun2.person_name_id)
        FROM person_name aun2
        WHERE aun2.person_id = approval_user.person_id
            AND aun2.voided = 0
    )

-- Pathologic diagnosis (grouped, from results encounter)
LEFT JOIN (
    SELECT
        pd.encounter_id,
        GROUP_CONCAT(DISTINCT cn.name) AS pathologic_diagnosis_names
    FROM obs pd
    LEFT JOIN concept_name cn ON cn.concept_id = pd.value_coded
        AND cn.voided = 0
        AND cn.locale = 'en'
        AND cn.concept_name_type = 'FULLY_SPECIFIED'
    WHERE pd.concept_id = {pathologicDiagnosisConceptId}
        AND pd.voided = 0
    GROUP BY pd.encounter_id
) pathologic_diagnosis ON pathologic_diagnosis.encounter_id = results_link_obs.encounter_id

-- Filters
WHERE enc.voided = 0
    AND enc.form_id = {pathologyRequestFormId}
    AND (:location IS NULL OR healthcenter.location_id = :location)

ORDER BY enc.encounter_id DESC
