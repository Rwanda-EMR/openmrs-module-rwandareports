-- $BEGIN

-- Update the current insurance rate for this insurance
UPDATE mamba_dim_insurance ins
SET ins.current_insurance_rate = COALESCE(
    (SELECT rate
     FROM mamba_dim_insurance_rate ir
     WHERE ir.insurance_id = ins.insurance_id
      AND (ir.retire_date IS NULL OR ir.retire_date > NOW())
     ORDER BY ir.retire_date ASC
     LIMIT 1),
    0 -- Default value when no active rate is found (you can change this to any default value)
 )
WHERE id > 0;

-- Update flat_rate as well -- TODO: combine this update into one update with upper update
UPDATE mamba_dim_insurance ins
SET ins.current_insurance_rate_flat_fee = COALESCE(
    (SELECT flatFee
     FROM mamba_dim_insurance_rate ir
     WHERE ir.insurance_id = ins.insurance_id
      AND (ir.retire_date IS NULL OR ir.retire_date > NOW())
     ORDER BY ir.retire_date ASC
     LIMIT 1),
    0
 )
WHERE id > 0;

-- Update the current insurance rate and flat rate in a single query. This query should work but Test it first before replacing other 2
-- UPDATE mamba_dim_insurance ins
--   JOIN (
--     SELECT ir.insurance_id,
--         COALESCE(
--             (SELECT rate
--             FROM mamba_dim_insurance_rate ir_inner
--             WHERE ir_inner.insurance_id = ir.insurance_id
--              AND (ir_inner.retire_date IS NULL OR ir_inner.retire_date > NOW())
--             ORDER BY ir_inner.retire_date
--             LIMIT 1),
--             0
--        ) AS current_rate,
--         COALESCE(
--             (SELECT flatFee
--             FROM mamba_dim_insurance_rate ir_inner
--             WHERE ir_inner.insurance_id = ir.insurance_id
--              AND (ir_inner.retire_date IS NULL OR ir_inner.retire_date > NOW())
--             ORDER BY ir_inner.retire_date
--             LIMIT 1),
--             0
--        ) AS current_flat_fee
--     FROM mamba_dim_insurance_rate ir
--     GROUP BY ir.insurance_id
--  ) AS ir_combined
--   ON ins.insurance_id = ir_combined.insurance_id
-- SET ins.current_insurance_rate = ir_combined.current_rate,
--   ins.current_insurance_rate_flat_fee = ir_combined.current_flat_fee
-- WHERE ins.id > 0;

-- $END