DELIMITER //

DROP PROCEDURE IF EXISTS sp_mamba_fact_cashier_report_flat_create;

CREATE PROCEDURE sp_mamba_fact_cashier_report_flat_create()
BEGIN

SET session group_concat_max_len = 20000;
SET @service_columns := NULL;

-- Configuration-driven column generation (dimension + actual data)
-- Ensures all configured CASHIER services get columns,
-- even if no payment data exists yet (will default to 0.00)
SELECT GROUP_CONCAT(DISTINCT CONCAT('`', service_id, '` DECIMAL(25, 2) DEFAULT 0.00')
                    ORDER BY service_id)
INTO @service_columns
FROM (
  SELECT DISTINCT hop_service_id AS service_id
  FROM mamba_dim_billing_report_columns
  WHERE report_type = 'CASHIER'
  UNION
  SELECT DISTINCT hop_service_id AS service_id
  FROM mamba_fact_cashier_report
) AS all_services;

IF @service_columns IS NULL THEN
    SET @create_table = CONCAT(
        'CREATE TABLE mamba_fact_cashier_report_flat (
          bill_payment_id     INT       NOT NULL,
          patient_bill_id     INT       NULL,
          date          DATETIME    NULL,
          patient_name      VARCHAR(255)  NULL,
          first_date_id      INT       NOT NULL,
          global_bill_id     INT       NOT NULL,

          -- Unique constraints
          constraint global_bill_id unique (global_bill_id),

          -- Indexes
          INDEX mamba_fact_cashier_report_flat_global_bill_index (global_bill_id),
          INDEX mamba_fact_cashier_report_flat_date_index (date),
          INDEX mamba_fact_cashier_report_flat_bill_payment_id_index (bill_payment_id),
          INDEX mamba_fact_cashier_report_flat_first_first_date_id_index (first_date_id))'
     );

ELSE
    SET @create_table = CONCAT(
        'CREATE TABLE mamba_fact_cashier_report_flat (
          bill_payment_id     INT       NOT NULL,
          patient_bill_id     INT       NULL,
          date          DATETIME    NULL,
          patient_name      VARCHAR(255)  NULL,
          first_date_id      INT       NOT NULL,
          global_bill_id     INT       NOT NULL,
          ', @service_columns, ',

        -- Unique constraints
        constraint global_bill_id unique (global_bill_id),

        -- Indexes
        INDEX mamba_fact_cashier_report_flat_global_bill_index (global_bill_id),
        INDEX mamba_fact_cashier_report_flat_date_index (date),
        INDEX mamba_fact_cashier_report_flat_bill_payment_id_index (bill_payment_id),
        INDEX mamba_fact_cashier_report_flat_first_date_id_index (first_date_id))'
     );
END IF;

DROP TABLE IF EXISTS `mamba_fact_cashier_report_flat`;

PREPARE createtb FROM @create_table;
EXECUTE createtb;
DEALLOCATE PREPARE createtb;

END //

DELIMITER ;