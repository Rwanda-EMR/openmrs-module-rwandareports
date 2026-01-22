DELIMITER //

DROP PROCEDURE IF EXISTS sp_mamba_data_processing_etl;

CREATE PROCEDURE sp_mamba_data_processing_etl(IN etl_incremental_mode INT)

BEGIN
  -- Base folder SPs (Flat tables from JSON configs - must run BEFORE derived)
  -- CALL sp_mamba_flat_encounter_vital_signs();
  -- CALL sp_mamba_flat_encounter_diagnosis();

  -- Needed for now till incremental is full implemented. We will just drop all tables and recreate them
  CALL sp_mamba_drop_all_billing_tables();
  -- Call the ETL process
  CALL sp_mamba_data_processing_derived_billing();

END //

DELIMITER ;