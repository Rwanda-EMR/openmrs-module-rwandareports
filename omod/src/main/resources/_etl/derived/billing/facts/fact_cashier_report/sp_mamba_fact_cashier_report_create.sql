-- $BEGIN

CREATE TABLE mamba_fact_cashier_report
(
    id               INT            NOT NULL AUTO_INCREMENT,
    bill_payment_id  INT            NOT NULL,
    patient_bill_id  INT            NULL,
    date             DATETIME       NULL,
    patient_name     VARCHAR(255)   NULL,
    amount_paid      DECIMAL(25, 2) NULL,
    hop_service_id   INT            NULL,
    global_bill_id   INT            NOT NULL,
    hop_service_name VARCHAR(50)    NULL,

    PRIMARY KEY (id)
);


CREATE INDEX mamba_fact_cashier_report_bill_payment_id_index
    ON mamba_fact_cashier_report (bill_payment_id);

CREATE INDEX mamba_fact_cashier_report_global_bill_id_index
    ON mamba_fact_cashier_report (global_bill_id);

CREATE INDEX mamba_fact_cashier_report_hop_service_id_index
    ON mamba_fact_cashier_report (hop_service_id);

CREATE INDEX mamba_fact_cashier_report_date_index
    ON mamba_fact_cashier_report (date);

CREATE INDEX mamba_fact_cashier_report_hop_service_name_index
    ON mamba_fact_cashier_report (hop_service_name);

CREATE INDEX idx_paid_service_bill_join ON mamba_dim_paid_service_bill (patient_service_bill_id, bill_payment_id);
CREATE INDEX idx_patient_service_bill_join ON mamba_dim_patient_service_bill (patient_service_bill_id, consommation_id, service_id, voided);
CREATE INDEX idx_consommation_join ON mamba_dim_consommation (consommation_id, global_bill_id, beneficiary_id);
CREATE INDEX idx_beneficiary_patient ON mamba_dim_beneficiary (beneficiary_id, patient_id);
CREATE INDEX idx_global_bill_closed ON mamba_dim_global_bill (global_bill_id, closed);

-- $END