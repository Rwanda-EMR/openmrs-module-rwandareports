-- $BEGIN

INSERT INTO mamba_dim_service_category (service_category_id,
                    insurance_id,
                    department_id,
                    service_id,
                    name,
                    description,
                    price,
                    created_date)
SELECT service_category_id,
    insurance_id,
    department_id,
    service_id,
    name,
    description,
    price,
    created_date
FROM mamba_source_db.moh_bill_service_category;

-- $END