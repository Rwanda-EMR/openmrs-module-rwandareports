-- $BEGIN

CREATE TABLE IF NOT EXISTS mamba_dim_bill_payment
(
    id                   INT            NOT NULL AUTO_INCREMENT,
    bill_payment_id      INT            NOT NULL,
    patient_bill_id      int            not null,
    amount_paid          decimal(20, 2) not null,
    date_received        DATETIME       null,
    collector            int            not null,
    bill_status          VARCHAR(20)    null,
    service_total_amount decimal(20, 2) null,
    insurance_rate       decimal(5, 2)  null,
    patient_due          decimal(20, 2) null,
    insurance_due        decimal(20, 2) null,
    created_date         DATETIME       null DEFAULT '1970-01-01 00:00:00',

    PRIMARY KEY (id)
);


CREATE INDEX mamba_dim_bill_payment_bill_payment_id_index
    ON mamba_dim_bill_payment (bill_payment_id);

CREATE INDEX mamba_dim_bill_payment_patient_bill_id_index
    ON mamba_dim_bill_payment (patient_bill_id);

CREATE INDEX mamba_dim_bill_payment_patient_collector_index
    ON mamba_dim_bill_payment (collector);

CREATE INDEX idx_billpayment_collector
    ON mamba_dim_bill_payment (collector, patient_bill_id, amount_paid);

CREATE INDEX idx_bill_payment_status
    ON mamba_dim_bill_payment (bill_status);

-- $END