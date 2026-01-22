-- $BEGIN

  INSERT INTO mamba_dim_transaction (transaction_id,
                    patient_account_id,
                    amount,
                    collector,
                    transaction_reason,
                    transaction_date,
                    creator,
                    created_date,
                    voided,
                    voided_date,
                    void_reason,
                    voided_by)

  SELECT transaction_id,
      patient_account_id,
      amount,
      collector,
      transaction_reason,
      transaction_date,
      creator,
      created_date,
      voided,
      voided_date,
      void_reason,
      voided_by
  FROM mamba_source_db.moh_bill_transaction ;

-- $END