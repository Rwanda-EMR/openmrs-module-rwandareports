-- $BEGIN

-- Create temporary table to hold all calculated billing values
DROP TEMPORARY TABLE IF EXISTS mamba_tmp_bill_totals;
CREATE TEMPORARY TABLE mamba_tmp_bill_totals
(
    patient_bill_id      BIGINT PRIMARY KEY,
    service_total_amount DECIMAL(20, 2) NOT NULL,
    insurance_rate       DECIMAL(5, 2),
    patient_due          DECIMAL(20, 2),
    insurance_due        DECIMAL(20, 2),
    INDEX idx_patient_bill (patient_bill_id)
);

-- Populate temporary table with aggregated service amounts and calculated values
-- This only includes bills that have associated service bills
INSERT INTO mamba_tmp_bill_totals (patient_bill_id, service_total_amount, insurance_rate, patient_due, insurance_due)
SELECT mdc.patient_bill_id,
       COALESCE(SUM(COALESCE(mpsb.unit_price, 0) * COALESCE(mpsb.quantity, 0)), 0) AS service_total_amount,
       MAX(COALESCE(mdi.current_insurance_rate, 0))                                AS insurance_rate,
       ROUND(COALESCE(SUM(COALESCE(mpsb.unit_price, 0) * COALESCE(mpsb.quantity, 0)), 0) *
             (100 - MAX(COALESCE(mdi.current_insurance_rate, 0))) * 0.01, 2)       AS patient_due,
       ROUND(COALESCE(SUM(COALESCE(mpsb.unit_price, 0) * COALESCE(mpsb.quantity, 0)), 0) *
             MAX(COALESCE(mdi.current_insurance_rate, 0)) * 0.01, 2)               AS insurance_due
FROM mamba_dim_consommation mdc
         INNER JOIN mamba_dim_patient_service_bill mpsb ON mpsb.consommation_id = mdc.consommation_id
         LEFT JOIN mamba_dim_global_bill mdgb ON mdgb.global_bill_id = mdc.global_bill_id
         LEFT JOIN mamba_dim_insurance mdi ON mdgb.insurance_id = mdi.insurance_id
WHERE mpsb.voided = 0
GROUP BY mdc.patient_bill_id;

-- Step 1: Update bills that have service records
UPDATE mamba_dim_bill_payment mdbp
    INNER JOIN mamba_tmp_bill_totals tbt ON mdbp.patient_bill_id = tbt.patient_bill_id
SET mdbp.service_total_amount = tbt.service_total_amount,
    mdbp.insurance_rate       = tbt.insurance_rate,
    mdbp.patient_due          = tbt.patient_due,
    mdbp.insurance_due        = tbt.insurance_due,
    mdbp.bill_status          =
        CASE
            WHEN mdbp.amount_paid IS NULL OR mdbp.amount_paid = 0 THEN 'UNPAID'
            WHEN mdbp.amount_paid < tbt.patient_due AND mdbp.amount_paid > 0 THEN 'PARTIALLY PAID'
            ELSE 'PAID'
            END;

-- Clean up temporary table
DROP TEMPORARY TABLE IF EXISTS mamba_tmp_bill_totals;

-- $END