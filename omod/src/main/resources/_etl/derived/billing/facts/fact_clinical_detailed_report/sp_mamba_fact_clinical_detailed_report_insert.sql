-- $BEGIN

INSERT INTO mamba_fact_clinical_detailed_report(patient_id,
                                                given_name,
                                                family_name,
                                                household_name,
                                                gender,
                                                birth_date,
                                                age,
                                                age_at_encounter,
                                                weight,
                                                height,
                                                temperature,
                                                country,
                                                province,
                                                district,
                                                sector,
                                                cell,
                                                umudugudu,
                                                case_status,
                                                catchment_area,
                                                encounter_datetime,
                                                chief_complaint,
                                                treatment,
                                                provider_name,
                                                visit_type,
                                                primary_diagnosis,
                                                secondary_diagnosis,
                                                presumptive_diagnosis,
                                                admission_service,
                                                insurance,
                                                type_of_discharge,
                                                department,
                                                admission_date,
                                                insurance_id)

SELECT DISTINCT
       p.person_id                                           AS patient_id,
       pn.given_name                                         AS given_name,
       pn.family_name                                        AS family_name,
       ben.owner_name                                        AS household_name,
       p.gender                                              AS gender,
       p.birthdate                                           AS birth_date,
       TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE())           AS age,
       TIMESTAMPDIFF(YEAR, p.birthdate, e.encounter_datetime) AS age_at_encounter,

       -- Vitals from flat table (FAST!)
       vitals.weight                                         AS weight,
       vitals.height                                         AS height,
       vitals.temperature                                    AS temperature,

       -- Address info
       pa.country                                            AS country,
       pa.state_province                                     AS province,
       pa.county_district                                    AS district,
       pa.address3                                           AS sector,
       pa.address1                                           AS cell,
       pa.address2                                           AS umudugudu,

       -- Clinical data - already resolved in flat table
       diag.case_status                                      AS case_status,
       diag.catchment_area                                   AS catchment_area,

       e.encounter_datetime                                  AS encounter_datetime,

       -- Clinical data from diagnosis flat table (text fields)
       diag.chief_complaint                                  AS chief_complaint,
       diag.treatment                                        AS treatment,

       -- Provider info
       COALESCE(prov.name, CONCAT(prov_person_name.given_name, ' ', prov_person_name.family_name)) AS provider_name,

       -- Visit type
       vt.name                                               AS visit_type,

       -- Diagnoses - already resolved in flat table
       diag.main_diagnosis                                   AS primary_diagnosis,
       diag.secondary_diagnosis                              AS secondary_diagnosis,
       diag.presumptive_diagnosis                            AS presumptive_diagnosis,

       -- Billing/admission info (derived and joined)
       CASE adm.is_admitted
           WHEN 0 THEN 'OPD'
           WHEN 1 THEN 'IPD'
           ELSE NULL
       END                                                   AS admission_service,
       ins.name                                              AS insurance,
       CASE
           WHEN adm.discharging_date IS NOT NULL THEN 'DISCHARGED'
           WHEN adm.is_admitted = 0 THEN 'DISCHARGED'
           ELSE NULL
       END                                                   AS type_of_discharge,
       dept.name                                             AS department,
       adm.admission_date                                    AS admission_date,
       ins.insurance_id                                      AS insurance_id

FROM mamba_dim_person p
         INNER JOIN mamba_dim_person_name pn ON pn.person_id = p.person_id AND pn.preferred = 1
         LEFT JOIN mamba_dim_person_address pa ON pa.person_id = p.person_id AND pa.voided = 0 AND pa.preferred = 1
         LEFT JOIN mamba_dim_beneficiary ben ON ben.patient_id = p.person_id
         LEFT JOIN mamba_dim_insurance_policy isp ON ben.insurance_policy_id = isp.insurance_policy_id
         LEFT JOIN mamba_dim_insurance ins ON ins.insurance_id = isp.insurance_id
         LEFT JOIN mamba_dim_admission adm ON adm.insurance_policy_id = ben.insurance_policy_id
         LEFT JOIN mamba_dim_consommation cons ON cons.beneficiary_id = ben.beneficiary_id
         LEFT JOIN mamba_dim_department dept ON dept.department_id = cons.department_id

         -- Join encounters for each patient
         INNER JOIN mamba_dim_encounter e ON e.patient_id = p.person_id AND e.voided = 0

         -- *** FLAT TABLE JOINS (MUCH FASTER THAN 15+ obs JOINS!) ***

         -- Join vitals flat table by encounter_id
         LEFT JOIN mamba_flat_encounter_vital_signs vitals
             ON vitals.encounter_id = e.encounter_id

         -- Join diagnosis flat table by encounter_id
         LEFT JOIN mamba_flat_encounter_diagnosis diag
             ON diag.encounter_id = e.encounter_id

         -- *** PROVIDER AND VISIT INFO (from source tables) ***

         -- Join provider via encounter_provider bridge table
         LEFT JOIN mamba_source_db.encounter_provider ep ON ep.encounter_id = e.encounter_id AND ep.voided = 0
         LEFT JOIN mamba_source_db.provider prov ON prov.provider_id = ep.provider_id AND prov.retired = 0
         LEFT JOIN mamba_source_db.person_name prov_person_name
             ON prov_person_name.person_id = prov.person_id
             AND prov_person_name.voided = 0
             AND prov_person_name.preferred = 1

         -- Join visit and visit_type
         LEFT JOIN mamba_source_db.visit v ON v.visit_id = e.visit_id AND v.voided = 0
         LEFT JOIN mamba_source_db.visit_type vt ON vt.visit_type_id = v.visit_type_id AND vt.retired = 0

WHERE p.voided = 0;

-- $END
