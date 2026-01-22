-- $BEGIN

  CREATE TABLE mamba_dim_patient_account
  (
    patient_account_id INT       NOT NULL,
    patient_id     INT       NOT NULL,
    balance      DECIMAL(20, 2)  NOT NULL,
    creator      INT       NOT NULL,
    created_date    DATETIME     NOT NULL,
    voided       TINYINT(1)    NOT NULL,
    voided_by     INT       NULL,
    voided_date    DATETIME     NULL,
    void_reason    VARCHAR(250)   NULL,

    PRIMARY KEY (patient_account_id)
 );


  CREATE INDEX mamba_dim_patient_account_patient_account_id_index
    ON mamba_dim_patient_account (patient_account_id);

  CREATE INDEX mamba_dim_patient_account_patient_id_index
    ON mamba_dim_patient_account (patient_id);

-- $END
