-- $BEGIN

INSERT INTO mamba_dim_bill_payment (bill_payment_id,
                  patient_bill_id,
                  amount_paid,
                  date_received,
                  collector,
                  created_date)
SELECT bill_payment_id,
    patient_bill_id,
    amount_paid,
    date_received,
    collector,
    created_date
FROM mamba_source_db.moh_bill_payment;

-- $END