-- $BEGIN

  INSERT INTO mamba_dim_payment_refund (refund_id,
                        bill_payment_id,
                        amount_refunded,
                        refunded_by,
                        creator,
                        created_date,
                        voided,
                        voided_date,
                        void_reason,
                        voided_by)

  SELECT refund_id,
      bill_payment_id,
      amount_refunded,
      refunded_by,
      creator,
      created_date,
      voided,
      voided_date,
      void_reason,
      voided_by
  FROM mamba_source_db.moh_bill_payment_refund;

-- $END