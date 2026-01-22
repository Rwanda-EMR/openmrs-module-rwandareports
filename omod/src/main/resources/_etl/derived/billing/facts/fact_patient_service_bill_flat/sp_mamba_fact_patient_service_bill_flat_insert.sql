DELIMITER //

DROP PROCEDURE IF EXISTS sp_mamba_fact_patient_service_bill_flat_insert;

CREATE PROCEDURE sp_mamba_fact_patient_service_bill_flat_insert()
BEGIN

  SET session group_concat_max_len = 20000;
  SET @service_columns_case := NULL;

  -- Schema-driven CASE generation (reads actual table columns, not data)
  -- Ensures CASE statements align with all columns in flat table,
  -- including configured services with no billing data (will SUM to 0)
  SELECT GROUP_CONCAT(DISTINCT
            CONCAT('SUM(CASE WHEN hop_service_id = "', COLUMN_NAME,
                '" THEN service_bill_quantity*service_bill_unit_price ELSE 0 END) AS "',
                COLUMN_NAME, '"')
            ORDER BY CAST(COLUMN_NAME AS UNSIGNED))
  INTO @service_columns_case
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'mamba_fact_patient_service_bill_flat'
    AND COLUMN_NAME REGEXP '^[0-9]+$';

  -- TODO: see if first inserting into a sub-query table helps before joining. But also other reports that use hte service revenues but have different base columns can benefit from having a shared services revenue table instead of just sub-querying it here. It can just be a table of its own to be joined on
  SET @insert_stmt = CONCAT('INSERT INTO mamba_fact_patient_service_bill_flat
  SELECT
    b.insurance_id,
    b.global_bill_identifier,
    b.admission_date,
    b.closing_date,
    b.beneficiary_name,
    b.household_head_name,
    b.family_code,
    b.beneficiary_level,
    b.card_number,
    b.company_name,
    b.age,
    b.birth_date,
    b.gender,
    b.doctor_name,
    s.*
  FROM (
    SELECT MIN(id) as first_closing_date_id, global_bill_id, ', @service_columns_case, '
    FROM mamba_fact_patient_service_bill
    GROUP BY global_bill_id
 ) AS s
  LEFT JOIN mamba_fact_patient_service_bill b
    on s.global_bill_id = b.global_bill_id AND s.first_closing_date_id = b.id;');

  PREPARE inserttbl FROM @insert_stmt;
  EXECUTE inserttbl;
  DEALLOCATE PREPARE inserttbl;

END //

DELIMITER ;