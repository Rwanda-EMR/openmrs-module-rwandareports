-- $BEGIN

  INSERT INTO mamba_dim_deposit_payment (deposit_payment_id,
                    transaction_id,
                    creator,
                    created_date,
                    voided,
                    voided_date,
                    void_reason,
                    voided_by)
  SELECT deposit_payment_id,
      transaction_id,
      creator,
      created_date,
      voided,
      voided_date,
      void_reason,
      voided_by
  FROM mamba_source_db.moh_bill_deposit_payment;

-- $END