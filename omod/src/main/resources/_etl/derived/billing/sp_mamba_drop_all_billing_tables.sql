DELIMITER //

-- Needed for now till incremental is full implemented. We will just drop all tables and recreate them

DROP PROCEDURE IF EXISTS sp_mamba_drop_all_billing_tables;

CREATE PROCEDURE sp_mamba_drop_all_billing_tables()

BEGIN

    DROP TABLE IF EXISTS mamba_dim_billing_report_columns;
    DROP TABLE IF EXISTS mamba_dim_admission;
    DROP TABLE IF EXISTS mamba_dim_beneficiary;
    DROP TABLE IF EXISTS mamba_dim_bill_payment;
    DROP TABLE IF EXISTS mamba_dim_billable_service;
    DROP TABLE IF EXISTS mamba_dim_consommation;
    DROP TABLE IF EXISTS mamba_dim_department;
    DROP TABLE IF EXISTS mamba_dim_facility_service_price;
    DROP TABLE IF EXISTS mamba_dim_global_bill;
    DROP TABLE IF EXISTS mamba_dim_hop_service;
    DROP TABLE IF EXISTS mamba_dim_insurance_rate;
    DROP TABLE IF EXISTS mamba_dim_insurance;
    DROP TABLE IF EXISTS mamba_dim_insurance_bill;
    DROP TABLE IF EXISTS mamba_dim_insurance_policy;
    DROP TABLE IF EXISTS mamba_dim_paid_service_bill;
    DROP TABLE IF EXISTS mamba_dim_patient_bill;
    DROP TABLE IF EXISTS mamba_dim_patient_service_bill;
    DROP TABLE IF EXISTS mamba_dim_service_category;
    DROP TABLE IF EXISTS mamba_dim_third_party_bill;
    DROP TABLE IF EXISTS mamba_dim_third_party;
    DROP TABLE IF EXISTS mamba_dim_paid_service_bill_refund;
    DROP TABLE IF EXISTS mamba_dim_cash_payment;
    DROP TABLE IF EXISTS mamba_dim_deposit_payment;
    DROP TABLE IF EXISTS mamba_dim_patient_account;
    DROP TABLE IF EXISTS mamba_dim_payment_refund;
    DROP TABLE IF EXISTS mamba_dim_recovery;
    DROP TABLE IF EXISTS mamba_dim_transaction;

    DROP TABLE IF EXISTS mamba_fact_patient_service_bill;
    DROP TABLE IF EXISTS mamba_fact_patient_service_bill_flat;
    DROP TABLE IF EXISTS mamba_fact_cashier_report;
    DROP TABLE IF EXISTS mamba_fact_cashier_report_flat;
    DROP TABLE IF EXISTS mamba_fact_service_revenue_report;
    DROP TABLE IF EXISTS mamba_fact_consommation_report;
    DROP TABLE IF EXISTS mamba_fact_clinical_detailed_report;

END //

DELIMITER ;