DELIMITER //

DROP PROCEDURE IF EXISTS sp_mamba_view_fact_deposits_report;

CREATE PROCEDURE sp_mamba_view_fact_deposits_report()
BEGIN

SET SESSION group_concat_max_len = 20000;
-- Create or Replace View
SET @select_stmt =
    'CREATE OR REPLACE VIEW mamba_view_fact_deposits_report AS
      SELECT
        transaction_date date,
        username collector,
        mdp.person_name_short,
        mdt.amount,
        transaction_reason reason
      FROM mamba_dim_deposit_payment mddp
      LEFT JOIN mamba_dim_transaction mdt ON mdt.transaction_id = mddp.transaction_id
      LEFT JOIN mamba_dim_patient_account mdpa ON mdpa.patient_account_id = mdt.patient_account_id
      LEFT JOIN mamba_dim_person mdp ON mdp.person_id = mdpa.patient_id
      LEFT JOIN mamba_dim_users mdu ON mdu.user_id = mdt.collector;';

  -- Execute the dynamic SQL statement
  PREPARE select_stmt FROM @select_stmt;
  EXECUTE select_stmt;
  DEALLOCATE PREPARE select_stmt;

END //

DELIMITER ;