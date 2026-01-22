-- $BEGIN

CREATE TABLE IF NOT EXISTS mamba_dim_consommation
(
  id         INT   NOT NULL AUTO_INCREMENT,
  consommation_id   INT   NOT NULL,
  global_bill_id   INT   NULL,
  department_id    INT   NULL,
  beneficiary_id   INT   NOT NULL,
  patient_bill_id   INT   NOT NULL,
  insurance_bill_id  INT   NULL,
  third_party_bill_id INT   NULL,
  created_date    DATETIME NOT NULL DEFAULT '1900-01-01 00:00:00',

  PRIMARY KEY (id)
);

CREATE INDEX mamba_dim_consommation_global_bill_id_index
  ON mamba_dim_consommation (global_bill_id);

CREATE INDEX mamba_dim_consommation_beneficiary_id_index
  ON mamba_dim_consommation (beneficiary_id);

CREATE INDEX mamba_dim_consommation_insurance_bill_id_index
  ON mamba_dim_consommation (insurance_bill_id);

CREATE INDEX mamba_dim_consommation_composite_bills_index
  ON mamba_dim_consommation (patient_bill_id, global_bill_id, beneficiary_id);

CREATE INDEX idx_consommation_dept
    ON mamba_dim_consommation (department_id, global_bill_id, beneficiary_id);

-- $END
