-- $BEGIN

INSERT INTO mamba_dim_third_party (third_party_id,
                  name,
                  rate,
                  created_date)
SELECT third_party_id,
    name,
    rate,
    created_date
FROM mamba_source_db.moh_bill_third_party;

-- $END