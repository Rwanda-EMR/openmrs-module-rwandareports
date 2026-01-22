DELIMITER //

DROP PROCEDURE IF EXISTS sp_mamba_view_fact_consommation_report;

CREATE PROCEDURE sp_mamba_view_fact_consommation_report()
BEGIN

    SET SESSION group_concat_max_len = 20000;

    -- Create or Replace View
    SET @select_stmt =
            'CREATE OR REPLACE VIEW mamba_view_fact_consommation_report AS
              SELECT CAST(mdgb.created_date AS DATE) AS date,
            mdd.name,
            mdb.policy_id_number,
            mdc.global_bill_id,
            mdc.consommation_id,
            CONCAT(mdpn.given_name, '' '', mdpn.family_name) AS beneficiary,
            COALESCE(NULLIF(mdb.company, '' ''), ''None'') AS insurancename,
            mdgb.global_amount,
            (mdgb.global_amount * (100 - mdi.current_insurance_rate)) / 100 AS patientdue,
            (mdgb.global_amount * mdi.current_insurance_rate) / 100 AS insurancedue,
            mdbp.amount_paid AS paid_amount,
            mdpb.status AS bill_status,
            CASE WHEN mda.is_admitted = 1 THEN ''In-Patient'' ELSE ''Out-Patient'' END AS admission_type,
            CASE WHEN mdgb.closing_date IS NOT NULL THEN ''DISCHARGED'' ELSE ''NOT DISCHARGED'' END AS global_bill_status,
            CONCAT(c.given_name, '' '', c.family_name) AS collectorname
        FROM mamba_dim_consommation mdc
        LEFT JOIN mamba_dim_global_bill mdgb
               ON mdgb.global_bill_id = mdc.global_bill_id
        LEFT JOIN mamba_dim_department mdd
               ON mdc.department_id = mdd.department_id
        LEFT JOIN mamba_dim_beneficiary mdb
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
        LEFT JOIN (
            SELECT mdbp.collector,
                   mdpn.given_name,
                   mdpn.family_name
            FROM mamba_dim_bill_payment mdbp
            JOIN mamba_dim_person_name mdpn
                 ON mdbp.collector = mdpn.person_id
            GROUP BY mdbp.collector, mdpn.given_name, mdpn.family_name
        ) c
               ON c.collector = mdbp.collector;';

    -- Execute the dynamic SQL statement
    PREPARE select_stmt FROM @select_stmt;
    EXECUTE select_stmt;
    DEALLOCATE PREPARE select_stmt;

END //

DELIMITER ;