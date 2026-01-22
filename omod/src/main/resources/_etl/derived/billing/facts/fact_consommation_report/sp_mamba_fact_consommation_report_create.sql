-- $BEGIN

CREATE TABLE mamba_fact_consommation_report
(
    id                 INT            NOT NULL AUTO_INCREMENT,
    date               DATE           NULL,
    name               VARCHAR(255)   NULL,
    policy_id_number   VARCHAR(255)   NULL,
    global_bill_id     INT            NOT NULL,
    consommation_id    INT            NOT NULL,
    beneficiary        VARCHAR(500)   NULL,
    insurancename      VARCHAR(255)   NULL,
    global_amount      DECIMAL(25, 2) NULL,
    patientdue         DECIMAL(25, 2) NULL,
    insurancedue       DECIMAL(25, 2) NULL,
    paid_amount        DECIMAL(25, 2) NULL,
    bill_status        VARCHAR(50)    NULL,
    admission_type     VARCHAR(50)    NULL,
    global_bill_status VARCHAR(50)    NULL,
    collectorname      VARCHAR(500)   NULL,

    PRIMARY KEY (id)
);

-- Requested indexes on insurancename and date
CREATE INDEX mamba_fact_consommation_report_insurancename_index
    ON mamba_fact_consommation_report (insurancename);

CREATE INDEX mamba_fact_consommation_report_date_index
    ON mamba_fact_consommation_report (date);

-- Additional indexes for performance
CREATE INDEX mamba_fact_consommation_report_global_bill_id_index
    ON mamba_fact_consommation_report (global_bill_id);

CREATE INDEX mamba_fact_consommation_report_consommation_id_index
    ON mamba_fact_consommation_report (consommation_id);

CREATE INDEX mamba_fact_consommation_report_bill_status_index
    ON mamba_fact_consommation_report (bill_status);

-- $END