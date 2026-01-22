-- $BEGIN
CALL sp_mamba_dim_deposit_payment_create();
CALL sp_mamba_dim_deposit_payment_insert();
CALL sp_mamba_dim_deposit_payment_update();
-- $END