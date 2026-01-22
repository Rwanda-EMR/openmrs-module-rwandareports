-- $BEGIN
CALL sp_mamba_dim_patient_account_create();
CALL sp_mamba_dim_patient_account_insert();
CALL sp_mamba_dim_patient_account_update();
-- $END