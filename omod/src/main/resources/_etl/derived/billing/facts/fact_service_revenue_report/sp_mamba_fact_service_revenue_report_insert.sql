DELIMITER //

DROP PROCEDURE IF EXISTS sp_mamba_fact_service_revenue_report_insert;

CREATE PROCEDURE sp_mamba_fact_service_revenue_report_insert()

BEGIN

SET session group_concat_max_len = 20000;
SET @service_columns_case := NULL;
SET @service_columns_select := NULL;

-- Schema-driven CASE generation for srv subquery (reads actual table columns, not data)
-- Ensures CASE statements align with all columns in flat table,
-- including configured services with no billing data (will SUM to 0)
SELECT GROUP_CONCAT(DISTINCT
      CONCAT(
        'SUM(CASE WHEN psb.service_id = "', COLUMN_NAME,
        '" THEN (psb.paid_quantity * psb.unit_price) ELSE 0 END) AS `', COLUMN_NAME, '`'
     )
     ORDER BY CAST(COLUMN_NAME AS UNSIGNED) SEPARATOR ', ')
INTO @service_columns_case
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'mamba_fact_service_revenue_report_flat'
  AND COLUMN_NAME REGEXP '^[0-9]+$';

-- Generate column references for outer SELECT (srv.`123`, srv.`456`, ...)
SELECT GROUP_CONCAT(DISTINCT
      CONCAT('srv.`', COLUMN_NAME, '`')
      ORDER BY CAST(COLUMN_NAME AS UNSIGNED) SEPARATOR ', ')
INTO @service_columns_select
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'mamba_fact_service_revenue_report_flat'
  AND COLUMN_NAME REGEXP '^[0-9]+$';

SET @insert_stmt = CONCAT('INSERT INTO mamba_fact_service_revenue_report_flat
  SELECT
    NULL AS id,
    base.service_date,
    base.patient_name,
    base.patient_service_bill_id,
    srv.first_service_bill_id,
    srv.global_bill_id,
    srv.total_due,
    COALESCE(payments.total_paid, 0) AS total_paid',
    COALESCE(CONCAT(',\n    ', @service_columns_select), ''),
    '
  FROM (
    SELECT
      MIN(psb.patient_service_bill_id) as first_service_bill_id,
      cons.global_bill_id,
      SUM(psb.paid_quantity * psb.unit_price) AS total_due',
      COALESCE(CONCAT(',\n      ', @service_columns_case), ''),
      '
    FROM mamba_dim_patient_service_bill psb
    INNER JOIN mamba_dim_consommation cons ON psb.consommation_id = cons.consommation_id
    WHERE psb.service_id IS NOT NULL
      AND psb.voided = 0
    GROUP BY cons.global_bill_id
 ) AS srv
  LEFT JOIN (
    SELECT
      psb.patient_service_bill_id,
      cons.global_bill_id,
      psb.service_date,
      bps.person_name_long AS patient_name
    FROM mamba_dim_patient_service_bill psb
    INNER JOIN mamba_dim_consommation cons ON psb.consommation_id = cons.consommation_id
    INNER JOIN mamba_dim_beneficiary ben ON cons.beneficiary_id = ben.beneficiary_id
    INNER JOIN mamba_dim_person bps ON bps.person_id = ben.patient_id
    WHERE psb.voided = 0
  ) AS base
    ON srv.global_bill_id = base.global_bill_id
    AND srv.first_service_bill_id = base.patient_service_bill_id
  LEFT JOIN (
    SELECT
      cons.global_bill_id,
      SUM(bp.amount_paid) AS total_paid
    FROM mamba_dim_consommation cons
    INNER JOIN mamba_dim_bill_payment bp ON cons.patient_bill_id = bp.patient_bill_id
    GROUP BY cons.global_bill_id
  ) AS payments
    ON srv.global_bill_id = payments.global_bill_id;');

PREPARE inserttbl FROM @insert_stmt;
EXECUTE inserttbl;
DEALLOCATE PREPARE inserttbl;

END //

DELIMITER ;
