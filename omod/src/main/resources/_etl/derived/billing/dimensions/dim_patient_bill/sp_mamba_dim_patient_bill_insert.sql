-- $BEGIN

INSERT INTO mamba_dim_patient_bill (patient_bill_id,
                  amount,
                  is_paid,
                  status)
SELECT patient_bill_id,
    amount,
    is_paid,
    status
FROM mamba_source_db.moh_bill_patient_bill;

-- $END