DELIMITER //

DROP PROCEDURE IF EXISTS sp_mamba_view_fact_insurance_report;

CREATE PROCEDURE sp_mamba_view_fact_insurance_report()

BEGIN

  SET session group_concat_max_len = 20000; 
  SET @insurance_report_columns := NULL;
  SET @imaging_report_columns := NULL;
  SET @proced_report_columns := NULL;

  SELECT GROUP_CONCAT(DISTINCT CONCAT('IFNULL (bill.`', hop_service_id, '`, 0) AS ', '`', column_name, '`') ORDER BY
            id ASC SEPARATOR ', ')
  INTO @insurance_report_columns
  FROM mamba_dim_billing_report_columns
  WHERE report_type = 'INSURANCE'
   AND group_column_name = 'INSURANCE';

  -- Imaging Columns TODO: improve this area
  SELECT (GROUP_CONCAT(DISTINCT CONCAT('IFNULL (bill.`', hop_service_id, '`, 0)') ORDER BY
             id ASC SEPARATOR ' + ')) AS 'group_column_name'
  INTO @imaging_report_columns
  FROM mamba_dim_billing_report_columns
  WHERE report_type = 'INSURANCE'
   AND group_column_name = 'IMAGING';

  -- Proceed Columns TODO: improve this area
  SELECT GROUP_CONCAT(DISTINCT CONCAT('IFNULL (bill.`', hop_service_id, '`, 0)') ORDER BY
            id ASC SEPARATOR ' + ')
  INTO @proced_report_columns
  FROM mamba_dim_billing_report_columns
  WHERE report_type = 'INSURANCE'
   AND group_column_name = 'PROCED.';

  SET @select_stmt = CONCAT('CREATE OR REPLACE VIEW mamba_view_fact_insurance_report AS
SELECT bill.first_closing_date_id,
      bill.admission_date,
      bill.closing_date,
      bill.beneficiary_name,
      bill.household_head_name,
      bill.family_code,
      bill.beneficiary_level,
      bill.card_number,
      bill.company_name,
      bill.age,
      bill.birth_date,
      bill.gender,
      bill.doctor_name,
      bill.insurance_id,
      bill.global_bill_id,
      bill.global_bill_identifier,
      ', COALESCE(@insurance_report_columns, 'NULL AS no_insurance_data'), ',
      (', COALESCE(@imaging_report_columns, '0'), ') AS `IMAGING`,
      (', COALESCE(@proced_report_columns, '0'), ') AS `PROCED.`
    FROM mamba_fact_patient_service_bill_flat bill;');

  PREPARE select_stmt FROM @select_stmt;
  EXECUTE select_stmt;
  DEALLOCATE PREPARE select_stmt;

END //

DELIMITER ;