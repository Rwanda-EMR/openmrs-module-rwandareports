-- $BEGIN

  INSERT INTO mamba_dim_cash_payment (cash_payment_id,
                      creator,
                      created_date,
                      voided,
                      voided_date,
                      void_reason,
                      voided_by)
  SELECT cash_payment_id,
      creator,
      created_date,
      voided,
      voided_date,
      void_reason,
      voided_by
  FROM mamba_source_db.moh_bill_cash_payment;

-- $END