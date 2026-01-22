-- $BEGIN

  INSERT INTO mamba_dim_patient_account (patient_account_id,
                      patient_id,
                      balance,
                      creator,
                      created_date,
                      voided,
                      voided_by,
                      voided_date,
                      void_reason)
  SELECT patient_account_id,
      patient_id,
      balance,
      creator,
      created_date,
      voided,
      voided_by,
      voided_date,
      void_reason
  FROM mamba_source_db.moh_bill_patient_account;

-- $END