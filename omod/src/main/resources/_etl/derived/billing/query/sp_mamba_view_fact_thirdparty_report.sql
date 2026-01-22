-- =============================================================================
-- Third Party Report View Generator
-- =============================================================================
-- Purpose: Creates view with comprehensive third party billing calculations
--
-- IMPORTANT NOTES:
-- 1. This view is part of the NEW SQL-based reporting architecture
-- 2. Current Java controller (MohBillingThirdPartyReportController) still uses
--    old model-based approach and does NOT query this view
-- 3. Future migration: Controller should query this view directly instead of
--    using Java-based calculations
--
-- BUG FIXES:
-- - Fixed critical bug where third_party_amount was miscalculated
--   OLD: Used (100 - insurance_rate) formula - actually calculated PATIENT amount!
--   NEW: Uses actual third_party rate from database
-- - Added separate patient_amount column with correct formula
-- - Fixed typo: insurace_rate → insurance_rate
--
-- BUSINESS LOGIC:
-- - Total bill = Insurance amount + Third party amount + Patient amount
-- - Rate formula: insurance_rate + third_party_rate + patient_rate = 100%
-- - LEFT JOIN on third_party handles policies without third party (rate = 0)
--
-- =============================================================================

DELIMITER //

DROP PROCEDURE IF EXISTS sp_mamba_view_fact_thirdparty_report;

CREATE PROCEDURE sp_mamba_view_fact_thirdparty_report()

BEGIN

  SET session group_concat_max_len = 20000;
  SET @thirdparty_report_columns := NULL;
  SET @imaging_report_columns := NULL;
  SET @proced_report_columns := NULL;

  -- Individual ThirdParty Columns (non-aggregated services)
  SELECT GROUP_CONCAT(DISTINCT CONCAT('IFNULL (bill.`', hop_service_id, '`, 0) AS ', '`', column_name, '`') ORDER BY
            id ASC SEPARATOR ', ')
  INTO @thirdparty_report_columns
  FROM mamba_dim_billing_report_columns
  WHERE report_type = 'THIRDPARTY'
   AND group_column_name = 'THIRDPARTY';

  -- Imaging Columns (aggregated into single IMAGING column)
  SELECT (GROUP_CONCAT(DISTINCT CONCAT('IFNULL (bill.`', hop_service_id, '`, 0)') ORDER BY
             id ASC SEPARATOR ' + ')) AS 'group_column_name'
  INTO @imaging_report_columns
  FROM mamba_dim_billing_report_columns
  WHERE report_type = 'THIRDPARTY'
   AND group_column_name = 'IMAGING';

  -- Procedure Columns (aggregated into single PROCED. column)
  SELECT GROUP_CONCAT(DISTINCT CONCAT('IFNULL (bill.`', hop_service_id, '`, 0)') ORDER BY
            id ASC SEPARATOR ' + ')
  INTO @proced_report_columns
  FROM mamba_dim_billing_report_columns
  WHERE report_type = 'THIRDPARTY'
   AND group_column_name = 'PROCED.';

  SET @select_stmt = CONCAT('CREATE OR REPLACE VIEW mamba_view_fact_thirdparty_report AS
      SELECT bill.first_closing_date_id,
          bill.admission_date,
          bill.card_number,
          bill.age,
          bill.gender,
          bill.beneficiary_name,
          bill.company_name,
          -- Rate percentages (must sum to 100)
          c.rate AS insurance_rate,
          COALESCE(tp.rate, 0) AS third_party_rate,  -- NULL-safe: 0 when no third party
          (100 - c.rate - COALESCE(tp.rate, 0)) AS patient_rate,  -- Remaining percentage',
          -- Service columns (dynamically generated from configuration)
          COALESCE(@thirdparty_report_columns, 'NULL AS no_thirdparty_data'), ',
          (', COALESCE(@imaging_report_columns, '0'), ') AS IMAGING,
          (', COALESCE(@proced_report_columns, '0'), ') AS PROCED,
          -- Amount calculations (split by payer)
          d.amount AS amount_100_percent,
          (d.amount * c.rate / 100) AS insurance_amount,
          (d.amount * COALESCE(tp.rate, 0) / 100) AS third_party_amount,  -- FIX: Now uses actual tp.rate
          (d.amount * (100 - c.rate - COALESCE(tp.rate, 0)) / 100) AS patient_amount  -- NEW: Correct patient calculation
      FROM mamba_fact_patient_service_bill_flat bill
      INNER JOIN mamba_dim_consommation b ON bill.global_bill_id = b.global_bill_id
      INNER JOIN mamba_dim_patient_bill d ON d.patient_bill_id = b.patient_bill_id
      INNER JOIN mamba_dim_insurance_rate c ON bill.insurance_id = c.insurance_id
      -- NEW: JOIN chain to retrieve third party rate
      INNER JOIN mamba_dim_beneficiary ben ON b.beneficiary_id = ben.beneficiary_id
      INNER JOIN mamba_dim_insurance_policy ipol ON ben.insurance_policy_id = ipol.insurance_policy_id
      LEFT JOIN mamba_dim_third_party tp ON ipol.third_party_id = tp.third_party_id;  -- LEFT: Not all policies have third party'
  );

  PREPARE select_stmt FROM @select_stmt;
  EXECUTE select_stmt;
  DEALLOCATE PREPARE select_stmt;

END //

DELIMITER ;
