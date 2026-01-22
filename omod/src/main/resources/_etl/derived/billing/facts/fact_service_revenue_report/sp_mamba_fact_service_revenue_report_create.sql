DELIMITER //

DROP PROCEDURE IF EXISTS sp_mamba_fact_service_revenue_report_create;

CREATE PROCEDURE sp_mamba_fact_service_revenue_report_create()
BEGIN

SET session group_concat_max_len = 20000;
SET @service_columns := NULL;

-- Configuration-driven column generation (dimension + actual data)
-- Ensures all configured SERVICE_REVENUE services get columns,
-- even if no payment data exists yet (will default to 0.00)
SELECT GROUP_CONCAT(DISTINCT CONCAT('`', service_id, '` DECIMAL(25, 2) DEFAULT 0.00')
                    ORDER BY service_id)
INTO @service_columns
FROM (
  SELECT DISTINCT hop_service_id AS service_id
  FROM mamba_dim_billing_report_columns
  WHERE report_type = 'SERVICE_REVENUE'
  UNION
  SELECT DISTINCT service_id
  FROM mamba_dim_patient_service_bill
  WHERE service_id IS NOT NULL
) AS all_services;

IF @service_columns IS NULL THEN
    SET @create_table = CONCAT(
        'CREATE TABLE mamba_fact_service_revenue_report_flat (
          id                    INT         AUTO_INCREMENT PRIMARY KEY,
          service_date          DATE        NULL,
          patient_name          VARCHAR(255) NULL,
          patient_service_bill_id INT       NULL,
          first_service_bill_id INT         NOT NULL,
          global_bill_id        INT         NOT NULL,
          total_due             DECIMAL(25, 2) DEFAULT 0.00,
          total_paid            DECIMAL(25, 2) DEFAULT 0.00,

          -- Unique constraints
          CONSTRAINT uq_service_revenue_global_bill_null UNIQUE (global_bill_id),

          -- Indexes
          INDEX mamba_fact_service_revenue_flat_global_bill_index (global_bill_id),
          INDEX mamba_fact_service_revenue_flat_service_date_index (service_date),
          INDEX mamba_fact_service_revenue_flat_first_service_bill_id_index (first_service_bill_id))'
     );

ELSE
    SET @create_table = CONCAT(
        'CREATE TABLE mamba_fact_service_revenue_report_flat (
          id                    INT         AUTO_INCREMENT PRIMARY KEY,
          service_date          DATE        NULL,
          patient_name          VARCHAR(255) NULL,
          patient_service_bill_id INT       NULL,
          first_service_bill_id INT         NOT NULL,
          global_bill_id        INT         NOT NULL,
          total_due             DECIMAL(25, 2) DEFAULT 0.00,
          total_paid            DECIMAL(25, 2) DEFAULT 0.00,
          ', @service_columns, ',

        -- Unique constraints
        CONSTRAINT uq_service_revenue_global_bill UNIQUE (global_bill_id),

        -- Indexes
        INDEX mamba_fact_service_revenue_flat_global_bill_index (global_bill_id),
        INDEX mamba_fact_service_revenue_flat_service_date_index (service_date),
        INDEX mamba_fact_service_revenue_flat_first_service_bill_id_index (first_service_bill_id))'
     );
END IF;

DROP TABLE IF EXISTS mamba_fact_service_revenue_report_flat;

PREPARE createtb FROM @create_table;
EXECUTE createtb;
DEALLOCATE PREPARE createtb;

END //

DELIMITER ;
