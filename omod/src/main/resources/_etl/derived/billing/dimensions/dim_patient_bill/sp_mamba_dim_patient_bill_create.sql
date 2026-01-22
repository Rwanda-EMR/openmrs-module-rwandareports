-- $BEGIN

CREATE TABLE mamba_dim_patient_bill
(
  id       INT      NOT NULL AUTO_INCREMENT,
  patient_bill_id INT      NOT NULL,
  amount     decimal(20, 2) not null,
  is_paid     smallint    null,
  status     varchar(150)  null,
  created_date  DATETIME    null,

  PRIMARY KEY (id)
);
  

CREATE INDEX mamba_dim_patient_bill_patient_bill_id_index
  ON mamba_dim_patient_bill (patient_bill_id);

CREATE INDEX idx_patientbill
    ON mamba_dim_patient_bill (patient_bill_id, status);

-- $END