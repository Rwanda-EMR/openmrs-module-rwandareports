
DELIMITER //

DROP PROCEDURE IF EXISTS sp_mamba_view_fact_cashier_report;

CREATE PROCEDURE sp_mamba_view_fact_cashier_report()

BEGIN

  SET session group_concat_max_len = 20000;
  SET @cashier_report_columns := NULL;
  SET @imaging_report_columns := NULL;
  SET @proced_report_columns := NULL;

  -- Individual Cashier Columns (non-aggregated services)
  SELECT GROUP_CONCAT(DISTINCT CONCAT('IFNULL (cashier.`', hop_service_id, '`, 0) AS ', '`', column_name, '`') ORDER BY
            id ASC SEPARATOR ', ')
  INTO @cashier_report_columns
  FROM mamba_dim_billing_report_columns
  WHERE report_type = 'CASHIER'
   AND group_column_name = 'CASHIER';

  -- Imaging Columns (aggregated into single IMAGING column)
  SELECT (GROUP_CONCAT(DISTINCT CONCAT('IFNULL (cashier.`', hop_service_id, '`, 0)') ORDER BY
             id ASC SEPARATOR ' + ')) AS 'group_column_name'
  INTO @imaging_report_columns
  FROM mamba_dim_billing_report_columns
  WHERE report_type = 'CASHIER'
   AND group_column_name = 'IMAGING';

  -- Procedure Columns (aggregated into single PROCED. column)
  SELECT GROUP_CONCAT(DISTINCT CONCAT('IFNULL (cashier.`', hop_service_id, '`, 0)') ORDER BY
            id ASC SEPARATOR ' + ')
  INTO @proced_report_columns
  FROM mamba_dim_billing_report_columns
  WHERE report_type = 'CASHIER'
   AND group_column_name = 'PROCED.';

  SET @select_stmt = CONCAT('CREATE OR REPLACE VIEW mamba_view_fact_cashier_report AS
SELECT cashier.first_date_id,
      cashier.date,
      cashier.bill_payment_id,
      cashier.patient_bill_id,
      cashier.patient_name,
      cashier.global_bill_id,
      ', COALESCE(@cashier_report_columns, 'NULL AS no_cashier_data'), ',
      (', COALESCE(@imaging_report_columns, '0'), ') AS `IMAGING`,
      (', COALESCE(@proced_report_columns, '0'), ') AS `PROCED.`
    FROM mamba_fact_cashier_report_flat cashier;');

  PREPARE select_stmt FROM @select_stmt;
  EXECUTE select_stmt;
  DEALLOCATE PREPARE select_stmt;

END //

DELIMITER ;
