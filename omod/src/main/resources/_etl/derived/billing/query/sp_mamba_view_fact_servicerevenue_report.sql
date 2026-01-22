DELIMITER //

DROP PROCEDURE IF EXISTS sp_mamba_view_fact_service_report;

CREATE PROCEDURE sp_mamba_view_fact_service_report()

BEGIN

  SET session group_concat_max_len = 20000;
  SET @servicerevenue_report_columns := NULL;
  SET @imaging_report_columns := NULL;
  SET @proced_report_columns := NULL;

  -- Individual Service Revenue Columns (non-aggregated services)
  SELECT GROUP_CONCAT(DISTINCT CONCAT('IFNULL (srv.`', hop_service_id, '`, 0) AS ', '`', column_name, '`') ORDER BY
            id ASC SEPARATOR ', ')
  INTO @servicerevenue_report_columns
  FROM mamba_dim_billing_report_columns
  WHERE report_type = 'SERVICE_REVENUE'
   AND group_column_name = 'SERVICE_REVENUE';

  -- Imaging Columns (aggregated into single IMAGING column)
  SELECT (GROUP_CONCAT(DISTINCT CONCAT('IFNULL (srv.`', hop_service_id, '`, 0)') ORDER BY
             id ASC SEPARATOR ' + ')) AS 'group_column_name'
  INTO @imaging_report_columns
  FROM mamba_dim_billing_report_columns
  WHERE report_type = 'SERVICE_REVENUE'
   AND group_column_name = 'IMAGING';

  -- Procedure Columns (aggregated into single PROCED. column)
  SELECT GROUP_CONCAT(DISTINCT CONCAT('IFNULL (srv.`', hop_service_id, '`, 0)') ORDER BY
            id ASC SEPARATOR ' + ')
  INTO @proced_report_columns
  FROM mamba_dim_billing_report_columns
  WHERE report_type = 'SERVICE_REVENUE'
   AND group_column_name = 'PROCED.';

  SET @select_stmt = CONCAT('CREATE OR REPLACE VIEW mamba_view_fact_service_report AS
SELECT srv.id,
      srv.global_bill_id,
      srv.service_date,
      srv.patient_name,
      -- srv.patient_service_bill_id,
      -- srv.first_service_bill_id,
      ', COALESCE(@servicerevenue_report_columns, 'NULL AS no_service_revenue_data'), ',
      srv.total_due,
      srv.total_paid
      -- (', COALESCE(@imaging_report_columns, '0'), ') AS `IMAGING`,
      -- (', COALESCE(@proced_report_columns, '0'), ') AS `PROCED.`
    FROM mamba_fact_service_revenue_report_flat srv;');

  PREPARE select_stmt FROM @select_stmt;
  EXECUTE select_stmt;
  DEALLOCATE PREPARE select_stmt;

END //

DELIMITER ;
