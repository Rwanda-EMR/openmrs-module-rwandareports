-- $BEGIN

INSERT INTO mamba_dim_insurance (insurance_id,
                 concept_id,
                 category,
                 name,
                 address,
                 phone,
                 created_date)
SELECT insurance_id,
    concept_id,
    category,
    name,
    address,
    phone,
    created_date
FROM mamba_source_db.moh_bill_insurance;

-- $END