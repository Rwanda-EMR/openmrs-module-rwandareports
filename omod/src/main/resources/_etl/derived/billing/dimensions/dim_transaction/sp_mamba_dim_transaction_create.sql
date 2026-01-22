-- $BEGIN

  CREATE TABLE mamba_dim_transaction
  (
    id         INT        NOT NULL AUTO_INCREMENT,
    transaction_id   INT        NOT NULL,
    patient_account_id INT        NOT NULL,
    amount       DECIMAL(20, 2)   NOT NULL,
    collector     INT        NOT NULL,
    transaction_reason VARCHAR(250)    NOT NULL,
    transaction_date  DATETIME      NOT NULL,
    creator      INT        NOT NULL,
    created_date    DATETIME      NOT NULL,
    voided       SMALLINT      NOT NULL,
    voided_date    DATETIME      NULL,
    void_reason    VARCHAR(250)    NULL,
    voided_by     INT        NULL,

    PRIMARY KEY (id)
 );

  CREATE INDEX mamba_dim_transaction_transaction_id_index
    ON mamba_dim_transaction (transaction_id);

  CREATE INDEX mamba_dim_transaction_patient_account_id_index
    ON mamba_dim_transaction (patient_account_id);

  CREATE INDEX mamba_dim_transaction_collector_index
    ON mamba_dim_transaction (collector);

  CREATE INDEX mamba_dim_transaction_voided_index
    ON mamba_dim_transaction (voided);

-- $END
