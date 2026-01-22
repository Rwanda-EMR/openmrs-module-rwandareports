-- $BEGIN

INSERT INTO mamba_dim_consommation (consommation_id,
                  global_bill_id,
                  department_id,
                  beneficiary_id,
                  patient_bill_id,
                  insurance_bill_id,
                  third_party_bill_id,
                  created_date)
SELECT consommation_id,
    global_bill_id,
    department_id,
    beneficiary_id,
    patient_bill_id,
    insurance_bill_id,
    third_party_bill_id,
    created_date
FROM mamba_source_db.moh_bill_consommation;

-- $END