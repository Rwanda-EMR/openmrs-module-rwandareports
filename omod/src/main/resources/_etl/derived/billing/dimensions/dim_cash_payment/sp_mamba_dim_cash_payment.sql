-- $BEGIN
CALL sp_mamba_dim_cash_payment_create();
CALL sp_mamba_dim_cash_payment_insert();
CALL sp_mamba_dim_cash_payment_update();
-- $END