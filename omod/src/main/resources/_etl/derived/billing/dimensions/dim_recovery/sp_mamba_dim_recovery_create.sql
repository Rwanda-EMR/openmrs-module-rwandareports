-- $BEGIN

  CREATE TABLE mamba_dim_recovery
  (
    id        INT             NOT NULL AUTO_INCREMENT,
    recovery_id    INT             NOT NULL,
    insurance_id   INT             NULL,
    third_party_id  INT             NULL,
    start_period   DATE             NOT NULL,
    end_period    DATE             NOT NULL,
    status      VARCHAR(50)         NOT NULL,
    due_amount    DECIMAL(20, 2)        NOT NULL,
    submission_date  DATE             NULL,
    verification_date DATE             NULL,
    paid_amount    DECIMAL(20, 2)        NULL,
    payement_date   DATE             NULL,
    partly_pay_reason VARCHAR(250)         NULL,
    no_payment_reason VARCHAR(250)         NULL,
    observation    VARCHAR(250)         NULL,
    creator      INT             NOT NULL,
    created_date   DATE             NOT NULL,
    changed_by    INT             NULL,
    retired      SMALLINT           NOT NULL,
    retired_by    INT             NULL,
    retire_date    DATE             NULL,
    retire_reason   VARCHAR(250)         NULL,

    PRIMARY KEY (id)
 );

  CREATE INDEX mamba_dim_recovery_recovery_id_index
    ON mamba_dim_recovery (recovery_id);

  CREATE INDEX mamba_dim_recovery_insurance_id_index
    ON mamba_dim_recovery (insurance_id);

  CREATE INDEX mamba_dim_recovery_third_party_id_index
    ON mamba_dim_recovery (third_party_id);

  CREATE INDEX mamba_dim_recovery_status_index
    ON mamba_dim_recovery (status);

-- $END
