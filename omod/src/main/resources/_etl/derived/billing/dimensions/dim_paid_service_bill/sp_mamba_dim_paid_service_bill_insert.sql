-- $BEGIN

INSERT INTO mamba_dim_paid_service_bill (paid_service_bill_id,
                     bill_payment_id,
                     patient_service_bill_id,
                     paid_quantity,
                     voided,
                     created_date)
SELECT paid_service_bill_id,
    bill_payment_id,
    patient_service_bill_id,
    paid_quantity,
    voided,
    created_date
FROM mamba_source_db.moh_bill_paid_service_bill;

-- $END