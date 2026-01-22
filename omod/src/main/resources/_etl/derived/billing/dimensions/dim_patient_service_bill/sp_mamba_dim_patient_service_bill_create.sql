-- $BEGIN

CREATE TABLE mamba_dim_patient_service_bill
(
    id                        INT            NOT NULL AUTO_INCREMENT,
    patient_service_bill_id   INT            NOT NULL,
    consommation_id           int            not null,
    billable_service_id       int            null,
    service_id                int            null,
    service_date              date           null,
    unit_price                decimal(20, 2) null default 0.00,
    quantity                  decimal(20, 2) null,
    paid_quantity             decimal(20, 2) null,
    service_other             varchar(100)   null,
    service_other_description varchar(250)   null,
    is_paid                   smallint       not null,
    drug_frequency            varchar(255)   null,
    item_type                 tinyint(1)     null,
    voided                    smallint       not null,
    created_date              DATETIME       null,

    PRIMARY KEY (id)
);


CREATE INDEX mamba_dim_patient_service_bill_patient_service_bill_id_index
    ON mamba_dim_patient_service_bill (patient_service_bill_id);

CREATE INDEX mamba_dim_patient_service_bill_consommation_id_index
    ON mamba_dim_patient_service_bill (consommation_id);

CREATE INDEX mamba_dim_patient_service_bill_billable_service_id_index
    ON mamba_dim_patient_service_bill (billable_service_id);

CREATE INDEX mamba_dim_patient_service_bill_service_id_index
    ON mamba_dim_patient_service_bill (service_id);

CREATE INDEX mamba_dim_patient_service_bill_voided_index
    ON mamba_dim_patient_service_bill (voided);

CREATE INDEX mamba_dim_patient_service_consommation_voided
    ON mamba_dim_patient_service_bill (consommation_id, voided);                                                                                                             

-- $END