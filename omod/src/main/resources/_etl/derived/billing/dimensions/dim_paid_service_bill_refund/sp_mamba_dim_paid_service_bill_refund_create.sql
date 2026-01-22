-- $BEGIN

  CREATE TABLE mamba_dim_paid_service_bill_refund
  (
    service_bill_refund_id INT        NOT NULL,
    created_date      DATETIME      NOT NULL,
    refund_id       INT        NOT NULL,
    paid_item_id      INT        NOT NULL,
    refund_quantity    INT        NOT NULL,
    creator        INT        NOT NULL,
    refund_reason     VARCHAR(250)    NULL,
    is_approved      SMALLINT      NOT NULL,
    approval_date     DATETIME      NULL,
    approved_by      INT        NULL,
    is_declined      SMALLINT      NOT NULL,
    declining_note     VARCHAR(250)    NULL,
    decline_date      DATETIME      NULL,
    voided         SMALLINT      NOT NULL,
    voided_date      DATETIME      NULL,
    void_reason      VARCHAR(250)    NULL,
    voided_by       INT        NULL,

    PRIMARY KEY (service_bill_refund_id)
 );

  CREATE INDEX mamba_dim_paid_service_bill_refund_service_bill_refund_id_index
    ON mamba_dim_paid_service_bill_refund (service_bill_refund_id);

  CREATE INDEX mamba_dim_paid_service_bill_refund_paid_item_id_index
    ON mamba_dim_paid_service_bill_refund (paid_item_id);

  CREATE INDEX mamba_dim_paid_service_bill_refund_approved_by_index
    ON mamba_dim_paid_service_bill_refund (approved_by);

  CREATE INDEX mamba_dim_paid_service_bill_refund_voided_index
    ON mamba_dim_paid_service_bill_refund (voided);

-- $END
