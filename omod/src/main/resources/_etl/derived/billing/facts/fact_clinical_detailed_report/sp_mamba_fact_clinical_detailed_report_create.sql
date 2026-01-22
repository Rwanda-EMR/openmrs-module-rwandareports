-- $BEGIN

CREATE TABLE mamba_fact_clinical_detailed_report
(
    id                    INT            NOT NULL AUTO_INCREMENT,
    patient_id            INT            NOT NULL,
    given_name            VARCHAR(255)   NULL,
    family_name           VARCHAR(255)   NULL,
    household_name        VARCHAR(255)   NULL,
    gender                CHAR(1)        NULL,
    birth_date            DATE           NULL,
    age                   INT            NULL,
    age_at_encounter      INT            NULL,
    weight                DECIMAL(25, 2) NULL,
    height                DECIMAL(25, 2) NULL,
    temperature           DECIMAL(25, 2) NULL,
    country               VARCHAR(255)   NULL,
    province              VARCHAR(255)   NULL,
    district              VARCHAR(255)   NULL,
    sector                VARCHAR(255)   NULL,
    cell                  VARCHAR(255)   NULL,
    umudugudu             VARCHAR(255)   NULL,
    case_status           VARCHAR(255)   NULL,
    catchment_area        VARCHAR(255)   NULL,
    encounter_datetime    DATETIME       NULL,
    chief_complaint       VARCHAR(2000)  NULL,
    treatment             VARCHAR(2000)  NULL,
    provider_name         VARCHAR(255)   NULL,
    visit_type            VARCHAR(255)   NULL,
    primary_diagnosis     VARCHAR(2000)  NULL,
    secondary_diagnosis   VARCHAR(2000)  NULL,
    presumptive_diagnosis VARCHAR(2000)  NULL,
    admission_service     VARCHAR(255)   NULL,
    insurance             VARCHAR(500)   NULL,
    type_of_discharge     VARCHAR(255)   NULL,
    department            VARCHAR(255)   NULL,
    admission_date        DATETIME       NULL,
    insurance_id          INT            NULL,

    PRIMARY KEY (id)
);


CREATE INDEX mamba_clinical_detailed_report_patient_id_index
    ON mamba_fact_clinical_detailed_report (patient_id);

CREATE INDEX mamba_clinical_detailed_report_insurance_id_index
    ON mamba_fact_clinical_detailed_report (insurance_id);

CREATE INDEX mamba_clinical_detailed_report_admission_date_index
    ON mamba_fact_clinical_detailed_report (admission_date);

-- $END