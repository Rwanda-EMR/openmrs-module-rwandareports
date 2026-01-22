-- $BEGIN
  CALL sp_mamba_fact_cashier_report_flat_create();
  CALL sp_mamba_fact_cashier_report_flat_insert();
  CALL sp_mamba_fact_cashier_report_flat_update();
-- $END