-- $BEGIN

INSERT INTO mamba_dim_insurance_rate (insurance_rate_id,
                   insurance_id,
                   rate,
                   flatFee,
                   start_date,
                   end_date,
                   created_date,
                   retired,
                   retire_date)
SELECT insurance_rate_id,
    insurance_id,
    rate,
    flatFee,
    start_date,
    end_date,
    created_date,
    retired,
    retire_date
FROM mamba_source_db.moh_bill_insurance_rate;

-- $END