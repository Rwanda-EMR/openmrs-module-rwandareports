-- $BEGIN

  CREATE TABLE mamba_dim_payment_refund
  (
    id       INT       NOT NULL AUTO_INCREMENT,
    refund_id    INT       NOT NULL,
    bill_payment_id INT       NOT NULL,
    amount_refunded DECIMAL(20, 2) NULL,
    refunded_by   INT       NULL,
    creator     INT       NOT NULL,
    created_date  DATETIME    NOT NULL,
    voided     SMALLINT    NOT NULL,
    voided_date   DATETIME    NULL,
    void_reason   VARCHAR(250)  NULL,
    voided_by    INT       NULL,

    PRIMARY KEY (id)
 );

  CREATE INDEX mamba_dim_payment_refund_refund_id_index
    ON mamba_dim_payment_refund (refund_id);

  CREATE INDEX mamba_dim_payment_refund_bill_payment_id_index
    ON mamba_dim_payment_refund (bill_payment_id);

  CREATE INDEX mamba_dim_payment_refund_refunded_by_index
    ON mamba_dim_payment_refund (refunded_by);

  CREATE INDEX mamba_dim_payment_refund_voided_index
    ON mamba_dim_payment_refund (voided);

-- $END
