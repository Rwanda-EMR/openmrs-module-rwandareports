-- $BEGIN

INSERT INTO mamba_dim_beneficiary (beneficiary_id,
                  patient_id,
                  insurance_policy_id,
                  policy_id_number,
                  created_date,
                  creator,
                  owner_name,
                  owner_code,
                  level,
                  company)
SELECT beneficiary_id,
    patient_id,
    insurance_policy_id,
    policy_id_number,
    created_date,
    creator,
    owner_name,
    owner_code,
    level,
    company
FROM mamba_source_db.moh_bill_beneficiary;

-- $END