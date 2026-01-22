-- $BEGIN

INSERT INTO mamba_dim_insurance_policy (insurance_policy_id,
                    insurance_id,
                    third_party_id,
                    insurance_card_no,
                    owner,
                    coverage_start_date,
                    expiration_date,
                    created_date)
SELECT insurance_policy_id,
    insurance_id,
    third_party_id,
    insurance_card_no,
    owner,
    coverage_start_date,
    expiration_date,
    created_date
FROM mamba_source_db.moh_bill_insurance_policy;

-- $END