-- $BEGIN

  CREATE TABLE IF NOT EXISTS mamba_dim_deposit_payment
  (
    id         INT         NOT NULL AUTO_INCREMENT,
    deposit_payment_id INT         NOT NULL,
    transaction_id   INT         NOT NULL,
    creator       INT         NOT NULL,
    created_date    DATETIME      NOT NULL,
    voided       SMALLINT      NOT NULL,
    voided_date     DATETIME      NULL,
    void_reason     VARCHAR(250)    NULL,
    voided_by      INT         NULL,

    PRIMARY KEY (id)
   );

  CREATE INDEX mamba_dim_deposit_payment_deposit_payment_id_index
    ON mamba_dim_deposit_payment (deposit_payment_id);

  CREATE INDEX mamba_dim_deposit_payment_transaction_id_index
    ON mamba_dim_deposit_payment (transaction_id);



-- $END
