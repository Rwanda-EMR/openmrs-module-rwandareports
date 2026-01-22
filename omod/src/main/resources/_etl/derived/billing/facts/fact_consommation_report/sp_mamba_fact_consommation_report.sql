-- $BEGIN
CALL sp_mamba_fact_consommation_report_create();
CALL sp_mamba_fact_consommation_report_insert();
CALL sp_mamba_fact_consommation_report_update();
-- $END