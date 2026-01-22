-- Optimized version using pre-calculated values from mamba_dim_bill_payment
-- All billing calculations (service_total_amount, patient_due, insurance_due, bill_status)
-- are now pre-calculated and stored in mamba_dim_bill_payment table via sp_mamba_dim_bill_payment_update.sql
-- This eliminates the need for temporary tables and runtime calculations

SELECT
    mdgb.created_date,
    mdd.name,
    mdb.policy_id_number,
    mdc.global_bill_id,
    mdc.consommation_id,
    CONCAT(mdpn.given_name, ' ', mdpn.family_name) AS beneficiary,
    mdi.name AS insurancename,
    
    -- All these values are now pre-calculated in mamba_dim_bill_payment
    mdbp.service_total_amount,
    mdbp.patient_due AS patientdue,
    mdbp.insurance_due AS insurancedue,
    COALESCE(mdbp.amount_paid, 0) AS paid_amount,
    mdbp.bill_status,

    CASE WHEN mda.is_admitted = 1 THEN 'In-Patient' ELSE 'Out-Patient' END AS admission_type,
    CASE WHEN mdgb.closing_date IS NOT NULL THEN 'DISCHARGED' ELSE 'NOT DISCHARGED' END AS global_bill_status,

    CONCAT(COALESCE(collector_names.given_name, ''), ' ', COALESCE(collector_names.family_name, '')) AS collectorname

FROM mamba_dim_consommation mdc
    INNER JOIN mamba_dim_bill_payment mdbp ON mdc.patient_bill_id = mdbp.patient_bill_id
    LEFT JOIN mamba_dim_global_bill mdgb ON mdgb.global_bill_id = mdc.global_bill_id
    LEFT JOIN mamba_dim_department mdd ON mdc.department_id = mdd.department_id
    LEFT JOIN mamba_dim_beneficiary mdb ON mdc.beneficiary_id = mdb.beneficiary_id
    INNER JOIN mamba_dim_person_name mdpn ON mdb.patient_id = mdpn.person_id
    LEFT JOIN mamba_dim_insurance_bill mdib ON mdc.insurance_bill_id = mdib.insurance_bill_id
    INNER JOIN mamba_dim_admission mda ON mda.insurance_policy_id = mdb.insurance_policy_id
    LEFT JOIN mamba_dim_insurance mdi ON mdgb.insurance_id = mdi.insurance_id
    LEFT JOIN (
        -- Pre-aggregate collector names to avoid repeated subquery execution
        SELECT
            mdbp.collector,
            mdpn.given_name,
            mdpn.family_name
        FROM mamba_dim_bill_payment mdbp
        INNER JOIN mamba_dim_person_name mdpn ON mdbp.collector = mdpn.person_id
        WHERE mdbp.collector IS NOT NULL
        GROUP BY mdbp.collector, mdpn.given_name, mdpn.family_name
    ) collector_names ON collector_names.collector = mdbp.collector;

-- Alternative version if you need DISTINCT (no temporary table needed)
-- All values are pre-calculated in mamba_dim_bill_payment
/*
SELECT DISTINCT
    mdgb.created_date,
    mdd.name,
    mdb.policy_id_number,
    mdc.global_bill_id,
    mdc.consommation_id,
    CONCAT(mdpn.given_name, ' ', mdpn.family_name) AS beneficiary,
    mdi.name AS insurancename,
    mdbp.service_total_amount,
    mdbp.patient_due AS patientdue,
    mdbp.insurance_due AS insurancedue,
    COALESCE(mdbp.amount_paid, 0) AS paid_amount,
    mdbp.bill_status,
    CASE WHEN mda.is_admitted = 1 THEN 'In-Patient' ELSE 'Out-Patient' END AS admission_type,
    CASE WHEN mdgb.closing_date IS NOT NULL THEN 'DISCHARGED' ELSE 'NOT DISCHARGED' END AS global_bill_status,
    CONCAT(COALESCE(collector_names.given_name, ''), ' ', COALESCE(collector_names.family_name, '')) AS collectorname
FROM mamba_dim_consommation mdc
    INNER JOIN mamba_dim_bill_payment mdbp ON mdc.patient_bill_id = mdbp.patient_bill_id
    -- ... rest of JOINs same as above
ORDER BY mdc.consommation_id, mdgb.created_date; -- Add ORDER BY for consistent results
*/