-- $BEGIN

INSERT INTO mamba_dim_patient_service_bill (patient_service_bill_id,
                      consommation_id,
                      billable_service_id,
                      service_id,
                      service_date,
                      unit_price,
                      quantity,
                      paid_quantity,
                      service_other,
                      service_other_description,
                      is_paid,
                      drug_frequency,
                      item_type,
                      voided,
                      created_date)

SELECT patient_service_bill_id,
    consommation_id,
    billable_service_id,
    service_id,
    service_date,
    unit_price,
    quantity,
    paid_quantity,
    service_other,
    service_other_description,
    is_paid,
    drug_frequency,
    item_type,
    voided,
    created_date
FROM mamba_source_db.moh_bill_patient_service_bill;

-- $END